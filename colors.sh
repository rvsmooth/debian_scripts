#!/usr/bin/env bash

# Color Codes
RESET='\033[0m'
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Color Functions
PRED() {
    echo -e "${RED}=> $@${RESET}"
}

PGREEN() {
    echo -e "${GREEN}=> $@${RESET}"
}

PYELL() {
    echo -e "${YELLOW}=> $@${RESET}"
}

PBLUE() {
    echo -e "${BLUE}=> $@${RESET}"
}

PMAG() {
    echo -e "${MAGENTA}=> $@${RESET}"
}

PCYAN() {
    echo -e "${CYAN}=> $@${RESET}"
}

ewhite() {
    echo -e "${WHITE}=> $@${RESET}"
}

PDONE() {
  sleep 1 && PGREEN Done... &&  echo && sleep 1
}

