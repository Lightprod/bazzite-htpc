#!/bin/bash

set -ouex pipefail

# echo "Defining variables"

echo "Import GPG key"
    rpm --import https://packagecloud.io/filips/FirefoxPWA/gpgkey

echo "Enable the repository"
    dnf5 config-manager setopt firefoxpwa.enabled=1

# echo "Update DNF cache"
#     dnf5 -q makecache -y --disablerepo="*" --enablerepo="firefoxpwa"

echo "Install the package"
    dnf5 install firefoxpwa

echo "Disable the repository"
    dnf5 config-manager setopt firefoxpwa.enabled=0

# echo 'Adding firefox-pwa profile to firefox's default profile'