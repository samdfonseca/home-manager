-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
      commit = "851e865342e5a4cb1ae23d31caf6e991e1c99f1e",
    },
  },
  branch = "main",
  commit = "4916d6592ede8c07973490d9322f187e07dfefac",
  lazy = false,
  build = ":TSUpdate",
  main = "nvim-treesitter",
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        -- Enable treesitter highlighting and disable regex syntax
        pcall(vim.treesitter.start)
        -- Enable treesitter-based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
  init = function()
    local ensureInstalled = {
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
      "markdown",
      "markdown_inline",
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
      "yaml",
    }
    local alreadyInstalled = require("nvim-treesitter.config").get_installed()
    local parsersToInstall = vim
      .iter(ensureInstalled)
      :filter(function(parser) return not vim.tbl_contains(alreadyInstalled, parser) end)
      :totable()
    require("nvim-treesitter").install(parsersToInstall)
  end,
}
