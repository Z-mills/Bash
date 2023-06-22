#!/bin/bash

# Get a list of all running Docker containers
CONTAINERS=$(docker ps --format '{{.Names}}')

# Loop through each container
for CONTAINER in ${CONTAINERS}; do
  # Get the container ID
  CONTAINER_ID=$(docker ps --filter "name=${CONTAINER}" --format "{{.ID}}")

  # Get the TCP ports that the container is using
  TCP_PORTS=$(docker port ${CONTAINER_ID} | grep tcp | awk '{print $3}' | cut -d'-' -f1)

  # Get the UDP ports that the container is using
  UDP_PORTS=$(docker port ${CONTAINER_ID} | grep udp | awk '{print $3}' | cut -d'-' -f1)

  # Print the container name and ports
  echo "Container ${CONTAINER} is using TCP ports: ${TCP_PORTS}"
  echo "Container ${CONTAINER} is using UDP ports: ${UDP_PORTS}"
done
