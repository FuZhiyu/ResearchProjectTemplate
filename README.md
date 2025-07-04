# IntermediaryDemand

Academic research project analyzing demand of intermediaries.

## Project Organization

The project is separated into two folders: `IntermediaryDemand` and `IntermediaryDemand-Share`, where 

- `IntermediaryDemand` stores the codebase, final figure and table outputs that go into papers and slides, and LaTeX projects. It is version-controlled using *Git*. 
- `IntermediaryDemand-Share` stores data and intermediate outputs. It is synced across the group using *Dropbox*. 

All folders under `IntermediaryDemand` are soft-linked to `IntermediaryDemand-Share` (see the setup below), so all files are accessible under `IntermediaryDemand`, and we can work directly in `IntermediaryDemand`.


### Core Structure

#### In the Git Repo (`IntermediaryDemand`)
- `Code/` - All analysis scripts and implementation
   - The subfolders are organized around different tasks, e.g., `DataCleaning`.
- `Figures/` - Final presentable charts, plots, and visualizations that we want to track the version with `git`
- `Tables/` - Final presentable result tables and summary statistics that we want to track with `git`
- `Paper/` - The LaTeX folder containing the draft
- `Slides/` - The LaTeX folder containing slides

#### In the Dropbox (`IntermediaryDemand-Share`)
- `Notes/` - Research notes and documentation
- `Data/` - Raw and processed datasets. Typically read-only. 
- `Output/` - Generated results and intermediate files
    - This folder is organized with subfolders that have the same names as folders under `Code`.
    - Within each subfolder, it is recommended (but not required) that the results are organized by folders named after the scripts that generate them.

## Setup Instructions

### Prerequisites

- **macOS**: Homebrew installed ([https://brew.sh](https://brew.sh))
- **Git**: For cloning the repository
- **VSCode/Cursor**: Not necessary but highly recommended

### Installation

1. **Clone the repository** in the same parent directory as your `IntermediaryDemand-Share` folder:
   ```bash
   # Navigate to the parent directory containing IntermediaryDemand-Share
   cd /path/to/parent/directory
   
   # Clone the repository
   git clone https://github.com/FuZhiyu/IntermediaryDemand.git
   cd IntermediaryDemand
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
   - Create symbolic links to `Notes`, `Data`, and `Output` folders from `../IntermediaryDemand-Share/`
   - Configure VS Code settings for proper Python interpreter and environment paths

## Git

This project uses Git for version control and GitHub for collaboration. Git helps us track changes, work simultaneously without conflicts, and maintain a complete history of our research progress.

### Commit

A **commit** is a snapshot of your project at a specific point in time. Each commit has:
- A message describing what changed
- The author and timestamp
- A complete copy of all files at that moment
- A unique identifier (hash)

When you make changes to files, Git tracks what's different from the last commit. You can then "commit" these changes to create a new snapshot. This allows you to see exactly what changed between different versions.

**Commit very often**, particularly before you call AI to do edits. AIs mess up things all the time, with a commit, we can make sure 

### What (not) to commit

**Never commit these types of files:**

- **Data files** (`.csv`, `.xlsx`, `.parquet`, etc.) - These are often large and change frequently
- **Personal files** (notes, temporary files, IDE settings)
- **Sensitive information** (API keys, passwords, personal data)
- **Large files** (>100MB) - Git repositories have size limits
- **Auxiliary files** (`.aux`, `.log`, `.tmp`, cache files)

**Use `.gitignore` to automatically ignore these files:**

### Figures and other outputs

The typical recommendation is we commit code, not the output. However, for research is often necessary to keep track the difference in the outputs, particularly as many outputs directly feed into our LaTeX project, and we do need to make sure the draft is completely reproducible without running the code. Hence we just need to exercise our discretion on when to commit the outputs and when not. Remember anything under the `IntermediaryDemand-Share` folder is not tracked by Git, while anything else is detected by Git by default. When producing results, you can decide where to put them based on the question "is it worth tracking?"

### Jupyter

Jupyter notebooks are often messy to manage with Git. Preferably (though not required) we use VSCode's [Python Interactive Window](https://code.visualstudio.com/docs/python/jupyter-support-py), which allows you to code in .py form but evaluate them interactively cell by cell just as in Jupyter notebooks. When using Jupyter notebooks, it is recommended to clean the output first before committing. You can always save a copy to the output folder to keep the results. 

### GitHub PR Workflow

We will use Pull Request (PR) workflows for collaboration. [Here](https://medium.com/%40husnainali593/pull-request-workflow-with-git-a-6-step-guide-e94f753752a3) is an accessible guide on how the PR workflows work. 

Below is a step-by-step guide on the PR workflow. All these can be done (sometimes more easily, sometimes more cumbersome) with VSCode GUI. The key principle is that for any non-trivial changes, do not commit directly on `main`. Rather, branch out, work on it, and then merge back. This practice helps to minimize conflict across team members, and also keep the main timeline clean. 

1. **Start new work**: 
   ```bash
   git checkout main
   git pull origin main  # Get latest changes
   git checkout -b feature/julie-regression-analysis
   ```

2. **Do your work**: Edit files, run analysis, create figures

3. **Save your progress** (do this frequently):
   ```bash
   git add .
   git commit -m "Add regression tables for main specification"
   ```

4. **Push to GitHub**:
   ```bash
   git push -u origin feature/julie-regression-analysis
   ```

5. **Create Pull Request**:
   (On VSCode source control panel, the button that looks like merge can directly create a pull request)
   - Go to GitHub.com → our repository
   - Click "Compare & pull request" (appears after you push)
   - Write description of what you changed
   - Click "Create pull request"

6. **Review process**:
   - Team members review your changes
   - Discuss any questions in PR comments
   - Make additional commits if needed

7. **Merge**: Once approved, click "Merge pull request". Recommend to choose `squash and merge` which combines all the updates in a single commit in `main` to keep the timeline clean. 

8. **Clean up**:
   ```bash
   git checkout main
   git pull origin main  # Get your merged changes
   git branch -d feature/julie-regression-analysis  # Delete old branch
   ```

### Best Practices

- **Commit very often**: Small, frequent commits are better than large ones. 
- **Descriptive messages**: "Fix typo in table 3" not "fix stuff". It is of course more workload if we want to both commit often while writing descriptive messages all the time. When lazy, better to commit often with unclear messages than infrequent commits. 
- **One feature per branch**: Don't mix unrelated changes
- **Pull before you push**: Always `git pull` before starting new work


## Environment Management

The project uses [`uv`](https://docs.astral.sh/uv/) for Python environment management, which is installed by the setup script.

**Quick uv commands:**
- `uv sync` - Install all required dependencies from `pyproject.toml`
- `uv run <command>` - Run any command with project environment (e.g., `uv run python script.py`, `uv run jupyter notebook`, `uv run pytest`)
- `uv add package` - Add a new dependency for this package. Instead of using `pip`, this is the more robust way to make sure the dependencies are shared. 
- `uv remove package` - Remove a dependency

### Virtual Environment Location

The setup script configures `uv` to place virtual environments in `~/.venvs/IntermediaryDemand` rather than within the project folder. This keeps the project directory clean and ensures consistent environment paths across different machines.

### VS Code Integration

The setup script automatically creates `.vscode/settings.json` with:
- `python.defaultInterpreterPath` - Points to the correct Python interpreter in the virtual environment
- `terminal.integrated.env.osx` - Sets `UV_PROJECT_ENVIRONMENT` for proper `uv` integration
- `python.analysis.extraPaths` - Ensures VS Code can find installed packages for IntelliSense

With these setup, by default when you open the project at this folder, it should automatically use the right environment. 

### Manual Setup (Alternative)

If you prefer manual setup or are not on macOS:

#### Python Environment
```bash
# Install uv (if not using macOS setup script)
pip install uv

# Sync dependencies
uv sync
```

#### Julia Environment
```bash
# Start Julia in project directory
julia --project=.

# In Julia REPL, activate and instantiate
] activate .
] instantiate
```

#### Create Symbolic Links
```bash
# Create links to shared folders (adjust paths as needed)
ln -s ../IntermediaryDemand-Share/Notes ./Notes
ln -s ../IntermediaryDemand-Share/Data ./Data
ln -s ../IntermediaryDemand-Share/Output ./Output
```

### Verification

After setup, you should have:
- Python environment ready with `uv sync`
- Julia environment activated with required packages
- Symbolic links to shared `Notes`, `Data`, and `Output` folders
