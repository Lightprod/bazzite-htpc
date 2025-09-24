#!/bin/bash

set -ouex pipefail

echo "Defining variables"

DISTROSELF_DIR=/etc/skel/.var/app/com.ranfdev.DistroShelf

UJUST_WORK_FOLDER=/tmp/ujust
UJUST_CONFIG_FILE=/usr/share/ublue-os/justfile
SCRIPT_FOLDER=/usr/share/ublue-os/bazzite-htpc/scripts

GIT_UJUST_BAZZITE_HTPC_CONFIG_FILE=/ctx/files/just/justfile
GIT_UJUST_OVERWRITES_CONFIG_FILE=/ctx/files/just/justfile-overwrites
UJUST_OVERWRITES_CONFIG=$(< $GIT_UJUST_OVERWRITES_CONFIG_FILE)

# ===================================================================

# Remove default DistroShelf config

echo 'Removing distroshelf config'

rm -rd $DISTROSELF_DIR

# ===================================================================

echo 'Copying upstream justfile'

mkdir ${UJUST_WORK_FOLDER}
cd ${UJUST_WORK_FOLDER}
cp $UJUST_CONFIG_FILE upstream-justfile
cp $GIT_UJUST_BAZZITE_HTPC_CONFIG_FILE justfile-bazzite-htpc-git

echo 'Amend upstream justfile' # Add customs just recipes

sed -i "11i$UJUST_OVERWRITES_CONFIG" upstream-justfile # Add overwrite recipes on top of imports due to bug: https://github.com/casey/just/issues/2540
cat justfile-bazzite-htpc-git >> upstream-justfile
cat upstream-justfile

echo 'Copying justfile to usr'

cp upstream-justfile $UJUST_CONFIG_FILE

# ===================================================================

echo 'Fix scripts permissions'

cd $SCRIPT_FOLDER
chmod +x *.sh