#!/bin/bash

# cf. tutorial at https://www.atlassian.com/git/tutorials/dotfiles

declare -a arr=("delta" "fd" "fzf" "lazygit" "tmux" "zellij" )
function ensure_is_installed (){
  if ! [ -x "$(command -v "$1")" ]; then
    echo "Error: $1 is not installed." >&2
    exit 1
  fi
}
if [ "$1" == "savefiles" ]; then
  git init --bare "$HOME"/.cfg;

  function config {
    /usr/bin/git --git-dir="$HOME"/.cfg/ --work-tree="$HOME" "$@"
  }
  config config --local status.showUntrackedFiles no;
  config config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*';
  echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> "$HOME"/.bashrc;

  function lazyconfig {
    lazygit --git-dir="$HOME"/.cfg/ --work-tree="$HOME" "$@"
  }
  echo "alias lazyconfig='lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> "$HOME"/.bashrc;

  # afterwards:
  # config status
  # config add .vimrc
  # config commit -m "Add vimrc"
  # config add .bashrc
  # config commit -m "Add bashrc"
  # config push
elif [ "$1" == "installfiles" ]; then

  # to be used with the following command:
  # curl -Lks https://raw.githubusercontent.com/AntoineBalaine/dotfiles/master/.dotfilescripts.sh | /bin/bash -s installfiles

  git clone --bare git@github.com:AntoineBalaine/dotfiles.git "$HOME"/.cfg
  function config {
    /usr/bin/git --git-dir="$HOME"/.cfg/ --work-tree="$HOME" "$@"
  }
  mkdir -p .config-backup
  config checkout
  if [ $? = 0 ]; then
    echo "Checked out config.";
    else
      echo "Backing up pre-existing dot files.";
      config checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
  fi;
  config checkout
  config config status.showUntrackedFiles no
  echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> "$HOME"/.bashrc;
  echo "alias lazyconfig='lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> "$HOME"/.bashrc;
  for program in "${arr[@]}"; do
    ensure_is_installed "$program"
  done
elif [ "$1" == "checkifinstalled" ]; then
  for program in "${arr[@]}"; do
    ensure_is_installed "$program"
  done
else
  echo "no command was run";
fi;

