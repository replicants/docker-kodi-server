#!/bin/sh
(
  xpra start :100 --daemon=no --start-child="/usr/bin/kodi --standalone -p --nolirc" --exit-with-children
)
