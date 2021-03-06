{ stdenv, fetchurl, pkgconfig, libxml2, gnome3, dconf, nautilus
, gtk3, gsettings-desktop-schemas, vte, intltool, which, libuuid, vala
, desktop-file-utils, itstool, wrapGAppsHook, glib, pcre2 }:

stdenv.mkDerivation rec {
  pname = "gnome-terminal";
  version = "3.34.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-terminal/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0gc004f9b5k94gkdanmqjz3wqgnpny0l3nqm8zd19h4f0ps27mrv";
  };

  buildInputs = [
    gtk3 gsettings-desktop-schemas vte libuuid dconf
    # For extension
    nautilus
  ];

  nativeBuildInputs = [
    pkgconfig intltool itstool which libxml2
    vala desktop-file-utils wrapGAppsHook pcre2
  ];

  # Silly ./configure, it looks for dbus file from gnome-shell in the
  # installation tree of the package it is configuring.
  postPatch = ''
    substituteInPlace configure --replace '$(eval echo $(eval echo $(eval echo ''${dbusinterfacedir})))/org.gnome.ShellSearchProvider2.xml' "${gnome3.gnome-shell}/share/dbus-1/interfaces/org.gnome.ShellSearchProvider2.xml"
    substituteInPlace src/Makefile.in --replace '$(dbusinterfacedir)/org.gnome.ShellSearchProvider2.xml' "${gnome3.gnome-shell}/share/dbus-1/interfaces/org.gnome.ShellSearchProvider2.xml"
  '';

  configureFlags = [ "--disable-migration" ]; # TODO: remove this with 3.30

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-terminal";
      attrPath = "gnome3.gnome-terminal";
    };
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The GNOME Terminal Emulator";
    homepage = https://wiki.gnome.org/Apps/Terminal;
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = gnome3.maintainers;
  };
}
