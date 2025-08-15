#  vim: set ft=make :
########################
### bazzite-htpc.just
########################
## Standardized verbs
# configure- = configure something that is pre-installed on the image
# install-   = install something, no uninstall or configuration provided
# setup-     = install something and also provide configuration and/or uninstallation options
# toggle-    = turn something on/off, logic can be automatic or manual selection
# fix-       = apply fix/patch/workaround for something
# foo        = no verb is used for shortcuts or something deemed important enough to use a super memorable name
# testing    = Testing branch recipes

flatpak-defaults
    # Show default flatpak installed
    #!/usr/bin/bash
    cat /usr/share/ublue-os/bazzite/flatpak/install

flatpak-blocklist
    # Show flatpak blocklist
    #!/usr/bin/bash
    cat /usr/share/ublue-os/flatpak-blocklist

bazaar-blocklist
    # Show bazaar blocklist
    #!/usr/bin/bash
    cat /usr/share/ublue-os/bazzar/blocklist.txt

fix-pokemon-insurgence
    # Fix Pokémon Insurgence's corrupted wild pokemon battle theme and fix lutris config
    #!/usr/bin/bash

rebase-testing
    # Rebase to the testing branch
    #!/usr/bin/bash

    $branch=ghcr.io/lightprod/bazzite-htpc:testing

    echo 'This will rebase this install to the testing branch. Continue?'
    bootc switch --enforce-container-sigpolicy registry $branch

rebase-latest
    # Rebase to the testing branch
    #!/usr/bin/bash

    $branch=ghcr.io/lightprod/bazzite-htpc:latest

    echo 'This will rebase this install to the latest branch. Continue?'
    bootc switch --enforce-container-sigpolicy registry $branch

# testing-disabled-recipe
#     # For disabled recipes
#     #!/usr/bin/bash
#     echo 'This '$recipe' is disabled due to being unsupported or being installed by this image.'

setup-flatpak-repo
    # Enable Flathub and disable Fedora Flatpaks. Taken from Aurora's install-system-flatpak
    #!/usr/bin/bash

    echo 'Enabling Flathub'
    flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo

    echo 'Disable Fedora-Flatpaks repos'
       for remote in fedora fedora-testing; do
           if flatpak remote-list | grep -q "$remote"; then
               flatpak remote-delete "$remote"
           fi
       done

install-system-flatpaks:
    # Set up default system flatpaks. Does not reinstall them nor updates them.
    #!/usr/bin/bash

    echo 'Installing Flatpaks'
    FLATPAK_LIST=`cat /usr/share/ublue-os/bazzite/flatpak/install`
    flatpak install --system --assumeyes ${FLATPAK_LIST}