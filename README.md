# Self-Signed-Certificate-Generator

This set of shell scripts can be used to create a CA for generating and signing self-signed certificates.



### Creating a local Certificate Authority for self-signed certificates
_____________________

If starting from a fresh install:
```
cd CertGeneration/CA
```

if Creating a CA:
```
sh GenCA.sh
```

If creating a new Intermediate certificate
```
sh GenCAIntermediate.sh
```

### Creating self-signed certificates using a defined CA
______________________

To create a self-signed certificate (after CA has been created):
```
cd CertGeneration/Servers
sh GenServerCert.sh [Server Name] [Server IP]
```
Replace [Server Name] with the name of the server. this is typically the first portion of a hostname url (e.i. www is one example)

Replace [Server IP] with the static IPv4 address associated with the server as assigned by the DHCP service.