local map = vim.keymap.set
local sev = vim.diagnostic.severity

-- ========================================================================== --
-- Deep Dark Color Palette (Optimized for Habamax & Catppuccin Mocha)
-- ========================================================================== --
local palette = {
  error_bg = "#2d1a1e", -- Subtle muted crimson tint
  warn_bg  = "#2a241a", -- Muted dark amber tint
  info_bg  = "#1a2430", -- Deep slate blue tint
  hint_bg  = "#1a2a1a", -- Dark forest moss tint
}

-- Apply native full-line tracking highlight groups
vim.api.nvim_set_hl(0, "DiagnosticErrorLine", { bg = palette.error_bg })
vim.api.nvim_set_hl(0, "DiagnosticWarnLine",  { bg = palette.warn_bg })
vim.api.nvim_set_hl(0, "DiagnosticInfoLine",  { bg = palette.info_bg })
vim.api.nvim_set_hl(0, "DiagnosticHintLine",  { bg = palette.hint_bg })

-- ========================================================================== --
-- Native Debugger Engine Sign Configurations (DAP)
-- ========================================================================== --
vim.api.nvim_set_hl(0, "DapBreakpointSign", { fg = "#f38ba8", bold = true })
vim.fn.sign_define("DapBreakpoint", {
  text = "●", 
  texthl = "DapBreakpointSign", 
  linehl = "", 
  numhl = "", 
})

-- ========================================================================== --
-- Core Asynchronous Diagnostic Engine Configurations
-- ========================================================================== --
vim.diagnostic.config({
  underline = true,      -- Keep errors underlined for rapid code scanning
  severity_sort = true,   -- Prioritize high-impact items (Errors > Warnings)
  update_in_insert = false, -- Disable updates while typing to eliminate display flickering
  
  -- Floating Window configuration profiles
  float = {
    border = "rounded",
    source = "always",    -- Explicitly shows source namespace (e.g., Roslyn, Pyright, tsserver)
    focusable = false,
  },
  
  -- Modern text sign indicators
  signs = {
    text = {
      [sev.ERROR] = "󰅚 ",
      [sev.WARN]  = " ",
      [sev.INFO]  = " ",
      [sev.HINT]  = "󰌵 ",
    },
  },
  
  -- Inline context annotations trailing code blocks
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  
  -- Native line dimming mechanics (Full-line background highlighting)
  linehl = {
    [sev.ERROR] = "DiagnosticErrorLine",
    [sev.WARN]  = "DiagnosticWarnLine",
    [sev.INFO]  = "DiagnosticInfoLine",
    [sev.HINT]  = "DiagnosticHintLine",
  },
})

-- ========================================================================== --
-- High-Performance Navigation Keymaps
-- ========================================================================== --
-- Core jump execution abstract function leveraging Neovim 0.12+ engines
local function diagnostic_jump(direction_forward, target_severity)
  return function()
    vim.diagnostic.jump({
      count = direction_forward and 1 or -1,
      float = true,
      severity = target_severity and sev[target_severity] or nil,
    })
  end
end

-- Diagnostic Operational Map Hooks
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Diagnostics: Inspect Current Line" })

-- Sequential Generic Traversals
map("n", "]d", diagnostic_jump(true),  { desc = "Diagnostics: Jump Next" })
map("n", "[d", diagnostic_jump(false), { desc = "Diagnostics: Jump Previous" })

-- Hard-Locked High Severity Jump Links (Ideal for clearing compiler errors quickly)
map("n", "]e", diagnostic_jump(true,  "ERROR"), { desc = "Diagnostics: Next Critical Error" })
map("n", "[e", diagnostic_jump(false, "ERROR"), { desc = "Diagnostics: Previous Critical Error" })
map("n", "]w", diagnostic_jump(true,  "WARN"),  { desc = "Diagnostics: Next System Warning" })
map("n", "[w", diagnostic_jump(false, "WARN"),  { desc = "Diagnostics: Previous System Warning" })
