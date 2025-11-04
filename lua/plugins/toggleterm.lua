return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
  start_in_insert = true,
  --open_mapping = [[<A-p>]],
  open_mapping = [[<leader>tt]],
  shell = ' "C:\\Program Files\\PowerShell\\7\\pwsh.exe" ',
  direction = 'float',
  hide_numbers = true,
  shade_filetypes = {},
  shading_factor = 2,
  persist_size = true,
  insert_mappings = true,
  terminal_mappings = true,
  close_on_exit = true,
  shade_terminals = true,
  winbar = 'Terminal',
      })
    end,
  }
}




