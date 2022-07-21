#!/bin/sh
# Date: 19Jul2022
# Author: Don Brown
# Description: This script runs lynis as a cronjob and generates 
# a report with the date in its name.
# Usage: $ ./lynis-cronjob.sh

# bool function to test if the user is root or not (POSIX only)
is_user_root () { 
	[ "$(id -u)" -eq 0 ];
}

# Treat unset variables as an error when substituting
set -u

if is_user_root; then
    # Create Report Filename with host, date, and time
	DATE = $(date +%Y-%m-%d_%H%M%S)
	HOST = $(hostname)
	LOG_DIR = "/var/log/lynis"
	REPORT = "$LOG_DIR/report-${HOST}.${DATE}"

	# Run Lynis
	/usr/local/lynis/lynis audit system --cronjob > ${REPORT}

	# implicit, here it serves the purpose to be explicit for the reader
    exit 0 
else
	# Need to run as root
    echo 'You must run this program as root.' >&2
    exit 1
fi

