-- install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- configurate vim & lazy.nvim
require("config.pachulski.vim")
require("config.pachulski.tmux-test")
require("lazy").setup({
  spec = { {
    -- install plugins
    import = "plugins",
  } },

  checker = {
    -- notice when plugins have updates available (lualine will use these)
    enabled = true,
    -- hide vim messages when plugins have updates available (they're annoying and force you to hit enter)
    notify = false,
  },

  change_detection = {
    -- update plugins when their files are saved
    enabled = true,
    -- hide vim messages when plugin files are saved (they're annoying and force you to hit enter)
    notify = false,
  },
})
