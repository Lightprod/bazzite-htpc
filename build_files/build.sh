#!/bin/bash

set -ouex pipefail

echo 'Building bazzite-htpc:testing'

# echo 'Step 1 : Image-metadata'
    # /ctx/steps/01-image_metadata.sh # Later.

echo 'Step 2: RPM packages'
    /ctx/steps/02-packages.sh

echo 'Step 3: Setting up default Flatpak install workflow'
    /ctx/steps/03-flatpak.sh

echo 'Step 4: Files Modifications'
    /ctx/steps/04-file_modifications.sh

echo 'Step 5: Setting up additionals systemd services'
    /ctx/steps/05-systemd_services.sh

echo 'Last step: Cleanup'
    /ctx/steps/06-cleanup.sh

echo 'Commiting container...'

ostree container commit
bootc container lint

# echo "Installing system packages"
# /ctx/packages_setup.sh

# echo "Preparing flatpak setup"
# /ctx/flatpaks.sh

# echo "Editing users files and preferences"
# /ctx/user_changes.sh

# echo "Editing ujust database"
# /ctx/ujust.sh

# echo "Installing systemd system services"
# /ctx/install_systemd_system.sh

# echo "Installing systemd user services"
# /ctx/install_systemd_user.sh



