#!/bin/sh

# Add Repositories
addRepos() {
  sudo apt-get upgrade -y
  sudo add-apt-repository -y ppa:ubuntugis/ppa
  sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
  sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
  sudo apt-add-repository -y ppa:johanvdw/saga-gis
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
  sudo add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'
  sudo apt-get update -y
}

# install - UTILS
installUtils() {
  sudo apt-get install build-essential -y
  sudo apt-get install -y gcc-6 g++-6 clang-3.8 -y
  sudo apt-get install vim git subversion cmake pkg-config dialog -y
  sudo apt-get install python-imaging-tk -y
}

# install - QGIS
installQGIS() {
  sudo apt install qgis python-qgis qgis-plugin-grass -y
}

# install - SAGA 
installSAGA() {
  sudo apt-get install saga -y
}

# install - GDAL
installGDAL() {
  sudo apt-get install libproj-dev gdal-bin python-gdal libgdal-dev -y
}

# install R
installR() {
  sudo apt-get install r-base -y
  echo "install.packages('raster')" >> Rlibs.r
  echo "install.packages('rgdal')" >> Rlibs.r
  echo "install.packages('RStoolbox')" >> Rlibs.r
  echo "install.packages('rgeos')" >> Rlibs.r
  echo "install.packages('RQGIS')" >> Rlibs.r
  echo "install.packages('RSAGA')" >> Rlibs.r
  echo "install.packages('RODBC')" >> Rlibs.r
  echo "install.packages('leafletR')" >> Rlibs.r
  echo "install.packages('maps')" >> Rlibs.r
  echo "install.packages('landsat')" >> Rlibs.r
  echo "install.packages('rasterVis')" >> Rlibs.r
  echo "install.packages('devtools')" >> Rlibs.r
  echo "install.packages('bfast')" >> Rlibs.r
  echo "library(devtools)" >> Rlibs.r
  echo "install_github('loicdtx/bfastSpatial')" >> Rlibs.r
  echo "install_github('vwmaus/dtwSat')" >> Rlibs.r
  Rscript Rlibs.r
  rm Rlibs.r
}

# install - PostgreSQL/PostGIS
installPGIS() {
  sudo apt-get install postgresql postgresql-contrib -y
  sudo apt-get install postgis pgadmin3 -y
}
# install - GEOS
installGEOS() {
  wget http://download.osgeo.org/geos/geos-3.6.2.tar.bz2
  tar xjf geos-3.6.2.tar.bz2
  cd geos-3.6.2
  ./configure && make -j$processadores && sudo make install
  cd ..
  rm -rf geos-3.6.2
  rm geos-3.6.2.tar.bz2
}

#install - Mapnik
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

# install - Python Libs
installPyLibs() {
  sudo python -m pip install numpy scipy matplotlib pandas gdal rasterio fiona shapely google-api-python-client earthengine-api
}

processadores=$(nproc)
zenity --info --text '<span foreground="red" font="24">Welcome to the Awesome-Geospatial Installer</span>\n\n<i>Version: 0.1</i>'
echo $processadores
