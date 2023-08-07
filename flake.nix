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

    teensy-test = image.build "teensy-test" ./test;

    imageWith = libs: let
      teensy-core = import ./core.nix { inherit pkgs libs; };
    in (import ./build.nix { inherit pkgs teensy-core; });


  in {
    packages.${system} = {
      inherit teensy-core teensy-test;
    };

    apps.${system} = {
      flash-blink   = image.flash teensy-test  "blink";
      flash-counter = image.flash teensy-test  "counter";
    };

    custom = {
      inherit image imageWith teensy-extras;
    };
  };
}
