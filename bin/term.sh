#!/bin/bash

# Check if the config.txt file exists
if [ ! -f "config.txt" ]; then
    echo "config.txt file not found."
    exit 1
fi

# Read the container name and port prefix from config.txt
CONTAINER_NAME=$(grep "CONTAINER_NAME" config.txt | cut -d '=' -f 2 | xargs)

# Check if the container is running
if docker ps | grep "$CONTAINER_NAME" &>/dev/null; then
    echo "Opening an interactive session with the container '${CONTAINER_NAME}'."

    # Start an interactive session in the container
    docker exec -it -w /root ${CONTAINER_NAME} /bin/bash
else
    echo "The container '${CONTAINER_NAME}' is not running."
    exit 1
fi
