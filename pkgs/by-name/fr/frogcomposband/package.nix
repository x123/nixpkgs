{
  buildFHSEnv,
  symlinkJoin,
  frogcomposband-unwrapped,
}: let
  fhsEnv = {
    inherit (frogcomposband-unwrapped) version;
    # Many WINE games need 32bit
    multiArch = true;

    targetPkgs = pkgs: [
      pkgs.frogcomposband-unwrapped
    ];

    multiPkgs = let
      xorgDeps = pkgs:
        with pkgs.xorg; [
          libpthreadstubs
          libSM
          libX11
          libXaw
          libxcb
          libXcomposite
          libXcursor
          libXdmcp
          libXext
          libXi
          libXinerama
          libXmu
          libXrandr
          libXrender
          libXv
          libXxf86vm
        ];
    in
      pkgs:
        with pkgs;
          [
            # https://wiki.winehq.org/Building_Wine
            ncurses6
            SDL
          ]
          ++ xorgDeps pkgs;
  };
in
  symlinkJoin {
    name = "frogcomposband";
    paths = [
      (buildFHSEnv (
        fhsEnv
        // {
          pname = "frogcomposband";
          runScript = "frogcomposband";
        }
      ))
    ];
    postBuild = ''
      mkdir -p $out/share
      mkdir -p $out/var/games/frogcomposband/user
      ln -s ${frogcomposband-unwrapped}/share/frogcomposband $out/share
    '';

    inherit (frogcomposband-unwrapped) meta;
  }
