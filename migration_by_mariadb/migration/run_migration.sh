#!/usr/bin/env bash
# ==========================================================================
# Oracle → MySQL 迁移执行脚本 (Kettle PDI)
# 使用前：
#   1. 编辑 config.properties 填入真实连接信息
#   2. 确保 Kettle (PDI) 已安装，且 kitchen.sh / pan.sh 在 PATH 中
# ==========================================================================

set -euo pipefail

# 脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ---- 从 config.properties 加载配置 ----
if [ -f "${SCRIPT_DIR}/config.properties" ]; then
  echo ">>> 加载配置文件: config.properties"
  set -a
  source "${SCRIPT_DIR}/config.properties"
  set +a
else
  echo "ERROR: config.properties 不存在，请先创建！"
  echo "       cp config.properties.example config.properties 并编辑"
  exit 1
fi

# ---- 检测 Kettle 命令 ----
KITCHEN=$(command -v kitchen.sh || echo "")
PAN=$(command -v pan.sh || echo "")

if [ -z "$KITCHEN" ]; then
  # 常见 Kettle 安装路径
  for dir in /opt/pdi /opt/data-integration /usr/local/pdi ~/pdi; do
    if [ -f "$dir/kitchen.sh" ]; then
      KITCHEN="$dir/kitchen.sh"
      PAN="$dir/pan.sh"
      break
    fi
  done
fi

if [ -z "$KITCHEN" ]; then
  echo "ERROR: 未找到 kitchen.sh，请设置 PDI_HOME 环境变量或安装 Kettle"
  echo "       下载: https://sourceforge.net/projects/pentaho/"
  exit 1
fi

echo ">>> Kettle 路径: $KITCHEN"
echo ""

# ---- 参数解析 ----
ACTION="${1:-all}"
TABLE_FILTER="${2:-}"

# ---- 执行动作 ----
case "$ACTION" in
  ddl)
    echo ">>> [DDL 阶段] 在 MySQL 中创建目标表"
    "$PAN" \
      -file:"${SCRIPT_DIR}/ora2mysql_create_tables.ktr" \
      -param:"ORACLE_HOST=${ORACLE_HOST}" \
      -param:"ORACLE_PORT=${ORACLE_PORT}" \
      -param:"ORACLE_DATABASE=${ORACLE_DATABASE}" \
      -param:"ORACLE_USER=${ORACLE_USER}" \
      -param:"ORACLE_PASS=${ORACLE_PASS}" \
      -param:"ORACLE_SCHEMA=${ORACLE_SCHEMA}" \
      -param:"MYSQL_HOST=${MYSQL_HOST}" \
      -param:"MYSQL_PORT=${MYSQL_PORT}" \
      -param:"MYSQL_DATABASE=${MYSQL_DATABASE}" \
      -param:"MYSQL_USER=${MYSQL_USER}" \
      -param:"MYSQL_PASS=${MYSQL_PASS}" \
      -level:Basic
    echo ">>> DDL 阶段完成"
    ;;

  data)
    echo ">>> [数据迁移阶段] 逐表拷贝数据"
    TABLES="${TABLE_FILTER:-${TABLE_LIST}}"
    IFS=',' read -ra TBL_ARRAY <<< "$TABLES"
    for tbl in "${TBL_ARRAY[@]}"; do
      tbl=$(echo "$tbl" | xargs)  # trim
      [ -z "$tbl" ] && continue
      echo ""
      echo ">>> 开始迁移表: $tbl"
      "$PAN" \
        -file:"${SCRIPT_DIR}/ora2mysql_copy.ktr" \
        -param:"TABLE_NAME=${tbl}" \
        -param:"COMMIT_SIZE=${COMMIT_SIZE:-1000}" \
        -param:"ORACLE_HOST=${ORACLE_HOST}" \
        -param:"ORACLE_PORT=${ORACLE_PORT}" \
        -param:"ORACLE_DATABASE=${ORACLE_DATABASE}" \
        -param:"ORACLE_USER=${ORACLE_USER}" \
        -param:"ORACLE_PASS=${ORACLE_PASS}" \
        -param:"MYSQL_HOST=${MYSQL_HOST}" \
        -param:"MYSQL_PORT=${MYSQL_PORT}" \
        -param:"MYSQL_DATABASE=${MYSQL_DATABASE}" \
        -param:"MYSQL_USER=${MYSQL_USER}" \
        -param:"MYSQL_PASS=${MYSQL_PASS}" \
        -level:Basic
      echo "<<< 表 $tbl 迁移完成"
    done
    echo ">>> 数据迁移阶段完成"
    ;;

  all)
    echo ">>> ====== 全量迁移开始 ======"
    bash "$0" ddl
    echo ""
    bash "$0" data "$TABLE_FILTER"
    echo ">>> ====== 全量迁移完成 ======"
    ;;

  ddl-only-sql)
    echo ">>> 生成 Oracle DDL 映射 SQL（在 Oracle 端执行）"
    echo "    请将 generate_ddl.sql 复制到 Oracle SQL Developer 或 SQL*Plus 中运行"
    echo "    输出文件: tables_mysql.sql（可在 MySQL 中执行）"
    ;;

  *)
    echo "用法: $0 [ddl|data|all|ddl-only-sql] [表名(逗号分隔)]"
    echo ""
    echo "   ./run_migration.sh all           # 建表 + 迁移全部表"
    echo "   ./run_migration.sh all EMP,DEPT   # 仅迁移 EMP,DEPT 表"
    echo "   ./run_migration.sh ddl            # 仅在 MySQL 建表"
    echo "   ./run_migration.sh data           # 仅迁移数据"
    echo "   ./run_migration.sh data EMP,DEPT  # 仅迁移指定表"
    echo "   ./run_migration.sh ddl-only-sql   # 生成 Oracle 原生 DDL 映射 SQL"
    exit 1
    ;;
esac
exit 0
