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

	myx.common lib/fetchStdout https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.1/wxWidgets-3.1.1.tar.bz2 | tar -xjvf - -C "$tempFolder" 

