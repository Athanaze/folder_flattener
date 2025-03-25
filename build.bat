@echo off
set APP_NAME=folder_flattener

:: Create build and dist directories
if not exist build mkdir build
if not exist dist mkdir dist

:: Check if Python is installed
where python >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Python 3 is required but not installed. Please install Python 3 and try again.
    exit /b 1
)

:: Check if pip is installed
python -m pip --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo pip is required but not installed. Please install pip and try again.
    exit /b 1
)

:: Install PyInstaller if not installed
python -c "import PyInstaller" >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Installing PyInstaller...
    python -m pip install pyinstaller
)

:: Build for Windows
echo Building executable for Windows...
python -m PyInstaller --name="%APP_NAME%" --onefile --windowed --add-data="*.py;." flat.py
if %ERRORLEVEL% equ 0 (
    echo Windows build completed. Executable is in dist/ directory.
) else (
    echo Build failed!
    exit /b 1
)

echo Build process completed!