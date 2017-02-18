# Vagrant-Sulu

A working (I swear!) example of [Sulu](http://sulu.io) running on a Vagrant VM.

## Primary Installation

* Install composer https://getcomposer.org
* Install vagrant and virtualbox
* Update php to v5.6+ `curl -s https://php-osx.liip.ch/install.sh | bash -s 7.1` (https://php-osx.liip.ch/)
* add `export PATH=/usr/local/php5/bin:$PATH` to `~/.bash_profile`
* `source ~/.bash_profile`
* add `192.168.33.66 sulu.local` to `/etc/hosts` for the VM.
* add `127.0.0.1 sulu.dev` to `/etc/hosts` for the browsersync proxy.
* `vagrant up` to spin up the vm and install dependencies.
* You should now have a working sulu install at [http://sulu.local](http://sulu.local) . Access the admin at [http://sulu.local/admin/login](http://sulu.local/admin/login) with login admin / admin.

#### Local Composer Installation (Optional)
* `cd sulu && composer install --no-scripts` locally to install dependencies. This is optional and the files will not be synced to the vm, but it's helpful for IDE autocompletion.

## Frontend Dev Installation (Optional)

* Run `node -v` to see if you have a current version of node. You should have version 4+.
* Run `npm install -g gulp bower` to install Gulp and Bower.
* Run `npm install && bower install` in the project root on the host.
* If you want to work on the frontend run `gulp serve` to spin up the browsersync proxy and related gulp watchers. A window should open automatically with the site.

## Working with the VM and Composer

Symfony and Vagrant don't play well together out of the box. Because Symfony has a large number of Composer dependencies the application will slow down considerably if these files are stored in the shared filesystem. To get around this the vendor folder has been moved to be a sibling of the main sulu folder, placing it outside of the shared sulu folder on the VM. As a result we have to maintain composer on both the host and the guest. 

When requiring a new composer dependency, first ssh in to the VM using `vagrant ssh`, then `cd /shared/sulu` to get to the shared sulu dir and run `composer require X` from there. The composer.json will be synced back onto the host machine and tracked in git, while the libraries themselves will be installed to the VM's `/shared/vendor` dir. It's not really shared, the name is misleading here. Afterwards you can return to the host's sulu dir and run `composer install --no-scripts` to update your local version of the dependencies.

## Browsersync and the VM

You may have noticed that this project uses Vagrant and Browsersync, which means we have two servers with two domains. I know that's kinda weird, but there's a good reason. sulu.local is the domain for our vm, where the main symfony app executes. Symfony does a lot of things very well, but working with css and js isn't really one of them. Symfony typically uses Assetic for asset management, which works well enough, but lacks the speed and flexibility of Gulp and doesn't work very well with Bower. To get live reloading into the mix as well we have to add Browsersync on top of gulp, which is where we get our second server. The browsersync server doesn't do much, it just acts as a proxy to the vm and inserts code for live reloading. 

## Working with frontend assets and gulp

Gulp