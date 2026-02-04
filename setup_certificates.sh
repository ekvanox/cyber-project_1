#!/bin/bash

# Generates a CA plus client/server certs, keystores, and truststores.
# Overwrites existing files. All passwords are "password".

set -e

## Clean previous outputs
rm -f ca-key.pem ca-cert.pem ca-cert.srl
rm -f client.csr client-cert.pem
rm -f server.csr server-cert.pem
rm -f clientkeystore clienttruststore
rm -f serverkeystore servertruststore

## Create CA key + self-signed certificate
openssl req -x509 -newkey rsa:2048 -nodes -keyout ca-key.pem -out ca-cert.pem -subj "/CN=CA"

## Client truststore: trust the CA
keytool -import -file ca-cert.pem -alias CARoot -keystore clienttruststore -storepass password -noprompt

## Client keystore: generate keypair
keytool -genkeypair -alias clientkey -keyalg RSA -keysize 2048 \
  -keystore clientkeystore -storepass password -keypass password -dname "CN=client"
## Client CSR -> signed cert -> import CA and signed cert
keytool -certreq -alias clientkey -file client.csr -keystore clientkeystore -storepass password
openssl x509 -req -in client.csr -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem
keytool -import -trustcacerts -alias CARoot -file ca-cert.pem -keystore clientkeystore -storepass password -noprompt
keytool -import -trustcacerts -alias clientkey -file client-cert.pem -keystore clientkeystore -storepass password -noprompt

## Server keystore: generate keypair
keytool -genkeypair -alias serverkey -keyalg RSA -keysize 2048 \
  -keystore serverkeystore -storepass password -keypass password -dname "CN=server"
## Server CSR -> signed cert -> import CA and signed cert
keytool -certreq -alias serverkey -file server.csr -keystore serverkeystore -storepass password
openssl x509 -req -in server.csr -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem
keytool -import -trustcacerts -alias CARoot -file ca-cert.pem -keystore serverkeystore -storepass password -noprompt
keytool -import -trustcacerts -alias serverkey -file server-cert.pem -keystore serverkeystore -storepass password -noprompt

## Server truststore: trust the CA
keytool -import -file ca-cert.pem -alias CARoot -keystore servertruststore -storepass password -noprompt