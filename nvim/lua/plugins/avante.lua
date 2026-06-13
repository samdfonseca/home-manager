-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  "yetone/avante.nvim", opts = {
    provider = "bedrock",
    mode = "agentic",
    auto_suggestions_provider = "bedrock",
    behaviour = {
      auto_suggestions = true,
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
        aws_profile = "admin-dev",
        timeout = 30000,
      },
      ["bedrock-haiku"] = {
        __inherited_from = "bedrock",
        model = "us.anthropic.claude-haiku-4-5-20251001-v1:0",
      },
    },
  },
}
