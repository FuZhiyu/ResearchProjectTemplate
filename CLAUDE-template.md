
# Academic Research Project Instructions for Claude

## Working Directory Context

You are working in the `ProjectExample/` folder, which is a Git repository. This folder contains:
- Git-tracked folders: `Code/`, `Figures/`, `Tables/`, `Paper/`, `Slides/`
- Symlinked folders: `Data`, `Notes`, `Output` (these link to `../ProjectExample-Share/` which is outside the Git repo)

You can access all folders normally - the symlinks are transparent. Files in symlinked folders are NOT tracked by Git but are synced via Dropbox.

## Project Structure

This project follows a two-folder structure designed for academic research collaboration:

### Git Repository (ProjectExample/)
- `Code/` - All analysis scripts organized by task (e.g., DataCleaning/)
- `Figures/` - Final presentable charts and visualizations (version-tracked)
- `Tables/` - Final presentable results and summary statistics (version-tracked)
- `Paper/` - LaTeX documents for academic papers
- `Slides/` - LaTeX presentations
- `Data`, `Notes`, `Output` - Symlinks to corresponding folders in ProjectExample-Share/

### Dropbox Folder (ProjectExample-Share/)
- `Data/` - Raw and processed datasets (read-only, not version-tracked)
- `Notes/` - Research notes and documentation
- `Output/` - Intermediate results organized by task matching Code/ structure

## Subfolder Organization

### Code/ Directory
Organize scripts by research tasks, not by individual runs. Examples:
- `Code/DataCleaning/` - Scripts for data preparation and cleaning
- `Code/Analysis/` - Main analysis scripts
- `Code/Robustness/` - Robustness checks and sensitivity analyses
- `Code/Visualization/` - Scripts generating figures and tables

**Important**: Edit existing scripts rather than creating new ones for variations of the same task.

### Output/ Directory
Mirror the Code/ structure with corresponding output folders:
- `Output/DataCleaning/` - Cleaned datasets, processing logs
- `Output/Analysis/` - Regression results, statistical outputs
- `Output/Robustness/` - Alternative specification results
- `Output/Visualization/` - Draft figures and tables (not final versions)


## Coding Style

- Code is for academic research and **NOT** meant for production-ready. Therefore, write **concise** and efficient code without safety check (`try...catch...`, `if...else`) unless it's necessary or specifically requested
- Due to the exploratory nature, **DO** write interactive code that can be evaluated line-by-line
- Document only when necessary, but be concise
- When producing outputs, save in `Output/` following the subfolder convention. Do **NOT** save outputs in `Figures/` or `Tables/` unless explicitly requested
- The project is version controlled with Git. Hence, when adding new analysis, Do **NOT** create a new script per task, but **DO** edit the existing files directly
- Always execute at the project root rather than `cd` into subfolders

## Python Environment

- Uses `uv` for dependency management
- Virtual environment located at `~/.venvs/ProjectExample`
- Run commands with `uv run <command>` (e.g., `uv run python script.py`)
- Add dependencies with `uv add package`

Whenever calling Python-related programs, use `uv` unless it is infeasible.