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

    USER_ABSOLUTE_PATH=$HOME/.mozilla/firefox
    FIREFOX_PROFILE_NAME=firefox-pwa
    FIREFOX_PROFILE_PATH="${USER_ABSOLUTE_PATH}/${FIREFOX_PROFILE_NAME}"
    FIREFOX_PROFILE_FULL="${FIREFOX_PROFILE_NAME} ${FIREFOX_PROFILE_PATH}"

    echo 'Creating a specific profile for firefox-pwa'

    firefox -createprofile "${FIREFOX_PROFILE_FULL}" -no-remote
    nohup firefox -P $FIREFOX_PROFILE_NAME -headless & wait 3s & kill `pidof firefox`

    
    echo 'firefox-pwa profile installed'
    sleep 5s
    echo 'Installing firefox-pwa extension'
    
    cd "${FIREFOX_PROFILE_PATH}/extensions"

    wget https://addons.mozilla.org/firefox/downloads/latest/firefoxpwa@filips.si/latest.xpi -O firefoxpwa@filips.si.xpi

    echo 'Installing ublock-origin extension'
    wget https://addons.mozilla.org/firefox/downloads/latest/uBlock0@raymondhill.net/latest.xpi -O uBlock0@raymondhill.net.xpi

    echo 'Installing firefox-pwa runtime'
    firefoxpwa runtime install

    echo 'Preconfiguring firefox-pwa id folder'
    mkdir ~/.local/share/firefoxpwa/.id

    echo 'Firefox-pwa is installed.'

# Start Firefox for installing custom PWA
[group('Experiment - Web Apps')]
start-firefox-pwa:
    #!/usr/bin/bash
    nohup firefox -P firefox-pwa -no-remote >&/dev/null &

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

    firefoxpwa site install https://www.youtube.com/manifest.webmanifest --profile $YOUTUBE_PROFILE_ID >> /tmp/firefoxpwa
    rm /tmp/firefoxpwa-output-youtube

    echo 'Youtube PWA installed.'

# Install Youtube as a PWA
[group('Experiment - Web Apps')]
install-youtube-pwa-v2:
    #!/usr/bin/bash

    # Profiles Variables
    PROFILE_NAME=Youtube
    PROFILE_DESCRIPTION="Profile for youtube.com"
    PWA_PROFILE_ID=""

    # PWA Variables
    PWA_NAME=Youtube
    PWA_ID=""
    PWA_MANIFEST_URL="https://www.youtube.com/manifest.webmanifest"
    PWA_SHORTCUT=""

    # Files variables
    ID_FOLDER=~/.local/share/firefoxpwa/.id
    TEMP_FOLDER=/tmp/firefoxpwa
    PROFILE_ID_FOLDER="${ID_FOLDER}/profiles"
    PWA_ID_FOLDER="${ID_FOLDER}/pwa"
    PROFILE_ID_TEMP_FILE="${TEMP_FOLDER}/output-profile"
    PROFILE_ID_FILE="${PROFILE_ID_FOLDER}/${PROFILE_NAME,,}"
    PWA_ID_TEMP_FILE="${TEMP_FOLDER}/output-pwa"
    PWA_ID_FILE="${PWA_ID_FOLDER}/${PWA_NAME,,}"


    # Checking if firefox-pwa is setup

    if [ ! -d "$ID_FOLDER" ]; then
        echo "Firefox-pwa is not setup, please run ujust setup-firefox-pwa before. Aborting!"
        exit 0
    fi

    # Checking if the pwa exist

    if [ -f "$PWA_ID_FILE" ]; then
        echo "$PWA_ID_FILE is already installed. Aborting!"
        exit 0
    fi

    # Checking if the directories exists

    if [ ! -d "$PROFILE_ID_FOLDER" ]; then
        echo "$PROFILE_ID_FOLDER does not exist. Creating directory..."
        mkdir $PROFILE_ID_FOLDER
    fi
    
    if [ ! -d "$PWA_ID_FOLDER" ]; then
        echo "$PWA_ID_FOLDER does not exist. Creating directory..."
        mkdir $PWA_ID_FOLDER
    fi

    # Checking if steam is running else start it
    
    if ! pgrep -x "steam" >> /dev/null ; then
        echo "Steam is not running. Starting Steam..."
        nohup steam >&/dev/null &
        sleep 5s
    fi

    echo "Creating a profile for ${PWA_NAME}"

    mkdir /tmp/firefoxpwa

    firefoxpwa profile create --name "${PROFILE_NAME}" --description "${PROFILE_DESCRIPTION}" >> $PROFILE_ID_TEMP_FILE
    cat $PROFILE_ID_TEMP_FILE | grep -o "01.*" >> $PROFILE_ID_FILE

    PWA_PROFILE_ID=$(< $PROFILE_ID_FILE)

    echo "Profile for ${PWA_NAME} has been created with profile id $PWA_PROFILE_ID"

    echo "Installing ${PWA_NAME} PWA"

    firefoxpwa site install "${PWA_MANIFEST_URL}" --profile "${PWA_PROFILE_ID}" >> $PWA_ID_TEMP_FILE
    cat $PWA_ID_TEMP_FILE | grep -o "01.*" >> $PWA_ID_FILE
    
    PWA_ID=$(< $PWA_ID_FILE)

    PWA_SHORTCUT="FFPWA-$PWA_ID.desktop"

    # checking if the pwa shortcut is installed

    cd ~/.local/share/applications/

    if [ ! -f "$PWA_SHORTCUT" ]; then
        echo "${PWA_NAME} PWA installation failed..."
        installed=false
    else
        echo "${PWA_NAME} PWA is installed."
        installed=true
    fi

    if "$installed" = true; then
        steamos-add-to-steam $PWA_SHORTCUT # For gaming mode
        echo "Added ${PWA_NAME} to Steam."
    fi

    echo "Cleanup files..."

    rm $PROFILE_ID_TEMP_FILE
    rm $PWA_ID_TEMP_FILE

    echo "Installation finished"
    
