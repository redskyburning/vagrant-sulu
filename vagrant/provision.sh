#!/usr/bin/env bash

echo "Provisioning devbox"

# Add xdebug
sudo apt-get -qy update
sudo apt-get install -qy php5-dev
sudo pecl install xdebug
sudo cp /vagrant_data/devbox/xdebug.ini /etc/php5/apache2/conf.d/

# add a dir for default so we get less complaints
mkdir -p /var/www/public

echo "Configuring server for www.stelladev.com"
mkdir -p /var/www/www.stelladev.com
sudo ln -s /vagrant_data/alex/web /var/www/www.stelladev.com/public
sudo cp /vagrant_data/devbox/www.stelladev.com.conf /etc/apache2/sites-available/www.stelladev.com.conf
sudo a2ensite www.stelladev.com.conf

#restart apache to let all changes take effect
sudo service apache2 restart

# make db
echo "Creating Magento DB"
sudo mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS magentodb"
sudo mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON magentodb.* TO 'magentouser'@'localhost' IDENTIFIED BY 'password'"
sudo mysql -u root --password=root -e "FLUSH PRIVILEGES"