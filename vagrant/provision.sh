#!/usr/bin/env bash

echo "Provisioning devbox"

# php ini override
sudo rm /etc/php5/apache2/conf.d/user.ini
sudo ln -s /shared/vagrant/user.ini /etc/php5/apache2/conf.d/user.ini

# add a dir for default so we get less complaints
sudo mkdir -p /var/www/public

echo "Configuring server for sulu.local"
sudo mkdir -p /var/www/sulu.local
sudo ln -s /shared/sulu/web /var/www/sulu.local/public
sudo cp /shared/vagrant/sulu.local.conf /etc/apache2/sites-available/sulu.local.conf
sudo a2ensite sulu.local.conf

#restart apache to let all changes take effect
sudo service apache2 restart

# make db
echo "Creating sulu DB"
sudo mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS suludb"
sudo mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON suludb.* TO 'suluuser'@'localhost' IDENTIFIED BY 'password'"
sudo mysql -u root --password=root -e "FLUSH PRIVILEGES"

# create local dir for cache and logs
sudo mkdir /shared/sulu_local
sudo chmod -R 777 /shared/sulu_local

sudo mkdir /shared/vendor
sudo chmod -R 777 /shared/vendor

# Create swap file
# To deal with https://getcomposer.org/doc/articles/troubleshooting.md#proc-open-fork-failed-errors
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=2048
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1

# Install dependencies
cd /shared/sulu
sudo composer self-update
composer install --no-progress

# Basic sulu data and assets
app/console sulu:build dev --no-interaction --quiet
app/console sulu:security:role:create admin Sulu
#app/console assets:install --symlink
