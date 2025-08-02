#!/bin/bash

set -ouex pipefail

echo 'Modifying upstream justfile'

cat /ctx/files/justfile >> /usr/share/ublue-os/justfile
cat /usr/share/ublue-os/justfile

echo 'Modifying upstream default flatpaks'

cat /ctx/files/flatpak/install >> /usr/share/ublue-os/bazzite/flatpak/install
sed -i '1d' /usr/share/ublue-os/bazzite/flatpak/install
cat /usr/share/ublue-os/bazzite/flatpak/install

echo 'Modifying upstream flatpak blocklist'

cat /ctx/files/flatpak/flatpak-blocklist >> /usr/share/ublue-os/bazzite/flatpak-blocklist
cat /usr/share/ublue-os/bazzite/flatpak-blocklist

echo 'Modifying upstream Bazarr blacklist'

cat /ctx/files/flatpak/blacklist >> /usr/share/ublue-os/bazaar/blocklist.txt
cat /usr/share/ublue-os/bazaar/blocklist.txt