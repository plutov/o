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
		remote=${remote/git\@/}
		remote=${remote/ssh\:\/\//http:\/\/}
		domain=$(echo "$remote" | awk -F/ '{print $3}')
		if [[ $domain == *"stash"* ]]; then
			remote=${remote/$domain/$domain\/scm}
		fi

		# Add branch path if not master
		branch=$(get_branch)
		if [[ $branch != "master" ]]; then
			path=$(get_branch_path $domain)
			if [[ $path != "" ]]; then
				remote="$remote$path$branch"
			fi
		fi

		echo $remote
	fi
}

# Get current branch
get_branch() {
	echo $(git rev-parse --abbrev-ref HEAD)
}

# Get URL path to branch page
get_branch_path() {
	path=""
	if [[ $1 == *"github.com"* || $1 == *"gitlab.com"* ]]; then
		path="/tree/"
	fi
	if [[ $1 == *"bitbucket.org"* ]]; then
		path="/src?at="
	fi

	echo $path
}

# Get program to open browser
get_open_program() {
	case $(uname -s) in
		Darwin)  program='open';;
		MINGW*)  program='start';;
		MSYS*)   program='start';;
		CYGWIN*) program='cygstart';;
		*)       program='xdg-open';;
	esac

	echo $program
}

url=$(get_url)
if [ "" != "$url" ]; then
	$(get_open_program) $url
fi
