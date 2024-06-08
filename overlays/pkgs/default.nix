{ inputs, ... }:
{
  imports = [
    ./pyzy
    ./ibus-pinyin
    ./ibus-chinese-tables
    ./zinit
  ];
  
  nixpkgs.overlays = [
    # Rust Overlay
    inputs.rust-overlay.overlays.default
  ];
}
