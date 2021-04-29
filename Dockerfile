FROM rocker/verse:3.6.3
%environment

  export OMPI_DIR=/opt/ompi
  export PATH="$OMPI_DIR/bin:$PATH"
  export LD_LIBRARY_PATH="$OMPI_DIR/lib:$LD_LIBRARY_PATH"
  export MANPATH="$OMPI_DIR/share/man:$MANPATH"
  export LC_ALL='C'

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    lbzip2 \
    libfftw3-dev \
    libgdal-dev \
    libgeos-dev \
    libgsl0-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libhdf4-alt-dev \
    libhdf5-dev \
    libjq-dev \
    liblwgeom-dev \
    libpq-dev \
    libproj-dev \
    libprotobuf-dev \
    libnetcdf-dev \
    libsqlite3-dev \
    libssl-dev \
    libudunits2-dev \
    netcdf-bin \
    postgis \
    protobuf-compiler \
    sqlite3 \
    tk-dev \
    unixodbc-dev

RUN install2.r --error \
    RColorBrewer \
    RandomFields \
    RNetCDF \
    classInt \
    deldir \
    gstat \
    hdf5r \
    lidR \
    mapdata \
    maptools \
    mapview \
    ncdf4 \
    proj4 \
    raster \
    rgdal \
    rgeos \
    rlas \
    sf \
    sp \
    spacetime \
    spatstat \
    spdep \
    geoR \
    geosphere \
    ## from bioconductor
    && R -e "BiocManager::install('rhdf5', update=FALSE, ask=FALSE)"

%post -c /bin/bash
# build MPI library
  echo "Installing Open MPI"
  export OMPI_DIR=/opt/ompi
  export OMPI_VERSION=4.0.4
  export OMPI_URL="https://download.open-mpi.org/release/open-mpi/v4.0/"
  export OMPI_FILE="openmpi-$OMPI_VERSION.tar.bz2"
  mkdir -p /mytmp/ompi
  mkdir -p /opt
  # Download
  cd /mytmp/ompi && wget -O openmpi-$OMPI_VERSION.tar.bz2 $OMPI_URL$OMPI_FILE
  tar -xjf openmpi-$OMPI_VERSION.tar.bz2
  # Compile and install
  cd /mytmp/ompi/openmpi-$OMPI_VERSION
  ./configure --prefix=$OMPI_DIR && make install
  # Set env variables so we can compile our application
  export PATH=$OMPI_DIR/bin:$PATH
  export LD_LIBRARY_PATH=$OMPI_DIR/lib:$LD_LIBRARY_PATH
  export MANPATH=$OMPI_DIR/share/man:$MANPATH
