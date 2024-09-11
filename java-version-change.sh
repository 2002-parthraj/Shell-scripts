#!/bin/bash

JAVA_PATH="/usr/lib/jvm"

# Function to get existing JAVA_HOME from /etc/environment
get_existing_java_home() {
    grep "^JAVA_HOME=" /etc/environment | grep -v "^#" | tail -n 1 | cut -d"=" -f2 | tr -d \"
}

# Get existing JAVA_HOME from /etc/environment
EXISTING_JAVA_HOME=$(get_existing_java_home)

# Get server IP address
SERVER_IP=$(hostname -I | awk '{print $1}')

# Find the latest Java 1.8 version installed
JAVA_8_VERSION=$(ls -1 ${JAVA_PATH} | grep -E "java-1\.8\.|openjdk-1\.8\." | sort -V | tail -n 1)

# Find the latest Java 21 version installed
JAVA_21_VERSION=$(ls -1 ${JAVA_PATH} | grep -E "java-21\.|openjdk-21\." | sort -V | tail -n 1)

# Debug output
echo "Existing JAVA_HOME: ${EXISTING_JAVA_HOME}"
echo "Found Java 1.8 version: ${JAVA_8_VERSION}"
echo "Found Java 21 version: ${JAVA_21_VERSION}"

# Determine which Java version to update based on existing JAVA_HOME
if [[ "${EXISTING_JAVA_HOME}" == *"java-1.8"* ]]; then
    if [ -n "${JAVA_8_VERSION}" ]; then
        NEW_JAVA_HOME="\"${JAVA_PATH}/${JAVA_8_VERSION}/jre\""
    else
        echo "No updated Java 1.8 installation found in ${JAVA_PATH}"
        exit 1
    fi
elif [[ "${EXISTING_JAVA_HOME}" == *"java-21"* ]] || [[ "${EXISTING_JAVA_HOME}" == *"jre-21"* ]]; then
    if [ -n "${JAVA_21_VERSION}" ]; then
        NEW_JAVA_HOME="\"${JAVA_PATH}/${JAVA_21_VERSION}/jre\""
    else
        echo "No updated Java 21 installation found in ${JAVA_PATH}"
        exit 1
    fi
else
    echo "No supported Java installation (1.8 or 21) found in ${EXISTING_JAVA_HOME}"
    exit 1
fi

# Set JAVA_HOME in /etc/environment
sudo sed -i "s|^JAVA_HOME=.*$|JAVA_HOME=${NEW_JAVA_HOME}|" /etc/environment

# Reload /etc/environment to apply changes for the current shell
source /etc/environment

# Print existing and updated JAVA_HOME for verification
echo "Updated JAVA_HOME: ${JAVA_HOME}"

# Prepare email body with existing and updated JAVA_HOME and server IP
EMAIL_BODY="Server IP: ${SERVER_IP}\nExisting JAVA_HOME: ${EXISTING_JAVA_HOME}\nUpdated JAVA_HOME: ${JAVA_HOME}"

# Send notification email
echo -e "${EMAIL_BODY}" | mailx \
    -s "${SERVER_IP} : Server Packages Updated" \
    -S smtp-use-starttls \
    -S ssl-verify=ignore \
    -S smtp-auth=login \
    -S smtp=smtp://smtp-mail.outlook.com:587 \
    -S from="issue@onlinepsbloans.com" \
    -S smtp-auth-user="issue@onlinepsbloans.com" \
    -S smtp-auth-password="Password@123" \
    -S nss-config-dir=/etc/pki/nssdb/ \
    infra@onlinepsbloans.com

echo "Notification email sent"
#EOF'

# Make the script executable
#sudo chmod +x /root/update_java_home.sh

# Add cron job for 8:30 PM every day directly to /etc/crontab
#echo "30 20 * * * root /root/update_java_home.sh" | sudo tee -a /etc/crontab
