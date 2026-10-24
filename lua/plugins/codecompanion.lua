-- ============================================================
-- ModelScope 模型清单（原来是写死的 4 个，早已跟线上对不上）
--   1) 实时请求 /v1/models（内存缓存 30 分钟）
--   2) 断网 / 没 key 时读上次成功拉取的磁盘缓存（Qwen 上新也不用改配置）
--   3) 从没成功过，才用下面的静态清单兜底
-- 手动查看：:CCModels   清缓存重拉：:CCModelsRefresh
-- ============================================================
local MODELSCOPE_BASE = "https://api-inference.modelscope.cn"
local MODELSCOPE_TTL = 30 * 60
local MODELSCOPE_DEFAULT = "deepseek-ai/DeepSeek-V4.1-Flash-1017"

local modelscope_cache = { models = nil, expires = 0 }

---@type table<string, table>
local MODELSCOPE_FALLBACK = {
  [MODELSCOPE_DEFAULT] = {
    formatted_name = "DeepSeek V4.1 Flash 1017",
    meta = { context_window = 131072 },
    opts = { can_reason = true, can_use_tools = true },
  },
  ["deepseek-ai/DeepSeek-V4.1-Flash"] = {
    formatted_name = "DeepSeek V4.1 Flash",
    meta = { context_window = 131072 },
    opts = { can_reason = true, can_use_tools = true },
  },
  -- Qwen3.8 家族（id 已按你的实际清单核对）
  -- context_window 是保守值：宁可让上下文管理早触发，也别把请求撑爆
  ["Qwen/Qwen-3.8-Flash-Next"] = {
    formatted_name = "Qwen3.8 Flash Next",
    meta = { context_window = 131072 },
    opts = { can_reason = true, can_use_tools = true },
  },
  ["Qwen/Qwen3.8-27B"] = {
    formatted_name = "Qwen3.8 27B",
    meta = { context_window = 131072 },
    opts = { can_reason = true, can_use_tools = true },
  },
  ["Qwen/Qwen3-Coder-30B-A3B-Instruct"] = {
    formatted_name = "Qwen3 Coder 30B A3B",
    meta = { context_window = 131072 },
    opts = { can_reason = true, can_use_tools = true },
  },
  ["Qwen/Qwen3-Next-80B-A3B-Instruct"] = {
    formatted_name = "Qwen3 Next 80B A3B",
    meta = { context_window = 131072 },
    opts = { can_reason = true, can_use_tools = true },
  },
}

local MODELSCOPE_CACHE_DIR = vim.fn.stdpath("data") .. "/codecompanion"
local MODELSCOPE_CACHE_FILE = MODELSCOPE_CACHE_DIR .. "/modelscope_models.json"
local modelscope_source = "static"

---把模型 id 转成好看点的名字：Qwen/Qwen3.8-Max -> Qwen3.8 Max
---@param id string
---@return string
local function modelscope_pretty(id)
  local tail = id:match("([^/]+)$") or id
  return (tail:gsub("[-_]", " "))
end

---@param id string
---@return table
local function modelscope_entry(id)
  return MODELSCOPE_FALLBACK[id] or {
    formatted_name = modelscope_pretty(id),
    opts = { can_reason = true, can_use_tools = true },
  }
end

---@param ids string[]
local function modelscope_write_cache(ids)
  if vim.fn.isdirectory(MODELSCOPE_CACHE_DIR) == 0 then
    vim.fn.mkdir(MODELSCOPE_CACHE_DIR, "p")
  end
  pcall(vim.fn.writefile, { vim.json.encode(ids) }, MODELSCOPE_CACHE_FILE)
end

---@return table<string, table>|nil
local function modelscope_read_cache()
  local ok, lines = pcall(vim.fn.readfile, MODELSCOPE_CACHE_FILE)
  if not ok or type(lines) ~= "table" or #lines == 0 then
    return nil
  end

  local decoded, ids = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not decoded or type(ids) ~= "table" then
    return nil
  end

  local models = {}
  for _, id in ipairs(ids) do
    if type(id) == "string" then
      models[id] = modelscope_entry(id)
    end
  end

  if vim.tbl_count(models) == 0 then
    return nil
  end
  return models
end

---实时拉取 ModelScope 模型列表
---@return table<string, table>|nil
local function modelscope_fetch()
  local api_key = vim.env.MODELSCOPE_API_KEY
  if not api_key or api_key == "" then
    return nil
  end

  local ok, res = pcall(function()
    return require("plenary.curl").get(MODELSCOPE_BASE .. "/v1/models", {
      sync = true,
      timeout = 15000,
      headers = { Authorization = "Bearer " .. api_key },
    })
  end)
  if not ok or type(res) ~= "table" or res.status ~= 200 or type(res.body) ~= "string" then
    return nil
  end

  local decoded, json = pcall(vim.json.decode, res.body)
  if not decoded or type(json) ~= "table" or type(json.data) ~= "table" then
    return nil
  end

  local models, ids = {}, {}
  for _, item in ipairs(json.data) do
    local id = type(item) == "table" and (item.id or item.model) or nil
    -- 过滤掉非对话类模型，免得选择框里混进 embedding / rerank
    if id and not id:lower():match("embedding") and not id:lower():match("rerank") then
      -- 线上清单决定"有哪些"，静态表决定"怎么显示"（友好名 / 上下文窗口）
      models[id] = modelscope_entry(id)
      ids[#ids + 1] = id
    end
  end

  if vim.tbl_count(models) == 0 then
    return nil
  end
  modelscope_write_cache(ids) -- 记住这次结果，断网时还能用
  return models
end

---@return table<string, table>
local function modelscope_models()
  if modelscope_cache.models and modelscope_cache.expires > os.time() then
    return modelscope_cache.models
  end

  local live = modelscope_fetch()
  if live then
    modelscope_source = "live"
    modelscope_cache.models, modelscope_cache.expires = live, os.time() + MODELSCOPE_TTL
    return live
  end

  local cached = modelscope_read_cache()
  if cached then
    modelscope_source = "cache"
    modelscope_cache.models, modelscope_cache.expires = cached, os.time() + MODELSCOPE_TTL
    return cached
  end

  modelscope_source = "static"
  return MODELSCOPE_FALLBACK
end

---@return string
local function modelscope_default()
  local models = modelscope_models()
  for _, id in ipairs({ MODELSCOPE_DEFAULT, "Qwen/Qwen3-Coder-30B-A3B-Instruct" }) do
    if models[id] then
      return id
    end
  end
  local ids = vim.tbl_keys(models)
  table.sort(ids)
  return ids[1]
end

return {
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    init = function()
      vim.api.nvim_create_user_command("CCModels", function()
        local models = modelscope_models()
        local ids = vim.tbl_keys(models)
        table.sort(ids)
        vim.notify(
          ("ModelScope 模型（%d 个，来源：%s）\n%s"):format(#ids, modelscope_source, table.concat(ids, "\n")),
          vim.log.levels.INFO
        )
      end, { desc = "CodeCompanion: 列出 ModelScope 可用模型" })

      vim.api.nvim_create_user_command("CCModelsRefresh", function()
        modelscope_cache.models, modelscope_cache.expires = nil, 0
        local models = modelscope_models()
        vim.notify(("已刷新模型清单，当前 %d 个"):format(vim.tbl_count(models)), vim.log.levels.INFO)
      end, { desc = "CodeCompanion: 重拉 ModelScope 模型清单" })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        http = {
          -- ModelScope 适配器（白嫖：免费额度走 api-inference，环境变量 MODELSCOPE_API_KEY）
          modelscope = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "_modelscope",
              formatted_name = "ModelScope",
              env = {
                api_key = "MODELSCOPE_API_KEY",
                url = "https://api-inference.modelscope.cn",
                chat_url = "/v1/chat/completions",
                models_endpoint = "/v1/models",
              },
              handlers = {
                -- 提取 reasoning_content（旧格式名 parse_message_meta，与内置 deepseek/kimi 同款）
                parse_message_meta = require("codecompanion.adapters.http.deepseek").handlers.response.parse_meta,
                -- 解析 modelscope 响应头配额（discussion #2395：必须保持旧格式，扁平挂在 handlers 下）
                on_exit = function(self, data)
                  require("codecompanion.adapters.http.openai").handlers.on_exit(self, data)
                  local headers = data and data.headers
                  if not headers then
                    return
                  end
                  local mappings = {
                    ["Modelscope-Ratelimit-Requests-Limit"] = "user_daily_limit",
                    ["Modelscope-Ratelimit-Requests-Remaining"] = "user_daily_remaining",
                    ["Modelscope-Ratelimit-Model-Requests-Limit"] = "model_daily_limit",
                    ["Modelscope-Ratelimit-Model-Requests-Remaining"] = "model_daily_remaining",
                  }
                  local parsed = {}
                  for _, hs in ipairs(headers) do
                    local key, value = string.match(hs, "([^:]+):%s*(.+)")
                    if key and value then
                      parsed[key] = value
                    end
                  end
                  local quota = {}
                  for header_name, quota_key in pairs(mappings) do
                    if parsed[header_name] then
                      quota[quota_key] = parsed[header_name]
                    end
                  end
                  if next(quota) then
                    vim.notify(
                      string.format(
                        "ModelScope 额度 → 今日请求: %s/%s, 本模型: %s/%s",
                        quota.user_daily_remaining or "?",
                        quota.user_daily_limit or "?",
                        quota.model_daily_remaining or "?",
                        quota.model_daily_limit or "?"
                      )
                    )
                  end
                end,
              },
              schema = {
                model = {
                  -- 函数形式：打开模型选择框时才按需拉取，清单永远跟线上一致
                  default = modelscope_default,
                  choices = modelscope_models,
                },
              },
            })
          end,
        },
      },
      interactions = {
        chat = { adapter = "modelscope" },
        inline = { adapter = "modelscope" },
      },

      -- 界面美化（依然配合你的 render-markdown）
      display = {
        chat = {
          render_distractions = false,
          --show_settings = true, -- 这样你能在窗口顶部看到当前适配器
        },
        action_palette = {
          width = 95,
          height = 10,
          prompt = "Prompt",
          provider = "default",
          opts = {
            show_preset_actions = true,
            show_preset_prompts = true,
            title = "CodeCompanion actions",
          },
        },
      },
    },
    keys = {
      { "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI Chat" },
      { "<leader>ay", "<cmd>CodeCompanion<cr>", desc = "AI Inline (Code)" },
      -- visual 模式按 `:` 会自动预填 '\<,'>，RHS 不要再写 range，否则会变成双重范围报错；mode "v" 自动覆盖 v/V/^V 三种 visual
      { "<leader>ay", ":CodeCompanion<CR>", mode = "v", desc = "AI Inline (Selection)" },
      { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to AI Chat" },
      { "<leader>ak", "<cmd>CodeCompanionActions<cr>", desc = "AI Actions" },
      { "<leader>ar", "<cmd>CodeCompanionCodeReview<cr>", desc = "AI Code Review" },
    },
  },
}