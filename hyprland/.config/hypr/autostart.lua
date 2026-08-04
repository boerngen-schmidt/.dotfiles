-- taken from https://github.com/basecamp/omarchy/blob/master/default/hypr/autostart.conf

hl.on("hyprland.start", function()
  -- hl.exec_cmd("fcitx5")
  hl.exec_cmd("uwsm app -- ashell")
  hl.exec_cmd("uwsm app -- swayosd-server")
  hl.exec_cmd("uwsm app -- walker --gapplication-service")
end)
