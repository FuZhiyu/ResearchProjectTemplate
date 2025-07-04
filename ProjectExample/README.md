# ProjectExample

Academic research project: ProjectExample

This project is created with [ResearchProjectTemplate](https://github.com/FuZhiyu/ResearchProjectTemplate). This readme explains the basic folder structure and setup. For design principles and best practices, see the [ResearchProjectTemplate documentation](https://github.com/FuZhiyu/ResearchProjectTemplate).


## Project Organization

The project is physically separated into two folders: `ProjectExample` and `ProjectExample-Share`, where 

- `ProjectExample` stores the codebase, publication-ready figure and table outputs that go into papers and slides, and LaTeX projects. It is version-controlled using *Git* and *not* shared via cloud services. 
- `ProjectExample-Share` stores data, intermediate outputs, and other relevant documents. It is synced across the group using cloud services like *Dropbox*. 

However, all folders under `ProjectExample-Share` are soft-linked to `ProjectExample` (see the setup below), so all files are accessible under `ProjectExample`, and one can work directly in `ProjectExample` with access to all folders. 

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
