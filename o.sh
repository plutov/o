#!/bin/bash
#
# Author: Alex Pliutau http://pliutau.com

set -e

get_url() {
	remote=$(git remote get-url origin)
	if [ "" != "$remote" ]; then
		remote=${remote/git\@github\.com\:/https://github.com/}
		remote=${remote/git\@bitbucket\.org\:/https://bitbucket.org/}
		remote=${remote/git\@gitlab\.com\:/https://gitlab.com/}
		remote=${remote/\.git//}
		echo $remote
	fi
}

url=$(get_url)
if [ "" != "$url" ]; then
	open $url
fi
