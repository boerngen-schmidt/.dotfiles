-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/ for more
hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Just dash of opacity by default
hl.window_rule({
  name = "default-opacity",
  match = { class = ".*" },
  opacity = "0.97 0.9",
})

-- Common rules
require("window-rules.common")

-- Fix some dragging issues with XWayland
hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

-- App-specific tweaks
require("window-rules.bitwarden")
require("window-rules.browser")
require("window-rules.jetbrains")
require("window-rules.terminals")
require("window-rules.walker")
