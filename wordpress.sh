#!/bin/bash

WP_DOMAIN=https://wordpress.org/
WP_NAME=latest.tar.gz
WEB_FOLDER=/var/www

FULL_ADDRESS=$WP_DOMAIN$WP_NAME

echo -e "Insert folder to unpack wordpress ($WEB_FOLDER): \c"
read user_folder

echo -e "Insert DB name:"
read user_db_name

root_mkdir() {
  if [ -d $WEB_FOLDER/$user_folder ]
  then
    echo "Directory exists, aborting..."
    exit 0
  else
    echo "Creating dir"
    su -c "mkdir $WEB_FOLDER/$user_folder && ./webservperm.sh $user_folder $USER"
  fi
}

validate_url() {

  if [[ `wget -S --spider $1  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then echo "true"; fi

}


download_wordpress() {
  if [[ `validate_url $FULL_ADDRESS` == true ]];
  then
    echo "Downloading wordpress..."
    wget $FULL_ADDRESS -P /tmp/ 2>&1
    echo "Done"
  else
    echo "$FULL_ADDRESS does not exists"
    exit 0
  fi
}

copy_wordpress_dest() {
  tar -xzf /tmp/$WP_NAME -C $WEB_FOLDER/$user_folder --strip=1
}

create_database() {
    read -p "mysql user? " -e mysql_user
    echo "Mysql pass: "
    mysql -u$mysql_user -p -e "create database $user_db_name"
}

check_if_import() {

  echo "Do you want to import db from file?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) import_db_from_file; break;;
      No ) exit 0;
    esac
  done

}

import_db_from_file() {

  while true; do
    read -p "Enter .sql file path " -i "$HOME/" -e sql_path
    if [ -f "$sql_path" ]
    then
        echo "Importing DB"
        mysql -uroot -p $user_db_name < $sql_path
        exit 0
    else
      echo "try again fucker"
    fi
  done
}



root_mkdir
download_wordpress
copy_wordpress_dest
create_database
check_if_import
