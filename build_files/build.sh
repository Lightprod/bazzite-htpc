#!/bin/bash

set -ouex pipefail

# Define variables

echo "Defining variables"

    # COPR Repos
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

    # Flatpaks

# FLATPAK_RM_REPO=(
#     fedora
# )

# FLATPAK_ADD=(
#     one.ablaze.floorp
#     io.github.ungoogled_software.ungoogled_chromium
#     com.bitwarden.desktop
#     io.github.ilya_zlobintsev.LACT
#     io.github.dvlv.boxbuddyrs
#     net.davidotek.pupgui2
#     com.github.zocker_160.SyncThingy
#     tv.plex.PlexDesktop
#     tv.plex.PlexHTPC
#     com.plexamp.Plexamp
#     com.github.iwalton3.jellyfin-media-player
#     com.discordapp.Discord
#     dev.vencord.Vesktop
# )

# FLATPAK_REMOVE=(
#     org.mozilla.firefox
# )


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

# echo "Remove fedora flatpaks repo"
#     flatpak remote-delete "${FLATPAK_RM_REPO[@]}"

# echo "Installing additional flatpaks"
#     flatpak install -y -v --system "${FLATPAK_ADD[@]}"

# echo "Removing un-needed flatpaks"
#     flatpak remove -y -v "${FLATPAK_REMOVE[@]}"

echo "Enabling system unit files"
    systemctl enable cockpit.socket
    systemctl enable sshd # For SSH access

