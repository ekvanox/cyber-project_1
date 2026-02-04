# Computer Security Project 1 - Setup Scripts

This directory contains scripts to set up and test the TLS connection for Project 1.

## Files

- `setup_certificates.sh` - Main setup script that creates all certificates and keystores
- `run_server.sh` - Helper script to compile and run the TLS server
- `run_client.sh` - Helper script to run the TLS client
- `README.md` - This file

## Usage

### Initial Setup

To create all certificates, keystores, and truststores from scratch:

```bash
./setup_certificates.sh
```

This will:
1. Clean up any old files
2. Create a Certificate Authority (CA)
3. Generate client and server certificates
4. Create all necessary keystores and truststores
5. Verify the setup

All passwords are set to: `password`

### Testing the TLS Connection

#### Terminal 1 (Server):
```bash
./run_server.sh
```

This will compile both server.java and client.java, then start the server on port 9876.

#### Terminal 2 (Client):
```bash
./run_client.sh
```

This will connect to the server at localhost:9876.

Type messages to send to the server. The server will respond with your message reversed.
Type `quit` to disconnect.

### Manual Compilation and Execution

If you prefer to run the commands manually:

```bash
# Compile
javac server.java client.java

# Run server (in one terminal)
java server 9876

# Run client (in another terminal)
java client localhost 9876
```

## Files Created by setup_certificates.sh

After running the setup script, you will have:

**Certificate Authority:**
- `ca-key.pem` - CA private key
- `ca-cert.pem` - CA certificate
- `ca-cert.srl` - Serial number file

**Client Files:**
- `client.csr` - Certificate Signing Request
- `client-cert.pem` - Signed certificate
- `clientkeystore` - Contains client private key and certificate chain
- `clienttruststore` - Contains CA certificate for verifying server

**Server Files:**
- `server.csr` - Certificate Signing Request
- `server-cert.pem` - Signed certificate
- `serverkeystore` - Contains server private key and certificate chain
- `servertruststore` - Contains CA certificate for verifying client

## Verification

To verify the contents of a keystore:

```bash
keytool -list -v -keystore clientkeystore -storepass password
keytool -list -v -keystore serverkeystore -storepass password
```

Each keystore should contain:
1. A CA certificate entry
2. A certificate chain of length 2 (signed cert + CA cert)

## Certificate Details

**CA Certificate:**
- CN=CA
- Self-signed
- Valid for 365 days

**Client Certificate:**
- CN=Daniel Bjarke (da8830bj-s)/Siere Herbert Heimdal (er3387he-s)/Vincent Lindell (vi6458li-s)/Linus Sköld (li5207sk-s)
- Signed by CA
- Valid for 365 days

**Server Certificate:**
- CN=MyServer
- Signed by CA
- Valid for 365 days

## Troubleshooting

**Problem:** "keytool: command not found"
- Make sure Java JDK is installed
- On macOS: `brew install openjdk`

**Problem:** "openssl: command not found"
- On macOS: OpenSSL should be pre-installed
- On Linux: `sudo apt-get install openssl`

**Problem:** Certificate chain not established
- Make sure you use the same alias when generating and importing certificates
- The `-trustcacerts` flag is important when importing
- Import the CA certificate BEFORE importing the signed certificate

**Problem:** "javax.net.ssl.SSLHandshakeException"
- Verify that all keystores and truststores contain the correct certificates
- Check that passwords are set to "password"
- Make sure the certificate chain is properly established

## Notes

- All certificates are valid for 365 days from creation
- The setup script will delete any existing certificates/keystores before creating new ones
- Comment out the cleanup section in setup_certificates.sh if you want to keep existing files
- These files are for educational purposes only and should not be used in production

## Project Information

**Course:** Computer Security (EITA25)  
**Project:** Project 1 - Digital Certificates  
**Group Members:**
- Daniel Bjarke (da8830bj-s)
- Siere Herbert Heimdal (er3387he-s)
- Vincent Lindell (vi6458li-s)
- Linus Sköld (li5207sk-s)