#!/bin/bash 
# Date: 21Jul2022
# Author: Don Brown
# Description: Ensure no users have .netrc files
# Usage: $ ./check_usersnetrcfiles.sh

# Treat unset variables as an error when substituting
set -u

# Make sure program is run as root.
if [ "$(id -u)" -eq 0 ] then
	echo "This script must be run as root."
	exit 1
fi

grep -E -v '^(root|halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do 
	if [ ! -d "$dir" ]; then 
		echo "The home directory ($dir) of user $user does not exist." 
	else 
		if [ ! -h "$dir/.netrc" -a -f "$dir/.netrc" ]; then 
			echo ".netrc file $dir/.netrc exists" 
		fi 
	fi 
done
