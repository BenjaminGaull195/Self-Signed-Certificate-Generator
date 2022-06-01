# Enter Root CA dir
cd GaullDevelopmentCA

# Initialize Intermediate CA directory
mkdir subca
cd subca
mkdir certs db private
touch db/index
openssl rand -hex 16 > db/serial
echo 1001 > db/crlnumber

cp ../../subca.conf subca.conf

# Register new Sub CA serial in Root CA 
openssl rand -hex 16 > ../rootca/db/serial



# Generate key and csr for Sub CA
openssl req -new -config subca.conf -out subca.csr -keyout private/subca.key

# Generate Sub CA crt
openssl ca -config ../rootca/rootca.conf -in subca.csr -out subca.crt -extensions sub_ca_ext





