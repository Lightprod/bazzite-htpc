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

# Setup firefox pwa
[group('Experiment - Web Apps')]
setup-firefox-pwa:
    #!/usr/bin/bash

    USER_ABSOLUTE_PATH=$(realpath ~/.mozilla/firefox)
    FIREFOX_PROFILE_NAME=firefox-pwa
    FIREFOX_PROFILE_PATH="${USER_ABSOLUTE_PATH}/${FIREFOX_PROFILE_NAME}"
    FIREFOX_PROFILE_FULL="${FIREFOX_PROFILE_NAME} ${FIREFOX_PROFILE_PATH}"

    echo 'Creating a specific profile for firefox-pwa'

    firefox -createprofile "${FIREFOX_PROFILE_FULL}" -no-remote
    nohup firefox -P $FIREFOX_PROFILE_NAME -headless & kill `pidof firefox`

    
    echo 'firefox-pwa profile installed'
    sleep 5s
    echo 'Installing firefox-pwa extension'
    
    cd "${FIREFOX_PROFILE_PATH}/extensions"

    wget https://addons.mozilla.org/firefox/downloads/latest/firefoxpwa@filips.si/latest.xpi -O firefoxpwa@filips.si.xpi

    echo 'Installing ublock-origin extension'
    wget https://addons.mozilla.org/firefox/downloads/latest/uBlock0@raymondhill.net/latest.xpi -O uBlock0@raymondhill.net.xpi

    echo 'Installing firefox-pwa runtime'
    firefoxpwa runtime install

    echo 'Preconfiguring firefox-pwa profile-id folder'
    mkdir ~/.local/share/firefoxpwa/.profiles-id

    echo 'Firefox-pwa is installed.'

# Start Firefox for installing custom PWA
[group('Experiment - Web Apps')]
start-firefox-pwa:
    #!/usr/bin/bash
    nohup firefox -P firefox-pwa -no-remote &

# Install Youtube as a PWA
[group('Experiment - Web Apps')]
install-youtube-pwa:
    #!/usr/bin/bash
    echo 'Creating a youtube profile'

    firefoxpwa profile create --name Youtube --description "Profile for youtube.com" >> /tmp/firefoxpwa-output-youtube
    cat /tmp/firefoxpwa-output-youtube | grep -o "01.*" >> ~/.local/share/firefoxpwa/.profiles-id/id-youtube.txt

    YOUTUBE_PROFILE_ID=$(< ~/.local/share/firefoxpwa/.profiles-id/id-youtube.txt)

    echo 'Youtube profile has been created with profile id ' && echo $YOUTUBE_PROFILE_ID

    echo 'Installing Youtube PWA'

    firefoxpwa site install https://www.youtube.com/manifest.webmanifest --profile $YOUTUBE_PROFILE_ID # Besoin de capturer l'ID du PWA wtf

    rm /tmp/firefoxpwa-output-youtube

    echo 'Youtube PWA installed.'
