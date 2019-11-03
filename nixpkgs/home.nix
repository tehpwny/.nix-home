# pwny's Nixos user configuration
# Experimental state -- DO NOT USE --

{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    git
    emacs
    zsh

    gimp
    firefox
    transmission

    hermit
    source-code-pro
    # terminus-font

    steam
    (steam.override { withPrimus = true;
                      extraPkgs = pkgs: [ bumblebee glxinfo ];
                      nativeOnly = true;
                    }).run


    # keepass
    (keepass.override {
      plugins = [
        # pkgs.keepass-keepasshttp
        pkgs.keepass-keefox ]
      ;})
  ];

  programs.git = {
    enable = true;
    userEmail = "pwnine@protonmail.ch";
    userName = "tehpwny";
    # signing.key = "GPG-KEY-ID";
    # signing.signByDefault = true;
  };
}
