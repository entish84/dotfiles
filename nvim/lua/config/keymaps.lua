local map = vim.keymap.set
local opts = { silent = true }

-- ========================================================================== --
-- 2. Buffer Navigation (Browser-style Framework tabs & Vim-style pairs)
-- ========================================================================== --
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Buffer: Next", silent = true })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Buffer: Previous", silent = true })

map("n", "[b", "<cmd>bprevious<cr>", { desc = "Buffer: Jump Previous" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Buffer: Jump Next" })

map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Buffer: Next (Leader)" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Buffer: Previous (Leader)" })

map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Buffer: Switch to Alternate file" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Buffer: Switch to Alternate file" })

-- ========================================================================== --
-- 3. Window Management & Multiplexer Navigation
-- ========================================================================== --
map("n", "<C-h>", "<C-w>h", { desc = "Window: Focus Left", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Window: Focus Down", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Window: Focus Up", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Window: Focus Right", remap = true })

map("n", "<C-S-Up>", "<cmd>resize +5<CR>", opts)
map("n", "<C-S-Down>", "<cmd>resize -5<CR>", opts)
map("n", "<C-S-Left>", "<cmd>vertical resize -5<CR>", opts)
map("n", "<C-S-Right>", "<cmd>vertical resize +5<CR>", opts)

-- Fixed sequential cycling viewport layout rules
map("n", "<leader>ww", "<C-w>w", { desc = "Window: Cycle Next Viewport", remap = true })
map("n", "<leader>wd", "<C-w>c", { desc = "Window: Close Viewport", remap = true })
map("n", "<leader>w-", "<C-w>s", { desc = "Split: Horizontal Layout", remap = true })
map("n", "<leader>sh", "<C-w>s", { desc = "Split: Horizontal Layout (Alt)", remap = true })
map("n", "<leader>w|", "<C-w>v", { desc = "Split: Vertical Layout", remap = true })
map("n", "<leader>sv", "<C-w>v", { desc = "Split: Vertical Layout (Alt)", remap = true })

-- ========================================================================== --
-- 4. Line Manipulation & Interaction (The IDE Experience)
-- ========================================================================== --
map("n", "<leader>tw", "<cmd>set wrap!<CR>", { desc = "Toggle: Wrap Constraints", silent = true })
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Move Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Move Up", expr = true, silent = true })

map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>== ", { desc = "Edit: Move Line Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Edit: Move Line Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Edit: Move Line Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Edit: Move Line Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Edit: Move Selection Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Edit: Move Selection Up" })
map("v", "J", ":move '>+1<CR>gv=gv", { desc = "Edit: Move Visual Block Down" })
map("v", "K", ":move '<-2<CR>gv=gv", { desc = "Edit: Move Visual Block Up" })

-- ========================================================================== --
-- 5. Text Selection & Utility Search Optimizations
-- ========================================================================== --
map({ "n", "x", "o" }, "gh", "^", { desc = "Nav: First Character of Line" })
map({ "n", "x", "o" }, "gl", "$", { desc = "Nav: End of Line" })
map("n", "<A-a>", "ggVG", { desc = "Edit: Select Full Buffer" })

map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Search: Clear Highlights" })
map("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "System: Force Redraw" })

map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)
map("v", "p", '"_dP', opts)
map("n", "<C-c>", ":%y+<CR>", opts)

map("i", ",", ",<c-g>u", opts)
map("i", ".", ".<c-g>u", opts)
map("i", ";", ";<c-g>u", opts)

-- ========================================================================== --
-- 6. Core Compilation, Saving & Window Exit Rigs
-- ========================================================================== --
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "System: Save Target File" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "System: Initialize Empty File" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "System: Close Neovim Subprocesses" })
map("n", "z0", "1z=", { desc = "Spelling: Accept Suggestion" })

-- ========================================================================== --
-- 7. Context Lists & Local Diagnostics
-- ========================================================================== --
map("n", "<leader>xl", function() pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen) end, { desc = "List: Toggle Location" })
map("n", "<leader>xq", function() pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen) end, { desc = "List: Toggle Quickfix" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "List: Previous Item" })
map("n", "]q", "<cmd>cnext<CR>", { desc = "List: Next Item" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics: Open Location List" })

-- ========================================================================== --
-- 8. Fuzzy Finder Integrations (Fzf-lua Execution Triggers)
-- ========================================================================== --
map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find: Track Project Files" })
map("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "Find: Substring Grep Match" })
map("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "Find: Active Buffer Wheel" })
map("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>", { desc = "Find: Query Internal Help Manuals" })

-- ========================================================================== --
-- 9. Asynchronous Native LSP Dynamic Mapping Pipeline
-- ========================================================================== --
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local lsp_map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = "LSP: " .. desc })
    end

    -- Core context bindings attached purely on compilation workspace instances
    lsp_map("n", "gd", vim.lsp.buf.definition, "Go to Code Definition")
    lsp_map("n", "gr", "<cmd>FzfLua lsp_references<CR>", "Find References via FZF")
    lsp_map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
    lsp_map("n", "gt", vim.lsp.buf.type_definition, "Go to Target Type Definition")
    lsp_map("n", "K", vim.lsp.buf.hover, "Show Hover Context Docs")
    
    lsp_map("n", "<leader>ca", vim.lsp.buf.code_action, "Execute Code Action")
    lsp_map("n", "<leader>cr", vim.lsp.buf.rename, "Refactor & Rename Symbol")
    lsp_map("n", "<leader>cd", vim.diagnostic.open_float, "Inspect Line Diagnostics Float")
  end,
})
