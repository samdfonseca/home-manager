-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.bash" },
  -- { import = "astrocommunity.pack.clojure" },
  { import = "astrocommunity.pack.cmake" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.lua" },
  -- { import = "astrocommunity.pack.python-ruff" },
  -- { import = "astrocommunity.pack.ruby" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.debugging.telescope-dap-nvim" },
  { import = "astrocommunity.terminal-integration.vim-tmux-yank" },
  -- { import = "astrocommunity.ai.avante-nvim" },
  -- { import = "astrocommunity.ai.opencode-nvim" },
  { import = "astrocommunity.utility.lua-json5" },
  -- import/override with your plugins folder
}
