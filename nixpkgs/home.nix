# pwny's Nixos user configuration
# Experimental state -- DO NOT USE --

{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    # Common tools
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    git
    emacs
    zsh

    gimp
    firefox
    transmission

    hermit
    source-code-pro

    # Steam
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    steam
    (steam.override { withPrimus = true;
                      extraPkgs = pkgs: [ bumblebee glxinfo ];
                      nativeOnly = true;
                    }).run

    # KEEPASS
    (keepass.override {
      plugins = [
        # pkgs.keepass-keepasshttp
        pkgs.keepass-keefox ]
      ;})

    # i3wm
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # pkgs.i3

    # i3wm additional packages
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    rofi
    compton
    hsetroot
    xsel
    xsettingsd
    lxappearance
    scrot
    viewnior
    dunst
    arandr
    # i3status
    # polybar
    #(polybar.override {
    #  i3Support = true;
    # })
  ];


  # i3wm
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3Support = true;
      alsaSupport = true;
      # iwSupport = true;
      githubSupport = true;
    };
    config = {
      "bar/bottom" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        width = "100%";
        height = 32;
        separator = "";
        background = "#002b36";
        foreground = "#839496";

        font-0 = "Inconsolata:size=18;1";
        font-1 = "unifont:fontformat=truetype:size=14:antialias=false;0";
        font-2 = "Font Awesome 5:style=Regular:pixelsize=17";
        font-3 = "Font Awesome 5 Free:pixelsize=10;3";
        font-4 = "Font Awesome 5 Free Solid:pixelsize=10;3";
        font-5 = "Font Awesome 5 Brands:pixelsize=10;3";

        monitor = "eDP1";
        bottom = true;

        modules-left = "workspaces";
        modules-center = "powermenu";
        modules-right = "cpu ram root volumeintel backlight battery date wifi";

        tray-position = "right";
        tray-padding = 8;
        tray-reparent = true;

        padding-left = 1;
        padding-right = 1;
        module-margin-left = 1;
        module-margin-right = 1;
      };

      "module/workspaces" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        type = "internal/i3";
        pin-workspaces = true;
        enable-click = true;
        enable-scroll = false;
        strip-wsnumbers = true;

        label-focused-padding = 1;
        label-focused-foreground = "#002b36";
        label-focused-background = "#b58900";

        label-unfocused-padding = 1;
        label-visible-padding = 1;

        label-urgent-padding = 1;
        label-urgent-background = "#dc322f";
        label-urgent-foreground = "#ffffff";
      };

      "module/backlight" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        type = "internal/xbacklight";
        format = "<label>";
        label = " %percentage%%";
      };

      "module/ethernet" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          type = "internal/network";
          interface = "enp0s25";
          ping-interval = 5;

          format-connected-padding = 1;
          label-connected-padding-left = 1;
          accumulate-stats = true;

          format-connected-foreground = "#859900";
          label-connected = "%{A:cmst &:} %upspeed% %downspeed%%{A}";
        };

      "module/wifi" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        type = "internal/network";
        interface = "wlp3s0";
        ping-interval = 5;

        accumulate-stats = true;

        format-connected-foreground = "#859900";

        # label-connected = "%{A:cmst &:} %upspeed% %downspeed%%{A}";
        label-connected = "%{A:cmst &:}%{A}";
        label-connected-padding-left = 1;

        format-disconnected-padding = 1;
        format-disconnected-foreground = "#b58900";

        label-disconnected = "%{A:cmst &:}%{A}";
      };

      "module/cpu" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        type = "internal/cpu";
        interval = 5;
        format = "<label>";
        label = "%{A:urxvt -e htop &:} %percentage%%%{A}";
        format-padding = 3;
      };

      "module/ram" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        type = "internal/memory";
        interval = 5;

        format-prefix = "";
        format-prefix-foreground = "#268bd2";
        format-padding = 1;

        label = "%{A:urxvt -e htop &:}%percentage_used:2%%%{A}";
        label-padding-left = 1;
      };

      "module/battery" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        type = "internal/battery";
        full-at = 100;
        battery = "BAT0";
        adapter = "ACAD";

        time-format = "%H:%M";
        format-charging = "<animation-charging> <label-charging>";
        format-charging-padding = 1;

        format-charging-foreground = "#859900";

        format-discharging = "<ramp-capacity> <label-discharging>";

        format-full-padding = 1;

        label-charging = "%{F#b7b8b9}%percentage:2%%%{F-} %time%";
        label-discharging = "%percentage:2%% %time% %{o- -o}";
        label-full = "%{F#31a354}%{F-} %percentage%% %{F#d7a645}%{F-}";

        ramp-capacity-0 = "%{F#e31a1c o#e31a1c +o} %{F-}";
        ramp-capacity-1 = "%{F#e31a1c o#e31a1c +o} %{F-}";
        ramp-capacity-2 = "%{F#d7a645 o#d7a645 +o} %{F-}";
        ramp-capacity-3 = "{F#31a354 o#31a354 +o} %{F-}";
        ramp-capacity-4 = "%{F#31a354 o#31a354 +o} %{F-}";


        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-3 = "";
        animation-charging-4 = "";
      };

      "module/volumeintel" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        type = "internal/volume";
        format-volume = "<ramp-volume> <label-volume>";
        master-mixer = "Master";
        label-muted = " muted";

        ramp-volume-0 = "";
        ramp-volume-1 = "";
        ramp-volume-2 = "";

        format-volume-padding = 2;
        mapping = true;
      };

      "module/home" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        type = "internal/fs";
        interval = "3600";
        mount-0 = "/home";


        format-mounted-padding = 1;
        format-mounted-prefix = "";
        format-mounted-prefix-foreground = "#268bd2";
        label-mounted = "%{A:urxvt -e ranger &:}%percentage_free%%%{A}";
        label-mounted-padding-left = 1;
      };

      "module/root" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        type = "internal/fs";
        interval = 3600;
        mount-0 = "/";


        format-mounted-padding = 1;
        format-mounted-prefix = "";
        format-mounted-prefix-foreground = "#cb4b16";
        label-mounted = "%{A:urxvt --hold -e df -h &:}%percentage_free%%%{A}";
        label-mounted-padding-left = 1;
      };


      "module/time" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        type = "internal/date";
        interval = 60;

        format-padding = 1;
        format-prefix = "";
        format-prefix-foreground = "#756bb1";


        date = "%I:%M %p";
        date-alt = "%a, %d %b";
        label-padding-left = 1;
      };

      "module/powermenu" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        type = "custom/menu";
        label-open = "";
        #          label-close = "x";
        label-close = "X";
        label-separator = "";
        menu-0-0 = "reboot";
        menu-0-0-exec = "menu-open-1";
        menu-0-1 = "power off";
        menu-0-1-exec = "menu-open-2";

        menu-1-0 = "cancel";
        menu-1-0-exec = "menu-open-0";
        menu-1-1 = "reboot";
        menu-1-1-exec = "reboot";

        menu-2-0 = "power off";
        menu-2-0-exec = "poweroff";
        menu-2-1 = "cancel";
        menu-2-1-exec = "menu-open-0";
      };

      "module/date" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        type = "internal/date";
        interval = 2;

        date = "  %d.%m.%Y";
        date-alt = "  %A, %d. %B";

        time = "%H:%M";
        time-alt = "%H:%M:%S";

        format-underline = "#839496";
        format-padding = 2;
        label = "%{A3:gsimplecal:}%date% | %time%%{A}";

        format-background = "#002b36";
      };
    };
      script = ''

        #!/usr/bin/env sh

        # Terminate already running bar instances
        killall -q polybar

        # Wait until the processes have been shut down
        while pgrep -x polybar >/dev/null; do sleep 1; done

          # Launch bars
          for m in $(polybar --list-monitors | cut -d":" -f1); do
              MONITOR=$m polybar bottom &
          done
          '';
  };
  # git
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  programs.git = {
    enable = true;
    userEmail = "pwnine@protonmail.ch";
    userName = "tehpwny";
    # signing.key = "GPG-KEY-ID";
    # signing.signByDefault = true;
  };


  # EOF
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}
