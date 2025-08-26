return {
{
    "sphamba/smear-cursor.nvim",
	config = function()
      require("smear_cursor").setup({
        cursor_color = "#fff3b0",
        stiffness = 0.3,
        gamma = 1,
        trailing_stiffness = 0.1,
        trailing_exponent = 5,
      })
    end,
}
}