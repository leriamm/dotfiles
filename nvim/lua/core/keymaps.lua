-- ============================================================
--  core/keymaps.lua  —  Custom key bindings
--
--  FORMAT: vim.keymap.set(mode, keys, action, opts)
--    mode  = "n" normal | "i" insert | "v" visual | "x" visual-block
--    keys  = what you press
--    action= what happens
--    opts  = { desc = "Description shown in which-key" }
--
--  LEARNING TIP: Run `:Telescope keymaps` to search all bindings.
-- ============================================================

local map = vim.keymap.set   -- shorthand

-- ─── Leader key ──────────────────────────────────────────────
-- <Space> is the most ergonomic leader key.
-- Leader is a "namespace" prefix for your custom commands.
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ─── Escape alternatives ─────────────────────────────────────
-- "jk" lets you leave Insert mode without reaching for Escape.
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- ─── Save & Quit shortcuts ───────────────────────────────────
map("n", "<leader>w", "<cmd>w<cr>",  { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>",  { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Force quit all" })

-- ─── Window navigation ───────────────────────────────────────
-- Move between splits with Ctrl+hjkl instead of Ctrl+W then hjkl.
-- LEARNING TIP: This is much faster once you use splits often.
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Resize splits with arrow keys
map("n", "<C-Up>",    "<cmd>resize +2<cr>",          { desc = "Increase split height" })
map("n", "<C-Down>",  "<cmd>resize -2<cr>",          { desc = "Decrease split height" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>", { desc = "Decrease split width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase split width" })

-- ─── Buffer navigation ───────────────────────────────────────
-- Buffers are open files. Navigate them without closing.
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Close buffer" })

-- ─── Better indenting in visual mode ─────────────────────────
-- Normally, > exits visual mode. This keeps the selection.
map("v", "<", "<gv", { desc = "Indent left (keep selection)" })
map("v", ">", ">gv", { desc = "Indent right (keep selection)" })

-- ─── Move lines up/down (great for reordering config options) ─
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- ─── Keep cursor centred when scrolling / searching ──────────
-- LEARNING TIP: This prevents disorientation when jumping around.
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centred)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centred)" })
map("n", "n",     "nzzzv",   { desc = "Next match (centred)" })
map("n", "N",     "Nzzzv",   { desc = "Prev match (centred)" })

-- ─── Don't clobber register when pasting over selection ──────
-- Normally, pasting over text replaces your clipboard with the deleted text.
-- This preserves it.
map("x", "<leader>p", '"_dP', { desc = "Paste without clobbering register" })

-- ─── File explorer ───────────────────────────────────────────
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })

-- ─── Telescope (fuzzy finder) ────────────────────────────────
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>",   { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>",     { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",   { desc = "Search help" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>",     { desc = "Search keymaps" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>",    { desc = "Recent files" })

-- ─── LSP (set up in lsp.lua, mapped here for discoverability) ─
-- These only activate when an LSP server is attached to a buffer.
map("n", "gd",        vim.lsp.buf.definition,      { desc = "Go to definition" })
map("n", "gr",        vim.lsp.buf.references,      { desc = "Go to references" })
map("n", "K",         vim.lsp.buf.hover,           { desc = "Hover documentation" })
map("n", "<leader>rn", vim.lsp.buf.rename,         { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action,    { desc = "Code action" })
map("n", "<leader>d",  vim.diagnostic.open_float,  { desc = "Show diagnostics" })
map("n", "[d",         vim.diagnostic.goto_prev,   { desc = "Previous diagnostic" })
map("n", "]d",         vim.diagnostic.goto_next,   { desc = "Next diagnostic" })

-- ─── Clear search highlight ──────────────────────────────────
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- ─── Open terminal in a split ────────────────────────────────
map("n", "<leader>t", "<cmd>split | terminal<cr>", { desc = "Open terminal split" })
map("t", "<Esc>",     "<C-\\><C-n>",               { desc = "Exit terminal mode" })
