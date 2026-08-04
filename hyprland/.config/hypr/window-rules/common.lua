local vars = require("vars")

-- Floating windows
hl.window_rule({
  name = "floating-window-float",
  match = { tag = "floating-window" },
  float = true,
})

hl.window_rule({
  name = "floating-window-center",
  match = { tag = "floating-window" },
  center = true,
})

hl.window_rule({
  name = "floating-window-size",
  match = { tag = "floating-window" },
  size = "875 600",
})

hl.window_rule({
  name = "tag-floating-window-apps",
  match = {
    class = "(org.omarchy.bluetui|org.omarchy.impala|org.omarchy.wiremix|org.omarchy.btop|org.omarchy.terminal|org.omarchy.bash|org.gnome.NautilusPreviewer|org.gnome.Evince|com.gabm.satty|Omarchy|About|TUI.float|imv|mpv)",
  },
  tag = "+floating-window",
})

hl.window_rule({
  name = "tag-floating-window-file-dialogs",
  match = {
    class = "(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus)",
    title = "^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to [open|save].*|[C|c]hoose.*)",
  },
  tag = "+floating-window",
})

hl.window_rule({
  name = "gnome-calculator-float",
  match = { class = "org.gnome.Calculator" },
  float = true,
})

-- Red border on fullscreen windows
hl.window_rule({
  name = "fullscreen-border-color",
  match = { fullscreen = true },
  border_color = vars.fullscreen_border_color,
})

-- Fullscreen screensaver
hl.window_rule({
  name = "screensaver-fullscreen",
  match = { class = "org.omarchy.screensaver" },
  fullscreen = true,
})

hl.window_rule({
  name = "screensaver-float",
  match = { class = "org.omarchy.screensaver" },
  float = true,
})

-- No transparency on media windows
hl.window_rule({
  name = "media-no-opacity",
  match = { class = "^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$" },
  opacity = "1 1",
})

-- Popped window rounding
hl.window_rule({
  name = "pop-rounding",
  match = { tag = "pop" },
  rounding = 8,
})

-- Prevent idle while open
hl.window_rule({
  name = "noidle-inhibit",
  match = { tag = "noidle" },
  idle_inhibit = "always",
})
