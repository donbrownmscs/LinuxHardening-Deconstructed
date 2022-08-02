#!/bin/bash 
# Date: 21Jul2022
# Author: Don Brown
# Description: Ensure no users have .rhosts files
# Usage: $ ./check_allgroupsexist.sh

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
		for file in $dir/.rhosts; do 
			if [ ! -h "$file" -a -f "$file" ]; then 
				echo ".rhosts file in $dir" 
			fi 
		done 
	fi 
done
