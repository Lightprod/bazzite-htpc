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
# start      = start a program.
# testing    = Testing branch recipes

# Start Firefox for installing custom PWA
[group('Experiment - Web Apps')]
start-firefox-pwa:
    #!/usr/bin/bash
    nohup firefox -P firefox-pwa &

# Install Youtube as a PWA
[group('Experiment - Web Apps')]
install-youtube-pwa:
    #!/usr/bin/bash
    echo 'Creating a youtube profile'

    firefoxpwa profile create --name Youtube --description "Profile for youtube.com" >> /tpm/firefowpwa-output-youtube
    cat /tpm/firefowpwa-output-youtube | grep -o "01.*" >> ~/.local/share/firefoxpwa/profiles/id-youtube.txt

    YOUTUBE_PROFILE_ID=$(< ~/.local/share/firefoxpwa/profiles/id-youtube.txt)

    echo 'Youtube profile has been created with profile id ' && echo $YOUTUBE_PROFILE_ID

    echo 'Installing Youtube PWA'

    firefoxpwa site install https://www.youtube.com/manifest.webmanifest --profile $YOUTUBE_PROFILE_ID

    echo 'Youtube PWA installed.'
