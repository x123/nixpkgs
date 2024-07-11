{
  lib,
  rustPlatform,
  fetchFromGitHub,
  bpf-linker,
  clang,
  cmake,
  git,
  libbpf,
  lld,
  # ninja,
}:
rustPlatform.buildRustPackage rec {
  pname = "kunai";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "kunai-project";
    repo = "kunai";
    rev = "v${version}";
    hash = "sha256-0oqlvwdFBwsv0bAZfleIl9V0mPU7lR2jb90vv2JNbpA=";
  };

  cargoHash = "sha256-Qzkqqcq76/tVZ/18XjrVf4lPGC7x8GnhuKvHJZtPL1g=";

  nativeBuildInputs = [
    bpf-linker
    clang
    cmake
    git
    lld
    # ninja
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libbpf
  ];

  preConfigure = ''
    sed -i -E 's/^target = (.*)$/target = [\1]/' xtask/.cargo/config.toml
  '';

  # preBuild = ''
  #   cargo xtask build-tools
  # '';

  # buildPhase = ''
  #   runHook preBuild
  #   # cargo xtask build-tools --help
  #   runHook cargoBuildHook
  #   runHook postBuild
  # '';

  meta = {
    description = "Threat-hunting tool for Linux";
    homepage = "https://github.com/kunai-project/kunai/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "kunai";
  };
}
