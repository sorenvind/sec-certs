#!/bin/sh

ORG="fundamentio"
MAIL="hi@fundament.io"

########################## CA
SUBJ="/C=DK/ST=Zealand/L=Copenhagen/O=${ORG}/OU=DevOps/emailAddress=${MAIL}"
echo ">>>> Creating _NEW_ CA private/public keys."
echo "     Input: Passphrase for CA."
openssl genrsa -aes256 -out ca-key.pem 2048
openssl req -new -sha512 -subj ${SUBJ} -x509 -days 730 -key ca-key.pem -out ca.pem
