{
  buildPecl,
  lib,
  fetchFromGitHub,
  zlib,
}:

let
  version = "0.4.17";
in
buildPecl {
  inherit version;
  pname = "spx";

  src = fetchFromGitHub {
    owner = "NoiseByNorthwest";
    repo = "php-spx";
    rev = "v${version}";
    hash = "sha256-MH/0G9KKmwcVsJKpe6uE1xjvykBEWuYU0DIOGfXiLAw=";
  };

  configureFlags = [ "--with-zlib-dir=${zlib.dev}" ];

  preConfigure = ''
    substituteInPlace Makefile.frag \
      --replace '$(INSTALL_ROOT)$(prefix)/share/misc/php-spx/assets/web-ui' '${placeholder "out"}/share/misc/php-spx/assets/web-ui'
  '';

  meta = {
    changelog = "https://github.com/NoiseByNorthwest/php-spx/releases/tag/${version}";
    description = "Simple & straight-to-the-point PHP profiling extension with its built-in web UI";
    homepage = "https://github.com/NoiseByNorthwest/php-spx";
    license = lib.licenses.php301;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
