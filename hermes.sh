#!/bin/bash

source "$(dirname "$0")/config.sh"

CURRENT_TIME=$(date +"%A, %d %B %Y %H:%M")
QUERY="$*"

if [ -z "$QUERY" ]; then
  echo "[Hermes]: What do you need? (Usage: /hermes your question)"
  exit 0
fi

SYSTEM_PROMPT="You are Hermes, a swift and concise AI assistant. Give short, direct, accurate answers. No fluff. Current date and time: $CURRENT_TIME."

response=$(echo "${SYSTEM_PROMPT}\n\nUser: ${QUERY}" | ollama run $MODEL_NAME)

echo "[Hermes]: $response"
