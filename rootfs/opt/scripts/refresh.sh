#!/bin/bash

[[ -f "/opt/scripts/refresh.conf" ]] && . "/opt/scripts/refresh.conf";
REFRESH_POSTPROCESS_OPTIONS="${_REFRESH_POSTPROCESS_OPTIONS:-nfo mov tv ama}";

until [[ -f "/opt/http/configuration/install.lock" ]]; do
    sleep 10;
done
until [[ -f "/opt/http/configuration/install.lock" ]]; do
     echo "Importing predb"
     cd /opt/http/cli/data
     php predb_import_daily_batch.php 1483246800 local true"
     echo "Importing Games"
     php populate_steam_games.php
done

if (true); then
    if ! screen -list | grep -q "tmux"; then
        echo "Preparing Life"
        cp /opt/http/misc/update/nix/screen/sequential/threaded.sh /opt/http/misc/update/nix/screen/sequential/user_threaded.sh
        cd /opt/http/misc/update/nix/tmux
        screen -d -m -S tmux /bin/bash -c 'php start.php'
    elif screen -list | grep -q "dead"; then
        echo "screen dead"
        screen -wipe
    else
       echo "Checking if script is running"
       value=$(tmux list-panes -a -F "#{pane_dead} #{pane_id}" | grep "^1" | head -1 | awk '{print $2}')
       if [ "$value" = "%0" ]; then
        printf "its dead jim"
        printf "\n" "restarting"
        pkill tmux
       fi
    fi
    sleep 60;
    tail -n 10 /opt/http/resources/logs/*.log
fi