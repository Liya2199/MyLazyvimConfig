-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
--
vim.g.root_spec = { "cwd" }
vim.o.termguicolors = true --硬件加速



--vim.opt.shada = "'100,<50, s10,h" --减少历史记录缓存
--vim.opt.undolevels = 1000--从款以10000减少1000
--vim.opt.undoreload = 100--从默试1000减少到100
vim.opt.updatetime = 300--从200ms增加到500ms减少后台刷新频率
--vim.opt.foldmethod = "manual"--禁用自动折叠，改用手动折叠
--vim.opt.synmaxcol=200--超过200列停止语法高亮


vim.lsp.set_log_level("off")



vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
  
  --禁用大型文件的语法高亮和折叠
    local large_file = vim.fn.getfsize(vim.fn.expand("%"))  > 1024*1024   -- 1MB
	if large_file then
	  vim.cmd("setlocal syntax foldmethod=manual")
	  vim.b.miniindentscope_disable = true  --禁用缩进线渲染
	end
  end


})