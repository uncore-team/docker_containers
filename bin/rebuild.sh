#!/bin/bash

# Check if the image.txt file exists
if [ ! -f "image.txt" ]; then
  echo "image.txt file not found."
  exit 1
fi

# Read the image name from the file
IMAGE_NAME=$(grep "IMAGE_NAME" image.txt | cut -d '=' -f 2 | xargs)

# Check if the image already exists
if docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "^${IMAGE_NAME}:latest$"; then
  echo "The image '${IMAGE_NAME}:latest' exists. Deleting it..."

  # Get the names of containers that depend on the image
  DEPENDENT_CONTAINERS=$(docker ps -a --filter "ancestor=${IMAGE_NAME}:latest" --format "{{.Names}}")

  if [ -n "$DEPENDENT_CONTAINERS" ]; then
    echo "Containers depending on this image were found:"
    echo "$DEPENDENT_CONTAINERS"
    echo "Press any key to stop and remove the containers, or Ctrl+C to cancel..."
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
  echo "Press any key to delete the image '${IMAGE_NAME}:latest' or Ctrl+C to cancel..."
  read
#  echo

  echo "Deleting the image '${IMAGE_NAME}:latest'..."
  docker rmi "${IMAGE_NAME}:latest"
fi

# Build the new image
echo "Building the new image '${IMAGE_NAME}:latest'..."
docker build -t "${IMAGE_NAME}:latest" .

# List images
docker image list
