#!/bin/bash 
# Date: 21Jul2022
# Author: Don Brown
# Description: Ensure no duplicate group names exist
# Usage: $ ./check_noduplicategroupnames.sh

# Treat unset variables as an error when substituting
set -u

# Make sure program is run as root.
if [ "$(id -u)" -eq 0 ] then
	echo "This script must be run as root."
	exit 1
fi

cut -d: -f1 /etc/group | sort | uniq -d | while read x do 
	echo "Duplicate group name ${x} in /etc/group" 
done
