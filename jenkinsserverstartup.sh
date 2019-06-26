#!/bin/bash
sudo curl -L https://aka.ms/InstallAzureCliDeb | sudo bash

groupName="JenkinsWildflyGroup"
networkName="JenkinsWildflyNetwork"
networkSecurityGroup="JenkinsWildflyNetworkSecurityGroup"
networkPublicIP="JenkinsIP"
networkPublicIP2="WildflyIP"
networkInterfaceCard="JenkinsNIC"
networkInterfaceCard2="WildflyNIC"

az login
az group create --name $groupName --location uksouth
az configure --defaults location=uksouth
az configure --defaults group=$groupName

az network vnet create --name $networkName --address-prefixes 10.0.0.0/16 --subnet-name jenkinswildfly --subnet-prefix 10.0.0.0/24
az network nsg create --name $networkSecurityGroup
az network nsg rule create --name HTTP --priority 500 --nsg-name $networkSecurityGroup
az network nsg rule create --name SSH --priority 450 --destination-port-ranges 22 --nsg-name $networkSecurityGroup
az network nsg rule create --name HTTPS --priority 475 --destination-port-ranges 443 --nsg-name $networkSecurityGroup
az network nsg rule create --name JENKINSWILDFLY --priority 425 --destination-port-ranges 8080 --nsg-name $networkSecurityGroup

az network public-ip create --name $networkPublicIP --dns-name jenkinsvirtualmachine --allocation-method Static
az network public-ip create --name $networkPublicIP2 --dns-name wildflyvirtualmachine --allocation-method Static

az network nic create --name $networkInterfaceCard --vnet-name $networkName --subnet jenkinswildfly --network-security-group $networkSecurityGroup --public-ip-address $networkPublicIP

az vm create --name Jenkins --image UbuntuLTS --nics $networkInterfaceCard --size Standard_B1s --private-ip-address 10.0.0.1 --generate-ssh-keys
echo "////////////////////////////////////"
echo "First VM CREATED"
echo "////////////////////////////////////"
az network nic create --name $networkInterfaceCard2 --vnet-name $networkName --subnet jenkinswildfly --network-security-group $networkSecurityGroup --public-ip-address $networkPublicIP2
az vm create --name Wildfly --image UbuntuLTS --nics $networkInterfaceCard2 --size Standard_B1s --private-ip-address 10.0.0.2 --generate-ssh-keys
