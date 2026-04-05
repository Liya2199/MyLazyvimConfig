-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


local function python_run()
  vim.cmd("silent! write")
  local filename = vim.fn.expand("%")
  -- 在下方打开新窗口运行（高度占 30%）
  vim.cmd("botright split | resize 30 | terminal python " .. filename)
  -- 进入终端插入模式（可选）
  vim.cmd("startinsert")
end

-- 绑定 <leader>rp 快捷键
vim.keymap.set("n", "<leader>rp", python_run, { desc = "Run Python file" })


local function cpp_run()
  vim.cmd("silent! write")
  local filename = '"'..vim.fn.expand("%:r")..'"'
  vim.cmd("botright split | resize 30 | terminal g++ % -o "..filename..".exe && .\\"..filename..".exe")
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>rc", cpp_run, { desc = "Run C++ file" })

local function rust_run()
  vim.cmd("silent! write")
  local filename = '"'..vim.fn.expand("%:r")..'"'
  vim.cmd("botright split | resize 30")
  vim.cmd("terminal cargo run")  
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>rr", rust_run, { desc = "Run Rust file" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })