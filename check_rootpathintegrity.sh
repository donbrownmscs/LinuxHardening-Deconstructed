#!/bin/bash 
# Date: 21Jul2022
# Author: Don Brown
# Description: Ensure root path integrity
# Usage: $ ./check_rootpathintegrity.sh

# Treat unset variables as an error when substituting
set -u

# Make sure program is run as root.
if [ "$(id -u)" -eq 0 ] then
	echo "This script must be run as root."
	exit 1
fi

# Find any empty directories in $PATH environment variable
if echo $PATH | grep -q "::" ; then 
	echo "Empty Directory in PATH (::)" 
fi
 
# Find any trailing colons in $PATH environment variable
if echo $PATH | grep -q ":$" ; then 
	echo "Trailing : in PATH" 
fi 

for x in $(echo $PATH | tr ":" " ") ; do 
	if [ -d "$x" ] ; then 
		ls -ldH "$x" | awk ' 
			$9 == "." {print "PATH contains current working directory (.)"} 
			$3 != "root" {print $9, "is not owned by root"} 
			substr($1,6,1) != "-" {print $9, "is group writable"} 
			substr($1,9,1) != "-" {print $9, "is world writable"}' 
	else 
		echo "$x is not a directory" 
	fi 
done
