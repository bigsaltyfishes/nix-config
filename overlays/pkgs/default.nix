{ inputs, ... }:
{
  imports = [
    ./pyzy
    ./ibus-pinyin
    ./ibus-chinese-tables
    ./zinit
    ./steam-im-modules
  ];
  
  nixpkgs.overlays = [
    # Rust Overlay
    inputs.rust-overlay.overlays.default
  ];
}
