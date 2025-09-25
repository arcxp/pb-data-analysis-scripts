#!/bin/bash

# Get the options
PageOrTemplateId=""
while getopts ":hi:" option; do
  case $option in
    i) # Enter an ID
      PageOrTemplateId=$OPTARG;;
    h) # Help message
      echo "Usage: $0 -n name [-c]"
      echo "  -c for CSV output you can pipe to a file"
      exit 0;;
    \?) # Invalid option
      echo "Error: Invalid option"
      exit 1;;
  esac
done
# Check if the name is at least 2 characters long
if [[ -z "$PageOrTemplateId" || ${#PageOrTemplateId} -lt 2 ]]; then
  echo "Error: Page or Template id (-i argument) is required."
  exit 1
fi

YELLOW='\033[0;33m'
RESET='\033[0m'


## Print Page Meta ---------------------
echo "${YELLOW}\n--- Page or Temoplate: #${PageOrTemplateId} ---\n${RESET}"
duckdb _tmpview.db "SELECT * FROM view_page_and_template WHERE pageOrTemplateId = '$PageOrTemplateId'"


## Print Chains ---------------------
echo "${YELLOW}\n--- All chains used in: #${PageOrTemplateId} ---\n${RESET}"
duckdb _tmpview.db "SELECT * FROM (
  SELECT
    chainName,
    COUNT(DISTINCT featureName) as countOfTimesUsed
  FROM view_rendering
  INNER JOIN view_page_and_template ON view_page_and_template.published = view_rendering.renderingVersionId
    AND view_page_and_template.pageOrTemplateId = '$PageOrTemplateId'
  WHERE chainName != ''
  GROUP BY chainName
)
ORDER BY countOfTimesUsed DESC"

## Print Features ---------------------
echo "${YELLOW}\n--- All features used in: #${PageOrTemplateId} ---\n${RESET}"
duckdb _tmpview.db "SELECT * FROM (
  SELECT
    featureName,
    COUNT(DISTINCT CONCAT(COALESCE(chainName, ''), '|', layout, '|', COALESCE(contentService, ''))) as countOfTimesUsed
  FROM view_rendering
  INNER JOIN view_page_and_template ON view_page_and_template.published = view_rendering.renderingVersionId
    AND view_page_and_template.pageOrTemplateId = '$PageOrTemplateId'
  WHERE featureName != ''
  GROUP BY featureName
)
ORDER BY countOfTimesUsed DESC"


## Print Content Sources ---------------------
echo "${YELLOW}\n--- Content sources used in: #${PageOrTemplateId} ---\n${RESET}"
duckdb _tmpview.db "SELECT * FROM (
  SELECT
    featureName,
    contentService,
    COUNT(DISTINCT CONCAT(COALESCE(chainName, ''), '|', layout)) as countOfTimesUsed
  FROM view_rendering
  INNER JOIN view_page_and_template ON view_page_and_template.published = view_rendering.renderingVersionId
    AND view_page_and_template.pageOrTemplateId = '$PageOrTemplateId'
  WHERE contentService != '' AND featureName != ''
  GROUP BY contentService, featureName
)
ORDER BY countOfTimesUsed DESC"
