#!/bin/bash

projectsetup(){
  if [ "$1" = "newproject" ] || [ "$1" = "newProject" ]
    then
      newproject
  elif [ "$1" = "login" ]
    then
      if [ "$2" = "--save" ]
        then
          printf "Please type your Master Password for 1password\n"
          printf "It will be saved as .password in the script folder\n"
          read -s __masterpassop
          printf "\n\n"

          if [ -f ~/.scripts/1pass-snm/cbw_project_setup.sh ]
            then
              echo $__masterpassop > ~/.scripts/1pass-snm/.password
              1pass-login
          elif [ -f ~/Documents/1pass-snm/cbw_project_setup.sh ]
            then
              echo $__masterpassop > ~/Documents/1pass-snm/.password
              1pass-login
          else
              printf "Could not find script folder to save .password to\n"
              printf "Either move the script folder to ~/Documents/1pass-snm or ~/.scripts/1pass-snm \n"
              printf "Or create your own .password file in the folder directory\n"
          fi
      elif [ "$2" = "--help" ]
        then
          printf "projectSetup login\n"
          printf "projectSetup login --save\n"
          printf "projectSetup help --save\n"
      else
          1pass-login
      fi
  elif [ "$1" = "firstlogin" ]
    then
      printf "\nCoolblueweb Email Address?   "
      read __1passeml
      printf "1Password secret-key -- can be found in your emergency kit? (A3-XXXXXX-XXXXXX-XXXXX-XXXXX-XXXXX-XXXXX)\n"
      read __1passScky
      printf "\n"
      op signin coolblueweb.1password.com $__1passeml $__1passScky
      printf "\nPlease run the 'export OP_SESSION...' command above\n\n"
  elif [ "$1" = "--help" ]
    then
      printf "Help -- I need somebody --- Section had not been done yet\n\n"
  else 
    printf "Invalid Command. Please type 'projectSetup --help' \n\n"
  fi
}

newproject(){

  1pass-login

  __uuid=0
  
  printf "Project Name:   "
  read __project_name


  __formatedProjectName=$(echo $__project_name | sed 's/ //g' | awk '{print tolower($0)}')

  if [ -n "$__project_name" ]
    then
      __temp_proj_name=$__project_name'-Staging-Env'
      printf "1password Title ($__temp_proj_name):   "
      read __note_title
      if [ -n "$__note_title" ]
        then
         __note_title=$__note_title
        else
         __note_title=$__temp_proj_name
      fi

      printf "Creating 1password note...\n"

      __note_title=${__note_title//[[:blank:]]/}

      1pass-create-securenote $__formatedProjectName $__note_title 

      printf "Note finished creating\n"

      printf "Clone TUGBOAT down (1) or just create .env file (2)?:   "
      read __clone_tugboat_bool

      if [ "$__clone_tugboat_bool" = "1" ]
        then

          printf "Cloning in Tugboat...\n"
          git clone https://github.com/bryanlittlefield/TUGBOAT.git .

          mkdir .1pass-templates

          printf "Creating .env file...\n"
          1pass-create-env $__formatedProjectName $__uuid

          printf "Git Repo to clone:   "
          read __repo_addr

          if [ -n "$__repo_addr" ]
            then
              mkdir var/www/html
              git clone $__repo_addr var/www/html/
            else
              printf "Skipping cloning repo\n"
          fi
        else
          mkdir .1pass-templates
          printf "Creating .env file...\n"
          1pass-create-env $__formatedProjectName $__uuid
      fi
      
      printf "Creating wp-config.php\n"
      1pass-create-config
      
      printf "Creating wp-config-db.php\n"
      1pass-create-configdb $__formatedProjectName $__uuid

    else
      printf 'Project Name Required\n'
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
      __uuid=$(op create item 'Secure Note' $securenote --title=$2 --vault=Shared)
      __uuid=$(echo $__uuid | jq '.uuid' | cut -d '"' -f 2)
   fi
}

# GITHUB Gist URL for env.sh
# https://gist.githubusercontent.com/Littlejord27/365a52b1834da0e2a1f403af37603692/raw/b9259eba0a1b07bb2aed22dd4e4c37ac9b728aa3/env.sh
1pass-create-env(){
  if [ "$#" -eq 2 ]
   then
    project_name=$1
    __htpasswd_user=$(op get item "$2" | jq '.details.sections[] | select(.title=="HTACCESS") | .fields[] | select(.t=="HTPASSWD_USER").v' | cut -d '"' -f 2)
    __htpasswd_pass=$(op get item "$2" | jq '.details.sections[] | select(.title=="HTACCESS") | .fields[] | select(.t=="HTPASSWD_PASS").v' | cut -d '"' -f 2)
    __root_user_pass=$(op get item "$2" | jq '.details.sections[] | select(.title=="Container SSH") | .fields[] | select(.t=="ROOT_USER_PASS").v' | cut -d '"' -f 2)
    __dev_user_pass=$(op get item "$2" | jq '.details.sections[] | select(.title=="Container SSH") | .fields[] | select(.t=="DEV_USER_PASS").v' | cut -d '"' -f 2)
    __mysql_root_password=$(op get item "$2" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_ROOT_PASSWORD").v' | cut -d '"' -f 2)
    __mysql_database=$(op get item "$2" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_DATABASE").v' | cut -d '"' -f 2)
    __mysql_user=$(op get item "$2" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_USER").v' | cut -d '"' -f 2)
    __mysql_password=$(op get item "$2" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_PASSWORD").v' | cut -d '"' -f 2)
    curl https://gist.githubusercontent.com/Littlejord27/365a52b1834da0e2a1f403af37603692/raw/b9259eba0a1b07bb2aed22dd4e4c37ac9b728aa3/env.sh > .1pass-templates/env.sh
    sh  .1pass-templates/env.sh $project_name $__htpasswd_user $__htpasswd_pass $__root_user_pass $__dev_user_pass $__mysql_root_password $__mysql_database $__mysql_user $__mysql_password > .env
  fi
}

# GITHUB Gist URL for wp-config.sh
# https://gist.githubusercontent.com/Littlejord27/59fee22da7453635ad96a8e6199c53a3/raw/1b79473e3e55d45eb23655733a814af8fdfb03bf/wp-config.sh
1pass-create-config(){
  curl https://gist.githubusercontent.com/Littlejord27/59fee22da7453635ad96a8e6199c53a3/raw/1b79473e3e55d45eb23655733a814af8fdfb03bf/wp-config.sh > .1pass-templates/wp-config.sh
  sh .1pass-templates/wp-config.sh > wp-config.php
}

# GITHUB Gist URL for wp-config-db.sh
# https://gist.githubusercontent.com/Littlejord27/e269c2b5e85a8341fbc8c363a983da9b/raw/59894f991cecdff054df9f4299c39ccf6c11001a/wp-config-db.sh
1pass-create-configdb(){
  if [ "$#" -eq 2 ]
   then
    __mysql_database=$(op get item "$2" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_DATABASE").v' | cut -d '"' -f 2)
    __mysql_user=$(op get item "$2" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_USER").v' | cut -d '"' -f 2)
    __mysql_password=$(op get item "$2" | jq '.details.sections[] | select(.title=="MySQL") | .fields[] | select(.t=="MYSQL_PASSWORD").v' | cut -d '"' -f 2)
    __mysql_host=$1"_db"
    __salt=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
    printf "***********************************************\n**\n"
    printf "** Host: $__mysql_host\n"
    printf "** User: $__mysql_user\n"
    printf "** Pass: $__mysql_password\n"
    printf "** DB  : $__mysql_database\n**\n"
    printf "***********************************************\n"
    curl https://gist.githubusercontent.com/Littlejord27/e269c2b5e85a8341fbc8c363a983da9b/raw/59894f991cecdff054df9f4299c39ccf6c11001a/wp-config-db.sh > .1pass-templates/wp-config-db.sh
    sh .1pass-templates/wp-config-db.sh $__mysql_database $__mysql_user $__mysql_password $__mysql_host $__salt > wp-config-db.php
  fi
}

1pass-login(){
 if [ -f ~/.scripts/1pass-snm/.password ]
    then
      eval $(op signin coolblueweb $(cat ~/.scripts/1pass-snm/.password))
  elif [ -f ~/Documents/1pass-snm/.password ]
    then
      eval $(op signin coolblueweb $(cat ~/Documents/1pass-snm/.password))
  else
      eval $(op signin coolblueweb)
  fi
 # First login command
 # op signin coolblueweb.1password.com wendy_appleseed@coolblueweb.com A3-XXXXXX-XXXXXX-XXXXX-XXXXX-XXXXX-XXXXX)
}
