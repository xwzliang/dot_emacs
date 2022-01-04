#!/bin/sh

# Set the screen DPI
xrdb ~/git/dot_emacs/exwm/Xresources

# Fire it up
exec dbus-launch --exit-with-session emacs -mm --debug-init
