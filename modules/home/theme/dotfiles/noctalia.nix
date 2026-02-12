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
  imports = [
    inputs.noctalia.homeModules.default
  ];
  config = lib.mkIf (osCfg.enable && (cfg.dotfile == "noctalia")) {
    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true;
    };

    programs.ghostty.settings = {
      "theme" = "noctalia";
    };

    home.packages = with pkgs; [
      app2unit
      gpu-screen-recorder
      hyprshot
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
        source = [
          "~/.config/hypr/noctalia/noctalia-colors.conf"
        ];
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

        # ### Keybinds ###
        # Workspaces
        "$kbMoveWinToWs" = "Super+Alt";
        "$kbMoveWinToWsGroup" = "Ctrl+Super+Alt";
        "$kbGoToWs" = "Super";
        "$kbGoToWsGroup" = "Ctrl+Super";

        "$kbNextWs" = "Ctrl+Super, right";
        "$kbPrevWs" = "Ctrl+Super, left";

        "$kbToggleSpecialWs" = "Super, S";

        # Window groups
        "$kbWindowGroupCycleNext" = "Alt, Tab";
        "$kbWindowGroupCyclePrev" = "Shift+Alt, Tab";
        "$kbUngroup" = "Super, U";
        "$kbToggleGroup" = "Super, Comma";

        # Window actions
        "$kbMoveWindow" = "Super, Z";
        "$kbResizeWindow" = "Super, X";
        "$kbWindowPip" = "Super+Alt, Backslash";
        "$kbPinWindow" = "Super, P";
        "$kbWindowFullscreen" = "Super, F";
        "$kbWindowBorderedFullscreen" = "Super+Alt, F";
        "$kbToggleWindowFloating" = "Super+Alt, Space";
        "$kbCloseWindow" = "Super, Q";

        # Special workspace toggles
        "$kbSystemMonitor" = "Ctrl+Shift, Escape";
        "$kbMusic" = "Super, M";
        "$kbCommunication" = "Super, D";
        # Apps
        "$kbTerminal" = "Super, T";
        "$kbBrowser" = "Super, W";
        "$kbEditor" = "Super, C";
        "$kbFileExplorer" = "Super, E";

        # Misc
        "$kbLauncher" = "Super, Super_L";
        "$kbSession" = "Ctrl+Alt, Delete";
        "$kbLock" = "Super, L";

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
          sensitivity = -0.5;

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
          "blur true, match:namespace noctalia-background-.*$"
          "blur_popups true, match:namespace noctalia-background-.*$"
          "ignore_alpha 0.5, match:namespace noctalia-background-.*$"

          # Fuzzel
          "animation popin 80%, match:namespace launcher"
          "blur true, match:namespace launcher"
        ];
      };
      extraConfig = ''
        # ## Shell keybinds
        # Launcher
        bind = $kbLauncher, exec, noctalia-shell ipc call launcher toggle

        # Misc
        bind = $kbSession, exec, noctalia-shell ipc call sessionMenu toggle
        bind = $kbLock, exec, noctalia-shell ipc call lockScreen lock

        # Brightness
        bindl = , XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase
        bindl = , XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease

        # Go to workspace #
        $wsaction = ${wsaction}
        bind = $kbGoToWs, 1, exec, $wsaction workspace 1
        bind = $kbGoToWs, 2, exec, $wsaction workspace 2
        bind = $kbGoToWs, 3, exec, $wsaction workspace 3
        bind = $kbGoToWs, 4, exec, $wsaction workspace 4
        bind = $kbGoToWs, 5, exec, $wsaction workspace 5
        bind = $kbGoToWs, 6, exec, $wsaction workspace 6
        bind = $kbGoToWs, 7, exec, $wsaction workspace 7
        bind = $kbGoToWs, 8, exec, $wsaction workspace 8
        bind = $kbGoToWs, 9, exec, $wsaction workspace 9
        bind = $kbGoToWs, 0, exec, $wsaction workspace 10
        # Go to workspace group #
        bind = $kbGoToWsGroup, 1, exec, $wsaction -g workspace 1
        bind = $kbGoToWsGroup, 2, exec, $wsaction -g workspace 2
        bind = $kbGoToWsGroup, 3, exec, $wsaction -g workspace 3
        bind = $kbGoToWsGroup, 4, exec, $wsaction -g workspace 4
        bind = $kbGoToWsGroup, 5, exec, $wsaction -g workspace 5
        bind = $kbGoToWsGroup, 6, exec, $wsaction -g workspace 6
        bind = $kbGoToWsGroup, 7, exec, $wsaction -g workspace 7
        bind = $kbGoToWsGroup, 8, exec, $wsaction -g workspace 8
        bind = $kbGoToWsGroup, 9, exec, $wsaction -g workspace 9
        bind = $kbGoToWsGroup, 0, exec, $wsaction -g workspace 10
        # Go to workspace -1/+1
        bind = Super, mouse_down, workspace, -1
        bind = Super, mouse_up, workspace, +1
        binde = $kbPrevWs, workspace, -1
        binde = $kbNextWs, workspace, +1
        binde = Super, Page_Up, workspace, -1
        binde = Super, Page_Down, workspace, +1
        # Go to workspace group -1/+1
        bind = Ctrl+Super, mouse_down, workspace, -10
        bind = Ctrl+Super, mouse_up, workspace, +10

        # Move window to workspace #
        bind = $kbMoveWinToWs, 1, exec, $wsaction movetoworkspace 1
        bind = $kbMoveWinToWs, 2, exec, $wsaction movetoworkspace 2
        bind = $kbMoveWinToWs, 3, exec, $wsaction movetoworkspace 3
        bind = $kbMoveWinToWs, 4, exec, $wsaction movetoworkspace 4
        bind = $kbMoveWinToWs, 5, exec, $wsaction movetoworkspace 5
        bind = $kbMoveWinToWs, 6, exec, $wsaction movetoworkspace 6
        bind = $kbMoveWinToWs, 7, exec, $wsaction movetoworkspace 7
        bind = $kbMoveWinToWs, 8, exec, $wsaction movetoworkspace 8
        bind = $kbMoveWinToWs, 9, exec, $wsaction movetoworkspace 9
        bind = $kbMoveWinToWs, 0, exec, $wsaction movetoworkspace 10
        # Move window to workspace group #
        bind = $kbMoveWinToWsGroup, 1, exec, $wsaction -g movetoworkspace 1
        bind = $kbMoveWinToWsGroup, 2, exec, $wsaction -g movetoworkspace 2
        bind = $kbMoveWinToWsGroup, 3, exec, $wsaction -g movetoworkspace 3
        bind = $kbMoveWinToWsGroup, 4, exec, $wsaction -g movetoworkspace 4
        bind = $kbMoveWinToWsGroup, 5, exec, $wsaction -g movetoworkspace 5
        bind = $kbMoveWinToWsGroup, 6, exec, $wsaction -g movetoworkspace 6
        bind = $kbMoveWinToWsGroup, 7, exec, $wsaction -g movetoworkspace 7
        bind = $kbMoveWinToWsGroup, 8, exec, $wsaction -g movetoworkspace 8
        bind = $kbMoveWinToWsGroup, 9, exec, $wsaction -g movetoworkspace 9
        bind = $kbMoveWinToWsGroup, 0, exec, $wsaction -g movetoworkspace 10
        # Move window to workspace -1/+1
        binde = Super+Alt, Page_Up, movetoworkspace, -1
        binde = Super+Alt, Page_Down, movetoworkspace, +1
        bind = Super+Alt, mouse_down, movetoworkspace, -1
        bind = Super+Alt, mouse_up, movetoworkspace, +1
        binde = Ctrl+Super+Shift, right, movetoworkspace, +1
        binde = Ctrl+Super+Shift, left, movetoworkspace, -1
        # Move window to/from special workspace
        bind = Ctrl+Super+Shift, up, movetoworkspace, special:special
        bind = Ctrl+Super+Shift, down, movetoworkspace, e+0
        bind = Super+Alt, S, movetoworkspace, special:special

        # Window groups
        binde = $kbWindowGroupCycleNext, cyclenext
        binde = $kbWindowGroupCyclePrev, cyclenext, prev
        binde = Ctrl+Alt, Tab, changegroupactive, f
        binde = Ctrl+Shift+Alt, Tab, changegroupactive, b
        bind = $kbToggleGroup, togglegroup
        bind = $kbUngroup, moveoutofgroup
        bind = Super+Shift, Comma, lockactivegroup, toggle

        # Window actions
        bind = Super, left, movefocus, l
        bind = Super, right, movefocus, r
        bind = Super, up, movefocus, u
        bind = Super, down, movefocus, d
        bind = Super+Shift, left, movewindow, l
        bind = Super+Shift, right, movewindow, r
        bind = Super+Shift, up, movewindow, u
        bind = Super+Shift, down, movewindow, d
        binde = Super, Minus, splitratio, -0.1
        binde = Super, Equal, splitratio, 0.1
        bindm = Super, mouse:272, movewindow
        bindm = $kbMoveWindow, movewindow
        bindm = Super, mouse:273, resizewindow
        bindm = $kbResizeWindow, resizewindow
        bind = Ctrl+Super, Backslash, centerwindow, 1
        bind = Ctrl+Super+Alt, Backslash, resizeactive, exact 55% 70%
        bind = Ctrl+Super+Alt, Backslash, centerwindow, 1
        bind = $kbPinWindow, pin
        bind = $kbWindowFullscreen, fullscreen, 0
        bind = $kbWindowBorderedFullscreen, fullscreen, 1  # Fullscreen with borders
        bind = $kbToggleWindowFloating, togglefloating,
        bind = $kbCloseWindow, killactive,

        # Apps
        bind = $kbTerminal, exec, app2unit -- $terminal
        bind = $kbBrowser, exec, app2unit -- $browser
        bind = $kbEditor, exec, app2unit -- $editor
        bind = Super, G, exec, app2unit -- github-desktop
        bind = $kbFileExplorer, exec, app2unit -- $fileExplorer
        bind = Super+Alt, E, exec, app2unit -- nemo
        bind = Ctrl+Alt, Escape, exec, app2unit -- qps
        bind = Ctrl+Alt, V, exec, app2unit -- pavucontrol

        # Volume
        bindl = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        bindl = Super+Shift, M, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        bindle = , XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ $volumeStep%+
        bindle = , XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ $volumeStep%-

        # Sleep
        bind = Super+Shift, L, exec, systemctl suspend-then-hibernate

        # Clipboard and emoji picker
        bind = Super, V, exec, noctalia-shell ipc call launcher clipboard
      '';
    };
  };
}
