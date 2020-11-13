{
  description = "reproduce https://github.com/fossar/selfoss/issues/1230";

  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-compat, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs.outPath {
          inherit system;
          overlays = [
            (final: prev: {
              # html-tidy = prev.html-tidy.overrideAttrs (attrs: {
              #   src = prev.fetchFromGitHub {
              #     owner = "htacg";
              #     repo = "tidy-html5";
              #     rev = "188988022da4a64d80bc4a2eba21c33d57eb5152";
              #     sha256 = "GRs5qF7OBv0CX/b8kLnnQsENZDjBRAn0uXJvWfJDQkg=";
              #   };
              # });
              libxml2-old = prev.libxml2.overrideAttrs (attrs: rec {
                pname = "libxml2";
                version = "2.9.4";

                src = prev.fetchurl {
                  url = "http://xmlsoft.org/sources/${pname}-${version}.tar.gz";
                  sha256 = "/7kRGR5Qm5Zt61XecFOH8UFW4aVrIYJDV83wBTIzYzw=";
                };
              });
              libxslt-old = prev.libxslt.override { libxml2 = final.libxml2-old; };
            })
          ];
        };
      in {
        devShell =
          let
            replaceLibxml = ext: ext.overrideAttrs (attrs: {
              buildInputs = builtins.map (i:
                if i == pkgs.libxml2 then pkgs.libxml2-old
                else if i == pkgs.libxml2.dev then pkgs.libxml2-old.dev
                else if i == pkgs.libxslt then pkgs.libxslt-old
                else i) attrs.buildInputs;
              configureFlags = builtins.map (builtins.replaceStrings [ "${pkgs.libxml2.dev}" "${pkgs.libxslt.dev}" ] [ "${pkgs.libxml2-old.dev}" "${pkgs.libxslt-old.dev}" ]) (pkgs.lib.toList attrs.configureFlags);
            });
            php = (replaceLibxml pkgs.php).withExtensions ({ enabled, all }: with all; builtins.map replaceLibxml (enabled ++ [
              tidy
            ]));
          in
            pkgs.mkShell {
              nativeBuildInputs = [
                php
              ] ++ (with php.packages; [
                composer
              ]);
            };
      }
    );
}
