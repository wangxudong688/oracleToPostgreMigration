# Kettle Oracle → MySQL 迁移模板

一套完整的开源 ETL 迁移模板，使用 **Pentaho Data Integration (Kettle / PDI)** 将 Oracle 数据库迁移至 MySQL。

## 文件说明

| 文件 | 作用 |
|------|------|
| `ora2mysql_copy.ktr` | 单表数据迁移转换（Oracle 表输入 → MySQL 表输出） |
| `ora2mysql_create_tables.ktr` | 自动在 MySQL 创建目标表（读取 Oracle 表结构，映射为 MySQL DDL） |
| `ora2mysql_master.kjb` | 主控作业（建表 → 逐表迁移） |
| `generate_ddl.sql` | Oracle 原生 SQL，生成 MySQL 兼容的 CREATE TABLE + 约束/索引 DDL |
| `config.properties` | 数据库连接配置 |
| `run_migration.sh` | 一键执行脚本 |

## 使用方式

### 准备工作

1. **安装 Kettle PDI**
   - 下载: https://sourceforge.net/projects/pentaho/
   - 解压后确保 `kitchen.sh` 和 `pan.sh` 在 PATH 中

2. **编辑 config.properties**，填入 Oracle 和 MySQL 的连接信息

3. **安装 MySQL JDBC 驱动**
   - 下载 `mysql-connector-java-*.jar` 放到 Kettle 的 `lib/` 目录下

### 方式一：一键全量迁移（推荐）

```bash
./run_migration.sh all         # 建表 + 全部表数据迁移
./run_migration.sh all EMP,DEPT  # 仅迁移指定表
```

### 方式二：分步执行

```bash
# 第一步：在 MySQL 创建表结构
./run_migration.sh ddl

# 第二步：迁移数据
./run_migration.sh data
```

### 方式三：在 Oracle 端生成 DDL SQL

```bash
# 将 generate_ddl.sql 复制到 Oracle SQL Developer 或 SQL*Plus 中执行
# 会生成 tables_mysql.sql，然后在 MySQL 中 source 即可
```

### 方式四：在 Kettle Spoon GUI 中打开

```bash
# 启动 Spoon
./spoon.sh

# 打开 ora2mysql_master.kjb，右键编辑参数配置连接信息
# 点击运行
```

## Oracle → MySQL 类型映射参考

| Oracle 类型 | MySQL 类型 |
|------------|-----------|
| `VARCHAR2(n)` | `VARCHAR(n)` |
| `NVARCHAR2(n)` | `VARCHAR(n)` |
| `CHAR(n)` | `CHAR(n)` |
| `NUMBER(p,s)` with s>0 | `DECIMAL(p,s)` |
| `NUMBER(p,0)` | `BIGINT` |
| `NUMBER` (无精度) | `DECIMAL(38)` |
| `DATE` | `DATETIME` |
| `TIMESTAMP` | `DATETIME(6)` |
| `CLOB` / `NCLOB` / `LONG` | `LONGTEXT` |
| `BLOB` / `RAW` / `LONG RAW` | `LONGBLOB` |
| `FLOAT` | `DOUBLE` |
| `INTEGER` | `INT` |
| `BINARY_FLOAT` | `FLOAT` |
| `BINARY_DOUBLE` | `DOUBLE` |

## 注意事项

- **大表迁移**：对于大表，建议先用 `data TABLE_NAME` 单独迁移，观察性能
- **提交频率**：`COMMIT_SIZE` 默认 1000，大表可调至 5000-10000 以提升速度
- **Oracle 分区表**：Kettle 逐表迁移不含分区逻辑，建议在 MySQL 端手动建分区表
- **序列**：Oracle 序列需要在 MySQL 端手动转换为 `AUTO_INCREMENT` 或业务层实现
- **存储过程/函数**：Oracle PL/SQL 需要手动改写为 MySQL 存储过程
- **集群环境**：可通过 `JOBS` 参数开启 Kettle 并行迁移以加速

## 结合 ora2pg 使用

如果习惯用 ora2pg 导出，可在 `ora2pg.conf` 中设置 `TYPE KETTLE`：

```ini
TYPE    KETTLE
OUTPUT  /path/to/kettle_ktr/
```

ora2pg 会为每张表生成 `.ktr` 文件，然后用 Kettle 执行即可。
