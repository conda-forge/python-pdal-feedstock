if ($ENV:PDAL_DRIVER_PATH) {
    $ENV:_CONDA_SET_PDAL_DRIVER_PATH=$ENV:PDAL_DRIVER_PATH
}

$ENV:PDAL_DRIVER_PATH="$ENV:PDAL_DRIVER_PATH;$ENV:CONDA_PREFIX\Lib\site-packages\pdal\;$ENV:CONDA_PREFIX\bin"
if (-Not (Test-Path $ENV:PDAL_DRIVER_PATH) ) {
     Remove-Item ENV:PDAL_DRIVER_PATH
}
