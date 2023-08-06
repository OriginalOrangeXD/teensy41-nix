{ pkgs, teensy-core, ... }:

{
  build = name: source: pkgs.stdenv.mkDerivation rec {
    inherit name;

    src = source;

    buildInputs = with pkgs; [
      gcc-arm-embedded
      teensy-core
    ];

    buildPhase = ''
      export CC=arm-none-eabi-gcc
      export CXX=arm-none-eabi-g++
      export OBJCOPY=arm-none-eabi-objcopy
      export SIZE=arm-none-eabi-size

      cp ${./Makefile.default} Makefile
      export TEENSY_PATH=${teensy-core}
      make
    '';

    installPhase = ''
      mkdir $out
      cp *.hex $out/
    '';
  };

  flash = let
    loader = name: path: pkgs.writeScript name ''
      #!/bin/sh
      ${pkgs.teensy-loader-cli}/bin/teensy-loader-cli --mcu=TEENSY41 -w ${path}
    '';

  in drv: file: {
    type = "app";
    program = ''${loader file "${drv}/${file}.hex"}'';
  };
}
