{ config, pkgs, ... }:

{
  services.samba = {
  	enable = true;
	  openFirewall = true;
	  usershares = {
    		enable = true;
  	};
	settings = {
		global = {
			workgroup = "WORKGROUP";
			"server string" = "NixOS Samba";
			"netbios name" = "nixos";
			security = "user";
			"hosts allow" = "192.168.1. 127.0.0.1 localhost";
			"hosts deny" = "0.0.0.0/0";
		};
		"shares" ={
			path = "/home/ravenousbyte/Public";
			browsable = "yes";
			"read only" = "no";
			"guest ok" = "no";
			"valid users" = "ravenousbyte";
			"create mask" = "0644";
			"directory mask" = "0755";
		};
	};
  };

  # Optional but highly recommended: Allows Windows/Mac/Linux to discover your shares on the local network
services.samba-wsdd = {
  enable = true;
  discovery = true;
  openFirewall = true;
};

}
