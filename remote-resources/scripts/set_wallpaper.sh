#! /usr/bin/env bash
PATH_PROPERTY=/backdrop/screen0/monitor0/workspace0/last-image
WALLPAPER_PATH=~/.wallpaper/wallpaper.png
xfconf-query --channel xfce4-desktop --property $PATH_PROPERTY --set $WALLPAPER_PATH
