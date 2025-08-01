#!/bin/bash

set -ouex pipefail

echo "Modifying upstream justfile"
cat /tmp/files_modifications/justfile >> /usr/share/ublue-os/justfile