#!/bin/bash

if [ $# -eq 0 ]
    then 
        echo "pass arguments [server name] [ip] as a repeating pattern"
        exit 1
fi

while test ${#} -gt 0
do
  server=$1
  shift
  ip=$1
  shift
  sh GenServerCert.sh $server $ip
done



<<COMMENTS
# Gen BeautifulLadies cert
sh GenServerCert.sh beautifulladies 196.160.100.10

# Gen BeautifulLadiesDB cert
sh GenServerCert.sh beautifulladiesdb 196.160.100.11

# Gen BeautifulLadies cert
sh GenServerCert.sh beautifulladies3 196.160.100.12

# Gen BeautifulLadies cert
sh GenServerCert.sh beautifulladies4 196.160.100.13

# Gen BeautifulLadies cert
sh GenServerCert.sh beautifulladies5 196.160.100.14

# Gen BeautifulLadies cert
sh GenServerCert.sh beautifulladies6 196.160.100.15
COMMENTS