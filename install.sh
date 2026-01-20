if [[ "$(uname)" == "Darwin" ]]; then
  OS="mac"
elif [[ -f /etc/arch-release ]]; then
  OS="arch"
fi

function install_monolisa_font {
  if [[ "$OS" == "mac" ]]; then
    cp $PWD/assets/MonoLisa/*.ttf $HOME/Library/Fonts/
  elif [[ "$OS" == "arch" ]]; then
    mkdir -p $HOME/.local/share/fonts
    cp $PWD/assets/MonoLisa/*.ttf $HOME/.local/share/fonts/
    fc-cache -fv
  fi
}

function set_desktop_wallpaper_on_mac {
  if [[ "$OS" == "mac" ]]; then
    osascript -e 'tell application "Finder" to set desktop picture to POSIX file "'$PWD/assets/less\ is\ less.png'"'
  fi
}

function install_package_manager {
  if [[ "$OS" == "mac" ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo >> ~/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ "$OS" == "arch" ]]; then
    sudo pacman -S --needed --noconfirm git base-devel
    # install yay (AUR helper) if not present
    if ! command -v yay &> /dev/null; then
      git clone https://aur.archlinux.org/yay.git /tmp/yay
      cd /tmp/yay && makepkg -si --noconfirm
      cd - > /dev/null
      rm -rf /tmp/yay
    fi
  fi
}

function install_packages {
  if [[ "$OS" == "mac" ]]; then
    brew bundle
  elif [[ "$OS" == "arch" ]]; then
    sudo pacman -S --needed --noconfirm \
      neovim tmux zsh ripgrep git base-devel rust unzip \
      hyprland hyprpaper waybar ttf-nerd-fonts-symbols noto-fonts-emoji network-manager-applet chromium openssh \
      zsh-syntax-highlighting direnv postgresql keyd \
      tree-sitter tree-sitter-cli wl-clipboard less pacman-contrib
    # audio
    sudo pacman -S --needed --noconfirm \
      pipewire pipewire-pulse pipewire-alsa wireplumber playerctl
    yay -S --needed --noconfirm swayosd-git
    # bluetooth
    sudo pacman -S --needed --noconfirm bluez bluez-utils blueman
    # portal for dark mode detection in browsers
    sudo pacman -S --needed --noconfirm xdg-desktop-portal xdg-desktop-portal-gtk
    yay -S --needed --noconfirm ghostty asdf-vm nordvpn-bin spotify
  fi
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
  mkdir -p "$HOME/.config"

  # shared dotfiles
  for file in $PWD/dotfiles/*; do
    filename=$(basename "$file")
    if [[ "$filename" == "config" ]]; then
      # symlink each item inside config individually
      for config_item in $PWD/dotfiles/config/*; do
        config_name=$(basename "$config_item")
        ln -sf "$config_item" "$HOME/.config/$config_name"
      done
    else
      ln -sf "$file" "$HOME/.$filename"
    fi
  done

  # os-specific dotfiles
  local os_dotfiles=""
  if [[ "$OS" == "arch" ]]; then
    os_dotfiles="$PWD/dotfiles-arch"
  elif [[ "$OS" == "mac" ]]; then
    os_dotfiles="$PWD/dotfiles-mac"
  fi

  if [[ -n "$os_dotfiles" && -d "$os_dotfiles" ]]; then
    for file in $os_dotfiles/*; do
      filename=$(basename "$file")
      if [[ "$filename" == "config" ]]; then
        for config_item in $os_dotfiles/config/*; do
          config_name=$(basename "$config_item")
          ln -sf "$config_item" "$HOME/.config/$config_name"
        done
      else
        ln -sf "$file" "$HOME/.$filename"
      fi
    done
  fi
}

function install_asdf_plugins {
  asdf plugin add nodejs
  asdf install nodejs lts
  asdf set -u nodejs lts

  asdf plugin add yarn
  asdf install yarn 1.22.22
  asdf set -u yarn 1.22.22
}

function install_claude {
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
  npm install -g @anthropic-ai/claude-code
}

function start_postgres {
  if [[ "$OS" == "mac" ]]; then
    brew services start postgresql@17
  elif [[ "$OS" == "arch" ]]; then
    sudo -u postgres initdb -D /var/lib/postgres/data
    sudo systemctl enable --now postgresql
  fi
}

function remap_keys_on_arch {
  if [[ "$OS" == "arch" ]]; then
    echo -e "[ids]\n*\n\n[main]\ncapslock = leftcontrol\nleftalt = leftmeta\nleftmeta = leftalt\n\n[meta]\nv = C-v\n\n[meta+shift]\n[ = C-S-tab\n] = C-tab" | sudo tee /etc/keyd/default.conf
    sudo systemctl enable --now keyd
  fi
}

function disable_ipv6_on_arch {
  if [[ "$OS" == "arch" ]]; then
    # Disable IPv6 to avoid 5s DNS timeouts on networks with broken IPv6
    # (router hands out IPv6 addresses but can't route IPv6 traffic)
    if [[ ! -f /etc/sysctl.d/40-ipv6.conf ]]; then
      echo -e "net.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1" | sudo tee /etc/sysctl.d/40-ipv6.conf
      sudo sysctl --system
    fi
  fi
}

function start_audio_on_arch {
  if [[ "$OS" == "arch" ]]; then
    systemctl --user enable --now pipewire pipewire-pulse wireplumber
  fi
}

function start_bluetooth_on_arch {
  if [[ "$OS" == "arch" ]]; then
    sudo systemctl enable --now bluetooth
  fi
}

function use_dark_mode_on_arch {
  if [[ "$OS" == "arch" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  fi
}

function setup_nordvpn_on_arch {
  if [[ "$OS" == "arch" ]]; then
    sudo systemctl enable --now nordvpnd
    sudo gpasswd -a $USER nordvpn
  fi
}

function use_zsh {
  chsh -s /bin/zsh
}

function sync_theme {
  $HOME/.config/bin/update-theme.sh
}

function install_nvim_plugins {
  nvim --headless "+Lazy! sync" +qa
  nvim --headless "+TSUpdateSync" +qa
}

function start_hyprland_on_arch {
  if [[ "$OS" == "arch" ]]; then
    start-hyprland
  fi
}

install_monolisa_font
set_desktop_wallpaper_on_mac
install_package_manager
install_packages
enable_asdf_autocompletions
create_gitconfig_dotfile
symlink_dotfiles
sync_theme
install_nvim_plugins
install_asdf_plugins
install_claude
start_postgres
remap_keys_on_arch
disable_ipv6_on_arch
start_audio_on_arch
start_bluetooth_on_arch
use_dark_mode_on_arch
setup_nordvpn_on_arch
use_zsh
start_hyprland_on_arch
