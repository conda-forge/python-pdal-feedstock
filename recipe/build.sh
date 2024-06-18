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
    rm $BUILD_PREFIX/lib/libpdal*
    rm $BUILD_PREFIX/lib/libpython*
fi

# scikit-build only passes PYTHON_EXECUTABLE and doesn't pass Python3_EXECUTABLE
export CMAKE_ARGS="${CMAKE_ARGS} -DPDAL_DIR=$PREFIX -LAH -DPython3_NumPy_INCLUDE_DIR=$PREFIX/lib/python${PY_VERSION}/site-packages/numpy/core/include/"

${PYTHON} -m pip install . -vv --no-deps --no-build-isolation

mkdir plugins && cd plugins
curl -OL https://files.pythonhosted.org/packages/17/67/0190c89b2af7e322f3558290ca94cdbc502e8ad882af1f4daf3268480a01/pdal_plugins-1.5.1.tar.gz
tar xvf pdal_plugins-1.5.1.tar.gz
cd pdal_plugins-1.5.1

${PYTHON} -m pip install . -vv --no-deps --no-build-isolation
cd ../..

ACTIVATE_DIR=$PREFIX/etc/conda/activate.d
DEACTIVATE_DIR=$PREFIX/etc/conda/deactivate.d
mkdir -p $ACTIVATE_DIR
mkdir -p $DEACTIVATE_DIR

cp $RECIPE_DIR/scripts/activate.sh $ACTIVATE_DIR/pdal-python-activate.sh
cp $RECIPE_DIR/scripts/deactivate.sh $DEACTIVATE_DIR/pdal-python-deactivate.sh
