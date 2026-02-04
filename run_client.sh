#!/bin/bash

# Run Client Script
# This script runs the TLS client

echo "Starting TLS client connecting to localhost:9876..."
echo ""
echo "Type messages to send to the server."
echo "The server will respond with the message reversed."
echo "Type 'quit' to exit."
echo ""

java client localhost 9876