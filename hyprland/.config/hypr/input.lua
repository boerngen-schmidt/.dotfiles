-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
  input = {
    kb_layout = "de",
    kb_variant = "nodeadkeys",
    kb_model = "thinkpad",
    kb_options = "compose:caps",

    follow_mouse = 1,

    sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

    -- Change speed of keyboard repeat
    repeat_rate = 40,
    repeat_delay = 600,

    -- Start with numlock on by default
    numlock_by_default = true,

    touchpad = {
      -- Use natural (inverse) scrolling
      natural_scroll = false,

      -- Use two-finger clicks for right-click instead of lower-right corner
      clickfinger_behavior = true,

      -- Control the speed of your scrolling
      scroll_factor = 0.4,
    },
  },

  misc = {
    key_press_enables_dpms = true, -- key press will trigger wake
    mouse_move_enables_dpms = true, -- mouse move will trigger wake
  },
})

-- Scroll nicely in the terminal
hl.window_rule({
  name = "terminal-scroll-touchpad",
  match = { class = "(Alacritty|kitty)" },
  scroll_touchpad = 1.5,
})

hl.window_rule({
  name = "ghostty-scroll-touchpad",
  match = { class = "com.mitchellh.ghostty" },
  scroll_touchpad = 0.2,
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
