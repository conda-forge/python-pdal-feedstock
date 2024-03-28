#!/bin/bash

set -ex

# strip std settings from conda
CXXFLAGS="${CXXFLAGS/-std=c++14/}"
CXXFLAGS="${CXXFLAGS/-std=c++11/}"
export CXXFLAGS

if [ "$target_platform" = "osx-arm64" ]; then
  export CMAKE_OSX_ARCHITECTURES="arm64"
fi


# scikit-build only passes PYTHON_EXECUTABLE and doesn't pass Python3_EXECUTABLE
export CMAKE_ARGS="${CMAKE_ARGS} -DPDAL_DIR=$PREFIX -LAH -DPython3_ROOT_DIR=$PREFIX Python3_EXECUTABLE=$Python3_EXECUTABLE -DPython3_EXECUTABLE=$Python3_EXECUTABLE"

${PYTHON} -m pip install . -v

mkdir plugins && cd plugins
curl -OL https://files.pythonhosted.org/packages/ef/a7/eff3213c29a2c5e2c3de594f2459412e3e11f7dff59ad52a8717810c8821/pdal-plugins-1.3.0.tar.gz
tar xvf pdal-plugins-1.3.0.tar.gz
cd pdal-plugins-1.3.0

#if [ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]; then
#rm $BUILD_PREFIX/lib/libpdal*
#rm $BUILD_PREFIX/lib/libpython*
#fi

${PYTHON} -m pip install . -vv
cd ../..

ACTIVATE_DIR=$PREFIX/etc/conda/activate.d
DEACTIVATE_DIR=$PREFIX/etc/conda/deactivate.d
mkdir -p $ACTIVATE_DIR
mkdir -p $DEACTIVATE_DIR

cp $RECIPE_DIR/scripts/activate.sh $ACTIVATE_DIR/pdal-python-activate.sh
cp $RECIPE_DIR/scripts/deactivate.sh $DEACTIVATE_DIR/pdal-python-deactivate.sh
