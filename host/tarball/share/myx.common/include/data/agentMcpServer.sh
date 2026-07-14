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
# Known limitations (accepted, not bugs):
#  - Requests are handled synchronously/sequentially; a long-running
#    myx_common_run call blocks the next request, including a would-be
#    notifications/cancelled for it.
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

AgentMcpSendResult(){
	local id="$1" resultJson="$2"
	[ -n "$id" ] || return 0
	printf '{"jsonrpc":"2.0","id":%s,"result":%s}\n' "$id" "$resultJson"
}

AgentMcpSendError(){
	local id="$1" code="$2" message="$3" escMsg
	[ -n "$id" ] || return 0
	escMsg="$(printf '%s' "$message" | AgentMcpJsonEscape)"
	printf '{"jsonrpc":"2.0","id":%s,"error":{"code":%s,"message":"%s"}}\n' "$id" "$code" "$escMsg"
}

AgentMcpHandleToolsCall(){
	local reqDir="$1" id="$2"
	local toolName cmd unameArg argsCount i contentText exitCode isError escText resultJson

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
			set --
			i=0
			while [ "$i" -lt "$argsCount" ]; do
				set -- "$@" "$(cat "$reqDir/arg_args_$i" 2>/dev/null || true)"
				i=$((i + 1))
			done
			if [ -f "$reqDir/arg_stdin" ]; then
				contentText="$("$MYX_COMMON_BIN" "$cmd" "$@" < "$reqDir/arg_stdin" 2>&1)"
			else
				contentText="$("$MYX_COMMON_BIN" "$cmd" "$@" < /dev/null 2>&1)"
			fi
			exitCode=$?
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

AgentMcpHandleRequest(){
	local reqDir="$1" method hasId id

	method="$(cat "$reqDir/method" 2>/dev/null || true)"
	hasId="$(cat "$reqDir/has_id" 2>/dev/null || true)"
	id=""
	[ -z "$hasId" ] || id="$(cat "$reqDir/id" 2>/dev/null || true)"

	case "$method" in
		initialize)
			AgentMcpSendResult "$id" '{"protocolVersion":"2025-06-18","capabilities":{"tools":{}},"serverInfo":{"name":"myx.common","version":"1.0.0"}}'
		;;
		notifications/initialized|notifications/cancelled)
			: # notifications - no response
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

	local reqBase reqDir LINE
	reqBase="$(mktemp -d "${TMPDIR:-/tmp}/myx.common.agentMcp.XXXXXX")" || return 1
	trap 'rm -rf "$reqBase"' EXIT INT TERM

	while IFS= read -r LINE || [ -n "$LINE" ]; do
		[ -n "$LINE" ] || continue
		reqDir="$reqBase/req"
		rm -rf "$reqDir"
		AgentMcpJsonParseRequest "$LINE" "$reqDir"
		AgentMcpHandleRequest "$reqDir"
	done

	rm -rf "$reqBase"
	trap - EXIT INT TERM
}

# NOTE: deliberately no `set -e` here - this is a long-running loop that
# must survive individual failing tool invocations, not abort the whole
# server process on the first non-zero exit status.
AgentMcpServerLoop
