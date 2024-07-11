{
  bpf-linker,
  clang,
  cmake,
  fetchFromGitHub,
  git,
  lib,
  libbpf,
  lld,
  ninja,
  rustPlatform,
  stdenv,
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

  nativeBuildInputs = [
    bpf-linker
    clang
    cmake
    git
    lld
    ninja
  ];

  buildInputs = [
    libbpf
  ];

  # preBuild = ''
  #   cargo xtask build-tools
  # '';
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.cargoShortTarget;

  RUSTC_BOOTSTRAP = 1;
  RUST_BACKTRACE = 1;
  preConfigure = ''
    sed -i -E 's/^target = (.*)$/target = [\1]/' xtask/.cargo/config.toml
    #sed -i -E 's/^target = (.*)$/target = "x86_64-unknown-linux-gnu"/' .cargo/config.toml
  '';

  buildPhase = ''
    runHook preBuild
    # cargo xtask build-tools
    # cargo xtask --release
    cargo xtask build
    # cargo xtask build --release
    runHook postBuild
  '';

  doCheck = true;

  cargoHash = "sha256-Qzkqqcq76/tVZ/18XjrVf4lPGC7x8GnhuKvHJZtPL1g=";

  meta = {
    description = "Threat-hunting tool for Linux";
    homepage = "https://github.com/kunai-project/kunai";
    changelog = "https://github.com/kunai-project/kunai/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [x123];
    mainProgram = "kunai";
  };
}
