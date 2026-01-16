{
  perSystem =
    { pkgs, self', ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = [
          (pkgs.python3.withPackages (ps: [ ps.mypy ]))
          pkgs.ruff
        ];
        inputsFrom = [ self'.packages.jmt ];
      };
    };
}
