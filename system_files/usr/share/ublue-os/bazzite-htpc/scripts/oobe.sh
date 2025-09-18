#!/usr/bin/bash

echo 'Installing flatpaks...'

ujust install-system-flatpaks

echo 'Enabling default flatpak service'

systemctl enable enable default-flatpak-manager

echo "Disabling oobe service"

systemctl disable systemctl enable oobe