#!/bin/bash

# Check if input file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <text_file>"
    exit 1
fi

FILE="$1"

# Check if file exists and is readable
if [ ! -r "$FILE" ]; then
    echo "Error: File not found or not readable."
    exit 1
fi

# Clear output files
> vowels.txt
> consonants.txt
> mixed.txt

# Convert input into one word per line, normalize case
tr -c 'A-Za-z' '\n' < "$FILE" | tr 'A-Z' 'a-z' | while read -r word
do
    [ -z "$word" ] && continue

    # Only vowels
    if echo "$word" | grep -Eq '^[aeiou]+$'; then
        echo "$word" >> vowels.txt

    # Only consonants
    elif echo "$word" | grep -Eq '^[bcdfghjklmnpqrstvwxyz]+$'; then
        echo "$word" >> consonants.txt

    # Mixed but starting with a consonant
    elif echo "$word" | grep -Eq '^[bcdfghjklmnpqrstvwxyz]' \
         && echo "$word" | grep -Eq '[aeiou]' \
         && echo "$word" | grep -Eq '[bcdfghjklmnpqrstvwxyz]'; then
        echo "$word" >> mixed.txt
    fi
done

echo "Processing complete."
echo "Results saved in vowels.txt, consonants.txt, and mixed.txt."
