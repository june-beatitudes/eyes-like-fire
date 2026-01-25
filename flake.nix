{
  description = "Juniper Beatitudes' site build system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      fhs = pkgs.buildFHSEnv {
        name = "site-build-env";
        targetPkgs =
          pkgs:
          (with pkgs; [
            gnumake
            pandoc
            unzip
            mermaid-filter
            (texlive.combine {
              inherit (texlive)
                scheme-basic
                latexmk
                dvisvgm
                standalone
                pgf
                pgfplots
                ;
            })
          ]);
      };
    in
    {
      devShells.${system}.default = fhs.env;
    };
}
