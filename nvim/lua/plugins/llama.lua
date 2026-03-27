return {
  {
    "ggml-org/llama.vim",
    init = function()
      vim.g.llama_config = {
        n_prefix = 1024,
        n_suffix = 1024, -- Fixed typo: was n_siffix
        auto_fim = false, -- Enable automatic suggestions as you type
        endpoint_fim = 'http://server-workstation-26:8001/infill',
        endpoint_inst = 'http://server-workstation-26:8001/v1/chat/completions',
        show_info = 1,
        -- Custom keymaps to avoid blink.cmp conflicts
        keymap_fim_accept_full = '<C-y>',    -- Accept full suggestion
        keymap_fim_accept_line = '<C-l>',    -- Accept single line
        keymap_fim_accept_word = '<C-Right>', -- Accept word
        keymap_fim_dismiss = '<C-e>',        -- Dismiss suggestion
        keymap_fim_trigger = '<C-\\>',       -- Manual trigger
        -- keymap_fim_trigger = "<leader>llf",
        -- keymap_fim_accept_full = "<Tab>",
        -- keymap_fim_accept_line = "<S-Tab>",
        -- keymap_fim_accept_word = "<leader>ll]",
        -- keymap_inst_trigger = "<leader>lli",
        -- keymap_inst_rerun = "<leader>llr",
        -- keymap_inst_continue = "<leader>llc",
        -- keymap_inst_accept = "<Tab>",
        -- keymap_inst_cancel = "<Esc>",
      }
    end,
  },
}
