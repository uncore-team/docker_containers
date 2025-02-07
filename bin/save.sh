#!/bin/bash

# Check if the config.txt file exists
if [ ! -f "config.txt" ]; then
    echo "Error: config.txt file not found."
    exit 1
fi

# Read the container name from config.txt
CONTAINER_NAME=$(grep "CONTAINER_NAME" config.txt | cut -d '=' -f 2 | xargs)

# Validate that a container name was retrieved
if [ -z "$CONTAINER_NAME" ]; then
    echo "Error: Could not retrieve the container name from config.txt."
    exit 1
fi

# Confirm that the container is running
if ! docker ps --format "{{.Names}}" | grep -q "^$CONTAINER_NAME$"; then
    echo "Error: The container '$CONTAINER_NAME' is not running."
    exit 1
fi

# Pause the container if it is running
STATUS=$(docker inspect --format='{{.State.Status}}' $CONTAINER_NAME)

if [ "$STATUS" == "paused" ]; then
    echo "The container '$CONTAINER_NAME' is already paused."
else
    echo "Pausing the container '$CONTAINER_NAME'..."
    docker pause $CONTAINER_NAME
fi

# Save the container to a .tar file
OUTPUT_FILE="$HOME/backup/${CONTAINER_NAME}_backup.tar"

echo "Saving the container '$CONTAINER_NAME' to the file '$OUTPUT_FILE'..."
docker export "$CONTAINER_NAME" > "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "The container '$CONTAINER_NAME' was successfully saved to '$OUTPUT_FILE'."
else
    echo "Error: Could not save the container '$CONTAINER_NAME'."
    exit 1
fi
