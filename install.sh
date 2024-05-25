#!/bin/bash

# Function to install package if not found
install_package() {
    sudo yay -S --noconfirm "$1" || { echo "Failed to install $1. Exiting." >&2; exit 1; }
}

# Check and install packages if not found
for pkg in gcc make git ripgrep fd unzip neovim; do
    command -v $pkg &> /dev/null || install_package $pkg
done

# Check if nvim folder exists in ~/.config/
if [ -d "$HOME/.config/nvim" ]; then
    # Move existing nvim folder to nvim.bak
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
    echo "Moved existing nvim folder to nvim.bak"
fi

# Create symlink for nvim folder
ln -s "$(pwd)/nvim" "$HOME/.config/nvim"
echo "Created symlink for nvim folder in ~/.config/"

echo "All required packages are installed."

# Run Neovim
nvim
