-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- My config
vim.g.root_spec = { "cwd" }
vim.g.lazyvim_picker = "fzf"

-- 防止出现使用Windows (CRLF) 的换行格式，而 Neovim 却以 Unix (LF) 格式在解析它。
-- 在 Windows 里，换行是 \r\n，而在 Unix/Linux 里只有 \n。
-- 当 Neovim 识别不出这是 Windows 格式时，就会把多出来的 \r 显示成 ^M。
vim.opt.fileformats = "unix,dos,mac"
