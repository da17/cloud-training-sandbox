#!/usr/bin/env bash
echo "==> Downloading and mounting official Amazon AWS CLI..."
curl "https://amazonaws.com" -o "awscliv2.zip"
unzip -q awscliv2.zip && sudo ./aws/install && rm -rf aws awscliv2.zip
