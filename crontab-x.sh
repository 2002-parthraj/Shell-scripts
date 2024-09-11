#!/bin/bash

# Path to your private key
KEY_PATH="/home/emc/pem-keys/opl/PSB_DEV_APP.pem"

# Cron job to add
CRON_JOB="@reboot bash /root/java-version.sh"

# List of server IP addresses
SERVERS=(
"10.60.6.123"
"10.60.6.196"
"10.60.6.248"
"10.60.6.61"
"10.60.6.224"
"10.60.6.143"
"10.60.6.100"
"10.60.6.144"
"10.60.6.219"
"10.60.6.130"
"10.60.6.75"
"10.60.6.111"
"10.60.6.131"
"10.60.6.198"
"10.60.6.151"
"10.60.6.19"
"10.60.6.125"
"10.60.6.204"
"10.60.6.20"
"10.60.6.46"
"10.60.6.214"
"10.60.6.14"
"10.60.6.120"
"10.60.6.230"
"10.60.6.112"
"10.60.6.253"
"10.60.6.47"
"10.60.6.77"
"10.60.6.206"
)

# Loop through each server to add the cron job for root
for SERVER in "${SERVERS[@]}"; do
    echo "Adding cron job for root on $SERVER..."
    ssh -i "$KEY_PATH" ec2-user@"$SERVER" "(
        sudo crontab -l 2>/dev/null; echo '$CRON_JOB'
    ) | sudo crontab -"
    if [ $? -eq 0 ]; then
        echo "Successfully added cron job for root on $SERVER"
    else
        echo "Failed to add cron job for root on $SERVER"
    fi
done

