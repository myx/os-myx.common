#!/usr/bin/env sh

##### !!! This script is universal for FreeBSD, Darwin, Ubuntu. !!! #####
#
# SHELL-NOTE: Long-running MCP (Model Context Protocol) stdio server. This is
# the myx.common MCP *integration*, not a public/completable myx.common
# command - it lives here (not under bin/) and is invoked by its own direct
# path, so it never shows up in `myx.common help`/completion and needs no
# help pair. Registered via `myx.common setup/agentMcp`, which writes this
# file's absolute path straight into the MCP host's config; launched as a
# subprocess by that host (e.g. Claude Code) - not for interactive human use.
#
# Speaks JSON-RPC 2.0 over stdin/stdout, newline-delimited, hand-rolled (no
# jq/python dependency) using the sibling resources in this directory
# (agentMcpJsonEscape.awk, agentMcpJsonParseRequest.awk, agentMcpTools.json).
#
# Exposes two tools to the connected agent:
#   myx_common_help - discover commands (wraps `myx.common help`)
#   myx_common_run  - execute a command and return stdout/stderr/exit status
#
# Also exposes a `resources` capability (resources/list, resources/read) so
# a host can read a command's full help manual without spending a tool
# call: one resource per shipped $MYXROOT/help/**/*.help.md file, addressed
# by URI `myx-common://help/<category>/<name>` (mirrors the command's own
# `category/name` addressing, minus the `.help.md` suffix). NOTE: this is
# `$MYXROOT/help/*.help.md` only - the repo's own README.md is NOT part of
# the installed tree (`host/tarball/share/myx.common/` has no README.md),
# so it can't be exposed this way without also changing what ships in the
# install tarball, which wasn't done here.
#
# myx_common_run runs in the background (see AgentMcpRunMyxCommonRunAsync)
# so the request loop stays free to read/act on the next line - a
# notifications/cancelled for the in-flight call (see
# AgentMcpHandleCancelled), a ping, another fast method - instead of
# blocking for the whole duration. Single-in-flight by design: only one
# myx_common_run can be running at a time; a second call while one is
# already running gets an immediate "busy" error rather than being queued
# or run in parallel.
#
# Known limitations (accepted, not bugs):
#  - Cancellation and the "busy" check are PID-based (same TERM-then-KILL
#    pattern as the timeout feature below), so share its grandchild /
#    PID-reuse caveats.
#  - Response lines (synchronous methods and the async myx_common_run
#    result alike) are serialized through a tiny mkdir-based mutex
#    (AgentMcpStdoutLock/Unlock) so two writers can never interleave
#    partial JSON-RPC lines on stdout - now that more than one write can
#    genuinely be in flight at once, this isn't optional.
#  - Background myx_common_run jobs are not explicitly reaped (`wait`ed)
#    after they finish - POSIX sh has no portable non-blocking wait, and a
#    blocking one would reintroduce exactly the stall this design avoids.
#    They become zombie processes until this server process itself exits
#    (which reaps all its children) - typically once per MCP host session,
#    so accepted as bounded/cheap rather than engineered away.
#  - An optional `timeout` (seconds) arg still bounds an individual
#    myx_common_run call itself (see AgentMcpRunWithTimeout) - independent
#    of, and composable with, the above.
#  - Timeout enforcement is PID-based (TERM then KILL on the directly
#    backgrounded command process), not process-group-based: a grandchild
#    the command itself forks (e.g. a `curl` it shells out to) is not
#    guaranteed to die with it and may linger detached. No GNU `timeout(1)`
#    dependency is assumed, since it's not guaranteed present on a bare
#    FreeBSD/Darwin install.
#  - A trailing newline (or its absence) at the very end of a command's
#    output is not distinguishable after capture; harmless for text results.
#  - NUL bytes in command output are not supported (shared sh/awk limitation).

if [ -z "$MYXROOT" ]; then
	case "$0" in
	*/include/data/agentMcpServer.sh) MYXROOT="${0%/include/data/agentMcpServer.sh}" ;;
	*) MYXROOT="/usr/local/share/myx.common" ;;
	esac
	export MYXROOT MYXUNIX=${MYXUNIX:-$(uname -s)}
fi

# Tool definitions are static (no dynamic values), so they live in their
# own real .json file (agentMcpTools.json, sibling to the awk resources
# below) rather than an embedded shell literal - editable/diffable/lintable
# as actual JSON. The wire format is newline-delimited JSON-RPC (see header
# comment above), so the file's own newlines must be stripped before use -
# JSON itself doesn't care about the whitespace either way.
AGENT_MCP_TOOLS_JSON="$(tr -d '\n' < "$MYXROOT/include/data/agentMcpTools.json")"

AgentMcpJsonEscape(){
	LC_ALL=C awk -f "$MYXROOT/include/data/agentMcpJsonEscape.awk"
}

AgentMcpJsonParseRequest(){
	local line="$1" outDir="$2"
	mkdir -p "$outDir" || return 1
	printf '%s\n' "$line" | LC_ALL=C awk -v outDir="$outDir" -f "$MYXROOT/include/data/agentMcpJsonParseRequest.awk"
}

# Tiny mkdir-based mutex around stdout writes - mkdir is atomic on every
# POSIX filesystem, so this is portable with no flock/lockf dependency
# (flock isn't guaranteed present on bare FreeBSD/Darwin). Needed because
# AgentMcpRunMyxCommonRunAsync's background job and the main loop's own
# synchronous responses can now genuinely write to stdout at the same
# moment; without this, two response lines could interleave mid-line and
# break JSON-RPC framing for both. Hold times here are always a single
# printf call (microseconds), so a tight spin is fine - the sleep fallback
# only guards against something unexpectedly stuck.
AgentMcpStdoutLock(){
	local tries=0
	[ -n "$AGENT_MCP_STDOUT_LOCK" ] || return 0
	while ! mkdir "$AGENT_MCP_STDOUT_LOCK" 2>/dev/null; do
		tries=$((tries + 1))
		if [ "$tries" -ge 500 ]; then
			sleep 1
			tries=0
		fi
	done
}

AgentMcpStdoutUnlock(){
	[ -n "$AGENT_MCP_STDOUT_LOCK" ] || return 0
	rmdir "$AGENT_MCP_STDOUT_LOCK" 2>/dev/null
}

AgentMcpSendResult(){
	local id="$1" resultJson="$2"
	[ -n "$id" ] || return 0
	AgentMcpStdoutLock
	printf '{"jsonrpc":"2.0","id":%s,"result":%s}\n' "$id" "$resultJson"
	AgentMcpStdoutUnlock
}

AgentMcpSendError(){
	local id="$1" code="$2" message="$3" escMsg
	[ -n "$id" ] || return 0
	escMsg="$(printf '%s' "$message" | AgentMcpJsonEscape)"
	AgentMcpStdoutLock
	printf '{"jsonrpc":"2.0","id":%s,"error":{"code":%s,"message":"%s"}}\n' "$id" "$code" "$escMsg"
	AgentMcpStdoutUnlock
}

# Runs "env" "$@" (stdin from reqDir/arg_stdin if present, else
# /dev/null) with a hard wall-clock timeout. $@ is expected to already be
# the fully-assembled [envpair1 envpair2 ... MYX_COMMON_BIN cmd arg1 arg2
# ...] list (see AgentMcpHandleToolsCall's myx_common_run case) - `env`
# with zero leading NAME=value tokens just execs the target directly, so
# routing every call through it (even with no env vars set) keeps this
# function simple with no branching on whether env vars were requested.
# Portable POSIX background-job + watcher pattern - no GNU `timeout(1)`
# dependency (not guaranteed present on a bare FreeBSD/Darwin install).
# Backgrounds the invocation directly (not wrapped in a `( ... )` subshell)
# so "$!" is the real, killable process - `env` execs into the target
# rather than forking, so its PID stays the target's PID. Prints captured
# stdout+stderr to stdout and returns the command's exit status, or 124 if
# the watcher had to kill it. PID-based, so is subject to the grandchild /
# PID-reuse caveats noted in this file's header comment.
AgentMcpRunWithTimeout(){
	local reqDir="$1" timeoutSecs="$2" outFile killedFile cmdPid watcherPid exitCode
	shift 2
	outFile="$reqDir/timeout_out"
	killedFile="$reqDir/timeout_killed"
	rm -f "$outFile" "$killedFile"

	if [ -f "$reqDir/arg_stdin" ]; then
		env "$@" < "$reqDir/arg_stdin" > "$outFile" 2>&1 &
	else
		env "$@" < /dev/null > "$outFile" 2>&1 &
	fi
	cmdPid=$!

	(
		waited=0
		while [ "$waited" -lt "$timeoutSecs" ]; do
			kill -0 "$cmdPid" 2>/dev/null || exit 0
			sleep 1
			waited=$((waited + 1))
		done
		if kill -0 "$cmdPid" 2>/dev/null; then
			: > "$killedFile"
			kill -TERM "$cmdPid" 2>/dev/null
			sleep 1
			kill -0 "$cmdPid" 2>/dev/null && kill -KILL "$cmdPid" 2>/dev/null
		fi
	) &
	watcherPid=$!

	wait "$cmdPid" 2>/dev/null
	exitCode=$?

	kill "$watcherPid" 2>/dev/null
	wait "$watcherPid" 2>/dev/null

	cat "$outFile" 2>/dev/null
	if [ -f "$killedFile" ]; then
		printf '\n[timed out after %ss, process killed]\n' "$timeoutSecs"
		exitCode=124
	fi
	rm -f "$outFile" "$killedFile"
	return "$exitCode"
}

# Runs myx_common_run entirely in the background so the main request loop
# stays free to read the next line - a notifications/cancelled for this
# same request (see AgentMcpHandleCancelled), a ping, another fast method
# - instead of blocking for the whole duration. $AGENT_MCP_REQ_BASE/
# inflight_pid + inflight_id track the one job this design allows to be
# running at a time (see the busy-check in AgentMcpHandleToolsCall's
# myx_common_run case).
AgentMcpRunMyxCommonRunAsync(){
	local asyncReqDir="$1" id="$2"
	shift 2
	# $@ = [envpair... MYX_COMMON_BIN cmd arg...], assembled by the caller.

	(
		local contentText exitCode isError escText resultJson timeoutArg

		timeoutArg="$(cat "$asyncReqDir/arg_timeout" 2>/dev/null || true)"
		case "$timeoutArg" in ''|*[!0-9]*) timeoutArg="" ;; esac
		if [ -n "$timeoutArg" ]; then
			contentText="$(AgentMcpRunWithTimeout "$asyncReqDir" "$timeoutArg" "$@")"
			exitCode=$?
		elif [ -f "$asyncReqDir/arg_stdin" ]; then
			contentText="$(env "$@" < "$asyncReqDir/arg_stdin" 2>&1)"
			exitCode=$?
		else
			contentText="$(env "$@" < /dev/null 2>&1)"
			exitCode=$?
		fi

		isError=false
		if [ "$exitCode" -ne 0 ]; then
			isError=true
			contentText="$contentText
[exit code: $exitCode]"
		fi
		[ -n "$contentText" ] || contentText="(no output)"

		escText="$(printf '%s' "$contentText" | AgentMcpJsonEscape)"
		resultJson="$(printf '{"content":[{"type":"text","text":"%s"}],"isError":%s}' "$escText" "$isError")"
		AgentMcpSendResult "$id" "$resultJson"

		# Only clear tracking if this job is still the one tracked - a
		# notifications/cancelled that raced in concurrently already cleared
		# it (and already killed this job), so this send raced past a TERM
		# but still completed; harmless, the client already stopped
		# expecting a response for a cancelled id and will just ignore it.
		if [ "$(cat "$AGENT_MCP_REQ_BASE/inflight_id" 2>/dev/null || true)" = "$id" ]; then
			rm -f "$AGENT_MCP_REQ_BASE/inflight_pid" "$AGENT_MCP_REQ_BASE/inflight_id"
		fi
		rm -rf "$asyncReqDir"
	) &

	printf '%s' "$!" > "$AGENT_MCP_REQ_BASE/inflight_pid"
	printf '%s' "$id" > "$AGENT_MCP_REQ_BASE/inflight_id"
}

# Handles notifications/cancelled for the one possible in-flight
# myx_common_run job (single-in-flight by design - see
# AgentMcpRunMyxCommonRunAsync). A notification has no id and expects no
# response either way; this only does something if the cancelled
# requestId matches the currently-tracked in-flight job. TERM is sent
# immediately and tracking is cleared right away (so a new myx_common_run
# isn't needlessly held "busy" waiting for the old one to actually die);
# the KILL escalation runs in its own detached background check so this
# function - and the main loop right after it - never blocks on it.
AgentMcpHandleCancelled(){
	local cancelReqDir="$1" cancelId inflightId inflightPid

	cancelId="$(cat "$cancelReqDir/cancel_request_id" 2>/dev/null || true)"
	[ -n "$cancelId" ] || return 0

	inflightId="$(cat "$AGENT_MCP_REQ_BASE/inflight_id" 2>/dev/null || true)"
	inflightPid="$(cat "$AGENT_MCP_REQ_BASE/inflight_pid" 2>/dev/null || true)"
	[ -n "$inflightPid" ] && [ "$cancelId" = "$inflightId" ] || return 0

	rm -f "$AGENT_MCP_REQ_BASE/inflight_pid" "$AGENT_MCP_REQ_BASE/inflight_id"
	kill -TERM "$inflightPid" 2>/dev/null
	(
		sleep 1
		kill -0 "$inflightPid" 2>/dev/null && kill -KILL "$inflightPid" 2>/dev/null
	) &
}

AgentMcpHandleToolsCall(){
	local reqDir="$1" id="$2"
	local toolName cmd unameArg argsCount envCount i contentText exitCode isError escText resultJson envName envVal asyncReqDir

	toolName="$(cat "$reqDir/tool_name" 2>/dev/null || true)"

	case "$toolName" in
		myx_common_help)
			cmd="$(cat "$reqDir/arg_command" 2>/dev/null || true)"
			unameArg="$(cat "$reqDir/arg_uname" 2>/dev/null || true)"
			set --
			[ -z "$unameArg" ] || set -- --uname "$unameArg"
			if [ -n "$cmd" ]; then
				contentText="$("$MYX_COMMON_BIN" help "$@" "$cmd" 2>&1)"
			else
				contentText="$("$MYX_COMMON_BIN" help "$@" 2>&1)"
			fi
			# NOTE: `myx.common help ...` conventionally exits 1 even when it
			# successfully displayed help text - that's not a real failure,
			# so this tool never reports isError based on exit status.
			exitCode=0
		;;
		myx_common_run)
			cmd="$(cat "$reqDir/arg_command" 2>/dev/null || true)"
			if [ -z "$cmd" ]; then
				AgentMcpSendError "$id" -32602 "myx_common_run requires a non-empty 'command' argument"
				return 0
			fi
			argsCount="$(cat "$reqDir/arg_args_count" 2>/dev/null || true)"
			case "$argsCount" in ''|*[!0-9]*) argsCount=0 ;; esac
			envCount="$(cat "$reqDir/arg_env_count" 2>/dev/null || true)"
			case "$envCount" in ''|*[!0-9]*) envCount=0 ;; esac

			# $@ is assembled once as [envpair1 ... MYX_COMMON_BIN cmd arg1 ...] -
			# see AgentMcpRunWithTimeout's header comment for why leading it with
			# NAME=value tokens and always invoking through `env` is safe/simple.
			set --
			i=0
			while [ "$i" -lt "$envCount" ]; do
				envName="$(cat "$reqDir/arg_env_name_$i" 2>/dev/null || true)"
				envVal="$(cat "$reqDir/arg_env_val_$i" 2>/dev/null || true)"
				[ -z "$envName" ] || set -- "$@" "$envName=$envVal"
				i=$((i + 1))
			done
			set -- "$@" "$MYX_COMMON_BIN" "$cmd"
			i=0
			while [ "$i" -lt "$argsCount" ]; do
				set -- "$@" "$(cat "$reqDir/arg_args_$i" 2>/dev/null || true)"
				i=$((i + 1))
			done

			# Single myx_common_run in flight at a time (see
			# AgentMcpRunMyxCommonRunAsync's header comment) - reject a second
			# concurrent call rather than queueing or running it in parallel, so
			# cancellation/tracking never has to reason about more than one job.
			if [ -f "$AGENT_MCP_REQ_BASE/inflight_pid" ] && kill -0 "$(cat "$AGENT_MCP_REQ_BASE/inflight_pid" 2>/dev/null)" 2>/dev/null; then
				AgentMcpSendError "$id" -32000 "Another myx_common_run is already in progress; wait for it to finish or send notifications/cancelled for it first"
				return 0
			fi

			# reqDir is the loop's one shared scratch directory, reused (rm
			# -rf'd) on the very next line read - moving it to a private,
			# uniquely-named directory before backgrounding is what makes it
			# safe for the async job to keep reading it after this function
			# (and this loop iteration) returns.
			AGENT_MCP_ASYNC_SEQ=$((AGENT_MCP_ASYNC_SEQ + 1))
			asyncReqDir="$AGENT_MCP_REQ_BASE/async.$AGENT_MCP_ASYNC_SEQ"
			rm -rf "$asyncReqDir"
			mv "$reqDir" "$asyncReqDir"
			AgentMcpRunMyxCommonRunAsync "$asyncReqDir" "$id" "$@"
			return 0
		;;
		*)
			AgentMcpSendError "$id" -32602 "Unknown tool: $toolName"
			return 0
		;;
	esac

	isError=false
	if [ "$exitCode" -ne 0 ]; then
		isError=true
		contentText="$contentText
[exit code: $exitCode]"
	fi
	[ -n "$contentText" ] || contentText="(no output)"

	escText="$(printf '%s' "$contentText" | AgentMcpJsonEscape)"
	resultJson="$(printf '{"content":[{"type":"text","text":"%s"}],"isError":%s}' "$escText" "$isError")"
	AgentMcpSendResult "$id" "$resultJson"
}

# Lists every $MYXROOT/help/**/*.help.md file as an MCP resource. URI is
# `myx-common://help/<relpath>` where <relpath> mirrors the command's own
# category/name (the file minus its $MYXROOT/help/ prefix and .help.md
# suffix) - e.g. help/git/clonePull.help.md -> myx-common://help/git/clonePull.
AgentMcpHandleResourcesList(){
	local id="$1" helpDir fileList file relpath uri escName escUri entries first

	helpDir="$MYXROOT/help"
	fileList="$(find "$helpDir" -type f -name '*.help.md' 2>/dev/null | sort)"
	entries=""
	first=1
	while IFS= read -r file; do
		[ -n "$file" ] || continue
		relpath="${file#"$helpDir"/}"
		relpath="${relpath%.help.md}"
		uri="myx-common://help/$relpath"
		escName="$(printf '%s' "$relpath" | AgentMcpJsonEscape)"
		escUri="$(printf '%s' "$uri" | AgentMcpJsonEscape)"
		[ "$first" = 1 ] || entries="$entries,"
		entries="$entries{\"uri\":\"$escUri\",\"name\":\"$escName\",\"description\":\"myx.common help manual: $escName\",\"mimeType\":\"text/markdown\"}"
		first=0
	done <<-AGENTMCPLISTEOF
$fileList
AGENTMCPLISTEOF

	AgentMcpSendResult "$id" "{\"resources\":[$entries]}"
}

# Reads back one resource listed by AgentMcpHandleResourcesList. Re-derives
# and validates the file path from the URI rather than trusting it verbatim
# - relpath must stay a plain relative path under $MYXROOT/help (no "..",
# no leading "/", identifier/slash/dot/dash characters only) since the URI
# is caller-supplied and a well-behaved client isn't the only possible one.
AgentMcpHandleResourcesRead(){
	local reqDir="$1" id="$2" uri relpath filePath escUri escText

	uri="$(cat "$reqDir/uri" 2>/dev/null || true)"
	case "$uri" in
		myx-common://help/*) relpath="${uri#myx-common://help/}" ;;
		*) AgentMcpSendError "$id" -32602 "Unknown resource URI: $uri"; return 0 ;;
	esac
	case "$relpath" in
		''|*..*|/*|*[!A-Za-z0-9_./-]*)
			AgentMcpSendError "$id" -32602 "Invalid resource URI: $uri"
			return 0
		;;
	esac

	filePath="$MYXROOT/help/$relpath.help.md"
	if [ ! -f "$filePath" ]; then
		AgentMcpSendError "$id" -32602 "Resource not found: $uri"
		return 0
	fi

	escUri="$(printf '%s' "$uri" | AgentMcpJsonEscape)"
	escText="$(AgentMcpJsonEscape < "$filePath")"
	AgentMcpSendResult "$id" "{\"contents\":[{\"uri\":\"$escUri\",\"mimeType\":\"text/markdown\",\"text\":\"$escText\"}]}"
}

AgentMcpHandleRequest(){
	local reqDir="$1" method hasId id

	method="$(cat "$reqDir/method" 2>/dev/null || true)"
	hasId="$(cat "$reqDir/has_id" 2>/dev/null || true)"
	id=""
	[ -z "$hasId" ] || id="$(cat "$reqDir/id" 2>/dev/null || true)"

	case "$method" in
		initialize)
			AgentMcpSendResult "$id" '{"protocolVersion":"2025-06-18","capabilities":{"tools":{},"resources":{}},"serverInfo":{"name":"myx.common","version":"1.0.0"}}'
		;;
		notifications/initialized)
			: # notification - no response
		;;
		notifications/cancelled)
			AgentMcpHandleCancelled "$reqDir"
		;;
		ping)
			AgentMcpSendResult "$id" '{}'
		;;
		tools/list)
			AgentMcpSendResult "$id" "{\"tools\":$AGENT_MCP_TOOLS_JSON}"
		;;
		tools/call)
			AgentMcpHandleToolsCall "$reqDir" "$id"
		;;
		resources/list)
			AgentMcpHandleResourcesList "$id"
		;;
		resources/read)
			AgentMcpHandleResourcesRead "$reqDir" "$id"
		;;
		"")
			AgentMcpSendError "$id" -32700 "Parse error"
		;;
		*)
			AgentMcpSendError "$id" -32601 "Method not found: $method"
		;;
	esac
}

AgentMcpServerLoop(){
	MYX_COMMON_BIN="${MYXROOT%/share/myx.common}/bin/myx.common"
	[ -x "$MYX_COMMON_BIN" ] || { echo "⛔ ERROR: AgentMcpServerLoop: can't resolve myx.common executable from MYXROOT ($MYXROOT)" >&2; return 1; }

	local reqDir LINE
	AGENT_MCP_REQ_BASE="$(mktemp -d "${TMPDIR:-/tmp}/myx.common.agentMcp.XXXXXX")" || return 1
	AGENT_MCP_STDOUT_LOCK="$AGENT_MCP_REQ_BASE/stdout.lock"
	AGENT_MCP_ASYNC_SEQ=0
	trap 'rm -rf "$AGENT_MCP_REQ_BASE"' EXIT INT TERM

	while IFS= read -r LINE || [ -n "$LINE" ]; do
		[ -n "$LINE" ] || continue
		reqDir="$AGENT_MCP_REQ_BASE/req"
		rm -rf "$reqDir"
		AgentMcpJsonParseRequest "$LINE" "$reqDir"
		AgentMcpHandleRequest "$reqDir"
	done

	rm -rf "$AGENT_MCP_REQ_BASE"
	trap - EXIT INT TERM
}

# NOTE: deliberately no `set -e` here - this is a long-running loop that
# must survive individual failing tool invocations, not abort the whole
# server process on the first non-zero exit status.
AgentMcpServerLoop
