#!/usr/bin/env bash

echo "Provisioning devbox"

# add a dir for default so we get less complaints
mkdir -p /var/www/public

echo "Configuring server for sulu.local"
mkdir -p /var/www/sulu.local
sudo ln -s /shared/sulu/web /var/www/sulu.local/public
sudo cp /vagrant_data/devbox/sulu.local.conf /etc/apache2/sites-available/sulu.local.conf
sudo a2ensite sulu.local.conf

#restart apache to let all changes take effect
sudo service apache2 restart

# make db
echo "Creating Magento DB"
sudo mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS magentodb"
sudo mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON magentodb.* TO 'magentouser'@'localhost' IDENTIFIED BY 'password'"
sudo mysql -u root --password=root -e "FLUSH PRIVILEGES"

cd /
sudo mkdir sulu_local
sudo chmod 777 sulu_local

cd /shared/sulu
composer install

app/console sulu:build dev
app/console sulu:security:role:create
app/console assetic:dump