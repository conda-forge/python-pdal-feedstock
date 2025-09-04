#!/bin/bash

set -ex

# strip std settings from conda
CXXFLAGS="${CXXFLAGS/-std=c++14/}"
CXXFLAGS="${CXXFLAGS/-std=c++11/}"
export CXXFLAGS

if [ "$target_platform" = "osx-arm64" ]; then
  export CMAKE_OSX_ARCHITECTURES="arm64"
fi

PY_VERSION=$(${PYTHON} -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")

if [ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]; then
    rm $BUILD_PREFIX/lib/libpython*
fi

# scikit-build only passes PYTHON_EXECUTABLE and doesn't pass Python3_EXECUTABLE
export CMAKE_ARGS="${CMAKE_ARGS} -DPDAL_DIR=$PREFIX "

${PYTHON} -m pip install . -vv --no-deps --no-build-isolation

mkdir plugins && cd plugins
curl -OL https://files.pythonhosted.org/packages/af/b6/688aab3af699a94e72ba6fa3c40fe7d9cc23a5623b3b5ac653fd83f1b585/pdal_plugins-1.6.6.tar.gz
tar xvf pdal_plugins-1.6.6.tar.gz
cd pdal_plugins-1.6.6

${PYTHON} -m pip install . -vv --no-deps --no-build-isolation
cd ../..

ACTIVATE_DIR=$PREFIX/etc/conda/activate.d
DEACTIVATE_DIR=$PREFIX/etc/conda/deactivate.d
mkdir -p $ACTIVATE_DIR
mkdir -p $DEACTIVATE_DIR

sed "s#@PLUGIN_DIR_PATH@#${SP_DIR}/pdal#g" $RECIPE_DIR/scripts/activate.sh >> $ACTIVATE_DIR/pdal-python-activate.sh
cp $RECIPE_DIR/scripts/deactivate.sh $DEACTIVATE_DIR/pdal-python-deactivate.sh
