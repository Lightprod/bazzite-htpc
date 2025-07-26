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

FLATPAK_RM_REPO=(
    fedora
)

FLATPAK_ADD=(
    one.ablaze.floorp
    io.github.ungoogled_software.ungoogled_chromium
    com.bitwarden.desktop
    io.github.ilya_zlobintsev.LACT
    io.github.dvlv.boxbuddyrs
    net.davidotek.pupgui2
    com.github.zocker_160.SyncThingy
    tv.plex.PlexDesktop
    tv.plex.PlexHTPC
    com.plexamp.Plexamp
    com.github.iwalton3.jellyfin-media-player
    com.discordapp.Discord
    dev.vencord.Vesktop
)

FLATPAK_REMOVE=(
    org.mozilla.firefox
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

# echo "Remove fedora flatpaks repo"
#     flatpak remote-delete "${FLATPAK_RM_REPO[@]}"

echo "Installing additional flatpaks"
    flatpak install -y -v --system "${FLATPAK_ADD[@]}"

echo "Removing un-needed flatpaks"
    flatpak remove -y -v "${FLATPAK_REMOVE[@]}"

echo "Enabling system unit files"
    systemctl enable cockpit.socket
    systemctl enable sshd # For SSH access


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf5 -y copr enable atim/heroic-games-launcher
# dnf5 install -y konsole heroic-games-launcher-bin cockpit cockpit-files cockpit-ostree gvfs-smb gvfs-fuse plasma-discover plasma-discover-flatpak plasma-discover-notifier 
# dnf5 -y copr disable atim/heroic-games-launcher

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

# systemctl enable podman.socket
