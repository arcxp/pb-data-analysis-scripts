-- Simplified and flattened rendering collection view
CREATE VIEW view_rendering AS
SELECT
  renderingVersionId,
  layout,
  chainName,
  chainDisplayName,
  featureConfig as featureName,
  displayName as featureDisplayName,
  featureConfig as featureId,
  contentService,
  contentConfigValues
FROM (
  SELECT
    renderingVersionId,
    layout,
    featureConfig as chainName,
    displayName as chainDisplayName,
    unnest(features, recursive := true)
  FROM (
    SELECT
      renderingVersionId,
      layout,
      unnest(renderableItems, recursive := true)
    FROM (
      SELECT
        _version as renderingVersionId,
        layout,
        unnest(layoutItems, recursive := true)
      FROM read_json_auto(
        'pb-data/rendering.json',
        format = 'newline_delimited',
        ignore_errors=true
      )
    )
  )
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


-- Resolver view
CREATE VIEW view_resolver AS
SELECT * FROM read_json_auto(
  'pb-data/resolver_config.json',
  format = 'newline_delimited',
  ignore_errors=true
);
