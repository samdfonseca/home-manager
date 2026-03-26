-- lua/plugins/ansible.lua
---@type LazySpec
return {
  -- Ensure the server is installed
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "ansiblels" })
    end,
  },

  -- LSP setup (AstroLSP wrapper)
  {
    "AstroNvim/astrolsp",
    opts = {
      servers = { "ansiblels" },
      config = {
        ansiblels = {
          settings = {
            ansible = {
              ansible = { path = "ansible" },        -- or absolute path if needed
              ansibleLint = { enabled = true, path = "ansible-lint" },
              executionEnvironment = { enabled = true }, -- set true if you want EE/docker/podman
              python = { interpreterPath = "python3" },
            },
          },
        },
        -- keep yamlls, but don't attach it to ansible buffers
        yamlls = {
          filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" }, -- deliberately exclude "yaml.ansible"
        },
      },
    },
  },
}

