{ super, ... }@args:
(super.p11-kit.overrideAttrs (oldAttrs: {
  mesonCheckFlags = [
    "--timeout-multiplier 0"
  ];
}))
