-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "cmake",
      "cpp",
      "cuda",
      "desktop",
      "dockerfile",
      "git_rebase",
      "gitcommit",
      "gitignore",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "hcl",
      "html",
      "ini",
      "jinja",
      "jq",
      "json",
      "just",
      "lua",
      "luap",
      "make",
      "meson",
      "nginx",
      "objc",
      "proto",
      "python",
      "query",
      "requirements",
      "rst",
      "ruby",
      "rust",
      "ssh_config",
      "starlark",
      "terraform",
      "tmux",
      "toml",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml"
      -- add more arguments for adding more treesitter parsers
    },
  },
}
