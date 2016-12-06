#!/usr/bin/env bash

echo "Provisioning devbox"

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
cd /
sudo mkdir sulu_local


/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1

cd /shared/sulu
composer self-update
composer install --no-progress

app/console sulu:build dev --no-interaction
app/console sulu:security:role:create admin sulu
app/console assetic:dump

cd /
sudo chmod -R 777 sulu_local