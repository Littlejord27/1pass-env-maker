#!/bin/bash

1pass(){
  1pass-login
  uuid=0
  1pass-create-securenote $1 $2
  1pass-create-env $uuid
  1pass-create-configdb $uuid
  1pass-create-config
}

# Docker Functions
1pass-create-securenote(){
   if [ "$#" -eq 2 ]
    then
      SECTION_0_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
      ROOT_USER_PASS_VALUE=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
      DEV_USER_PASS_VALUE=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
      ROOT_USER_PASS_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
      DEV_USER_PASS_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

      SECTION_1_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
      MYSQL_DATABASE_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
      MYSQL_ROOT_PASSWORD_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
      MYSQL_USER_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
      MYSQL_PASSWORD_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
      MYSQL_ROOT_PASSWORD_VALUE=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
      MYSQL_PASSWORD_VALUE=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)

      # Create the Database and User values based off of the Password
      MYSQL_DATABASE_VALUE=$(echo $MYSQL_PASSWORD_VALUE | cut -c 6-9)
      MYSQL_DATABASE_VALUE=$(echo $MYSQL_DATABASE_VALUE"_"$1 | cut -c -16 )
      MYSQL_USER_VALUE=$MYSQL_DATABASE_VALUE

      SECTION_2_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
      HTPASSWD_USER_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
      HTPASSWD_USER_VALUE="cbw_"$1
      HTPASSWD_PASS_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
      HTPASSWD_PASS_VALUE=$(cat /dev/urandom | env LC_CTYPE=C tr -dc '0-9' | fold -w 6 | head -n 1)

      securenote=$(op get template "Secure Note" | jq --arg SECTION_0_HASH $SECTION_0_HASH --arg ROOT_USER_PASS_HASH $ROOT_USER_PASS_HASH --arg ROOT_USER_PASS_VALUE $ROOT_USER_PASS_VALUE --arg DEV_USER_PASS_HASH $DEV_USER_PASS_HASH --arg DEV_USER_PASS_VALUE $DEV_USER_PASS_VALUE '.sections[0] |= .+ {"fields":[{"k":"concealed","n":$ROOT_USER_PASS_HASH,"t":"ROOT_USER_PASS","v":$ROOT_USER_PASS_VALUE},{"k":"concealed","n":$DEV_USER_PASS_HASH,"t":"DEV_USER_PASS","v":$DEV_USER_PASS_VALUE}], name:$SECTION_0_HASH, title:"Container SSH"}')
      securenote=$(echo $securenote | jq --arg SECTION_1_HASH $SECTION_1_HASH --arg MYSQL_DATABASE_HASH $MYSQL_DATABASE_HASH --arg MYSQL_DATABASE_VALUE $MYSQL_DATABASE_VALUE --arg MYSQL_ROOT_PASSWORD_HASH $MYSQL_ROOT_PASSWORD_HASH --arg MYSQL_ROOT_PASSWORD_VALUE $MYSQL_ROOT_PASSWORD_VALUE --arg MYSQL_USER_HASH $MYSQL_USER_HASH --arg MYSQL_USER_VALUE $MYSQL_USER_VALUE --arg MYSQL_PASSWORD_HASH $MYSQL_PASSWORD_HASH --arg MYSQL_PASSWORD_VALUE $MYSQL_PASSWORD_VALUE '.sections[1] |= .+ {"fields":[{"k":"string","n":$MYSQL_DATABASE_HASH,"t":"MYSQL_DATABASE","v":$MYSQL_DATABASE_VALUE},{"k":"string","n":$MYSQL_USER_HASH,"t":"MYSQL_USER","v":$MYSQL_USER_VALUE},{"k":"concealed","n":$MYSQL_ROOT_PASSWORD_HASH,"t":"MYSQL_ROOT_PASSWORD","v":$MYSQL_ROOT_PASSWORD_VALUE},{"k":"concealed","n":$MYSQL_PASSWORD_HASH,"t":"MYSQL_PASSWORD","v":$MYSQL_PASSWORD_VALUE}], name:$SECTION_1_HASH, title:"MySQL"}')
      securenote=$(echo $securenote | jq --arg SECTION_2_HASH $SECTION_2_HASH --arg HTPASSWD_USER_HASH $HTPASSWD_USER_HASH --arg HTPASSWD_USER_VALUE $HTPASSWD_USER_VALUE --arg HTPASSWD_PASS_HASH $HTPASSWD_PASS_HASH --arg HTPASSWD_PASS_VALUE $HTPASSWD_PASS_VALUE '.sections[2] |= .+ {"fields":[{"k":"string","n":$HTPASSWD_USER_HASH,"t":"HTPASSWD_USER","v":$HTPASSWD_USER_VALUE},{"k":"concealed","n":$HTPASSWD_PASS_HASH,"t":"HTPASSWD_PASS","v":$HTPASSWD_PASS_VALUE}], name:$SECTION_2_HASH, title:"HTACCESS"}' | op encode)

      # Send the template into One Note and return the UUID of the new note.
      uuid=$(op create item 'Secure Note' $securenote --title=$2 --vault=Private)
      uuid=$(echo $uuid | jq '.uuid' | cut -d '"' -f 2)
   fi
}


1pass-login(){
 eval $(op signin coolblueweb)
 # First login command
 # All this can be found in your emergency kit.
 # op signin company.1password.com wendy_appleseed@email.com A3-XXXXXX-XXXXXX-XXXXX-XXXXX-XXXXX-XXXXX)
}

1pass-create-env(){
  if [ "$#" -eq 1 ]
   then
    root_user_pass=$(op get item "$1" | jq '.details.sections[] | select(.title=="Container SSH") | .fields[] | select(.t=="ROOT_USER_PASS").v' | cut -d '"' -f 2)
    dev_user_pass=$(op get item "$1" | jq '.details.sections[] | select(.title=="Container SSH") | .fields[] | select(.t=="DEV_USER_PASS").v' | cut -d '"' -f 2)
    mysql_database=$(op get item "$1" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_DATABASE").v' | cut -d '"' -f 2)
    mysql_user=$(op get item "$1" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_USER").v' | cut -d '"' -f 2)
    mysql_password=$(op get item "$1" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_PASSWORD").v' | cut -d '"' -f 2)
    mysql_root_password=$(op get item "$1" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_ROOT_PASSWORD").v' | cut -d '"' -f 2)
    htpasswd_user=$(op get item "$1" | jq '.details.sections[] | select(.title=="HTACCESS") | .fields[] | select(.t=="HTPASSWD_USER").v' | cut -d '"' -f 2)
    htpasswd_pass=$(op get item "$1" | jq '.details.sections[] | select(.title=="HTACCESS") | .fields[] | select(.t=="HTPASSWD_PASS").v' | cut -d '"' -f 2)
    echo "# ==============================" > .env
    echo "# GLOBAL" >> .env
    echo "# ==============================" >> .env
    echo "PROJECT_NAME=tugboat" >> .env
    echo "" >> .env
    echo "# ==============================" >> .env
    echo "# WEB" >> .env
    echo "# ==============================" >> .env
    echo "PHP_VERSION=stable" >> .env
    echo "" >> .env
    echo "ROOT_USER_PASS=$root_user_pass" >> .env
    echo "DEV_USER_PASS=$dev_user_pass" >> .env
    echo "INCLUDE_HTPASSWD=true" >> .env
    echo "HTPASSWD_USER=$HTPASSWD_USER_VALUE" >> .env
    echo "HTPASSWD_PASS=$HTPASSWD_PASS_VALUE" >> .env
    echo "" >> .env
    echo "# ==============================" >> .env
    echo "# MYSQL" >> .env
    echo "# ==============================" >> .env
    echo "MYSQL_VERSION=stable" >> .env
    echo "" >> .env
    echo "MYSQL_ROOT_PASSWORD=$mysql_root_password" >> .env
    echo "MYSQL_DATABASE=$mysql_database" >> .env
    echo "MYSQL_USER=$mysql_user" >> .env
    echo "MYSQL_PASSWORD=$mysql_password" >> .env
    echo "#MYSQL_ALLOW_EMPTY_PASSWORD=yes" >> .env
    echo "" >> .env
    echo "# ==============================" >> .env
    echo "# GITHUB REPOSITORY" >> .env
    echo "# ==============================" >> .env
    echo "#GITHUB_USER=bryanlittlefield" >> .env
    echo "#GITHUB_USER_PASS=mypass123" >> .env
    echo "#GITHUB_REPO_NAME=TUGBOAT" >> .env
  fi
}

1pass-create-configdb(){
  if [ "$#" -eq 1 ]
   then
    mysql_database=$(op get item "$1" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_DATABASE").v' | cut -d '"' -f 2)
    mysql_user=$(op get item "$1" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_USER").v' | cut -d '"' -f 2)
    mysql_password=$(op get item "$1" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_PASSWORD").v' | cut -d '"' -f 2)
    salt=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
    echo "<?php" > wp-config-db.php
    echo "" >> wp-config-db.php
    echo "define('DB_NAME', '$mysql_database');" >> wp-config-db.php
    echo "define('DB_USER', '$mysql_user');" >> wp-config-db.php
    echo "define('DB_PASSWORD', '$mysql_password');" >> wp-config-db.php
    echo "define('DB_HOST', 'localhost');" >> wp-config-db.php
    echo "" >> wp-config-db.php
    echo "" >> wp-config-db.php
    echo "$salt" >> wp-config-db.php
  fi
}

1pass-create-config(){
    echo "<?php" > wp-config.php
    echo "/**" >> wp-config.php
    echo " * The base configuration for WordPress" >> wp-config.php
    echo " *" >> wp-config.php
    echo " * The wp-config.php creation script uses this file during the" >> wp-config.php
    echo " * installation. You don't have to use the web site, you can" >> wp-config.php
    echo " * copy this file to \"wp-config.php\" and fill in the values." >> wp-config.php
    echo " *" >> wp-config.php
    echo " * This file contains the following configurations:" >> wp-config.php
    echo " *" >> wp-config.php
    echo " * * MySQL settings" >> wp-config.php
    echo " * * Secret keys" >> wp-config.php
    echo " * * Database table prefix" >> wp-config.php
    echo " * * ABSPATH" >> wp-config.php
    echo " *" >> wp-config.php
    echo " * @link https://codex.wordpress.org/Editing_wp-config.php" >> wp-config.php
    echo " *" >> wp-config.php
    echo " * @package WordPress" >> wp-config.php
    echo " */" >> wp-config.php
    echo "" >> wp-config.php
    echo "require_once('wp-config-db.php');" >> wp-config.php
    echo "" >> wp-config.php
    echo "/** Database Charset to use in creating database tables. */" >> wp-config.php
    echo "define('DB_CHARSET', 'utf8');" >> wp-config.php
    echo "" >> wp-config.php
    echo "/** The Database Collate type. Don't change this if in doubt. */" >> wp-config.php
    echo "define('DB_COLLATE', '');" >> wp-config.php
    echo "" >> wp-config.php
    echo "/**" >> wp-config.php
    echo " * WordPress Database Table prefix." >> wp-config.php
    echo " *" >> wp-config.php
    echo " * You can have multiple installations in one database if you give each" >> wp-config.php
    echo " * a unique prefix. Only numbers, letters, and underscores please!" >> wp-config.php
    echo " */" >> wp-config.php
    echo "" >> wp-config.php
    echo "\$table_prefix  = 'wp_';" >> wp-config.php
    echo "" >> wp-config.php
    echo "/**" >> wp-config.php
    echo " * For developers: WordPress debugging mode." >> wp-config.php
    echo " *" >> wp-config.php
    echo " * Change this to true to enable the display of notices during development." >> wp-config.php
    echo " * It is strongly recommended that plugin and theme developers use WP_DEBUG" >> wp-config.php
    echo " * in their development environments." >> wp-config.php
    echo " *" >> wp-config.php
    echo " * For information on other constants that can be used for debugging," >> wp-config.php
    echo " * visit the Codex." >> wp-config.php
    echo " *" >> wp-config.php
    echo " * @link https://codex.wordpress.org/Debugging_in_WordPress" >> wp-config.php
    echo " */" >> wp-config.php
    echo "" >> wp-config.php
    echo "define('WP_DEBUG', false);" >> wp-config.php
    echo "" >> wp-config.php
    echo "/* That's all, stop editing! Happy blogging. */" >> wp-config.php
    echo "/** Absolute path to the WordPress directory. */" >> wp-config.php
    echo "if ( !defined('ABSPATH') )" >> wp-config.php
    echo "    define('ABSPATH', dirname(__FILE__) . '/');" >> wp-config.php
    echo "/** Sets up WordPress vars and included files. */" >> wp-config.php
    echo "require_once(ABSPATH . 'wp-settings.php');" >> wp-config.php
}