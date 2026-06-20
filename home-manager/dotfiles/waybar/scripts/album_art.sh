#!/bin/bash

# 1. Fetch current track metadata
ART_URL=$(playerctl metadata mpris:artUrl 2>/dev/null)
TITLE=$(playerctl metadata title 2>/dev/null | cut -c1-30)
ARTIST=$(playerctl metadata artist 2>/dev/null | cut -c1-30)

# Fallback profile if no media is active
LOCAL_COVER="/tmp/current_art.png"
if [ -z "$ART_URL" ]; then
    notify-send "Media Player" "No media actively playing"
    exit 0
fi

# 2. Handle cover image conversions (Local storage caching)
if [[ "$ART_URL" == http* ]]; then
    curl -s "$ART_URL" > "$LOCAL_COVER"
else
    # Strip file:// prefix if present
    CLEAN_PATH=$(echo "$ART_URL" | sed 's/file:\/\///')
    cp "$CLEAN_PATH" "$LOCAL_COVER" 2>/dev/null || LOCAL_COVER="$CLEAN_PATH"
fi

# 3. Launch the Integrated Controller Panel via YAD
yad --plug="mediapanel" --tabnum=1 --image="$LOCAL_COVER" --width=280 --height=280 &
yad --plug="mediapanel" --tabnum=2 --form \
    --field="<b>$TITLE</b>:LBL" "" \
    --field="$ARTIST:LBL" "" \
    --field="⏮":BTN "playerctl previous" \
    --field="⏸  ▶":BTN "playerctl play-pause" \
    --field="⏭":BTN "playerctl next" &

yad --paned --key="mediapanel" --title="WaybarMediaCenter" \
    --text="" --orient=vert --no-buttons --undecorated \
    --close-on-unfocus --width=300 --height=400
