#!/bin/bash

set -ouex pipefail

echo "Enabling cockpit socket"
systemctl enable cockpit.socket

echo "Enabling sshd service"  # For SSH access
systemctl enable sshd

# echo 'Enabling default flatpak install service' # For installing default flatpaks
# systemctl enable default-flatpak-manager

echo 'Enabling oobe service' # For iso installs
systemctl enable oobe

echo 'Enabling syncthingy serivce'
systemctl enable syncthingy

echo 'Enabling kde connect serivce'
systemctl enable kde-connect

echo 'Enabling OpenRGB serivce'
systemctl enable openrgb