#!/bin/bash 
# Date: 21Jul2022
# Author: Don Brown
# Description: Ensure users' home directories permissions
# Usage: $ ./check_homedirectorypermissions.sh

# Treat unset variables as an error when substituting
set -u

# Make sure program is run as root.
if [ "$(id -u)" -eq 0 ] then
	echo "This script must be run as root."
	exit 1
fi

grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do 
	if [ ! -d "$dir" ]; then 
		echo "The home directory ($dir) of user $user does not exist." 
	else 
		dirperm=$(ls -ld $dir | cut -f1 -d" ") 
		if [ $(echo $dirperm | cut -c6) != "-" ]; then 
			echo "Group Write permission set on the home directory ($dir) of user $user" 
		fi 
		if [ $(echo $dirperm | cut -c8) != "-" ]; then 
			echo "Other Read permission set on the home directory ($dir) of user $user" 
		fi 
		if [ $(echo $dirperm | cut -c9) != "-" ]; then 
			echo "Other Write permission set on the home directory ($dir) of user $user" 
		fi 
		if [ $(echo $dirperm | cut -c10) != "-" ]; then 
			echo "Other Execute permission set on the home directory ($dir) of user $user" 
		fi 
	fi 
done
