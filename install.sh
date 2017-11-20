#!/bin/bash

if [ "$#" -eq 1 ]
 then
  # Check to see if the json processor (jq) is already installed.
  # If it isn't, then copy this file into the bin folder
  if [ -f /usr/local/bin/jq ] || [ -f /usr/bin/jq ];
   then
    echo "jq found. Not installing."
   else
    echo "Copying jq to /usr/local/bin/"
    if [ "$1" = "mac" ]
     then
      chmod u+x ~/Documents/1pass-snm/osx/jq
      cp ~/Documents/1pass-snm/osx/jq /usr/local/bin/
    fi
    if [ "$1" = "linux" ]
     then
      sudo apt-get install jq
    fi
  fi

  # Check to see if the 1pass cli is already installed.
  # If it isn't, then copy this file into the bin folder
  if [ -f /usr/local/bin/op ] || [ -f /usr/bin/op ];
   then
    echo "op found. Not installing."
   else
    echo "Copying op to /usr/local/bin/"
    if [ "$1" = "mac" ]
     then
      chmod u+x ~/Documents/1pass-snm/osx/op
      cp ~/Documents/1pass-snm/osx/op /usr/local/bin/
    fi
    if [ "$1" = "linux" ]
     then
      chmod u+x ~/.scripts/1pass-snm/linux/op
      cp ~/.scripts/1pass-snm/linux/op /usr/bin/
    fi
  fi

  # Append the onepass path into the bashrc or zshrc file
  if [ -f ~/.bashrc ]
   then
    echo "# 1pass CLI Source from https://github.com/Littlejord27/1password-securenote-maker" >> ~/.bashrc
    if [ "$1" = "mac" ]
     then
      echo "source ~/Documents/1pass-snm/onepass.sh" >> ~/.bashrc
    fi
    if [ "$1" = "linux" ]
     then
      echo "source ~/.scripts/1pass-snm/onepass.sh" >> ~/.bashrc
    fi
    echo "Appending to ~/.bashrc"
   elif [ -f ~/.zshrc ]
    then
     echo "# 1pass CLI Source from https://github.com/Littlejord27/1password-securenote-maker" >> ~/.zshrc
     if [ "$1" = "mac" ]
     then
      echo "source ~/Documents/1pass-snm/onepass.sh" >> ~/.zshrc
    fi
    if [ "$1" = "linux" ]
     then
      echo "source ~/.scripts/1pass-snm/onepass.sh" >> ~/.zshrc
    fi
     echo "Appending to ~/.zshrc"
   else
    echo "Can not find bashrc or zshrc to add to. Add ~/Documents/1pass-cbw/onepass.sh to your path terminal somehow."
  fi
 else
  echo 'Error: "mac" or "linux"'
fi
