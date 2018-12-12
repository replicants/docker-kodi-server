#!/bin/sh
(
  pulseaudio --system --daemonize=1
  xpra start :100 --daemon=no --start-child="/usr/bin/kodi --standalone -p --nolirc" --exit-with-children > /usr/share/kodi/portable_data/X.log 2>&1
)
