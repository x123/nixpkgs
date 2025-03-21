{
  stdenv,
  lib,
  fetchpatch,
  fetchFromGitHub,
  makeDesktopItem,
  pkg-config,
  cmake,
  freefont_ttf,
  spice-protocol,
  nettle,
  libbfd,
  fontconfig,
  libffi,
  expat,
  libGL,
  nanosvg,

  libX11,
  libxkbcommon,
  libXext,
  libXrandr,
  libXi,
  libXScrnSaver,
  libXinerama,
  libXcursor,
  libXpresent,
  libXdmcp,

  wayland,
  wayland-protocols,
  wayland-scanner,

  pipewire,
  pulseaudio,
  libsamplerate,

  openGLSupport ? true,
  xorgSupport ? true,
  waylandSupport ? true,
  pipewireSupport ? true,
  pulseSupport ? true,
}:

let
  desktopItem = makeDesktopItem {
    name = "looking-glass-client";
    desktopName = "Looking Glass Client";
    type = "Application";
    exec = "looking-glass-client";
    icon = "lg-logo";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "looking-glass-client";
  version = "B7-rc1";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "LookingGlass";
    rev = finalAttrs.version;
    hash = "sha256-ne1Q+67+P8RHcTsqdiSSwkFf0g3pSNT91WN/lsSzssU=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix failing cmake assertion when disabling X11 without explicitly enabling Wayland.
    (fetchpatch {
      url = "https://github.com/gnif/LookingGlass/commit/20972cfd9b940fddf9e7f3d2887a271d16398979.patch";
      hash = "sha256-CqB8AmOZ4YxnEsQkyu/ZEaun6ywpSh4B7PM+MFJF0qU=";
      stripLen = 1;
    })
    ./nanosvg-unvendor.diff
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  buildInputs =
    [
      libX11
      libGL
      freefont_ttf
      spice-protocol
      expat
      libbfd
      nettle
      fontconfig
      libffi
      nanosvg
    ]
    ++ lib.optionals xorgSupport [
      libxkbcommon
      libXi
      libXScrnSaver
      libXinerama
      libXcursor
      libXpresent
      libXext
      libXrandr
      libXdmcp
    ]
    ++ lib.optionals waylandSupport [
      libxkbcommon
      wayland
      wayland-protocols
    ]
    ++ lib.optionals pipewireSupport [
      pipewire
      libsamplerate
    ]
    ++ lib.optionals pulseSupport [
      pulseaudio
      libsamplerate
    ];

  cmakeFlags =
    [ "-DOPTIMIZE_FOR_NATIVE=OFF" ]
    ++ lib.optionals (!openGLSupport) [ "-DENABLE_OPENGL=no" ]
    ++ lib.optionals (!xorgSupport) [ "-DENABLE_X11=no" ]
    ++ lib.optionals (!waylandSupport) [ "-DENABLE_WAYLAND=no" ]
    ++ lib.optionals (!pulseSupport) [ "-DENABLE_PULSEAUDIO=no" ]
    ++ lib.optionals (!pipewireSupport) [ "-DENABLE_PIPEWIRE=no" ];

  postUnpack = ''
    echo ${finalAttrs.src.rev} > source/VERSION
    export sourceRoot="source/client"
  '';

  postInstall = ''
    mkdir -p $out/share/pixmaps
    ln -s ${desktopItem}/share/applications $out/share/
    cp $src/resources/lg-logo.png $out/share/pixmaps
  '';

  meta = with lib; {
    description = "KVM Frame Relay (KVMFR) implementation";
    longDescription = ''
      Looking Glass is an open source application that allows the use of a KVM
      (Kernel-based Virtual Machine) configured for VGA PCI Pass-through
      without an attached physical monitor, keyboard or mouse. This is the final
      step required to move away from dual booting with other operating systems
      for legacy programs that require high performance graphics.
    '';
    homepage = "https://looking-glass.io/";
    license = licenses.gpl2Plus;
    mainProgram = "looking-glass-client";
    maintainers = with maintainers; [
      alexbakker
      babbaj
      j-brn
    ];
    platforms = [ "x86_64-linux" ];
  };
})
