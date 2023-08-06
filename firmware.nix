{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  name = "firmware-arm.cpp";


  buildInputs = with pkgs; [
    cacert
    arduino-cli
  ];

  # This needs to be adopted for teensy41, but the general idea would be to convert ino code to cpp
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
