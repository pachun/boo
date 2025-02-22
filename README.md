# Boo

_The lazy ghost_.

Boo is a set of steps that I use to set up new or re-imaged Mac machines. It includes some manual steps and then some automated steps to install my apps and setup my terminal ([Ghostty](https://ghostty.org)), along with my dotfiles which mainly configure [Neovim](https://neovim.io) and [Lazy.nvim](https://lazy.folke.io/).

[Install Xcode](https://apps.apple.com/us/app/xcode/id497799835)
[Install Amphetamine](https://apps.apple.com/us/app/amphetamine/id937984704)
[Install ColorSlurp](https://apps.apple.com/us/app/colorslurp/id1287239339)
[Install Affinity Photo](https://apps.apple.com/us/app/affinity-photo-2-image-editor/id1616822987)

- System Settings → Trackpad → Tracking Speed → Move the slider all the way to the right
- System Settings → Trackpad → Tap to Click → On
- System Settings → Keyboard → Keyboard Shortcuts → Modifier Keys → Caps Lock → Control
- System Settings → Desktop & Dock → Automatically hide and show the Dock → On
- System Settings → Desktop & Dock → Desktop & State Manager → Click wallpaper to reveal desktop → Only in State Manager
- System Settings → Control Center → Battery → Show Percentage → On
- System Settings → Accessibility → Pointer Control → Trackpad Options → Use trackpad for dragging → On (Without Drag Lock)

Remove all but Finder and Trash from the dock.

In Finder's preferences, adjust what's in the sidebar. Favorites should be `~` and `Applications`. iCloud should only be `iCloud Drive`. Locations should only be `Machintosh HD`. Tags are useless. Remove everything not mentioned here.

Open a Finder folder window and change the view type from icon to list.

[Generate an SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and [add it to GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

Install [homebrew](https://brew.sh/), install [applications](https://github.com/pachun/puck-drop/blob/main/Brewfile), and symlink [dotfiles](https://github.com/pachun/puck-drop/blob/main/dotfiles) by running:

```sh
git clone git@github.com:pachun/puck-drop.git && cd puck-drop && ./install.sh
```

Start postgres.

```sh
brew services start postgresql@17
```

## Updating homebrew apps

1. Add an app to your Brewfile
1. Run `brew bundle`

## Updating dotfiles

Since dotfiles are symlinked, you only need to run this if you add a new dotfile. You don't need to run this if you edit an existing dotfile.

```sh
./dotfiles.sh
```

## Modifying lazy plugins

To modify a lazy.nvim plugin, type `lplug [name]`. For example:

```sh
lplug lualine
```
