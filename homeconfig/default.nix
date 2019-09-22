{ pkgs ? import <nixpkgs> {} }:
let
  toInstall = with pkgs;
    [
      git
    ];

  # Git with config baked in
  git = import ./git (
    { inherit (pkgs) makeWrapper symlinkJoin writeTextFile;
      git = pkgs.git;
    });

in
  if pkgs.lib.inNixShell
  then pkgs.mkShell
    { buildInputs = toInstall;
    shellHook = ''
      $(bashrc)
      '';
    }
  else toInstall
