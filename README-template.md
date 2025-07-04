# ProjectExample

Academic research project: ProjectExample

This project is created using 

## Project Organization

The project is separated into two folders: `ProjectExample` and `ProjectExample-Share`, where 

- `ProjectExample` stores the codebase, publication-ready figure and table outputs that go into papers and slides, and LaTeX projects. It is version-controlled using *Git* and *Not* shared via cloud services. 
- `ProjectExample-Share` stores data, intermediate outputs, and other relevant documents. It is synced across the group using cloud services like *Dropbox*. 

All folders under `ProjectExample-Share` are soft-linked to `ProjectExample` (see the setup below), so all files are accessible under `ProjectExample`, and one can work directly in `ProjectExample` with access all folders. 

### Core Structure

#### In the Git Repo (`ProjectExample`)
- `Code/` - All analysis scripts and implementation
   - The subfolders are organized around different tasks, e.g., `DataCleaning`.
- `Figures/` - Final presentable charts, plots, and visualizations that we want to track the version with git
- `Tables/` - Final presentable result tables and summary statistics that we want to track with git
- `Paper/` - The LaTeX folder containing the draft
- `Slides/` - The LaTeX folder containing slides

#### In the Dropbox (`ProjectExample-Share`)
- `Notes/` - Research notes and documentation
- `Data/` - Raw and processed datasets. Typically read-only. 
- `Output/` - Generated results and intermediate files
    - This folder is organized with subfolders that have the same names as folders under `Code`.

## Setup Instructions

### Prerequisites

- **macOS**: Homebrew installed ([https://brew.sh](https://brew.sh))
- **Git**: For cloning the repository
- **VSCode/Cursor**: Not necessary but highly recommended

### Installation

1. **Clone the repository** in the same parent directory as your `ProjectExample-Share` folder:
   ```bash
   # Navigate to the parent directory containing ProjectExample-Share
   cd /path/to/parent/directory
   
   # Clone the repository (or copy the project folder)
   cd ProjectExample
   ```

2. **Make the setup script executable and run it** (macOS only):
   ```bash
   chmod +x setup_mac.sh
   ./setup_mac.sh
   ```

   This script will:
   - Install `uv` (Python package manager) via Homebrew
   - Set up UV environment variable for consistent virtual environment location
   - Sync the Python project dependencies
   - Create symbolic links to folders from `../ProjectExample-Share/`
   - Configure VS Code settings for proper Python interpreter and environment paths
   - Initialize a git repository and create the initial commit

### Manual Setup (Alternative)

If you prefer manual setup or are not on macOS:

#### Python Environment
```bash
# Install uv (if not using macOS setup script)
pip install uv

# Sync dependencies
export UV_PROJECT_ENVIRONMENT="$HOME/.venvs/$(basename "$PWD")"
uv sync
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
```

#### Create Symbolic Links
```bash
# Create links to all folders in the shared directory
for folder in ../ProjectExample-Share/*/; do
    ln -s "$folder" "./$(basename "$folder")"
done
```

### Verification

After setup, you should have:
- Python environment ready with `uv sync`
- Symbolic links to shared `Notes`, `Data`, and `Output` folders
- Local `Code`, `Figures`, `Tables`, `Paper`, and `Slides` folders in the repository
