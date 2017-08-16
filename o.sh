#!/bin/bash
#
# Author: Alex Pliutau http://pliutau.com

set -e

# Get repository URL based on git remote
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

		# Add branch path if not master
		branch=$(get_branch)
		if [[ $branch != "master" ]]; then
			if [[ $domain == *"github.com"* || $domain == *"gitlab.com"* ]]; then
				remote="$remote/tree/$branch"
			fi
		fi

		echo $remote
	fi
}

# Get current branch
get_branch() {
	echo $(git rev-parse --abbrev-ref HEAD)
}

url=$(get_url)
if [ "" != "$url" ]; then
	open $url
fi
