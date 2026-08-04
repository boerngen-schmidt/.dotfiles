-- Define terminal tag to style them uniformly
hl.window_rule({
  name = "terminal-tag",
  match = { class = "(Alacritty|kitty|com.mitchellh.ghostty)" },
  tag = "+terminal",
})
