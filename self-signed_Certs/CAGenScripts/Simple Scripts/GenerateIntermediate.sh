#!/bin/bash

mkdir $1
mkdir $1/servers

# intermediate
openssl req -new -nodes -text -out intermediate.csr \
  -keyout $1/intermediate.key -subj "/C=US/ST=Washington/L=Pullman/O=BRGaull Development/OU=IT/CN=intermediate.yourdomain.com"
chmod og-rwx $1/intermediate.key
openssl req -text -noout -verify -in intermediate.csr | grep verify
openssl x509 -req -in intermediate.csr -text -days 1825 \
  -extfile /etc/ssl/openssl.cnf -extensions v3_ca \
  -CA root.crt -CAkey root.key -CAcreateserial \
  -out $1/intermediate.crt

# check certs:
echo "$1/intermediate.crt:"
openssl x509 -in $1/intermediate.crt -text -noout

rm intermediate.csr


echo '#!/bin/bash

for i in $@
do
    mkdir servers/$i

    # leaf
    openssl req -new -nodes -text -out $i-server.csr \
      -keyout servers/$i/$i-server.key -subj "/C=US/ST=Washington/L=Pullman/O=BRGaull Development/OU=IT/CN=$i.yourdomain.com"
    chmod og-rwx servers/$i/$i-server.key
    openssl req -text -noout -verify -in $i-server.csr | grep verify
    openssl x509 -req -in $i-server.csr -text -days 365 \
      -extfile /etc/ssl/openssl.cnf -extensions v3_req \
      -CA intermediate.crt -CAkey intermediate.key -CAcreateserial \
      -out servers/$i/$i-server.crt
    
    # check certs:
    echo "servers/$i/$i-server.crt:"
    openssl x509 -in servers/$i/$i-server.crt -text -noout

    rm $i-server.csr

done
' >> $1/GenerateServers.sh
chmod +x $1/GenerateServers.sh