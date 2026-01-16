{
  lib,
  python3Packages,
  makeWrapper,
  nix,
  jujutsu,
  uutils-coreutils-noprefix,
}:

python3Packages.buildPythonApplication {
  pname = "jmt";
  version = "0.1.0";
  pyproject = true;

  src = ./.;

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [ makeWrapper ];

  pythonImportsCheck = [ "jmt" ];

  postFixup = ''
    wrapProgram $out/bin/jmt \
      --prefix PATH : ${
        lib.makeBinPath [
          nix
          jujutsu
        ]
      } \
      --set JMT_MKTEMP "${uutils-coreutils-noprefix}/bin/mktemp"
  '';

  meta = {
    description = "Generate jj fix config from flake's treefmt formatter";
    homepage = "https://github.com/seungwon-jeong/jmt";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "jmt";
  };
}
