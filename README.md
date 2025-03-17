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
- [Calendar Settings](#calendar-settings)
- [iPhone Settings](#iphone-settings)
- [GitHub Setup](#github-setup)
- [Dotfiles](#dotfiles)
- [Open & Setup Installed Apps](#open-&-setup-installed-apps)

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
- Control Center → Menu Bar Only → Weather → Show in Menu Bar
- Accessibility → Pointer Control → Trackpad Options → Use trackpad for dragging → On (Without Drag Lock)
- Touch ID & Password → Apple Watch → Use Apple Watch to unlock your applications and your Mac. → Apple Watch Name → On

### Finder Settings

- Remove all but Finder and Trash from the dock
- `⌘ ,` → General → New Finder windows show → `~`
- `⌘ ,` → Sidebar → **only** `~`, `icloud documents`, and `Applications`
- `⌘ n` → Click "View as List" → `⌘ j` → Always open in list view → On → Use as Defaults

### Safari Settings

- `⌘ ,` → Advanced → Show features for web developers → On
- [Install Privacy](https://apps.apple.com/us/app/privacy-for-safari/id6449850851)

### Calendar Settings

- `⌘ ,` → Accounts → Add → Google → Only allow access to Contacts & Calendar

### iPhone Settings

_This automatically happened on my last Sequioa 15.3.2 upgrade. We may be able to remove this section._

- Settings → Apps → Messages → Text Message Forwarding → New Machine's Name → On

### GitHub Setup

[Generate an SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and [add it to GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

### Dotfiles

- [Xcode must be installed](https://apps.apple.com/us/app/xcode/id497799835)
- [Your SSH key must be added to GitHub](#github-setup)

```sh
mkdir code && cd code && git clone git@github.com:pachun/boo.git && cd boo && ./install.sh
```

### Open & Setup Installed Apps

- Ghostty → Open Neovim (`vim`) → Lazy will open and install plugins
- Spotify → Sign in
- ChatGPT → Sign in
- NordVPN → Sign in
  - Settings → Appearance → Show application in → Menu Bar
- Rectangle
- Amphetamine
  - Settings → Triggers → Enable (Disallow Bluetooth)
  - Settings → Triggers → Add Trigger
    - Name: Keep Awake When Connected to Power & External Display
    - Criteria:
      - Battery & Power Adapter → Only when power adapter is connected → Add Criterion
      - Displays → Display Count = 1 → Ignore built-in display → On → Add Criterion
    - Allow system to sleep when display is closed → Off
    - Allow screen saver to run after 1 hour of inactivity
- System Settings → General → Login Items & Extensions → Open at Login:
  - NordVPN
  - Amphetamine
  - Rectangle

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

- I'd _really_ love to automate the whole installation process, but there are still a lot of manual steps. I haven't found a way that I'm happy with, for instance, to automate setting the system preferences. If you know of a way, please either [email me](mailto:nick@pachulski.me) or [submit a PR](https://github.com/pachun/boo/pulls). If it works, I will Venmo you $5.

  - Note to self: I think the most promising way to do this is with `defaults write`. If you run `defaults read > prefs`, initialize a git repo, make a change to a preference, and then run `defaults read > prefs` again, you can see the relavant changes in the prefs file related to the preferences change. However, they don't seem to propogate when I try to make the same change with defaults write. For example, when I run this:

    ```sh
    defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    killall Finder
    killall SystemUIServer
    ```

    Which I think, should change the preference "Enable tap to click" from off to on, it's not changed in the Settings app UI, nor does tap to click begin working.

- Add dark/light mode wallpapers - ChatGPT has info about a few ways we can do this
