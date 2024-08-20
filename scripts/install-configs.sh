#!/bin/bash

$DOTFILES_BACKUP_PATH = ~/.dotfiles-backup

mkdir -p $DOTFILES_BACKUP_PATH
mv ~/.zshrc $DOTFILES_BACKUP_PATH
mv ~/.vimrc $DOTFILES_BACKUP_PATH
mv ~/.gitignore $DOTFILES_BACKUP_PATH
mv ~/.gitconfig $DOTFILES_BACKUP_PATH
mv ~/.editorconfig $DOTFILES_BACKUP_PATH
mv ~/.alacritty.toml $DOTFILES_BACKUP_PATH
mv ~/.vscode $DOTFILES_BACKUP_PATH
mv ~/.logseq $DOTFILES_BACKUP_PATH
mv ~/wallpaper.jpeg $DOTFILES_BACKUP_PATH
mv ~/.tmux.conf $DOTFILES_BACKUP_PATH
mv ~/.lfrc $DOTFILES_BACKUP_PATH
mv ~/tmux.sh $DOTFILES_BACKUP_PATH

mkdir -p $DOTFILES_BACKUP_PATH/.config/lf
mkdir -p $DOTFILES_BACKUP_PATH/.config/vifm

mv ~/.config/lf $DOTFILES_BACKUP_PATH/.config/lf
mv ~/.config/vifm $DOTFILES_BACKUP_PATH/.config/vifm

echo "Your configs are moved via backup under $DOTFILES_BACKUP_PATH"


mkdir -p $DOTFILES_BACKUP_PATH
cp ../configs/.zshrc $DOTFILES_BACKUP_PATH
cp ../configs/.vimrc $DOTFILES_BACKUP_PATH
cp ../configs/.gitignore $DOTFILES_BACKUP_PATH
cp ../configs/.gitconfig $DOTFILES_BACKUP_PATH
cp ../configs/.editorconfig $DOTFILES_BACKUP_PATH
cp ../configs/.alacritty.toml $DOTFILES_BACKUP_PATH
cp ../configs/.tmux.conf $DOTFILES_BACKUP_PATH
cp ../configs/.lfrc $DOTFILES_BACKUP_PATH
cp ../configs/tmux.sh $DOTFILES_BACKUP_PATH
cp ../configs/wallpaper.jpeg $DOTFILES_BACKUP_PATH

cp -r ../.vscode $DOTFILES_BACKUP_PATH
cp -r ../.logseq $DOTFILES_BACKUP_PATH

cp -r ../configs/.config/lf ~/.config/lf
cp -r ../configs/.config/vifm ~/.config/vifm

echo "New configs are imported to ~/"
