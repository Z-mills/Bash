#!/bin/bash

# Set the threshold for CPU utilization
THRESHOLD=80

# Get a list of all instances in the account
INSTANCES=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --output text)

# Loop through each instance
for INSTANCE in ${INSTANCES}; do
  # Get the CPU utilization for the instance over the past day
  CPU_UTILIZATION=$(aws cloudwatch get-metric-statistics --metric-name CPUUtilization --start-time $(date -u +%Y-%m-%dT%T.%S --date '-1 day') --end-time $(date -u +%Y-%m-%dT%T.%S) --period 300 --namespace AWS/EC2 --statistics Average --dimensions Name=InstanceId,Value=${INSTANCE} --query 'Datapoints[0].Average')

  # If the CPU utilization is above the threshold, print the instance ID
  if (( $(echo "${CPU_UTILIZATION} > ${THRESHOLD}" | bc -l) )); then
    echo "Instance ${INSTANCE} is overprovisioned."
  fi
done
