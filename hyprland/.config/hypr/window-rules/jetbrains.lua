-- Fix splash screen showing in weird places and prevent annoying focus takeovers
hl.window_rule({
  name = "jetbrains-splash-tag",
  match = { class = "^(jetbrains-.*)$", title = "^(splash)$", float = true },
  tag = "+jetbrains-splash",
})

hl.window_rule({
  name = "jetbrains-splash-center",
  match = { tag = "jetbrains-splash" },
  center = true,
})

hl.window_rule({
  name = "jetbrains-splash-no-focus",
  match = { tag = "jetbrains-splash" },
  no_focus = true,
})

hl.window_rule({
  name = "jetbrains-splash-border-size",
  match = { tag = "jetbrains-splash" },
  border_size = 0,
})

-- Center popups/find windows
hl.window_rule({
  name = "jetbrains-popup-tag",
  match = { class = "^(jetbrains-.*)", title = "^()$", float = true },
  tag = "+jetbrains",
})

hl.window_rule({
  name = "jetbrains-popup-center",
  match = { tag = "jetbrains" },
  center = true,
})

-- Enabling this makes it possible to provide input in popup dialogs (search window, new file, etc.)
hl.window_rule({
  name = "jetbrains-popup-stay-focused",
  match = { tag = "jetbrains" },
  stay_focused = true,
})

hl.window_rule({
  name = "jetbrains-popup-border-size",
  match = { tag = "jetbrains" },
  border_size = 0,
})

-- For some reason match:tag jetbrains does not work for size rule
hl.window_rule({
  name = "jetbrains-popup-size",
  match = { class = "^(jetbrains-.*)", title = "^()$", float = true },
  size = ">50% >50%",
})

-- Disable window flicker when autocomplete or tooltips appear
hl.window_rule({
  name = "jetbrains-no-initial-focus",
  match = { class = "^(jetbrains-.*)$", title = "^(win.*)$", float = true },
  no_initial_focus = true,
})

-- Disable mouse focus
hl.window_rule({
  name = "jetbrains-no-follow-mouse",
  match = { class = "^(jetbrains-.*)$" },
  no_follow_mouse = true,
})
