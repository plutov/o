#!/usr/bin/env bash
#
# Author: Alex Pliutau http://pliutau.com

set -e

remote=${1:-"origin"}

# Get repository URL based on git remote
get_url() {
	url=$(git remote get-url $remote)
	if [ "" != "$url" ]; then
		url=${url/git\@github\.com\:/https://github.com/}
		url=${url/git\@bitbucket\.org\:/https://bitbucket.org/}
		url=${url/git\@gitlab\.com\:/https://gitlab.com/}
		url=${url/\.git/}
		url=${url/git\@/}
		url=${url/ssh\:\/\//http:\/\/}
		domain=$(echo "$url" | awk -F/ '{print $3}')
		if [[ $domain == *"stash"* && $url != *$domain"/scm/"* ]]; then
			url=${url/$domain/$domain\/scm}
		fi

		# Add branch path if not master
		branch=$(get_branch)
		if [[ $branch != "master" ]]; then
			path=$(get_branch_path $domain)
			if [[ $path != "" && $domain != *"stash"* ]]; then
				url="$url$path$branch"
			fi
			if [[ $domain == *"stash"* ]]; then
				old="/scm/spp/"
				new="/projects/spp/repos/"
				url="${url/$old/$new}"
				url="$url$path$(rawurlencode $branch)"
				url="${url//http:\/\/*@stash/http://stash}"
			fi
		fi

		echo $url
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

	if [[ $1 == *"stash"* ]]; then
		path="/browse?at="$(rawurlencode refs/heads/)
	fi

	echo $path
}
# Encode url.
rawurlencode() {
	local string="${1}"
	local strlen=${#string}
	local encoded=""
	local pos c o

	for (( pos=0 ; pos<strlen ; pos++ )); do
		c=${string:$pos:1}
		case "$c" in
			[-_.~a-zA-Z0-9] ) o="${c}" ;;
			* )	printf -v o '%%%02x' "'$c"
		esac
		encoded+="${o}"
	done

	echo "${encoded}"
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
