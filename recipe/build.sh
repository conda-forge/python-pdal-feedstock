#!/bin/bash

set -ex

export CXXFLAGS="${CXXFLAGS} -std=c++11"
if [ "$(uname)" == "Linux" ]; then
   export LDFLAGS="${LDFLAGS} -Wl,-rpath-link,${PREFIX}/lib"
fi

set CMAKE_GENERATOR=Ninja
${PYTHON} setup.py install -vv -- -DPython3_EXECUTABLE="${PYTHON}" --

ACTIVATE_DIR=$PREFIX/etc/conda/activate.d
DEACTIVATE_DIR=$PREFIX/etc/conda/deactivate.d
mkdir -p $ACTIVATE_DIR
mkdir -p $DEACTIVATE_DIR

cp $RECIPE_DIR/scripts/activate.sh $ACTIVATE_DIR/pdal-python-activate.sh
cp $RECIPE_DIR/scripts/deactivate.sh $DEACTIVATE_DIR/pdal-python-deactivate.sh
