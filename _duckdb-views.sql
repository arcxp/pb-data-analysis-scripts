-- Resolver view
CREATE VIEW view_resolver AS
SELECT
  _id,
  params,
  sites,
  testUri,
  name,
  CAST(json_extract(to_json(priority), '$.$numberInt') AS INTEGER) as priority,
  pattern,
  page,
  contentSourceId,
  contentConfigMapping,
  content2pageMapping,
  CAST(json_extract(to_json(__v), '$.$numberInt') AS INTEGER) as __v,
  defaultOutputType,
  REPLACE(REPLACE(note, CHR(10), ' '), CHR(13), ' ') as note -- replace newlines with spaces
FROM read_json_auto(
  'pb-data/resolver_config.json',
  format = 'newline_delimited',
  ignore_errors=true
);

-- Pages and templates combined view
CREATE VIEW view_page_and_template AS
SELECT
  _id as pageOrTemplateId,
  'Page' as isPageOrTemplate,
  uri,
  name,
  defaultOutputType,
  published
FROM read_json_auto(
  'pb-data/page.json',
  format = 'newline_delimited',
  ignore_errors=true
)
UNION
SELECT
  _id as pageOrTemplateId,
  'Template' as isPageOrTemplate,
  '' as uri,
  name,
  '' as defaultOutputType,
  published
FROM read_json_auto(
  'pb-data/template.json',
  format = 'newline_delimited',
  ignore_errors=true
);

-- Simplified and flattened rendering collection view
CREATE VIEW view_rendering AS
WITH PublishedVersions AS (
  SELECT DISTINCT published as versionId
  FROM view_page_and_template
  WHERE published IS NOT NULL
),
PublishedLayoutItems AS (
  SELECT
    _id as renderingId,
    _version as renderingVersionId,
    json_extract_string(creationDate, '$.$numberLong') as creationDate,
    layout,
    layoutItems
  FROM read_json_auto(
    'pb-data/rendering.json',
    format = 'newline_delimited',
    ignore_errors=true
  )
  WHERE _version IN (SELECT versionId FROM PublishedVersions)
),
LatestLayoutItems AS (
  SELECT
    renderingId,
    renderingVersionId,
    creationDate,
    layout,
    layoutItems
  FROM PublishedLayoutItems
  -- Select the latest rendering by creation date for each page's published version
  QUALIFY ROW_NUMBER() OVER (PARTITION BY renderingVersionId ORDER BY creationDate DESC) = 1
  ORDER BY renderingVersionId, creationDate DESC
),
FlattenedLayoutItems AS (
  SELECT
    renderingId,
    renderingVersionId,
    creationDate,
    layout,
    unnest(layoutItems) as layoutItem
  FROM LatestLayoutItems
  ORDER BY renderingVersionId, creationDate DESC
),
RenderableItems AS (
  SELECT
    renderingId,
    renderingVersionId,
    creationDate,
    layout,
    unnest(layoutItem.renderableItems) as renderableItem
  FROM FlattenedLayoutItems
),
ExpandedRenderableItems AS (
  SELECT
    renderingVersionId,
    layout,
    renderableItem.fingerprint,
    renderableItem.className,
    renderableItem.featureConfig,
    renderableItem.chainConfig,
    renderableItem.displayName,
    renderableItem.customFields,
    renderableItem.features
  FROM RenderableItems
  -- WHERE renderableItem.parent IS NULL -- Optionally exclude feature-linked children feature blocks
),
FeaturesFromRenderableItems AS (
  SELECT
    renderingVersionId,
    layout,
    fingerprint,
    '' as chainName,
    '' as chainDisplayName,
    featureConfig as featureName,
    displayName as featureDisplayName,
    (
      SELECT string_agg(content_service, '|')
      FROM (
        SELECT DISTINCT json_extract_string(customFields, '$.' || key.unnest || '.contentService') as content_service
        FROM unnest(json_keys(customFields)) as key
        WHERE json_extract_string(customFields, '$.' || key.unnest || '.contentService') IS NOT NULL
          AND json_extract_string(customFields, '$.' || key.unnest || '.contentService') != ''
      )
    ) as contentService
    FROM ExpandedRenderableItems
    WHERE className LIKE '%.rendering.Feature'
),
ChainsFromRenderableItems AS (
  SELECT
      renderingVersionId,
      layout,
      chainConfig as chainName,
      displayName as chainDisplayName,
      features
    FROM ExpandedRenderableItems
    WHERE className LIKE '%.rendering.Chain'
),
UnnestedFeaturesFromChains AS (
  SELECT
    renderingVersionId,
    layout,
    chainName,
    chainDisplayName,
    unnest(features) as feature
  FROM ChainsFromRenderableItems
),
FeaturesFromChains AS (
  SELECT
    renderingVersionId,
    layout,
    feature.fingerprint,
    chainName,
    chainDisplayName,
    feature.featureConfig as featureName,
    feature.displayName as featureDisplayName,
    (
      SELECT string_agg(content_service, '|')
      FROM (
        SELECT DISTINCT json_extract_string(feature.customFields, '$.' || key.unnest || '.contentService') as content_service
        FROM unnest(json_keys(feature.customFields)) as key
        WHERE json_extract_string(feature.customFields, '$.' || key.unnest || '.contentService') IS NOT NULL
          AND json_extract_string(feature.customFields, '$.' || key.unnest || '.contentService') != ''
      )
    ) as contentService
  FROM UnnestedFeaturesFromChains
  -- WHERE feature.parent IS NULL -- Optionally exclude feature-linked children feature blocks
),
FlattenedAllFeatures AS (
  SELECT *
  FROM (
    SELECT * FROM FeaturesFromRenderableItems
    UNION ALL
    SELECT * FROM FeaturesFromChains
  )
)
SELECT * FROM FlattenedAllFeatures
