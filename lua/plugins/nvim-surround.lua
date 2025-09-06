return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  config = function()
    local surround = require("nvim-surround")

    surround.setup({
      surrounds = {
        -- 小括号 ()，去掉内部空格
        ["("] = { add = { "(", ")" } },
        [")"] = { add = { "(", ")" } },
        -- 中括号 []，去掉内部空格
        ["["] = { add = { "[", "]" } },
        ["]"] = { add = { "[", "]" } },
        -- 大括号 {}，去掉内部空格
        ["{"] = { add = { "{", "}" } },
        ["}"] = { add = { "{", "}" } },
        -- 尖括号 <>，去掉内部空格
        ["<"] = { add = { "<", ">" } },
        [">"] = { add = { "<", ">" } },
      },
    })
  end,
}

