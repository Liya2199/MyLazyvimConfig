return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      -- 打开文件不顶掉树窗口，树常驻
      -- press H to unhide files
      open_files_in_last_window = true,
      window = { width = 34 },
      filesystem = {
        group_empty_dirs = true,
        filtered_items = {
          -- 默认显示 dotfiles / dotfolders（.gitignore、.env、.git、.venv 都能看到）
          hide_dotfiles = false,
          hide_gitignored = true,
          -- 只按名字隐藏纯噪音目录；想显示就删掉对应项
          hide_by_name = { "node_modules", "dist", "__pycache__" },
        },
      },
    },
  },
}
