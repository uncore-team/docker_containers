#!/bin/bash

# Check if the config.txt file exists
if [ ! -f "config.txt" ]; then
    echo "Error: config.txt file not found."
    exit 1
fi

# Read the container name from config.txt
CONTAINER_NAME=$(grep "^CONTAINER_NAME=" config.txt | cut -d '=' -f 2 | xargs)

# Validate that a container name was retrieved
if [ -z "$CONTAINER_NAME" ]; then
    echo "Error: Could not retrieve the container name from config.txt."
    exit 1
fi

# Check if the container exists
if ! docker ps --format "{{.Names}}" | grep -q "^$CONTAINER_NAME$" &>/dev/null; then
    echo "Error: The container '$CONTAINER_NAME' does not exist."
    exit 1
fi

# Verify the container's status
STATUS=$(docker inspect --format='{{.State.Status}}' $CONTAINER_NAME)

if [ "$STATUS" == "paused" ]; then
    echo "The container '$CONTAINER_NAME' is paused. Resuming..."
    docker unpause $CONTAINER_NAME
elif [ "$STATUS" == "running" ]; then
    echo "The container '$CONTAINER_NAME' is already running."
    exit 1
else
    echo "The container '$CONTAINER_NAME' is neither paused nor running (status: $STATUS)."
    exit 1
fi

docker ps
