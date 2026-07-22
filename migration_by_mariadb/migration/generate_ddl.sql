-- ==========================================================================
-- 从 Oracle 生成 MySQL CREATE TABLE DDL
-- 在 Oracle 端执行，输出可直接在 MySQL 中运行的建表语句
-- ==========================================================================
-- 使用方式（Oracle SQL*Plus / SQL Developer）：
--   @generate_ddl.sql
--   或者复制下面 SELECT 查询到 Oracle SQL Developer 中运行
--   将输出保存为 .sql 文件，然后在 MySQL 中执行：source tables_mysql.sql
-- ==========================================================================

SET PAGESIZE 0
SET LONG 1000000
SET LINESIZE 500
SET FEEDBACK OFF
SET TRIMSPOOL ON
SET VERIFY OFF
SET TERMOUT OFF

SPOOL tables_mysql.sql

-- 定义要迁移的模式（改成实际的 Schema 名）
DEFINE input_schema = 'SCOTT'

WITH col_defs AS (
  SELECT
    c.table_name,
    c.column_id,
    c.column_name,
    CASE
      -- VARCHAR2 → VARCHAR
      WHEN c.data_type IN ('VARCHAR2','NVARCHAR2')
        THEN 'VARCHAR(' || c.char_length || ')'
      -- CHAR/NCHAR → CHAR
      WHEN c.data_type IN ('CHAR','NCHAR')
        THEN 'CHAR(' || c.char_length || ')'
      -- NUMBER(p,s) → DECIMAL(p,s)
      WHEN c.data_type = 'NUMBER' AND c.data_precision IS NOT NULL
            AND c.data_scale IS NOT NULL AND c.data_scale > 0
        THEN 'DECIMAL(' || c.data_precision || ',' || c.data_scale || ')'
      -- NUMBER(p,0) → BIGINT
      WHEN c.data_type = 'NUMBER' AND c.data_precision IS NOT NULL
            AND NVL(c.data_scale,0) = 0
        THEN 'BIGINT'
      -- NUMBER(任意) → DECIMAL(38)
      WHEN c.data_type = 'NUMBER' AND c.data_precision IS NULL
        THEN 'DECIMAL(38)'
      -- DATE → DATETIME
      WHEN c.data_type = 'DATE'
        THEN 'DATETIME'
      -- TIMESTAMP → DATETIME(6)
      WHEN c.data_type LIKE 'TIMESTAMP%'
        THEN 'DATETIME(6)'
      -- CLOB → LONGTEXT
      WHEN c.data_type IN ('CLOB','NCLOB','LONG')
        THEN 'LONGTEXT'
      -- BLOB → LONGBLOB
      WHEN c.data_type IN ('BLOB','RAW','LONG RAW')
        THEN 'LONGBLOB'
      -- FLOAT → DOUBLE
      WHEN c.data_type = 'FLOAT'
        THEN 'DOUBLE'
      -- INTEGER → INT
      WHEN c.data_type = 'INTEGER'
        THEN 'INT'
      -- BINARY_FLOAT → FLOAT
      WHEN c.data_type = 'BINARY_FLOAT'
        THEN 'FLOAT'
      -- BINARY_DOUBLE → DOUBLE
      WHEN c.data_type = 'BINARY_DOUBLE'
        THEN 'DOUBLE'
      -- 其他保持原名（如 BOOLEAN 等）
      ELSE c.data_type
    END AS mysql_data_type,
    CASE WHEN c.nullable = 'N' THEN ' NOT NULL' ELSE '' END AS nullable,
    CASE WHEN c.data_default IS NOT NULL
              AND c.data_default != 'NULL'
              AND c.data_default != ''
         THEN ' DEFAULT ' || REPLACE(REPLACE(c.data_default, CHR(10), ''), CHR(13), '')
         ELSE ''
    END AS col_default,
    CASE WHEN pk_col.column_name IS NOT NULL THEN ' PRIMARY KEY' ELSE '' END AS is_pk
  FROM all_tab_columns c
  LEFT JOIN (
    SELECT cc.owner, cc.table_name, cc.column_name
    FROM all_cons_columns cc
    JOIN all_constraints uc
      ON cc.owner = uc.owner
     AND cc.table_name = uc.table_name
     AND cc.constraint_name = uc.constraint_name
     AND uc.constraint_type = 'P'
  ) pk_col
    ON c.owner = pk_col.owner
   AND c.table_name = pk_col.table_name
   AND c.column_name = pk_col.column_name
  WHERE c.owner = UPPER('&&input_schema')
    AND c.table_name NOT LIKE 'BIN$%'
)
SELECT
  CONCAT(
    '-- Table: ', table_name, CHR(10),
    'DROP TABLE IF EXISTS `', table_name, '`;', CHR(10),
    'CREATE TABLE `', table_name, '` (', CHR(10),
    GROUP_CONCAT(
      CONCAT('  `', column_name, '` ', mysql_data_type, nullable, col_default, is_pk)
      ORDER BY column_id
      SEPARATOR ', ' || CHR(10)
    ),
    CHR(10),
    ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;',
    CHR(10)
  ) AS stmt
FROM col_defs
GROUP BY table_name
ORDER BY table_name;

SPOOL OFF

-- 生成外键约束（如果 Oracle 表有外键）
PROMPT -- ============================================
PROMPT -- Foreign Key Constraints
PROMPT -- ============================================

SELECT
  CONCAT(
    'ALTER TABLE `', c.table_name, '`',
    ' ADD CONSTRAINT `', c.constraint_name, '`',
    ' FOREIGN KEY (`', cc.column_name, '`)',
    ' REFERENCES `', c.r_owner, '`.`', uc.table_name, '` (`', rcc.column_name, '`)',
    CASE WHEN c.delete_rule = 'CASCADE' THEN ' ON DELETE CASCADE' ELSE '' END,
    ';'
  ) AS fk_stmt
FROM all_constraints c
JOIN all_cons_columns cc ON c.owner = cc.owner AND c.constraint_name = cc.constraint_name
JOIN all_constraints uc ON c.r_owner = uc.owner AND c.r_constraint_name = uc.constraint_name
JOIN all_cons_columns rcc ON uc.owner = rcc.owner AND uc.constraint_name = rcc.constraint_name AND cc.position = rcc.position
WHERE c.owner = UPPER('&&input_schema')
  AND c.constraint_type = 'R'
  AND c.table_name NOT LIKE 'BIN$%'
ORDER BY c.table_name, c.constraint_name;

-- 生成索引
PROMPT
PROMPT -- ============================================
PROMPT -- Indexes
PROMPT -- ============================================

SELECT
  CONCAT(
    CASE WHEN i.uniqueness = 'UNIQUE' THEN 'CREATE UNIQUE INDEX ' ELSE 'CREATE INDEX ' END,
    '`', i.index_name, '` ON `', i.table_name, '` (',
    (
      SELECT GROUP_CONCAT(
        CASE WHEN ic.descend = 'DESC' THEN CONCAT('`', ic.column_name, '` DESC')
             ELSE CONCAT('`', ic.column_name, '`')
        END ORDER BY ic.column_position
      )
      FROM all_ind_columns ic
      WHERE ic.index_owner = i.owner AND ic.index_name = i.index_name
    ),
    ');'
  ) AS idx_stmt
FROM all_indexes i
WHERE i.owner = UPPER('&&input_schema')
  AND i.table_name NOT LIKE 'BIN$%'
  AND i.index_type != 'LOB'
  AND i.constraint_index = 'NO'
ORDER BY i.table_name, i.index_name;

SPOOL OFF

PROMPT
PROMPT DDL 已生成到 tables_mysql.sql
PROMPT 在 MySQL 中执行: source tables_mysql.sql
PROMPT
EXIT;
