#!/bin/bash

set -ex

export CXXFLAGS="${CXXFLAGS} -std=c++11"
if [ "$(uname)" == "Linux" ]; then
   export LDFLAGS="${LDFLAGS} -Wl,-rpath-link,${PREFIX}/lib"
fi

set CMAKE_GENERATOR=Ninja
${PYTHON} setup.py install -- -DPython3_EXECUTABLE="${PYTHON}" -- -vv 
