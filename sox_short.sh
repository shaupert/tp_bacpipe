#!/bin/bash

# Target directory (defaults to current directory if not provided)
TARGET_DIR="${1:-.}"

echo "Scanning '$TARGET_DIR' for files shorter than 3s to remove..."
echo "---------------------------------------------------------"

count=0

# Find audio files and evaluate duration
find "$TARGET_DIR" -type f \( -name "*.wav" -o -name "*.mp3" -o -name "*.flac" -o -name "*.ogg" -o -name "*.aiff" \) | while read -r file; do
    duration=$(soxi -D "$file" 2>/dev/null)

    if [[ -n "$duration" ]]; then
        # Check if duration is less than 3.0 seconds
        if (( $(echo "$duration < 3.0" | bc -l) )); then
            printf "Deleting [%.2fs]: %s\n" "$duration" "$file"
            rm -f "$file"
            ((count++))
        fi
    fi
done

echo "---------------------------------------------------------"
echo "Done! Removed matching short files."
