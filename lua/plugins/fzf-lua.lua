return {
  {
    "ibhagwan/fzf-lua",
    opts = function(_, opts)
      local config = require("fzf-lua.config")
      -- 自定义布局：比如让预览窗口在右侧占 60%
      opts.winopts = {
        height = 0.85,
        width = 0.80,
        preview = {
          layout = "flex",
          horizontal = "right:60%",
        },
      }
      -- 让搜索结果包含当前 session 的历史文件
      opts.oldfiles = {
        include_current_session = true,
      }
      -- 如果你想用 fzf 处理 vim.ui.select (比如代码重构时的选择框)
      require("fzf-lua").register_ui_select()
    end,
  },
}