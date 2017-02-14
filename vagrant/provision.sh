#!/usr/bin/env bash

echo "Provisioning devbox"

# php ini override
rm /etc/php5/apache2/conf.d/user.ini
ln -s /shared/vagrant/user.ini /etc/php5/apache2/conf.d/user.ini

# add a dir for default so we get less complaints
mkdir -p /var/www/public

echo "Configuring server for sulu.local"
mkdir -p /var/www/sulu.local
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
sudo mkdir /sulu_local
sudo mkdir /shared/vendor
#sudo chmod 777 /shared/vendor

# To deal with https://getcomposer.org/doc/articles/troubleshooting.md#proc-open-fork-failed-errors
/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1

# Install dependencies
cd /shared/sulu
composer self-update -q
composer install --no-progress -q

# Basic sulu data and assets
app/console sulu:build dev --no-interaction --quiet
app/console sulu:security:role:create admin Sulu
app/console assetic:dump

# Fix permissions. TODO : Is vagrant user/group the issue?
cd /
sudo chmod -R 777 sulu_local