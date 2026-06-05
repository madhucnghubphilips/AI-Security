#!/bin/sh
set -eu

CERT_DIR="${EXTRA_CA_CERTS_DIR:-/extra-certs}"
DEST_DIR="/usr/local/share/ca-certificates"
IMPORTED=0

if [ ! -d "$CERT_DIR" ]; then
  exit 0
fi

for cert in "$CERT_DIR"/*.crt; do
  if [ ! -f "$cert" ]; then
    continue
  fi

  echo "Installing extra CA certificate: $(basename "$cert")"
  cp "$cert" "$DEST_DIR/$(basename "$cert")"
  IMPORTED=1
done

if [ "$IMPORTED" -eq 1 ]; then
  update-ca-certificates
fi
