#!/bash

# server
mkdir $1
mkdir $1/cert
SERVER_NAME=$1
SERVER_IP=$2

cp Template/server-config-template.cnf $1/$1-config.cnf
cp Template/server-template-v3.ext $1/$1-v3.ext
sed -i "s/server-template/${SERVER_NAME}/g" $1/$1-config.cnf
sed -i "s/server-template/${SERVER_NAME}/g" $1/$1-v3.ext
sed -i "s/192.168.0.100/${SERVER_IP}/g" $1/$1-v3.ext

openssl req -new -nodes -text -sha256 -out $1/server.csr \
  -keyout $1/cert/$1-server.key -config $1/$1-config.cnf
chmod og-rwx $1/cert/server.key
openssl x509 -req -in $1/server.csr -text -sha256 -days 365 \
  -CA ../CA/CA/Intermediate/intermediate.crt -CAkey ../CA/CA/Intermediate/intermediate.key -CAcreateserial \
  -extfile $1/$1-v3.ext -out $1/cert/$1-server.crt 
