#!/bin/bash

mkdir $1

# root
openssl req -new -nodes -text -out root.csr \
  -keyout $1/root.key -subj "/C=US/ST=Washington/L=Pullman/O=BRGaull Development/OU=IT/CN=root.yourdomain.com"
chmod og-rwx root.key
openssl req -text -noout -verify -in root.csr | grep verify
openssl x509 -req -in root.csr -text -days 3650 \
  -extfile /etc/ssl/openssl.cnf -extensions v3_ca \
  -signkey $1/root.key -out $1/root.crt

rm root.csr

# check certs:
echo 'root.crt:'
openssl x509 -in $1/root.crt -text -noout

cp ./GenerateIntermediate.sh $1/.
cd $1
./GenerateIntermediate.sh intermediate