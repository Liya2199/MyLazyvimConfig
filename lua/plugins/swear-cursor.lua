--return {
--{
   -- "sphamba/smear-cursor.nvim",
   -- enabled = false,
	--config = function()
     -- require("smear_cursor").setup({
      --  cursor_color = "#fff3b0",
       -- stiffness = 0.3,
       -- gamma = 1,
                             -- 0.6      [0, 1]
    --trailing_stiffness = 0.6,             -- 0.45     [0, 1]
    --stiffness_insert_mode = 0.7,          -- 0.5      [0, 1]
    --trailing_stiffness_insert_mode = 0.7, -- 0.5      [0, 1]
    --damping = 0.95,                       -- 0.85     [0, 1]
    --damping_insert_mode = 0.95,           -- 0.9      [0, 1]
    --distance_stop_animating = 0.5,        -- 0.1      > 0
    --time_interval = 7, -- milliseconds
        
     -- })
   -- end,
--}
--}

return {
  "sphamba/smear-cursor.nvim",
  opts = {
    -- 优化性能配置
    time_interval = 7, -- 降低帧间隔，提高流畅度
    stiffness = 0.6, -- 增加刚性，让光标更紧跟
    trailing_stiffness = 0.6, -- 尾迹跟随性
    damping = 0.75, -- 减少振动
    damping_insert_mode = 0.95, -- 插入模式下的阻尼
    distance_stop_animating = 0.5, -- 停止动画的距离阈值
    
    -- 外观配置
    hide_target_hack = true, -- 避免光标闪烁
    cursor_color = "none", -- 使用文本颜色
    smear_between_buffers = true, -- 窗口切换时也显示拖尾
    smear_between_neighbor_lines = true, -- 行间移动时也显示
    scroll_buffer_space = true, -- 滚动时在缓冲区空间绘制
    
    -- 性能相关
    smear_insert_mode = true, -- 插入模式也启用拖尾
  }
}