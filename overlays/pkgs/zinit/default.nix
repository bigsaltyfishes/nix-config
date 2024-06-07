{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      zinit = prev.zinit.overrideAttrs (oldAttrs: {
        installPhase = ''
          outdir="$out/share/$pname"
          cd "$src"
          ls -al doc

          # Zplugin's source files
          install -dm0755 "$outdir"
          # Installing backward compatibility layer
          install -m0644 zinit{,-side,-install,-autoload}.zsh "$outdir"
          install -m0755 share/git-process-output.zsh "$outdir"
          mkdir -p "$outdir/doc"
          install doc/zinit.1 "$outdir/doc/zinit.1"

          # Zplugin autocompletion
          installShellCompletion --zsh _zinit
        '';
      });
    })
  ];
}
