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

## First time setup

Error: Valut "Private" not found

## Known Issues

#### Mac

No Mac Specific Issues

#### Linux (digital ocean)

No Linux Specific Issues
