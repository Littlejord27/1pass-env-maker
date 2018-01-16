# 1password Securenote Maker
## Installation

#### Mac OSX x64 install
```shell
mkdir ~/Documents/1pass-snm
git clone https://github.com/Littlejord27/1password-securenote-maker.git ~/Documents/1pass-snm
chmod u+x ~/Documents/1pass-snm/./install.sh
~/Documents/1pass-snm/./install.sh mac
```


#### Linux x32 install (Digital Ocean droplets)
```shell
mkdir -p ~/.scripts/1pass-snm
git clone https://github.com/Littlejord27/1password-securenote-maker.git ~/.scripts/1pass-snm
chmod u+x ~/.scripts/1pass-snm/./install.sh
~/.scripts/1pass-snm/./install.sh linux
```

## First time setup

After you have the 1password cli and jq installed, and the onepass.sh added to the source file, you need to set up your 1password token.
Go to your 1password application. Go to Account -> Get Emergency Kit...
You will need your secret key for the next part (A3-XXXXXX-XXXXXX-XXXXX-XXXXX-XXXXX-XXXXX).
In your terminal, run the following command:

```shell
projectsetup firstlogin
```

## Usage

General Usage:

The most complete function is the **1pass** function. It takes in a username and a title. 
It will create a 1password secure note in your private vault as well as generate an
.env, wp-config-db.php, and wp-config.php file in the directory you call the function.

```shell
projectsetup newproject
```



New project will require the following information

```text
Project Name: Name of the project. This will be used in the .env file.

1password Title: This is the title given to the entry in 1password

Git Repo: If you choose to clone in tugboat, it will then prompt you for a repo address that will then clone into var/www/html

```


### Skip typing in 1Password Master Password each time

```shell
projectsetup login --save
```


## Known Issues

Error: Valut "Private" not found

### Mac

No Mac Specific Issues

### Linux (digital ocean)

No Linux Specific Issues
