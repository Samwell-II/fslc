{ pkgs ? import <nixpkgs> {} }:

pkgs.writeShellScript "hello-fslc3" ''
  echo "Hello fslc3!"
''
