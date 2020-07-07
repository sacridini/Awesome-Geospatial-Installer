#!/bin/bash

# ---------------------------------- [ start ] ------------------------------------
printf "\n ### Running PLANGEA Installer ### \n"
sudo apt-get install -y dialog; echo "Installed dialog without errors." >> plangea_installer.log

welcomeMsg() {
  dialog --title "PLANGEA" --msgbox "PLANGEA Installer v0.1 \n\n\n Pronto para instalar o PLANGEA? " 9 45;
  clear 
}
welcomeMsg

installUtils() {
  sudo apt-get install -y build-essential; echo "Installed build essential without errors." >> plangea_installer.log
  sudo apt-get install -y git; echo "Installed git without errors." >> plangea_installer.log
  sudo apt-get install -y tmux; echo "Installed tmux without errors." >> plangea_installer.log
  sudo apt-get install -y htop; echo "Installed htop without errors." >> plangea_installer.log
  sudo apt-get install -y vim; echo "Installed vim without errors." >> plangea_installer.log
  sudo apt-get install -y libudunits2-dev; echo "Installed libudunits2 without errors." >> plangea_installer.log
  sudo apt-get install -y libssl-dev; echo "Installed libssl without errors." >> plangea_installer.log
  sudo apt-get install -y libcairo2-dev; echo "Installed libcairo without errors." >> plangea_installer.log
  sudo apt-get install -y libopenblas-dev;  echo "Installed libopenblas without errors." >> plangea_installer.log
  sudo apt-get install -y liblapack-dev; echo "Installed liblapack without errors." >> plangea_installer.log
  sudo apt-get install -y python-dev; echo "Installed python without errors." >> plangea_installer.log
  sudo apt-get install -y r-base-dev; echo "Installed R without errors." >> plangea_installer.log
  sudo apt-get install -y gdal-bin; echo "Installed gdal (bin) without errors." >> plangea_installer.log
  sudo apt-get install -y libgdal-dev; echo "Installed gdal (dev) without errors." >> plangea_installer.log
  sudo apt-get install -y coinor-libsymphony*; echo "Installed symphony without errors." >> plangea_installer.log
  sudo apt-get install -y coinor-libsymphony-dev; echo "Installed symphony dev without errors." >> plangea_installer.log
}

installPlangea() {
  instp=$(dialog --title "PLANGEA" --menu "What branch to install?" 0 0 3 \
        1 "master"\
        2 "dev" --stdout); clear
  
  plangea_path=$(dialog --title "PLANGEA" --inputbox "Especifique o path para fazer o clone do pacote: " 0 0 "./" --stdout); clear
  
  if [instp == 1]
  then
    cd $plangea_path
    git clone https://github.com/IIS-Rio/plangea-pkg
  else
     cd $plangea_path
     git clone https://github.com/IIS-Rio/plangea-pkg
     cd plangea-pkg
     git checkout dev
     cd ..
  fi
  echo "Created plangea clone @ $plangea_path" >> plangea_installer.log
}

installRLibs() {
  echo 'install.packages("devtools")' >> install_R_packages.R
  echo 'install.packages("jsonlite")' >> install_R_packages.R
  echo 'install.packages("rgdal")' >> install_R_packages.R
  echo 'install.packages("tidyverse")' >> install_R_packages.R
  echo 'install.packages("sf")' >> install_R_packages.R
  echo 'install.packages("raster")' >> install_R_packages.R
  echo 'install.packages("slam")' >> install_R_packages.R
  echo 'install.packages("Rsymphony")' >> install_R_packages.R
  sudo Rscript install_R_packages.R
  echo "Installed R packages without errors." >> plangea_installer.log
  rm install_R_packages.R
}

installGurobi() {
  gurobi_path=$(dialog --title "PLANGEA" --inputbox "Where is the gurobi .tar.gz installer file?" 0 0)
  tar xvfz $gurobi_path /opt
  gurobi_folder_name=$(ls /opt | grep gurobi)  
  export PATH="${PATH}:/opt/$gurobi_folder_name/linux64/bin"
  echo 'install.packages("/opt/gurobi902/linux64/R/gurobi_9.0-2_R_3.6.1.tar.gz", repos=NULL)' >> install_R_packages.R
  sudo Rscript install_R_packages.R
  rm install_R_packages.R
  cd /opt/$gurobi_folder_name/linux64/bin
  key=$(dialog --title "PLANGEA" --inputbox "Enter your gurobi key" 0 0)
  grbgetkey $key
}

finish() {
  dialog --title "PLANGEA" --infobox "Instalação concluída com sucesso!" 5 40;
  sleep 2;
  clear;
  dialog --title "PLANGEA" --infobox "Team Tarrasque Riders 2020" 5 30;
  sleep 3;
  clear
}

showMenu() {
 escolha=$(dialog --menu "What to install?:" 20 60 6\
        1 "Utils (htop, tmux, gdal, R, Python, etc)"\
        2 "R Packages" \
        3 "Gurobi"\
        4 "Clone Plangea from Git"\
        5 "All"\
        6 "None" --stdout); clear
 
 if [ $escolha == 1 ]; then
   installUtils
 elif [ $escolha == 2 ]; then
   installRLibs
 elif [ $escolha == 3 ]; then
   installGurobi
 elif [ $escolha == 4 ]; then
   installPlangea
 elif [ $escolha == 5 ]; then
   installUtils
   installRLibs
   installGurobi
   installPlangea
   finish
 elif [ $escolha == 6 ]; then
   finish
 fi
}
showMenu
