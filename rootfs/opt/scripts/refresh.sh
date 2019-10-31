#!/bin/bash

[[ -f "/opt/scripts/refresh.conf" ]] && . "/opt/scripts/refresh.conf";
REFRESH_POSTPROCESS_OPTIONS="${_REFRESH_POSTPROCESS_OPTIONS:-nfo mov tv ama}";

until [[ -f "/opt/http/configuration/install.lock" ]]; do
    sleep 10;
done
# until [[ -f "/opt/http/configuration/install.lock" ]]; do
#     echo "Importing predb"
#     su - www-data -s /bin/bash -c "$(which php)  /opt/http/cli/data/predb_import_daily_batch.php 0 local true"
# done

# while (true); do
#     su - www-data -s /bin/bash -c "$(which php) /opt/http/misc/update/nix/multiprocessing/binaries.php 0";
#     su - www-data -s /bin/bash -c "$(which php) /opt/http/misc/update/nix/multiprocessing/releases.php"
#     for pparm in ${REFRESH_POSTPROCESS_OPTIONS}; do
#         su - www-data -s /bin/bash -c "$(which php) /opt/http/misc/update/nix/multiprocessing/postprocess.php $pparm";
#     done
#     sleep 60;
#done
if (true); then
    if ! screen -list | grep -q "tmux"; then
        echo "Preparing Life"
        cp /opt/http/misc/nix/screen/squential/threaded.sh /opt/http/misc/nix/screen/squential/user_threaded.sh
        screen -d -m -S tmux /bin/bash -c 'su - www-data -s /bin/bash -c php /opt/http/misc/nix/tmux/start.php'
    else
       echo "screen is running"
    fi
fi
 
