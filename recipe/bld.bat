

:: %PYTHON% setup.py install -vv -- -DPython3_EXECUTABLE="%PYTHON%"
:: scikit-build only passes PYTHON_EXECUTABLE and doesn't pass Python3_EXECUTABLE
set UNIX_SP_DIR=%SP_DIR:\=/%
set CMAKE_ARGS=%CMAKE_ARGS% -DPDAL_DIR=$PREFIX -LAH --debug-find -DPYTHON3_NUMPY_INCLUDE_DIRS=%UNIX_SP_DIR%/numpy/core/include

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation

mkdir plugins
cd plugins
curl -OL https://files.pythonhosted.org/packages/0a/1c/c10b9ca583fbf31e5afa137a41f45472e26808df6e869a9cb1064923961c/pdal_plugins-1.5.2.tar.gz
tar xvf pdal_plugins-1.5.2.tar.gz
cd pdal_plugins-1.5.2

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
cd ../..

set ACTIVATE_DIR=%PREFIX%\etc\conda\activate.d
set DEACTIVATE_DIR=%PREFIX%\etc\conda\deactivate.d
mkdir %ACTIVATE_DIR%
mkdir %DEACTIVATE_DIR%

copy %RECIPE_DIR%\scripts\activate.bat %ACTIVATE_DIR%\pdal-python-activate.bat
if errorlevel 1 exit 1

copy %RECIPE_DIR%\scripts\deactivate.bat %DEACTIVATE_DIR%\pdal-python-deactivate.bat
if errorlevel 1 exit 1

:: Copy unix shell activation scripts, needed by Windows Bash users
copy %RECIPE_DIR%\scripts\activate.sh %ACTIVATE_DIR%\pdal-python-activate.sh
if errorlevel 1 exit 1

copy %RECIPE_DIR%\scripts\deactivate.sh %DEACTIVATE_DIR%\pdal-python-deactivate.sh
if errorlevel 1 exit 1

:: Copy powershell activation scripts
copy %RECIPE_DIR%\scripts\activate.ps1 %ACTIVATE_DIR%\pdal-python-activate.ps1
if errorlevel 1 exit 1

copy %RECIPE_DIR%\scripts\deactivate.ps1 %DEACTIVATE_DIR%\pdal-python-deactivate.ps1
if errorlevel 1 exit 1
