# --- 1. Basic Options ---
autoload -U compinit; compinit  # Enables the advanced tab completion system
setopt correct                  # Auto-corrects minor spelling mistakes (sl -> ls)

# --- 2. History (The Memory) ---
HISTFILE=~/.zsh_history         # Where to save your command history
HISTSIZE=1000           # How many commands to remember in the current session
SAVEHIST=1000           # How many commands to save to the file
setopt HIST_IGNORE_DUPS         # Don't record the same command twice in a row

# --- 3. The Plugins (Visuals & Speed) ---
# Load the packages we just installed with pacman
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- 6. Visual Tab Completion (The Menu) ---
# This makes the Tab key show a selectable menu with colors
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# --- 4. Your Visuals ---
eval "$(starship init zsh)"
fastfetch

# --- Backup Script for github dotfiles ---
backup() {
    echo "backing up dotfiles..."
    
    # 1. Update the files in the backup folder
    cp ~/.zshrc ~/dotfiles/
    rm -rf ~/dotfiles/hypr && cp -r ~/.config/hypr ~/dotfiles/
    pacman -Qqe > ~/dotfiles/packages.txt
    
    # 2. Send to GitHub
    cd ~/dotfiles
    git add .
    git commit -m "Update: $(date)"
    git push
    
    # 3. Go back to where you were
    cd -
    echo "Backup complete!"
}