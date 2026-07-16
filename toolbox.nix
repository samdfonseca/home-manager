{ config, lib, ... }:

# Declarative Builder Toolbox + AIM management via AmznNix-Community's home
# module (provides `programs.toolbox`, wired in via flake.nix modules list).
#
# We use the generic `tools.<name>.enable` (which just installs the toolbox)
# and deliberately avoid the opinionated wrappers `programs.toolbox.{cr,ada,
# brazil-cli}` — those would overwrite hand-tuned ~/.config/cr/preferences,
# ~/.aws/config and ~/.config/brazil/brazil.prefs.
#
# strict = false (default) everywhere so nix never removes toolboxes / aim
# packages it doesn't manage.
let
  # All custom registries share the same cross-account ToolboxUser role;
  # they're matched by URI, so the attr key is only cosmetic.
  reg = uri: {
    inherit uri;
    roleArn = "arn:aws:iam::865827691132:role/ToolboxUser";
  };
in
{
  # aim validates uvx-based MCP servers (e.g. aws-api-mcp) by running `which
  # uvx` during activation. home-manager's activation PATH is a fixed set of nix
  # store dirs — it has neither `which` nor `uvx`, and mise isn't active. So we
  # put the nix profile bin (which supplies pkgs.uv's uvx and pkgs.which) on PATH
  # before the toolbox/aim entries run (they're inline in the same shell).
  home.activation.uvxOnPath = lib.hm.dag.entryBefore [ "installPackages" ] ''
    export PATH="${config.home.profileDirectory}/bin:$PATH"
  '';

  programs.toolbox = {
    enable = true;
    currentPlatform = "ubuntu";

    # Custom S3-backed registries (beyond the default builder-tools registry).
    # Keys must be space-free: the activation script word-splits registry keys.
    # They're cosmetic anyway — registries are matched/deduped by URI.
    registries = {
      aws-outlook-mcp = reg "s3://buildertoolbox-awsoutlook-mcp-us-west-2/tools.json";
      bt-rust = reg "s3://buildertoolbox-registry-bt-rust-registry-us-west-2/tools.json";
      crossborder-mcp = reg "s3://cross-border-mcp-prod-registry-bucket-us-west-2/tools.json";
      inner-loop = reg "s3://toolbox-inner-loop-registry-us-west-2/tools.json";
      mcp-spec-studio-server-tools = reg "s3://buildertoolbox-registry-mcp-spec-studio-server-us-west-2/tools.json";
      miscellaneous = reg "s3://buildertoolbox-registry-secondary-registry-us-west-2/tools.json";
      orca-mcp = reg "s3://buildertoolbox-registry-orca-mcp-us-west-2/tools.json";
      orcha = reg "s3://buildertoolbox-registry-orcha-us-west-2/tools.json";
      pippin-mcp-server-tools = reg "s3://buildertoolbox-registry-pippin-mcp-server-us-west-2/tools.json";
      wasabi-registry = reg "s3://prod-wasabi-vending-registry/tools.json";
    };

    # Tools from the default builder-tools registry. (aim + kiro-cli are enabled
    # by the higher-level programs.toolbox.{aim,kiro} modules below.)
    tools = {
      ada.enable = true;
      axe.enable = true;
      barium.enable = true;
      batscli.enable = true;
      bemol.enable = true;
      brazilcli.enable = true;
      brazil-graph.enable = true;
      brazil-third-party-tool.enable = true;
      builder-mcp.enable = true;
      code-search.enable = true;
      cr.enable = true;
      create.enable = true;
      devspaces.enable = true;
      gitlfs.enable = true;
      gordian-knot.enable = true;
      hydra.enable = true;
      inner-loop.enable = true;
      javari.enable = true;
      lpt.enable = true;
      mcp-registry.enable = true;
      personal-stacks.enable = true;
      python-migration-tools.enable = true;
      q.enable = true;
      tao.enable = true;
      wasabi.enable = true;
    };

    # Kiro CLI (required by the aim module). Settings left unmanaged so nix
    # won't touch ~/.kiro/settings/cli.json.
    kiro.cli.enable = true;

    # AIM (AI Integration Manager). All MCP servers resolve via the default
    # amazon-internal-mcp-registry, so no per-server registry override needed.
    aim = {
      enable = true;

      mcpServers = {
        andes-mcp = { };
        alloy-iceberg-fua-mcp = { };
        amazon-sharepoint-mcp = { };
        aws-api-mcp = { };
        aws-outlook-mcp = { };
        aws-sharepoint-mcp = { };
        builder-mcp = { };
        crossborder-mcp = { };
        local-chorus-mcp = { };
        orca-mcp = { };
        pippin-mcp = { };
        quickwork-outlook-mcp = { };
        sage-plus-service-mcp = { };
        slack-mcp = { };
        spec-studio-mcp = { };
        tekton-mcp = { };
        wis-web-search-mcp = { };
      };

      agents = {
        AEE-SE-Kiro-Agents = {
          version = "1.0";
          versionSet = "AEE-SE-Kiro-Agents/development";
        };
      };

      skills = {
        MidwayClientSuiteIntegrationAgents.versionSet = "MidwayClientSuiteIntegrationAgents/development";
      };

      # Claude Code plugins; namespaces select which sub-plugins to install.
      plugins = {
        AEE-SE-Kiro-Agents.namespaces = [ "all" ];
        AmazonBuilderCoreAIAgents.namespaces = [ "core" "pipeline-assistant" ];
        ChorusAIM.namespaces = [ "all" ];
      };
    };
  };
}
