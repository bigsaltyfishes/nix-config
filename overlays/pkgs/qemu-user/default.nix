{
  lib,
  stdenv,
  buildPackages,
  glib,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  arches ? [
    "aarch64-linux"
    "armv7l-linux"
    "i386-linux"
    "x86_64-linux"
    "powerpc-linux"
    "powerpc64-linux"
    "powerpc64le-linux"
    "riscv32-linux"
    "riscv64-linux"
  ],
  qemu,
}: let
  archFor = system: (lib.systems.elaborate {inherit system;}).qemuArch;
  hostCpuTargets = map (system: "${archFor system}-linux-user") arches;
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "qemu-user";
    version = qemu.version;
    src = qemu.src;

    depsBuildBuild = [buildPackages.stdenv.cc];
    nativeBuildInputs = [
      pkg-config
      meson
      ninja
      python3Packages.python
    ];
    buildInputs = [glib];

    prePatch = ''
      # don't install keymaps
      echo >pc-bios/keymaps/meson.build
    '';

    dontUseMesonConfigure = true;
    dontAddStaticConfigureFlags = true;
    configureFlags =
      [
        "--localstatedir=/var"
        "--sysconfdir=/etc"
        "--cross-prefix=${stdenv.cc.targetPrefix}"
        "--target-list=${lib.concatStringsSep "," hostCpuTargets}"
        "--disable-install-blobs"
        "--disable-plugins"
        (lib.enableFeature false "docs")
        (lib.enableFeature false "tools")
        (lib.enableFeature false "guest-agent")
      ]
      ++ lib.optional stdenv.hostPlatform.isStatic "--static";

    preBuild = "cd build";

    passthru = {
      binaryFor = system: "${lib.getExe' finalAttrs.finalPackage "qemu-${archFor system}"}";
      tests.chroot-binfmt = {
        pkgs,
        lib,
        ...
      }: {
        name = "chroot-binfmt";
        meta.maintainers = [pkgs.lib.maintainers.jcaesar];

        nodes.machine = {...}: {
          boot.binfmt.emulatedSystems = ["riscv64-linux"];
          boot.binfmt.registrations.riscv64-linux = {
            interpreter = "${pkgs.qemu-user-static}/bin/qemu-${archFor "riscv64-linux"}";
            wrapInterpreterInShell = false;
            preserveArgvZero = true;
            matchCredentials = true;
            fixBinary = true;
          };
        };

        testScript = let
          helloRiscv64 = pkgs.pkgsCross.riscv64.pkgsStatic.hello;
        in ''
          machine.succeed(
            "systemd-run --wait"
            " -p RootDirectory=$(mktemp -d)"
            " -p BindReadOnlyPaths=${helloRiscv64}"
            " ${lib.getExe helloRiscv64}"
          )
        '';
      };
    };

    postFixup = lib.optionalString stdenv.hostPlatform.isStatic ''
      # HACK: Otherwise the result will have the entire buildinput closure
      # injected by the pkgsStatic stdenv
      # <https://github.com/NixOS/nixpkgs/issues/83667>
      rm -f $out/nix-support/propagated-build-inputs
    '';

    meta = {
      homepage = "https://www.qemu.org/";
      description = "QEMU User space emulator - launch executables compiled for one CPU on another CPU";
      license = lib.licenses.gpl2Plus;
      maintainers = [lib.maintainers.jcaesar];
      platforms = lib.platforms.linux;
    };
  })
