{ stdenv, lib, fetchFromGitHub, fetchurl, linuxPackages_xanmod, kernelPkg ? linuxPackages_xanmod }:
let
  version = "6.12.31";
  krnl_src = fetchFromGitHub {
    owner = "Nevuly";
    repo = "WSL2-Linux-Kernel-Rolling-LTS";
    rev = "linux-wsl-lts-${version}";
    hash = "sha256-9+AOw+UtrfEA53w3YtjZzeb3bVakXnB4R9Uy8ZyqM0s=";
  };
  kernel = kernelPkg.kernel;
in
stdenv.mkDerivation {
  pname = "dxgkrnl";
  inherit version;

  src = "${krnl_src}/drivers/hv/dxgkrnl";

  sourceRoot = "dxgkrnl";
  nativeBuildInputs = kernel.moduleBuildDependencies;

  patchPhase = ''
    cat ${./Makefile} > Makefile
    
    mkdir -p include/uapi/misc
    mkdir -p include/linux

    cp -r ${krnl_src}/include/linux/hyperv.h include/linux/hyperv_dxgkrnl.h
    cp -r ${krnl_src}/include/uapi/misc/d3dkmthk.h include/uapi/misc/

    # Fix include paths
    sed -i "s#<linux/hyperv.h>#<linux/hyperv_dxgkrnl.h>#g" `grep -rl "<linux/hyperv.h>" .`
  '';

  makeFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install dxgkrnl.ko -Dm444 -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/dxgkrnl/
  '';

  meta = {
    description = "A kernel module for Hyper-V's DirectX Graphics Kernel (dxgkrnl) for WSL2";
    homepage = "https://github.com/microsoft/WSL2-Linux-Kernel";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}