{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, systems, ... }@inputs:
    let forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in {
      # packages.vscode-extension = {

      # };
      devShells = forEachSystem (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = with pkgs; mkShell {
            nativeBuildInputs = [
              nodejs_22
              node-gyp
              python3
            ];

            runtimeInputs = [
              zsh
            ];
            # pushd core/node_modules/sqlite3
            # node-gyp rebuild
            # popd
            CPPFLAGS = "-I${pkgs.nodejs}/include/node";
            # pushd extensions/vscode
            # npm run package
            # popd

            shellHook = ''
              ${zsh}/bin/zsh
            '';
          };
        });
    };
}
