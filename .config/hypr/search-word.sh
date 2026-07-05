#!/usr/bin/env bash

QUERY=$(wl-paste --primary)

QUERY=$(echo "$QUERY" | xargs)

if [ -z "$QUERY" ]; then
    exit 0
fi

if [[ "$QUERY" =~ ^https?:// ]] || [[ "$QUERY" =~ ^www\. ]]; then
    if [[ "$QUERY" =~ ^www\. ]]; then
        xdg-open "https://${QUERY}"
    else
        xdg-open "$QUERY"
    fi
else
    xdg-open "https://www.duckduckgo.com/search?q=${QUERY}"
fi
