{ config, pkgs, ... }:

{
  environment.pathsToLink = [ "/libexec" ];
  services.xserver = {
  	desktopManager = {
		# xfce as window manager
		default = "xfce";
		xterm.enable = false;
		xfce = {
			enable = true;
			noDesktop = true;
			enableXfwm = false;
		};
  	};
  	windowManager.i3 = {
		  enable = true;
		  extraPackages = with pkgs; [
		  ];
  	};
  };
}
