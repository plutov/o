#!/usr/bin/env bash
#
# Author: Alex Pliutau http://pliutau.com

set -e

DOWNLOAD_URL="https://raw.githubusercontent.com/plutov/o/master/o.sh"
TMP_FILE="/tmp/o.sh"

downloadFile() {
	if type "curl" > /dev/null; then
		curl -s -L "$DOWNLOAD_URL" -o "$TMP_FILE"
	elif type "wget" > /dev/null; then
		wget -q -O "$TMP_FILE" "$DOWNLOAD_URL"
	fi
}

installFile() {
	chmod +x "$TMP_FILE"
	SUDO=''
	if [ $EUID != 0 ]; then
		SUDO='sudo'
	fi

	read -p "Please pick a name for your git open [o]:" o_name
	echo    # (optional) move to a new line
	if [[ "$o_name" == "" ]]; then
		o_name="o"
	fi
	BIN_FILE="/usr/local/bin/$o_name"
	$SUDO mv "$TMP_FILE" $BIN_FILE
}

downloadFile
installFile
echo "Installed in $BIN_FILE"
