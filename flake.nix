{
  description = "Nix environment for development.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-root.url = "github:srid/flake-root";
  };

  outputs =
    inputs@{ nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-root.flakeModule
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      perSystem =
        {
          pkgs,
          lib,
          config,
          ...
        }:
        {
          devShells.default = pkgs.mkShell rec {
            inputsFrom = [ config.flake-root.devShell ];

            name = "nvim";

            # dev tools
            nativeBuildInputs = with pkgs; [
              pkg-config # packages finder
              stylua # format lua file
              lua-language-server # lua_ls
            ];

            # libraries
            buildInputs =
              with pkgs;
              [
                openssl # openssl
                zlib # compression
              ]
              ++ lib.optionals pkgs.stdenv.isDarwin [
                libiconv
                pkgs.darwin.apple_sdk.frameworks.SystemConfiguration
              ];

            shellHook = ''
              export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH"
              export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib.outPath}/lib:$LD_LIBRARY_PATH"
            '';
          };
        };
    };
}
