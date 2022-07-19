# root
openssl req -new -nodes -text -out root.csr \
  -keyout root.key -subj "/C=US/ST=Washington/L=Pullman/O=BRGaull Development/OU=IT/CN=root.yourdomain.com"
chmod og-rwx root.key
openssl req -text -noout -verify -in root.csr | grep verify
openssl x509 -req -in root.csr -text -days 3650 \
  -extfile /etc/ssl/openssl.cnf -extensions v3_ca \
  -signkey root.key -out root.crt

# intermediate
openssl req -new -nodes -text -out intermediate.csr \
  -keyout intermediate.key -subj "/C=US/ST=Washington/L=Pullman/O=BRGaull Development/OU=IT/CN=intermediate.yourdomain.com"
chmod og-rwx intermediate.key
openssl req -text -noout -verify -in intermediate.csr | grep verify
openssl x509 -req -in intermediate.csr -text -days 1825 \
  -extfile /etc/ssl/openssl.cnf -extensions v3_ca \
  -CA root.crt -CAkey root.key -CAcreateserial \
  -out intermediate.crt

# leaf
openssl req -new -nodes -text -out server.csr \
  -keyout server.key -subj "/C=US/ST=Washington/L=Pullman/O=BRGaull Development/OU=IT/CN=dbhost.yourdomain.com"
chmod og-rwx server.key
openssl req -text -noout -verify -in server.csr | grep verify
openssl x509 -req -in server.csr -text -days 365 \
  -extfile /etc/ssl/openssl.cnf -extensions v3_req \
  -CA intermediate.crt -CAkey intermediate.key -CAcreateserial \
  -out server.crt


# check certs:
echo 'root.crt:'
openssl x509 -in root.crt -text -noout
echo 'intermediate.crt'
openssl x509 -in intermediate.crt -text -noout
echo 'server.crt'
openssl x509 -in server.crt -text -noout
