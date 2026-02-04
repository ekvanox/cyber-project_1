# TLS Setup Scripts

Minimal scripts to generate a CA plus client/server certificates and run the TLS demo.

## Quick start

```bash
./setup_certificates.sh
./run_server.sh
./run_client.sh
```

## Defaults

- Password for all keystores: `password`
- Host/port: `localhost:9876`
- Certificate CNs: `CA`, `client`, `server`
- Re-running `setup_certificates.sh` overwrites existing files

## Files created

- `ca-key.pem`, `ca-cert.pem`, `ca-cert.srl`
- `client.csr`, `client-cert.pem`, `clientkeystore`, `clienttruststore`
- `server.csr`, `server-cert.pem`, `serverkeystore`, `servertruststore`

## Requirements

- Java (for `keytool` and `javac`)
- OpenSSL