{ stdenv, fetchurl, autoconf, automake, ncurses
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "tetradraw";
  version = "2.0.2";

  src = fetchurl {
    url = "https://iweb.dl.sourceforge.net/project/${pname}/${pname}/${pname}-${version}/${pname}-${version}.tar.gz";
    sha256 = "c47553d23c3d583d835655bb588a4bdbd8ea87b87e5b401c8f4352723f7d4866";
  };

  #nativeBuildInputs = [ texinfo ] ++ optional enableNls gettext;
  buildInputs = [ autoconf automake ncurses ];

  outputs = [ "out" ];
  setOutputFlags = false;
  hardeningDisable = [ "all" ];
  #hardeningDisable = [ "format" ];
  configureFlags = [
    "--sysconfdir=/etc"
    #(stdenv.lib.enableFeature enableTiny "tiny")
  ];

  #postInstall = ''
  #  cp ${nixSyntaxHighlight}/nix.nanorc $out/share/nano/
  #'';

  enableParallelBuilding = true;

  meta = {
    homepage = https://tetradraw.sourceforge.net/;
    description = "Tetradraw is a fully featured ANSI art editor for *nix operating systems by John McCutchan.";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      x123
    ];
    platforms = platforms.all;
  };
}
