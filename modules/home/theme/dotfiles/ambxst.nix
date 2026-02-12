{
  inputs,
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  cfg = config.molyuu.home-manager.theme;
  osCfg = osConfig.molyuu.desktop.hyprland;
  system = pkgs.stdenv.hostPlatform.system;
  wsaction = pkgs.writeScript "wsaction" ''
    #!${pkgs.fish}/bin/fish

    if test "$argv[1]" = '-g'
        set group
        set -e $argv[1]
    end

    if test (count $argv) -ne 2
        echo 'Wrong number of arguments. Usage: ./wsaction.fish [-g] <dispatcher> <workspace>'
        exit 1
    end

    set -l active_ws (hyprctl activeworkspace -j | jq -r '.id')

    if set -q group
        # Move to group
        hyprctl dispatch $argv[1] (math "($argv[2] - 1) * 10 + $active_ws % 10")
    else
        # Move to ws in group
        hyprctl dispatch $argv[1] (math "floor(($active_ws - 1) / 10) * 10 + $argv[2]")
    end
  '';
in
{
  config = lib.mkIf (osCfg.enable && (cfg.dotfile == "ambxst")) {
    home.packages = [
      inputs.ambxst-shell.packages.${system}.default
    ];
    home.sessionVariables = {
      XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = 24;
    };

    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
      gtk.enable = true;
    };

    wayland.windowManager.hyprland = {
      settings = {
        # Variables
        # Apps
        "$terminal" = "ghostty";
        "$browser" = "google-chrome";
        "$editor" = "zeditor";
        "$fileExplorer" = "nautilus";

        # Touchpad
        "$touchpadDisableTyping" = true;
        "$touchpadScrollFactor" = 0.3;
        "$workspaceSwipeFingers" = 4;
        "$gestureFingers" = 3;
        "$gestureFingersMore" = 4;

        # Blur
        "$blurEnabled" = true;
        "$blurSpecialWs" = false;
        "$blurPopups" = true;
        "$blurInputMethods" = true;
        "$blurSize" = 8;
        "$blurPasses" = 2;
        "$blurXray" = false;

        # Shadow
        "$shadowEnabled" = true;
        "$shadowRange" = 20;
        "$shadowRenderPower" = 3;

        # Gaps
        "$workspaceGaps" = 20;
        "$windowGapsIn" = 10;
        "$windowGapsOut" = 40;
        "$singleWindowGapsOut" = 20;

        # Window styling
        "$windowOpacity" = 0.95;
        "$windowRounding" = 10;

        "$windowBorderSize" = 3;

        # Misc
        "$volumeStep" = 10; # In percent
        "$cursorTheme" = "sweet-cursors";
        "$cursorSize" = 24;

        # End of Variables

        env = [
          "NIXOS_OZONE_WL, 1"
          # ############# Themes #############
          "QT_QPA_PLATFORMTHEME, qt6ct"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
          "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
          "XCURSOR_THEME, $cursorTheme"
          "XCURSOR_SIZE, $cursorSize"

          # ######## Toolkit backends ########
          "GDK_BACKEND, wayland,x11"
          "QT_QPA_PLATFORM, wayland;xcb"
          "SDL_VIDEODRIVER, wayland,x11,windows"
          "CLUTTER_BACKEND, wayland"
          "ELECTRON_OZONE_PLATFORM_HINT, auto"

          # ####### XDG specifications #######
          "XDG_CURRENT_DESKTOP, Hyprland"
          "XDG_SESSION_TYPE, wayland"
          "XDG_SESSION_DESKTOP, Hyprland"

          # ############# Others #############
          "_JAVA_AWT_WM_NONREPARENTING, 1"
        ];

        monitor = osCfg.monitors;
        "exec-once" = [
          # Keyring and auth
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "gnome-keyring-daeomon --start --components=secrets"

          # Clipboard history
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"

          # Auto delete trash 30 days old
          "trash-empty 30"

          # Cursors
          "hyprctl setcursor $cursorTheme $cursorSize"
          "gsettings set org.gnome.desktop.interface cursor-theme '$cursorTheme'"
          "gsettings set org.gnome.desktop.interface cursor-size $cursorSize"

          # Location provider and night light
          "${pkgs.geoclue2-with-demo-agent}/lib/geoclue-2.0/demos/agent"
          "sleep 1 && gammastep"

          # Forward bluetooth media commands to MPRIS
          "mpris-proxy"

          # Resize and move windows based on matches (e.g. pip)
          "caelestia resizer -d"

          "fcitx5"
        ];

        animations = {
          enabled = true;

          # Animation curves
          bezier = [
            "specialWorkSwitch, 0.05, 0.7, 0.1, 1"
            "emphasizedAccel, 0.3, 0, 0.8, 0.15"
            "emphasizedDecel, 0.05, 0.7, 0.1, 1"
            "standard, 0.2, 0, 0, 1"
          ];

          # Animation configs
          animation = [
            "layersIn, 1, 5, emphasizedDecel, slide"
            "layersOut, 1, 4, emphasizedAccel, slide"
            "fadeLayers, 1, 5, standard"

            "windowsIn, 1, 5, emphasizedDecel"
            "windowsOut, 1, 3, emphasizedAccel"
            "windowsMove, 1, 6, standard"
            "workspaces, 1, 5, standard"

            "specialWorkspace, 1, 4, specialWorkSwitch, slidefadevert 15%"

            "fade, 1, 6, standard"
            "fadeDim, 1, 6, standard"
            "border, 1, 6, standard"
          ];
        };

        decoration = {
          rounding = "$windowRounding";

          blur = {
            enabled = "$blurEnabled";
            xray = "$blurXray";
            special = "$blurSpecialWs";
            ignore_opacity = true; # Allows opacity blurring
            new_optimizations = true;
            popups = "$blurPopups";
            input_methods = "$blurInputMethods";
            size = "$blurSize";
            passes = "$blurPasses";
          };

          shadow = {
            enabled = "$shadowEnabled";
            range = "$shadowRange";
            render_power = "$shadowRenderPower";
          };
        };

        general = {
          layout = "dwindle";

          allow_tearing = false; # Allows `immediate` window rule to work

          gaps_workspaces = "$workspaceGaps";
          gaps_in = "$windowGapsIn";
          gaps_out = "$windowGapsOut";
          border_size = "$windowBorderSize";
        };

        dwindle = {
          preserve_split = true;
          smart_split = false;
          smart_resizing = true;
        };

        gestures = {
          workspace_swipe_distance = 700;
          workspace_swipe_cancel_ratio = 0.15;
          workspace_swipe_min_speed_to_force = 5;
          workspace_swipe_direction_lock = true;
          workspace_swipe_direction_lock_threshold = 10;
          workspace_swipe_create_new = true;
        };

        gesture = [
          "$workspaceSwipeFingers, horizontal, workspace"
          "$gestureFingers, up, special, special"
          "$gestureFingers, down, dispatcher, exec, caelestia toggle specialws"
          "$gestureFingersMore, down, dispatcher, exec, systemctl suspend-then-hibernate"
        ];

        group = {
          groupbar = {
            font_family = "JetBrains Mono NF";
            font_size = 15;
            gradients = true;
            gradient_round_only_edges = false;
            gradient_rounding = 5;
            height = 25;
            indicator_height = 0;
            gaps_in = 3;
            gaps_out = 3;
          };
        };

        input = {
          kb_layout = "us";
          numlock_by_default = false;
          repeat_delay = 250;
          repeat_rate = 35;

          focus_on_close = 1;

          touchpad = {
            natural_scroll = true;
            disable_while_typing = "$touchpadDisableTyping";
            scroll_factor = "$touchpadScrollFactor";
          };
        };

        binds = {
          scroll_event_delay = 0;
        };

        cursor = {
          hotspot_padding = 1;
        };

        misc = {
          vfr = true;
          vrr = 1;

          animate_manual_resizes = false;
          animate_mouse_windowdragging = false;

          disable_hyprland_logo = true;
          force_default_wallpaper = 0;

          on_focus_under_fullscreen = 2;
          allow_session_lock_restore = true;
          middle_click_paste = false;
          focus_on_activate = true;
          session_lock_xray = true;

          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
        };

        debug = {
          error_position = 1;
        };

        # Window rules
        windowrule = [
          "opacity $windowOpacity override, match:fullscreen false"
          ''opaque true, match:class foot|equibop|org\.quickshell|imv|swappy'' # They use native transparency or we want them opaque
          "center true, match:float true, match:xwayland false" # Center all floating windows (not xwayland cause popups)

          # Float
          "float true, match:class guifetch" # FlafyDev/guifetch
          "float true, match:class yad"
          "float true, match:class zenity"
          "float true, match:class wev"
          ''float true, match:class org\.gnome\.FileRoller''
          "float true, match:class file-roller" # WHY IS THERE TWOOOOOOOOOOOOOOOO
          "float true, match:class blueman-manager"
          ''float true, match:class com\.github\.GradienceTeam\.Gradience''
          "float true, match:class feh"
          "float true, match:class imv"
          "float true, match:class system-config-printer"
          ''float true, match:class org\.quickshell''

          # Float, resize and center
          "float true, match:class foot, match:title nmtui"
          "size 60% 70%, match:class foot, match:title nmtui"
          "center 1, match:class foot, match:title nmtui"
          ''float true, match:class org\.gnome\.Settings''
          ''size 70% 80%, match:class org\.gnome\.Settings''
          ''center 1, match:class org\.gnome\.Settings''
          ''float true, match:class org\.pulseaudio\.pavucontrol|yad-icon-browser''
          ''size 60% 70%, match:class org\.pulseaudio\.pavucontrol|yad-icon-browser''
          ''center 1, match:class org\.pulseaudio\.pavucontrol|yad-icon-browser''
          "float true, match:class nwg-look"
          "size 50% 60%, match:class nwg-look"
          "center 1, match:class nwg-look"

          # Special workspaces
          "workspace special:sysmon, match:class btop"
          "workspace special:music, match:class feishin|Spotify|Supersonic|Cider"
          "workspace special:music, match:initial_title Spotify( Free)?" # Spotify wayland, it has no class for some reason
          "workspace special:communication, match:class discord|equibop|vesktop|whatsapp"
          "workspace special:todo, match:class Todoist"

          # Dialogs
          "float true, match:title (Select|Open)( a)? (File|Folder)(s)?"
          "float true, match:title File (Operation|Upload)( Progress)?"
          "float true, match:title .* Properties"
          "float true, match:title Export Image as PNG"
          "float true, match:title GIMP Crash Debug"
          "float true, match:title Save As"
          "float true, match:title Library"

          # Picture in picture (resize and move done via script)
          "move 100%-w-2% 100%-w-3%, match:title Picture(-| )in(-| )[Pp]icture" # Initial move so window doesn't shoot across the screen from the center
          "keep_aspect_ratio true, match:title Picture(-| )in(-| )[Pp]icture"
          "float true, match:title Picture(-| )in(-| )[Pp]icture"
          "pin true, match:title Picture(-| )in(-| )[Pp]icture"

          # Steam
          "rounding 10, match:class steam"
          "float true, match:title Friends List, match:class steam"
          "immediate true, match:class steam_app_[0-9]+" # Allow tearing for steam games
          "idle_inhibit always, match:class steam_app_[0-9]+" # Always idle inhibit when playing a steam game

          # ATLauncher console
          "float true, match:class com-atlauncher-App, match:title ATLauncher Console"

          # Autodesk Fusion 360
          ''no_blur true, match:title Fusion360|(Marking Menu), match:class fusion360\.exe''

          # Ugh xwayland popups
          "no_dim true, match:xwayland 1, match:title win[0-9]+"
          "no_shadow true, match:xwayland 1, match:title win[0-9]+"
          "rounding 10, match:xwayland 1, match:title win[0-9]+"
        ];

        # Workspace rules
        workspace = [
          "w[tv1]s[false], gapsout:$singleWindowGapsOut"
          "f[1]s[false], gapsout:$singleWindowGapsOut"
        ];

        # Layer rules
        layerrule = [
          "animation fade, match:namespace hyprpicker" # Colour picker out animation
          "animation fade, match:namespace logout_dialog" # wlogout
          "animation fade, match:namespace selection" # slurp
          "animation fade, match:namespace wayfreeze"

          # Fuzzel
          "animation popin 80%, match:namespace launcher"
          "blur true, match:namespace launcher"

          # Shell
          "no_anim true, match:namespace caelestia-(border-exclusion|area-picker)"
          "animation fade, match:namespace caelestia-(drawers|background)"

          "blur true, match:namespace caelestia-drawers"
          "ignore_alpha 0.57, match:namespace caelestia-drawers"
        ];
      };
    };
  };
}
