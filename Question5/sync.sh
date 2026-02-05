#!/bin/bash

# Check that exactly two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <dirA> <dirB>"
    exit 1
fi

DIRA="$1"
DIRB="$2"

# Validate directories
if [ ! -d "$DIRA" ]; then
    echo "Error: $DIRA is not a valid directory."
    exit 1
fi

if [ ! -d "$DIRB" ]; then
    echo "Error: $DIRB is not a valid directory."
    exit 1
fi

echo "Files present only in $DIRA:"
echo "-----------------------------"
for file in "$DIRA"/*
do
    filename=$(basename "$file")
    if [ ! -e "$DIRB/$filename" ]; then
        echo "$filename"
    fi
done

echo
echo "Files present only in $DIRB:"
echo "-----------------------------"
for file in "$DIRB"/*
do
    filename=$(basename "$file")
    if [ ! -e "$DIRA/$filename" ]; then
        echo "$filename"
    fi
done

echo
echo "Files present in BOTH directories (content comparison):"
echo "-------------------------------------------------------"
for file in "$DIRA"/*
do
    filename=$(basename "$file")

    if [ -f "$DIRB/$filename" ] && [ -f "$file" ]; then
        cmp -s "$file" "$DIRB/$filename"
        if [ "$?" -eq 0 ]; then
            echo "$filename : SAME"
        else
            echo "$filename : DIFFERENT"
        fi
    fi
done
