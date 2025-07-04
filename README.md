# Academic Research Project Template

A project template designed for academic research collaboration, centered around Git and optimized for AI assistance.

**Key Features:**
- Git-centric: A **must** to use AI, because AI messes up things. 
- Git repo + Dropbox share, symlinked into one folder
- AI-friendly setup with included default instructions for LLM
- Compatible with traditional workflows and no-Git coauthors

See `ProjectExample/` for structure reference and [Setup](#automated-setup) for automated setup.

## Table of Contents

- [Project Organization](#project-organization)
    - [Core Structure](#core-structure)
- [Prerequisites and Setup](#prerequisites-and-setup)
- [Git](#git)
    - [Commit](#commit)
    - [Best Practices](#best-practices-on-commits)
    - [GitHub Pull-Request Workflow](#github-pull-request-workflow)
- [AI Instructions](#ai-instructions)
- [Python Environment Management](#python-environment-management)
  - [Virtual Environment Location](#virtual-environment-location)


## Project Organization

Projects use a two-folder structure:

- `MyProject/` - Git repository containing code, final figures/tables, and LaTeX documents
- `MyProject-Share/` - Dropbox-synced folder with data, notes, and intermediate outputs

Folders from `MyProject-Share/` are symlinked into `MyProject/`, so you work in one place with access to everything.

**Why two folders?** Solves the Git vs. Dropbox dilemma: Dropbox lacks proper version control and handles conflicts poorly, while Git struggles with large files. By linking folders together, you get Git's version control + Dropbox's file sharing while working seamlessly in one place.

**Working with non-Git users**: you can also clone the repo into the `MyProject-Share` folder, so they can work just as usual. Because it is shared via Dropbox, you can access all the code and handle Git on their behalf. 


### Core Structure

#### In the Git Repo (`MyProject`)
- `Code/` - All analysis scripts and implementation
   - The subfolders are organized around different tasks, e.g., `DataCleaning`.
- `Figures/` - Final presentable charts, plots, and visualizations that we want to track the version with git
- `Tables/` - Final presentable result tables and summary statistics that we want to track with git
- `Paper/` - The LaTeX folder containing the draft
- `Slides/` - The LaTeX folder containing slides

#### In the Dropbox (`MyProject-Share`)
- `Notes/` - Research notes and documentation
- `Data/` - Raw and processed datasets. Typically read-only. 
- `Output/` - Generated results and intermediate files
    - This folder is organized with subfolders that have the same names as folders under `Code`.

## Automated Setup

1. **Clone and create project**:
   ```bash
   git clone https://github.com/FuZhiyu/ResearchProjectTemplate.git
   cd ResearchProjectTemplate
   ./create_project.sh YourProjectNameOrPath
   ```

2. **Share with coauthors**:
   - Share `YourProjectName-Share/` via Dropbox
   - Push to GitHub: `cd YourProjectName && git remote add origin <url> && git push -u origin main`
   - Coauthors: clone repo and run `./setup_mac.sh`


## Git

We use Git for version control and GitHub for collaboration. Git helps us track changes, work simultaneously without conflicts, and maintain a complete history of our research progress. Tons of tutorials on Git can be easily found online, so here we briefly explain two key concepts, commit and pull request, and focus more on best practices in academic research. 

**Why isn't Dropbox/Overleaf version history enough?** Version control isn't just "save every copy"—it's about organizing changes meaningfully. Thousands of timestamped versions don't help you understand what changed or easily recover specific states. 


### Commit

A **commit** is a snapshot of your project at a specific point in time. Each commit has:
- A message describing what changed
- The author and timestamp
- A complete copy of all files at that moment
- A unique identifier (hash)

When you make changes to files, Git tracks what's different from the last commit. You can then "commit" these changes to create a new snapshot. This allows you to see exactly what changed between different versions.

### Best Practices

1. **Commit very often** - Essential before AI edits. AI can mess things up, but frequent commits let you experiment safely knowing everything can be recovered.

2. **Descriptive messages** - "Fix typo in table 3" not "fix stuff" for easier change tracking.

3. **Rule 1 >> Rule 2** - Rules 1 and 2 conflict since detailed messages add commit burden. Prioritize frequent commits over detailed messages. Better to have cryptic messages than no checkpoints.
   
   **Tips for lazy messaging:**
   - Ask AI: "Summarize the staged changes and write a commit message"
   - Use PR descriptions to provide context later

4. **One topic per commit** - Keep commits focused on single changes rather than bundling multiple topics.


### What (not) to commit

#### Never commit:
- Data files (`.csv`, `.xlsx`, `.parquet`)
- Personal files, IDE settings
- Sensitive info (API keys, passwords)
- Large files (>100MB)
- Auxiliary files (`.aux`, `.log`, `.tmp`)

#### Figures and outputs

The standard "commit code, not output" rule is less clear for academic research. Exercise discretion:

- **Do commit:** Final figures/tables that feed into LaTeX documents when reproducibility is critical
- **Don't commit:** Large binary files that slow Git and can't show meaningful diffs

Remember: `MyProject-Share/` files aren't tracked by Git.

#### Jupyter notebooks

Use VSCode's [Python Interactive Window](https://code.visualstudio.com/docs/python/jupyter-support-py) for cleaner Git management—write `.py` files with cell-by-cell evaluation. 

If using notebooks: clean outputs before committing, save copies with outputs to the output folder.

### GitHub Pull-Request Workflow

We will use Pull Request (PR) workflows for collaboration. [Here](https://medium.com/%40husnainali593/pull-request-workflow-with-git-a-6-step-guide-e94f753752a3) is an accessible guide on how the PR workflows work. 

PRs solve co-editing conflicts: when multiple coauthors work simultaneously, how do we merge safely? 

The solution: coauthors branch out, work independently, then merge back. Git handles non-conflicting changes automatically; conflicting edits are resolved during the PR process. 

A typical PR workflow works as follows. The introduction here uses terminal commands, though all these can be done with GUI, or simply with AI. 
1. **Start new work**: 
   ```bash
   git checkout main
   git pull origin main  # Get latest changes
   git checkout -b feature/julie-regression-analysis # branch out 
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

7. **Merge**: Once approved, click "Merge pull request". We recommend choosing `squash and merge` which combines all the updates in a single commit in `main` to keep the timeline clean. 

8. **Clean up**:
   ```bash
   git checkout main
   git pull origin main  # Get your merged changes
   git branch -d feature/julie-regression-analysis  # Delete old branch
   ```

## AI Instructions

Projects include `CLAUDE.md` with the following AI coding principles:

- Write concise research code (not production-ready)
- Use interactive, line-by-line evaluation
- Save outputs to `Output/`, not `Figures/Tables/`
- Edit existing files instead of creating new ones
- Execute from project root

## Python Environment Management

The project uses [`uv`](https://docs.astral.sh/uv/) for Python environment management, which is installed by the setup script.

**Quick uv commands:**
- `uv sync` - Install all required dependencies from `pyproject.toml`
- `uv run <command>` - Run any command with project environment (e.g., `uv run python script.py`, `uv run jupyter notebook`, `uv run pytest`)
- `uv add package` - Add a new dependency for this package. Instead of using `pip`, this is the more robust way to make sure the dependencies are shared. 
- `uv remove package` - Remove a dependency

### Virtual Environment Location

The setup script configures `uv` to place virtual environments in `~/.venvs/MyProject` rather than within the project folder. This keeps the project directory clean and ensures consistent environment paths across different machines.

**A more technical note**: The rationale for putting the `.venvs` folder outside of the project folder is that more often than not, the project folder is also synced via Dropbox across different machines. `uv` uses hard-link/clone for the Python environment, which will be broken by Dropbox sync. This will result in multiple copies of the same package across different projects, which is highly space inefficient. Moving it out of Dropbox solves this issue. 

To automatically use the right virtual environment, the setup script automatically creates `.vscode/settings.json` with:
- `python.defaultInterpreterPath` - Points to the correct Python interpreter in the virtual environment
- `terminal.integrated.env.osx` - Sets `UV_PROJECT_ENVIRONMENT` for proper `uv` integration
- `python.analysis.extraPaths` - Ensures VS Code can find installed packages for IntelliSense

VSCode automatically configured to use the correct environment. 
