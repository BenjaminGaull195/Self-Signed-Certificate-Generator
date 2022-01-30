#!/bin/bash

CA_DIR=CA
CA_DEBUG_DIR=$CA_DIR/ca-debug
INTERMEDIATE_DIR=$CA_DIR/Intermediate
INTERMEDIATE_DEBUG_DIR=$INTERMEDIATE_DIR/intermediate-debug

mkdir $CA_DIR
mkdir $CA_DEBUG_DIR
mkdir $INTERMEDIATE_DIR
mkdir $INTERMEDIATE_DEBUG_DIR


# CA root
openssl req -new -nodes -text -out $CA_DIR/ca.csr \
  -keyout $CA_DIR/ca.key -sha256 -config ca.cnf
chmod og-rwx $CA_DIR/ca.key
openssl x509 -req -in $CA_DIR/ca.csr -text -days 3650 \
  -extfile /etc/ssl/openssl.cnf -extensions v3_ca \
  -signkey $CA_DIR/ca.key -sha256 -out $CA_DIR/ca.crt


echo "Printing output of ca.csr to ca-csr-debug.txt for debug"
openssl req -in $CA_DIR/ca.csr -text -noout > $CA_DEBUG_DIR/ca-csr-debug.txt
echo "Printing output of ca.crt to ca-crt-debug.txt for debug"
openssl x509 -in $CA_DIR/ca.crt -text -noout > $CA_DEBUG_DIR/ca-crt-debug.txt


# CA intermediate
openssl req -new -nodes -text -out $INTERMEDIATE_DIR/intermediate.csr \
  -keyout $INTERMEDIATE_DIR/intermediate.key -sha256 -config intermediate.cnf
chmod og-rwx $INTERMEDIATE_DIR/intermediate.key
openssl x509 -req -sha256 -in $INTERMEDIATE_DIR/intermediate.csr -text -days 3650 \
  -extfile /etc/ssl/openssl.cnf -extensions v3_ca \
  -CA $CA_DIR/ca.crt -CAkey $CA_DIR/ca.key -CAcreateserial \
   -out $INTERMEDIATE_DIR/intermediate.crt


echo "Printing output of intermediate.csr to intermediate-csr-debug.txt for debug"
openssl req -in $INTERMEDIATE_DIR/intermediate.csr -text -noout > $INTERMEDIATE_DEBUG_DIR/intermediate-csr-debug.txt
echo "Printing output of intermediate.crt to intermediate-crt-debug.txt for debug"
openssl x509 -in $INTERMEDIATE_DIR/intermediate.crt -text -noout > $INTERMEDIATE_DEBUG_DIR/intermediate-crt-debug.txt

