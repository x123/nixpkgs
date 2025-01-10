{ lib
, gcc13Stdenv
, fetchFromGitHub
, autoreconfHook
, ncurses
, enableSdl ? false
, SDL
, SDL_image
, SDL_sound
, SDL_mixer
, SDL_ttf
, xorg
}:
let
  stdenv = gcc13Stdenv;
in
stdenv.mkDerivation rec {
  pname = "frogcomposband";
  version = "7.1.salmiak";

  src = fetchFromGitHub {
    owner = "sulkasormi";
    repo = "frogcomposband";
    rev = "v${version}";
    hash = "sha256-mhYP7oN7a6MJOdTtWKtb40mnyxl49EATH7n2qTm6QFk=";
  };

  preAutoreconf = ''
    autoupdate
  '';

  postPatch = ''
    patchShebangs .
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp src/frogcomposband $out/bin
    mkdir -p $out/share
    mkdir -p $out/share/frogcomposband/file
    cp lib/file/*.txt $out/share/frogcomposband/file/
    runHook postInstall
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];
  buildInputs =
    [ ncurses xorg.libX11 xorg.libSM ]
    ++ lib.optionals enableSdl [
      SDL
      SDL_image
      SDL_sound
      SDL_mixer
      SDL_ttf
    ];

  enableParallelBuilding = true;
  env.NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  configureFlags =
    [
      # "--with-no-install"
      # "--prefix $out"
      "--with-private-dirs"
    ]
    ++ lib.optional enableSdl "--enable-sdl";
  meta = {
    description = "A variant of PosChengband and Composband with more stuff, more humor and fewer bugs";
    homepage = "https://github.com/sulkasormi/frogcomposband";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "frogcomposband";
    platforms = lib.platforms.all;
  };
}
