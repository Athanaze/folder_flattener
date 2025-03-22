#!/bin/bash

# Script to build executables for Text Extractor app

# Set application name
APP_NAME="folder_flattener"

# Create build and dist directories if they don't exist
mkdir -p build dist

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Python is installed
if ! command_exists python3; then
    echo "Python 3 is required but not installed. Please install Python 3 and try again."
    exit 1
fi

# Check if pip is installed
if ! command_exists pip3; then
    echo "pip3 is required but not installed. Please install pip and try again."
    exit 1
fi

# Install PyInstaller if not already installed
if ! python3 -c "import PyInstaller" &> /dev/null; then
    echo "Installing PyInstaller..."
    pip3 install pyinstaller
fi

# Determine operating system
OS="$(uname -s)"
case "${OS}" in
    Linux*)     BUILD_OS=linux;;
    Darwin*)    BUILD_OS=macos;;
    CYGWIN*|MINGW*|MSYS*)  BUILD_OS=windows;;
    *)          BUILD_OS=unknown;;
esac

echo "Detected OS: ${BUILD_OS}"
echo "Building executable for ${BUILD_OS}..."

# Build for the detected platform
if [ "$BUILD_OS" = "linux" ]; then
    python3 -m PyInstaller --name="${APP_NAME}" --onefile --windowed --add-data="*.py:." flat.py
    echo "Linux build completed. Executable is in dist/ directory."
elif [ "$BUILD_OS" = "macos" ]; then
    python3 -m PyInstaller --name="${APP_NAME}" --onefile --windowed --add-data="*.py:." --icon=icon.icns flat.py
    echo "macOS build completed. Application is in dist/ directory."
elif [ "$BUILD_OS" = "windows" ]; then
    python3 -m PyInstaller --name="${APP_NAME}" --onefile --windowed --add-data="*.py;." flat.py
    echo "Windows build completed. Executable is in dist/ directory."
else
    echo "Unsupported operating system for building."
    exit 1
fi

echo "Build process completed!" 