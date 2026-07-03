hl.on("hyprland.start", function()
	hl.exec_cmd("${pkgs.kdePackages.polkit-kde-agent-1}/polkit-kde-authentication-agent-1")
	hl.exec_cmd("swaync &")
	hl.exec_cmd("waybar &")

-- Clipboard: history
    --hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("wl-paste --type text --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'")
    hl.exec_cmd("wl-paste --type image --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'")

  	hl.exec_cmd("nm-applet --indicator &")
	hl.exec_cmd("blueman-applet &")
	hl.exec_cmd("awww-daemon &")
	hl.exec_cmd("sleep 5 && rog-control-center &") -- Enforces profile/charge limits on startup
	hl.exec_cmd("sleep 5 && opensnitch-ui &") -- Launches the firewall prompt tray application

	hl.exec_cmd("sleep 5 && kdeconnect-indicator &") -- Syncs notifications and background tray integration
	hl.exec_cmd("sleep 5 && discord --start-minimized &") -- Opens Discord quietly into the system tray
end)
