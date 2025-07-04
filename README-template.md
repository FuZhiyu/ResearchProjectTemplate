# ProjectExample

Academic research project created with [ResearchProjectTemplate](https://github.com/FuZhiyu/ResearchProjectTemplate).

For design principles and best practices, see the [template documentation](https://github.com/FuZhiyu/ResearchProjectTemplate).


## Project Organization

Projects use a two-folder structure:

- `ProjectExample/` - Git repository containing code, final figures/tables, and LaTeX documents
- `ProjectExample-Share/` - Dropbox-synced folder with data, notes, and intermediate outputs

Folders from `ProjectExample-Share/` are symlinked into `ProjectExample/`, so you work in one place with access to everything.


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

1. **Clone the repository and run setup**:
   ```bash
   cd /Parent/Folder/of/ProjectExample-Share
   git clone <repository-url>
   cd ProjectExample
   ./setup_mac.sh
   ```

   The setup script will:
   - Create symbolic links to folders from `../ProjectExample-Share/`
   - Setup `uv` to manage the Python project dependencies
   - Configure VS Code settings for proper Python interpreter and environment paths

### Manual Setup (Alternative)

If you prefer manual setup or are not on macOS:

#### Python Environment
```bash
# Install uv (if not using macOS setup script)
pip install uv

# Sync dependencies
export UV_PROJECT_ENVIRONMENT="$HOME/.venvs/$(basename "$PWD")"
uv sync

# for vscode, set default virtual environment
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
