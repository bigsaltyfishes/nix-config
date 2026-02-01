{
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  cfg = osConfig.molyuu.home-manager.profile.shell;
in
{
  config = lib.mkIf (cfg == "zsh") {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      historySubstringSearch.enable = true;
      plugins = with pkgs; [
        {
          name = "fzf-tab";
          src = zsh-fzf-tab;
          file = "share/fzf-tab/fzf-tab.plugin.zsh";
        }
        {
          name = "nix-zsh-completions";
          src = nix-zsh-completions;
          file = "share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
          completions = [ "share/zsh/site-functions" ];
        }
        {
          name = "fast-syntax-highlighting";
          src = zsh-fast-syntax-highlighting;
          file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
        }
      ];
      initContent = ''
        export PATH=$HOME/.cargo/bin:$PATH

        # Prompt Engineering Starship
        PROMPT_NEEDS_NEWLINE=false

        precmd() {
          if [[ "$PROMPT_NEEDS_NEWLINE" == true ]]; then
            echo
          fi
          PROMPT_NEEDS_NEWLINE=true
        }

        clear() {
          PROMPT_NEEDS_NEWLINE=false
          command clear
        }
      '';
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        format = lib.concatStrings [
          "($username )"
          "($hostname )"
          "$directory "
          "($git_branch )"
          "($git_commit )"
          "$git_state"
          "$git_status"
          "$fill"
          "($status )"
          "($cmd_duration )"
          "($jobs )"
          "($python )"
          "($rust )"
          "$time"
          "$line_break$character"
        ];
        fill = {
          symbol = " ";
        };
        command_timeout = 60; # 60ms must be enough. I like a responsive prompt more than additional git information.
        username = {
          format = "[$user]($style)";
          style_root = "bold red";
          style_user = "bold purple";
          aliases.root = "";
        };
        hostname = {
          format = "[$hostname]($style)[$ssh_symbol](green)";
          ssh_only = true;
          ssh_symbol = " 󰣀";
          style = "bold red";
        };
        directory = {
          format = "[$path]($style)[$read_only]($read_only_style)";
          fish_style_pwd_dir_length = 1;
          style = "bold blue";
        };
        character = {
          success_symbol = "[>](bold green)";
          error_symbol = "[>](red)";
          vimcmd_symbol = "[](bold green)";
          vimcmd_replace_one_symbol = "[](bold purple)";
          vimcmd_replace_symbol = "[](bold purple)";
          vimcmd_visual_symbol = "[](bold yellow)";
        };
        git_branch = {
          format = "[$symbol$branch]($style)";
          symbol = " ";
          style = "green";
        };
        git_commit = {
          commit_hash_length = 8;
          format = "[$hash$tag]($style)";
          style = "green";
        };
        git_status = {
          conflicted = "$count";
          ahead = "⇡$count";
          behind = "⇣$count";
          diverged = "⇡$ahead_count⇣$behind_count";
          untracked = "?$count";
          stashed = "\\$$count";
          modified = "!$count";
          staged = "+$count";
          renamed = "→$count";
          deleted = "-$count";
          format = lib.concatStrings [
            "[($conflicted )](red)"
            "[($stashed )](magenta)"
            "[($staged )](green)"
            "[($deleted )](red)"
            "[($renamed )](blue)"
            "[($modified )](yellow)"
            "[($untracked )](blue)"
            "[($ahead_behind )](green)"
          ];
        };
        status = {
          disabled = false;
          pipestatus = true;
          pipestatus_format = "$pipestatus => [$int( $signal_name)]($style)";
          pipestatus_separator = "[|]($style)";
          pipestatus_segment_format = "[$status]($style)";
          format = "[$status( $signal_name)]($style)";
          style = "red";
        };
        python = {
          format = "[$symbol$pyenv_prefix($version )(\($virtualenv\) )]($style)";
        };
        cmd_duration = {
          format = "[ $duration]($style)";
          style = "yellow";
        };
        time = {
          format = "[ $time]($style)";
          style = "cyan";
          disabled = false;
        };
      };
    };
  };
}
