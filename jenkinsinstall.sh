#!/bin/bash
sudo apt update
sudo apt install openjdk-8-jdk -y
sudo useradd --create-home jenkins
sudo usermod --shell /bin/bash jenkins
sudo usermod gid sudo
wget http://updates.jenkins-ci.org/latest/jenkins.war
echo "Modding"
chmod 777 jenkins.war
echo "Moving Jenkins.war"
sudo mv jenkins.war /home/jenkins/
echo "Moving Jenkins.Service"
sudo cp jenkins.service /etc/systemd/system/jenkins.service
echo "system reload"
sudo systemctl daemon-reload
echo "start jenkins"
sudo systemctl start jenkins



