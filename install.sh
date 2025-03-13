function install_monolisa_font {
  cp $PWD/assets/MonoLisa/*.ttf $HOME/Library/Fonts/
}

function set_desktop_wallpaper {
  osascript -e 'tell application "Finder" to set desktop picture to POSIX file "'$PWD/assets/less\ is\ less.png'"'
}

function install_homebrew {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >> ~/.zprofile
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

function install_homebrew_apps {
  brew bundle
}

function enable_asdf_autocompletions {
  # https://asdf-vm.com/guide/getting-started.html#set-up-shell-completions-optional-3
  mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
  asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
}

function create_gitconfig_dotfile {
  read -p "What name should show on your git commits? " git_name
  read -p "What email should show on your git commits? " git_email

  cat <<EOF > "$PWD/dotfiles/gitconfig"
[user]
  name = $git_name
  email = $git_email

[init]
  defaultBranch = main

[format]
  pretty = format:%C(yellow)%h%C(green)%d%Creset %C(blue)%s %C(magenta) [%an, %cr]%Creset

[core]
  editor = nvim
  excludesFile = ~/.gitignore
EOF
}

function symlink_dotfiles {
  for file in $PWD/dotfiles/*; do
    filename=$(basename "$file")
    ln -sf "$file" "$HOME/.$filename"
  done

  # remove infinitely recursed symlink
  rm -rf $PWD/dotfiles/config/config
}

function install_asdf_plugins {
  asdf plugin add yarn
}

function start_postgres {
  brew services start postgresql@17
}

install_monolisa_font
set_desktop_wallpaper
install_homebrew
install_homebrew_apps
enable_asdf_autocompletions
create_gitconfig_dotfile
symlink_dotfiles
install_asdf_plugins
start_postgres
