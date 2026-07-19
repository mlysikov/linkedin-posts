DROP TABLE IF EXISTS count_demo;

CREATE TABLE count_demo (
  id    INTEGER PRIMARY KEY,
  value VARCHAR(20)
);

INSERT INTO count_demo (id, value) VALUES
  (1, NULL),
  (2, ''),
  (3, ' '),
  (4, 'SQL'),
  (5, '  SQL  ');

SELECT
  id,
  value,
  length(value) AS value_length
FROM count_demo
ORDER BY id;

SELECT
  COUNT(*) AS all_rows,
  COUNT(value) AS non_null_values,
  COUNT(NULLIF(TRIM(value), '')) AS filled_values
FROM count_demo;
