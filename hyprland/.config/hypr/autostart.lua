-- taken from https://github.com/basecamp/omarchy/blob/master/default/hypr/autostart.conf

hl.on("hyprland.start", function()
  -- hl.exec_cmd("fcitx5")
  -- The shell hosts the bar, notifications, OSD, lock, idle and background.
  hl.exec_cmd("uwsm app -- omarchy-launch-shell")
  hl.exec_cmd("uwsm app -- walker --gapplication-service")
end)
