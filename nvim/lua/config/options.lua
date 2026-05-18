local opt = vim.opt

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ========================================================================== --
-- UI & Look and Feel
-- ========================================================================== --
opt.number = true           -- Show line numbers
opt.relativenumber = true   -- Relative line numbers for snappy vertical jumps
opt.cursorline = true       -- Highlight the current line
opt.termguicolors = true    -- True color support (24-bit)
opt.signcolumn = "yes"      -- Always show sign column to prevent layout shifting
opt.cmdheight = 1           -- Command line screen estate height
opt.showmode = false        -- Mode is handled cleanly by statuslines
opt.pumheight = 10          -- Max items inside popup menu
opt.pumblend = 10           -- Popup menu semi-transparency
opt.winblend = 0            -- Floating window transparency
opt.scrolloff = 10          -- Keep cursor vertically centered where possible
opt.sidescrolloff = 8       -- Keep columns visible left/right of cursor
opt.laststatus = 3          -- Global statusline (modern Neovim default)
opt.ruler = false           -- Disable native ruler (redundant with modern statuslines)

-- ========================================================================== --
-- Windows & Splits behavior
-- ========================================================================== --
opt.splitbelow = true       -- Horizontal splits open underneath current window
opt.splitright = true       -- Vertical splits open to the right
opt.splitkeep = "screen"    -- Stabilize cursor scroll positioning during splits
opt.winminwidth = 5         -- Prevent inactive splits from collapsing entirely

-- ========================================================================== --
-- Indentation & Code Formatting
-- ========================================================================== --
opt.tabstop = 2             -- Number of spaces a tab stands for
opt.shiftwidth = 2          -- Size of an indent step
opt.softtabstop = 2         -- Intercept tabs to insert spaces fluidly
opt.expandtab = true        -- Turn tabs cleanly into spaces
opt.autoindent = true       -- Carry over indent configuration to new lines
opt.breakindent = true      -- Wrapped lines inherit visual indentation indentation
opt.linebreak = true        -- Break lines at clean text boundaries
opt.wrap = false            -- Set to true if visual text wrapping is preferred
opt.shiftround = true       -- Snap indentation to strict multiples of shiftwidth

-- ========================================================================== --
-- Search Systems
-- ========================================================================== --
opt.ignorecase = true       -- Case-insensitive search queries
opt.smartcase = true        -- Case-sensitive switch if uppercase character is typed
opt.hlsearch = false        -- Suppress persistent highlighting across old matches
opt.incsearch = true        -- Realtime match previewing as you type
opt.showmatch = true        -- Briefly flash matching brackets
opt.matchtime = 2           -- Tenths of a second to flash matching brackets
vim.o.inccommand = "split"  -- Live preview substitutions inside a temporary split window

-- ========================================================================== --
-- Intelligent Completion Engine
-- ========================================================================== --
opt.completeopt = "menu,menuone,noselect,fuzzy" -- Native fuzzy-matching parameters

-- ========================================================================== --
-- File Engineering & Persistent State
-- ========================================================================== --
opt.backup = false          -- Skip manual backup creation
opt.writebackup = false     -- Skip backups right before writes
opt.swapfile = false        -- Avoid disk clutter from swap files
opt.undofile = true         -- Persistent histories across buffer exits
opt.undolevels = 10000      -- Retain an extensive command history tree
opt.updatetime = 300        -- Interval length for diagnostic and LSP evaluation
opt.timeoutlen = 300        -- Key map timeout trigger limit (optimized for which-key)
opt.ttimeoutlen = 0         -- Terminate key code timeouts immediately
opt.autoread = true         -- Refresh buffers tracking shifts on disk automatically
opt.autowrite = true        -- Save modifications prior to running compile tasks

-- ========================================================================== --
-- Advanced Environment Navigation
-- ========================================================================== --
opt.virtualedit = "block"   -- Direct cursor positioning past line ends in Visual Block mode
opt.selection = "exclusive" -- Strict text block bounds highlighting
opt.mouse = "a"             -- Full mouse interaction integration
-- Prevent clipboard delay drops when operating across SSH remotes
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

-- ========================================================================== --
-- Code Rendering & Obfuscation
-- ========================================================================== --
opt.conceallevel = 2        -- Uniformly style away raw markup blocks (Markdown/JSON)
opt.concealcursor = ""      -- Un-conceal items on the exact cursor row line

-- ========================================================================== --
-- Modern Treesitter Code Folding
-- ========================================================================== --
opt.smoothscroll = true
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Treesitter-backed fold tracking
opt.foldlevel = 99                              -- Keep code files open at entry

-- ========================================================================== --
-- Command Line Execution Scope
-- ========================================================================== --
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- ========================================================================== --
-- Performance Adjustments
-- ========================================================================== --
opt.synmaxcol = 300         -- Terminate highlighting long lines to save memory cycles
opt.redrawtime = 10000      -- Max time allotment for screen re-renders
opt.maxmempattern = 20000   -- Limit memory maps for heavy regex engine computations
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- ========================================================================== --
-- Advanced Diff Utilities
-- ========================================================================== --
opt.diffopt:append("linematch:60,inline:word") -- Enhanced word-level diff highlighting

-- ========================================================================== --
-- Visual Asset Character Replacements
-- ========================================================================== --
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = {
  foldopen = " ",
  foldclose = " ",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ", -- Completely clear empty lines at end of buffer bounds
}

-- ========================================================================== --
-- Global Context Flags
-- ========================================================================== --
vim.g.autoformat = true
vim.g.trouble_lualine = true
vim.g.markdown_recommended_style = 0

-- ========================================================================== --
-- Custom Filetype Triggers (Dotnet, Cloud Specs, Web Configuration Assets)
-- ========================================================================== --
vim.filetype.add({
  extension = {
    env = "dotenv",
  },
  filename = {
    [".env"] = "dotenv",
    ["env"] = "dotenv",
  },
  pattern = {
    ["[jt]sconfig.*.json"] = "jsonc",
    ["%.env%.[%w_.-]+"] = "dotenv",
  },
})
