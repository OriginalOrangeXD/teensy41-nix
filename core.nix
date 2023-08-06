{ pkgs, libs ? [ ], ... }:

pkgs.stdenvNoCC.mkDerivation rec {
  name = "teensy-core";
  version = "1.58";

  src = pkgs.fetchFromGitHub {
    owner = "PaulStoffregen";
    repo = "cores";
    rev = "${version}";
    sha256 = "0fr0LgVv70UDMqneyWE5wWGrBCN9E8x8OZnZxWsAcaE=";
  };

  buildInputs = with pkgs; [
    binutils
    gcc-arm-embedded
  ];

  buildPhase = let
    copyLibs = libs: builtins.concatStringsSep "\n" (map (lib: "cp ${lib}/*.{cpp,h} .") libs);

  in ''
    export CC=arm-none-eabi-gcc
    export CXX=arm-none-eabi-g++

    pushd teensy4
    rm main.cpp
    cp ${./Makefile.lib} Makefile
    substitute ${./flags.mk} flags.mk \
               --subst-var-by TEENSY_INCLUDE . \
               --subst-var-by TEENSY_LIB .
    cp ${./flags.mk} flags.mk

    ${copyLibs libs}

    make

    popd
  '';

  installPhase = ''
    mkdir -p $out/{include,lib}
    pushd teensy4
    cp -r *.h $out/include/
    cp -r avr $out/include/
    cp -r debug $out/include/
    cp -r util $out/include/
    cp libteensy-core.a $out/lib/
    substitute ${./flags.mk} $out/include/flags.mk \
               --subst-var-by TEENSY_INCLUDE $out/include \
               --subst-var-by TEENSY_LIB $out/lib
    cp imxrt1062.ld $out/include/IMXRT1062.ld
    popd
  '';
}
