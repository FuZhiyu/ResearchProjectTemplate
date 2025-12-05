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

# Install dependencies
echo "Installing Python packages..."

# Common data analysis packages
echo "Installing data analysis packages..."
uv add jupyter pandas matplotlib polars pyarrow

# Add zotero-mcp git source to pyproject.toml before installing dependencies
if ! grep -q "^zotero-mcp.*git" pyproject.toml; then
    # Check if [tool.uv.sources] section exists
    if grep -q "\[tool.uv.sources\]" pyproject.toml; then
        # Uncomment the zotero-mcp line (remove leading # and spaces)
        sed -i '' 's/^# *zotero-mcp = { git.*/zotero-mcp = { git = "https:\/\/github.com\/54yyyu\/zotero-mcp.git" }/' pyproject.toml
    else
        # Section doesn't exist, add it
        echo "" >> pyproject.toml
        echo "[tool.uv.sources]" >> pyproject.toml
        echo "zotero-mcp = { git = \"https://github.com/54yyyu/zotero-mcp.git\" }" >> pyproject.toml
    fi
fi

# Claude skill dependencies
echo "Installing Claude skill dependencies..."
# PDF processing (for pdf skill)
uv add pypdf reportlab pdf2image pillow

# Mistral OCR (for mistral-pdf-to-markdown skill)
uv add mistralai

# Zotero integration (for zotero-paper-reader skill)
uv add python-dotenv zotero-mcp

# Sync to ensure everything is installed
uv sync

echo "All dependencies installed"

# Create .venv symlink to the actual virtual environment location
echo "Creating .venv symlink..."
if [ ! -e ".venv" ]; then
    ln -s "$HOME/.venvs/$(basename "$PWD")" .venv
    echo "Created .venv -> $HOME/.venvs/$(basename "$PWD") symlink"
else
    echo ".venv already exists, skipping"
fi

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
