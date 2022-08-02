#!/bin/bash 
# Date: 21Jul2022
# Author: Don Brown
# Description: Ensure no duplicate GIDs exist
# Usage: $ ./check_noduplicategids.sh

# Treat unset variables as an error when substituting
set -u

# Make sure program is run as root.
if [ "$(id -u)" -eq 0 ] then
	echo "This script must be run as root."
	exit 1
fi

cut -d: -f3 /etc/group | sort | uniq -d | while read x ; do 
	echo "Duplicate GID ($x) in /etc/group" 
done
