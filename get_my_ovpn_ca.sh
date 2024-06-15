#!/bin/bash

# Chemin vers le répertoire Easy-RSA
EASYRSA_PATH="~/myWork/cloud_training/terra-infra/vpn_ca/easy-rsa/easyrsa3/"

# Initialisation du PKI
cd $EASYRSA_PATH
./easyrsa init-pki

# Construction de l'Autorité de Certification (CA)
./easyrsa build-ca nopass

# Génération d'une Demande de Certificat pour le Client sans Passphrase
./easyrsa gen-req client1 nopass

# Signature de la Demande de Certificat pour le Client
./easyrsa sign-req client client1

# Génération du Diffie-Hellman
./easyrsa gen-dh

# Génération de la Clé TLS Auth
openvpn --genkey --secret ta.key

echo "Certificats et clés générés avec succès."
