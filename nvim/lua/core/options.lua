-- ============================================================
--  core/options.lua  —  General editor behaviour
--  All vim.opt.* settings live here.
--  Tip: `:help 'optionname'` explains any option in detail.
-- ============================================================

local opt = vim.opt   -- shorthand so we don't repeat "vim.opt" everywhere

-- --- Line numbers ---
opt.number         = true   -- Show absolute line number on current line
opt.relativenumber = true   -- Show relative numbers on all other lines
                            -- LEARNING TIP: Relative numbers make motions
                            -- like "5j" (jump 5 lines down) much easier.

-- --- Indentation ---
-- These settings matter a lot when editing fish scripts & TOML configs.
opt.tabstop        = 4      -- A <Tab> character looks like 4 spaces
opt.shiftwidth     = 4      -- >> and << indent by 4 spaces
opt.expandtab      = true   -- Always insert spaces, never a real tab
opt.smartindent    = true   -- Auto-indent new lines intelligently
opt.shiftround     = true   -- Round indents to nearest shiftwidth

-- --- Search ---
opt.ignorecase     = true   -- Searches are case-insensitive by default…
opt.smartcase      = true   -- …unless you type a capital letter
opt.hlsearch       = false  -- Don't keep highlighting after search is done
opt.incsearch      = true   -- Show matches as you type

-- --- Appearance ---
opt.termguicolors  = true   -- Enable 24-bit colour (needed by most themes)
opt.scrolloff      = 8      -- Keep 8 lines visible above/below the cursor
opt.sidescrolloff  = 8      -- Same but horizontally
opt.wrap           = false  -- Don't wrap long lines (good for config files)
opt.cursorline     = true   -- Highlight the line your cursor is on
opt.signcolumn     = "yes"  -- Always show the gutter (prevents layout jumps)
opt.colorcolumn    = "80"   -- Faint ruler at column 80 as a soft line-length guide

-- --- Splits ---
opt.splitright     = true   -- Vertical splits open to the RIGHT  (more natural)
opt.splitbelow     = true   -- Horizontal splits open BELOW

-- --- Files & undo ---
opt.undofile       = true   -- Persist undo history across sessions
                            -- You can undo changes even after closing a file!
opt.backup         = false  -- Don't create .bak files
opt.swapfile       = false  -- Don't create .swp files

-- --- Clipboard ---
-- Makes Neovim share the system clipboard so copy/paste works
-- with other apps (like your browser or terminal).
opt.clipboard      = "unnamedplus"

-- --- Mouse ---
opt.mouse          = "a"    -- Enable mouse support (useful while learning)

-- --- UI feel ---
opt.updatetime     = 250    -- Faster CursorHold events (used by LSP, gitsigns)
opt.timeoutlen     = 500    -- ms to wait for a key sequence (e.g. <leader>ff)
opt.completeopt    = "menuone,noselect"  -- Better completion menu behaviour
opt.pumheight      = 10     -- Max 10 items in the pop-up completion menu

-- --- File encoding ---
opt.fileencoding   = "utf-8"

-- --- Folding (disabled by default, enable when comfortable) ---
opt.foldmethod     = "indent"
opt.foldlevel      = 99     -- Start with all folds open
