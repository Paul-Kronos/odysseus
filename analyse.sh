#!/bin/bash

source "$(dirname "$0")/config.sh"

CURRENT_TIME=$(date +"%A, %d %B %Y %H:%M")

if [ "$#" -lt 1 ]; then
  echo "Usage: ./odysseus.sh --analyse <file1> <file2> ..."
  exit 1
fi

COMBINED=""
for f in "$@"; do
  if [ ! -f "$f" ]; then
    echo "Error: File not found: $f"
    exit 1
  fi
  echo "Loading: $f"
  COMBINED="${COMBINED}\n\n--- FILE: $f ---\n$(cat "$f")"
done

SYSTEM_PROMPT="You are Athena, a critical analytical AI. The current date and time is $CURRENT_TIME. Analyse the following documents thoroughly. Cross-reference information, identify patterns, contradictions and key insights. Be honest and direct."

response=$(printf "${SYSTEM_PROMPT}\n${COMBINED}" | ollama run $MODEL_NAME)

echo ""
echo "[Athena Analysis]:"
echo "$response"
