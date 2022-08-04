#!/bin/bash 
# Date: 21Jul2022
# Author: Don Brown
# Description: Ensure users own their home directories
# Usage: $ ./check_usersownhomedirectories.sh

# Treat unset variables as an error when substituting
set -u

# Make sure program is run as root.
if [ "$(id -u)" -eq 0 ] then
	echo "This script must be run as root."
	exit 1
fi

grep -E -v '^(halt|sync|shutdown)' /etc/passwd | awk -F: '($7 != "'"$(which nologin)"'" && $7 != "/bin/false") { print $1 " " $6 }' | while read -r user dir; do 
	if [ ! -d "$dir" ]; then 
		echo "The home directory ($dir) of user $user does not exist." 
	fi 
done
