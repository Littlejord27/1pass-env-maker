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
      echo "source ~/Documents/1pass-snm/cbw_project_setup.sh" >> ~/.bashrc
    fi
    if [ "$1" = "linux" ]
     then
      echo "source ~/.scripts/1pass-snm/cbw_project_setup.sh" >> ~/.bashrc
    fi
    echo "Appending to ~/.bashrc"
   else
    echo "No .basshrc"
  fi #end of basshrc

  if [ -f ~/.zshrc ]
   then
    echo "# 1pass CLI Source from https://github.com/Littlejord27/1password-securenote-maker" >> ~/.zshrc
    if [ "$1" = "mac" ]
     then
      echo "source ~/Documents/1pass-snm/cbw_project_setup.sh" >> ~/.zshrc
    fi
    if [ "$1" = "linux" ]
     then
      echo "source ~/.scripts/1pass-snm/cbw_project_setup.sh" >> ~/.zshrc
    fi
    echo "Appending to ~/.zshrc"
   else
    echo "No .zshrc"
  fi #end of zshrc
  
 else
  echo 'Error: "mac" or "linux"'
fi
