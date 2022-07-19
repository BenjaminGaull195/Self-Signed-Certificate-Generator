#!/bin/bash
#CADir=${1}



# Initialize Root CA directory
mkdir GaullDevelopmentCA
cd GaullDevelopmentCA
mkdir certs db private
touch db/index
openssl rand -hex 16 > db/serial
echo 1001 > db/crlnumber

cp ../rootca.conf rootca.conf

pwd

read key

# Generate key and csr for Root CA
openssl req -new -config rootca.conf -out GaullDevelopmentCA.csr -keyout private/GaullDevelopmentCA.key

# Generate Root CA crt
openssl ca -selfsign -config rootca.conf -in GaullDevelopmentCA.csr -out GaullDevelopmentCA.crt -extensions ca_ext



