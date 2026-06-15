#!/bin/bash

source "$(dirname "$0")/config.sh"

CURRENT_TIME=$(date +"%A, %d %B %Y %H:%M")
QUERY="$*"

if [ -z "$QUERY" ]; then
  echo "[Athena]: How can I assist? (Usage: /athena your question)"
  exit 0
fi

SYSTEM_PROMPT="You are Athena, a deeply analytical AI assistant. Think carefully, reason thoroughly, and give detailed, well-structured answers. Current date and time: $CURRENT_TIME."

response=$(echo "${SYSTEM_PROMPT}\n\nUser: ${QUERY}" | ollama run $MODEL_NAME)

echo "[Athena]: $response"
