#!/bin/bash

# Check that exactly one argument is provided
if [ "$#" -ne 1 ]; then
    echo "Error: Exactly one log file must be provided."
    echo "Usage: $0 <log_file>"
    exit 1
fi

LOG_FILE="$1"

# Validate that the file exists and is readable
if [ ! -e "$LOG_FILE" ]; then
    echo "Error: File does not exist: $LOG_FILE"
    exit 1
fi

if [ ! -r "$LOG_FILE" ]; then
    echo "Error: File is not readable: $LOG_FILE"
    exit 1
fi

# Count total log entries
TOTAL_ENTRIES=$(wc -l < "$LOG_FILE")

# Count log levels
INFO_COUNT=$(grep -c " INFO " "$LOG_FILE")
WARNING_COUNT=$(grep -c " WARNING " "$LOG_FILE")
ERROR_COUNT=$(grep -c " ERROR " "$LOG_FILE")

# Get the most recent ERROR message
LAST_ERROR=$(grep " ERROR " "$LOG_FILE" | tail -n 1)

if [ -z "$LAST_ERROR" ]; then
    LAST_ERROR="No ERROR messages found."
fi

# Generate report file name
DATE=$(date +"%Y-%m-%d")
REPORT_FILE="logsummary_${DATE}.txt"

# Write report
{
    echo "Log Summary Report"
    echo "Date: $DATE"
    echo "Log File: $LOG_FILE"
    echo "----------------------------------"
    echo "Total log entries: $TOTAL_ENTRIES"
    echo "INFO messages: $INFO_COUNT"
    echo "WARNING messages: $WARNING_COUNT"
    echo "ERROR messages: $ERROR_COUNT"
    echo
    echo "Most recent ERROR message:"
    echo "$LAST_ERROR"
} > "$REPORT_FILE"

# Display summary to terminal
echo "Log analysis completed successfully."
echo "Summary:"
echo "Total entries: $TOTAL_ENTRIES"
echo "INFO: $INFO_COUNT | WARNING: $WARNING_COUNT | ERROR: $ERROR_COUNT"
echo "Most recent ERROR:"
echo "$LAST_ERROR"
echo
echo "Report generated: $REPORT_FILE"
