return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      --adapters = {
        -- 配置 DeepSeek 适配器
        --deepseek = function()
         -- return require("codecompanion.adapters").extend("deepseek", {
          --  env = {
              -- 推荐做法：在系统变量中设置 DEEPSEEK_API_KEY
         --     api_key = os.getenv("DEEPSEEK_API_KEY"), 
              --api_key = function() return os.getenv("DEEPSEEK_API_KEY") end,
         --   },
            
        --  })
       -- end,
     -- },
      
     
      -- 界面美化（依然配合你的 render-markdown）
      display = {
        chat = {
          render_distractions = false,
          --show_settings = true, -- 这样你能在窗口顶部看到 DeepSeek 已经在运行
        },
      },
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI Chat" },
      { "<leader>ac", "<cmd>CodeCompanion<cr>", desc = "AI Inline (Code)" },
      { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to AI Chat" },
    },
  },
}