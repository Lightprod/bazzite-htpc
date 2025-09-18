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

# Show default flatpak installed
[group('System Config')]
flatpak-defaults:
    #!/usr/bin/bash
    cat /usr/share/ublue-os/bazzite/flatpak/install

# Show flatpak blocklist
[group('System Config')]
flatpak-blocklist:
    #!/usr/bin/bash
    cat /usr/share/ublue-os/flatpak-blocklist

# Show bazaar blocklist
[group('System Config')]
bazaar-blocklist:
    #!/usr/bin/bash    
    cat '/usr/share/ublue-os/bazaar/blocklist.txt'

# Fix Pokémon Insurgence's corrupted wild pokemon battle theme and fix lutris config
[group('Games fixes')]
fix-pokemon-insurgence:
    #!/usr/bin/bash    

# Rebase to the testing branch
[group('System')]
rebase-testing:
    #!/usr/bin/bash
    $branch=ghcr.io/lightprod/bazzite-htpc:testing

    echo 'This will rebase this install to the testing branch. Continue?'

    bootc switch --enforce-container-sigpolicy registry $branch

# Rebase to the latest branch
[group('System')]
rebase-latest:
    #!/usr/bin/bash

    $branch=ghcr.io/lightprod/bazzite-htpc:latest

    echo 'This will rebase this install to the latest branch. Continue?'

    bootc switch --enforce-container-sigpolicy registry $branch

# Enable Flathub and disable Fedora Flatpaks. Taken from Aurora's install-system-flatpak recipe
[group('System')]
fix-flatpak-repo:
    #!/usr/bin/bash

    echo 'Enabling Flathub'

    flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo

    echo 'Disable Fedora-Flatpaks repos'

    for remote in fedora fedora-testing; do
        if flatpak remote-list | grep -q "$remote"; then
            flatpak remote-delete "$remote"
        fi
    done

# Set up default system flatpaks. Does not reinstall them nor updates them.
[group('System')]
install-system-flatpaks:
    #!/usr/bin/bash
    FLATPAK_LIST=$(< /usr/share/ublue-os/bazzite/flatpak/install)
    echo 'Installing defaults Flatpaks'
    flatpak install --system --assumeyes ${FLATPAK_LIST}