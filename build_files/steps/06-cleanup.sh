#!/bin/bash

set -ouex pipefail

# ==================================================================================

echo 'Clean up the package manager'

dnf5 clean all

echo 'Clean up /tmp'

rm -rf /tmp/*



