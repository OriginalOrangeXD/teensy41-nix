{
  description = "Build environment for Teensy 4.1";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

    teensy-core   = import ./core.nix { inherit pkgs; };
    teensy-extras = import ./extra.nix { inherit pkgs; };

    image = import ./build.nix { inherit pkgs teensy-core; };


    imageWith = libs: let
      teensy-core = import ./core.nix { inherit pkgs libs; };
    in (import ./build.nix { inherit pkgs teensy-core; });

    teensy-firmware = let
      firmware-source = import ./firmware.nix { inherit pkgs; };
      firmware-deps   = with teensy-extras; [ spi wire ];
    in (imageWith firmware-deps).build
      "teensy-firmware"
      (pkgs.linkFarmFromDrvs "firmware" [ firmware-source ]);

  in {
    packages.${system} = {
      inherit teensy-core teensy-firmware;
    };

    apps.${system} = {
      flash-firmware   = image.flash teensy-firmware "firmware-arm";
    };

    custom = {
      inherit image imageWith teensy-extras;
    };
  };
}
