# An Academic Research Project Template in the AI Era

This project template is based on my personal workflow when collaborating with coauthors. It has the following design philosophy:

- *AI friendly*: It has a clean project setup and instructions for AI agents to understand the project and work as a research assistant; 
- *Git-centric*: Version control is a **must** in the AI era because AI messes up things. 
- *Backward compatible*: Collaborating with someone you can't force fancy new tools onto? They can work just as usual, and you can handle all the bells and whistles.
- *Geared towards academic research*: Unlike software engineering, academic research has smaller teams and is more exploratory by nature. Best practices in the industry may not be suitable here.  

Folder `ProjectExample` gives you a sense of the structure of the project. You can also find the instructions of automated setup under [Prerequisites and Setup](#prerequisites-and-setup).

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

A project is "physically" separated into two folders: `MyProject` and `MyProject-Share`, where: 

- `MyProject` stores the codebase, publication-ready figure and table outputs that go into papers and slides, and LaTeX projects. It is version-controlled using *Git* and *not* shared via cloud services. 
- `MyProject-Share` stores data, intermediate outputs, and other relevant documents. It is synced across the group using cloud services like *Dropbox*. 

**Importantly**, all folders under `MyProject-Share` are symlinked to `MyProject` (see the setup below), so we can just work under `MyProject` as if there is only one folder. 

**Why two folders?** The two-folder structure solves the following dilemma: Dropbox is bad at handling simultaneous-editing conflict (and lacks meaningful version control), while Git does not handle big files well. More sophisticated tools exist but they are typically overkill for academic research, and they won't be compatible with coauthor teams who are used to Dropbox.  By maintaining two folders and soft-linking them together, one can use the strengths of Git and Dropbox together while working seamlessly as if there is only one project folder.

**Working with someone who does not use Git**: you can also clone the repo into the `MyProject-Share` folder, so they can work just as usual. Because it is shared via Dropbox, you can access all the code and handle Git on their behalf. 


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

The automated project creation script only works on macOS/Linux. However, the structure can be easily replicated on Windows (PRs welcome). 

To create a new project using this template:

1. **Clone or download this template repository**:
   ```bash
   git clone https://github.com/FuZhiyu/ResearchProjectTemplate.git
   cd ResearchProjectTemplate
   ```

2. **Run the project creation script**:
   ```bash
   ./create_project.sh YourProjectName
   ```
   
   You can also specify a path:
   ```bash
   ./create_project.sh ../MyResearchProject      # Creates in parent directory
   ./create_project.sh /path/to/MyProject        # Creates at absolute path
   ```

The script will automatically:
- Create the two-folder structure (`YourProjectName/` and `YourProjectName-Share/`)
- Call `setup_mac.sh` to set up the folder

3. **Share with coauthors**:
   - Share `YourProjectName-Share/` folder via Dropbox
   - Push repository to GitHub: `cd YourProjectName && git remote add origin <your-repo-url> && git push -u origin main`
   - Coauthors: clone repo and run `./setup_mac.sh` (see instructions on the project readme file)


## Git

We use Git for version control and GitHub for collaboration. Git helps us track changes, work simultaneously without conflicts, and maintain a complete history of our research progress. Tons of tutorials on Git can be easily found online, so here we briefly explain two key concepts --- commit and pull request --- and focus more on best practices in academic research. 

**Why isn't version history in Dropbox/Overleaf good enough?**

- Dropbox and Overleaf version history is limited and doesn't provide meaningful diff comparisons, branching capabilities, or conflict resolution
- Git provides granular control over what changes are tracked and allows for collaborative workflows through branches and pull requests
- Git's commit system creates explicit checkpoints with descriptive messages, making it easier to understand the evolution of your research 

### Basic concept: Commit

A **commit** is a snapshot of your project at a specific point in time. Each commit has:
- A message describing what changed
- The author and timestamp
- A complete copy of all files at that moment
- A unique identifier (hash)

When you make changes to files, Git tracks what's different from the last commit. You can then "commit" these changes to create a new snapshot. This allows you to see exactly what changed between different versions.

### Best Practices

1. **Commit very often**. This is really rule #1, particularly before you call AI to do edits. AI messes things up all the time, and with timely commits you can safely experiment with AI agents with peace of mind knowing anything can be recovered; 
2. **Descriptive messages**: "Fix typo in table 3" not "fix stuff" so it is easier to trace back changes 
3. **Rule 1 >> Rule 2**: The two rules above intrinsically conflict with each other: when one is required to write detailed messages, it naturally adds burden for each commit. When conflicted, follow rule #1. It's better to decipher cryptic commit messages than have no checkpoint to return to at all. Several strategies when you feel lazy about writing messages:
    
    - Use AI to summarize: "Summarize the staged changes and write a commit message"
    - If one follows PR-based workflow (see below), the PR stage offers another opportunity to review the changes and summarize them in messages
4. **One topic per commit**. Try to make each commit about one topic, rather than a bunch of things all together.


#### What (not) to commit

We commit everything that we want to keep track of the versions. Never commit these types of files:

- **Data files** (`.csv`, `.xlsx`, `.parquet`, etc.) - These are often large and change frequently
- **Personal files** (notes, temporary files, IDE settings)
- **Sensitive information** (API keys, passwords, personal data)
- **Large files** (>100MB) - Git repositories have size limits
- **Auxiliary files** (`.aux`, `.log`, `.tmp`, cache files)

Add them to `.gitignore` to automatically ignore these files

#### Should we commit figures and other outputs?

The standard recommendation is "we commit code, not the output". *However*, for academic research, the rule of thumb is less clear. 

- Reasons to commit: It is often necessary to keep track of the differences in outputs, particularly as many outputs directly feed into our LaTeX project, and we do need to make sure the draft is completely reproducible without rerunning all the code. 
- Reasons not to commit: The downside of committing large binary files to Git is that it slows Git down and is inefficient at space usage. Git also cannot meaningfully show the differences of binary files so the advantage of Git is much less. 

The conclusion is that one needs to exercise discretion on when to commit outputs and when not to. Also, remember anything under the `MyProject-Share` folder is not tracked by Git, while anything else is detected by Git by default. 

#### How about Jupyter Notebook?

Jupyter notebooks are often messy to manage with Git. It is recommended to use VSCode's [Python Interactive Window](https://code.visualstudio.com/docs/python/jupyter-support-py), which allows one to code in .py form but evaluate them interactively cell by cell just as in Jupyter notebooks, and save the output in notebooks.

If Jupyter notebook is used, it is recommended to clean the output first before committing to keep the repo clean. You can always save a copy to the output folder to keep the results. 

### GitHub Pull-Request Workflow

We will use Pull Request (PR) workflows for collaboration. [Here](https://medium.com/%40husnainali593/pull-request-workflow-with-git-a-6-step-guide-e94f753752a3) is an accessible guide on how the PR workflows work. 

Why do we add another layer of complexity on top of commits? The PR workflow is designed to solve co-editing conflicts: Suppose two coauthors both work on the codebase simultaneously. When both push their changes to the central repository (hosted on GitHub), how do we merge them safely? 

The solution of the PR workflow is as follows: both coauthors branch out, work independently, and merge back to the main branch. If the changes made in the PR are independent from other changes made to the main branch during this period (e.g., by other coauthors), the merge is handled automatically; if one line is changed differently by different authors, the PR offers a chance to reconcile the changes and merge. 

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

The project template includes `CLAUDE.md`, instructions for Claude Code tailored for academic research and the project structure. It contains the following (possibly opinionated) coding style guidance for Claude:

- Code is for academic research and **NOT** meant for production-ready. Therefore, write **concise** and efficient code without safety check (`try...catch...`, `if...else`) unless it's necessary or specifically requested
- Due to the exploratory nature, **DO** write interactive code that can be evaluated line-by-line
- Document only when necessary, but be concise
- When producing outputs, save in `Output/` following the subfolder convention. Do **NOT** save outputs in `Figures/` or `Tables/` unless explicitly requested
- The project is version controlled with Git. Hence, when adding new analysis, Do **NOT** create a new script per task, but **DO** edit the existing files directly
- Always execute at the project root rather than `cd` into subfolders

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

With this setup, by default when you open the project in this folder, it should automatically use the right environment. 
