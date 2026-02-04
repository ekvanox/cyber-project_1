#!/bin/bash

# Run Server Script
# This script compiles and runs the TLS server

echo "Compiling server and client..."
javac server.java client.java

echo ""
echo "Starting TLS server on port 9876..."
echo "Press Ctrl+C to stop the server."
echo ""

java server 9876