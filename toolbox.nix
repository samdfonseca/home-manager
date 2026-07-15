{ ... }:

# Declarative Builder Toolbox management via AmznNix-Community's home module
# (provides the `programs.toolbox` options, wired in via flake.nix modules list).
#
# We only use the generic `tools.<name>.enable` (which just installs the
# toolbox) and deliberately avoid the opinionated wrappers `programs.toolbox.{cr,
# ada,brazil-cli}` — those would overwrite hand-tuned ~/.config/cr/preferences,
# ~/.aws/config and ~/.config/brazil/brazil.prefs.
#
# strict = false (default) so nix never removes toolboxes it doesn't manage.
{
  programs.toolbox = {
    enable = true;
    currentPlatform = "ubuntu";

    # ponytail: default builder-tools registry only. Tools from custom
    # registries (andes-mcp, aws-outlook-mcp, orca-mcp, etc.) are aim-managed
    # and need registry URIs/roleArns — add programs.toolbox.registries + aim
    # config if you want those declarative too.
    tools = {
      ada.enable = true;
      aim.enable = true;
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
      kiro-cli.enable = true;
      lpt.enable = true;
      mcp-registry.enable = true;
      personal-stacks.enable = true;
      python-migration-tools.enable = true;
      q.enable = true;
      tao.enable = true;
      wasabi.enable = true;
    };
  };
}
