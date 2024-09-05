#!/usr/bin/env bash
WEZ_CONFIG_CALLBACK=INIT_WORKSPACE
[[ -n $1 ]] || exit 1
encoded=$(echo -n "$1" | base64)
cmd=(bash -c "printf '\\033]1337;SetUserVar=%s=%s\\007' \"$WEZ_CONFIG_CALLBACK\" \"$encoded\"; sleep 0.1")
if [[ -t 1 ]]; then
    "${cmd[@]}"
else
    wezterm cli spawn -- "${cmd[@]}"
fi
