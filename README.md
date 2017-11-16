# 1password Securenote Maker
## Installation

#### Mac OSX x64 install
```shell
mkdir ~/Documents/1pass-snm
git clone https://github.com/Littlejord27/1password-securenote-maker.git ~/Documents/1pass-snm
~/Documents/1pass-snm/./install.sh mac
```


#### linux x32 install (Digital Ocean droplets)
```shell
mkdir ~/Documents/1pass-snm
git clone https://github.com/Littlejord27/1password-securenote-maker.git ~/Documents/1pass-snm
~/Documents/1pass-snm/./install.sh linux
```

## First time setup

After you have the 1password cli and jq installed, and the onepass.sh added to the source file, you need to set up your 1password token.
Go to your 1password application. Go to Account -> Get Emergency Kit...
You will need your secret key for the next part (A3-XXXXXX-XXXXXX-XXXXX-XXXXX-XXXXX-XXXXX).
In your terminal, run the following command:

```shell
op signin company.1password.com email@domain.com A3-XXXXXX-XXXXXX-XXXXX-XXXXX-XXXXX-XXXXX
```

It should prompt you for your 1password master password. 
After that, you can sign in using 

```shell
1pass-login
```

or

```shell
eval $(op signin company)
```

## Usage

General Usage:

The most complete function is the **1pass** function. It takes in a username and a title. 
It will create a 1password secure note in your private vault as well as generate an
.env, wp-config-db.php, and wp-config.php file in the directory you call the function.

```shell
1pass username "Secure Note - Title - Name"
```


# 1pass-login

```shell
1pass username "Secure Note - Title - Name"
```

# 1pass-create-securenote

```shell
1pass-create-securenote username "Secure Note - Title - Name"
```

# 1pass-create-env

```shell
1pass-create-configdb uuid
```

# 1pass-create-configdb

```shell
1pass-create-configdb uuid
```

# 1pass-create-config

```shell
1pass-create-config
```


## Known Issues

Error: Valut "Private" not found

### Mac

No Mac Specific Issues

### Linux (digital ocean)

No Linux Specific Issues
