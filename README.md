# 👻 Boo

_The lazy ghost_.

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
- Desktop & Dock → Desktop & State Manager → Click wallpaper to reveal desktop → Only in State Manager
- Control Center → Battery → Show Percentage → On
- Accessibility → Pointer Control → Trackpad Options → Use trackpad for dragging → On (Without Drag Lock)

## Finder Settings

- Remove all but Finder and Trash from the dock.
- `⌘ ,` → General → New Finder windows show → `~`
- `⌘ ,` → Sidebar → **only** `~`, `icloud documents`, and `Applications`
- `⌘ n` → Click "View as List" → `⌘ j` → Always open in list view → On → Use as Defaults

## iPhone Settings

- Settings → Apps → Messages → Text Message Forwarding → New Machine's Name → On

## GitHub Setup

[Generate an SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and [add it to GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

## After Xcode is installed

Install [homebrew](https://brew.sh/), install [applications](https://github.com/pachun/boo/blob/main/Brewfile), and symlink [dotfiles](https://github.com/pachun/boo/blob/main/dotfiles) by running:

```sh
mkdir code && cd code && git clone git@github.com:pachun/boo.git && cd boo && ./install.sh
```

Wait for that to finish; Then start postgres.

```sh
brew services start postgresql@17
```

## Add a dotfile

Since dotfiles are symlinked, you only need the following to add _new_ dotfiles. Existing dotfiles will "just work".

[Remove your dotfile from gitignore](https://github.com/pachun/boo/blob/main/.gitignore)

```sh
./dotfiles.sh
```

## Add a homebrew app

[Add a homebrew app](https://github.com/pachun/boo/blob/main/Brewfile)

```sh
brew bundle
```

## Add a keymap

[Add a keymap](https://github.com/pachun/boo/blob/main/dotfiles/config/nvim/lua/config/pachulski/keymaps.lua)

## Add an option

[Add an option](https://github.com/pachun/boo/blob/main/dotfiles/config/nvim/lua/config/pachulski/opts.lua)

## Add a Syntax highlighter

[Add a syntax highlighter](https://github.com/pachun/boo/blob/main/dotfiles/config/nvim/lua/config/pachulski/syntax_highlighters.lua)

## Add a language server

[Add a language server](https://github.com/pachun/boo/blob/main/dotfiles/config/nvim/lua/config/pachulski/language_servers.lua)

## Add a formatter

[Add a formatter](https://github.com/pachun/boo/blob/main/dotfiles/config/nvim/lua/config/pachulski/formatters.lua)

## Add a linter

[Add a linter](https://github.com/pachun/boo/blob/main/dotfiles/config/nvim/lua/config/pachulski/linters.lua)

## Add/Edit a lazy plugin

[Existing plugins](https://github.com/pachun/boo/tree/main/dotfiles/config/nvim/lua/plugins)

```sh
lplug plugin-name
```
