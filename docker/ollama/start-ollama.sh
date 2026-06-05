#!/bin/sh
set -eu

/bin/sh /install-certs.sh
exec ollama serve
