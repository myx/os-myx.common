# FetchStdout ( myx.common lib/fetchStdout )

Fetch URL content to stdout with optional cache.

Supported OS: Linux, FreeBSD, Darwin.

Arguments:

    <URL>

                The URL of resource to fetch. (Example: https://githubuserconte..../data.tbz)

                Supported protocols:

					- https:// - fetch http url
					- http:// - will also work, but will ignore cache parameters
					- sftp:// - fetch resource by sftp protocol
					- ssh:// - fench file from remote host filesystem

                Note: This utility for fetching git repos, check: `git/clonePull` command.

Options:

    --local-cache <directory-path>

                Use given directory as a root of (read-only, pre-cooked) cache. The path to
                each resource in cache directory is URL with protocol preffix (e.g. https://)
                cut.

    --do-cache

                Allows caching of fetched resources to a (read-write, live) cache directory.
				The path to each resource in cache directory is URL with protocol preffix (e.g. https://) removed.

Environment:

    ENV_FETCH_LOCAL_CACHE
                if --local-cache option is not specified, the value of this environment variable
                is used as default. If unset - no cache is used to fetch resources.

Examples:

```sh
  myx.common lib/fetchStdout https://example.com/index.html
```

```sh
  myx.common lib/fetchStdout --local-cache /var/cache/myx.fetch --check-cache https://example.com/index.html
```

```sh
  myx.common lib/fetchStdout --do-cache --local-cache /var/cache/myx.fetch https://example.com/index.html
```
