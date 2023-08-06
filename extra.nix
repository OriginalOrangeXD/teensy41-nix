{ pkgs, ... }:

{
  spi = pkgs.fetchFromGitHub {
    owner = "PaulStoffregen";
    repo = "SPI";
    rev = "574ab8c7a8a45ea21cc56dcc6b7361da90868e86";
    sha256 = "I3M7w9SNEXvPD0ynuZ38bnTaenGEORg72E5YC2x6ek4=";
  };

  wire = pkgs.fetchFromGitHub {
    owner = "PaulStoffregen";
    repo = "Wire";
    rev = "15018075857fa0176d8a5fc610fc564427282ca0";
    sha256 = "GTfqmQykFS4nXXPBhQHe2gpEUY2sH0ESHh28ZrIW/dE=";
  };

  servo = pkgs.fetchFromGitHub {
    owner = "PaulStoffregen";
    repo = "Servo";
    rev = "0cf9712f15e1ab175f0ec06496bad1c23453fb64";
    sha256 = "k6QIWXJmPbLzd9gDmnrwWSA7kcUu7OcWfOwILVAYAbQ=";
  };
}
