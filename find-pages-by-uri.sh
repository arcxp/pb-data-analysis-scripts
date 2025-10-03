#!/bin/bash

# Get the options
UrlFilter=""
Csv=False
while getopts ":hu:c" option; do
  case $option in
    u) # Enter a name
      UrlFilter=$OPTARG;;
    c) # CSV output
      Csv=True;;
    h) # Help message
      echo "Usage: $0 -u uri [-c]"
      echo "  -c for CSV output you can pipe to a file"
      exit 0;;
    \?) # Invalid option
      echo "Error: Invalid option"
      exit 1;;
  esac
done
# Check if the name is at least 2 characters long
if [[ -z "$UrlFilter" || ${#UrlFilter} -lt 2 ]]; then
  echo "Error: URI filter (-u argument) with at least 2 characters is required."
  exit 1
fi

QUERY="SELECT * FROM view_page_and_template
WHERE uri LIKE '%$UrlFilter%'
ORDER BY
  view_page_and_template.isPageOrTemplate ASC,
  view_page_and_template.uri ASC,
  view_page_and_template.name ASC"

if [[ $Csv == "True" ]]; then
  QUERY="COPY ($QUERY) TO STDOUT WITH (FORMAT CSV, HEADER);"
else
  # Print the header
  YELLOW='\033[0;33m'
  RESET='\033[0m'
  echo "${YELLOW}\n--- All published pages with URI contains: ${UrlFilter} ---\n${RESET}"
fi

duckdb _tmpview.db "$QUERY"
