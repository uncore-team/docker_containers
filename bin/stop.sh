#!/bin/bash

# Check if the config.txt file exists
if [ ! -f "config.txt" ]; then
    echo "Error: config.txt file not found."
    exit 1
fi

# Read the container name from config.txt
CONTAINER_NAME=$(grep "^CONTAINER_NAME=" config.txt | cut -d '=' -f 2 | xargs)

# Validate that a container name was obtained
if [ -z "$CONTAINER_NAME" ]; then
    echo "Error: Could not retrieve the container name from config.txt."
    exit 1
fi

# Check if the container is already stopped
if ! docker ps --format "{{.Names}}" | grep -q "^$CONTAINER_NAME$"; then
    echo "The container '$CONTAINER_NAME' is already stopped."
    exit 1
fi

# Verify the container's status
STATUS=$(docker inspect --format='{{.State.Status}}' "$CONTAINER_NAME")

if [ "$STATUS" == "paused" ]; then
    echo "The container '$CONTAINER_NAME' is paused. Resuming..."
    docker unpause "$CONTAINER_NAME"
fi

# Attempt to stop services within the container using /stop.sh
if docker exec -it "$CONTAINER_NAME" /stop.sh; then
    echo "Services stopped successfully in the container '$CONTAINER_NAME'."
else
    echo "Warning: Could not execute /stop.sh in the container '$CONTAINER_NAME'. Please check the container manually."
fi

# Stop and remove services defined in docker-compose
echo "Shutting down and removing the container '$CONTAINER_NAME' using docker-compose..."
if docker compose down; then
    echo "The container '$CONTAINER_NAME' has been successfully stopped and removed."
else
    echo "Error: There was an issue shutting down/removing the container '$CONTAINER_NAME'."
    exit 1
fi

# Confirm that the container is no longer active
if docker ps --format "{{.Names}}" | grep -q "^$CONTAINER_NAME$"; then
    echo "Error: The container '$CONTAINER_NAME' is still running. Please check manually."
    exit 1
else
    echo "The container '$CONTAINER_NAME' has been successfully stopped."
fi

# Display the current list of containers (active and inactive)
docker ps -a
