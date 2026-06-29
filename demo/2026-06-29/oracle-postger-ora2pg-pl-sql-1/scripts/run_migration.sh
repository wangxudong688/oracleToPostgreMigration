#!/bin/bash
#
# 在 ora2pg_runner 容器中执行: bash /work/scripts/run_migration.sh
#
# ora2pg v18.2 支持的导出类型:
#   TABLE, VIEW, SEQUENCE, TRIGGER, FUNCTION, PROCEDURE, PACKAGE,
#   GRANT, MVIEW, SYNONYM, COPY, INSERT, ...
#
set -e

CFG=/work/config/ora2pg.conf
OUT=/work/outputs
PG_URL="postgresql://postgres:postgres@postgres:5432/target_db"

echo ""
echo "========================================="
echo " Step 1: 测试 Oracle 连接"
echo "========================================="
ora2pg -c $CFG -t SHOW_TABLE || { echo "连接 Oracle 失败"; exit 1; }

echo ""
echo "========================================="
echo " Step 2: 导出序列 (SEQUENCE)"
echo "========================================="
ora2pg -c $CFG -t SEQUENCE -o $OUT/01_sequence.sql

echo ""
echo "========================================="
echo " Step 3: 导出表结构 (TABLE)"
echo "  (包含表定义、约束、索引)"
echo "========================================="
ora2pg -c $CFG -t TABLE -o $OUT/02_table.sql

echo ""
echo "========================================="
echo " Step 4: 导出视图 (VIEW)"
echo "========================================="
ora2pg -c $CFG -t VIEW -o $OUT/03_view.sql

echo ""
echo "========================================="
echo " Step 5: 导出触发器 (TRIGGER)"
echo "========================================="
ora2pg -c $CFG -t TRIGGER -o $OUT/04_trigger.sql

echo ""
echo "========================================="
echo " Step 6: 导出函数 (FUNCTION)"
echo "========================================="
ora2pg -c $CFG -t FUNCTION -o $OUT/05_function.sql

echo ""
echo "========================================="
echo " Step 7: 导出存储过程 (PROCEDURE)"
echo "========================================="
ora2pg -c $CFG -t PROCEDURE -o $OUT/06_procedure.sql

echo ""
echo "========================================="
echo " Step 8: 导出包 (PACKAGE)"
echo "========================================="
ora2pg -c $CFG -t PACKAGE -o $OUT/07_package.sql

echo ""
echo "========================================="
echo " Step 9: 导出物化视图 (MVIEW)"
echo "========================================="
ora2pg -c $CFG -t MVIEW -o $OUT/08_mview.sql

echo ""
echo "========================================="
echo " Step 10: 导出同义词 (SYNONYM)"
echo "========================================="
ora2pg -c $CFG -t SYNONYM -o $OUT/09_synonym.sql

echo ""
echo "========================================="
echo " Step 11: 导出授权 (GRANT)"
echo "========================================="
ora2pg -c $CFG -t GRANT -o $OUT/10_grant.sql

echo ""
echo "========================================="
 echo " Step 12: 导出数据 (INSERT)"
echo "========================================="
ora2pg -c $CFG -t INSERT -o $OUT/11_data.sql

echo ""
echo "========================================="
echo " Step 13: 导入 PostgreSQL"
echo "========================================="
for f in 01_sequence.sql 02_table.sql 03_view.sql \
         04_trigger.sql 05_function.sql 06_procedure.sql \
         07_package.sql 08_mview.sql 09_synonym.sql \
         10_grant.sql; do
  echo "  -> 导入 $f ..."
  psql "$PG_URL" -f $OUT/$f.sql 2>&1 | tail -5
  echo ""
done

echo ""
echo "========================================="
echo " Step 14: 导入数据"
echo "========================================="
echo "  -> 禁用触发器..."
psql "$PG_URL" -c "SET session_replication_role = 'replica';"
echo "  -> 导入数据..."
psql "$PG_URL" -f $OUT/11_data.sql 2>&1 | tail -10
echo "  -> 恢复触发器..."
psql "$PG_URL" -c "SET session_replication_role = 'origin';"

echo ""
echo "========================================="
echo " Step 15: 验证"
echo "========================================="
echo ""
echo "--- 表清单 ---"
psql "$PG_URL" -c "\dt"
echo ""
echo "--- 索引清单 ---"
psql "$PG_URL" -c "\di"
echo ""
echo "--- 视图清单 ---"
psql "$PG_URL" -c "\dv"
echo ""
echo "--- 函数/过程清单 ---"
psql "$PG_URL" -c "\df"
echo ""
echo "--- 序列清单 ---"
psql "$PG_URL" -c "\ds"
echo ""
echo "--- 数据行数 ---"
psql "$PG_URL" -c "
  SELECT schemaname, relname, n_live_tup
  FROM pg_stat_user_tables
  ORDER BY relname;
"
echo ""
echo "========================================="
echo " 迁移完成！生成文件在宿主机 outputs/ 目录下"
echo "========================================="
ls -la $OUT/*.sql 2>/dev/null
