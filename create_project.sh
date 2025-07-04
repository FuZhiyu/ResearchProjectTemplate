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

# Create README
echo "Creating README..."
cat > README.md << EOF
# $PROJECT_NAME

Academic research project: $PROJECT_NAME

## Project Organization

The project is separated into two folders: \`$PROJECT_NAME\` and \`$PROJECT_SHARE_NAME\`, where:

- \`$PROJECT_NAME\` stores the codebase, final figure and table outputs that go into papers and slides, and LaTeX projects. It is version-controlled using *Git*.
- \`$PROJECT_SHARE_NAME\` stores data and intermediate outputs. It is synced across the group using *Dropbox* or other cloud storage.

All folders under \`$PROJECT_SHARE_NAME\` are soft-linked to \`$PROJECT_NAME\` (see the setup below), so all files are accessible under \`$PROJECT_NAME\`, and we can work directly in \`$PROJECT_NAME\`.

### Core Structure

#### In the Git Repo (\`$PROJECT_NAME\`)
- \`Code/\` - All analysis scripts and implementation
- \`Figures/\` - Final presentable charts, plots, and visualizations that we want to track the version with \`git\`
- \`Tables/\` - Final presentable result tables and summary statistics that we want to track with \`git\`
- \`Paper/\` - The LaTeX folder containing the draft
- \`Slides/\` - The LaTeX folder containing slides

#### In the Cloud Storage (\`$PROJECT_SHARE_NAME\`)
- \`Notes/\` - Research notes and documentation
- \`Data/\` - Raw and processed datasets. Typically read-only.
- \`Output/\` - Generated results and intermediate files

## Setup Instructions

### Prerequisites

- **macOS**: Homebrew installed ([https://brew.sh](https://brew.sh))
- **Git**: For cloning the repository
- **VSCode/Cursor**: Not necessary but highly recommended

### Installation

1. **Clone the repository** in the same parent directory as your \`$PROJECT_SHARE_NAME\` folder:
   \`\`\`bash
   # Navigate to the parent directory containing $PROJECT_SHARE_NAME
   cd /path/to/parent/directory
   
   # Clone the repository (or copy the project folder)
   cd $PROJECT_NAME
   \`\`\`

2. **Make the setup script executable and run it** (macOS only):
   \`\`\`bash
   chmod +x setup_mac.sh
   ./setup_mac.sh
   \`\`\`

   This script will:
   - Install \`uv\` (Python package manager) via Homebrew
   - Set up UV environment variable for consistent virtual environment location
   - Sync the Python project dependencies
   - Create symbolic links to folders from \`../$PROJECT_SHARE_NAME/\`
   - Configure VS Code settings for proper Python interpreter and environment paths
   - Initialize a git repository and create the initial commit

## Environment Management

The project uses [\`uv\`](https://docs.astral.sh/uv/) for Python environment management, which is installed by the setup script.

**Quick uv commands:**
- \`uv sync\` - Install all required dependencies from \`pyproject.toml\`
- \`uv run <command>\` - Run any command with project environment (e.g., \`uv run python script.py\`, \`uv run jupyter notebook\`)
- \`uv add package\` - Add a new dependency
- \`uv remove package\` - Remove a dependency

### Virtual Environment Location

The setup script configures \`uv\` to place virtual environments in \`~/.venvs/$PROJECT_NAME\` rather than within the project folder. This keeps the project directory clean and ensures consistent environment paths across different machines.

### VS Code Integration

The setup script automatically creates \`.vscode/settings.json\` with:
- \`python.defaultInterpreterPath\` - Points to the correct Python interpreter in the virtual environment
- \`terminal.integrated.env.osx\` - Sets \`UV_PROJECT_ENVIRONMENT\` for proper \`uv\` integration
- \`python.analysis.extraPaths\` - Ensures VS Code can find installed packages for IntelliSense

### Manual Setup (Alternative)

If you prefer manual setup or are not on macOS:

#### Python Environment
\`\`\`bash
# Install uv (if not using macOS setup script)
pip install uv

# Sync dependencies
uv sync
\`\`\`

#### Create Symbolic Links
\`\`\`bash
# Create links to all folders in the shared directory
for folder in ../$PROJECT_SHARE_NAME/*/; do
    ln -s "\$folder" "./\$(basename "\$folder")"
done
\`\`\`

### Verification

After setup, you should have:
- Python environment ready with \`uv sync\`
- Symbolic links to shared \`Notes\`, \`Data\`, and \`Output\` folders
- Local \`Code\`, \`Figures\`, \`Tables\`, \`Paper\`, and \`Slides\` folders in the repository

### Usage

- **Python**: Use \`uv run\` to execute Python scripts with the project environment
EOF

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