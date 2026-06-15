#!/bin/bash

source ./config.sh

check_ollama

mkdir -p $LOG_DIR

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOGFILE="$LOG_DIR/chat_$TIMESTAMP.txt"
MEMORY_FILE="./memory.txt"

show_menu() {
  echo ""
  echo "==============================="
  echo "        ODYSSEUS MENU          "
  echo "==============================="
  echo " 1) Start Chat"
  echo " 2) Send a File"
  echo " 3) Run Batch File"
  echo " 4) Inject a Prompt"
  echo " 5) Switch Model"
  echo " 6) Exit"
  echo "==============================="
  read -p "Choose an option: " choice
  case "$choice" in
    1) bash "$0" --chat ;;
    2) read -p "File path: " f; bash "$0" --file "$f" ;;
    3) read -p "Batch file path: " f; bash "$0" --batch "$f" ;;
    4) read -p "Prompt: " p; bash "$0" --inject "$p" ;;
    5) read -p "Model name: " m; bash "$0" --model "$m" ;;
    6) echo "Goodbye!"; exit 0 ;;
    *) echo "Invalid option." ;;
  esac
}

case "$1" in
  --chat)
    echo "Chat started: $TIMESTAMP" > $LOGFILE
    MEMORY=""
    if [ -f "$MEMORY_FILE" ]; then
      MEMORY=$(cat "$MEMORY_FILE")
    fi
    CURRENT_TIME=$(date +"%A, %d %B %Y %H:%M"); HISTORY="You are $AGENT_NAME, a helpful AI assistant. The current date and time is $CURRENT_TIME.\n${MEMORY}\n"
    while true; do
      read -p "You: " input
      if [ "$input" = "/bye" ]; then
        echo "Chat ended." >> $LOGFILE
        break
      fi
      if [[ "$input" == /remember* ]]; then
        mem="${input#/remember }"
        echo "$mem" >> "$MEMORY_FILE"
        echo "Remembered: $mem"
        continue
      fi
      echo "You: $input" >> $LOGFILE
      HISTORY="${HISTORY}User: ${input}\n"
      response=$(printf "$HISTORY" | ollama run $MODEL_NAME)
      HISTORY="${HISTORY}Assistant: ${response}\n"
      echo "$response"
      echo "AI: $response" >> $LOGFILE
    done
    ;;
  --file)
    if [ -z "$2" ]; then
      echo "Error: No file specified."
      exit 1
    fi
    if [ ! -f "$2" ]; then
      echo "Error: File not found: $2"
      exit 1
    fi
    echo "Reading file: $2"
    input=$(cat "$2")
    response=$(echo "$input" | ollama run $MODEL_NAME)
    echo "$response"
    echo "File: $2" >> $LOGFILE
    echo "AI: $response" >> $LOGFILE
    ;;
  --batch)
    if [ -z "$2" ]; then
      echo "Error: No batch file specified."
      exit 1
    fi
    if [ ! -f "$2" ]; then
      echo "Error: File not found: $2"
      exit 1
    fi
    echo "Running batch: $2"
    while IFS= read -r line; do
      echo "Prompt: $line"
      response=$(echo "$line" | ollama run $MODEL_NAME)
      echo "AI: $response"
      echo "Prompt: $line" >> $LOGFILE
      echo "AI: $response" >> $LOGFILE
    done < "$2"
    ;;
  --inject)
    if [ -z "$2" ]; then
      echo "Error: No prompt specified."
      exit 1
    fi
    echo "Injecting prompt..."
    response=$(echo "$2" | ollama run $MODEL_NAME)
    echo "$response"
    echo "Injected: $2" >> $LOGFILE
    echo "AI: $response" >> $LOGFILE
    ;;
  --model)
    if [ -z "$2" ]; then
      echo "Available models:"
      ollama list
    else
      MODEL_NAME="$2"
      echo "Model switched to: $MODEL_NAME"
    fi
    ;;
  --menu)
    show_menu
    ;;
  *)
    echo "Usage: ./odysseus.sh --chat"
    echo "       ./odysseus.sh --file <filename>"
    echo "       ./odysseus.sh --batch <filename>"
    echo "       ./odysseus.sh --inject <prompt>"
    echo "       ./odysseus.sh --model <modelname>"
    echo "       ./odysseus.sh --menu"
    ;;
esac