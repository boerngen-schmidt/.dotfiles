-- Based on https://github.com/basecamp/omarchy/blob/master/default/hypr/envs.conf
-- According to https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
--   When using uwsm place environment variables ~/.config/uswsm/env

hl.config({
  xwayland = {
    force_zero_scaling = true,
  },
})

-- Use XCompose file
hl.env("XCOMPOSEFILE", "~/.XCompose")

-- Don't show update on first launch
hl.config({
  ecosystem = {
    no_update_news = true,
  },
})
