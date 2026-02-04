#!/bin/bash

# Computer Security Project 1: Certificate Setup Script
# This script creates all certificates, keystores, and truststores needed for the project
# Authors: Daniel Bjarke, Siere Herbert Heimdal, Vincent Lindell, Linus Sköld

set -e  # Exit on any error

echo "=========================================="
echo "Computer Security Project 1 Setup"
echo "=========================================="
echo ""

# Clean up old files (optional - comment out if you want to keep existing files)
echo "Cleaning up old files..."
rm -f ca-key.pem ca-cert.pem ca-cert.srl
rm -f client.csr client-cert.pem
rm -f server.csr server-cert.pem
rm -f clientkeystore clienttruststore
rm -f serverkeystore servertruststore
echo "Done cleaning up."
echo ""

# Step 1: Create CA Certificate
echo "Step 1: Creating CA certificate..."
openssl req -x509 -newkey rsa:2048 -keyout ca-key.pem -out ca-cert.pem -days 365 -nodes -subj "/CN=CA"
echo "CA certificate created: ca-cert.pem"
echo "CA private key created: ca-key.pem"
echo ""

# Step 2: Create Client Truststore
echo "Step 2: Creating client truststore..."
keytool -import -file ca-cert.pem -alias CARoot -keystore clienttruststore -storepass password -noprompt
echo "Client truststore created: clienttruststore"
echo ""

# Step 3: Create Client Keystore and Certificate
echo "Step 3: Creating client keystore and certificate..."

# 3a: Generate client keypair
echo "  3a: Generating client keypair..."
keytool -genkeypair -alias clientkey -keyalg RSA -keysize 2048 \
  -keystore clientkeystore -storepass password -keypass password \
  -dname "CN=Daniel Bjarke (da8830bj-s)/Siere Herbert Heimdal (er3387he-s)/Vincent Lindell (vi6458li-s)/Linus Sköld (li5207sk-s)"
echo "  Client keypair generated."

# 3b: Create CSR
echo "  3b: Creating certificate signing request..."
keytool -certreq -alias clientkey -file client.csr \
  -keystore clientkeystore -storepass password
echo "  CSR created: client.csr"

# 3c: Sign client certificate with CA
echo "  3c: Signing client certificate with CA..."
openssl x509 -req -in client.csr -CA ca-cert.pem -CAkey ca-key.pem \
  -CAcreateserial -out client-cert.pem -days 365
echo "  Client certificate signed: client-cert.pem"

# 3d: Import CA certificate into client keystore
echo "  3d: Importing CA certificate into client keystore..."
keytool -import -trustcacerts -alias CARoot -file ca-cert.pem \
  -keystore clientkeystore -storepass password -noprompt
echo "  CA certificate imported."

# 3e: Import signed client certificate
echo "  3e: Importing signed client certificate..."
keytool -import -trustcacerts -alias clientkey -file client-cert.pem \
  -keystore clientkeystore -storepass password -noprompt
echo "  Client certificate imported."
echo "Client keystore completed: clientkeystore"
echo ""

# Step 4: Create Server Keystore and Certificate
echo "Step 4: Creating server keystore and certificate..."

# 4a: Generate server keypair
echo "  4a: Generating server keypair..."
keytool -genkeypair -alias serverkey -keyalg RSA -keysize 2048 \
  -keystore serverkeystore -storepass password -keypass password \
  -dname "CN=MyServer"
echo "  Server keypair generated."

# 4b: Create CSR
echo "  4b: Creating certificate signing request..."
keytool -certreq -alias serverkey -file server.csr \
  -keystore serverkeystore -storepass password
echo "  CSR created: server.csr"

# 4c: Sign server certificate with CA
echo "  4c: Signing server certificate with CA..."
openssl x509 -req -in server.csr -CA ca-cert.pem -CAkey ca-key.pem \
  -CAcreateserial -out server-cert.pem -days 365
echo "  Server certificate signed: server-cert.pem"

# 4d: Import CA certificate into server keystore
echo "  4d: Importing CA certificate into server keystore..."
keytool -import -trustcacerts -alias CARoot -file ca-cert.pem \
  -keystore serverkeystore -storepass password -noprompt
echo "  CA certificate imported."

# 4e: Import signed server certificate
echo "  4e: Importing signed server certificate..."
keytool -import -trustcacerts -alias serverkey -file server-cert.pem \
  -keystore serverkeystore -storepass password -noprompt
echo "  Server certificate imported."
echo "Server keystore completed: serverkeystore"
echo ""

# Step 5: Create Server Truststore
echo "Step 5: Creating server truststore..."
keytool -import -file ca-cert.pem -alias CARoot -keystore servertruststore -storepass password -noprompt
echo "Server truststore created: servertruststore"
echo ""

# Verification
echo "=========================================="
echo "Verification"
echo "=========================================="
echo ""

echo "Client Keystore Contents:"
echo "-------------------------"
keytool -list -keystore clientkeystore -storepass password
echo ""

echo "Server Keystore Contents:"
echo "-------------------------"
keytool -list -keystore serverkeystore -storepass password
echo ""

echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Files created:"
echo "  - ca-key.pem (CA private key)"
echo "  - ca-cert.pem (CA certificate)"
echo "  - ca-cert.srl (CA serial number file)"
echo "  - client.csr (Client CSR)"
echo "  - client-cert.pem (Signed client certificate)"
echo "  - server.csr (Server CSR)"
echo "  - server-cert.pem (Signed server certificate)"
echo "  - clientkeystore (Client keystore)"
echo "  - clienttruststore (Client truststore)"
echo "  - serverkeystore (Server keystore)"
echo "  - servertruststore (Server truststore)"
echo ""
echo "All passwords are set to: password"
echo ""
echo "To test the TLS connection:"
echo "  1. Compile: javac server.java client.java"
echo "  2. Run server: java server 9876"
echo "  3. Run client (in another terminal): java client localhost 9876"
echo ""