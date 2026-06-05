#!/bin/sh
set -eu

CERT_DIR="${EXTRA_CA_CERTS_DIR:-/extra-certs}"
DEST_DIR="/usr/local/share/ca-certificates"
IMPORTED=0

if [ ! -d "$CERT_DIR" ]; then
  exit 0
fi

install_cert() {
  cert="$1"
  if [ ! -f "$cert" ]; then
    return 0
  fi

  echo "Installing extra CA certificate: $(basename "$cert")"
  dest="$DEST_DIR/$(basename "$cert" .cer).crt"

  if grep -q "BEGIN CERTIFICATE" "$cert"; then
    cp "$cert" "$dest"
  else
    openssl x509 -inform DER -in "$cert" -out "$dest"
  fi

  IMPORTED=1
}

for cert in "$CERT_DIR"/*.crt; do
  install_cert "$cert"
done

for cert in "$CERT_DIR"/*.cer; do
  install_cert "$cert"
done

if [ "$IMPORTED" -eq 1 ]; then
  update-ca-certificates
else
  echo "No extra CA certificates found in $CERT_DIR. Add corporate CA .crt files there if model pulls fail with x509 errors."
fi
