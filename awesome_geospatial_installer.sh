#! /bin/bash
# awesome_geospatial_installer.sh
# 
# author: Eduardo R. Lacerda
# email: elacerda@id.uff.br

# ---------------------------------- [ start ] ------------------------------------

echo "----------------- [Initializing Awesome-Geospatial Installer] -----------------"
echo "----------------- Author:   Eduardo Lacerda, eduardolacerdageo@gmail.com -----------------"
processadores=$(nproc)

addRepos() {
    sudo add-apt-repository ppa:ubuntugis/ppa
    sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
    sudo add-apt-repository ppa:grass/grass-devel
    sudo apt-get update
}

installDialog() {
    sudo apt-get install dialog
}

welcomeMsg() {
    dialog --title "AGI" --infobox "Awesome-Geospatial Installer \n\n\n Use the keyboard to select items" 9 45; sleep 2 
}

ubuntuVersion() {
    version=$(dialog --stdout --title "Awesome-Geospatial Installer" --menu "Choose your Ubuntu version:" 0 0 15 \
    1 "Zesty (17.04)" \
    2 "Yakkety (16.10)" \
    3 "Xenial (16.04)" \
    4 "Trusty (14.04)" \
    5 "Precise (12.04)")
}

# ------------------------------ [ install utils ] ---------------------------------

installUtils() {
    sudo apt-get install -y build-essential
    sudo apt-get install -y gcc-6 g++-6 clang-3.8 -y
    sudo apt-get install -y cmake
    sudo apt-get install -y git
    sudo apt-get install -y htop
    sudo apt-get install -y xterm
    sudo apt-get install -y vim
    sudo apt-get install -y pkg-config
    sudo apt-get install -y python-dev
    sudo apt-get install -y libgtk2.0-dev
    sudo apt-get install -y libavcodec-dev
    sudo apt-get install -y libavformat-dev
    sudo apt-get install -y libswscale-dev
    sudo apt-get install -y libtbb2
    sudo apt-get install -y libtbb-dev
    sudo apt-get install -y libjpeg-dev
    sudo apt-get install -y libpng-dev
    sudo apt-get install -y libtiff-dev
    sudo apt-get install -y libjasper-dev
    sudo apt-get install -y libdc1394-22-dev
    sudo apt-get install -y libfontconfig1
    sudo apt-get install -y mesa-common-dev
    sudo apt-get install -y libglu1-mesa-dev
}

# ------------------------------ [ install GDAL/OGR ] ---------------------------------

installGDAL() {
    sudo apt-get install -y libproj-dev # lib proj   
    sudo apt-get install -y libgdal-dev    sudo apt-get install -y libgdal-dev
    sudo apt-get install -y gdal-bin
    sudo apt-get install -y python-gdal
}

# ------------------------------ [ install GRASS GIS ] ---------------------------------

installGRASS() {
  sudo apt-get install -y grass
}

# ------------------------------ [ install QGIS ] ---------------------------------

installQGIS() {
    sudo apt-get install -y qgis
    sudo apt-get install -y python-qgis
    sudo apt-get install -y qgis-plugins-grass
}

# ------------------------------ [ install SAGA ] ---------------------------------

installSAGA() {
  sudo apt-get install saga -y
}}
 
# ------------------------------ [ install GEOS ] ---------------------------------

installGEOS() {
    wget http://download.osgeo.org/geos/geos-3.6.2.tar.bz2
    tar xjf geos-3.6.2.tar.bz2
    cd geos-3.6.2
    ./configure
    make
    sudo make install
    cd ..
    rm -rf geos-3.6.2
    rm -rf geos-3.6.2.tar.bz2
}

# ------------------------------ [ install SQLite ] ---------------------------------

installSQLite() {
  sudo apt-get install -y sqlite3 libsqlite3-dev
}

# ------------------------------ [ install PostgreSQL ] ---------------------------------

installPGSQL() {
    if test $version == 1
    then
        sudo apt-get install -y postgresql-9.6
        sudo apt-get install -y postgresql-9.6-postgis-2.3
        sudo apt-get install -y postgresql-contrib-9.6
        sudo apt-get install -y postgresql-9.6-pgrouting
        return
    elif test $version == 2 
    then
        sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt xenial-pgdb main"
    elif test $version == 3
    then
        sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt xenial-pgdb main"
    elif test $version == 4
    then
        sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt trusty-pgdb main"
    else test $version == 5
    then
        sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt precise-pgdb main"
    fi

        wget --quiet -O - http://www.postgresql.org/media/keys/ACCC4CF8.asc | \
            sudo apt-key add -
        sudo apt-get update
        sudo apt-get install -y postgresql-9.6
        sudo apt-get install -y postgresql-9.6-postgis-2.3
        sudo apt-get install -y postgresql-contrib-9.6
        sudo apt-get install -y postgresql-9.6-pgrouting
}

# ------------------------------ [ install libpqxx ] ---------------------------------

installPQXX() {
    wget http://pqxx.org/download/software/libpqxx-4.0.tar.gz
    tar xvfz libpqxx-4.0.tar.gz
    cd libpqxx-4.0
    ./configure
    make
    sudo make install
    cd ..
    rm -rf libpqxx-4.0
    rm -rf libpqxx-4.0.tar.gz
}

# ------------------------------ [ install Mapnik ] ---------------------------------

installMapnik() {
  export CXX="clang++-3.8" && export CC="clang-3.8"
  git clone https://github.com/mapnik/mapnik mapnik-3.x --depth 10
  cd mapnik-3.x
  git submodule update --init
  sudo apt-get install python zlib1g-dev clang make pkg-config curl
  source bootstrap.sh
  ./configure CUSTOM_CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" CXX=${CXX} CC=${CC}
  make -j$processadores
  make test
  sudo make install
  cd ..
  rm -rf mapnik-3.x
}

welcomeMsg
ubuntuVersion
addRepos
installUtils
installGDAL
installGRASS
installQGIS
installSAGA
installGEOS
installSQLite
installPGSQL
installPQXX
installMapnik