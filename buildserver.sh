#!/bin/bash

#update/upgrade the server
sudo apt-get update -y
sudo apt-get upgrade


#installing and configuring nginx 
sudo apt install nginx -y 
sudo systemctl enable nginx
sudo systemctl start nginx 

#install vim 
sudo apt install vim -y

#install copy-paste tools 
apt-get install open-vm-tools
apt-get install open-vm-tools-desktop 

#install ufw/firewall
sudo apt install ufw
sudo ufw allow ssh
sudo ufw disable
sudo ufw enable
sudo ufw status verbose

#install ssh 
sudo apt-get install openssh-client

#install netstat
sudo apt instal net-tools

#install curl 
sudo apt install curl

#install pm2
sudo apt install npm
sudo npm install pm2@latest -g


#install nodejs latest version
curl -fsSL https://deb.nodesouirce.com/setup_18.x | sudo -E bash -
sudo apt install nodejs
node --version

#install angular-cli

#install nodejs latest version 

#install php 

#install docker 

#install mysql

#install apache 

#show port command 
sudo netstat -tulpn

