#!/bin/bash
wget http://updates.jenkins-ci.org/latest/jenkins.war
chmod 777 jenkins.war
sudo mv jenkins.war /home/jenkins/
sudo systemctl restart jenkins

