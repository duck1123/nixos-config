let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
in
  with nixpkgs;
  stdenv.mkDerivation {
    name = "moz_overlay_shell";
    buildInputs = [
      nixpkgs.latest.rustChannels.nightly.rust
      nixpkgs.latest.rustChannels.nightly.rust-src
      openssl
      pkg-config
      ];
    RUST_SRC_PATH ="${nixpkgs.latest.rustChannels.nightly.rust-src}/lib/rustlib/src/rust/src";
  }
