{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "certstream";
  version = "1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CaliDog";
    repo = "certstream-python";
    rev = version;
    hash = "sha256-cJjeR66wG/JHfai9mHq6sdosxtEqcvPPYUZmUeq1nx4=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    termcolor
    websocket-client
  ];

  pythonImportsCheck = [
    "certstream"
  ];

  meta = {
    description = "Python library for connecting to CertStream";
    homepage = "https://github.com/CaliDog/certstream-python/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "certstream";
  };
}
