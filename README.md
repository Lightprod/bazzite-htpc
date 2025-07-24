# Bazzite-htpc

[Template readme](https://github.com/Lightprod/bazzite-htpc/blob/main/README%20template.md)

# Purpose
This image is a custom version of Bazzite based from ```bazzite-deck:latest``` using [the Ublue project's image template](https://github.com/ublue-os/image-template). 

It comes with (some) KDE default apps restored and add additional packages and settings to use on my personal HTPC.

**_Please note that this image is made for personal use only and I do not provide support of any kind. I am not responsible for any kind of damage resulting from using this image._**


# Rebase

You can rebase to this image from any **KDE based** ublue image.

Start by rebasing to the _unverified_ image using those command:

``` sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/lightprod/bazzite-htpc:latest ```

``` sudo systemctl reboot ```

Then rebase to the _verified_ image:

``` sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/lightprod/bazzite-htpc:latest ```

``` sudo systemctl reboot ```

# Changes

 - Added rpm packages:
    - _Libraries_:
        - gvfs-fuse
        - gvfs-smb
    - _Games / Launchers_:
        - heroic-games-launcher
    - _KDE app suite_:
        - konsole
        - plasma-discover
        - plasma-discover-flatpak
        - plasma-discover-notifier
        - plasma-discover-kns
        - discover-overlay
        - kvantum
    - _Sysadmin and utilitaries_:
        - cockpit
        - cockpit-ostree
        - cockpit-file-manager
        - cockpit-sosreport
        - mc
        - atuin
        - openrgb (1)
        - gparted
        - veracrypt

 - Added flatpaks:
    - _Browsers_:
        - Floorp (one.ablaze.floorp)
        - Ungoogled Chromium
    - _Utilities_:
        - Bitwarden
        - LACT
        - Boxbuddy
        - ProtonUp-QT
        - Syncthingy
    - _Multimedia_:
        - Plex
        - Plex HTPC
        - Plexamp
        - Jellyin Media Player
        - Vesktop
        - Discord
    - _May be added later_:
        - kde-partitionmanager (rpm)

    - Removed rpms packages:

    - Removed Flatpaks:
        - Firefox (Replaced by Floorp)


Notes: 

  (1) Bazzite's openrgb is an appimage. I set it up as a rpm for automatic updates and avoid a risk of depending on fuse2.
