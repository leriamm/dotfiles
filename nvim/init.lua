-- ============================================================
--  init.lua  —  Neovim entry point
--  This file just loads all your other config modules.
--  Think of it as the "table of contents" for your config.
-- ============================================================
 
require("core.options")   -- General editor settings
require("core.keymaps")   -- Your custom key bindings
require("core.lazy")      -- Plugin manager bootstrap

