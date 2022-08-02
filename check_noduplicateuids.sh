#!/bin/bash 
# Date: 21Jul2022
# Author: Don Brown
# Description: Ensure no duplicate UIDs exist
# Usage: $ ./check_noduplicateuids.sh

# Treat unset variables as an error when substituting
set -u

# Make sure program is run as root.
if [ "$(id -u)" -eq 0 ] then
	echo "This script must be run as root."
	exit 1
fi

cut -f3 -d":" /etc/passwd | sort -n | uniq -c | while read x ; do 
	[ -z "$x" ] && break 
	set - $x 
	if [ $1 -gt 1 ]; then 
		users=$(awk -F: '($3 == n) { print $1 }' n=$2 /etc/passwd | xargs) 
		echo "Duplicate UID ($2): $users" 
	fi 
done
