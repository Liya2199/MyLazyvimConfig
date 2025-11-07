return {
--  "yetone/avante.nvim",
 
--  build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
--    or "make",
--  event = "VeryLazy",
--  version = false, -- Never set this value to "*"! Never!
 
--  opts = {
   
--    instructions_file = "avante.md",
    
--    provider = "gemini",
--    providers = {
--      gemini = {
--        model = "gemini-2.5-flash",
--        temperature = 0.5,
--        max_tokens = 20480,
--        endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
--        timeout = 30000, -- Timeout in milliseconds
--      },
--      moonshot = {
--        endpoint = "https://api.moonshot.ai/v1",
--        model = "kimi-k2-0711-preview",
--        timeout = 30000, -- Timeout in milliseconds
--        extra_request_body = {
--          temperature = 0.75,
--          max_tokens = 32768,
--        },
--      },
      
--    },
--  },
--  dependencies = {
--    "nvim-lua/plenary.nvim",
--    "MunifTanjim/nui.nvim",
   
--    "nvim-mini/mini.pick", -- for file_selector provider mini.pick
--    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
--    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
--    "ibhagwan/fzf-lua", -- for file_selector provider fzf
--    "stevearc/dressing.nvim", -- for input provider dressing
--    "folke/snacks.nvim", -- for input provider snacks
--    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
--    "zbirenbaum/copilot.lua", -- for providers='copilot'
--    {
      
--      "HakonHarnes/img-clip.nvim",
--      event = "VeryLazy",
--      opts = {

--        default = {
--          embed_image_as_base64 = false,
--          prompt_for_file_name = false,
--          drag_and_drop = {
--            insert_mode = true,
--          },
          
--          use_absolute_path = true,
--        },
--      },
--    },
--    {
      
--      "MeanderingProgrammer/render-markdown.nvim",
--      opts = {
--        file_types = { "markdown", "Avante" },
--      },
--      ft = { "markdown", "Avante" },
--    },
--  },
}
