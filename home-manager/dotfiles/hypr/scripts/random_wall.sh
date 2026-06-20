#!/usr/bin/env bash

WALL_DIR="$HOME/Pictures/Wallpapers"
NEW_WALL=$(find "$WALL_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | shuf -n 1)

# Apply with a custom transition effect (outer, wave, wipe, grow, fade)
if [ -n "$NEW_WALL" ]; then
    awww img "$NEW_WALL" \
        --transition-type grow \
        --transition-pos top-right \
        --transition-duration 1.5 \
        --transition-fps 60
fi
