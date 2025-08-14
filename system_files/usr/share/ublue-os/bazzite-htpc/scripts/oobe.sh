#!/usr/bin/bash

echo 'Installing flatpaks...'
ujust setup-flatpak-repo
ujust install-system-flatpaks


echo 'Enabling default flatpak service'

systemctl enable enable default-flatpak-manager