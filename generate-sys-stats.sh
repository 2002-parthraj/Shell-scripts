#!/bin/bash

# Define the output file
OUTPUT_FILE="sar_report_last_week_$(date +%Y-%m-%d).txt"

# Function to check if the sysstat package is installed
check_sysstat() {
    if ! command -v sar &> /dev/null; then
        echo "sysstat package is not installed. Please install it using 'sudo apt install sysstat' (Debian/Ubuntu) or 'sudo yum install sysstat' (RHEL/CentOS)."
        exit 1
    fi
}

# Function to generate report for the last week
generate_last_week_report() {
    echo "Starting SAR report generation for the last week..."
    echo "SAR Report (Last Week) - $(date)" > "$OUTPUT_FILE"
    echo "=============================================" >> "$OUTPUT_FILE"

    # Define the date range (last 7 days)
    for i in {1..7}; do
        DATE=$(date --date="$i days ago" +%d)
        FILE="/var/log/sysstat/sa$DATE"

        if [[ -f "$FILE" ]]; then
            echo "Processing data for $(date --date="$i days ago" +%Y-%m-%d)..." >> "$OUTPUT_FILE"

            # CPU Usage
            echo "-------- CPU Usage on $(date --date="$i days ago" +%Y-%m-%d) --------" >> "$OUTPUT_FILE"
            sar -u -f "$FILE" >> "$OUTPUT_FILE"

            # Memory Usage
            echo "-------- Memory Usage on $(date --date="$i days ago" +%Y-%m-%d) --------" >> "$OUTPUT_FILE"
            sar -r -f "$FILE" >> "$OUTPUT_FILE"

            # Disk Usage
            echo "-------- Disk Usage on $(date --date="$i days ago" +%Y-%m-%d) --------" >> "$OUTPUT_FILE"
            sar -d -f "$FILE" >> "$OUTPUT_FILE"

            # Network Usage
            echo "-------- Network Usage on $(date --date="$i days ago" +%Y-%m-%d) --------" >> "$OUTPUT_FILE"
            sar -n DEV -f "$FILE" >> "$OUTPUT_FILE"

            echo "" >> "$OUTPUT_FILE"
        else
            echo "Data file for $(date --date="$i days ago" +%Y-%m-%d) not found." >> "$OUTPUT_FILE"
        fi
    done

    echo "SAR report for the last week has been generated: $OUTPUT_FILE"
}

# Check for sysstat and generate the report
check_sysstat
generate_last_week_report
