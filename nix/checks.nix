{
  perSystem =
    { pkgs, self', ... }:
    {
      checks = {
        package = self'.packages.jmt;

        mypy =
          pkgs.runCommand "mypy"
            {
              nativeBuildInputs = [ (pkgs.python3.withPackages (ps: [ ps.mypy ])) ];
            }
            ''
              cd ${self'.packages.jmt.src}
              mypy jmt/ --ignore-missing-imports
              touch $out
            '';
      };
    };
}
