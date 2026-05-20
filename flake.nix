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
    { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."samf-hp-elitebook" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = {
          username = "safonse";
          homeDirectory = "/home/ANT.AMAZON.COM/safonse";
          nvidiaGpu = null;
        };
      };
      homeConfigurations."samf-nzxt" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = {
          username = "safonse";
          homeDirectory = "/home/ANT.AMAZON.COM/safonse";
          nvidiaGpu = {
            version = "580.126.09";
            sha256 = "09pchs4lk2h8zpm8q2fqky6296h54knqi1vwsihzdpwaizj57b2c";
          };
        };
      };
    };
}
