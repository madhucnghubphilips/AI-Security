#!/bin/sh
set -eu

echo "Preparing Ollama models..."

/bin/sh /install-certs.sh

PULL_FLAGS=""
if [ "${OLLAMA_PULL_INSECURE:-false}" = "true" ]; then
  echo "Using insecure Ollama model pulls. TLS certificate verification is bypassed for registry downloads."
  PULL_FLAGS="--insecure"
fi

ollama pull $PULL_FLAGS dolphin-mistral
ollama create dolphin-ctf -f /models/Modelfile-ctf
ollama pull $PULL_FLAGS nomic-embed-text
ollama pull $PULL_FLAGS llama3.1

echo "Ollama models are ready."
