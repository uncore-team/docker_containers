#!/bin/bash

CONFIG_FILE="config.txt"

# Check if the config.txt file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: config.txt file not found."
    exit 1
fi

# Read the container name and other parameters from config.txt
CONTAINER_NAME=$(grep "CONTAINER_NAME" config.txt | cut -d '=' -f 2 | xargs)
PORTS_PREFIX=$(grep "PORTS_PREFIX" config.txt | cut -d '=' -f 2 | xargs)

# Check that the variables exist in config.txt
if [ -z "$CONTAINER_NAME" ]; then
    echo "Error: Could not retrieve the container name from config.txt."
    exit 1
fi

if [ -z "$PORTS_PREFIX" ]; then
    echo "Error: Could not retrieve the port prefix from config.txt."
    exit 1
fi

# Expected .tar file name
INPUT_FILE="$HOME/backup/${CONTAINER_NAME}_backup.tar"

# Verify if the backup file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

# Define the name of the new image
IMAGE_NAME="${CONTAINER_NAME}_recovered"

# Check if the image already exists
if docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "^${IMAGE_NAME}:latest$"; then
  echo "The image '${IMAGE_NAME}:latest' exists. Deleting it ..."

  # Get names of containers that depend on the image
  DEPENDENT_CONTAINERS=$(docker ps -a --filter "ancestor=${IMAGE_NAME}:latest" --format "{{.Names}}")

  if [ -n "$DEPENDENT_CONTAINERS" ]; then
    echo "Containers depending on this image were found:"
    echo "$DEPENDENT_CONTAINERS"
    echo "Press any key to stop and remove the containers, or Ctrl+C to cancel ..."
    read
#    echo

    # Stop and remove containers by name
    for CONTAINER in $DEPENDENT_CONTAINERS; do
      docker stop "$CONTAINER"
      docker rm "$CONTAINER"
    done
  else
    echo "No containers depend on this image."
  fi

  # Prompt for confirmation before deleting the image
  echo "Press any key to delete the image '${IMAGE_NAME}:latest' or Ctrl+C to cancel ..."
  read
#  echo

  echo "Deleting the image '${IMAGE_NAME}:latest'..."
  docker rmi "${IMAGE_NAME}:latest"
fi

# Load the image from the .tar file
echo "Loading the image '$IMAGE_NAME' from the file '$INPUT_FILE'..."
IMAGE_ID=$(docker import "$INPUT_FILE" "$IMAGE_NAME" | xargs)

if [ -z "$IMAGE_ID" ]; then
    echo "Error: Failed to load the image from '$INPUT_FILE'."
    exit 1
fi

# Rename the config.txt file to config.bak before regenerating it
echo "Renaming the file config.txt to config.bak..."
mv "$CONFIG_FILE" "${CONFIG_FILE}.bak"

# Create the new config.txt file
echo "Generating a new configuration file: $CONFIG_FILE"
cat > "$CONFIG_FILE" <<EOL
IMAGE_NAME=$IMAGE_NAME
CONTAINER_NAME=$CONTAINER_NAME
PORTS_PREFIX=$PORTS_PREFIX
EOL

# Create a new docker-compose.yml file
generate_compose.sh

# Start the container
play.sh
