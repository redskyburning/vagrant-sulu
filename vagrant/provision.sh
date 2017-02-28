#!/usr/bin/env bash

# Folders
PUBLIC="/var/www/public"
SULU_ROOT="/var/www/sulu.local"
SULU_PUBLIC="$SULU_ROOT/public"
SULU_SHARED="/shared/sulu"
SULU_WEB="$SULU_SHARED/web"
SULU_LOCAL="/shared/sulu_local"
VENDOR="/shared/vendor"
SWAP="/var/swap.1"

# Db Info
SULU_DB_NAME="suludb"
SULU_DB_USER="suluuser"
SULU_DB_PASSWORD="password"

echo "Provisioning devbox"

# php ini override
sudo rm /etc/php5/apache2/conf.d/user.ini
sudo ln -s /shared/vagrant/user.ini /etc/php5/apache2/conf.d/user.ini

# add a dir for default so we get less complaints
test -d "$PUBLIC" || (sudo mkdir -p "$PUBLIC")

echo "Configuring server for sulu.local"
# Create dir and link if needed.
test -d "$SULU_ROOT" || (sudo mkdir -p "$SULU_ROOT")
test -h "$SULU_PUBLIC" || (sudo ln -s "$SULU_WEB" "$SULU_PUBLIC")

# Always update domain config, ensures changes are picked up by provision
sudo cp /shared/vagrant/sulu.local.conf /etc/apache2/sites-available/sulu.local.conf
sudo a2ensite sulu.local.conf

#restart apache to let all changes take effect
sudo service apache2 restart

# make db
echo "Creating sulu DB"
# The following line makes 'vagrant provision' very destructive. Optional, use with care.
sudo mysql -u root --password=root -e "DROP DATABASE IF EXISTS $SULU_DB_NAME"
sudo mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS $SULU_DB_NAME"
sudo mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON $SULU_DB_NAME.* TO '$SULU_DB_USER'@'localhost' IDENTIFIED BY '$SULU_DB_PASSWORD'"
sudo mysql -u root --password=root -e "FLUSH PRIVILEGES"

# create local dir for cache and logs
# the following line clears out the local cache on 'vagrant provision' usually a good idea, but you may want to comment it out.
sudo rm -rf "$SULU_LOCAL"
test -d "$SULU_LOCAL" || sudo mkdir "$SULU_LOCAL"
sudo chmod -R 777 "$SULU_LOCAL"

# create vendor outside of shared filesystem
sudo rm -rf "$VENDOR"
test -d "$VENDOR" || (sudo mkdir "$VENDOR")
sudo chmod -R 777 "$VENDOR"

# Create swap file
# To deal with https://getcomposer.org/doc/articles/troubleshooting.md#proc-open-fork-failed-errors
if [[ ! -f "$SWAP" ]]
    then
        sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=2048
        sudo /sbin/mkswap "$SWAP"
        sudo /sbin/swapon "$SWAP"
fi

# Install dependencies
cd "$SULU_SHARED"
sudo composer self-update
composer install --no-progress

# Basic sulu data and assets
app/console sulu:build dev --no-interaction --quiet
app/console sulu:security:role:create admin Sulu
#app/console assets:install --symlink
