# ~/.bashrc
# Sourced for interactive non-login shells

# Run neofetch on startup for interactive shells
if [ -n "$PS1" ] && [ "$TERM" != "dumb" ]; then
    if command -v neofetch >/dev/null 2>&1; then
        neofetch
    elif command -v figlet >/dev/null 2>&1; then
        figlet "Welcome $(whoami)"
    fi
fi

# Enable colors
export CLICOLOR=1
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=37;41:sg=30;43:tw=30;42:ow=34;42"

# Colorful PS1 prompt with git branch
parse_git_branch() {
    git branch 2>/dev/null | grep \* | sed 's/* //'
}

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]$(parse_git_branch)\[\033[00m\]\$ '

# Some useful aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias ga='git add .'
alias please='sudo $(fc -ln -1)'  # rerun last command with sudo
alias pyserv='python3 -m http.server'

# Git branch in terminal tab title
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
    ;;
*)
    ;;
esac

# Load custom functions (optional)
if [ -f "$HOME/.bash_functions" ]; then
    . "$HOME/.bash_functions"
fi 