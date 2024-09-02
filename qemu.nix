let
  name = "xs-checkpoint-qemu";
  pkgs = import <nixpkgs> {};
in pkgs.stdenv.mkDerivation {
  inherit name;
  src = pkgs.fetchFromGitHub {
    owner = "OpenXiangShan";
    repo = "qemu";
    # latest checkpoint branch
    rev = "8758c375de12f09073614cad48f9956fe53b5aa7";
    hash = "sha256-xSJcR4bywPwpBGQfFKGOTrYZBhMoy0gOP8hYoA+hEOM=";
    postFetch = let
      keycodemapdb = pkgs.fetchFromGitLab {
        owner = "qemu-project";
        repo = "keycodemapdb";
        rev = "f5772a62ec52591ff6870b7e8ef32482371f22c6";
        hash = "sha256-GbZ5mrUYLXMi0IX4IZzles0Oyc095ij2xAsiLNJwfKQ=";
      };
      berkeley-softfloat-3 = pkgs.fetchFromGitLab {
        owner = "qemu-project";
        repo = "berkeley-softfloat-3";
        rev = "b64af41c3276f97f0e181920400ee056b9c88037";
        hash = "sha256-Yflpx+mjU8mD5biClNpdmon24EHg4aWBZszbOur5VEA=";
      };
      berkeley-testfloat-3 = pkgs.fetchFromGitLab {
        owner = "qemu-project";
        repo = "berkeley-testfloat-3";
        rev = "e7af9751d9f9fd3b47911f51a5cfd08af256a9ab";
        hash = "sha256-inQAeYlmuiRtZm37xK9ypBltCJ+ycyvIeIYZK8a+RYU=";
      };
    in ''
      cp -r ${keycodemapdb} $out/subprojects/keycodemapdb
      find $out/subprojects/keycodemapdb -type d -exec chmod +w {} \;

      cp -r ${berkeley-softfloat-3} $out/subprojects/berkeley-softfloat-3
      find $out/subprojects/berkeley-softfloat-3 -type d -exec chmod +w {} \;
      cp -r $out/subprojects/packagefiles/berkeley-softfloat-3/* $out/subprojects/berkeley-softfloat-3/

      cp -r ${berkeley-testfloat-3} $out/subprojects/berkeley-testfloat-3
      find $out/subprojects/berkeley-testfloat-3 -type d -exec chmod +w {} \;
      cp -r $out/subprojects/packagefiles/berkeley-testfloat-3/* $out/subprojects/berkeley-testfloat-3/
    '';
  };

  buildInputs = [
    pkgs.python3
    pkgs.ninja
    pkgs.meson
    pkgs.glib
    pkgs.pkg-config
    pkgs.zstd
    pkgs.dtc
  ];

  dontUseMesonConfigure = true;
  preConfigure = ''
  '';
  configureFlags = [
    "--target-list=riscv64-softmmu"
    # "--enable-debug"
    "--enable-zstd"
    "--enable-plugins"
    "--disable-werror"
    "--disable-download"
  ];
  preBuild = "cd build";
}