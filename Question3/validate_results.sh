#!/bin/bash

# Check if marks.txt exists and is readable
if [ ! -r "marks.txt" ]; then
    echo "Error: marks.txt not found or not readable."
    exit 1
fi

one_fail_count=0
all_pass_count=0

echo "Students who failed in exactly ONE subject:"
echo "------------------------------------------"

# Read file line by line
while IFS=',' read -r roll name m1 m2 m3
do
    fail_count=0

    # Check each subject
    if [ "$m1" -lt 33 ]; then
        fail_count=$((fail_count + 1))
    fi

    if [ "$m2" -lt 33 ]; then
        fail_count=$((fail_count + 1))
    fi

    if [ "$m3" -lt 33 ]; then
        fail_count=$((fail_count + 1))
    fi

    # Exactly one subject failed
    if [ "$fail_count" -eq 1 ]; then
        echo "$roll - $name"
        one_fail_count=$((one_fail_count + 1))
    fi

    # Passed all subjects
    if [ "$fail_count" -eq 0 ]; then
        all_pass_count=$((all_pass_count + 1))
    fi

done < marks.txt

echo
echo "Students who passed in ALL subjects:"
echo "----------------------------------"

# Second loop to print passed students
while IFS=',' read -r roll name m1 m2 m3
do
    if [ "$m1" -ge 33 ] && [ "$m2" -ge 33 ] && [ "$m3" -ge 33 ]; then
        echo "$roll - $name"
    fi
done < marks.txt

echo
echo "Summary:"
echo "--------"
echo "Students failed in exactly one subject: $one_fail_count"
echo "Students passed all subjects: $all_pass_count"
