-- Volume, brightness, keyboard backlight and touchpad controls (OSD drawn by the shell)
-- Based on https://github.com/basecamp/omarchy/blob/v4.0.6/default/hypr/bindings/media.lua
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("omarchy-audio-output-volume raise"), { description = "Volume up", repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("omarchy-audio-output-volume lower"), { description = "Volume down", repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("omarchy-audio-output-volume mute-toggle"), { description = "Mute", locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("omarchy-audio-input-mute"), { description = "Mute microphone", locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("omarchy-brightness-display +5%"), { description = "Brightness up", repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("omarchy-brightness-display 5%-"), { description = "Brightness down", repeating = true, locked = true })
hl.bind("SHIFT + XF86MonBrightnessUp", hl.dsp.exec_cmd("omarchy-brightness-display 100%"), { description = "Brightness maximum", repeating = true, locked = true })
hl.bind("SHIFT + XF86MonBrightnessDown", hl.dsp.exec_cmd("omarchy-brightness-display 1%"), { description = "Brightness minimum", repeating = true, locked = true })
hl.bind("XF86KbdBrightnessUp", hl.dsp.exec_cmd("omarchy-brightness-keyboard up"), { description = "Keyboard brightness up", repeating = true, locked = true })
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("omarchy-brightness-keyboard down"), { description = "Keyboard brightness down", repeating = true, locked = true })
hl.bind("XF86KbdLightOnOff", hl.dsp.exec_cmd("omarchy-brightness-keyboard cycle"), { description = "Keyboard backlight cycle", locked = true })
hl.bind("XF86TouchpadToggle", hl.dsp.exec_cmd("omarchy-toggle-touchpad"), { description = "Toggle touchpad", locked = true })
hl.bind("XF86TouchpadOn", hl.dsp.exec_cmd("omarchy-toggle-touchpad on"), { description = "Enable touchpad", locked = true })
hl.bind("XF86TouchpadOff", hl.dsp.exec_cmd("omarchy-toggle-touchpad off"), { description = "Disable touchpad", locked = true })

-- Precise 1% multimedia adjustments with Alt modifier
hl.bind("ALT + XF86AudioRaiseVolume", hl.dsp.exec_cmd("omarchy-audio-output-volume +1"), { description = "Volume up precise", repeating = true, locked = true })
hl.bind("ALT + XF86AudioLowerVolume", hl.dsp.exec_cmd("omarchy-audio-output-volume -1"), { description = "Volume down precise", repeating = true, locked = true })
hl.bind("ALT + XF86MonBrightnessUp", hl.dsp.exec_cmd("omarchy-brightness-display +1%"), { description = "Brightness up precise", repeating = true, locked = true })
hl.bind("ALT + XF86MonBrightnessDown", hl.dsp.exec_cmd("omarchy-brightness-display 1%-"), { description = "Brightness down precise", repeating = true, locked = true })

-- Media controls through the shell's media service
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("omarchy-shell media next"), { description = "Next track", locked = true })
hl.bind("ALT + XF86AudioPlay", hl.dsp.exec_cmd("omarchy-shell media next"), { description = "Next track", locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("omarchy-shell media playPause"), { description = "Pause", locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("omarchy-shell media playPause"), { description = "Play", locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("omarchy-shell media previous"), { description = "Previous track", locked = true })
hl.bind("ALT + SHIFT + XF86AudioPlay", hl.dsp.exec_cmd("omarchy-shell media previous"), { description = "Previous track", locked = true })

-- Switch audio output with Super + Mute
-- hl.bind("SUPER + XF86AudioMute", hl.dsp.exec_cmd("omarchy-cmd-audio-switch"), { description = "Switch audio output" })

-- Bluetooth device management
hl.bind("SUPER + B", hl.dsp.exec_cmd("omarchy-launch-bluetooth"), { description = "Bluetooth device management" })
