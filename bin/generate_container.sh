#!/bin/bash

# Check if arguments were provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <project name> <container name> <port prefix -1,2,..,5->"
    exit 1
fi

# Local files to copy
SOURCE_DIR="$(pwd)/scripts/root"
CONFIG_FILE="config.txt"

# Assign arguments to variables
PROJECT_NAME=$1
CONTAINER_NAME=$2
PORTS_PREFIX=$3

# Check if the image.txt file exists
if [ ! -f "image.txt" ]; then
  echo "image.txt file not found."
  exit 1
fi

# Read the image name from the file
IMAGE_NAME=$(grep "IMAGE_NAME" image.txt | cut -d '=' -f 2 | xargs)

# Check if the image already exists
if ! docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "^${IMAGE_NAME}:latest$"; then
  echo "The image '${IMAGE_NAME}:latest' does not exist. Cancelling generation."
  exit 1
fi

# Set the container directory
BASE_DIR="$HOME/docker/$PROJECT_NAME-$CONTAINER_NAME"
HOME_DIR="$BASE_DIR/home"

# Create base and home directories if they don't exist
if [ ! -d "$BASE_DIR" ]; then
  echo "Creating directory: $BASE_DIR"
  mkdir "$BASE_DIR"
fi
if [ ! -d "$HOME_DIR" ]; then
  echo "Creating directory: $HOME_DIR"
  mkdir "$HOME_DIR"
fi

# Move to the container directory
cd "$BASE_DIR" || exit 1

# Check if the file exists, and if it does, rename it
if [ -f "$CONFIG_FILE" ]; then
  # Rename the config.txt file to config.bak before regenerating it
  echo "Renaming the file $CONFIG_FILE to $CONFIG_FILE.bak..."
  mv "$CONFIG_FILE" "$CONFIG_FILE.bak"
fi

# Create the config.txt file
echo "Generating configuration file: $CONFIG_FILE"
cat > "$CONFIG_FILE" <<EOL
IMAGE_NAME=$IMAGE_NAME
CONTAINER_NAME=$PROJECT_NAME-$CONTAINER_NAME
PORTS_PREFIX=$PORTS_PREFIX
EOL

# Generate the docker-compose.yml file
echo "Executing generate_compose.sh from $BASE_DIR"
generate_compose.sh

# Move to the root directory
cd "$HOME_DIR" || exit 1

FILES_TO_COPY=($(find "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -printf "%P\n"))

# Copy the files to the container only if they do not already exist in the destination directory
for file in "${FILES_TO_COPY[@]}"; do

  # Check if the file already exists in the container
  if [ ! -f "$file" ]; then
    echo "Copying $file to $HOME_DIR..."
    cp "$SOURCE_DIR/$file" "."  # Add quotes for paths with spaces
  else
    echo "The file $file already exists in $HOME_DIR. It will not be copied."
  fi

done

echo "Container generation completed."
