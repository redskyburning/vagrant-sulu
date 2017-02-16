# Vagrant-Sulu

A working (I swear!) example of [Sulu](http://sulu.io) running on a Vagrant VM.

## Installation

* Install composer https://getcomposer.org
* Install vagrant and virtualbox
* Update php to v5.6+ `curl -s https://php-osx.liip.ch/install.sh | bash -s 7.1` (https://php-osx.liip.ch/)
* add `export PATH=/usr/local/php5/bin:$PATH` to `~/.bash_profile`
* `source ~/.bash_profile`
* add `192.168.33.66 sulu.local` to `/etc/hosts`
* `vagrant up` to spin up the vm and install dependencies.
* `cd sulu && composer install --no-scripts` locally to install dependencies. Vendor files on the host system will not be synced to the guest, but they will be used in some instances such as using app/console to manage assetic.
* Have a look at [http://sulu.local](http://sulu.local) . Access the admin at [http://sulu.local/admin/login](http://sulu.local/admin/login) with login admin / admin

## Working with the VM and Composer

Symfony and Vagrant don't play well together out of the box. Because Symfony has a large number of Composer dependencies the application will slow down considerably if these files are stored in the shared filesystem. To get around this the vendor folder has been moved to be a sibling of the main sulu folder, placing it outside of the shared sulu folder on the VM. As a result we have to maintain composer on both the host and the guest. 

When requiring a new composer dependency, first ssh in to the VM using `vagrant ssh`, then `cd /shared/sulu` to get to the shared sulu dir and run `composer require X` from there. The composer.json will be synced back onto the host machine and tracked in git, while the libraries themselves will be installed to the VM's `/shared/vendor` dir. It's not really shared, the name is misleading here. Afterwards you can return to the host's sulu dir and run `composer install --no-scripts` to update your local version of the dependencies.

## Working with assetic

Assetic does not like running on the VM at all. It seems to have trouble monitoring changes in the shared file system. To use assetic go to the sulu dir on the host and run `app/console assetic:dump/watch/whatever`. Files generated on the host will sync to the guest automatically. Note that sometimes it can take a few reloads before assetic changes make it to the browser. TODO: Why?
