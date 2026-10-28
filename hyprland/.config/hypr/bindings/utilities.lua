-- Menus
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("omarchy-launch-walker"), { description = "Launch apps" })
hl.bind("SUPER + CTRL + E", hl.dsp.exec_cmd("omarchy-launch-walker -m symbols"), { description = "Emoji picker" })
hl.bind("SUPER + ALT + SPACE", hl.dsp.exec_cmd("omarchy-menu toggle"), { description = "Omarchy menu" })
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd("omarchy-menu toggle system"), { description = "System menu" })
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("omarchy-menu toggle system"), { description = "Power menu", locked = true })
hl.bind("SUPER + CTRL + C", hl.dsp.exec_cmd("omarchy-menu toggle capture"), { description = "Capture menu" })
hl.bind("SUPER + CTRL + O", hl.dsp.exec_cmd("omarchy-menu toggle toggle"), { description = "Toggle menu" })
hl.bind("SUPER + CTRL + H", hl.dsp.exec_cmd("omarchy-menu toggle hardware"), { description = "Hardware menu" })
hl.bind("SUPER + K", hl.dsp.exec_cmd("omarchy-menu-keybindings"), { description = "Show key bindings" })
hl.bind("XF86Calculator", hl.dsp.exec_cmd("gnome-calculator"), { description = "Calculator" })

-- Shell panels
hl.bind("SUPER + CTRL + A", hl.dsp.exec_cmd("omarchy-shell shell toggle omarchy.audio"), { description = "Audio" })
hl.bind("SUPER + CTRL + B", hl.dsp.exec_cmd("omarchy-shell shell toggle omarchy.bluetooth"), { description = "Bluetooth" })
hl.bind("SUPER + CTRL + D", hl.dsp.exec_cmd("omarchy-shell shell toggle omarchy.monitor"), { description = "Display" })
hl.bind("SUPER + CTRL + ALT + D", hl.dsp.exec_cmd("omarchy-shell shell toggle omarchy.clock"), { description = "Calendar" })
hl.bind("SUPER + CTRL + W", hl.dsp.exec_cmd("omarchy-shell shell toggle desktop.network"), { description = "Network" })
hl.bind("SUPER + CTRL + P", hl.dsp.exec_cmd("omarchy-shell shell toggle desktop.power"), { description = "Power" })

-- SUPER + CTRL + [1-9] opens the bar's right-section panels by position
for panel = 1, 9 do
  hl.bind(
    "SUPER + CTRL + code:" .. tostring(panel + 9),
    hl.dsp.exec_cmd("omarchy-shell -q shell togglePanelAt right " .. panel),
    { description = "Bar panel " .. panel }
  )
end

-- Aesthetics
hl.bind("SUPER + SHIFT + SPACE", hl.dsp.exec_cmd("omarchy-toggle-bar"), { description = "Toggle top bar" })
hl.bind("SUPER + CTRL + SPACE", hl.dsp.exec_cmd("omarchy-menu toggle background"), { description = "Background switcher" })
hl.bind("SUPER + SHIFT + CTRL + SPACE", hl.dsp.exec_cmd("omarchy-menu toggle theme"), { description = "Theme menu" })
hl.bind("SUPER + BACKSPACE", hl.dsp.exec_cmd("omarchy-hyprland-window-transparency-toggle"), { description = "Toggle window transparency" })
-- hl.bind("SUPER + SHIFT + BACKSPACE", hl.dsp.exec_cmd("omarchy-hyprland-workspace-toggle-gaps"), { description = "Toggle workspace gaps" })

-- Notifications
-- xkbcommon names the comma keysym "comma"; the upper-case "COMMA" does not match.
hl.bind("SUPER + comma", hl.dsp.exec_cmd("omarchy-shell notifications dismissOne"), { description = "Dismiss last notification" })
hl.bind("SUPER + SHIFT + comma", hl.dsp.exec_cmd("omarchy-shell notifications dismissAll"), { description = "Dismiss all notifications" })
hl.bind("SUPER + CTRL + comma", hl.dsp.exec_cmd("omarchy-toggle-notification-silencing"), { description = "Toggle silencing notifications" })
hl.bind("SUPER + ALT + comma", hl.dsp.exec_cmd("omarchy-shell notifications invokeLast"), { description = "Invoke last notification" })
hl.bind("SUPER + SHIFT + ALT + comma", hl.dsp.exec_cmd("omarchy-shell notifications showHistory"), { description = "Open notification history" })

-- Toggle idling
hl.bind("SUPER + CTRL + I", hl.dsp.exec_cmd("omarchy-toggle-idle"), { description = "Toggle locking on idle" })
hl.bind("SUPER + L", hl.dsp.exec_cmd("omarchy-system-lock"), { description = "Lock screen" })

-- Lid switch: lock on close, re-enable the internal display on open
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("omarchy-system-lid-close"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("omarchy-hyprland-monitor-clamshell"), { locked = true })

-- Toggle nightlight
hl.bind("SUPER + CTRL + N", hl.dsp.exec_cmd("omarchy-toggle-nightlight"), { description = "Toggle nightlight" })

-- Captures
-- hl.bind("PRINT", hl.dsp.exec_cmd("omarchy-cmd-screenshot"), { description = "Screenshot with editing" })
-- hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("omarchy-cmd-screenshot smart clipboard"), { description = "Screenshot to clipboard" })
-- hl.bind("ALT + PRINT", hl.dsp.exec_cmd("omarchy-menu screenrecord"), { description = "Screenrecording" })
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"), { description = "Color picker" })

-- File sharing
-- hl.bind("SUPER + CTRL + S", hl.dsp.exec_cmd("omarchy-menu share"), { description = "Share" })

-- Bar-less information
-- hl.bind("SUPER + CTRL + T", hl.dsp.exec_cmd([[notify-send "    $(date +"%A %H:%M  —  %d %B W%V %Y")"]]), { description = "Show time" })
