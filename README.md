# 👻 Boo

_The lazy ghost_.

![Ghostty Screenshot](assets/ghostty-screenshot.png)

Boo is a set of steps that I use to set up new or re-imaged Mac machines. It includes manual and automated steps to configure my system settings, install my apps and setup my terminal ([Ghostty](https://ghostty.org)). My dotfiles are also installed, which mainly configure [Neovim](https://neovim.io) and some [Lazy.nvim](https://lazy.folke.io/) plugins.

[Install Xcode](https://apps.apple.com/us/app/xcode/id497799835)

[Install Amphetamine](https://apps.apple.com/us/app/amphetamine/id937984704)

[Install Bear](https://apps.apple.com/us/app/bear-markdown-notes/id1091189122)

[Install ColorSlurp](https://apps.apple.com/us/app/colorslurp/id1287239339)

[Install Affinity Photo](https://apps.apple.com/us/app/affinity-photo-2-image-editor/id1616822987)

[Install the MonoLisa font](https://github.com/pachun/boo/tree/main/assets/MonoLisa)

[Set your desktop wallpaper](https://github.com/pachun/boo/blob/main/assets/less%20is%20less.png)

## System Settings

- Trackpad → Tracking Speed → Move the slider all the way to the right
- Trackpad → Tap to Click → On
- Keyboard → Keyboard Shortcuts → Modifier Keys → Caps Lock → Control
- Desktop & Dock → Automatically hide and show the Dock → On
- Desktop & Dock → Desktop & Stage Manager → Click wallpaper to reveal desktop → Only in Stage Manager
- Desktop & Dock → Desktop & Stage Manager → Show Items → On Desktop → Off
- Control Center → Battery → Show Percentage → On
- Accessibility → Pointer Control → Trackpad Options → Use trackpad for dragging → On (Without Drag Lock)

## Finder Settings

- Remove all but Finder and Trash from the dock.
- `⌘ ,` → General → New Finder windows show → `~`
- `⌘ ,` → Sidebar → **only** `~`, `icloud documents`, and `Applications`
- `⌘ n` → Click "View as List" → `⌘ j` → Always open in list view → On → Use as Defaults

## Safari Settings

- `⌘ ,` → Advanced → Show features for web developers → On

## iPhone Settings

- Settings → Apps → Messages → Text Message Forwarding → New Machine's Name → On

## GitHub Setup

[Generate an SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and [add it to GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

## After Xcode is installed

Install [homebrew](https://brew.sh/), install [applications](https://github.com/pachun/boo/blob/main/Brewfile), and symlink [dotfiles](https://github.com/pachun/boo/blob/main/dotfiles) by running:

```sh
mkdir code && cd code && git clone git@github.com:pachun/boo.git && cd boo && ./install.sh
```

You'll eventually be prompted to enter the name and email you want to be shown on your git commits.

After that finishes, start postgres.

```sh
brew services start postgresql@17
```

## Usage

- [Themes](https://github.com/pachun/boo/blob/main/dotfiles/config/theme)
- [Keymaps](https://github.com/pachun/boo/blob/main/dotfiles/config/nvim/lua/config/personal/keymaps.lua)
- [Language Servers](https://github.com/pachun/boo/blob/main/dotfiles/config/nvim/lua/config/personal/language_servers.lua)
- [Syntax Highlighters](https://github.com/pachun/boo/blob/main/dotfiles/config/nvim/lua/config/personal/syntax_highlighters.lua)
- [Formatters](https://github.com/pachun/boo/blob/main/dotfiles/config/nvim/lua/config/personal/formatters.lua)
- [Linters](https://github.com/pachun/boo/blob/main/dotfiles/config/nvim/lua/config/personal/linters.lua)
- [Options](https://github.com/pachun/boo/blob/main/dotfiles/config/nvim/lua/config/personal/opts.lua)
- [Aliases](https://github.com/pachun/boo/blob/146b85047116fd85938b64593851bb72fd8b7e52/dotfiles/zshrc#L98)
- [Homebrew apps](https://github.com/pachun/boo/blob/main/Brewfile) (`brew bundle` after changing)

## Adding a dotfile

1. [Add a dotfile](https://github.com/pachun/boo/tree/main/dotfiles) (without the dot prefix)
1. [Remove your dotfile from gitignore](https://github.com/pachun/boo/blob/main/.gitignore)
1. Run `./dotfiles.sh` to symlink it to ~/.dotfile_name

## Adding/Editing a Lazy.nvim plugins

[You can view existing plugins here](https://github.com/pachun/boo/tree/main/dotfiles/config/nvim/lua/plugins).

You can add or edit a plugin with [`lplug plugin-name`](https://github.com/pachun/boo/blob/146b85047116fd85938b64593851bb72fd8b7e52/dotfiles/zshrc#L113). For example:

```sh
lplug telescope
```

## License

In case anyone comes across this and likes it enough to want it, [please take whatever you want](https://github.com/pachun/boo/blob/main/LICENSE).
