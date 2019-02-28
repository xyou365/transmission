#!/bin/bash
# Install transmission.
# By @CodyDoby

sudo apt-get install transmission-daemon

sudo service transmission-daemon stop

# sudo apt-get install vim  && sudo vim /etc/transmission-daemon/settings.json

if [ $1 ]; then
    username=$1
else
    read -p "Username: " username
    #username="transmission"
fi


if [ $2 ]; then
    password=$2
else
    read -p "Password: " password
fi

if [ $3 ]; then
    trpath=$3
else
    #read -p "Path: " trpath
    trpath="/home/$username"
fi

sudo mkdir -p $trpath
sudo mkdir -p "$trpath"/downloads
sudo mkdir -p "$trpath"/tmp
chmod a+w $trpath
chmod a+w $trpath/*

config="/etc/transmission-daemon/settings.json"
printf "Setting dht-enabled to false | "
sed -i "s|\"dht-enabled: true\"|\"dht-enabled: false\"|" $config && echo "Done"

printf "Setting download-dir to "$trpath"/download | "
sed -i "s|\"download-dir\".*$|\"download-dir\": \"$trpath\/downloads\",|" $config && echo "Done"

printf "Setting incomplete-dir to "$trpath"/tmp | "
sed -i "s|\"incomplete-dir\".*$|\"incomplete-dir\": \"$trpath\/tmp\",|" $config && echo "Done"

printf "Setting incomplete-dir-enabled to true | "
sed -i "s|\"incomplete-dir-enabled\": false|\"incomplete-dir\": true|" $config && echo "Done"

printf "Setting username to $username | "
sed -i "s|\"rpc-username\".*$|\"rpc-username\": \"$username\",|" $config && echo "Done"

printf "Setting password to $password | "
sed -i "s|\"rpc-password\".*$|\"rpc-password\": \"$password\",|" $config && echo "Done"

printf "Setting rpc-whitelist-enabled to false | "
sed -i "s|\"rpc-whitelist-enabled\": true|\"rpc-whitelist-enabled\": false|" $config && echo "Done"

# cat $config

# Beuatify
sudo wget https://github.com/ronggang/transmission-web-control/raw/master/release/install-tr-control-cn.sh
sudo bash install-tr-control-cn.sh

sudo service transmission-daemon start && echo "IP:9091 | Username is $username | Password is $password"
