#!/bin/bash

# Setup script for Mac users
# This script installs uv, syncs the Python project, and creates softlinks

set -e  # Exit on any error

echo "Setting up IntermediaryDemand project..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is not installed. Please install Homebrew first:"
    echo "https://brew.sh"
    exit 1
fi

# Install uv via Homebrew
echo "Installing uv..."
brew install uv

# Set up UV environment variable for consistent venv location
export UV_PROJECT_ENVIRONMENT="$HOME/.venvs/$(basename "$PWD")"

# Sync the uv Python project
echo "Syncing uv Python project..."
uv sync

# Create softlinks from ../IntermediaryDemand/ to current directory
echo "Creating softlinks..."

# Define source and target directories
SOURCE_DIR="../IntermediaryDemand-Share"


# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Warning: Source directory $SOURCE_DIR does not exist"
    echo "Skipping softlink creation"
else
    # Create softlinks for all folders in the IntermediaryDemand directory
    for folder in "$SOURCE_DIR"/*; do
        if [ -d "$folder" ]; then
            folder_name=$(basename "$folder")
            if [ -L "./$folder_name" ]; then
                echo "Softlink ./$folder_name already exists, skipping"
            else
                ln -s "$SOURCE_DIR/$folder_name" "./$folder_name"
                echo "Created softlink: ./$folder_name -> $SOURCE_DIR/$folder_name"
            fi
        fi
    done
fi

# Create VS Code settings directory and configuration
echo "Setting up VS Code configuration..."
mkdir -p .vscode

# Create VS Code settings.json with proper Python interpreter path
cat > .vscode/settings.json << EOF
{
    "python.defaultInterpreterPath": "\${env:HOME}/.venvs/\${workspaceFolderBasename}/bin/python",
    "terminal.integrated.env.osx": {
        "UV_PROJECT_ENVIRONMENT": "\${env:HOME}/.venvs/\${workspaceFolderBasename}"
    },
    "python.analysis.extraPaths": [
        "\${env:HOME}/.venvs/\${workspaceFolderBasename}/lib/python*/site-packages"
    ]
}
EOF

echo "VS Code settings configured at .vscode/settings.json"
echo "Setup complete!"