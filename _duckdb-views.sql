-- Simplified and flattened rendering collection view
CREATE VIEW view_rendering AS
WITH FlattenedLayoutItems AS (
  SELECT
    _version as renderingVersionId,
    layout,
    unnest(layoutItems, recursive := true) as renderableItem
  FROM read_json_auto(
    'pb-data/rendering.json',
    format = 'newline_delimited',
    ignore_errors=true
  )
),
RenderableItems AS (
  SELECT * FROM (
    SELECT
      renderingVersionId,
      layout,
      unnest(renderableItems, recursive := true)
    FROM FlattenedLayoutItems
  )
),
FeaturesFromRenderableItems AS (
  SELECT
    renderingVersionId,
    layout,
    '' as chainName,
    '' as chainDisplayName,
    featureConfig as featureName,
    displayName as featureDisplayName,
    contentService,
    contentConfigValues
  FROM (
    SELECT * FROM RenderableItems
    WHERE className LIKE '%.rendering.Feature'
  )
),
ChainsFromRenderableItems AS (
  SELECT
      renderingVersionId,
      layout,
      chainConfig as chainName,
      displayName as chainDisplayName,
      features
    FROM RenderableItems
    WHERE className LIKE '%.rendering.Chain'
),
FeaturesFromChains AS (
  SELECT
    renderingVersionId,
    layout,
    chainName,
    chainDisplayName,
    featureConfig as featureName,
    displayName  as featureDisplayName,
    contentService,
    contentConfigValues
  FROM (
    SELECT
      renderingVersionId,
      layout,
      chainName,
      chainDisplayName,
      unnest(features, recursive := true)
    FROM ChainsFromRenderableItems
  )
),
FlattenedAllFeatures AS (
  SELECT *
  FROM (
    SELECT * FROM FeaturesFromRenderableItems
    UNION ALL
    SELECT * FROM FeaturesFromChains
  )
)
SELECT * FROM FlattenedAllFeatures;

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

-- Resolver view
CREATE VIEW view_resolver AS
SELECT * FROM read_json_auto(
  'pb-data/resolver_config.json',
  format = 'newline_delimited',
  ignore_errors=true
);
