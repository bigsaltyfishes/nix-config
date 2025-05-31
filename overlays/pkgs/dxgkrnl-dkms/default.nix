{ stdenv, lib, fetchFromGitHub, fetchurl, linuxPackages_xanmod, kernelPkg ? linuxPackages_xanmod }:
let
  version = "6.6.87.1";
  krnl_src = fetchFromGitHub {
    owner = "microsoft";
    repo = "WSL2-Linux-Kernel";
    rev = "linux-msft-wsl-${version}";
    hash = "sha256-eE9cyI26HLtz5kyooNNuRn3PrZIYkW/Jk0SrjlOVVRE=";
  };
  kernel = kernelPkg.kernel;
in
stdenv.mkDerivation {
  pname = "dxgkrnl-dkms";
  inherit version;

  src = "${krnl_src}/drivers/hv/dxgkrnl";

  sourceRoot = "drivers/hv/dxgkrnl";
  nativeBuildInputs = kernel.moduleBuildDependencies;

  # Patch from https://github.com/staralt/dxgkrnl-dkms/raw/refs/heads/main/linux-msft-wsl-6.6.y/0002-Fix-eventfd_signal.patch
  patches = [
    (fetchurl {
      url = "https://raw.githubusercontent.com/staralt/dxgkrnl-dkms/4d0fb9d935db546912e2ab31302e6f9b6e03be3b/linux-msft-wsl-6.6.y/0002-Fix-eventfd_signal.patch";
      sha256 = "sha256-RMJNu+p4M2icrlOV5vmREkgm5UcXLIpBwXcBhocGMlI=";
    })
  ];

  postPatch = ''
    cp -r ${./Makefile} ./
  '';

  makeFlags = [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall
    install dxgkrnl.ko -Dm444 -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/gpu/dxgkrnl/
    runHook postInstall
  '';

  meta = {
    description = "A kernel module to create V4L2 loopback devices";
    homepage = "https://github.com/aramg/droidcam";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.makefu ];
    platforms = lib.platforms.linux;
  };
}