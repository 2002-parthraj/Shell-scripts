#!/bin/bash

# Define the location of the PEM file
PEM_FILE="/home/emc/pem-keys/opl/PSB_DEV_APP.pem"

# Define the location of the servers list
SERVER_LIST="/home/emc/opl-scripts/servers.txt"

# Define the path to the mail.sh script
MAIL_SCRIPT="/home/emc/opl-scripts/mail.sh"

# Loop through each server
while IFS= read -r SERVER; do
  echo "Copying mail.sh to $SERVER..."
  scp -i "$PEM_FILE" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$MAIL_SCRIPT" ec2-user@$SERVER:/tmp/ 2>&1
  if [ $? -eq 0 ]; then
    echo "Script copied successfully to $SERVER."
    echo "Executing mail.sh on $SERVER..."
    OUTPUT=$(ssh -i "$PEM_FILE" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ec2-user@$SERVER "bash /tmp/mail.sh" 2>&1)
    if [ $? -eq 0 ]; then
      echo "Script executed successfully on $SERVER. Output:"
      echo "$OUTPUT"
    else
      echo "Failed to execute script on $SERVER. Error:"
      echo "$OUTPUT"
    fi
  else
    echo "Failed to copy script to $SERVER."
  fi
done < "$SERVER_LIST"

