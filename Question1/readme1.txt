Question 1
craeted shell file using cmd-
nano analyze.sh
then coded-

#!/bin/bash

# Check for exactly one argument
if [ "$#" -ne 1 ]; then
    echo "Error: Exactly one argument is required."
    exit 1
fi

TARGET="$1"

# Check if the path exists
if [ ! -e "$TARGET" ]; then
    echo "Error: The specified path does not exist."
    exit 1
fi

# If the argument is a file
if [ -f "$TARGET" ]; then
    lines=$(wc -l < "$TARGET")
    words=$(wc -w < "$TARGET")
    chars=$(wc -c < "$TARGET")

    echo "File analysis:"
    echo "Lines: $lines"
    echo "Words: $words"
    echo "Characters: $chars"

# If the argument is a directory
elif [ -d "$TARGET" ]; then
    total_files=$(find "$TARGET" -maxdepth 1 -type f | wc -l)
    txt_files=$(find "$TARGET" -maxdepth 1 -type f -name "*.txt" | wc -l)

    echo "Directory analysis:"
    echo "Total files: $total_files"
    echo ".txt files: $txt_files"

# If it is neither file nor directory
else
    echo "Error: The argument is neither a regular file nor a directory."
    exit 1
fi

After saving the code, gave it executable permission using-
chmod +x analyze.sh

And then ran it(created myfile.txt before as well)-
./analyze.sh myfile.txt
./analyze.sh Music


