#!/usr/bin/env bash

#############################################
## installs all instantOS tools            ##
#############################################

cd "$HOME"

echo "installing instantOS tools"

RAW="https://raw.githubusercontent.com"
source <(curl -s $RAW/paperbenni/bash/master/import.sh)
pb install
pb git

LINK="$RAW/paperbenni/suckless/master"

curl -s "$LINK/termprograms.txt" >.cache/termprograms.txt

if ! [ ~/.local/share/fonts/symbola.ttf ]; then
    mkdir -p .local/share/fonts
    cd .local/share/fonts
    echo "installing symbola font"
    wget -q "http://symbola.surge.sh/symbola.ttf"
fi

cd "$HOME"

# laptop specific stuff
if acpi | grep -q '[0-9]%' &>/dev/null; then
    # config file to indicate being a laptop
    touch .cache/islaptop
fi

cd

# auto start script with instantWM
ls .instantos &>/dev/null || mkdir .instantos
curl -s $LINK/autostart.sh >.instantos/autostart.sh
chmod +x .instantos/autostart.sh

cd /tmp
# drag and drop x utility for ranger
if ! command -v dragon &>/dev/null; then
    cd /tmp
    git clone --depth=1 https://github.com/mwh/dragon.git &>/dev/null
    cd dragon
    make
    make install
    cd ..
    rm -rf dragon
fi

cd
mkdir -p instantos/notifications &>/dev/null
cd instantos/notifications

# gets executed by dunst on notification
curl -s "$RAW/paperbenni/suckless/master/programs/dunsttrigger" >dunsttrigger
chmod +x dunsttrigger

if ! [ -e notification.ogg ]; then
    wget -qO notification.ogg "https://notificationsounds.com/notification-sounds/me-too-603/download/ogg"
fi

cd ~/instantos

rm -rf wallpapers
mkdir wallpapers
cd wallpapers
curl -s "$RAW/instantOS/instantWALLPAPER/master/wall.sh" >wall.sh
curl -s "$RAW/instantOS/instantWALLPAPER/master/offlinewall.sh" >offlinewall.sh
chmod +x *.sh
cd

# set instantwm as default for lightdm
echo '[Desktop]' >.dmrc
echo 'Session=instantwm' >>.dmrc
