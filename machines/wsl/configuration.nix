# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
    let
      hsa-runtime-rocr4wsl-amdgpu = pkgs.stdenv.mkDerivation rec {
        name = "hsa-runtime-rocr4wsl-amdgpu";
        version = "25.10-2149029.24.04";
        src = pkgs.fetchzip {
          url = "https://repo.radeon.com/amdgpu/6.4/ubuntu/pool/main/h/${name}/${name}_${version}_amd64.deb";
          hash = "sha256-DNvxgXJ8ln66cGC5DxMGnDw3gFz50srPalxpo9oLPKg=";
          nativeBuildInputs = [ pkgs.dpkg ];
        };
        installPhase = ''
          runHook preInstall
          mkdir -p $out/lib
          # TODO I'm guessing I should care about the specific ROCm version here...
          mv opt/rocm-*/lib/* $out/lib
          runHook postInstall
        '';
        buildInputs = [
          pkgs.stdenv.cc.cc.lib
          pkgs.elfutils
        ];
        nativeBuildInputs = [ pkgs.autoPatchelfHook ];
        # this needs to get dynamically loaded in with another LD_LIBRARY_PATH
        autoPatchelfIgnoreMissingDeps = [ "libdxcore.so" ]; 
      };
    in
{
  imports = [
    ../../profiles/minimum.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "molyuu";
    interop.register = true;
    useWindowsDriver = true;
    wslConf = {
      automount = {
        ldconfig = true;
      };
    };
  };

  security.sudo.wheelNeedsPassword = true;
  virtualisation.docker.storageDriver = "overlay2";

  environment.sessionVariables = {
    LD_LIBRARY_PATH = [
      "${pkgs.stdenv.cc.cc.lib}/lib"
      "${hsa-runtime-rocr4wsl-amdgpu}/lib"
    ];
  };

  molyuu.home-manager.profile.extraFeatures = [ "baseDevel" ];
}
