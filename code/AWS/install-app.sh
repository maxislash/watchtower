#!/bin/bash

echo "Hello" > /home/ubuntu/hello.txt

#Install the libraries needed
sudo apt-get update -y
sudo apt-get install -y git apache2 php5 php5-mysql curl php5-curl zip unzip python-pip libapache2-mod-php5
sudo pip install awscli --ignore-installed six

#Install all the things needed to PHP
export COMPOSER_HOME=/root && /usr/bin/composer.phar self-update 1.0.0-alpha11
curl -sS https://getcomposer.org/installer | php
php composer.phar require aws/aws-sdk-php
cp -r /vendor /var/www/html

#Clone the private repo
git clone git@github.com:illinoistech-itm/glasssecurity.git
cp -r /itmd555 /home/ubuntu
cp /glasssecurity/code/AWS/create_db.php /var/www/html
cp /glasssecurity/code/AWS/push.php /var/www/html
cp /glasssecurity/code/AWS/read.php /var/www/html

#rm /var/www/html/index.html
#cd /var/www/html/
#php create-db.php

#Restart the apache server to be sure it's online
sudo systemctl enable apache2
sudo systemctl start apache2

