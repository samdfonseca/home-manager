-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  "yetone/avante.nvim",
  keys = {
    {
      "<leader>AS",
      function() require("avante.api").get_suggestion():suggest() end,
      desc = "avante: trigger suggestion",
      mode = "n",
    },
  },
  opts = {
    provider = "bedrock",
    mode = "agentic",
    auto_suggestions_provider = "bedrock",
    behaviour = {
      auto_suggestions = false,
    },
    input = {
      provider = "snacks",
    },
    selector = {
      provider = "snacks",
    },
    providers = {
      bedrock = {
        model = "us.anthropic.claude-opus-4-6-v1",
        aws_region = "us-east-1",
        aws_profile = "admin-prod",
        timeout = 30000,
        -- Opus 4.8 rejects `temperature`; override the default body to omit it.
        -- extra_request_body = {
        --   max_tokens = 64000,
        -- },
      },
      ["bedrock-haiku"] = {
        __inherited_from = "bedrock",
        model = "us.anthropic.claude-haiku-4-5-20251001-v1:0",
      },
      lmstudio = {
        __inherited_from = "openai",
        endpoint = "http://192.168.1.233:1234/v1",
        model = "qwen/qwen3.6-35b-a3b", -- set to the model id loaded in LM Studio
        api_key_name = "", -- LM Studio needs no key
      },
    },
  },
}
