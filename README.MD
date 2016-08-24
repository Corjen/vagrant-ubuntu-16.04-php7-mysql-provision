Vagrant - Virtualbox - Ubuntu 16.04 - PHP7 - MySQL
======================
This is a very simple, step-by-step guide to get up and running with a specific vagrant box in no-time.

The box itself is preinstalled with Ubuntu 16.04, Nginx, PHP7 and MySQL.

NOTE: We use this for our own projects because it matches our production server and is quite easy to setup. If you're looking for a more feature-rich solution, there are way better solutions out there. Check out [Scotch Box](https://box.scotch.io) for a great, ready-to-go LAMP stack.

Installation
--------------
- Make sure you have a recent version of [Vagrant](https://www.vagrantup.com) and [Virtualbox](https://www.virtualbox.org)
- Clone or download this repo

## Download the base box

Download the .box file from [https://corjen.stackstorage.com/index.php/s/19qLztoSvs4cIJA](https://corjen.stackstorage.com/index.php/s/19qLztoSvs4cIJA) and put it in the repo folder

Import the box
--------------
Import the box by running:

```vagrant box add ubuntu-16.04-php7-mysql-v1.0 ubuntu16-php7-mysql.box```

This will save the box to ```~/.vagrant.d/boxes/ubuntu-16.04-php7-mysql-v1.0```

**You only have to run this the very first time, after that the box will be saved to your local file system and you can skip this step**

Change Vagrantfile
---------------------

Change *example.dev* on this line to represent your local development URL:
```config.vm.synced_folder './public', '/var/www/example.dev/html/', nfs: true```

If you're using multiple boxes, it can be easy to change the last part of the ip adress to some number you're not using yet. Change the ip adress on this line:
```config.vm.network "private_network", ip: "192.168.50.100"```


Change provision.sh
-------------------

In provision.sh, change every occurence of *example.dev* to your local development url. You can also change the name of the development database to something of for you liking on this line:
```CREATE DATABASE IF NOT EXISTS example_develop;```

NOTE: Ensure that the path on this line ```root /var/www/example.dev/html;``` in *provision.sh* is matching the path in *Vagrantfile* on this line ```config.vm.synced_folder './public', '/var/www/example.dev/html/', nfs: true```

Connecting to the database
--------------------------

You can authenticate to the db with username *dev* and passsword *dev*. MySQL is running on localhost.

If you want to do database management with something like Sequel Pro you can use the following settings:

- MySQL Host *127.0.0.1*
- Username *dev*
- Password *dev*
- SSH Host *Fill in the ip adress you've set in Vagrantfile*
- SSH User *vagrant*
- SSH Key *Point it to: ~/.vagrant.d/insecure_private_key*

Change your host file
---------------------

Point your host file to the chosen url & ip adress. Should be something like this: ```192.168.50.100  example.dev```. Then, run ```vagrant up``` and you should be good to go!

Common errors
-------------

- *Vagrant cannot forward the specified ports on this VM...* - Change the port number in your Vagrantfile

- *NFS is reporting that your exports file is invalid...* - Run ```sudo rm /etc/exports && sudo touch /etc/exports```
