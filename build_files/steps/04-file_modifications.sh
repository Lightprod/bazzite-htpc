#!/bin/bash

set -ouex pipefail

echo "Defining variables"

DISTROSELF_DIR=/etc/skel/.var/app/com.ranfdev.DistroShelf

UJUST_WORK_FOLDER=/tmp/ujust
UJUST_CONFIG_FILE=/usr/share/ublue-os/justfile

# SYSTEMD_USER_SERVICE_FOLDER=/etc/skel/.config/systemd/user/*
# SYSTEMD_USER_SERVICE_SYSLINK_FOLDER=/etc/skel/.config/systemd/user/default.target.wants

GIT_UJUST_CONFIG_FILE=/ctx/files/just/justfile

# ===================================================================

mkdir ${UJUST_WORK_FOLDER}

# ===================================================================

# Remove default DistroShelf config

echo 'Removing distroshelf config'

rm -rd $DISTROSELF_DIR

# ===================================================================

echo 'Copying upstream justfile'

cd ${UJUST_WORK_FOLDER}
cp $UJUST_CONFIG_FILE upstream-justfile
cp $GIT_UJUST_CONFIG_FILE justfile-git

echo 'Amend upstream justfile' # Add customs just recipes

cat justfile-git >> upstream-justfile
cat upstream-justfile

echo 'Copying justfile to usr'

cp upstream-justfile $UJUST_CONFIG_FILE

# ===================================================================

# mkdir ${SYSTEMD_USER_SERVICE_SYSLINK_FOLDER}
# cp $SYSTEMD_USER_SERVICE_FOLDER $SYSTEMD_USER_SERVICE_SYSLINK_FOLDER