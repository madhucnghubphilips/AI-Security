#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker was not found. Install Docker Desktop or Docker Engine first."
  exit 1
fi

if docker compose version >/dev/null 2>&1; then
  COMPOSE=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE=(docker-compose)
else
  echo "Docker Compose was not found. Install Docker Compose first."
  exit 1
fi

print_urls() {
  cat <<'EOF'

Apps:
  LLM01 Prompt Injection                  http://localhost:8501
  LLM02 Sensitive Information Disclosure  http://localhost:8502
  LLM03 Supply Chain Kontra Style         http://localhost:8503
  LLM04 Data and Model Poisoning          http://localhost:8504
  LLM05 Improper Output Handling          http://localhost:8505
  LLM06 Excessive Agency                  http://localhost:8506
  LLM07 System Prompt Leakage             http://localhost:8507
  LLM08 Vector and Embedding Weaknesses   http://localhost:8508
  LLM09 Misinformation                    http://localhost:8509
  LLM10 Unbounded Consumption             http://localhost:8510
  RAG Chatbot                             http://localhost:8000
  Ollama API                              http://localhost:11434

First run note:
  Ollama model downloads can take several minutes.
  Keep this terminal open while the apps are running.

EOF
}

usage() {
  cat <<'EOF'
Usage:
  ./start_all.sh          Build and start everything
  ./start_all.sh up       Build and start everything
  ./start_all.sh build    Build Docker images only
  ./start_all.sh down     Stop containers
  ./start_all.sh logs     Show container logs
  ./start_all.sh status   Show container status
EOF
}

case "${1:-up}" in
  up|start)
    "${COMPOSE[@]}" config --quiet
    print_urls
    "${COMPOSE[@]}" up --build
    ;;
  build)
    "${COMPOSE[@]}" config --quiet
    "${COMPOSE[@]}" build
    ;;
  down|stop)
    "${COMPOSE[@]}" down
    ;;
  logs)
    "${COMPOSE[@]}" logs
    ;;
  status|ps)
    "${COMPOSE[@]}" ps
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    usage
    exit 1
    ;;
esac
