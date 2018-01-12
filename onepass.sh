#!/bin/bash

1pass(){
  1pass-login
  1pass-securenote-infogather
}

1pass-securenote-infogather(){
  uuid=0
  
  read 'project_name?Project Name: '

  if [ -n "$project_name" ]
    then
      temp_proj_name=$project_name' - Staging - Env'
      read 'note_title?1password Title ('$temp_proj_name'): '
      if [ -n "$note_title" ]
        then
         note_title=$note_title
        else
         note_title=$temp_proj_name
      fi

      1pass-create-securenote $project_name $note_title 

      git clone https://github.com/bryanlittlefield/TUGBOAT.git .

      1pass-create-env $project_name $uuid

      read 'repo_addr?Git Repo to clone: '
      if [ -n "$repo_addr" ]
        then
         docker-compose up -d
         rm -rf var/www/html
         git clone $repo_addr var/www/html/
        else
      fi

      read 'create_wp_bool?Create wp-config? (yes/no): '

      if [ "$create_wp_bool" = "y" ] || [ "$create_wp_bool" = "ye" ] || [ "$create_wp_bool" = "yes" ]
        then
         1pass-create-config
         1pass-create-configdb $uuid
         mv wp-config.php var/www/html/wp-config.php
         mv wp-config-db.php var/www/html/wp-config-db.php
        else
      fi

    else
      echo 'Project Name Required'
  fi
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
 # op signin coolblueweb.1password.com wendy_appleseed@coolblueweb.com A3-XXXXXX-XXXXXX-XXXXX-XXXXX-XXXXX-XXXXX)
}

1pass-create-env(){
  if [ "$#" -eq 2 ]
   then
    project_name=$1
    htpasswd_user=$(op get item "$2" | jq '.details.sections[] | select(.title=="HTACCESS") | .fields[] | select(.t=="HTPASSWD_USER").v' | cut -d '"' -f 2)
    htpasswd_pass=$(op get item "$2" | jq '.details.sections[] | select(.title=="HTACCESS") | .fields[] | select(.t=="HTPASSWD_PASS").v' | cut -d '"' -f 2)
    root_user_pass=$(op get item "$2" | jq '.details.sections[] | select(.title=="Container SSH") | .fields[] | select(.t=="ROOT_USER_PASS").v' | cut -d '"' -f 2)
    dev_user_pass=$(op get item "$2" | jq '.details.sections[] | select(.title=="Container SSH") | .fields[] | select(.t=="DEV_USER_PASS").v' | cut -d '"' -f 2)
    mysql_root_password=$(op get item "$2" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_ROOT_PASSWORD").v' | cut -d '"' -f 2)
    mysql_database=$(op get item "$2" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_DATABASE").v' | cut -d '"' -f 2)
    mysql_user=$(op get item "$2" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_USER").v' | cut -d '"' -f 2)
    mysql_password=$(op get item "$2" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_PASSWORD").v' | cut -d '"' -f 2)
    sh ~/Documents/1pass-snm/env.sh $project_name $htpasswd_user $htpasswd_pass $root_user_pass $dev_user_pass $mysql_root_password $mysql_database $mysql_user $mysql_password > .env
  fi
}

1pass-create-config(){
    sh ~/Documents/1pass-snm/wp-config.sh > wp-config.php
}

1pass-create-configdb(){
  if [ "$#" -eq 1 ]
   then
    mysql_database=$(op get item "$1" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_DATABASE").v' | cut -d '"' -f 2)
    mysql_user=$(op get item "$1" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_USER").v' | cut -d '"' -f 2)
    mysql_password=$(op get item "$1" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_PASSWORD").v' | cut -d '"' -f 2)
    mysql_host='localhost'
    salt=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
    sh ~/Documents/1pass-snm/wp-config-db.sh $mysql_database $mysql_user $mysql_password $mysql_host $salt > wp-config-db.php
  fi
}
