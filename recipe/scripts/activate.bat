@REM Store existing PDAL env vars and set to this conda env
@REM so other PDAL installs don't pollute the environment

@if defined PDAL_DRIVER_PATH (
    set "_CONDA_SET_PDAL_PYTHON_DRIVER_PATH=%PDAL_DRIVER_PATH%"
)

python -m pdal --pdal-plugin-path > pdal-plugin-path
set /p PDAL_PLUGIN_PATH= < pdal-plugin-path
DEL pdal-plugin-path

@REM Support plugins if the plugin directory exists
@REM i.e if it has been manually created by the user
@set "PDAL_DRIVER_PATH=%_CONDA_SET_PDAL_PYTHON_DRIVER_PATH%;%PDAL_PLUGIN_PATH%


