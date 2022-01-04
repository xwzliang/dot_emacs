#!/bin/sh

# Set the screen DPI
xrdb ~/git/dot_emacs/exwm/Xresources

# Run the screen compositor
picom &

# Enable screen locking on suspend
xss-lock -- slock &

# Fire it up
exec dbus-launch --exit-with-session emacs -mm --debug-init
