{

  nixConfig = {
    substituters = [ "https://nix-community.cachix.org" ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="

    ];
  };

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, nixgl }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default nixgl.overlay ];
        };

        inherit (pkgs)
          rust-bin rust-analyzer openssl libGL libGLU libxkbcommon wayland
          egl-wayland vulkan-headers vulkan-loader vulkan-tools;

        inherit (pkgs.xorg) libX11 libxcb libXcursor libXrandr libXi;
        inherit (pkgs.lib) makeLibraryPath;
        inherit (pkgs.nodePackages) vscode-langservers-extracted;
        inherit (pkgs.nixgl) nixGLIntel nixGLMesa nixVulkanMesa nixVulkanIntel;

        rustToolchain =
          pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;

        buildInputs = [
          libX11
          libxcb
          libGL
          libGLU
          libXcursor
          libXrandr
          libXi
          libxkbcommon
          wayland
          egl-wayland
          vulkan-headers
          vulkan-loader
          vulkan-tools
          openssl
        ];

        LD_LIBRARY_PATH = makeLibraryPath buildInputs;

      in
      rec {
        # `nix develop`
        devShells.default = (pkgs.mkShell {
          shellHook = ''
            export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/run/opengl-driver/lib:${LD_LIBRARY_PATH}
          '';

          inherit buildInputs;

          nativeBuildInputs = [
            rustToolchain
            rust-analyzer
            vscode-langservers-extracted
            nixGLIntel
            nixGLMesa
            nixVulkanMesa
            nixVulkanIntel
          ];
        });
      });
}
