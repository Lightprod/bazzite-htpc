#!/bin/bash

set -ouex pipefail

# ==================================================================================

echo 'Clean up the package manager'

dnf5 clean all

echo 'Clean up temporary files'

rm -rf /tmp/*
rm -rf /var/*
# rm -rf /usr/etc

