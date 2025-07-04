#!/bin/bash

# Project template generator for academic research projects
# Creates a new project with the same structure as this one

set -e  # Exit on any error

# Check if project name is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <project-name-or-path>"
    echo "Examples:"
    echo "  $0 MyResearchProject      # Creates in current directory"
    echo "  $0 ../MyResearchProject   # Creates in parent directory"
    echo "  $0 /path/to/MyProject     # Creates at absolute path"
    exit 1
fi

PROJECT_PATH="$1"

# Extract directory and project name
if [[ "$PROJECT_PATH" == */* ]]; then
    # Path contains directory
    PROJECT_DIR=$(dirname "$PROJECT_PATH")
    PROJECT_NAME=$(basename "$PROJECT_PATH")
    
    # Create and change to the project directory
    mkdir -p "$PROJECT_DIR"
    cd "$PROJECT_DIR"
else
    # Just a name, use current directory
    PROJECT_NAME="$PROJECT_PATH"
    PROJECT_DIR="."
fi

PROJECT_SHARE_NAME="${PROJECT_NAME}-Share"

echo "Creating project template for: $PROJECT_NAME"
echo "Location: $(pwd)"

# Create shared folders directory
mkdir -p "$PROJECT_SHARE_NAME"
cd "$PROJECT_SHARE_NAME"

# Create shared project structure
echo "Creating shared directories..."
mkdir -p Notes Data Output

echo "Created shared folder structure in $PROJECT_SHARE_NAME"

# Create code repository
cd ..
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

echo "Creating code project directories..."
mkdir -p Code Figures Tables Paper Slides

# Create Python pyproject.toml
echo "Creating Python environment..."
cat > pyproject.toml << EOF
[project]
name = "$(echo $PROJECT_NAME | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
version = "0.1.0"
description = "Academic research project: $PROJECT_NAME"
readme = "README.md"
requires-python = ">=3.9"
dependencies = []
EOF

# Create setup script
echo "Creating setup script..."
cat > setup_mac.sh << 'EOF'
#!/bin/bash

# Setup script for Mac users
# This script installs uv, syncs the Python project, and creates softlinks

set -e  # Exit on any error

echo "Setting up PROJECT_NAME_PLACEHOLDER project..."

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

# Create softlinks from ../PROJECT_NAME_PLACEHOLDER-Share/ to current directory
echo "Creating softlinks..."

# Define source and target directories
SOURCE_DIR="../PROJECT_NAME_PLACEHOLDER-Share"

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
EOF

# Replace placeholder with actual project name
sed -i '' "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" setup_mac.sh

# Make setup script executable
chmod +x setup_mac.sh

# Get the directory where create_project.sh is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create README from template
echo "Creating README..."
if [ -f "$SCRIPT_DIR/README-template.md" ]; then
    cp "$SCRIPT_DIR/README-template.md" README.md
    # Replace ProjectExample with actual project names
    sed -i '' "s/ProjectExample/$PROJECT_NAME/g" README.md
    sed -i '' "s/ProjectExample-Share/$PROJECT_SHARE_NAME/g" README.md
else
    echo "Warning: README-template.md not found, creating basic README"
    echo "# $PROJECT_NAME" > README.md
    echo "" >> README.md
    echo "Academic research project: $PROJECT_NAME" >> README.md
fi

# Create CLAUDE.md from template
echo "Creating CLAUDE.md..."
if [ -f "$SCRIPT_DIR/CLAUDE-template.md" ]; then
    cp "$SCRIPT_DIR/CLAUDE-template.md" CLAUDE.md
    # Replace ProjectExample with actual project names
    sed -i '' "s/ProjectExample/$PROJECT_NAME/g" CLAUDE.md
    sed -i '' "s/ProjectExample-Share/$PROJECT_SHARE_NAME/g" CLAUDE.md
else
    echo "Warning: CLAUDE-template.md not found, skipping CLAUDE.md creation"
fi

# Create initial symlinks to shared folders
echo "Creating initial symlinks..."
SOURCE_DIR="../$PROJECT_SHARE_NAME"
if [ -d "$SOURCE_DIR" ]; then
    for folder in "$SOURCE_DIR"/*; do
        if [ -d "$folder" ]; then
            folder_name=$(basename "$folder")
            ln -s "$SOURCE_DIR/$folder_name" "./$folder_name"
            echo "Created symlink: ./$folder_name -> $SOURCE_DIR/$folder_name"
        fi
    done
else
    echo "Warning: Shared directory $SOURCE_DIR not found"
fi

# Initialize git repository
echo "Initializing git repository..."
git init

# Create .gitignore
echo "Creating .gitignore..."
cat > .gitignore << EOF
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
.pytest_cache/
.coverage
.ipynb_checkpoints/
*.ipynb_checkpoints

# LaTeX
*.aux
*.log
*.out
*.toc
*.bbl
*.blg
*.synctex.gz
*.fdb_latexmk
*.fls
*.nav
*.snm
*.vrb
*.bcf
*.run.xml
*-blx.bib
*.dvi
*.ps
*.pdf
!figures/*.pdf

# Environment
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/
.python-version
.Rproj.user

# IDE
.idea/
*.swp
*.swo
*~
*.sublime-*

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
desktop.ini

# Project specific
Notes
Data
Output
sync/
uv.lock
*.tmp
*.bak
EOF

echo ""
echo "✅ Project template created successfully!"
echo ""
echo "Project structure:"
echo "📁 $PROJECT_SHARE_NAME/       - Shared folders (for cloud storage)"
echo "   ├── Notes/                 - Research notes"
echo "   ├── Data/                  - Datasets"
echo "   └── Output/                - Analysis results"
echo ""
echo "📁 $PROJECT_NAME/             - Code repository (for Git)"
echo "   ├── Code/                  - Source code"
echo "   ├── Figures/               - Final figures for papers"
echo "   ├── Tables/                - Final tables for papers"
echo "   ├── Paper/                 - Paper materials"
echo "   ├── Slides/                - Presentation materials"
echo "   ├── Notes/                 - (symlink to $PROJECT_SHARE_NAME/Notes)"
echo "   ├── Data/                  - (symlink to $PROJECT_SHARE_NAME/Data)"
echo "   ├── Output/                - (symlink to $PROJECT_SHARE_NAME/Output)"
echo "   ├── pyproject.toml         - Python environment"
echo "   ├── setup_mac.sh           - Setup script"
echo "   └── README.md              - Setup instructions"
echo ""
echo "Next steps:"
echo "1. cd $PROJECT_NAME"
echo "2. ./setup_mac.sh"
echo "3. Start coding in Code/ directory"