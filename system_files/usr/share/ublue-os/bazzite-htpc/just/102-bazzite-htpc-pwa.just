#  vim: set ft=make :
########################
### bazzite-htpc-pwa.just
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
    nohup firefox -P $FIREFOX_PROFILE_NAME -headless >&/dev/null & wait 3s & kill `pidof firefox`


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

# Start Firefox with an specific profile for installing custom PWA
[group('Experiment - Web Apps')]
start-firefox-pwa url="":
    #!/usr/bin/bash
    WEBSITE_URL= "{{ url }}"
    nohup firefox -P firefox-pwa "${WEBSITE_URL}" -no-remote >&/dev/null &
    
# Use firefoxpwa to install websites as a application
[group('Experiment - Web Apps')]
get-web-app app="":
    #!/usr/bin/bash

    # Load ugum for interactive menu

    source /usr/lib/ujust/ujust.sh
    
    # Global variables

    SELECTION=""

    ID_FOLDER=~/.local/share/firefoxpwa/.id
    TEMP_FOLDER=/tmp/firefoxpwa

    PROFILE_ID_FOLDER="${ID_FOLDER}/profiles"
    PROFILE_ID_TEMP_FILE="${TEMP_FOLDER}/output-profile"

    PWA_ID_FOLDER="${ID_FOLDER}/pwa"
    PWA_ID_TEMP_FILE="${TEMP_FOLDER}/output-pwa"

    PWA_SHORTCUT_FOLDER="~/.local/share/applications/"
    PWA_PROFILE_ID=""
    PWA_ID=""
    PWA_SHORTCUT=""

    FLATPAK_ID=""
    FLATAPK_NAME=""
    FLATPAK_SHORTCUT=""


    # Display selector menu

    if [ -n "{{ app }}" ]; then
        SELECTION="{{ app }}"
    else
        echo -e "\n${bold}Select a web application to install and add to Steam:${normal}"
        SELECTION=$(ugum choose \
            "Youtube" \
            "Youtube Music" \
            "Twitch" \
            "Plex Media Player" \
            "Plex HTPC" \
            "Plex amp" \
            "Plex (IP)" \
            "Plex (plex.tv)" \
            "Jellyfin Media Player" \
            "Spotify" \
            "Steam (Web)" \
            "Cancel")
    fi
    # Exit if Cancel is selected
    
    if [ "$SELECTION" = "Cancel" ]; then
        echo "Exiting..."
        exit 
    fi

    # Installing selected pwa  
    install_pwa(){
        local INSTALLED=false

        # Variable for ID files
    
        PROFILE_ID_FILE="${PROFILE_ID_FOLDER}/${PROFILE_NAME,,}"
        PWA_ID_FILE="${PWA_ID_FOLDER}/${PWA_NAME,,}"
        

        # Checking if firefox-pwa is setup

        if [ ! -d "$ID_FOLDER" ]; then

            echo "Firefox-pwa is not setup correctly, running setup-firefox-pwa"
            sleep 1s
            ujust _setup-firefox-pwa
            sleep 3s

            if [ ! -d "$ID_FOLDER" ]; then
                echo "Firefox-pwa setup failed. Please delete the firefoxpwa profile folder and retry. Aborting!"
                exit 1
            fi
            echo "Firefox-pwa is setup correctly, resuming pwa setup"
        fi

        # Checking if the pwa exist

        if [ -f "$PWA_ID_FILE" ]; then
            echo "$PWA_NAME is already installed. Aborting!"
            exit 0
        fi

        # Checking if the directories exists

        if [ ! -d "$TEMP_FOLDER" ]; then
            echo "Creating temp directory..."
            mkdir $TEMP_FOLDER
        fi

        if [ ! -d "$PROFILE_ID_FOLDER" ]; then
            echo "$PROFILE_ID_FOLDER does not exist. Creating directory..."
            mkdir $PROFILE_ID_FOLDER
        fi
    
        if [ ! -d "$PWA_ID_FOLDER" ]; then
            echo "$PWA_ID_FOLDER does not exist. Creating directory..."
            mkdir $PWA_ID_FOLDER
        fi

        # Checking if steam is running else start it
    
        if [ ! pgrep -x "steam" >> /dev/null ] ; then
            echo "Steam is not running. Starting Steam..."
            nohup steam >&/dev/null &
            sleep 5s
        fi

        # Creating an profile for the PWA if it does not exist

        if [ ! -d "$PROFILE_ID_FILE" ]; then
            echo "No Profile for ${PWA_NAME} found. Creating profile."

            firefoxpwa profile create --name "${PROFILE_NAME}" --description "${PROFILE_DESCRIPTION}" >> $PROFILE_ID_TEMP_FILE
            cat $PROFILE_ID_TEMP_FILE | grep -o "01.*" >> $PROFILE_ID_FILE

            PWA_PROFILE_ID=$(< $PROFILE_ID_FILE)

            echo "An Profile for ${PWA_NAME} has been created with profile id $PWA_PROFILE_ID"
        else
            PWA_PROFILE_ID=$(< $PROFILE_ID_FILE)
            echo "An Profile id ($PWA_PROFILE_ID) for ${PWA_NAME} was found. Skipping profile creation."
        fi

        echo "Installing ${PWA_NAME} PWA"

        firefoxpwa site install "${PWA_MANIFEST_URL}" --profile "${PWA_PROFILE_ID}" >> $PWA_ID_TEMP_FILE
        cat $PWA_ID_TEMP_FILE | grep -o "01.*" >> $PWA_ID_FILE
    
        PWA_ID=$(< $PWA_ID_FILE)

        PWA_SHORTCUT="FFPWA-$PWA_ID.desktop"

        # checking if the pwa shortcut is installed

        cd ~/.local/share/applications/

        if [ ! -f "$PWA_SHORTCUT" ]; then
            echo "${PWA_NAME} PWA installation failed..."
            INSTALLED=false
        else
            echo "${PWA_NAME} PWA is installed."
            INSTALLED=true
        fi

        if ["$INSTALLED" = true] && ["$ADD_TO_STEAM"=true]; then
            add_to_steam
        fi

        echo "Cleaning up temporary files..."

        rm $PROFILE_ID_TEMP_FILE
        rm $PWA_ID_TEMP_FILE

        echo "Installation finished"
    }

    install_flatpak(){
        local INSTALLED=false

        if flatpak list | grep -q "${FLATPAK_ID}" ; then
            echo "${FLATAPK_NAME} is already installed"
            INSTALLED=true
        else
            if flatpak install --system -y "${FLATPAK_ID}"; then
                echo "${FLATAPK_NAME} is installed"
                INSTALLED=true
            else
                echo "Failed to install ${FLATAPK_NAME}. Please try again or install manually with:"
                echo "flatpak install --system ${FLATPAK_ID}"
                INSTALLED=false
            fi
        fi

        if ["$INSTALLED" = true] && ["$ADD_TO_STEAM" = true]; then
            add_to_steam
        fi
    }

    # Adding installed pwa to steam
    add_to_steam(){
        local APP_SHORTCUT=""
        local APP_NAME=""

        if "$IS_PWA" = true; then
            APP_SHORTCUT="${PWA_SHORTCUT_FOLDER}${PWA_SHORTCUT}"
            APP_NAME="${PWA_NAME}"
        elif "$IS_FLATPAK" = true; then
            APP_SHORTCUT="${FLATPAK_SHORTCUT}"
            APP_NAME="${FLATPAK_NAME}"
        fi

        steamos-add-to-steam $APP_SHORTCUT # For gamescope or BPM
        echo "Added ${APP_NAME} to Steam."
    }

    # Start firefoxpwa profile for terminal incompatible apps
    start_firefoxpwa(){
        nohup firefox -P firefox-pwa "${PWA_MANIFEST_URL}" -no-remote >&/dev/null &
    }

    # Process user's selection
    case "$SELECTION" in
        "Youtube" | "Youtube Music")
            IS_PWA=true

            # Profile Variables
            PROFILE_NAME=Youtube
            PROFILE_DESCRIPTION="Profile used for Youtube"

            # PWA Variables
            PWA_NAME="$SELECTION"
            if "$PWA_NAME" = "Youtube"; then
                PWA_MANIFEST_URL="https://www.youtube.com/manifest.webmanifest"
            else
                PWA_MANIFEST_URL="https://music.youtube.com/manifest.webmanifest"
            fi

            install_pwa
            ;;
        "Twitch")
            # IS_PWA=true

            # Profile Variables
            # PROFILE_NAME=Twitch
            # PROFILE_DESCRIPTION="Profile used for Twitch"

            # PWA Variables
            PWA_NAME=Twitch
            PWA_MANIFEST_URL="https://www.twitch.tv"

            # install_pwa
            echo "${PWA_NAME} is not installable through the shell. Install it through the addon. Starting firefox..."
            # ujust start-firefox-pwa "${PWA_MANIFEST_URL}"

            ;;
        "Plex (IP)" | "Plex (plex.tv)")
            IS_PWA=true

            # Profile Variables
            PROFILE_NAME="Plex"
            PROFILE_DESCRIPTION="Profile used for Plex"

            # PWA Variables
            if [ "$SELECTION" = "Plex (IP)"]; then
                PWA_NAME="Plex (Web)"
                PWA_MANIFEST_URL=$(gum input --prompt="Enter the address of your plex server: " --placeholder="http://<ip.adress:port> or http://<domain.address:port>" --prompt.italic --prompt.foreground 10 --cursor.foreground 10)
                    if ! echo "$PWA_MANIFEST_URL" | grep -q -e "http://" -e "https://"; then
                        echo "Incorrect syntax. Aborting!"
                        exit code 1
                    fi
            else
                PWA_NAME="Plex (plex.tv)"
                PWA_MANIFEST_URL="https://app.plex.tv/desktop"
            fi
            install_pwa
            ;;
        "Plex Media Player")
            IS_FLATPAK=true

            # Flatpak Variables
            FLATPAK_ID=tv.plex.PlexDesktop
            FLATPAK_NAME="Plex Media Player"
            FLATPAK_SHORTCUT="/var/lib/flatpak/app/tv.plex.PlexDesktop/x86_64/stable/active/export/share/applications/tv.plex.PlexDesktop"

            install_flatpak
            ;;
        "Plex HTPC")
            IS_FLATPAK=true

            # Flatpak Variables
            FLATPAK_ID=tv.plex.PlexHTPC
            FLATPAK_NAME="Plex HTPC"
            FLATPAK_SHORTCUT="/var/lib/flatpak/app/tv.plex.PlexHTPC/x86_64/stable/active/export/share/applications/tv.plex.PlexHTPC"

            install_flatpak
            ;;
        "Plex amp")
            IS_FLATPAK=true

            # Flatpak Variables
            FLATPAK_ID=com.plexamp.Plexamp
            FLATPAK_NAME="Plex amp"
            FLATPAK_SHORTCUT="/var/lib/flatpak/app/com.plexamp.Plexamp/x86_64/stable/active/export/share/applications/com.plexamp.Plexamp"

            install_flatpak
            ;;
        "Jellyfin Media Player")
            IS_FLATPAK=true

            # Flatpak Variables
            FLATPAK_ID=com.github.iwalton3.jellyfin-media-player
            FLATPAK_NAME="Jellyfin Media Player"
            FLATPAK_SHORTCUT="/var/lib/flatpak/app/com.github.iwalton3.jellyfin-media-player/x86_64/stable/active/export/share/applications/com.github.iwalton3.jellyfin-media-player"

            install_flatpak
            ;;
        "Spotify")
            IS_FLATPAK=true

            # Flatpak Variables
            FLATPAK_ID=com.spotify.Client
            FLATPAK_NAME="Spotify"
            FLATPAK_SHORTCUT="/var/lib/flatpak/app/com.spotify.Client/x86_64/stable/active/export/share/applications/com.spotify.Client"

            install_flatpak
            ;;
        "Steam (Web)")
            IS_PWA=true
            ADD_TO_STEAM=false # Forced to false as it makes no sense to be in gaming mode

            # Profile Variables
            PROFILE_NAME="Steam"
            PROFILE_DESCRIPTION="Profile used for Steam"

            # # PWA Variables
            PWA_NAME="Steam (Web)"
            PWA_MANIFEST_URL="https://store.steampowered.com"

            install_pwa
            ;;
        *)
            echo "Invalid selection. Aborting!"
            exit 1
            ;;
    esac
