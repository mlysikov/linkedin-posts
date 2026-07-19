WHENEVER SQLERROR EXIT SQL.SQLCODE

BEGIN
  EXECUTE IMMEDIATE 'DROP USER demo CASCADE';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -1918 THEN
      RAISE;
    END IF;
END;
/

CREATE USER demo IDENTIFIED BY Password1;
GRANT CREATE SESSION, CREATE TABLE, UNLIMITED TABLESPACE TO demo;

CREATE TABLE demo.count_demo (
  id    NUMBER PRIMARY KEY,
  value VARCHAR2(20)
);

INSERT INTO demo.count_demo (id, value) VALUES (1, NULL);
INSERT INTO demo.count_demo (id, value) VALUES (2, '');
INSERT INTO demo.count_demo (id, value) VALUES (3, ' ');
INSERT INTO demo.count_demo (id, value) VALUES (4, 'SQL');
INSERT INTO demo.count_demo (id, value) VALUES (5, '  SQL  ');

COMMIT;

SELECT
  id,
  value,
  LENGTH(value) AS value_length
FROM demo.count_demo
ORDER BY id;

SELECT
  COUNT(*) AS all_rows,
  COUNT(value) AS non_null_values,
  COUNT(CASE WHEN TRIM(value) IS NOT NULL THEN 1 END) AS filled_values
FROM demo.count_demo;

EXIT
