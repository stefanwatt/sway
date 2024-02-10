#!/bin/env bash
xos packages
xrandr --newmode "3440x1440_144.00" 1086.75 3440 3744 4128 4816 1440 1443 1453 1568 -hsync +vsync
xrandr --addmode DisplayPort-0 3440x1440_144.00
xrandr -s 3440x1440 -r 144.0
xrandr --output DisplayPort-0 --set TearFree on

xrandr --newmode "1080vsync" 138.50 1920 1968 2000 2080 1080 1083 1088 1111 +hsync -vsync
