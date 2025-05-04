# aphidus 
A simple crawler for .onion sites

# HTML Metadata Extractor

## Overview:
This Bash script extracts useful metadata and structural elements from HTML files, including:
- Title
- Meta description
- Keywords
- Number of images (<img>) and their alt text descriptions
- Number of videos (<video>)
- Count of \<h1\> and \<h2\> headers

It supports processing multiple HTML files at once and provides color-coded terminal output when run interactively.

## Features:
- Extracts essential metadata from <title> and <meta> tags
- Counts media elements like images and videos
- Extracts alt attributes from images
- Counts headings (\<h1\> and \<h2\>)
- Works with multiple files (*.html)
- Supports color-coded terminal output


## Installation & Usage:

1. Clone the repository:
   git clone https://github.com/yourusername/html-metadata-extractor.git
   cd html-metadata-extractor

2. Make the script executable:
   chmod +x extract_html_info.sh

3. Run the script:
   ./extract_html_info.sh *.html

Redirecting output (without colors):
If you want to save the output to a file (without color codes), use:
   ./extract_html_info.sh *.html > output.txt

## Example Output:
```Processing: example.html
Title: Example Web Page
Description: This is a sample website description.
Keywords: sample, example, website
-----------------------------------
Number of Images: 5
Image Alt Texts:
 - Logo image
 - Hero banner
 - Thumbnail preview
Number of Videos: 2
Number of <h1> Headers: 1
Number of <h2> Headers: 3
===================================
```
## How It Works:
The script uses:
- grep and sed to extract <title> and <meta> information.
- grep to count media tags (<img> and <video>).
- Regular expressions to extract text between HTML tags.
- ANSI escape codes for color-coded output (disabled when redirected).

# License:
This project is licensed under the MIT License - see the LICENSE file for details.

# Contributing:
Feel free to fork the repository and submit pull requests! Suggestions and improvements are welcome.
