# Terminal Style Configuration for Zsh

A comprehensive zsh configuration script that adds colorful prompts, git status indicators, terminal information display, and enhanced shell experience.

## Features

- **Colorful prompt** with username, hostname, current directory, and git branch status
- **Git integration** showing branch name and repository state (clean/dirty)
- **Virtual environment indicator** for Python projects
- **Terminal information display** on startup showing system details
- **256-color support** with custom color palette
- **Enhanced aliases** for ls, grep, and git commands
- **Smart history** configuration with deduplication
- **Custom color definitions** for advanced terminal styling

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/termstyle.git ~/.config/termstyle
```

Or download to any location:

```bash
git clone https://github.com/yourusername/termstyle.git ~/Projects/termstyle
```

### 2. Load the script in your zsh configuration

Add this to your `~/.zshrc`:

```bash
# Load Terminal Style Configuration
if [[ -r ~/.config/termstyle/termstyle.zshrc ]]; then
  source ~/.config/termstyle/termstyle.zshrc
fi
```

Or if you cloned to a different location:

```bash
# Load Terminal Style Configuration
if [[ -r ~/Projects/termstyle/termstyle.zshrc ]]; then
  source ~/Projects/termstyle/termstyle.zshrc
fi
```

### 3. Reload your shell

```bash
source ~/.zshrc
```

You should see a colorful terminal info display and your prompt will now include git status and virtual environment indicators.

## What You'll See

When you open a new terminal, you'll see:

```
╔══════════════════════════════════════════════════════════════╗
║                    TERMINAL PROPERTIES                       ║
╠══════════════════════════════════════════════════════════════╣
║ Shell:           /bin/zsh
║ Shell Version:   5.9
║ Terminal Type:   xterm-256color
║ Terminal Size:   80x24
║ User:            andreu
║ Hostname:        Nanzens-MacBook
║ Home Directory:  /Users/andreu
║ Current Path:    /Users/andreu/Projects
║ Virtual Env:     None
║ Python Version:  3.11.5
║ Node Version:    v20.10.0
║ Git Branch:      main (clean)
║ Color Support:   256 colors
╚══════════════════════════════════════════════════════════════╝
```

Your prompt will look like:

```
(venv) andreu@hostname ~/Projects/myproject (main) ❯
```

- **Green** branch name = clean repository
- **Red** branch name = uncommitted changes
- **Magenta** (venv) = active Python virtual environment

## Customization

### Disable startup info display

If you don't want the terminal info on every new shell, edit `termstyle.zshrc` and comment out these lines in the `main()` function:

```bash
# display_terminal_info
# display_color_palette
```

### Change prompt colors

Edit the `setup_prompt()` function to customize colors:

```bash
PROMPT='$(venv_info)%F{cyan}%n%f@%F{green}%m%f %F{yellow}%~%f $(git_status_color) %F{blue}❯%f '
```

Available colors: `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`

### Use detailed git status

For more detailed git information (ahead/behind indicators), replace `git_status_color` with `git_status_detailed` in the prompt:

```bash
PROMPT='$(venv_info)%F{cyan}%n%f@%F{green}%m%f %F{yellow}%~%f $(git_status_detailed) %F{blue}❯%f '
```

## Included Aliases

The script sets up these convenient aliases:

```bash
ll    # ls -lh with colors
la    # ls -lah with colors (includes hidden files)
gs    # git status --short
gl    # git log --oneline --graph --decorate --all
gd    # git diff with colors
colors # Display all 256 terminal colors
```

## Requirements

- Zsh shell (5.0 or later recommended)
- Terminal with 256-color support
- Git (optional, for git status features)
- Python 3 (optional, for Python version display)
- Node.js (optional, for Node version display)

## Compatibility

Tested on:

- macOS (Terminal.app, iTerm2)
- Linux (GNOME Terminal, Terminator, Alacritty)
- Windows (WSL2 with zsh)

## Troubleshooting

### "read-only variable: status" error

This means you have a conflicting variable name. Make sure you're using the latest version of the script where all `local status=` have been changed to `local git_stat=`.

### Colors not working

Check your terminal supports 256 colors:

```bash
echo $TERM
tput colors
```

If you see `8` instead of `256`, update your terminal settings or set:

```bash
export TERM=xterm-256color
```

### Prompt not updating

Make sure prompt substitution is enabled (the script does this automatically):

```bash
setopt PROMPT_SUBST
```

## Uninstallation

Remove the source line from your `~/.zshrc` and delete the cloned directory:

```bash
rm -rf ~/.config/termstyle  # or ~/Projects/termstyle
```

Then restart your terminal.

## License

MIT License - feel free to modify and share!

## Contributing

Issues and pull requests welcome at [your-repo-url].
EOF

```

Run that command and it will create `README.md` in `~/Projects/termstyle`. Then you can commit it:

```bash
git add README.md
git commit -m "Add installation and usage documentation"
git push
```
