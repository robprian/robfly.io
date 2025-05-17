# ~/.profile
# Sourced during login shell

# Set default editor
export EDITOR=nano

# Add local bin to PATH
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Start neofetch (cool terminal info banner)
if command -v neofetch >/dev/null 2>&1; then
    neofetch
elif command -v screenfetch >/dev/null 2>&1; then
    screenfetch
elif command -v figlet >/dev/null 2>&1; then
    figlet "Welcome $(whoami)"
fi 