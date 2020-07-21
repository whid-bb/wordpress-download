#!/bin/bash

if [ -d "/var/www/$1" ]
then
        chgrp -R www-data /var/www/$1
        find /var/www/$1 -type d -exec chmod g+rx {} +
        find /var/www/$1 -type f -exec chmod g+r {} +

        chown -R $2 /var/www/$1
        find /var/www/$1 -type d -exec chmod u+rwx {} +
        find /var/www/$1 -type f -exec chmod u+rw {} +

        find /var/www/$1 -type d -exec chmod g+s {} +
        chmod -R o-rwx /var/www/$1
else
        echo "Dir /var/www/$1 does not exists"
        exit 9999;
fi
