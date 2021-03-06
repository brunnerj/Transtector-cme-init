#!/bin/bash

CME_INIT_PN=1500-004

SRC=$(pwd) # project source code
SRCDIST=$(pwd)/srcdist # source copied here for building
DIST=$(pwd)/dist # built code ends up here

# Read the VERSION file to use in the created archive name
VERSION=$(<${SRC}/VERSION)

PACKAGE=${CME_INIT_PN}-v${VERSION}-SWARE-CME_INIT.tgz

# Point PIP env paths to wheelhouse
export WHEELHOUSE=${DIST}/wheelhouse
export PIP_WHEEL_DIR=$WHEELHOUSE
export PIP_FIND_LINKS=$WHEELHOUSE

# Make the SRCDIST and DIST directories
mkdir ${SRCDIST}  # source files copied here for the build
mkdir -p ${WHEELHOUSE} # PIP stores the built wheels here

# Copy source files over to srcdist/
# Note: this is to avoid wheel adding a bunch of files and
# directories that are not needed in the distribution.
pushd ${SRCDIST}
cp -R ${SRC}/cmeinit/ .
cp ${SRC}/VERSION .
cp ${SRC}/setup.py .

# Activate the venv
source ${SRC}/cmeinit_venv/bin/activate

# Generate the wheels for the application.
# These will show up in WHEELHOUSE
pip wheel .

popd
cp ${SRCDIST}/VERSION ${DIST} # copy VERSION
rm -rf ${SRCDIST} # done w/srcdist

# Now generate the archive of the wheels
pushd ${DIST}

tar -czvf ../build/${PACKAGE} .

# Done with the built distribution
popd
rm -rf ${DIST}

echo "Done!"
