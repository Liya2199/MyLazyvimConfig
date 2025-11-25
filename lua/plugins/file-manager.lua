function _G.get_oil_winbar()
	local dir = require('oil').get_current_dir()
	if dir then
		return vim.fn.fnamemodify(dir,':~')
	else
		return vim.api.nvim_buf_get_name(0)
	end
end



return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
	default_file_explorer = true,
	win_options = {
		winbar = '%!v:lua.get_oil_winbar()',
	}
	
  },
  -- Optional dependencies
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}