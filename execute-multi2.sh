#!/bin/bash

# Define the location of the PEM file
PEM_FILE="/home/emc/pem-keys/opl/PSB_DEV_APP.pem"

# Define the location of the servers list
SERVER_LIST="/home/emc/opl-scripts/servers.txt"

# Define the path to the mail.sh script
MAIL_SCRIPT="/home/emc/opl-scripts/mail.sh"

# Loop through each server and execute the script
while IFS= read -r SERVER; do
  echo "Copying mail.sh to $SERVER..."
  
  # Copy the mail.sh script to the remote server
  scp -i "$PEM_FILE" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null /opl-scripts/mail.sh opladmin@$SERVER:$REMOTE_SCRIPT_PATH

  echo "Executing mail.sh on $SERVER..."
  
  # Execute the mail.sh script on the remote server
  OUTPUT=$(ssh -i "$PEM_FILE" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null opladmin@$SERVER "bash $REMOTE_SCRIPT_PATH" 2>&1)
  EXIT_CODE=$?

  if [ $EXIT_CODE -eq 0 ]; then
    echo "Script executed successfully on $SERVER. Output:"
    echo "$OUTPUT"
  else
    echo "Failed to execute script on $SERVER. Error:"
    echo "$OUTPUT"
  fi

done < "$SERVER_LIST"

