#!/bin/bash

CA_DIR=CA
CA_DEBUG_DIR=$CA_DIR/ca-debug
INTERMEDIATE_DIR=$CA_DIR/Intermediate
INTERMEDIATE_DEBUG_DIR=$INTERMEDIATE_DIR/intermediate-debug

# CA intermediate

<<COMMENTS
openssl req -new -nodes -text -out intermediate.csr \
  -keyout intermediate.key -sha256 -config intermediate.cnf
chmod og-rwx intermediate.key
openssl x509 -req -sha256 -in intermediate.csr -text -days 3650 \
  -extfile /etc/ssl/openssl.cnf -extensions v3_ca \
  -CA ca.crt -CAkey ca.key -CAcreateserial \
   -out intermediate.crt


echo "Printing output of intermediate.csr to intermediate-csr-debug.txt for debug"
openssl req -in intermediate.csr -text -noout > intermediate-csr-debug.txt
echo "Printing output of intermediate.crt to intermediate-crt-debug.txt for debug"
openssl x509 -in intermediate.crt -text -noout > intermediate-crt-debug.txt
COMMENTS

mkdir intermediate-debug

if test -f "ca.crt" ;
then
    echo "CA cert exists, generating intermediate certificate"

    # CA intermediate
    openssl req -new -nodes -text -out $INTERMEDIATE_DIR/intermediate.csr \
      -keyout $INTERMEDIATE_DIR/intermediate.key -sha256 -config intermediate.cnf
    chmod og-rwx $INTERMEDIATE_DIR/intermediate.key
    openssl x509 -req -sha256 -in $INTERMEDIATE_DIR/intermediate.csr -text -days 3650 \
      -extfile /etc/ssl/openssl.cnf -extensions v3_ca \
      -CA $CA_DIR/ca.crt -CAkey $CA_DIR/ca.key -CAcreateserial \
      -out $INTERMEDIATE_DIR/intermediate.crt

openssl pkcs -export -i $INTERMEDIATE_DIR/intermediate.crt -inkey $INTERMEDIATE_DIR/intermediate.key -out $INTERMEDIATE_DIR/intermediate.pfx
else
    echo "CA cert not found, generating CA certificate"
    if test -f "GenCA.sh" ;
    then
        echo "Running GenCA"
        sh GenCA.sh
        exit 0
    else
        echo "Failed to find GenCA, exiting"
        exit 1
    fi
fi
echo "Printing output of intermediate.csr to intermediate-csr-debug.txt for debug"
openssl req -in $INTERMEDIATE_DIR/intermediate.csr -text -noout > $INTERMEDIATE_DEBUG_DIR/intermediate-csr-debug.txt
echo "Printing output of intermediate.crt to intermediate-crt-debug.txt for debug"
openssl x509 -in $INTERMEDIATE_DIR/intermediate.crt -text -noout > $INTERMEDIATE_DEBUG_DIR/intermediate-crt-debug.txt
