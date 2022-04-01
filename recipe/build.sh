#!/bin/bash

set -ex

# strip std settings from conda
CXXFLAGS="${CXXFLAGS/-std=c++14/}"
CXXFLAGS="${CXXFLAGS/-std=c++11/}"
export CXXFLAGS

if [ "$target_platform" = "osx-arm64" ]; then
  export SKBUILD_CONFIGURE_OPTIONS=${CMAKE_ARGS/CMAKE_INSTALL_PREFIX/CMAKE_INSTALL_PREFIX_BAK}
  export CMAKE_OSX_ARCHITECTURES="arm64"
fi


set CMAKE_GENERATOR=Ninja
${PYTHON} -m pip install . -v
${PYTHON} -m pip install pdal-plugins=1.1.0 --no-binary :all:

ACTIVATE_DIR=$PREFIX/etc/conda/activate.d
DEACTIVATE_DIR=$PREFIX/etc/conda/deactivate.d
mkdir -p $ACTIVATE_DIR
mkdir -p $DEACTIVATE_DIR

cp $RECIPE_DIR/scripts/activate.sh $ACTIVATE_DIR/pdal-python-activate.sh
cp $RECIPE_DIR/scripts/deactivate.sh $DEACTIVATE_DIR/pdal-python-deactivate.sh
