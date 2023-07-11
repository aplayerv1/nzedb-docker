#!/usr/bin/with-contenv bash

echo "================================================================================"
echo "Running install_nzedb.sh as $(whoami)".
echo "================================================================================"

[[ ! -d "${_PATH_INSTALL_ROOT}" ]] && exit 1;
[[ ! "$(whoami)" == "www-data" ]] && exit 2;
export HOME="/home/www-data"
cd "${_PATH_INSTALL_ROOT}" || exit 3;
echo ""
echo "=== Cloning nZEDb from https://github.com/nZEDb/nZEDb.git to ${_PATH_INSTALL_ROOT}"
echo ""
git clone https://github.com/nZEDb/nZEDb.git ${_PATH_INSTALL_ROOT} || exit 4;
#composer create-project --no-dev --keep-vcs --prefer-source nzedb/nzedb ${_PATH_INSTALL_ROOT} || exit 5;
echo ""
chmod -R 755 /opt/html/app/libraries && chmod -R 755 /opt/html/libraries && chmod -R 777 /opt/html/resources && chmod -R 777 /opt/html/www
echo ""
echo "--- Done."
echo ""
echo "=== Running composer install on nZEDb directory."
echo ""
composer clearcache
composer --no-ansi install || exit 5;
echo ""
echo "--- Done."
echo ""
echo "=== Installing additional modules required."
echo ""
composer --no-ansi require league/oauth2-google || exit 6;
echo ""
echo "--- Done."
exit 0;
