# Certificate Authority Generation Scripts

A collection of shell scripts to create a self-signed root CA, intermediate, and server/client certificates.

## Simple Scripts
These scripts provide an easy to use method for generating a simple Certificate Authority.  CA generated using this method will not have any methods for tracking revoced certificates.  
### **Scripts**
- ```GenerateRootCA.sh <ca-name>``` can be used to generate a self-signed Root CA certificate.
    - ```GenerateIntermediate.sh <intermediate-name>``` generates an intermediate certificate.  Automatically copied to CA directory and executed when GenerateRootCA.sh is executed.
    - ```GenerateServers.sh [server-names]``` generates a series of server certificates. Generated inside the directory of the Intermediate certificate.
