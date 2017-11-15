{ stdenv
, fetchurl
, patchelf
, pam
}:

let
  rpath = stdenv.lib.makeLibraryPath [ stdenv.cc.cc pam ];
in
  stdenv.mkDerivation rec {
    version = "11.1.2";
    name = "db2cli-${version}";

    src = fetchurl {
      url = "https://delivery04.dhe.ibm.com/sdfdl/v2/sar/CM/IM/076el/0/Xa.2/Xb.jusyLTSp44S04pY4NjY2SU3bA8YnIbzr-i9Jb9eNyTw5SUgYoukHgJiwOzc/Xc.CM/IM/076el/0/v11.1.2fp2a_linuxx64_odbc_cli.tar.gz/Xd./Xf.LPR.D1vk/Xg.9404032/Xi.habanero/XY.habanero/XZ.CxotCiyrJrMmEYGlvIp8qc_RAzE/v11.1.2fp2a_linuxx64_odbc_cli.tar.gz";
      sha256 = "f9a9c7162d4304773a0d52a3465dcaf4c40cf058240fb223a2f72f4f886438e4";
    };

    unpackPhase = "tar xvzf $src";

    buildPhase = ''
      chmod -R +w ./odbc_cli
      cd ./odbc_cli/clidriver/bin
      ls -lah ./db2cli
      ldd ./db2cli
      echo ""
      rpath2=${rpath}:../lib
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./db2cli
      patchelf --set-rpath $rpath2 ./db2cli
      find -type f -name "*.so" -exec patchelf --set-rpath $rpath2 {} \;
      ldd ./db2cli
    '';

    # dontPatchELF = true;

    # installPhase = ''
    #   runHook preInstall
    #   mkdir -p $out/bin
    #   cp -r ./ $out
    #   ln -s $out/dotnet $out/bin/dotnet
    #   runHook postInstall
    # '';

    meta = with stdenv.lib; {
      homepage = ibm.com;
      description = "IBM Data Server Client Packages (11.1.*, Linux 64-bit,x86_64)";
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ kuznero kadmia ];
    };
  }
