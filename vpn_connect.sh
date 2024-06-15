#!/usr/bin/env bash


# create a var env TF_VAR_local_network_ip to connect it to your private vpc
#and manage your cloud ressources.

export TF_VAR_local_network_ip="$(curl ifconfig.me | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')"