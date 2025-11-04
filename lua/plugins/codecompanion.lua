return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("codecompanion").setup {
        display = {        
		diff = {
      enabled = true,
      }},
            adapters = {
                gemini = function()
                    return require("codecompanion.adapters").extend("gemini", {
                        env = {
                            model = "gemini-2.5-flash",
                            
                        },
                    })
                end,
            },
            strategies = {
                chat = {
                    adapter = "gemini",
                },
                inline = {
                    adapter = "gemini",
                },
            },
            log_level = "DEBUG",
        }

        local keymap = vim.keymap

        keymap.set("n", "<leader>cc", "<cmd>CodeCompanionChat<CR>", { desc = "Open Code Companion Chat" })
        keymap.set("n", "<leader>ci", "<cmd>CodeCompanion<CR>", { desc = "Open Code Companion Inline" })
    end,
}