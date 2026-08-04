-- Shared values used across more than one Lua module.
-- Only fullscreen_border_color needs this: it's defined here but consumed by
-- window-rules/common.lua. Everything else stays local to the file that uses it.

return {
  fullscreen_border_color = "rgba(ff3333ee) rgba(ff0099ee) 45deg",
}
