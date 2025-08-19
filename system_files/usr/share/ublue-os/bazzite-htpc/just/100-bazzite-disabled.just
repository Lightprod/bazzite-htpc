#  vim: set ft=make :
########################
### bazzite-disabled.just
########################
## Standardized verbs
# configure- = configure something that is pre-installed on the image
# install-   = install something, no uninstall or configuration provided
# setup-     = install something and also provide configuration and/or uninstallation options
# toggle-    = turn something on/off, logic can be automatic or manual selection
# fix-       = apply fix/patch/workaround for something
# foo        = no verb is used for shortcuts or something deemed important enough to use a super memorable name

# Disabling the following bazzite recipe:

# Disabled recipe
[group('Disabled')]
_install-system-flatpaks:
    #!/usr/bin/bash
    echo "This recipe is replaced by install-system-flatpaks and setup-flatpak-repo"