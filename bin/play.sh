#!/bin/bash

# Check if the config.txt file exists
if [ ! -f "config.txt" ]; then
  echo "config.txt file not found."
  exit 1
fi

# Read the container name and port prefix from config.txt
CONTAINER_NAME=$(grep "CONTAINER_NAME" config.txt | cut -d '=' -f 2 | xargs)

# Check if the container is running
if ! docker ps | grep "$CONTAINER_NAME" &>/dev/null; then
  echo "The container '$CONTAINER_NAME' is not running. Starting the container..."
  docker compose up -d # detached
else
  echo "The container '$CONTAINER_NAME' is already running."
fi

# Confirm that the container is running
echo "Checking active containers..."
docker ps
