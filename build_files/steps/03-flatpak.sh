#!/bin/bash

set -ouex pipefail

# ================================================================================

echo "Defining variables"

UPSTREAM_FLATPAK_INSTALL_FILE=https://raw.githubusercontent.com/ublue-os/bazzite/refs/heads/main/installer/kde_flatpaks/flatpaks

DEFAULT_FOLDER=/tmp/flatpak

FLATPAK_INSTALL_FILE=/usr/share/ublue-os/bazzite/flatpak/install
FLATPAK_BLOCKLIST_FILE=/usr/share/ublue-os/flatpak-blocklist
BAZAAR_BLOCKLIST_FILE=/usr/share/ublue-os/bazzar/blocklist.txt

GIT_FLATPAK_INSTALL_FILE=/ctx/files/flatpak/install
GIT_FLATPAK_BLOCKLIST_FILE=/ctx/files/flatpak/blocklist
GIT_BAZAAR_BLOCKLIST_FILE=/ctx/files/bazzar/blocklist

# ================================================================================

mkdir ${DEFAULT_FOLDER}
cd ${DEFAULT_FOLDER}

echo 'Importing list of default flatpak from upstream'
curl -o upstream-flatpaks $UPSTREAM_FLATPAK_INSTALL_FILE

echo 'Copying upstream flatpak blocklist'
cp $FLATPAK_BLOCKLIST_FILE flatpak-blocklist

echo 'Copying upstream BAZAAR blocklist'
cp $BAZAAR_BLOCKLIST_FILE bazzar-blocklist

# ==================================================================================

echo 'Amend upstream default flatpaks'

echo 'Removing Firefox flatpak'
# sed -i '/org.mozilla.firefox/d' upstream-flatpaks

echo 'Removing Distroshelf flatpak'
sed -i '/com.ranfdev.DistroShelf/d' upstream-flatpaks

cat upstream-flatpaks

echo 'Adding additional flatpaks'

cat $GIT_FLATPAK_INSTALL_FILE >> upstream-flatpaks
cat upstream-flatpaks

# ==================================================================================

echo 'Amend upstream flatpak blocklist'

cat $GIT_FLATPAK_BLOCKLIST_FILE >> flatpak-blocklist
cat flatpak-blocklist

echo 'Amend upstream bazzar blacklist'

cat $GIT_BAZAAR_BLOCKLIST_FILE >> bazzar-blocklist
cat bazzar-blocklist

# ==================================================================================

echo 'Copying flatpaks config files to usr'

cp upstream-flatpaks $FLATPAK_INSTALL_FILE
cp flatpak-blocklist $FLATPAK_BLOCKLIST_FILE
cp bazzar-blocklist $BAZAAR_BLOCKLIST_FILE