#!/bin/bash
sudo apt update
sudo apt install openjdk-8-jdk
sudo useradd --create-home jenkins
sudo usermod --shell /bin/bash jenkins
sudo usermod gid sudo
wget http://updates.jenkins-ci.org/latest/jenkins.war
chmod 777 jenkins.war
sudo mv jenkins.war /home/jenkins/
sudo cp jenkins.service /etc/systemd/system/jenkins.service
sudo systemctl daemon-reload
sudo systemctl start jenkins



