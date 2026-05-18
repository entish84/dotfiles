-- ========================================================================== --
-- Core Theme & Environment Initialization
-- ========================================================================== --
vim.o.background = "dark"

-- Theme Activation (Uncomment your preference; habamax is bundled natively)
vim.cmd.colorscheme "habamax"
-- vim.cmd.colorscheme "catppuccin-mocha"

-- ========================================================================== --
-- Native Cursor Configuration
-- ========================================================================== --
-- Custom cursor styling across modes:
--  - Normal/Visual/Command: Solid Block
--  - Insert/Replace/Terminal: Thin Vertical Line or Underline
--  - Enables responsive blinking behavior natively
vim.opt.guicursor = "n-v-c:block-Cursor/lCursor-blinkwait700-blinkoff400-blinkon250,"
  .. "i-ci-ve:ver25-Cursor/lCursor-blinkwait700-blinkoff400-blinkon250,"
  .. "r-cr:hor20-Cursor/lCursor,"
  .. "o:hor50-Cursor/lCursor,"
  .. "t:ver25-TerminalCursor-blinkwait700-blinkoff400-blinkon250"

-- ========================================================================== --
-- Dynamic Statusline Theme Color Engine
-- ========================================================================== --
local function setup_statusline_highlights()
  -- Safely extract background highlights from native structures
  local sl_bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg or 0x2c2e3e
  local sl_fg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).fg or 0xadbac7

  -- Define modern, vibrant mode blocks matching both habamax and catppuccin arcs
  local mode_colors = {
    Normal   = { bg = 0x61afef, fg = 0x1e1e2e }, -- Soft Blue
    Insert   = { bg = 0x98c379, fg = 0x1e1e2e }, -- Emerald Green
    Visual   = { bg = 0xc678dd, fg = 0x1e1e2e }, -- Purple / Violet
    Replace  = { bg = 0xe06c75, fg = 0x1e1e2e }, -- Crimson Red
    Command  = { bg = 0xe5c07b, fg = 0x1e1e2e }, -- Amber Yellow
    Terminal = { bg = 0x56b6c2, fg = 0x1e1e2e }, -- Teal
  }

  -- Register Mode Highlights
  for mode, colors in pairs(mode_colors) do
    vim.api.nvim_set_hl(0, "StatusMode" .. mode, { fg = colors.fg, bg = colors.bg, bold = true })
  end

  -- Context and Metadata Accent Highlights
  vim.api.nvim_set_hl(0, "StatusBase",       { fg = sl_fg, bg = sl_bg })
  vim.api.nvim_set_hl(0, "StatusFile",       { fg = sl_fg, bg = sl_bg, bold = true })
  vim.api.nvim_set_hl(0, "StatusModified",   { fg = 0xe06c75, bg = sl_bg, bold = true })
  vim.api.nvim_set_hl(0, "StatusGit",        { fg = 0x98c379, bg = sl_bg })
  
  -- Native LSP Diagnostic Highlights matching system colorschemes
  vim.api.nvim_set_hl(0, "StatusDiagError",  { fg = vim.api.nvim_get_hl(0, { name = "DiagnosticError" }).fg or 0xe06c75, bg = sl_bg })
  vim.api.nvim_set_hl(0, "StatusDiagWarn",   { fg = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }).fg or 0xe5c07b, bg = sl_bg })
  vim.api.nvim_set_hl(0, "StatusDiagHint",   { fg = vim.api.nvim_get_hl(0, { name = "DiagnosticHint" }).fg or 0x61afef, bg = sl_bg })
end

-- Re-trigger context colors when switching color schemes on-the-fly
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = setup_statusline_highlights,
})
setup_statusline_highlights()

-- ========================================================================== --
-- Statusline Data Compilation Engine
-- ========================================================================== --
local M = {}

-- Comprehensive Neovim Mode Mapper
local mode_map = {
  ["n"]    = { name = "NORMAL", hl = "StatusModeNormal" },
  ["no"]   = { name = "O-PEND", hl = "StatusModeNormal" },
  ["nov"]  = { name = "O-PEND", hl = "StatusModeNormal" },
  ["noV"]  = { name = "O-PEND", hl = "StatusModeNormal" },
  ["v"]    = { name = "VISUAL", hl = "StatusModeVisual" },
  ["V"]    = { name = "V-LINE", hl = "StatusModeVisual" },
  ["\22"]  = { name = "V-BLCK", hl = "StatusModeVisual" },
  ["s"]    = { name = "SELECT", hl = "StatusModeVisual" },
  ["S"]    = { name = "S-LINE", hl = "StatusModeVisual" },
  ["\19"]  = { name = "S-BLCK", hl = "StatusModeVisual" },
  ["i"]    = { name = "INSERT", hl = "StatusModeInsert" },
  ["ic"]   = { name = "INSERT", hl = "StatusModeInsert" },
  ["ix"]   = { name = "INSERT", hl = "StatusModeInsert" },
  ["R"]    = { name = "REPLAC", hl = "StatusModeReplace" },
  ["Rc"]   = { name = "REPLAC", hl = "StatusModeReplace" },
  ["Rx"]   = { name = "REPLAC", hl = "StatusModeReplace" },
  ["Rv"]   = { name = "V-RPLC", hl = "StatusModeReplace" },
  ["c"]    = { name = "COMMND", hl = "StatusModeCommand" },
  ["cv"]   = { name = "EX-MOD", hl = "StatusModeCommand" },
  ["ce"]   = { name = "NORMEX", hl = "StatusModeCommand" },
  ["r"]    = { name = "PROMPT", hl = "StatusModeCommand" },
  ["rm"]   = { name = "MORE  ", hl = "StatusModeCommand" },
  ["r?"]   = { name = "CONFIM", hl = "StatusModeCommand" },
  ["!"]    = { name = "SHELL ", hl = "StatusModeTerminal" },
  ["t"]    = { name = "TERMNL", hl = "StatusModeTerminal" },
}

-- 1. Mode Block Component
function M.get_mode()
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_info = mode_map[current_mode] or { name = "UNKNOW", hl = "StatusModeNormal" }
  return string.format("%%#%s#  %s  %%#StatusBase#", mode_info.hl, mode_info.name)
end

-- 2. Native Git Integration (Detects branch data populated natively or via gitsigns)
function M.get_git()
  local git_status = vim.b.gitsigns_status_dict or vim.g.gitsigns_status_dict
  if git_status and git_status.head and git_status.head ~= "" then
    return string.format("%%#StatusGit#  %s ", git_status.head)
  end
  return ""
end

-- 3. Optimized File Information Block (.NET, Cloud configs, Web paths)
function M.get_fileinfo()
  local file_path = vim.fn.expand("%:f")
  if file_path == "" then return " %#StatusFile#[No Name]" end
  
  -- Handle special terminal buffers gracefully
  if vim.bo.buftype == "terminal" then
    return string.format(" %%#StatusFile#󰞀 Terminal (%s)", vim.fn.fnamemodify(file_path, ":t"))
  end

  local file_name = vim.fn.fnamemodify(file_path, ":t")
  local dir_path = vim.fn.fnamemodify(file_path, ":h")
  
  local display_path = ""
  if dir_path ~= "." then
    display_path = vim.fn.pathshorten(dir_path) .. "/"
  end

  local modified = vim.bo.modified and "%#StatusModified# 󰶼" or ""
  local readonly = vim.bo.readonly and "%#StatusModified# 󰌾" or ""

  return string.format(" %%#StatusBase#%s%%#StatusFile#%s%s%s ", display_path, file_name, modified, readonly)
end

-- 4. Fast, Native LSP Diagnostics Pipeline
function M.get_diagnostics()
  if #vim.lsp.get_clients({ bufnr = 0 }) == 0 then return "" end

  -- Fast direct counting from modern internal diagnostic engines
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

  local result = ""
  if errors > 0 then   result = result .. string.format("%%#StatusDiagError#  %d", errors) end
  if warnings > 0 then result = result .. string.format("%%#StatusDiagWarn#  %d", warnings) end
  if hints > 0 then    result = result .. string.format("%%#StatusDiagHint# 󰌶 %d", hints) end

  return result ~= "" and result .. " " or ""
end

-- 5. Active Filetype & Context Flags
function M.get_filetype()
  local filetype = vim.bo.filetype
  if filetype == "" then return "No FT" end
  return string.format(" %s ", filetype:upper())
end

-- ========================================================================== --
-- Native Statusline Main Composition Blueprint
-- ========================================================================== --
function _G.StatusLine()
  return table.concat({
    M.get_mode(),        -- Left Side: Mode Indicator Block
    M.get_fileinfo(),    -- Left Center: Path and File Attributes
    M.get_git(),         -- Left Center: Smart Git State Indicator
    "%=",                -- Alignment Breakpoint (Pushes subsequent items Right)
    M.get_diagnostics(), -- Right Center: Core LSP Pipeline Metrics
    "%#StatusBase#",     -- Reset standard highlights
    M.get_filetype(),    -- Right Side: File Context Signature
    "%#StatusLine#",     -- Set position tracker background
    " %l:%c │ %p%% ",    -- Right Side: Line:Col coordinates / Progress %
  })
end

-- Bind the compiled engine directly to Neovim execution loops
vim.o.statusline = "%!v:lua.StatusLine()"
