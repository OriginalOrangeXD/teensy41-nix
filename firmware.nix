{ pkgs, ... }:

# hacky usage of arduino-cli to preprocess ulisp "ino" source into compilable C++ code
pkgs.stdenv.mkDerivation rec {
  name = "firmware-arm.cpp";


  buildInputs = with pkgs; [
    cacert
    arduino-cli
  ];

  buildPhase = ''
    export HOME=/tmp/arduino
    arduino-cli core install arduino:samd
    mv firmware.ino source.ino
    arduino-cli compile --fqbn arduino:samd:arduino_zero_native --preprocess > firmware-arm.cpp
    echo 'extern "C" int main(void) { setup(); while(true) { loop(); } }' >> firmware-arm.cpp
  '';

  installPhase = ''
    cp firmware-arm.cpp $out
  '';
}
