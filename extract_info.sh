#!/bin/bash

# Check if output is to a terminal for color formatting
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BLUE='\033[0;34m'
    BOLD_GREEN='\e[1;32m'
    NC='\033[0m'  # No color
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    BOLD_GREEN=''
    NC=''
fi

# Ensure at least one file is provided
if [ $# -eq 0 ]; then
    echo -e "${RED}Usage: $0 file1.html file2.html ...${NC}"
    exit 1
fi

# Loop through each provided file
for filename in "$@"; do
    if [ -f "$filename" ]; then
        echo -e "${BLUE}Processing: $filename${NC}"

        # Extract <title>
        title=$(grep -oP '(?<=<title>).*?(?=</title>)' "$filename")

        # Extract <meta name="description">
        # description=$(grep -oP '(?<=<meta name="description" content=").*?(?=")' "$filename")
        # description=$(grep -o '<meta name="description" content="[^"]*' sites/* | cut -d'"' -f4)
	# description=$(grep -o '<meta name="description" content="[^"]*' "$filename"| cut -d'"' -f4)
	description=$(grep -o '<meta name="description" content="[^"]*' "$filename" | sed 's/<meta name="description" content="//')


        # Extract <meta name="keywords">
        # keywords=$(grep -oP '(?<=<meta name="keywords" content=").*?(?=")' "$filename")
	# keywords=$(grep -o '<meta name="keywords" content="[^"]*' "$filename"| cut -d'"' -f4)
	keywords=$(grep -o '<meta name="keywords" content="[^"]*' "$filename" | sed 's/<meta name="keywords" content="//')


        # Count <img> tags and extract alt attributes
        img_count=$(grep -o '<img ' "$filename" | wc -l)
        # Extract all alt attributes using grep & sed
        
	alt_texts=$(grep -o '<img[^>]*alt="[^"]*"' "$filename" | sed 's/.*alt="\([^"]*\)".*/\1/')
        # Store results in an array
        alt_array=()
        while IFS= read -r line; do
            alt_array+=("$line")
        done <<< "$alt_texts"
        # Print results
        # echo "Extracted alt attributes:"
	# printf '%s\n' "${alt_array[@]}"

        # img_alt_texts=$(grep -oP '(?<=<img[^>]+alt=").*?(?=")' "$filename")

        # Count <video> tags
        video_count=$(grep -o '<video' "$filename" | wc -l)

        # Count headers <h1> and <h2>
        # h1_count=$(grep -o '<h1' "$filename" | wc -l)
        # h2_count=$(grep -o '<h2' "$filename" | wc -l)

        # Print results with colors
        echo -e "${BOLD_GREEN}Title: $title${NC}"
        echo -e "${YELLOW}Description: ${NC}$description"
        echo -e "${RED}Keywords: ${NC}$keywords"
        echo -e "${BLUE}-----------------------------------${NC}"
        echo -e "${GREEN}Number of Images: ${NC}$img_count "
	echo -en "${YELLOW}Image Alt Texts:${NC}" ; for alt in ${alt_array[@]}; do echo -ne "$alt, "; done; echo ""
        echo -e "${RED}Number of Videos: ${NC}$video_count"
        # echo -e "${BLUE}Number of <h1> Headers: ${NC}$h1_count"
        # echo -e "${BLUE}Number of <h2> Headers: ${NC}$h2_count"
        echo -e "${BLUE}===================================${NC}"
    else
        echo -e "${RED}Error: File '$filename' not found.${NC}"
    fi
done
