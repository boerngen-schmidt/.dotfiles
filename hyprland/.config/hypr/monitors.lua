-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and resolutions possible: hyprctl monitors

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- Laptop monitor
hl.monitor({
  output = "desc:Lenovo Group Limited ATNA40HQ02-0",
  mode = "2880x1800@120",
  position = "auto",
  scale = "1.25",
})

-- External monitor
hl.monitor({
  output = "desc:ASUSTek COMPUTER INC PG32UCDP SALMQS120245",
  mode = "3840x2160@120",
  position = "auto-right",
  scale = "1",
  vrr = 2,
})
