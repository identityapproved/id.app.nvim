#!/bin/bash

CONFIG_DIR="$HOME/.config"
DOTFILES_DIR=$(pwd)

# Check if the dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Error: Dotfiles directory not found."
  exit 1
fi

# Get a list of all directories in the current folder
directories=("$DOTFILES_DIR"/*/)
directories=("${directories[@]%/}")

for dir in "${directories[@]}"; do
  target_dir="$CONFIG_DIR/$(basename "$dir")"

  # Check if the target directory is a symbolic link
  if [ -L "$target_dir" ]; then
    # Check if the link points to the dotfiles directory
    if [ "$(readlink -f "$target_dir")" = "$dir" ]; then
      # Existing symbolic link points to dotfiles, remove it
      rm -f "$target_dir"
      echo "Removed existing symbolic link: $target_dir"
    fi
  elif [ -d "$target_dir" ]; then
    # Check if it's a directory (not a symbolic link)
    mv "$target_dir" "$target_dir.bak"
    echo "Existing directory '$target_dir' renamed to '$target_dir.bak'"
  fi

  # Create symlink
  ln -sfn "$dir" "$target_dir"
  echo "Created symlink: $target_dir"
done

echo "Symbolic links created successfully."
