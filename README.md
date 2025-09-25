Example code is provided by a community of developers. They are intended to help you get started more quickly, but are not guaranteed to cover all scenarios nor are they supported by Arc XP.

> These examples are licensed under the [MIT license](https://mit-license.org/): THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Reiterated from license above, all code in this example is free to use, and as such, there is NO WARRANTY, SLA or SUPPORT for these examples.

----


## Scripts to analyze pb-data locally

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

## Video Tutorial

[![Video Tutorial](https://img.youtube.com/vi/Sy3FjQv73VM/0.jpg)](https://www.youtube.com/watch?v=Sy3FjQv73VM)

The video and tutorial can be found in "[How to check feature/content-source usage using pb-data analysis scripts](https://docs.arcxp.com/alc/en/how-to-check-feature-content-source-usage-using-pb-data-analysis-scripts?id=kb_article_view&sys_kb_id=b5ee6257c3f2ca50a046930a05013129#mcetoc_1i0qpofi99f)" ALC documentation.


## Scripts

### `all-chains-usage.sh [-c]`
Produces list of all chains used in your pb-data (not bundle), in published pages and templates along with how many pages they are used in and the number of times (instances) they are used in these pages.

`-c` Output in CSV format

### `all-features-usage.sh [-c]`
Produces list of all features used in your pb-data (not bundle), in published pages and templates along with how many pages they are used in and the number of times (instances) they are used in these pages.

`-c` Output in CSV format

### `find-pages-by-chain-name.sh -n <chain_name> [-c]`
Produces list of pages and templates which uses a specific chain.
You can open pagebuilder editor with the following url template with the page or template id in the query string: `https://YOURORG.arcpublishing.com/pagebuilder/editor/curate?p=PAGEID`

`-n` Chain name (required, min 2 characters)

`-c` Output in CSV format

### `find-pages-by-feature-name.sh -n <feature_name> [-c]`
Produces list of pages and templates which uses a specific feature.
You can open pagebuilder editor with the following url template with the page or template id in the query string: `https://YOURORG.arcpublishing.com/pagebuilder/editor/curate?p=PAGEID`

`-n` Feature name (required, min 2 characters)

`-c` Output in CSV format

### `all-content-sources-usage.sh`
List of all content sources, from both global content source configurations (from resolvers) and feature configurations.
Note: This script does NOT have CSV output option.

### `all-page-urls.sh [-c]`
Excludes templates, as they are powered by dynamic URL patterns from resolvers and are not included in this script's output.

`-c` Output in CSV format

### `find-pages-by-uri.sh -u <uri_filter> [-c]`
List all pages matching URI containing the provided filter.

`-u` URI filter (required, min 2 characters)

`-c` Output in CSV format

### `describe-page-or-template.sh -i <page_or_template_id> [-c]`
This script shows meta data of this page (uri, title), list of chains & features, sorted by how many times used in the page/template, and the content sources configured from features.

`-i` Page or Template ID (required, min 2 characters)

`-c` Output in CSV format
