#!/bin/bash

# source colors script
source colors.sh

# functions
__zypper_install(){
	local pkgs=("$@")
	local missing_packages=("")

	for pkg in "${pkgs[@]}"; do 
		if ! zypper search --installed-only | awk '{print $3}' | grep "$pkg" > /dev/null 2>&1; then 
			missing_packages+=("$pkg")
		fi
	done


        PYELL Installing ${missing_packages[@]}
	sudo zypper --non-interactive --no-gpg-checks install --auto-agree-with-licenses --no-recommends "${missing_packages[@]}" 
}

# arrays
hw_decoding_pkgs=(
	"intel-gpu-tools" 
	"intel-media-driver"
	"intel-vaapi-driver"
	"libva-vdpau-driver"
	"libva-utils"
)

audio_pkgs=(
	"alsa-utils"
	"pavucontrol"
	"pipewire"
	"pipewire-alsa"
	"pipewire-aptx"
	"pipewire-jack"
	"pipewire-libjack-0_3"
	"pipewire-modules-0_3"
	"pipewire-pulseaudio"
	"pipewire-spa-plugins-0_2"
	"pipewire-spa-tools"
	"pipewire-tools"
)

wm_pkgs=(
	"qtile"
	"python313-psutil"
	"feh"
	"redshift"
	"picom"
	"flameshot"
	"xclip"
	"sddm"
)

user_pkgs=(
	"kitty"
	"rofi"
        "calibre"
	"flatpak"
	"btop"
	"neovim"
	"qbittorrent"
	"libreoffice"
	"npm"
	"android-tools"
	"ddcutil"
	"pcmanfm"
	"mtpfs"
	"gvfs"
	"engrampa"
	"fortune"
	"starship"
	"usbutils"
	"viewnior"
	"fish"
	"libappindicator3-1"
	"mpv"
	)

DIRS=(
	"Android"
	"Documents"
	"Downloads"
	"Media"
	"Music"
	"Pictures"
	"Projects"
)

# prep + base packages
# codecs, bluetooth
# audio packages
# window manager packages
# user packages 
# display manager 

#
# execution
#

sudo zypper refresh
sudo zypper --non-interactive update  


PYELL Preparing environment for upcoming transactions
__zypper_install curl git unzip wget zip opi
PDONE 


PYELL Setting up codecs and hardware acceleration
opi -n codecs > /dev/null 2>&1
__zypper_install "${hw_decoding_pkgs[@]}"
PDONE

PYELL Installing audio packages and bluetooth packages 
__zypper_install "${audio_pkgs[@]}"
__zypper_install bluez  
sudo systemctl enable bluetooth.service
PDONE

PYELL Installing window manager packages
__zypper_install "${wm_pkgs[@]}"

PYELL Installing user packages
__zypper_install "${user_pkgs[@]}"

PDONE

echo "[General]
  contrastOpacity=188
  savePath=/home/$(whoami)/Pictures/screenshots
  savePathFixed=true

  [Shortcuts]
  TYPE_SAVE=Return" | tee "$FLAMESHOT_INI_DIR"
PDONE
else
	echo
fi

# setup bluetooth
PYELL Setting Up Bluetooth......
sudo systemctl enable bluetooth --now
PDONE

# Create bookmarks
PYELL Setting Up Bookmarks of Filemanager
for dir in ${DIRS[@]}; do
	mkdir "$HOME"/"$dir"
	echo "file:///home/$(whoami)/$dir" | tee -a "$GTK3_DIR"/bookmarks
done
PDONE

# change user shell
PYELL Changing User shell to fish......
sudo chsh "$USER" -s /usr/bin/fish
PDONE

PYELL Setup dotfiles
source dots.sh
PDONE

PYELL Enable sddm 
sudo systemctl enable sddm 
PDONE 

