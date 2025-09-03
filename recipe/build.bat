

:: %PYTHON% setup.py install -vv -- -DPython3_EXECUTABLE="%PYTHON%"
:: scikit-build only passes PYTHON_EXECUTABLE and doesn't pass Python3_EXECUTABLE
set UNIX_SP_DIR=%SP_DIR:\=/%
set CMAKE_ARGS=%CMAKE_ARGS% -DPDAL_DIR=$PREFIX -LAH --debug-find -DPYTHON3_NUMPY_INCLUDE_DIRS=%UNIX_SP_DIR%/numpy/core/include

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation

mkdir plugins
cd plugins
curl -OL https://files.pythonhosted.org/packages/09/ea/cbc3c2b96b5cc3dba3a9c3cbc58bfaf65d6c45352c8eb38bd23ded2b0610/pdal_plugins-1.6.2.tar.gz
tar xvf pdal_plugins-1.6.2.tar.gz
cd pdal_plugins-1.6.2

%PYTHON% -m pip install . -vv --no-deps --no-build-isolation
cd ../..

set ACTIVATE_DIR=%PREFIX%\etc\conda\activate.d
set DEACTIVATE_DIR=%PREFIX%\etc\conda\deactivate.d
mkdir %ACTIVATE_DIR%
mkdir %DEACTIVATE_DIR%

sed "s#@PLUGIN_DIR_PATH@#%SP_DIR%\\pdal#g" %RECIPE_DIR%\scripts\activate.bat >> %ACTIVATE_DIR%\pdal-python-activate.bat
if errorlevel 1 exit 1

copy %RECIPE_DIR%\scripts\deactivate.bat %DEACTIVATE_DIR%\pdal-python-deactivate.bat
if errorlevel 1 exit 1

:: Copy unix shell activation scripts, needed by Windows Bash users
sed "s#@PLUGIN_DIR_PATH@#%SP_DIR%\\pdal#g" %RECIPE_DIR%\scripts\activate.sh >> %ACTIVATE_DIR%\pdal-python-activate.sh
if errorlevel 1 exit 1

copy %RECIPE_DIR%\scripts\deactivate.sh %DEACTIVATE_DIR%\pdal-python-deactivate.sh
if errorlevel 1 exit 1

:: Copy powershell activation scripts
sed "s#@PLUGIN_DIR_PATH@#%SP_DIR%\\pdal#g" %RECIPE_DIR%\scripts\activate.ps1 >> %ACTIVATE_DIR%\pdal-python-activate.ps1
if errorlevel 1 exit 1

copy %RECIPE_DIR%\scripts\deactivate.ps1 %DEACTIVATE_DIR%\pdal-python-deactivate.ps1
if errorlevel 1 exit 1
