#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTS_CLONE_DIR='/tmp/dotfiles'
LOCAL_DOTS_VERSION="$(cat ${HOME}/.config/assets/version)"
UPSTREAM_VERSION=$(curl https://raw.githubusercontent.com/rvsmooth/dotfiles/refs/heads/main/.config/assets/version)
BARE_REPO="${HOME}/.dotfiles"
BARE_REPO_BAK="${HOME}/.dotfiles-bak"
CONFIGS="${HOME}/.config"
CONFIGS_BAK="${HOME}/.config-bak"
LOCAL_DOTS_VINT=$(echo $LOCAL_DOTS_VERSION | tr -d '.')
UPSTREAM_VINT=$(echo $UPSTREAM_VERSION | tr -d '.')

source colors.sh

function prepare_env(){
	PYELL Backing up old config files into $CONFIGS_BAK
	rm -rf $DOTS_CLONE_DIR
	cp -rf $CONFIGS $CONFIGS_BAK
	PDONE
}

function bak_old_repo(){
	PYELL Backing up old bare git repo to $BARE_REPO_BAK
	rm -rf $BARE_REPO_BAK
	git clone $BARE_REPO $BARE_REPO_BAK
	rm -rf $BARE_REPO
	PDONE
}

function get_dots(){
	PYELL Installing dotfiles as a bare git repo
        git clone https://github.com/rvsmooth/dotfiles -b main $DOTS_CLONE_DIR
	cd $DOTS_CLONE_DIR || { PRED "Failed to navigate to dotfiles directory."; exit 1; }
	cp -rf .* * $HOME/ || { PRED "Failed to copy dotfiles."; exit 1; } 
	cd -
	mv -f $HOME/.git $BARE_REPO || { PRED "Failed to move .git directory."; exit 1; }
	PDONE
}

function update() {
	bak_old_repo
	prepare_env
	get_dots
}

function fresh_install() {
	prepare_env
	get_dots
}

function check_for_updates() {
	if [[ "$LOCAL_DOTS_VINT" < "$UPSTREAM_VINT" ]]; then
		export UPDATE_STATUS="-1"
	elif [[ "$LOCAL_DOTS_VINT" == "$UPSTREAM_VINT" ]]; then
		export UPDATE_STATUS="0"
	fi
}

if [[ -n "$LOCAL_DOTS_VERSION" ]]; then
	PYELL Checking installation of rvsmooth 
	PMAG Dotsmooth is installed already 
	sleep 1 
	echo
	PMAG Checking for Updates
	check_for_updates
	if [[ "$UPDATE_STATUS" == "-1" ]]; then
	        PBLUE Updates found 
		PYELL Updating rvsmooth dotfiles
		update
	elif [[ "$UPDATE_STATUS" == "0" ]]; then
		PGREEN Already Up to date
	fi
else
	PMAG Dotsmooth has not been installed 
	echo
	sleep 1
	PYELL Initiating Fresh installation
	sleep 1
	fresh_install
fi
