#!/bin/bash

yum update -y

username="gcp-user"

yum -y install git wget
yum install -y nano vim
adduser $username
usermod -a -G wheel $username
echo "$username:$username" | chpasswd

## install docker
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh

sudo systemctl start docker.service
sudo systemctl enable docker.service

sudo usermod -aG docker $username

curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

## pull line chatbot from github
cd ~
git clone https://github.com/uuboyscy/NobodyChatbot.git
git clone https://github.com/BingHongLi/line_chat_bot_tutorial.git
sleep 5
# change owner
chown -R $username NobodyChatbot/
chown -R $username /root
chmod 777 -R NobodyChatbot

chown -R $username line_chat_bot_tutorial/
chown -R $username /root
chmod 777 -R line_chat_bot_tutorial

echo "alias freemem=\"sudo sh -c 'echo 1 >/proc/sys/vm/drop_caches';sudo sh -c 'echo 2 >/proc/sys/vm/drop_caches';sudo sh -c 'echo 3 >/proc/sys/vm/drop_caches'\"" >> /etc/profile
echo "alias chatbot-start='docker-compose -f /root/NobodyChatbot/docker-compose.yml up --build -d;sleep 3;\
  sh /root/NobodyChatbot/ngurl.sh'" >> /etc/profile
echo "alias chatbot-stop='docker-compose -f /root/NobodyChatbot/docker-compose.yml down'" >> /etc/profile
echo "alias ngrok-url='sh /root/NobodyChatbot/ngurl.sh'" >> /etc/profile

source /etc/profile
