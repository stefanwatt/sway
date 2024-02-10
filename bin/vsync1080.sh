#!/run/current-system/sw/bin/bash
# xrandr --newmode "1080vsync" 138.50 1920 1968 2000 2080 1080 1083 1088 1111 +hsync -vsync
# xrandr --addmode HDMI-A-0 1080vsync
xrandr -s 1920x1080 -r 60.0
xrandr --output HDMI-A-0 --set TearFree on
