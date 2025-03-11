function install_homebrew {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >> ~/.zprofile
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

function install_homebrew_apps {
  brew bundle
}

function enable_asdf_autcompletions {
  # https://asdf-vm.com/guide/getting-started.html#set-up-shell-completions-optional-3
  mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
  asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"
}

install_homebrew
install_homebrew_apps
enable_asdf_autocompletions
./dotfiles.sh
asdf plugin add yarn
