#!/bin/bash

Csv=False
while getopts ":hn:c" option; do
  case $option in
    c) # CSV output
      Csv=True;;
    h) # Help message
      echo "Usage: $0 [-c]"
      echo "  -c for CSV output you can pipe to a file"
      exit 0;;
    \?) # Invalid option
      echo "Error: Invalid option"
      exit 1;;
  esac
done

# Print the header
YELLOW='\033[0;33m'
RESET='\033[0m'
echo "${YELLOW}\n--- Global content sources in resolvers ---\n${RESET}"

duckdb _tmpview.db "SELECT * FROM (
  SELECT
    contentSourceId,
    COUNT(1) as countOfResolvers
  FROM view_resolver
  GROUP BY contentSourceId
)
ORDER BY countOfResolvers DESC"

echo "${YELLOW}\n--- Content sources in feature configuration is pages and templates ---\n${RESET}"

duckdb _tmpview.db "SELECT * FROM (
  SELECT
    featureName,
    contentService,
    COUNT(1) as countOfTimesUsed,
    COUNT(DISTINCT pageOrTemplateId) as countOfPagesOrTemplatesUsing
  FROM view_rendering
  LEFT JOIN view_page_and_template ON view_page_and_template.published = view_rendering.renderingVersionId
  WHERE pageOrTemplateId IS NOT NULL
    AND contentService != ''
  GROUP BY contentService, featureName
)
ORDER BY countOfPagesOrTemplatesUsing DESC"
