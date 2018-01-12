#!/bin/bash

 envFile=".env"
 while IFS= read -r envLine
  do
   if [[ $envLine == *"ROOT_USER_PASS"* ]]; then
    ROOT_USER_PASS=$(echo $envLine | awk -F '=' '{print $2}')
   fi
   if [[ $envLine == *"DEV_USER_PASS"* ]]; then
    DEV_USER_PASS=$(echo $envLine | awk -F '=' '{print $2}')
   fi
   if [[ $envLine == *"MYSQL_ROOT_PASSWORD"* ]]; then
    MYSQL_ROOT_PASSWORD=$(echo $envLine | awk -F '=' '{print $2}')
   fi
   if [[ $envLine == *"MYSQL_DATABASE"* ]]; then
    MYSQL_DATABASE=$(echo $envLine | awk -F '=' '{print $2}')
   fi
   if [[ $envLine == *"MYSQL_USER"* ]]; then
    MYSQL_USER=$(echo $envLine | awk -F '=' '{print $2}')
   fi
   if [[ $envLine == *"MYSQL_PASSWORD"* ]]; then
    MYSQL_PASSWORD=$(echo $envLine | awk -F '=' '{print $2}')
   fi
   if [[ $envLine == *"PROJECT_NAME"* ]]; then
    PROJECT_NAME=$(echo $envLine | awk -F '=' '{print $2}')
   fi
   if [[ $envLine == *"HTPASSWD_USER"* ]]; then
    HTPASSWD_USER=$(echo $envLine | awk -F '=' '{print $2}')
   fi
   if [[ $envLine == *"HTPASSWD_PASS"* ]]; then
    HTPASSWD_PASS=$(echo $envLine | awk -F '=' '{print $2}')
   fi
 done < "$envFile"

 if [[ -z "$ROOT_USER_PASS" ]]; then
  echo "ROOT_USER_PASS was empty.  Setting now..."
  ROOT_USER_PASS=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 else
  echo $ROOT_USER_PASS
 fi
 if [[ -z "$DEV_USER_PASS" ]]; then
  echo "DEV_USER_PASS was empty.  Setting now..."
  DEV_USER_PASS=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 else
  echo $DEV_USER_PASS
 fi
 if [[ -z "$MYSQL_ROOT_PASSWORD" ]]; then
  echo "MYSQL_ROOT_PASSWORD was empty.  Setting now..."
  MYSQL_ROOT_PASSWORD=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 else
  echo $MYSQL_ROOT_PASSWORD
 fi
 if [[ -z "$MYSQL_DATABASE" ]]; then
  echo "MYSQL_DATABASE was empty.  Setting now..."
  MYSQL_DATABASE=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 else
  echo $MYSQL_DATABASE
 fi
 if [[ -z "$MYSQL_USER" ]]; then
  echo "MYSQL_USER was empty.  Setting now..."
  MYSQL_USER=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 else
  echo $MYSQL_USER
 fi
 if [[ -z "$MYSQL_PASSWORD" ]]; then
  echo "MYSQL_PASSWORD was empty.  Setting now..."
  MYSQL_PASSWORD=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 else
  echo $MYSQL_PASSWORD
 fi
 if [[ -z "$PROJECT_NAME" ]]; then
  echo "PROJECT_NAME was empty."
  #PROJECT_NAME=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 fi
 if [[ -z "$HTPASSWD_USER" ]]; then
  echo "HTPASSWD_USER was empty.  Setting now..."
  HTPASSWD_USER="cbw_"
 else
  echo $HTPASSWD_USER
 fi
 if [[ -z "$HTPASSWD_PASS" ]]; then
  echo "HTPASSWD_PASS was empty.  Setting now..."
  HTPASSWD_PASS=$(cat /dev/urandom | env LC_CTYPE=C tr -dc '0-9' | fold -w 6 | head -n 1)
 else
  echo $HTPASSWD_PASS
 fi
 HTPASSWD_USER_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 HTPASSWD_PASS_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 ROOT_USER_PASS_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 DEV_USER_PASS_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 MYSQL_ROOT_PASSWORD_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 MYSQL_DATABASE_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 MYSQL_USER_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 MYSQL_PASSWORD_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 HTPASSWD_USER_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 HTPASSWD_PASS_HASH=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 
 #PROJECT_NAME
 #ROOT_USER_PASS
 #DEV_USER_PASS
 #MYSQL_ROOT_PASSWORD
 #MYSQL_DATABASE
 #MYSQL_USER
 #MYSQL_PASSWORD
 #HTPASSWD_USER
 #HTPASSWD_PASS
 
 echo "# ==============================" > .envTest
 echo "# GLOBAL" >> .envTest
 echo "# ==============================" >> .envTest
 echo "PROJECT_NAME=$PROJECT_NAME" >> .envTest
 echo "" >> .envTest
 echo "# ==============================" >> .envTest
 echo "# WEB" >> .envTest
 echo "# ==============================" >> .envTest
 echo "PHP_VERSION=stable" >> .envTest
 echo "" >> .envTest
 echo "ROOT_USER_PASS=$ROOT_USER_PASS" >> .envTest
 echo "DEV_USER_PASS=$DEV_USER_PASS" >> .envTest
 echo "INCLUDE_HTPASSWD=true" >> .envTest
 echo "HTPASSWD_USER=$HTPASSWD_USER" >> .envTest
 echo "HTPASSWD_PASS=$HTPASSWD_PASS" >> .envTest
 echo "" >> .envTest
 echo "# ==============================" >> .envTest
 echo "# MYSQL" >> .envTest
 echo "# ==============================" >> .envTest
 echo "MYSQL_VERSION=stable" >> .envTest
 echo "" >> .envTest
 echo "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD" >> .envTest
 echo "MYSQL_DATABASE=$MYSQL_DATABASE" >> .envTest
 echo "MYSQL_USER=$MYSQL_USER" >> .envTest
 echo "MYSQL_PASSWORD=$MYSQL_PASSWORD" >> .envTest
 echo "#MYSQL_ALLOW_EMPTY_PASSWORD=yes" >> .envTest
 echo "" >> .envTest
 echo "# ==============================" >> .envTest
 echo "# GITHUB REPOSITORY" >> .envTest
 echo "# ==============================" >> .envTest
 echo "#GITHUB_USER=bryanlittlefield" >> .envTest
 echo "#GITHUB_USER_PASS=mypass123" >> .envTest
 echo "#GITHUB_REPO_NAME=TUGBOAT" >> .envTest
