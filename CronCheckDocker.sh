#!/bin/bash

# Define image name
IMAGE_NAME="acme:v4.1.2"

# Check if container is running based on image name
if ! docker ps --format '{{.Image}}' | grep -q "^${IMAGE_NAME}\$"; then
  # Start container based on image name
  sudo docker run -p 80:80 -v /path acme:v4.1.2
else
  echo "${IMAGE_NAME} container is already running"
fi
