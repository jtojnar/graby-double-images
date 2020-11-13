{
  description = "reproduce https://github.com/fossar/selfoss/issues/1230";

  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    nixpkgs = {
      # revision containing libxml2 2.9.8
      url = "github:NixOS/nixpkgs/75ca6faece8f06096fb45d0b341c39a7ad47c256";
      flake = false;
    };

    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-compat, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs.outPath {
          inherit system;
          config = {
            php.tidy = true;
          };
        };
      in {
        devShell =
          let
            php = pkgs.php;
          in
            pkgs.mkShell {
              nativeBuildInputs = [
                php
              ] ++ (with pkgs.phpPackages; [
                composer
              ]);
            };
      }
    );
}
