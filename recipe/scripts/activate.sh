#!/bin/bash

# Store existing PDAL env vars and set to this conda env
# so other PDAL installs don't pollute the environment

if [[ -n "$PDAL_DRIVER_PATH" ]]; then
    export _CONDA_SET_PDAL_PYTHON_DRIVER_PATH=$PDAL_DRIVER_PATH
fi

SITE_PACKAGES=$(python -c 'import site; print(site.getsitepackages()[0])')
export PDAL_DRIVER_PATH=$_CONDA_SET_PDAL_PYTHON_DRIVER_PATH:$SITE_PACKAGES/lib:$SITE_PACKAGES/lib64

# Support plugins if the plugin directory exists
# i.e if it has been manually created by the user
if [[ ! -d "$PDAL_DRIVER_PATH" ]]; then
    unset PDAL_DRIVER_PATH
fi

