-- ============================================================
--  core/lazy.lua  —  Plugin manager (lazy.nvim) bootstrap
--
--  lazy.nvim is the standard modern plugin manager for Neovim.
--  It installs plugins from GitHub and only loads them when needed
--  so startup stays fast.
--
--  First run: lazy.nvim auto-installs itself, then `:Lazy sync`
--  installs all plugins listed below.
-- ============================================================

-- Bootstrap: download lazy.nvim if it isn't already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ─── Plugin list ─────────────────────────────────────────────
require("lazy").setup({

  -- ── Colorscheme ──────────────────────────────────────────
  -- Catppuccin: a warm, easy-on-the-eyes theme that works great
  -- in dark terminals. Change the flavour to "latte", "frappe",
  -- "macchiato", or "mocha".
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,   -- Load before everything else
    config = function()
      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ── Which-key: your learning best friend ─────────────────
  -- Shows a popup listing available keymaps whenever you pause
  -- mid-sequence. Press <leader> and wait — it'll show you every
  -- command available. Invaluable while learning.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        delay = 400,   -- ms before popup appears
      })
      -- Label leader groups so which-key shows friendly names
      require("which-key").add({
        { "<leader>f", group = "Find (Telescope)" },
        { "<leader>r", group = "Refactor / Rename" },
        { "<leader>c", group = "Code actions" },
      })
    end,
  },

  -- ── Telescope: fuzzy finder ───────────────────────────────
  -- Find files, search text, browse buffers — all with fuzzy matching.
  -- LEARNING TIP: <leader>fh searches Neovim's built-in :help.
  -- It's the fastest way to look things up.
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Native FZF sorter — much faster fuzzy matching
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix   = "  ",
          selection_caret = "  ",
          path_display    = { "truncate" },
        },
      })
      telescope.load_extension("fzf")
    end,
  },

  -- ── Neo-tree: file explorer ───────────────────────────────
  -- A sidebar file browser. Toggle with <leader>e.
  -- Useful when exploring unfamiliar project layouts.
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",  -- File icons
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        window = { width = 30 },
        filesystem = {
          filtered_items = {
            visible = true,   -- Show hidden files (dotfiles) — important for config editing!
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        },
      })
    end,
  },

  -- ── Treesitter: syntax highlighting & understanding ───────
  -- Treesitter parses your code into a proper syntax tree.
  -- This gives you accurate, beautiful highlighting plus features
  -- like smart text objects ("select inner function").
  --
  -- NOTE: nvim-treesitter was rewritten in late 2024. The old
  -- require('nvim-treesitter.configs').setup() API is gone.
  -- Settings now go in the plugin spec's `opts` table directly,
  -- and lazy.nvim passes them to the plugin's built-in setup().
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      -- Auto-install parsers for these languages.
      -- Add more as needed: run `:TSInstall <language>`
      ensure_installed = {
        "lua", "vim", "vimdoc",  -- Neovim config itself
        "fish",                   -- Fish shell scripts
        "toml", "yaml", "json",  -- Common config formats
        "ini",                    -- INI config files (many WM configs)
        "bash",                   -- Shell scripts
        "markdown",               -- READMEs and docs
        "regex",
      },
      auto_install = true,        -- Install parser when you open an unknown filetype
      highlight    = { enable = true },
      indent       = { enable = true },
    },
  },

  -- ── LSP: Language Server Protocol ────────────────────────
  -- LSPs give you IDE features: go-to-definition, hover docs,
  -- diagnostics (errors/warnings), and auto-rename.
  -- mason.nvim manages server installations for you.
  --
  -- NOTE: Neovim 0.11+ has native LSP config via vim.lsp.config().
  -- We no longer use require('lspconfig').server.setup() — that API
  -- is deprecated. Instead, vim.lsp.config + vim.lsp.enable() is used,
  -- and mason-lspconfig bridges Mason-installed servers into it.
  {
    "neovim/nvim-lspconfig",   -- Still needed: provides default server cmd/settings
    dependencies = {
      "williamboman/mason.nvim",           -- LSP server installer GUI
      "williamboman/mason-lspconfig.nvim", -- Bridges Mason → vim.lsp.enable()
    },
    config = function()
      require("mason").setup({
        ui = { border = "rounded" },
      })

      -- mason-lspconfig auto-installs servers and hooks them into
      -- Neovim's native vim.lsp.enable() when a matching filetype opens.
      require("mason-lspconfig").setup({
        -- These servers will auto-install on first launch.
        -- Open `:Mason` to browse and install more.
        ensure_installed = {
          "lua_ls",      -- Lua  (your Neovim config)
          "bashls",      -- Bash scripts
          "taplo",       -- TOML (many WM configs use TOML)
          "yamlls",      -- YAML
          "jsonls",      -- JSON
        },
        automatic_installation = true,
      })

      -- ── Per-server config via the new native API ──────────
      -- vim.lsp.config("name", opts) sets defaults for a server.
      -- vim.lsp.enable("name") activates it.
      -- mason-lspconfig calls enable() automatically for installed
      -- servers, but we still set config() for custom settings.

      -- Lua: tell lua_ls about Neovim's global `vim` object so it
      -- doesn't report "undefined global 'vim'" in your config files.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace   = { checkThirdParty = false },
          },
        },
      })

      -- The remaining servers work well with their built-in defaults —
      -- mason-lspconfig enables them automatically when installed.
      -- You can add vim.lsp.config("server", { ... }) blocks here
      -- if you ever need to customise them.
    end,
  },

  -- ── Autocompletion ────────────────────────────────────────
  -- nvim-cmp shows a completion menu as you type.
  -- Tab to select, Enter to confirm, Escape to dismiss.
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",    -- LSP completions
      "hrsh7th/cmp-buffer",      -- Words from current buffer
      "hrsh7th/cmp-path",        -- File path completions (great for configs!)
      "L3MON4D3/LuaSnip",        -- Snippet engine
      "saadparwaiz1/cmp_luasnip",-- Snippet completions
      "rafamadriz/friendly-snippets", -- A collection of pre-made snippets
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"]   = cmp.mapping.select_prev_item(),
          ["<C-j>"]   = cmp.mapping.select_next_item(),
          ["<C-d>"]   = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]   = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]    = cmp.mapping.confirm({ select = false }),
          -- Tab cycles through completions if menu is open; else inserts a tab
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },   -- LSP suggestions first
          { name = "luasnip" },    -- Then snippets
          { name = "buffer" },     -- Then buffer words
          { name = "path" },       -- Then file paths
        }),
        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = function(entry, item)
            -- Label where each suggestion comes from
            local source_names = {
              nvim_lsp = "[LSP]",
              buffer   = "[Buf]",
              path     = "[Path]",
              luasnip  = "[Snip]",
            }
            item.menu = source_names[entry.source.name]
            return item
          end,
        },
      })
    end,
  },

  -- ── Lualine: status bar ───────────────────────────────────
  -- Shows current mode, file name, git branch, diagnostics, etc.
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          globalstatus = true,   -- One status bar for all splits
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },   -- Relative path
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- ── Gitsigns: git in the gutter ──────────────────────────
  -- Shows added/changed/deleted lines next to line numbers.
  -- Also lets you stage/reset individual hunks (chunks of changes).
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function bmap(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end
          -- Navigate between hunks
          bmap("n", "]h", gs.next_hunk,           "Next git hunk")
          bmap("n", "[h", gs.prev_hunk,           "Prev git hunk")
          -- Stage / reset individual hunks
          bmap("n", "<leader>hs", gs.stage_hunk,  "Stage hunk")
          bmap("n", "<leader>hr", gs.reset_hunk,  "Reset hunk")
          bmap("n", "<leader>hp", gs.preview_hunk,"Preview hunk")
          bmap("n", "<leader>hb", gs.blame_line,  "Git blame line")
        end,
      })
    end,
  },

  -- ── Comment.nvim: toggle comments ────────────────────────
  -- `gcc` toggles line comment. `gc` in visual mode comments selection.
  -- Knows the right comment character for every filetype (# for fish, -- for lua, etc.)
  {
    "numToStr/Comment.nvim",
    event = "BufReadPre",
    config = true,
  },

  -- ── Autopairs ────────────────────────────────────────────
  -- Automatically inserts matching closing bracket/quote/paren.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,   -- Use treesitter to be smarter about when to pair
      })
      -- Make autopairs play nicely with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- ── indent-blankline: show indentation guides ─────────────
  -- Draws faint vertical lines at each indent level.
  -- Really helpful when reading deeply-nested TOML/YAML configs.
  {
    "lukas-reineke/indent-blankline.nvim",
    main   = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope  = { enabled = true },
      })
    end,
  },

  -- ── Noice: better UI for messages/cmdline ─────────────────
  -- Replaces the cmdline at the bottom with a floating input box.
  -- Makes Neovim feel much more polished.
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"]                = true,
            ["cmp.entry.get_documentation"]                  = true,
          },
        },
        presets = {
          bottom_search         = true,
          command_palette       = true,
          long_message_to_split = true,
        },
      })
    end,
  },

  -- ── vim-sleuth: auto-detect indentation ───────────────────
  -- Reads the file and automatically sets tabstop/shiftwidth to match.
  -- Useful since different projects use 2 or 4 spaces.
  { "tpope/vim-sleuth" },

  -- ── Hardtime: break bad habits (optional — comment out if annoying) ──
  -- Gently discourages using hjkl repeatedly when a faster motion exists.
  -- LEARNING TIP: Keep this enabled for a week. It will hurt, then help.
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("hardtime").setup({
        enabled         = true,
        disable_mouse   = false,   -- Keep mouse enabled while learning
        hint            = true,    -- Show hints for better motions
        notification    = true,
        max_count       = 4,       -- Warn after 4 repeated same-direction presses
      })
    end,
  },

}, {
  -- lazy.nvim UI settings
  ui = { border = "rounded" },
  checker = {
    enabled = true,   -- Notify when plugin updates are available
    notify  = false,  -- But don't show a popup every startup
  },
})
