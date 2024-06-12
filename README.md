## Analyze feature usage using pb-data locally

Notes:
- pb-data is a database snapshot of PageBuilder data, taken every 12 hours.

## Requirements

- Mongodb Tools: https://www.mongodb.com/docs/database-tools/installation/installation-macos/
- Duckdb CLI https://duckdb.org/docs/api/cli/overview.html#installation

## How to use

1. Make sure you install the dependencies that `bsondump` and `duckdb` commands are present in your current bash session.
2. First, download the pb-data from Arc XP Admin > PageBuilder > Developer Tools > PB Data screen, to your local computer.
3. Unzip the downloaded tar file, and rename the folder as `pb-data` and place it in this projects root folder.
4. Run `sh _prepare.sh` command to create temp database file (duckdb file) that contains the simplified views that is used in different shell scripts. These views are not copying the actual data, they are just views referring to the actual JSON files converted from mongodb bson files.
5. Run any of the shell script. These scripts are plain and simple, you can read the code to understand what the parameters, or add `-h` argument to the scripts to see help text for each one of them (i.e: `sh find-pages-by-feature-name.sh -h`)

## Scripts

#### `all-features-usage`
produces list of all features used in your pb-data (not bundle), in published pages and templates along with how many pages they are used in and the number of times (instances) they are used in these pages.

#### `find-pages-by-feature-name`
requires `-n` parameter with a feature name that will print list of pages and templates which uses this feature.

You can open pagebuilder editor with the following url template with the page or template id in the query string: `https://YOURORG.arcpublishing.com/pagebuilder/editor/curate?p=PAGEID`
