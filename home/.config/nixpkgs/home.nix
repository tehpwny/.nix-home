# pwny's Nixos user configuration
# Experimental state -- DO NOT USE --

{ config, pkgs, ... }:

{
  imports =
    [
#      ./nur.nix
    ];

  nixpkgs.config.allowUnfree = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # zsh
  programs.zsh.enable = true;
  programs.zsh.initExtra = ''
                         export TERM="xterm-256color"
                         source ~/powerlevel10k/powerlevel10k.zsh-theme

                         # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
                         [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

                         bindkey "^[[1;5C" forward-word
                         bindkey "^[[1;5D" backward-word
  '';
  # programs.zsh.enableAutosuggestions = true;
  # programs.zsh.promptInit = "";

  programs.zsh.oh-my-zsh.enable = true;
  programs.zsh.oh-my-zsh.plugins = [ "git" "sudo" "python"];

  # dotfiles
  xdg.configFile."i3/config".source = ~/.nix-home/home/.config/i3/config;
  xdg.configFile."i3/wallpaper.png".source = ~/.nix-home/home/.config/i3/wallpaper.png;
  # xdg.configFile.".zshrc".source = ~/.nix-home/home/.zshrc;

  home.packages = with pkgs; [
    # Common tools
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    git
    emacs
    zsh

    python38Full
    python38Packages.setuptools
    python38Packages.pip
    python38Packages.subliminal
    python38Packages.virtualenvwrapper
    python38Packages.virtualenv
    python38Packages.pudb

    feh
    gimp

    irssi

    firefox
    transmission

    vlc

    pavucontrol

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
    i3lock
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
      "bar/top" = {
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
        bottom = false;

        modules-left = "workspaces";
        modules-center = "";
        modules-right = "wifi temperature memory cpu root volumeintel backlight battery date powermenu";

        tray-position = "right";
        tray-padding = 0;
        tray-reparent = true;
        # tray-offset-x = 1;

        padding-left = 1;
        padding-right = 1;
        module-margin-left = 0;
        module-margin-right = 1;
      };

      "module/workspaces" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        type = "internal/i3";
        pin-workspaces = true;
        enable-click = true;
        enable-scroll = false;
        strip-wsnumbers = true;

        label-focused-padding = 0;
        label-focused-foreground = "#002b36";
        label-focused-background = "#b58900";

        label-unfocused-padding = 0;
        label-visible-padding = 0;

        label-urgent-padding = 0;
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
        label-connected = "  %upspeed%  %downspeed%%";
        # label-connected = "%{A:cmst &:}%{A}";
        label-connected-padding-left = 0;
        format-disconnected-padding = 0;
        format-disconnected-foreground = "#b58900";
        label-disconnected = "%{A:cmst &:}%{A}";
      };

      "module/cpu" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        type = "internal/cpu";
        interval = 5;

        format = "<label> <ramp-coreload>";
        label = " %percentage%%%{A}";
        format-padding = 3;
        ramp-coreload-spacing = 0;
        ramp-coreload-0 = "▁";
        ramp-coreload-1 = "▂";
        ramp-coreload-2 = "▃";
        ramp-coreload-3 = "▄";
        ramp-coreload-4 = "▅";
        ramp-coreload-5 = "▆";
        ramp-coreload-6 = "▇";
        ramp-coreload-7 = "█";
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
        full-at = 98;
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

        ramp-capacity-0 = "";
        ramp-capacity-0-foreground = "#f53c3c";
        ramp-capacity-1 = "";
        ramp-capacity-1-foreground = "#ffa900";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";

        bar-capacity-width = 10;
        bar-capacity-format = "%{+u}%{+o}%fill%%empty%%{-u}%{-o}";
        bar-capacity-fill = "█";
        bar-capacity-fill-foreground = "#ddffffff";
        bar-capacity-fill-font = 3;
        bar-capacity-empty = "█";
        bar-capacity-empty-font = "3";
        bar-capacity-empty-foreground = "#44ffffff";

        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-3 = "";
        animation-charging-4 = "";
        animation-charging-framerate = 750;
      };

      "module/volumeintel" = {
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        type = "internal/alsa";
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
        label-close = "";
        label-separator = " | ";
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
        interval = 1;

        date = "  %d.%m.%Y";
        date-alt = "  %A, %d. %B";

        time = "%H:%M:%S";
        time-alt = "%H:%M:%S";

        format-underline = "#839496";
        format-padding = 2;
        label = "%{A3:gsimplecal:}%date% | %time%%{A}";

        format-background = "#002b36";
      };

      "module/temperature" = {
        type = "internal/temperature";
        thermal-zone = 1;
        base-temperature = 55;
        warn-temperature = 75;

        format = "<ramp> <label>";
        # format-underline = "#f50a4d";
        format-warn = "<ramp> <label-warn>";
        # format-warn-underline = "#f50a4d";

        label = "%temperature-c%";
        label-warn = " %temperature-c%";
        label-warn-foreground = "#f00";

        ramp-0 = "";
        ramp-1 = " ";
        ramp-2 = " ";
        ramp-3 = " ";
        ramp-4 = "  ";
        ramp-foreground = "#66";
      };

      "module/memory" = {
        type = "internal/memory";
        format = "<label> <ramp-used>";
        format-prefix-foreground = "#268bd2";
        label = " %percentage_used%%";
        ramp-used-0 = "▁";
        ramp-used-1 = "▂";
        ramp-used-2 = "▃";
        ramp-used-3 = "▄";
        ramp-used-4 = "▅";
        ramp-used-5 = "▆";
        ramp-used-6 = "▇";
        ramp-used-7 = "█";
      };
    # config end
    };
    extraConfig = '' '';
      script = ''

        #!/usr/bin/env sh

        # Terminate already running bar instances
        # killall -q polybar
        kill -15 `ps aux |grep polybar |grep -v grep |awk '{print $2}'`>/dev/null

        # Wait until the processes have been shut down
        while pgrep -x polybar >/dev/null; do sleep 1; done

       # Launch bars
       for m in $(polybar --list-monitors | cut -d":" -f1); do
         MONITOR=$m polybar top &
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
