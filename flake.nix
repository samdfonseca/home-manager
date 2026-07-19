{
  description = "Home Manager configuration of samfonseca";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    amzn = {
      url = "git+ssh://git.amazon.com:2222/pkg/AmznNix-Community";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    { nixpkgs, home-manager, amzn, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgsUnfree = import nixpkgs {
        inherit system;
        config = {
          allowUnfreePredicate = pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [ "nvidia-x11" ];
          nvidia.acceptLicense = true;
        };
      };
    in
    {
      homeConfigurations."samf-hp-elitebook" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ amzn.homeModules.default ./home.nix ];
        extraSpecialArgs = {
          username = "safonse";
          homeDirectory = "/home/ANT.AMAZON.COM/safonse";
          nvidiaGpu = null;
        };
      };
      homeConfigurations."samf-thinkpad-p1" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsUnfree;
        modules = [ amzn.homeModules.default ./home.nix ];
        extraSpecialArgs = {
          username = "safonse";
          homeDirectory = "/home/ANT.AMAZON.COM/safonse";
          nvidiaGpu = {
            enable = true;
            version = "590.48.01";
            sha256 = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
          };
        };
      };
      homeConfigurations."samf-nzxt" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsUnfree;
        modules = [ amzn.homeModules.default ./home.nix ];
        extraSpecialArgs = {
          username = "safonse";
          homeDirectory = "/home/ANT.AMAZON.COM/safonse";
          nvidiaGpu = {
            enable = true;
            version = "590.48.01";
            sha256 = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
          };
        };
      };
    };
}
