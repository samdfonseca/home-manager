-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "ansible-language-server",
        "bash-language-server",
        "clangd",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "gh-actions-language-server",
        "gopls",
        "jq-lsp",
        "json-lsp",
        "lua-language-server",
        "neocmakelsp",
        "nginx-language-server",
        "rust-analyzer",
        "starlark-rust",
        "terraform-ls",
        "ty",
        "vim-language-server",

        -- linters
        "actionlint",
        "ruff",
        "selene",
        "shellcheck",
        "terraform",
        "tflint",
        "tfsec",

        -- install formatters
        "goimports",
        "gomodifytags",
        "gotests",
        "hclfmt",
        "nginx-config-formatter",
        "shfmt",
        "stylua",
        "taplo",
        "yamlfmt",

        -- install debuggers
        "bash-debug-adapter",
        "codelldb",
        "debugpy",
        "delve",
        "local-lua-debugger-vscode",

        -- install any other package
        "tree-sitter-cli",
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      log_level = vim.log.levels.DEBUG,
    },
  },
}
