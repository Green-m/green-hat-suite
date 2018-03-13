@echo off
net session >nul 2>&1
if %errorLevel% == 0 (
	echo "Begin to install,please waiting some time"

	echo "Installing .net framework 4.5.2 ..."
	start /wait NDP452-KB2901907-x86-x64-AllOS-ENU.exe setup /log ./install.log /passive /promptrestart 

	echo "Installing visual c++ build tools ..."
	start /wait visualcppbuildtools_full.exe /log ./install.log

	echo "Installing ruby..."
	start /wait rubyinstaller-2.3.3-x64.exe 
	gem install os 

	echo "Installing tdm-gcc ... "
	start /wait tdm-gcc-5.1.0-3.exe 

	echo "Installing clang"
	start /wait LLVM-5.0.0-win32.exe 

	echo "Installing metasploit ..."
	start /wait msiexec /i metasploitframework-latest.msi /passive

	echo "Add mingw32 to system path "
	SET mingwpath=%~dp0mingw\mingw32\bin\
	setx PATH "%PATH%;%mingwpath%; " 
) 

else (
    echo "Failure: Need administartor permission, please run as admin again. "
)
