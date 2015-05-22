#!/bin/bash

HOST=`cat fqdnhost`
PORT=`cat fqdnhostport`

# Input: The client dir
CLIENT=$1

########################## Client
CLIENT_DIR="config-clients/${CLIENT}"

echo ">>>> Creating client key and CSR. Passphrase for CA."
openssl genrsa -out key.pem 2048
openssl req -subj '/CN=client' -new -key key.pem -out client.csr

# Make key suitable for client authentication
echo extendedKeyUsage = clientAuth > extfile.cnf

# Sign client key and get cert
openssl x509 -req -days 365 -in client.csr -CA ca.pem -CAkey ca-key.pem \
  -CAcreateserial -out cert.pem -extfile extfile.cnf

echo ">>>> Creating a complete config directory for docker clients in ${CLIENT_DIR}."
echo "     The content of that directory can be copied to /etc/docker/certs.d as is."
echo ""
mkdir -p ${CLIENT_DIR}/${HOST}:${PORT}
mv key.pem ${CLIENT_DIR}/${HOST}:${PORT}/client.key
mv cert.pem ${CLIENT_DIR}/${HOST}:${PORT}/client.cert
cp ca.pem ${CLIENT_DIR}/${HOST}:${PORT}/ca.crt

echo "You can move the files with the following commands:"
echo "cp config-server/* ../distribution/certs/"
echo "cp scp -r ${CLIENT_DIR}/${HOST}:${PORT}/ ${HOST}:~"


########################## Cleanup
# Clean up CSRs and other temp files
rm -v extfile.cnf
