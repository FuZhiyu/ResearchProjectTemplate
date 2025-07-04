#!/bin/bash

# Setup script for Mac users
# This script installs uv, syncs the Python project, and creates softlinks

set -e  # Exit on any error

echo "Setting up ProjectExample project..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is not installed. Please install Homebrew first:"
    echo "https://brew.sh"
    exit 1
fi

# Install uv via Homebrew if not already installed
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    brew install uv
else
    echo "uv is already installed, skipping installation"
fi

# Set up UV environment variable for consistent venv location
export UV_PROJECT_ENVIRONMENT="$HOME/.venvs/$(basename "$PWD")"

# Sync the uv Python project
echo "Syncing uv Python project..."
uv sync

# Create softlinks from ../ProjectExample-Share/ to current directory
echo "Creating softlinks..."

# Define source and target directories
SOURCE_DIR="../ProjectExample-Share"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Warning: Source directory $SOURCE_DIR does not exist"
    echo "Skipping softlink creation"
else
    # Create softlinks for all folders in the shared directory
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
cat > .vscode/settings.json << VSCODE_EOF
{
    "python.defaultInterpreterPath": "\${env:HOME}/.venvs/\${workspaceFolderBasename}/bin/python",
    "terminal.integrated.env.osx": {
        "UV_PROJECT_ENVIRONMENT": "\${env:HOME}/.venvs/\${workspaceFolderBasename}"
    },
    "python.analysis.extraPaths": [
        "\${env:HOME}/.venvs/\${workspaceFolderBasename}/lib/python*/site-packages"
    ]
}
VSCODE_EOF

echo "VS Code settings configured at .vscode/settings.json"

# Initialize git repository if not already initialized
if [ ! -d .git ]; then
    echo "Initializing git repository..."
    git init
    
    # Add all files and make initial commit
    git add .
    git commit -m "Initial commit: $PROJECT_NAME research project setup"
    echo "Created initial git commit"
else
    echo "Git repository already initialized"
fi

echo "Setup complete!"
