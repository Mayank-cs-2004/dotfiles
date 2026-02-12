# Auto-start Hyprland
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    # Force use of the wrapper script to avoid the red error bar
    exec start-hyprland
fi
