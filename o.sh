#!/usr/bin/env bash
#
# Author: Alex Pliutau http://pliutau.com

set -e

remote=${1:-"origin"}

# Get repository URL based on git remote
get_url() {
	url=$(git remote get-url $remote)
	if [ "" != "$url" ]; then
		# Replace common Git host URLs
		url=${url/git\@github\.com\:/https://github.com/}
		url=${url/git\@bitbucket\.org\:/https://bitbucket.org/}
		url=${url/git\@gitlab\.com\:/https://gitlab.com/}

		# Remove .git appendix
		url=${url/\.git/}

		# Remove git username
		url=${url/git\@}

		# Replace first colon with slash (ignore SSH, since its a port then)
		if [[ $url != "https://"* ]] && [[ $url != "http://"* ]] && [[ $url != "ssh://"* ]]; then
			url=${url/:/\/}
		fi
		url=${url/ssh\:\/\//http:\/\/}

		# Append protocol if it's missing until now
		if [[ $url != "https://"* ]] && [[ $url != "http://"* ]]; then
			url="http://"$url
		fi

		# Simple domain parser - everything between second and third slash
		domain=$(echo "$url" | awk -F/ '{print $3}')
		if [[ $domain == *"stash"* && $url != *$domain"/scm/"* ]]; then
			url=${url/$domain/$domain\/scm}
		fi

		# Remove username from URL
		if [[ $domain == *"stash"* ]]; then
			url=${url/http:\/\/*@stash/http:\/\/stash}
		fi

		# Add branch path if not master
		branch=$(get_branch)
		if [[ $branch != "master" ]]; then
			path=$(get_branch_path $domain)
			if [[ $path != "" ]]; then
				url="$url$path$branch"
			fi
		fi

		# Append protocol if it's missing
		if [[ $url != "https://"* ]] && [[ $url != "http://"* ]]; then
			url="https://"$url
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
		path="/browse?at=refs/heads/"
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
