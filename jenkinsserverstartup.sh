#!bin/bash
curl -L https://aka.ms/InstallAzureCli | bash

groupName="JenkinsWildflyGroup"
networkName="JenkinsWildflyNetwork"
networkSecurityGroup="JenkinsWildflyNetworkSecurityGroup"
networkPublicIP="JenkinsWildflyIP"
networkInterfaceCard="JenkinsWildflyNIC"

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
az network public-ip create --name $networkPublicIP --dns-name jenkinswildflyvirtualmachines --allocation-method Static
az network nic create --name $networkInterfaceCard --vnet-name $networkName --subnet jenkinswildfly --network-security-group $networkSecurityGroup --public-ip-address $networkPublicIP
az vm create --name Jenkins --image UbuntuLTS --nics $networkInterfaceCard
az vm create --name Wildfly --image UbuntuLTS --nics $networkInterfaceCard