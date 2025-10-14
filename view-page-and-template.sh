#!/bin/bash

Csv=False
while getopts ":hn:c" option; do
  case $option in
    c) # CSV output
      Csv=True;;
    \?) # Invalid option
      echo "Error: Invalid option"
      exit 1;;
  esac
done

QUERY="SELECT *
FROM view_page_and_template
ORDER BY
  isPageOrTemplate ASC,
  uri ASC,
  name ASC"

if [[ $Csv == "True" ]]; then
  QUERY="COPY ($QUERY) TO STDOUT WITH (FORMAT CSV, HEADER);"
else
  # Print the header
  YELLOW='\033[0;33m'
  RESET='\033[0m'
  echo "${YELLOW}\n--- Select all from view_page_and_template ---\n${RESET}"
fi

duckdb _tmpview.db "$QUERY"
