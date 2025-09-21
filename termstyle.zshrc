#!/usr/bin/env zsh
# Terminal Properties Display and Color Configuration Script

# Enable color support
autoload -U colors && colors

# Function to display terminal properties
display_terminal_info() {
    echo "${fg[cyan]}╔══════════════════════════════════════════════════════════════╗${reset_color}"
    echo "${fg[cyan]}║                    TERMINAL PROPERTIES                       ║${reset_color}"
    echo "${fg[cyan]}╠══════════════════════════════════════════════════════════════╣${reset_color}"
    
    # Basic shell information
    echo "${fg[green]}║ Shell:${reset_color}           ${fg[yellow]}$SHELL${reset_color}"
    echo "${fg[green]}║ Shell Version:${reset_color}   ${fg[yellow]}$ZSH_VERSION${reset_color}"
    echo "${fg[green]}║ Terminal Type:${reset_color}   ${fg[yellow]}$TERM${reset_color}"
    echo "${fg[green]}║ Terminal Size:${reset_color}   ${fg[yellow]}${COLUMNS}x${LINES}${reset_color}"
    
    # User and system info
    echo "${fg[green]}║ User:${reset_color}            ${fg[yellow]}$USER${reset_color}"
    echo "${fg[green]}║ Hostname:${reset_color}       ${fg[yellow]}$HOST${reset_color}"
    echo "${fg[green]}║ Home Directory:${reset_color} ${fg[yellow]}$HOME${reset_color}"
    echo "${fg[green]}║ Current Path:${reset_color}   ${fg[yellow]}$PWD${reset_color}"
    
    # Virtual environment info
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "${fg[green]}║ Virtual Env:${reset_color}    ${fg[magenta]}$(basename $VIRTUAL_ENV)${reset_color}"
    else
        echo "${fg[green]}║ Virtual Env:${reset_color}    ${fg[red]}None${reset_color}"
    fi
    
    # Python version if available
    if command -v python3 &> /dev/null; then
        echo "${fg[green]}║ Python Version:${reset_color} ${fg[yellow]}$(python3 --version | cut -d' ' -f2)${reset_color}"
    fi
    
    # Node version if available
    if command -v node &> /dev/null; then
        echo "${fg[green]}║ Node Version:${reset_color}   ${fg[yellow]}$(node --version)${reset_color}"
    fi
    
    # Git status if in git repo
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch=$(git branch --show-current 2>/dev/null)
        local status=$(git status --porcelain 2>/dev/null)
        if [[ -n "$status" ]]; then
            echo "${fg[green]}║ Git Branch:${reset_color}     ${fg[red]}$branch (dirty)${reset_color}"
        else
            echo "${fg[green]}║ Git Branch:${reset_color}     ${fg[green]}$branch (clean)${reset_color}"
        fi
    else
        echo "${fg[green]}║ Git Status:${reset_color}     ${fg[red]}Not a git repository${reset_color}"
    fi
    
    # Color support
    echo "${fg[green]}║ Color Support:${reset_color}  ${fg[yellow]}$(tput colors) colors${reset_color}"
    
    echo "${fg[cyan]}╚══════════════════════════════════════════════════════════════╝${reset_color}"
    echo
}

# Function to display color palette
display_color_palette() {
    echo "${fg[cyan]}Color Palette Test:${reset_color}"
    
    # Basic colors
    local colors=(black red green yellow blue magenta cyan white)
    for color in $colors; do
        echo -n "${fg[$color]}●${reset_color} "
    done
    echo
    
    # 256 color test (first 16 colors)
    echo "${fg[cyan]}256 Color Support (sample):${reset_color}"
    for i in {0..15}; do
        echo -n "\033[38;5;${i}m●\033[0m "
    done
    echo
    echo
}

# Git branch function for prompt
git_branch() {
    git branch 2>/dev/null | grep '^*' | colrm 1 2
}

# Git status with colors - FIXED
git_status_color() {
    local branch=$(git_branch)
    if [[ -n "$branch" ]]; then
        local git_stat=$(git status --porcelain 2>/dev/null)  # Using git_stat instead of status
        if [[ -n "$git_stat" ]]; then
            echo "%F{red}($branch)%f"
        else
            echo "%F{green}($branch)%f"
        fi
    fi
}

# Alternative version with more detailed status
git_status_detailed() {
    local branch=$(git_branch)
    if [[ -n "$branch" ]]; then
        local git_stat=$(git status --porcelain 2>/dev/null)
        local ahead_behind=$(git status -b --porcelain 2>/dev/null | head -1)
        
        if [[ -n "$git_stat" ]]; then
            echo "%F{red}($branch)%f"  # Dirty repo
        elif [[ "$ahead_behind" =~ "ahead" ]]; then
            echo "%F{yellow}($branch)%f"  # Ahead of remote
        elif [[ "$ahead_behind" =~ "behind" ]]; then
            echo "%F{cyan}($branch)%f"  # Behind remote
        else
            echo "%F{green}($branch)%f"  # Clean repo
        fi
    fi
}

# Virtual environment indicator
venv_info() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "%F{magenta}($(basename $VIRTUAL_ENV))%f "
    fi
}

# Set up the colorful prompt
setup_prompt() {
    # Enable prompt substitution
    setopt PROMPT_SUBST
    
    # Define the prompt with colors
    PROMPT='$(venv_info)%F{cyan}%n%f@%F{green}%m%f %F{yellow}%~%f $(git_status_color) %F{blue}❯%f '
    
    # Right prompt with time
    RPROMPT='%F{244}%D{%H:%M:%S}%f'
}

# Custom color definitions for 256 color support
setup_custom_colors() {
    # Define custom color variables using 256 color codes
    typeset -gA custom_colors
    custom_colors[orange]=214
    custom_colors[pink]=213
    custom_colors[purple]=141
    custom_colors[light_blue]=117
    custom_colors[dark_green]=22
    custom_colors[gold]=220
    
    # Export for use in scripts
    export CUSTOM_ORANGE="\033[38;5;214m"
    export CUSTOM_PINK="\033[38;5;213m" 
    export CUSTOM_PURPLE="\033[38;5;141m"
    export CUSTOM_LIGHT_BLUE="\033[38;5;117m"
    export CUSTOM_DARK_GREEN="\033[38;5;22m"
    export CUSTOM_GOLD="\033[38;5;220m"
    export COLOR_RESET="\033[0m"
}

# Enhanced LS colors
setup_ls_colors() {
    # Custom LS_COLORS for better file type recognition
    export LS_COLORS="di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;32:bd=1;33;40:cd=1;33;40:su=1;37;41:sg=1;37;43:tw=1;37;42:ow=1;37;43:*.tar=1;31:*.tgz=1;31:*.zip=1;31:*.z=1;31:*.Z=1;31:*.gz=1;31:*.bz2=1;31:*.tbz2=1;31:*.tz=1;31:*.deb=1;31:*.rpm=1;31:*.rar=1;31:*.ace=1;31:*.zoo=1;31:*.cpio=1;31:*.7z=1;31:*.rz=1;31:*.jpg=1;35:*.jpeg=1;35:*.gif=1;35:*.bmp=1;35:*.xbm=1;35:*.xpm=1;35:*.png=1;35:*.tif=1;35:*.tiff=1;35:*.svg=1;35:*.mov=1;35:*.mpg=1;35:*.mpeg=1;35:*.m2v=1;35:*.mkv=1;35:*.ogm=1;35:*.mp4=1;35:*.m4v=1;35:*.mp4v=1;35:*.vob=1;35:*.qt=1;35:*.nuv=1;35:*.wmv=1;35:*.asf=1;35:*.rm=1;35:*.rmvb=1;35:*.flc=1;35:*.avi=1;35:*.fli=1;35:*.gl=1;35:*.dl=1;35:*.xcf=1;35:*.xwd=1;35:*.yuv=1;35:*.pdf=1;33:*.ps=1;33:*.txt=0;32:*.patch=0;32:*.diff=0;32:*.log=0;32:*.tex=0;32:*.doc=0;32:"
}

# History configuration
setup_history() {
    HISTSIZE=10000
    SAVEHIST=10000
    HISTFILE=~/.zsh_history
    setopt SHARE_HISTORY
    setopt HIST_IGNORE_DUPS
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_SAVE_NO_DUPS
    setopt HIST_FIND_NO_DUPS
}

# Aliases for enhanced terminal experience
setup_aliases() {
    # Colorful ls
    alias ls='ls --color=auto'
    alias ll='ls -lh --color=auto'
    alias la='ls -lah --color=auto'
    
    # Colorful grep
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    
    # Git aliases with color
    alias gs='git status --short'
    alias gl='git log --oneline --graph --decorate --all'
    alias gd='git diff --color=always'
    
    # Custom color test command
    alias colors='for i in {0..255}; do echo -n "\033[38;5;${i}m${i} \033[0m"; done; echo'
    alias spectrum='spectrum_ls'  # If oh-my-zsh is installed
}

# Main initialization
main() {
    # Only display info for interactive shells
    if [[ -o interactive ]]; then
        display_terminal_info
        display_color_palette
    fi
    
    # Set up all configurations
    setup_custom_colors
    setup_ls_colors
    setup_prompt
    setup_history
    setup_aliases
    
    echo "${fg[green]}✓ Terminal configured with custom colors and prompt${reset_color}"
    echo "${fg[yellow]}Type 'colors' to see all 256 colors available${reset_color}"
    echo
}

# Run the initialization
main

# Additional customizations (optional)
# Uncomment these if you want them

# Auto-completion enhancements
# autoload -Uz compinit && compinit
# zstyle ':completion:*' menu select
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Key bindings for better navigation
# bindkey "^[[1;5C" forward-word    # Ctrl+Right
# bindkey "^[[1;5D" backward-word   # Ctrl+Left
# bindkey "^[[3~" delete-char       # Delete key

# Load additional plugins if oh-my-zsh is installed
# if [[ -d "$HOME/.oh-my-zsh" ]]; then
#     source "$HOME/.oh-my-zsh/oh-my-zsh.sh"
# fi