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
install-firefox-pwa:
    #!/usr/bin/bash

    USER_ABSOLUTE_PATH=$(realpath ~/.mozilla/firefox/firefox-pwa-test)
    FIREFOX_PROFILE_NAME=firefox-pwa-test
    FIREFOX_PROFILE_FULL="${FIREFOX_PROFILE_NAME} ${USER_ABSOLUTE_PATH}"

    echo 'Creating a specific profile for firefox-pwa'

    firefox -createprofile "${FIREFOX_PROFILE_FULL}" -no-remote
    nohup firefox -P $FIREFOX_PROFILE_NAME -headless & disown
    pkill -f firefox

    echo 'firefox-pwa profile installed'
    echo 'Installing firefox-pwa extension'
    
    cd $USER_ABSOLUTE_PATH/extensions/
    wget https://addons.mozilla.org/firefox/downloads/latest/firefoxpwa@filips.si/latest.xpi -O firefoxpwa@filips.si.xpi

    echo 'Installing ublock-origin extension'
    wget https://addons.mozilla.org/firefox/downloads/latest/uBlock0@raymondhill.net/latest.xpi -O uBlock0@raymondhill.net

    echo 'Installing firefox-pwa runtime'
    firefoxpwa runtime install

    echo 'Firefox-pwa is installed.'

# Start Firefox for installing custom PWA
[group('Experiment - Web Apps')]
start-firefox-pwa:
    #!/usr/bin/bash
    nohup firefox -P firefox-pwa -no-remote & disown

# Install Youtube as a PWA
[group('Experiment - Web Apps')]
install-youtube-pwa:
    #!/usr/bin/bash
    echo 'Creating a youtube profile'

    firefoxpwa profile create --name Youtube --description "Profile for youtube.com" >> /tpm/firefoxpwa-output-youtube
    cat /tpm/firefoxpwa-output-youtube | grep -o "01.*" >> ~/.local/share/firefoxpwa/profiles/id-youtube.txt

    YOUTUBE_PROFILE_ID=$(< ~/.local/share/firefoxpwa/profiles/id-youtube.txt)

    echo 'Youtube profile has been created with profile id ' && echo $YOUTUBE_PROFILE_ID

    echo 'Installing Youtube PWA'

    firefoxpwa site install https://www.youtube.com/manifest.webmanifest --profile $YOUTUBE_PROFILE_ID

    echo 'Youtube PWA installed.'
