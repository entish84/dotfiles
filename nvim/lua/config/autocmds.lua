-- ========================================================================== --
-- Core Automation Group Initialization
-- ========================================================================== --
local augroup = vim.api.nvim_create_augroup("UserCoreAutocmds", { clear = true })

-- ========================================================================== --
-- High-Performance Native Filetype Registrations
-- ========================================================================== --
vim.filetype.add({
  extension = {
    ejs = "embedded_template",
    ["ejs.t"] = "embedded_template",
    ["code-snippets"] = "json",
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "sh", 
    [".*toml%-config.*"] = "toml", 
  },
})

-- ========================================================================== --
-- Document Context & System Sync Operations
-- ========================================================================== --
-- Check if files need to be reloaded if changed externally (e.g., Git operations)
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup,
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Visual Feedback: Briefly highlight text blocks on yank operations
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- Automatically rebalance active layout splits if host window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Restore last cursor location gracefully when loading documents
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Restore last active cursor position on document open",
  callback = function(event)
    if vim.o.diff or vim.tbl_contains({ "gitcommit" }, vim.bo[event.buf].filetype) then
      return
    end
    
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ========================================================================== --
-- Context-Specific Language Layout Overrides
-- ========================================================================== --
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = {
    "PlenaryTestPopup", "checkhealth", "dbout", "gitsigns-blame", "grug-far",
    "help", "lspinfo", "notify", "qf", "spectre_panel", "startuptime",
    "tsplayground", "neotest-output", "neotest-output-panel", "neotest-summary"
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, { buffer = event.buf, silent = true, desc = "Quit layout dashboard" })
    end)
  end,
})

-- ========================================================================== --
-- Automated Direct File System Engineering
-- ========================================================================== --
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function(event)
    -- Fixed the invalid escape sequence bug here safely:
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    local dir = vim.fn.fnamemodify(file, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- ========================================================================== --
-- Integrated Formatting Pipeline (Conform.nvim & EFM Options)
-- ========================================================================== --
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = {
    "*.lua", "*.py", "*.go", "*.js", "*.jsx", "*.ts", "*.tsx",
    "*.json", "*.css", "*.scss", "*.html", "*.sh", "*.bash", "*.zsh",
    "*.c", "*.cpp", "*.h", "*.hpp", "*.cs"
  },
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" or not vim.bo[args.buf].modifiable or vim.api.nvim_buf_get_name(args.buf) == "" then
      return
    end

    local has_conform, conform = pcall(require, "conform")
    if has_conform then
      conform.format({
        bufnr = args.buf,
        timeout_ms = 2000,
        lsp_format = "fallback",
      })
      return
    end

    local has_efm = false
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
      if client.name == "efm" then
        has_efm = true
        break
      end
    end
    
    if has_efm then
      pcall(vim.lsp.buf.format, {
        bufnr = args.buf,
        timeout_ms = 2000,
        filter = function(client) return client.name == "efm" end,
      })
    end
  end,
})
