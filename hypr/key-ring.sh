#!/bin/bash

# Manually resolve the user ID for the session
USER_ID=$(id -u)

# Set runtime directory for the user
export XDG_RUNTIME_DIR="/run/user/$USER_ID"

# Ensure the keyring control directory exists
mkdir -p "$XDG_RUNTIME_DIR/keyring"

# Start the gnome-keyring daemon
eval $(gnome-keyring-daemon --start --components=secrets)

# Export the necessary environment variables
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID

