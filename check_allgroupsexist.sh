#!/bin/bash 
# Date: 21Jul2022
# Author: Don Brown
# Description: Ensure all groups in /etc/passwd exist in /etc/group
# Usage: $ ./check_allgroupsexist.sh

# Treat unset variables as an error when substituting
set -u

# Make sure program is run as root.
if [ "$(id -u)" -eq 0 ] then
	echo "This script must be run as root."
	exit 1
fi

for i in $(cut -s -d: -f4 /etc/passwd | sort -u ); do 
	grep -q -P "^.*?:[^:]*:$i:" /etc/group 
	if [ $? -ne 0 ]; then 
		echo "Group $i is referenced by /etc/passwd but does not exist in /etc/group"
	fi 
done
