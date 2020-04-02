
set CMAKE_GENERATOR=Ninja
%PYTHON% setup.py install -- -DPython3_EXECUTABLE="%PYTHON%" -- -vv 
REM %PYTHON% -m pip install dist\*.whl