#!/usr/bin/env bash
#
# Author: Alex Pliutau http://pliutau.com

set -e

DOWNLOAD_URL="https://raw.githubusercontent.com/plutov/o/master/o.sh"
TMP_FILE="/tmp/o.sh"
BIN_FILE="/usr/local/bin/o"

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
	$SUDO mv "$TMP_FILE" /usr/local/bin/o
}

downloadFile
installFile
echo "Installed in $BIN_FILE"
