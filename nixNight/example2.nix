{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "hello-fslc2";

  buildCommand = ''
    echo '#!${pkgs.bash}/bin/bash' > $out
    echo 'echo "Hello fslc2!"' >> $out
    chmod +x $out
  '';
}
