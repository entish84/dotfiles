-- ========================================================================== --
-- 1. Zero-Dependency Native Package Bootstrapper Engine
-- ========================================================================== --
local pack_path = vim.fn.stdpath("data") .. "/site/pack/plugins/start/"
local function use(repo, branch)
  local plugin_name = repo:match(".*/(.*)")
  local target_dir = pack_path .. plugin_name
  if vim.fn.isdirectory(target_dir) == 0 then
    vim.api.nvim_echo({ { "⬇️ Clones & Deploys Native Asset: " .. plugin_name, "Headline" } }, true, {})
    
    local cmd = { "git", "clone", "--depth", "1" }
    if branch then
      table.insert(cmd, "-b")
      table.insert(cmd, branch)
    end
    table.insert(cmd, "https://github.com/" .. repo)
    table.insert(cmd, target_dir)
    
    vim.fn.system(cmd)
  end
end

-- Tracked Minimalist Stack Architecture
use("nvim-lua/plenary.nvim")             -- Essential utility layer (Required for easy-dotnet)
use("mfussenegger/nvim-dap")             -- Debug Adapter Protocol engine (Required for easy-dotnet)
use("mason-org/mason.nvim")              -- Cloud Engine & Compiler Installer
use("neovim/nvim-lspconfig")             -- Server configuration dictionary profiles
use("rafamadriz/friendly-snippets")      -- Pre-baked global JSON snippet framework
use("L3MON4D3/LuaSnip")                  -- Snippet Parsing Core
use("saghen/blink.cmp", "v1")            -- FORCED: Clones stable v1 branch to bypass v2 blink.lib issues
use("stevearc/conform.nvim")             -- Dynamic Formatting Engine
use("ibhagwan/fzf-lua")                  -- Fast Native Blazing Fuzzy Finder
use("folke/which-key.nvim")              -- Interface Command Guide Overlay
use("lewis6991/gitsigns.nvim")           -- High-speed Native Git Signs Visualizer
use("echasnovski/mini.pairs")            -- Optimized Balanced Bracket Engine
use("GustavEikaas/easy-dotnet.nvim")     -- Dedicated .NET solution management workspace

-- Force refresh system runtimes to detect newly added assets instantly
vim.cmd("packloadall")

-- ========================================================================== --
-- 2. Standalone Plugin Architectural Initializations
-- ========================================================================== --
require("mini.pairs").setup({})
require("gitsigns").setup({})
require("fzf-lua").setup({}) 

-- Modern Conform Setup (.NET, Python, Cloud manifests, and Web Development formatting)
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black", "isort" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    html = { "prettierd" },
    css = { "prettierd" },
    json = { "prettierd" },
    yaml = { "prettierd" },
    toml = { "taplo" },
    cs = { "csharpier" },
  },
})

-- Comprehensive Easy-Dotnet Core Runtime Configuration
require("easy-dotnet").setup({
  managed_terminal = {
    auto_hide = true,       
    auto_hide_delay = 1000, 
    mappings = {
      next_tab = { lhs = "<Tab>", desc = "Next terminal tab" },
      prev_tab = { lhs = "<S-Tab>", desc = "Previous terminal tab" },
      new_terminal = { lhs = "+", desc = "New terminal instance" },
    },
  },
  viewmode = "float",       
})

-- LuaSnip Engine Setup
require("luasnip").setup({
  history = true,
  updateevents = "TextChanged,TextChangedI",
})
require("luasnip.loaders.from_vscode").lazy_load()

-- Performance Auto-Completion Hub (Blink.cmp)
require("blink.cmp").setup({
	  -- Configure the keymaps layout
	  keymap = {
	    preset = "default",
	    ["<CR>"] = { "accept", "fallback" }, -- Enter selects the highlighted suggestion
	  },
  	completion = { documentation = { auto_show = true } },
})

-- ========================================================================== --
-- 3. Unified Which-Key Command Guides & Core System Keymaps
-- ========================================================================== --
local wk = require("which-key")
wk.setup({ 
  preset = "helix", 
  win = {
    no_overlap = true,
    border = "none",
    padding = { 1, 2 },
    title = true,
    title_pos = "center",
    zindex = 1000,
    bo = {},
    wo = {
      winblend = 30,
    },
  },
})

wk.add({
  { "<leader>b", group = "Buffers" },
  { "<leader>c", group = "Code / LSP Operations" },
  { "<leader>d", group = ".NET / Dotnet Lifecycle" },
  { "<leader>f", group = "Files & Tracking" },
  { "<leader>s", group = "Search Utilities" },
  { "<leader>t", group = "Toggle Configurations" },
  { "<leader>u", group = "UI / System Refreshes" },
  { "<leader>x", group = "Lists & Diagnostics" },

  -- FZF-Lua Fast Navigation Targets
  { "<leader>ff", function() require("fzf-lua").files() end, desc = "Find Files Workspace" },
  { "<leader>fg", function() require("fzf-lua").live_grep() end, desc = "Global Text Search (Grep)" },
  { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Tracked Working Buffers" },
  { "<leader>fh", function() require("fzf-lua").help_tags() end, desc = "Search Help System Documentation" },

  -- Code Execution & Maintenance Targets
  { "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format Code File" },
  { "<leader>ca", function() vim.lsp.buf.code_action() end, desc = "LSP Code Action" },
  { "<leader>cr", function() vim.lsp.buf.rename() end, desc = "Refactor / Rename Symbol" },

  -- Easy-Dotnet Workspace Orchestration Suite
  { "<leader>dr", function() require("easy-dotnet").run() end, desc = "Dotnet Run (Pick Project)" },
  { "<leader>db", function() require("easy-dotnet").build() end, desc = "Dotnet Build Solution / Target" },
  { "<leader>dt", function() require("easy-dotnet").test() end, desc = "Run Unit Tests" },
  { "<leader>ds", function() require("easy-dotnet").testrunner() end, desc = "Toggle Graphical Test Runner View" },
  { "<leader>dn", function() require("easy-dotnet").new() end, desc = "Generate New Solution Template" },
  { "<leader>dx", function() require("easy-dotnet").clean() end, desc = "Dotnet Clean Build Artifacts" },
  { "<leader>dp", function() require("easy-dotnet").run_profile() end, desc = "Run Project via Launch Profile" },

  -- Troubleshooting Lists & System Diagnostics
  { "<leader>xx", function() require("fzf-lua").diagnostics_document() end, desc = "Current Document Diagnostics" },
  { "<leader>xX", function() require("fzf-lua").diagnostics_workspace() end, desc = "Full Solution Workspace Diagnostics" },
})

-- ========================================================================== --
-- 4. Native Asynchronous LSP Framework Activation Loop (Neovim 0.12 Specification)
-- ========================================================================== --
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

local servers = {
  basedpyright = {},       
  vtsls = {},         
  html = {},          
  cssls = {},           
  taplo = {},         
  jsonls = {},        
  yamlls = {},        
  sqls = {},          

  lua_ls = {          
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
}

for server, config in pairs(servers) do
  config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end
