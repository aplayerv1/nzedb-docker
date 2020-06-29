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
    echo "SphinxSearch"
    cd /opt/http/misc/sphinxsearch
    echo "Creating Se Tables"
    php create_se_tables.php 0 9312
    echo "Populating rt_indexes"
    php populate_rt_indexes.php releases_rt
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
       echo "screen is running"
    fi
    sleep 60;
fi

 
