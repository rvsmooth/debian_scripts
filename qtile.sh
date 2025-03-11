#!/bin/bash 

qtile_packages=(
"alsa-utils"
"curl"
"libpangocairo-1.0-0"
"libxkbcommon-dev"
"libxkbcommon-x11-dev"
"python-dbus-dev"
"python3"
"python3-cairocffi"
"python3-pip"
"python3-v-sim"
"python3-venv"
"python3-xcffib"

)

user_packages=(
"feh"
"flameshot"
"kitty"
"pcmanfm"
"picom"
"redshift"
"rofi"
)

sudo apt-get update 

echo "Installing QTile..."
for package in ${qtile_packages[@]}; do
	sudo apt-get install -y ${package}
done

# set location of virtual directory
qtilevenv="$HOME/.local/src/qtile_venv"

# Setting up virtual environment for qtile.
python3 -m venv $qtilevenv 
mkdir ~/.local/bin/

# Git clone into virtual environment
git clone https://github.com/qtile/qtile.git $qtilevenv/qtile

# Install Qtile
$qtilevenv/bin/pip install $qtilevenv/qtile/.

# Install psutil
$qtilevenv/bin/pip install psutil pulsectl-asyncio

# Adding venv to correct path ~/.local/bin/qtile

ln -sf $qtilevenv/bin/qtile ~/.local/bin/

# Ensure /usr/share/xsessions directory exists
if [ ! -d /usr/share/xsessions ]; then
    sudo mkdir -p /usr/share/xsessions
    if [ $? -ne 0 ]; then
        echo "Failed to create /usr/share/xsessions directory. Exiting."
        exit 1
    fi
fi

# Adding qtile.desktop to Lightdm xsessions directory
echo "[Desktop Entry]
Name=Qtile
Comment=Qtile Session
Type=Application
Keywords=wm;tiling
Exec=/home/subham/.local/bin/qtile start" | sudo tee -a /usr/share/xsessions/qtile.desktop

echo "Done"


echo "Setting up dotfiles..."
source dots.sh

echo "Setting up sddm..."
source sddm.sh

echo "Installing nwg-look"
source nwg-look.sh

source nerdfonts.sh
