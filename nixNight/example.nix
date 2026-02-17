let
  pkgs = import <nixpkgs> { };
in
derivation {
  name = "hello-fslc1";
  system = builtins.currentSystem;
  builder = "${pkgs.bash}/bin/bash";
  args = [
    "-c"
    ''
      export PATH="$PATH:${pkgs.coreutils}/bin"
      echo '#!${pkgs.bash}/bin/bash' > $out
      echo 'echo "Hello fslc1!"' >> $out
      chmod +x $out
    ''
  ];
}
