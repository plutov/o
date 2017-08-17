#!/bin/bash
#
# Author: Alex Pliutau http://pliutau.com

set -e

downloadFile() {
	curl -L "https://raw.githubusercontent.com/plutov/o/master/o.sh" -o /tmp/o.sh
}

installFile() {
	chmod +x /tmp/o.sh
	SUDO=''
	if [ $EUID != 0 ]; then
		SUDO='sudo'
	fi
	$SUDO mv /tmp/o.sh /usr/local/bin/o
}

downloadFile
installFile
echo "Installed in /usr/local/bin/o"
