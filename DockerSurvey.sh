#!/bin/bash

# Get a list of all running Docker containers
CONTAINERS=$(docker ps --format '{{.Names}}')

# Loop through each container
for CONTAINER in ${CONTAINERS}; do
  # Get the container ID
  CONTAINER_ID=$(docker ps --filter "name=${CONTAINER}" --format "{{.ID}}")

  # Check if the container is configured to log to the host
  echo "Checking if container logs are being sent to host for container ${CONTAINER_ID}..."
  LOG_DRIVER=$(docker inspect --format '{{.HostConfig.LogConfig.Type}}' $CONTAINER_ID)
  if [[ "$LOG_DRIVER" == "syslog" ]]; then
    echo "Container logs are being sent to syslog on the host for container ${CONTAINER_ID}."
  else
    echo "Container logs are not being sent to syslog on the host for container ${CONTAINER_ID}."
  fi

  # Check if the container is configured to log all commands
  echo "Checking if container is configured to log all commands for container ${CONTAINER_ID}..."
  docker exec $CONTAINER_ID sh -c 'if [ -n "$(which script)" ]; then echo "Container is configured to log all commands for container '${CONTAINER_ID}'."; else echo "Container is not configured to log all commands for container '${CONTAINER_ID}'."; fi'

  # Check for Kubernetes metadata
  echo "Checking for Kubernetes metadata for container ${CONTAINER_ID}..."
  KUBE_METADATA=$(docker inspect $CONTAINER_ID | grep io.kubernetes)
  if [[ -n "$KUBE_METADATA" ]]; then
    echo "Kubernetes metadata found for container ${CONTAINER_ID}."
  else
    echo "No Kubernetes metadata found for container ${CONTAINER_ID}."
  fi

  # Get the TCP ports that the container is using
  TCP_PORTS=$(docker port ${CONTAINER_ID} | grep tcp | awk '{print $3}' | cut -d'-' -f1)

  # Get the UDP ports that the container is using
  UDP_PORTS=$(docker port ${CONTAINER_ID} | grep udp | awk '{print $3}' | cut -d'-' -f1)

  # Print the container name and ports
  echo "Container ${CONTAINER_ID} is using TCP ports: ${TCP_PORTS}"
  echo "Container ${CONTAINER_ID} is using UDP ports: ${UDP_PORTS}"
done
