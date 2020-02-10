#!/bin/bash

####################################################################
# Important:                                                       #
# s3cmd needs to be installed and configured for the target bucket #
# ##################################################################

# Setup
set -u
set -e
USER="$(whoami)"

# Create temporary path and filename
TMPPATH=~/backup-tmp
if [ ! -d "${TMPPATH}" ] 
then
    mkdir -p "${TMPPATH}"
fi
FILENAME="$(date '+%Y-%m-%d_%H:%M:%S')".gz
FILEPATH="${TMPPATH}"/"${FILENAME}"

# Create mysqldump, gzip and upload to S3
mysqldump "${USER}" | gzip > "${FILEPATH}"
/home/"${USER}"/.local/bin/s3cmd put --reduced-redundancy "${FILEPATH}" s3://"${USER}"-backup/"${FILENAME}"

# Remove temporary file
rm "${FILEPATH}"
