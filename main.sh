#!/bin/bash

# ---------------------------------- [ start ] ------------------------------------
printf "\n\n ### Running PLANGEA Installer ### \n\n"
printf "- Installing Dialog \n\n"
sudo apt-get install -y dialog

welcomeMsg() {
  dialog --title "PLANGEA" --infobox "PLANGEA Installer v0.1 \n\n\n Use the keyboard to select items" 9 45; sleep 1; clear 
}

installUtils() {
  sudo apt-get install -y build-essential
  sudo apt-get install -y git
  sudo apt-get install -y tmux
  sudo apt-get install -y htop
  sudo apt-get install -y vim
  sudo apt-get install -y libudunits2-dev
  sudo apt-get install -y libssl-dev
  sudo apt-get install -y libcairo2-dev
  sudo apt-get install -y libopenblas-dev 
  sudo apt-get install -y liblapack-dev
  sudo apt-get install -y python-dev
  sudo apt-get install -y r-base-dev
  sudo apt-get install -y gdal-bin
  sudo apt-get install -y libgdal-dev
}

welcomeMsg
installUtils
