#!/bin/sh

HOST="fqdn"
ALTNAME="alt-fqdn"
PORT="443"

ORG="fundamentio"
MAIL="hi@fundament.io"

echo "${HOST}" > fqdnhost
echo "${PORT}" > fqdnhostport

########################## CA

########################## Server Key
SERVER_DIR="config-server"

SUBJ="/C=DK/ST=Zealand/L=Copenhagen/O=${ORG}/OU=DevOps/CN=${HOST}/emailAddress=${MAIL}/subjectAltName=DNS.1=${ALTNAME}"
echo ">>>> Creating Server key and signature by CA certificate."
echo "     Input: Passphrase for CA."
openssl genrsa -out server-key.pem 2048
openssl req -new -sha512 -subj ${SUBJ} -key server-key.pem -out server.csr

# Sign server key and get cert
openssl x509 -req -days 365 -in server.csr -CA ca.pem -CAkey ca-key.pem \
  -CAcreateserial -out server-cert.pem

echo ">>>> Creating a complete config directory for docker servers in ${SERVER_DIR}."
echo "     The content of that directory can be copied to \$registry/distribution/certs as is."
echo ""
mkdir -p ${SERVER_DIR}/${HOST}:${PORT}
mv server-key.pem ${SERVER_DIR}/${HOST}:${PORT}/server.key
mv server-cert.pem ${SERVER_DIR}/${HOST}:${PORT}/server.crt
cp ca.pem ${SERVER_DIR}/${HOST}:${PORT}/ca.crt


########################## Cleanup
# Clean up CSRs and other temp files
rm -v server.csr
