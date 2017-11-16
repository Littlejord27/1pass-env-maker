# 1password Securenote Maker
## Installation

#### Mac OSX x64 install
```shell
mkdir ~/Documents/1pass-cbw
git clone https://github.com/jordan-cbw/1pass-cbw.git ~/Documents/1pass-cbw
cd ~/Documents/1pass-cbw
./install.sh mac
```


#### linux x32 install (Digital Ocean droplets)
```shell
mkdir ~/Documents/1pass-cbw
git clone https://github.com/jordan-cbw/1pass-cbw.git ~/Documents/1pass-cbw
cd ~/Documents/1pass-cbw
./install.sh linux
```

## First time setup

After you have the 1password cli and jq installed, and the onepass.sh added to the source file, you need to set up your 1password token.
Go to your 1password application. Go to Account -> Get Emergency Kit...
You will need your secret key for the next part (A3-XXXXXX-XXXXXX-XXXXX-XXXXX-XXXXX-XXXXX).
In your terminal, run the following command:

```shell
op signin coolblueweb.1password.com coolbluedude@coolblueweb.com A3-XXXXXX-XXXXXX-XXXXX-XXXXX-XXXXX-XXXXX
```

It should prompt you for your 1password master password. 
After that, you can sign in using 

```shell
1pass-login
```

or

```shell
eval $(op signin coolblueweb)
```
