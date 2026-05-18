-- ========================================================================== --
-- 1. Zero-Dependency Native Package Bootstrapper Engine
-- ========================================================================== --
local pack_path = vim.fn.stdpath("data") .. "/site/pack/plugins/start/"
local function use(repo)
  local plugin_name = repo:match(".*/(.*)")
  local target_dir = pack_path .. plugin_name
  if vim.fn.isdirectory(target_dir) == 0 then
    vim.api.nvim_echo({ { "⬇️ Clones & Deploys Native Asset: " .. plugin_name, "Headline" } }, true, {})
    vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/" .. repo, target_dir })
  end
end

-- Tracked Minimalist Stack Architecture
use("williamboman/mason.nvim")           -- Cloud Engine & Compiler Installer
use("neovim/nvim-lspconfig")             -- Server configuration dictionary profiles
use("hrsh7th/nvim-cmp")                  -- High-Performance Autocompletion
use("hrsh7th/cmp-nvim-lsp")              -- LSP Completion Bridge Source
use("hrsh7th/cmp-buffer")                -- Local Context Buffer Completion Source
use("hrsh7th/cmp-path")                  -- System Filesystem Completion Source
use("stevearc/conform.nvim")             -- Dynamic Formatting Engine
use("ibhagwan/fzf-lua")                  -- Fast Native Blazing Fuzzy Finder
use("folke/which-key.nvim")              -- Interface Command Guide Overlay
use("lewis6991/gitsigns.nvim")           -- High-speed Native Git Signs Visualizer
use("echasnovski/mini.pairs")            -- Optimized Balanced Bracket Engine

-- Force refresh system runtimes to detect newly added assets instantly
vim.cmd("packloadall")

-- ========================================================================== --
-- 2. Standalone Plugin Architectural Initializations
-- ========================================================================== --
require("mini.pairs").setup({})
require("gitsigns").setup({})
require("fzf-lua").setup({ "hide" })

-- Modern Conform Setup (.NET, Python, Cloud manifests, and Web Development formatting)
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black", "isort" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    toml = { "taplo" },
    cs = { "csharpier" },
  },
})

-- Which-Key Core Engine Setup
local wk = require("which-key")
wk.setup({ preset = "helix", 
	win = {
	    -- don't allow the popup to overlap with the cursor
	    no_overlap = true,
	    -- width = 1,
	    -- height = { min = 4, max = 25 },
	    -- col = 0,
	    -- row = math.huge,
	   	border = "none",
	    padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
	    title = true,
	    title_pos = "center",
	    zindex = 1000,
	    -- Additional vim.wo and vim.bo options
	    bo = {},
	    wo = {
	     	winblend = 30, -- value between 0-100 0 for fully opaque and 100 for fully transparent
	    },
	  },
 })
wk.add({
  { "<leader>b", group = "Buffers" },
  { "<leader>c", group = "Code/LSP Operations" },
  { "<leader>f", group = "Files & Tracking" },
  { "<leader>s", group = "Splits & Windows" },
  { "<leader>t", group = "Toggle Configurations" },
  { "<leader>u", group = "UI/System Refreshes" },
  { "<leader>w", group = "Window Management" },
  { "<leader>x", group = "Lists & Diagnostics" },
})

-- ========================================================================== --
-- 3. Structural Completion Menu Engine (Nvim-Cmp Ecosystem)
-- ========================================================================== --
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item() else fallback() end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item() else fallback() end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),
})

-- ========================================================================== --
-- 4. Native Asynchronous LSP Framework Activation Loop (Neovim 0.12 Specification)
-- ========================================================================== --
require("mason").setup({})
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {
  -- Language Stacks
  pyright = {},       
  ts_ls = {},         
  html = {},          
  cssls = {},         
  csharp_ls = {},     

  -- Configuration, Data, & Query Servers
  taplo = {},         
  jsonls = {},        
  yamlls = {},        
  sqls = {},          

  lua_ls = {          
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  },
}

-- Native loop using core configuration mechanics to eliminate the deprecation warning
for server, config in pairs(servers) do
  config.capabilities = capabilities
  
  -- Core 0.11/0.12 native registration and initialization pipeline
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end
