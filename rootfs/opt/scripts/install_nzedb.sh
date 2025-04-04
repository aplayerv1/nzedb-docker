#!/usr/bin/with-contenv bash

echo "================================================================================"
echo "Running install_nzedb.sh as $(whoami)".
echo "================================================================================"

[[ ! -d "${_PATH_INSTALL_ROOT}" ]] && exit 1;
[[ ! -f "/home/www-data/.composer/auth.json" ]] && exit 2;
[[ ! "$(whoami)" == "www-data" ]] && exit 3;
export HOME="/home/www-data"
cd "${_PATH_INSTALL_ROOT}" || exit 4;
echo ""
echo "=== Cloning nZEDb from https://github.com/nZEDb/nZEDb.git to ${_PATH_INSTALL_ROOT}"
echo ""
git clone https://github.com/nZEDb/nZEDb.git ${_PATH_INSTALL_ROOT} || exit 5;
#composer create-project --no-dev --keep-vcs --prefer-source nzedb/nzedb ${_PATH_INSTALL_ROOT} || exit 5;
echo ""
chmod -R 755 /opt/html/app/libraries && chmod -R 755 /opt/html/libraries && chmod -R 777 /opt/html/resources && chmod -R 777 /opt/html/www
echo ""
echo "--- Done."
echo ""

# Check and copy config files if they don't exist
echo "=== Checking for configuration files"
if [ -d "${_PATH_INSTALL_ROOT}/configuration" ]; then
  mkdir -p "${_PATH_CUSTOM_CONFIG}"
  for example_file in ${_PATH_INSTALL_ROOT}/configuration/*.example.php; do
    if [ -f "$example_file" ]; then
      base_name=$(basename "$example_file" .example.php)
      target_file="${_PATH_CUSTOM_CONFIG}/${base_name}.php"
      if [ ! -f "$target_file" ]; then
        echo "Copying $example_file to $target_file"
        cp "$example_file" "$target_file"
        chmod 644 "$target_file"
      else
        echo "Config file $target_file already exists, skipping"
      fi
    fi
  done
  echo "--- Configuration files check completed"
else
  echo "--- Configuration directory not found, skipping config files setup"
fi
echo ""

echo "=== Running composer install on nZEDb directory."
echo ""
composer clearcache
composer --no-ansi install || exit 6;
echo ""
echo "--- Done."
echo ""
echo "=== Installing additional modules required."
echo ""
composer --no-ansi require league/oauth2-google || exit 7;
echo ""
echo "--- Done."
exit 0;