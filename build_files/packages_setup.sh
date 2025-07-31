#!/bin/bash

set -ouex pipefail

echo "Defining variables"

COPR_REPOS=(
    atim/heroic-games-launcher
)
    # Layered packages
LAYERED_REPO_PACKAGES=(
    konsole
    heroic-games-launcher-bin
    cockpit 
    cockpit-files 
    cockpit-ostree 
    gvfs-smb 
    gvfs-fuse 
    plasma-discover 
    plasma-discover-flatpak 
    plasma-discover-notifier
    plasma-discover-kns
    kvantum
    mc
    atuin
    openrgb
    gparted
)

LAYERED_DISTANT_PACKAGES=( # For packages not present in Fedora's repos
    https://launchpad.net/veracrypt/trunk/1.26.24/+download/veracrypt-1.26.24-Fedora-40-x86_64.rpm
)

echo "Enabling COPR repos"

    for repo in "${COPR_REPOS[@]}"; do
        dnf5 copr enable "$repo" -y
    done

echo "Installing packages"

    dnf5 install --skip-broken --skip-unavailable -y "${LAYERED_REPO_PACKAGES[@]}"
    dnf5 install --skip-broken --skip-unavailable -y "${LAYERED_DISTANT_PACKAGES[@]}"

echo "Disabling COPR repos"
    for repo in "${COPR_REPOS[@]}"; do
        dnf5 copr disable "$repo" -y
    done
