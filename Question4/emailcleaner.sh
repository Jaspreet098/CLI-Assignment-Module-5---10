#!/bin/bash

# Check if emails.txt exists and is readable
if [ ! -r "emails.txt" ]; then
    echo "Error: emails.txt not found or not readable."
    exit 1
fi

# Define regex for valid email format
# <letters_and_digits>@<letters>.com
VALID_REGEX='^[A-Za-z0-9]\+@[A-Za-z]\+\.com$'

# Extract valid email addresses
grep "$VALID_REGEX" emails.txt | sort | uniq > valid.txt

# Extract invalid email addresses
grep -v "$VALID_REGEX" emails.txt > invalid.txt

echo "Email processing completed."
echo "Valid emails saved to valid.txt (duplicates removed)."
echo "Invalid emails saved to invalid.txt."
