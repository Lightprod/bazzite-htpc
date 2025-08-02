#!/bin/bash

set -ouex pipefail

echo "Modifying upstream justfile"
cat /ctx/files/justfile >> /usr/share/ublue-os/justfile
cat /usr/share/ublue-os/justfile