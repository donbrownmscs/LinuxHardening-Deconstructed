#!/bin/bash 
# Date: 21Jul2022
# Author: Don Brown
# Description: Ensure users' .netrc Files are not group or world accessible
# Usage: $ ./check_usersnetrcfilesnotworldwriteable.sh

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
		for file in $dir/.netrc; do 
			if [ ! -h "$file" -a -f "$file" ]; then 
				fileperm=$(ls -ld $file | cut -f1 -d" ") 
				if [ $(echo $fileperm | cut -c5) != "-" ]; then 
					echo "Group Read set on $file" 
				fi 
				if [ $(echo $fileperm | cut -c6) != "-" ]; then 
					echo "Group Write set on $file" 
				fi 
				if [ $(echo $fileperm | cut -c7) != "-" ]; then 
					echo "Group Execute set on $file" 
				fi 
				if [ $(echo $fileperm | cut -c8) != "-" ]; then 
					echo "Other Read set on $file" 
				fi 
				if [ $(echo $fileperm | cut -c9) != "-" ]; then 
					echo "Other Write set on $file" 
				fi 
				if [ $(echo $fileperm | cut -c10) != "-" ]; then 
					echo "Other Execute set on $file" 
				fi 
			fi 
		done 
	fi 
done

