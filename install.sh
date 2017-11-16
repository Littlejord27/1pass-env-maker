#!/bin/bash

if [ "$#" -eq 1 ]
 then
  # Check to see if the json processor (jq) is already installed.
  # If it isn't, then copy this file into the bin folder
  if [ -f /usr/local/bin/jq ]
   then
    echo "jq found. Not installing."
   else
    echo "Copying jq to /usr/local/bin/"
    if [ "$1" = "mac" ]
     then
      cp ~/Documents/1pass-cbw/osx/jq /usr/local/bin/
    fi
    if [ "$1" = "linux" ]
     then
      cp ~/Documents/1pass-cbw/linux/jq /usr/local/bin/
    fi
  fi

  # Check to see if the 1pass cli is already installed.
  # If it isn't, then copy this file into the bin folder
  if [ -f /usr/local/bin/op ]
   then
    echo "op found. Not installing."
   else
    echo "Copying op to /usr/local/bin/"
    if [ "$1" = "mac" ]
     then
      cp ~/Documents/1pass-cbw/osx/op /usr/local/bin/
    fi
    if [ "$1" = "linux" ]
     then
      cp ~/Documents/1pass-cbw/linux/op /usr/local/bin/
    fi
  fi

  # Append the onepass path into the bashrc or zshrc file
  if [ -f ~/.bashrc ]
   then
    echo "source ~/Documents/1pass-cbw/onepass.sh" >> ~/.bashrc
   elif [ -f ~/.zshrc ]
    then
     echo "source ~/Documents/1pass-cbw/onepass.sh" >> ~/.zshrc
   else
    echo "Can not find bashrc or zshrc to add to. Add ~/Documents/1pass-cbw/onepass.sh to your path terminal somehow."
  fi
 else
  echo 'Error: "mac" or "linux"'
fi
