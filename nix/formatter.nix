{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      formatter = inputs.treefmt-nix.lib.mkWrapper pkgs {
        projectRootFile = "flake.nix";
        programs = {
          # Nix
          nixfmt.enable = true;

          # Python
          ruff-check.enable = true;
          ruff-format.enable = true;

          # Markdown
          mdformat.enable = true;

          # Shell
          shellcheck.enable = true;
          shfmt.enable = true;
        };
      };
    };
}
