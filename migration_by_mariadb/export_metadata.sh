#!/bin/bash
# ============================================================
# 脚本名称: export_metadata.sh
# 功能描述: 导出 Oracle 数据库元数据（表结构、索引、视图等）
# 支持两种方式:
#   1. 使用 expdp 导出为 dump 文件
#   2. 使用 DBMS_METADATA 导出为 SQL 文件
# ============================================================

# ==================== 配置区域（请根据实际修改） ====================
DB_USER="your_username"
DB_PASS="your_password"
# 如果使用 CDB/PDB，需要指定服务名，如: //localhost:1521/XEPDB1
DB_CONNECT="//localhost:1521/XE"  

# expdp 相关配置
DIRECTORY_NAME="DPUMP_DIR"      # Oracle 目录对象名
DUMP_FILE="metadata_$(date +%Y%m%d_%H%M%S).dmp"
LOG_FILE="expdp_$(date +%Y%m%d_%H%M%S).log"

# SQL 导出相关配置
SQL_OUTPUT_DIR="./ddl_output"
SQL_FILE="ddl_export_$(date +%Y%m%d_%H%M%S).sql"

# ==================== 函数定义 ====================

# 打印带颜色的提示信息
print_info() {
    echo -e "\033[32m[INFO]\033[0m $1"
}

print_error() {
    echo -e "\033[31m[ERROR]\033[0m $1"
}

print_warning() {
    echo -e "\033[33m[WARNING]\033[0m $1"
}

# 检查 Oracle 环境变量
check_oracle_env() {
    if [ -z "$ORACLE_HOME" ]; then
        print_error "ORACLE_HOME 未设置，请先设置 Oracle 环境变量"
        exit 1
    fi
    
    if [ -z "$ORACLE_SID" ] && [ -z "$DB_CONNECT" ]; then
        print_warning "ORACLE_SID 未设置，将使用 DB_CONNECT 连接字符串"
    fi
    
    # 将 Oracle 工具加入 PATH
    export PATH=$ORACLE_HOME/bin:$PATH
}

# 创建输出目录
create_output_dir() {
    if [ ! -d "$SQL_OUTPUT_DIR" ]; then
        mkdir -p "$SQL_OUTPUT_DIR"
        print_info "创建输出目录: $SQL_OUTPUT_DIR"
    fi
}

# ==================== 方法一：使用 expdp ====================

export_with_expdp() {
    print_info "========== 开始使用 expdp 导出元数据 =========="
    
    # 检查目录对象是否存在
    DIR_COUNT=$(sqlplus -s "$DB_USER/$DB_PASS@$DB_CONNECT" <<EOF
set pagesize 0 feedback off verify off heading off echo off
select count(*) from dba_directories where directory_name='$DIRECTORY_NAME';
exit
EOF
)
    
    # 去除可能的空格和换行
    DIR_COUNT=$(echo "$DIR_COUNT" | tr -d '[:space:]')
    
    if [ "$DIR_COUNT" -eq 0 ]; then
        print_error "目录对象 $DIRECTORY_NAME 不存在，请先创建"
        print_info "创建目录对象的 SQL: CREATE DIRECTORY $DIRECTORY_NAME AS '/path/to/directory';"
        return 1
    fi
    
    # 执行 expdp 导出
    expdp "$DB_USER/$DB_PASS@$DB_CONNECT" \
        DIRECTORY="$DIRECTORY_NAME" \
        DUMPFILE="$DUMP_FILE" \
        LOGFILE="$LOG_FILE" \
        CONTENT=METADATA_ONLY \
        SCHEMAS="$DB_USER" \
        COMPRESSION=ALL \
        PARALLEL=2
    
    if [ $? -eq 0 ]; then
        print_info "expdp 导出成功！"
        print_info "导出文件: $DUMP_FILE"
        print_info "日志文件: $LOG_FILE"
    else
        print_error "expdp 导出失败，请检查日志: $LOG_FILE"
        return 1
    fi
}

# ==================== 方法二：使用 DBMS_METADATA ====================

export_with_dbms_metadata() {
    print_info "========== 开始使用 DBMS_METADATA 导出 DDL =========="
    create_output_dir
    
    local output_file="$SQL_OUTPUT_DIR/$SQL_FILE"
    local temp_sql="$SQL_OUTPUT_DIR/temp_export.sql"
    
    # 生成 SQL 脚本（获取所有对象的 DDL）
    cat > "$temp_sql" <<'EOF'
set pagesize 0
set linesize 1000
set long 1000000
set longchunksize 1000000
set trimspool on
set heading off
set feedback off
set verify off
set echo off
set termout off

spool &1

prompt ===================================================
prompt -- 导出时间: &2
prompt ===================================================
prompt 

-- 1. 表结构
prompt -- ========== TABLE DDL ==========
SELECT DBMS_METADATA.GET_DDL('TABLE', table_name) || ';' 
FROM user_tables 
ORDER BY table_name;

-- 2. 索引
prompt -- ========== INDEX DDL ==========
SELECT DBMS_METADATA.GET_DDL('INDEX', index_name) || ';' 
FROM user_indexes 
WHERE table_name IN (SELECT table_name FROM user_tables)
ORDER BY index_name;

-- 3. 视图
prompt -- ========== VIEW DDL ==========
SELECT DBMS_METADATA.GET_DDL('VIEW', view_name) || ';' 
FROM user_views 
ORDER BY view_name;

-- 4. 存储过程
prompt -- ========== PROCEDURE DDL ==========
SELECT DBMS_METADATA.GET_DDL('PROCEDURE', object_name) || ';' 
FROM user_objects 
WHERE object_type = 'PROCEDURE'
ORDER BY object_name;

-- 5. 函数
prompt -- ========== FUNCTION DDL ==========
SELECT DBMS_METADATA.GET_DDL('FUNCTION', object_name) || ';' 
FROM user_objects 
WHERE object_type = 'FUNCTION'
ORDER BY object_name;

-- 6. 包
prompt -- ========== PACKAGE DDL ==========
SELECT DBMS_METADATA.GET_DDL('PACKAGE', object_name) || ';' 
FROM user_objects 
WHERE object_type = 'PACKAGE'
ORDER BY object_name;

-- 7. 触发器
prompt -- ========== TRIGGER DDL ==========
SELECT DBMS_METADATA.GET_DDL('TRIGGER', trigger_name) || ';' 
FROM user_triggers 
ORDER BY trigger_name;

-- 8. 序列
prompt -- ========== SEQUENCE DDL ==========
SELECT DBMS_METADATA.GET_DDL('SEQUENCE', sequence_name) || ';' 
FROM user_sequences 
ORDER BY sequence_name;

spool off
exit
EOF
    
    # 执行 SQL 脚本
    print_info "正在导出 DDL，请稍候..."
    sqlplus -s "$DB_USER/$DB_PASS@$DB_CONNECT" @"$temp_sql" "$output_file" "$(date '+%Y-%m-%d %H:%M:%S')"
    
    if [ $? -eq 0 ] && [ -f "$output_file" ]; then
        # 清理输出文件中的多余空行
        sed -i '/^$/d' "$output_file" 2>/dev/null || true
        
        print_info "DBMS_METADATA 导出成功！"
        print_info "输出文件: $output_file"
        print_info "文件大小: $(du -h "$output_file" | cut -f1)"
        
        # 统计各类对象的数量
        print_info "对象统计："
        echo "  表: $(grep -c 'CREATE TABLE' "$output_file" 2>/dev/null || echo 0)"
        echo "  索引: $(grep -c 'CREATE INDEX' "$output_file" 2>/dev/null || echo 0)"
        echo "  视图: $(grep -c 'CREATE VIEW' "$output_file" 2>/dev/null || echo 0)"
        echo "  存储过程: $(grep -c 'CREATE PROCEDURE' "$output_file" 2>/dev/null || echo 0)"
        echo "  函数: $(grep -c 'CREATE FUNCTION' "$output_file" 2>/dev/null || echo 0)"
        echo "  触发器: $(grep -c 'CREATE TRIGGER' "$output_file" 2>/dev/null || echo 0)"
        echo "  序列: $(grep -c 'CREATE SEQUENCE' "$output_file" 2>/dev/null || echo 0)"
        
        # 删除临时文件
        rm -f "$temp_sql"
    else
        print_error "DBMS_METADATA 导出失败"
        return 1
    fi
}

# ==================== 主菜单 ====================

show_menu() {
    echo ""
    echo "=========================================="
    echo "      Oracle 元数据导出工具"
    echo "=========================================="
    echo "请选择导出方式："
    echo "  1) 使用 expdp 导出为 dump 文件"
    echo "  2) 使用 DBMS_METADATA 导出为 SQL 文件"
    echo "  3) 同时使用两种方式"
    echo "  4) 退出"
    echo "=========================================="
    read -p "请输入选项 [1-4]: " choice
    echo ""
    
    case $choice in
        1)
            export_with_expdp
            ;;
        2)
            export_with_dbms_metadata
            ;;
        3)
            export_with_expdp
            echo ""
            export_with_dbms_metadata
            ;;
        4)
            print_info "退出脚本"
            exit 0
            ;;
        *)
            print_error "无效选项，请重新选择"
            show_menu
            ;;
    esac
}

# ==================== 脚本入口 ====================

main() {
    print_info "脚本开始执行..."
    
    # 检查 Oracle 环境
    check_oracle_env
    
    # 显示连接信息
    print_info "连接信息: $DB_USER@$DB_CONNECT"
    
    # 显示菜单
    show_menu
    
    print_info "========== 所有导出任务完成 =========="
}

# 执行主函数
main