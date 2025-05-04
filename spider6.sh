#!/bin/bash

# Ensure correct arguments
if [ $# -ne 3 ]; then
  echo "Usage: $0 <start-url> <max-sites> <max-depth>"
  exit 1
fi

START_URL=$1
MAX_SITES=$2
MAX_DEPTH=$3
OUTPUT_DIR="./sites"
CRAWLED_URLS="./crawled_urls.txt"
#POSSIBLE_URLS="./possible_urls.txt"
LOG_FILE="./crawler.log" #TODO TO MAKE AND MAKE TIME-OF-START DEPENDENT


# Create required directories/files
mkdir -p "$OUTPUT_DIR"
touch "$CRAWLED_URLS"
#touch "$POSSIBLE_URLS"
echo "Crawl started at $(date)"

sites_crawled=0

# Normalize URLs properly
normalize_url() {
  echo "$1" | sed -E 's/^(https?:\/\/)?(www\.)?//; s:/*$::'
}

# Crawl function
crawl_url() {
  local url=$(normalize_url "$1")
  local depth=$2

  if [ "$depth" -gt "$MAX_DEPTH" ] || [ "$sites_crawled" -ge "$MAX_SITES" ]; then
    return
  fi

  if grep -Fxq "$url" "$CRAWLED_URLS"; then
    echo "Skipping already crawled: $url"
    return
  fi

  filename=$(echo "$url" | sed -E 's#https?://##; s#[^a-zA-Z0-9._-]#_#g')
  # echo "Filename is -> $filename"
  wget -cNk --timeout=10 --tries=3 --quiet --output-document="$OUTPUT_DIR/$filename" "http://$url"    # -c and -N -k may be very excessive ??
  if [ $? -ne 0 ]; then
    echo "Failed to download: $url"
    return
  fi
  echo "Downloaded: $url" 
  echo "$url" >> "$CRAWLED_URLS"

  ((sites_crawled++))

  links=()

  # Extract explicit .onion links
  while read -r onion_url; do
    links+=("$onion_url")
  done < <(grep -oE '<a href="(http|https)://[a-z2-7]{56}\.onion[^"]*"' "$OUTPUT_DIR/$filename" | sed -E 's/<a href="//;s/"$//')
  

  ### Extract potential hidden onions -- THIS IS NOW OFF AS IT IS A PAIN IN THE BUTT. PROBABLy better to do
  ### as a part of post-processing
  ### refer to spider5 for details. TODO this line cannot stay for any serious commit and needs to be RESOLVED. 
  
  # Sort the links placing the origin site last
  #
 
   # Extract domain from current_url
   current_domain=$(echo "$url" | awk -F[/:] '{print $4}')
   echo "Current url: $url"

   # Sort URLs: First those NOT matching the current domain, then the ones that match
   #$sorted_links=($(printf "%s\n" "${links[@]}" | awk -v domain="$current_domain" '{
   #    if ($0 ~ domain) {
   #        print $0 > "current_domain_links.txt"
   #    } else {
   #        print
   #    }
   #}
   #END {
   #    while ((getline line < "current_domain_links.txt") > 0) {
   #        print line
   #    }
   # close("current_domain_links.txt")
#}'))

# Print links
#for link in "${links[@]}"; do
#	echo "Link: $link" >> links_$sites_crawled.txt
#done
#for link in "${sorted_links[@]}"; do
#	echo "Sorter link: $link" >> sort_links_$sites_crawled.txt
#done

#printf "%s\n" "Links: ${links[@]}"
#printf "%s\n" "Sorted links: ${sorted_links[@]}"

# Cleanup temporary file
#rm -f current_domain_links.txt

  # Process extracted links
  if [ ${#links[@]} -gt 0 ]; then
    for link in "${links[@]}"; do
      crawl_url "$link" $((depth + 1))
    done
  fi
}

crawl_url "$START_URL" 0

echo "Crawl finished at $(date)"
