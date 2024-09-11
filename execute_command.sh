#!/bin/bash

# Define the location of the PEM file
PEM_FILE="/home/emc/pem-keys/opl/PSB_DEV_APP.pem"

# Define the location of the servers list
SERVER_LIST="/home/emc/opl-scripts/servers.txt"

# Define the command to be executed on the remote servers
REMOTE_COMMAND="ls -ltrha"

# Loop through each server and execute the command
while IFS= read -r SERVER; do
  echo "Executing command on $SERVER..."
  OUTPUT=$(ssh -i "$PEM_FILE" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ec2-user@$SERVER "$REMOTE_COMMAND" 2>&1)
  if [ $? -eq 0 ]; then
    echo "Command executed successfully on $SERVER. Output:"
    echo "$OUTPUT"
  else
    echo "Failed to execute command on $SERVER. Error:"
    echo "$OUTPUT"
  fi
done < "$SERVER_LIST"
