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
		remote=${remote/\.git/}
		remote=${remote/\.git/}
		remote=${remote/git\@/}
		remote=${remote/ssh\:\/\//http:\/\/}
		domain=$(echo "$remote" | awk -F/ '{print $3}')
		if [[ $domain == *"stash"* ]]; then
			remote=${remote/$domain/$domain\/scm}
		fi
		echo $remote
	fi
}

url=$(get_url)
echo $url
if [ "" != "$url" ]; then
	open $url
fi
