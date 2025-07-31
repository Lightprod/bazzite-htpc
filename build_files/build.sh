#!/bin/bash

set -ouex pipefail

echo "Installing system packages"
/ctx/packages_setup.sh

echo "Installing systemd system services"
/ctx/install_systemd_system.sh

echo "Installing systemd user services"
/ctx/install_systemd_user.sh


