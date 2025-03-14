# 👻 Boo

_The lazy ghost_.

<picture>
  <source srcset="assets/screenshot-dark.png" media="(prefers-color-scheme: dark)">
  <source srcset="assets/screenshot-light.png" media="(prefers-color-scheme: light)">
  <img src="screenshot-light.png" alt="Screenshot">
</picture>

Boo is a list of things that I install and configure on new or re-imaged Mac machines.

- [Apps](#apps)
- [System Settings](#system-settings)
- [Finder Settings](#finder-settings)
- [Safari Settings](#safari-settings)
- [iPhone Settings](#iphone-settings)
- [GitHub Setup](#github-setup)
- [Dotfiles](#dotfiles)

## Install

Xcode takes a while to install and is required to [install the dotfiles](#dotfiles).

### Apps

- [Xcode](https://apps.apple.com/us/app/xcode/id497799835)
- [Amphetamine](https://apps.apple.com/us/app/amphetamine/id937984704)
- [Bear](https://apps.apple.com/us/app/bear-markdown-notes/id1091189122)
- [ColorSlurp](https://apps.apple.com/us/app/colorslurp/id1287239339)
- [Affinity Photo](https://apps.apple.com/us/app/affinity-photo-2-image-editor/id1616822987)

### System Settings

- Trackpad → Tracking Speed → Move the slider all the way to the right
- Trackpad → Tap to Click → On
- Keyboard → Keyboard Shortcuts → Modifier Keys → Caps Lock → Control
- Desktop & Dock → Dock → Automatically hide and show the Dock → On
- Desktop & Dock → Dock → Show suggested and recent apps in Dock → On
- Desktop & Dock → Desktop & Stage Manager → Show Items → On Desktop → Off
- Desktop & Dock → Desktop & Stage Manager → Click wallpaper to reveal desktop → Only in Stage Manager
- Control Center → Battery → Show Percentage → On
- Accessibility → Pointer Control → Trackpad Options → Use trackpad for dragging → On (Without Drag Lock)
- Touch ID & Password → Apple Watch → Use Apple Watch to unlock your applications and your Mac. → Apple Watch Name → On

### Finder Settings

- Remove all but Finder and Trash from the dock
- `⌘ ,` → General → New Finder windows show → `~`
- `⌘ ,` → Sidebar → **only** `~`, `icloud documents`, and `Applications`
- `⌘ n` → Click "View as List" → `⌘ j` → Always open in list view → On → Use as Defaults

### Safari Settings

- `⌘ ,` → Advanced → Show features for web developers → On

### iPhone Settings

- Settings → Apps → Messages → Text Message Forwarding → New Machine's Name → On

### GitHub Setup

[Generate an SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and [add it to GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

### Dotfiles

- [Xcode must be installed](https://apps.apple.com/us/app/xcode/id497799835)
- [Your SSH key must be added to GitHub](#github-setup)

```sh
mkdir code && cd code && git clone git@github.com:pachun/boo.git && cd boo && ./install.sh
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
- [Homebrew apps](https://github.com/pachun/boo/blob/main/Brewfile)

### Adding a dotfile

1. [Add a dotfile](https://github.com/pachun/boo/tree/main/dotfiles) (without the dot prefix)
1. [Remove your dotfile from gitignore](https://github.com/pachun/boo/blob/main/.gitignore)
1. Symlink the dotfile: `ln -sf "$PWD/dotfiles/my_dotfile" "$HOME/.my_dotfile"`

### Adding/Editing Lazy.nvim plugins

[Installed plugins](https://github.com/pachun/boo/tree/main/dotfiles/config/nvim/lua/plugins)

Add or edit a plugin with `lplug plugin-name`. For example:

```sh
lplug telescope
```

## License

In case anyone comes across this and likes it enough to want it, [please take whatever you want](https://github.com/pachun/boo/blob/main/LICENSE).

Apps and dotfiles are personal, but the installation is not. Everything is tailored to my preferences but remains installer-agnostic.

## To Do

- Keep nvim-tree title at the top of the file explorer & retake readme screenshot (like a RN FlatList sticky header)
- I'd _really_ love to automate the whole installation process, but there are still a lot of manual steps. I haven't found a way that I'm happy with, for instance, to automate setting the system preferences. If you know of a way, please either [email me](mailto:nick@pachulski.me) or [submit a PR](https://github.com/pachun/boo/pulls). If it works, I will Venmo you $5.
