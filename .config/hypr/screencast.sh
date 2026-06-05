#!/usr/bin/env bash

# Configure
SPEC="-a"
TERMINAL=kitty
# Example:
# SPEC="-a --codec libx265"

FILE="$HOME/Videos/Screencasts/screencast-$(date +'%Y-%m-%d_%H%M%S').mp4"
LOGFILE="/tmp/recstat.log"

pkill -x fuzzel

OPT=$({
    if pidof wf-recorder >/dev/null; then
        echo "stop"
    fi

    hyprctl monitors |
        awk '/^Monitor/ { print $2 } END { print "region\nconfigure screencast" }'
} | fuzzel --dmenu --hide-prompt)

[[ -z "$OPT" ]] && exit

if [[ "$OPT" == "configure screencast" ]]; then
    $TERMINAL -e hx ~/.config/hypr/screencast.sh

elif [[ "$OPT" == "stop" ]]; then
    if pidof wf-recorder >/dev/null; then
        pkill wf-recorder

        FINAL_FILENAME=$(sed '1q' "$LOGFILE")

        if [[ $(
            notify-send \
                -a "wf-recorder" \
                -i video-display \
                -h string:file_path:"$FINAL_FILENAME" \
                -A "open=Open Location" \
                "Recording Stopped" \
                "File saved to: ${FINAL_FILENAME##*/}"
        ) == "open" ]]; then
            nautilus "$FINAL_FILENAME"
        fi
    fi

elif [[ "$OPT" == "region" ]]; then
    echo "$FILE" > "$LOGFILE"

    pkill wf-recorder

    wf-recorder \
        $SPEC \
        -g "$(slurp)" \
        -f "$FILE" \
        >> "$LOGFILE" 2>&1 &

else
    echo "$FILE" > "$LOGFILE"

    pkill wf-recorder

    wf-recorder \
        $SPEC \
        -o "$OPT" \
        -f "$FILE" \
        >> "$LOGFILE" 2>&1 &
fi
