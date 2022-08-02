#!/bin/bash 
# Date: 21Jul2022
# Author: Don Brown
# Description: Ensure no duplicate usernames exist
# Usage: $ ./check_noduplicateusernames.sh

# Treat unset variables as an error when substituting
set -u

# Make sure program is run as root.
if [ "$(id -u)" -eq 0 ] then
	echo "This script must be run as root."
	exit 1
fi

cut -d: -f1 /etc/passwd | sort | uniq -d | while read x do
	echo "Duplicate login name ${x} in /etc/passwd" 
done
