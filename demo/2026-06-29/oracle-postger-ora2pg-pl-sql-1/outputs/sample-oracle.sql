================================================================================
  Oracle => PostgreSQL 迁移测试样例数据 (Oracle SQL)
================================================================================
  用途：在 Oracle 中创建包含各类对象的测试 Schema，
        用于验证 ora2pg 的迁移转换效果。
  适用数据库：Oracle 19c+ / Oracle Free (23c)
  执行方式：sqlplus system/oracle@//localhost:1521/FREE @sample-oracle.sql
================================================================================

-- ============================================================================
-- 1. 创建测试用户（可选，也可以直接用 SYSTEM）
-- ============================================================================
-- 如果要创建独立用户测试，取消下面注释
/*
CREATE USER migration_test IDENTIFIED BY test_pass;
GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE PROCEDURE, CREATE TRIGGER, CREATE SEQUENCE TO migration_test;
GRANT UNLIMITED TABLESPACE TO migration_test;
ALTER SESSION SET CURRENT_SCHEMA = migration_test;
*/

-- 切换到 SYSTEM 或 migration_test
ALTER SESSION SET CURRENT_SCHEMA = SYSTEM;


-- ============================================================================
-- 2. 清理旧对象（可重复执行）
-- ============================================================================
BEGIN
  FOR x IN (SELECT object_name, object_type FROM user_objects
             WHERE object_type IN ('TABLE','VIEW','INDEX','SEQUENCE',
                                   'PROCEDURE','FUNCTION','TRIGGER','PACKAGE')
             ORDER BY object_type)
  LOOP
    BEGIN
      IF x.object_type = 'TABLE' THEN
        EXECUTE IMMEDIATE 'DROP ' || x.object_type || ' "' || x.object_name || '" CASCADE CONSTRAINTS';
      ELSE
        EXECUTE IMMEDIATE 'DROP ' || x.object_type || ' "' || x.object_name || '"';
      END IF;
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
  END LOOP;
END;
/


-- ============================================================================
-- 3. 创建序列
-- ============================================================================
CREATE SEQUENCE seq_emp_id START WITH 1001 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_dept_id START WITH 10 INCREMENT BY 10 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_order_id START WITH 10000 INCREMENT BY 1 CACHE 20;


-- ============================================================================
-- 4. 创建表（覆盖各种 Oracle 数据类型）
-- ============================================================================

-- 4.1 部门表
CREATE TABLE dept (
  deptno     NUMBER(2) PRIMARY KEY,
  dname      VARCHAR2(30),
  loc        VARCHAR2(50),
  created_at DATE DEFAULT SYSDATE
);

-- 4.2 员工表（含各种数据类型）
CREATE TABLE emp (
  empno      NUMBER(4) PRIMARY KEY,
  ename      VARCHAR2(30) NOT NULL,
  job        VARCHAR2(20) DEFAULT 'CLERK',
  mgr        NUMBER(4) REFERENCES emp(empno),
  hiredate   DATE DEFAULT SYSDATE,
  sal        NUMBER(7,2) CHECK (sal > 0),
  comm       NUMBER(7,2),
  deptno     NUMBER(2) REFERENCES dept(deptno),
  email      VARCHAR2(100),
  phone      VARCHAR2(20),
  active_flag CHAR(1) DEFAULT 'Y',
  notes      CLOB,
  photo      BLOB,
  salary_bonus NUMBER(10,2),
  CONSTRAINT chk_emp_active CHECK (active_flag IN ('Y','N'))
);

-- 4.3 订单表（含时间戳、时间区间类型）
CREATE TABLE orders (
  order_id    NUMBER(6),
  customer_id NUMBER(6) NOT NULL,
  order_date  TIMESTAMP DEFAULT SYSTIMESTAMP,
  ship_date   TIMESTAMP,
  total_amount NUMBER(10,2),
  status      VARCHAR2(20) DEFAULT 'PENDING',
  description CLOB,
  created_by  VARCHAR2(60),
  created_at  TIMESTAMP WITH TIME ZONE DEFAULT SYSTIMESTAMP,
  CONSTRAINT pk_orders PRIMARY KEY (order_id),
  CONSTRAINT chk_order_status CHECK (status IN ('PENDING','SHIPPED','DELIVERED','CANCELLED'))
);

-- 4.4 订单明细表（外键+联合主键）
CREATE TABLE order_items (
  order_id    NUMBER(6),
  item_id     NUMBER(3),
  product_name VARCHAR2(100) NOT NULL,
  quantity    NUMBER(5) DEFAULT 1,
  unit_price  NUMBER(10,2),
  line_total  NUMBER(12,2),
  CONSTRAINT pk_order_items PRIMARY KEY (order_id, item_id),
  CONSTRAINT fk_items_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 4.5 产品表（含 XML / JSON 测试）
CREATE TABLE products (
  product_id   NUMBER(6) PRIMARY KEY,
  product_name VARCHAR2(100) NOT NULL,
  category     VARCHAR2(50),
  price        NUMBER(10,2),
  stock_qty    NUMBER(6) DEFAULT 0,
  description  CLOB,
  attributes   VARCHAR2(2000),   -- 模拟 JSON 字符串
  UNIQUE (product_name)
);

-- 4.6 临时表（会话级）
CREATE GLOBAL TEMPORARY TABLE temp_work_log (
  log_id    NUMBER(6),
  empno     NUMBER(4),
  action    VARCHAR2(200),
  log_time  DATE DEFAULT SYSDATE
) ON COMMIT DELETE ROWS;

-- 4.7 日志表（无主键，只有索引）
CREATE TABLE audit_log (
  log_id      NUMBER(10),
  table_name  VARCHAR2(60),
  action_type VARCHAR2(10),
  old_data    CLOB,
  new_data    CLOB,
  changed_by  VARCHAR2(60),
  changed_at  DATE DEFAULT SYSDATE
);


-- ============================================================================
-- 5. 插入测试数据
-- ============================================================================

-- 部门数据
INSERT INTO dept (deptno, dname, loc) VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO dept (deptno, dname, loc) VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO dept (deptno, dname, loc) VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO dept (deptno, dname, loc) VALUES (40, 'OPERATIONS', 'BOSTON');

-- 员工数据
INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno, email, active_flag, notes)
VALUES (7369, 'SMITH',  'CLERK',     7902, TO_DATE('17-12-1980','DD-MM-YYYY'), 800,  NULL, 20, 'smith@test.com', 'Y',
        'First employee');

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno, email, active_flag)
VALUES (7499, 'ALLEN',  'SALESMAN',  7698, TO_DATE('20-02-1981','DD-MM-YYYY'), 1600, 300,  30, 'allen@test.com', 'Y');

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno, email, active_flag)
VALUES (7521, 'WARD',   'SALESMAN',  7698, TO_DATE('22-02-1981','DD-MM-YYYY'), 1250, 500,  30, 'ward@test.com', 'Y');

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno, email, active_flag)
VALUES (7566, 'JONES',  'MANAGER',   7839, TO_DATE('02-04-1981','DD-MM-YYYY'), 2975, NULL, 20, 'jones@test.com', 'Y');

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno, email, active_flag)
VALUES (7654, 'MARTIN', 'SALESMAN',  7698, TO_DATE('28-09-1981','DD-MM-YYYY'), 1250, 1400, 30, 'martin@test.com', 'Y');

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno, email, active_flag)
VALUES (7698, 'BLAKE',  'MANAGER',   7839, TO_DATE('01-05-1981','DD-MM-YYYY'), 2850, NULL, 30, 'blake@test.com', 'Y');

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno, email, active_flag)
VALUES (7782, 'CLARK',  'MANAGER',   7839, TO_DATE('09-06-1981','DD-MM-YYYY'), 2450, NULL, 10, 'clark@test.com', 'Y');

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno, email, active_flag)
VALUES (7788, 'SCOTT',  'ANALYST',   7566, TO_DATE('09-12-1982','DD-MM-YYYY'), 3000, NULL, 20, 'scott@test.com', 'Y');

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno, email, active_flag)
VALUES (7839, 'KING',   'PRESIDENT', NULL, TO_DATE('17-11-1981','DD-MM-YYYY'), 5000, NULL, 10, 'king@test.com', 'Y');

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno, email, active_flag)
VALUES (7844, 'TURNER', 'SALESMAN',  7698, TO_DATE('08-09-1981','DD-MM-YYYY'), 1500, 0,    30, 'turner@test.com', 'Y');

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno, email, active_flag)
VALUES (7876, 'ADAMS',  'CLERK',     7788, TO_DATE('12-01-1983','DD-MM-YYYY'), 1100, NULL, 20, 'adams@test.com', 'Y');

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno, email, active_flag)
VALUES (7900, 'JAMES',  'CLERK',     7698, TO_DATE('03-12-1981','DD-MM-YYYY'), 950,  NULL, 30, 'james@test.com', 'Y');

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno, email, active_flag)
VALUES (7902, 'FORD',   'ANALYST',   7566, TO_DATE('03-12-1981','DD-MM-YYYY'), 3000, NULL, 20, 'ford@test.com', 'Y');

INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno, email, active_flag)
VALUES (7934, 'MILLER', 'CLERK',     7782, TO_DATE('23-01-1982','DD-MM-YYYY'), 1300, NULL, 10, 'miller@test.com', 'Y');

-- 产品数据
INSERT INTO products (product_id, product_name, category, price, stock_qty, attributes)
VALUES (1, 'Laptop', 'Electronics', 999.99, 50, '{"color":"silver","weight":"2kg"}');

INSERT INTO products (product_id, product_name, category, price, stock_qty, attributes)
VALUES (2, 'Keyboard', 'Electronics', 49.99, 200, '{"layout":"US","type":"mechanical"}');

INSERT INTO products (product_id, product_name, category, price, stock_qty, attributes)
VALUES (3, 'Mouse', 'Electronics', 29.99, 150, '{"type":"wireless","dpi":1600}');

-- 订单数据
INSERT INTO orders (order_id, customer_id, order_date, total_amount, status, description)
VALUES (10001, 5001, TIMESTAMP '2024-01-15 10:30:00', 1079.97, 'SHIPPED', 'First order of the year');

INSERT INTO orders (order_id, customer_id, order_date, total_amount, status, description)
VALUES (10002, 5002, TIMESTAMP '2024-02-20 14:00:00', 49.99, 'PENDING', 'Single item order');

INSERT INTO order_items (order_id, item_id, product_name, quantity, unit_price, line_total)
VALUES (10001, 1, 'Laptop', 1, 999.99, 999.99);

INSERT INTO order_items (order_id, item_id, product_name, quantity, unit_price, line_total)
VALUES (10001, 2, 'Mouse', 2, 39.99, 79.98);

INSERT INTO order_items (order_id, item_id, product_name, quantity, unit_price, line_total)
VALUES (10002, 1, 'Keyboard', 1, 49.99, 49.99);

COMMIT;


-- ============================================================================
-- 6. 创建索引
-- ============================================================================
CREATE INDEX idx_emp_dept ON emp(deptno);
CREATE INDEX idx_emp_job ON emp(job);
CREATE INDEX idx_emp_sal  ON emp(sal DESC);
CREATE INDEX idx_emp_name ON emp(UPPER(ename));           -- 函数索引
CREATE UNIQUE INDEX idx_emp_email ON emp(email);          -- 唯一索引
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_audit_log_table ON audit_log(table_name, action_type);
CREATE BITMAP INDEX idx_emp_active ON emp(active_flag);   -- 位图索引


-- ============================================================================
-- 7. 创建视图
-- ============================================================================

-- 7.1 简单视图
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT e.empno, e.ename, e.job, e.sal, e.comm,
       d.dname AS department, d.loc AS location
FROM emp e
JOIN dept d ON e.deptno = d.deptno;

-- 7.2 聚合视图
CREATE OR REPLACE VIEW v_dept_stats AS
SELECT d.deptno, d.dname,
       COUNT(e.empno) AS emp_count,
       NVL(SUM(e.sal), 0) AS total_salary,
       NVL(AVG(e.sal), 0) AS avg_salary,
       NVL(MAX(e.sal), 0) AS max_salary,
       NVL(MIN(e.sal), 0) AS min_salary
FROM dept d
LEFT JOIN emp e ON d.deptno = e.deptno
GROUP BY d.deptno, d.dname;

-- 7.3 使用 DECODE 和 ROWNUM 的视图
CREATE OR REPLACE VIEW v_emp_ranking AS
SELECT empno, ename, sal, deptno,
       DECODE(job,
         'PRESIDENT', 1,
         'MANAGER',   2,
         'ANALYST',   3,
         'SALESMAN',  4,
         'CLERK',     5,
         99) AS job_rank,
       ROWNUM AS rn
FROM emp
ORDER BY sal DESC;

-- 7.4 使用 WITH CHECK OPTION 的视图
CREATE OR REPLACE VIEW v_active_emp AS
SELECT empno, ename, job, sal, deptno, active_flag
FROM emp
WHERE active_flag = 'Y'
WITH CHECK OPTION;


-- ============================================================================
-- 8. 创建存储过程和函数
-- ============================================================================

-- 8.1 函数：计算年薪（无参数返回标量）
CREATE OR REPLACE FUNCTION fn_yearly_salary(p_empno IN NUMBER)
RETURN NUMBER
IS
  v_sal    emp.sal%TYPE;
  v_comm   emp.comm%TYPE;
  v_total  NUMBER;
BEGIN
  SELECT sal, NVL(comm, 0) INTO v_sal, v_comm
  FROM emp WHERE empno = p_empno;

  v_total := (v_sal + v_comm) * 12;
  RETURN v_total;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20001, 'Error calculating salary: ' || SQLERRM);
END;
/

-- 8.2 函数：返回 SYS_REFCURSOR
CREATE OR REPLACE FUNCTION fn_get_dept_emps(p_deptno IN NUMBER)
RETURN SYS_REFCURSOR
IS
  v_cur SYS_REFCURSOR;
BEGIN
  OPEN v_cur FOR
    SELECT empno, ename, job, sal, hiredate
    FROM emp
    WHERE deptno = p_deptno
    ORDER BY ename;
  RETURN v_cur;
END;
/

-- 8.3 函数：使用游标循环
CREATE OR REPLACE FUNCTION fn_emp_count_by_job
RETURN VARCHAR2
IS
  CURSOR c_jobs IS
    SELECT job, COUNT(*) AS cnt
    FROM emp GROUP BY job ORDER BY job;
  v_result VARCHAR2(1000) := '';
BEGIN
  FOR r IN c_jobs LOOP
    v_result := v_result || r.job || ':' || r.cnt || '; ';
  END LOOP;
  RETURN RTRIM(v_result, '; ');
END;
/

-- 8.4 过程：晋升员工（出参）
CREATE OR REPLACE PROCEDURE sp_promote_employee(
  p_empno    IN  NUMBER,
  p_new_job  IN  VARCHAR2,
  p_new_sal  IN  NUMBER,
  p_success  OUT NUMBER,
  p_message  OUT VARCHAR2
)
IS
  v_old_job emp.job%TYPE;
  v_old_sal emp.sal%TYPE;
BEGIN
  -- 获取当前信息
  SELECT job, sal INTO v_old_job, v_old_sal
  FROM emp WHERE empno = p_empno;

  -- 更新
  UPDATE emp SET job = p_new_job, sal = p_new_sal
  WHERE empno = p_empno;

  -- 写审计日志
  INSERT INTO audit_log (log_id, table_name, action_type,
    old_data, new_data, changed_by, changed_at)
  VALUES (seq_order_id.NEXTVAL, 'EMP', 'UPDATE',
    'Job: ' || v_old_job || ', Sal: ' || v_old_sal,
    'Job: ' || p_new_job || ', Sal: ' || p_new_sal,
    USER, SYSDATE);

  p_success := 1;
  p_message := 'Employee ' || p_empno || ' promoted from ' ||
               v_old_job || ' to ' || p_new_job;
  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    p_success := 0;
    p_message := 'Employee ' || p_empno || ' not found';
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK;
    p_success := 0;
    p_message := 'Duplicate value error';
  WHEN OTHERS THEN
    ROLLBACK;
    p_success := 0;
    p_message := SQLERRM;
END;
/

-- 8.5 过程：批量更新（演示 FORALL）
CREATE OR REPLACE PROCEDURE sp_bonus_all(p_percent IN NUMBER)
IS
  TYPE num_tab IS TABLE OF emp.empno%TYPE;
  l_empnos num_tab;
BEGIN
  SELECT empno BULK COLLECT INTO l_empnos FROM emp;

  FORALL i IN 1..l_empnos.COUNT
    UPDATE emp SET salary_bonus = sal * p_percent / 100
    WHERE empno = l_empnos(i);

  COMMIT;
END;
/

-- 8.6 函数：演示异常处理和 DETERMINISTIC
CREATE OR REPLACE FUNCTION fn_calculate_tax(
  p_salary    IN NUMBER,
  p_tax_rate  IN NUMBER DEFAULT 0.15
)
RETURN NUMBER
DETERMINISTIC
IS
  v_tax NUMBER;
BEGIN
  IF p_salary IS NULL THEN
    RAISE_APPLICATION_ERROR(-20002, 'Salary cannot be null');
  END IF;

  IF p_tax_rate < 0 OR p_tax_rate > 1 THEN
    RAISE_APPLICATION_ERROR(-20003, 'Tax rate must be between 0 and 1');
  END IF;

  v_tax := p_salary * p_tax_rate;
  RETURN ROUND(v_tax, 2);
END;
/


-- ============================================================================
-- 9. 创建触发器
-- ============================================================================

-- 9.1 BEFORE INSERT 触发器（自增模拟 + 默认值）
CREATE OR REPLACE TRIGGER trg_emp_before_insert
BEFORE INSERT ON emp
FOR EACH ROW
BEGIN
  IF :NEW.empno IS NULL THEN
    :NEW.empno := seq_emp_id.NEXTVAL;
  END IF;
  IF :NEW.hiredate IS NULL THEN
    :NEW.hiredate := SYSDATE;
  END IF;
END;
/

-- 9.2 BEFORE INSERT 触发器（订单号自动生成）
CREATE OR REPLACE TRIGGER trg_orders_before_insert
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
  IF :NEW.order_id IS NULL THEN
    :NEW.order_id := seq_order_id.NEXTVAL;
  END IF;
  IF :NEW.created_at IS NULL THEN
    :NEW.created_at := SYSTIMESTAMP;
  END IF;
END;
/

-- 9.3 AFTER UPDATE 触发器（审计日志）
CREATE OR REPLACE TRIGGER trg_emp_after_update
AFTER UPDATE ON emp
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (log_id, table_name, action_type,
    old_data, new_data, changed_by, changed_at)
  VALUES (
    seq_order_id.NEXTVAL, 'EMP', 'UPDATE',
    'SAL:' || :OLD.sal || ' JOB:' || :OLD.job,
    'SAL:' || :NEW.sal || ' JOB:' || :NEW.job,
    USER, SYSDATE
  );
END;
/

-- 9.4 BEFORE DELETE 触发器
CREATE OR REPLACE TRIGGER trg_emp_before_delete
BEFORE DELETE ON emp
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (log_id, table_name, action_type,
    old_data, new_data, changed_by, changed_at)
  VALUES (
    seq_order_id.NEXTVAL, 'EMP', 'DELETE',
    'EMPNO:' || :OLD.empno || ' NAME:' || :OLD.ename,
    NULL, USER, SYSDATE
  );
END;
/


-- ============================================================================
-- 10. 创建包（PACKAGE）— 模拟封装
-- ============================================================================

-- 10.1 包规范
CREATE OR REPLACE PACKAGE pkg_employee_mgmt AS

  -- 全局变量（包变量）
  g_company_name   CONSTANT VARCHAR2(30) := 'ACME CORP';
  g_debug_mode     BOOLEAN := FALSE;

  -- 函数
  FUNCTION get_employee_info(p_empno NUMBER) RETURN VARCHAR2;
  FUNCTION get_dept_total_salary(p_deptno NUMBER) RETURN NUMBER;

  -- 过程
  PROCEDURE transfer_employee(
    p_empno     IN NUMBER,
    p_new_dept  IN NUMBER,
    p_new_job   IN VARCHAR2 DEFAULT NULL
  );

  -- 游标
  CURSOR c_high_earners RETURN emp%ROWTYPE;

END pkg_employee_mgmt;
/

-- 10.2 包体
CREATE OR REPLACE PACKAGE BODY pkg_employee_mgmt AS

  -- 私有变量
  v_last_operation VARCHAR2(100);

  -- 私有函数
  FUNCTION format_salary(p_amount NUMBER) RETURN VARCHAR2 IS
  BEGIN
    RETURN '$' || TO_CHAR(NVL(p_amount, 0), '999,999.99');
  END;

  -- 公开函数：获取员工信息摘要
  FUNCTION get_employee_info(p_empno NUMBER) RETURN VARCHAR2 IS
    v_info VARCHAR2(500);
  BEGIN
    SELECT ename || ' (' || job || ') - $' ||
           TO_CHAR(sal, '999,999') || ' - ' ||
           NVL(d.dname, 'Unknown')
    INTO v_info
    FROM emp e
    LEFT JOIN dept d ON e.deptno = d.deptno
    WHERE e.empno = p_empno;

    RETURN v_info;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'Employee ' || p_empno || ' not found';
  END;

  -- 公开函数：获取部门薪资总额
  FUNCTION get_dept_total_salary(p_deptno NUMBER) RETURN NUMBER IS
    v_total NUMBER;
  BEGIN
    SELECT NVL(SUM(sal), 0) INTO v_total
    FROM emp WHERE deptno = p_deptno;
    RETURN v_total;
  END;

  -- 公开过程：调转部门
  PROCEDURE transfer_employee(
    p_empno     IN NUMBER,
    p_new_dept  IN NUMBER,
    p_new_job   IN VARCHAR2 DEFAULT NULL
  ) IS
    v_old_dept emp.deptno%TYPE;
    v_old_job  emp.job%TYPE;
  BEGIN
    -- 获取旧值
    SELECT deptno, job INTO v_old_dept, v_old_job
    FROM emp WHERE empno = p_empno;

    -- 更新
    UPDATE emp SET deptno = p_new_dept,
                   job = NVL(p_new_job, v_old_job)
    WHERE empno = p_empno;

    -- 记录
    INSERT INTO audit_log (log_id, table_name, action_type,
      old_data, new_data, changed_by)
    VALUES (
      seq_order_id.NEXTVAL, 'EMP', 'TRANSFER',
      'DEPT:' || v_old_dept || ' JOB:' || v_old_job,
      'DEPT:' || p_new_dept || ' JOB:' || NVL(p_new_job, v_old_job),
      USER
    );

    v_last_operation := 'TRANSFER:' || p_empno;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20101, 'Transfer failed: ' || SQLERRM);
  END;

  -- 包初始化部分
BEGIN
  v_last_operation := 'PACKAGE INITIALIZED';
  IF g_debug_mode THEN
    DBMS_OUTPUT.PUT_LINE(g_company_name || ' Employee Management Package Loaded');
  END IF;
END pkg_employee_mgmt;
/


-- ============================================================================
-- 11. 创建物化视图
-- ============================================================================
CREATE MATERIALIZED VIEW mv_dept_salary_summary
REFRESH COMPLETE ON DEMAND
AS
SELECT d.deptno, d.dname,
       COUNT(e.empno) AS emp_count,
       SUM(e.sal) AS total_salary,
       AVG(e.sal) AS avg_salary,
       MAX(e.sal) AS max_salary
FROM dept d
LEFT JOIN emp e ON d.deptno = e.deptno
GROUP BY d.deptno, d.dname;


-- ============================================================================
-- 12. 创建同义词（SYNONYM）
-- ============================================================================
CREATE SYNONYM emp_syn FOR emp;
CREATE SYNONYM dept_syn FOR dept;


-- ============================================================================
-- 13. 创建层级查询（CONNECT BY 示例）
-- ============================================================================
CREATE OR REPLACE VIEW v_emp_hierarchy AS
SELECT empno, ename, job, mgr,
       LEVEL AS hier_level,
       SYS_CONNECT_BY_PATH(ename, ' -> ') AS hier_path,
       CONNECT_BY_ISLEAF AS is_leaf,
       CONNECT_BY_ROOT ename AS root_name
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr
ORDER SIBLINGS BY ename;


-- ============================================================================
-- 14. 验证结果
-- ============================================================================
SET LINESIZE 200
SET PAGESIZE 100

PROMPT ====== Objects Summary ======
SELECT object_type, COUNT(*) AS count
FROM user_objects
WHERE object_type IN ('TABLE','VIEW','INDEX','PROCEDURE','FUNCTION',
                      'TRIGGER','SEQUENCE','PACKAGE','PACKAGE BODY',
                      'MATERIALIZED VIEW','SYNONYM')
GROUP BY object_type
ORDER BY object_type;

PROMPT ====== Employee Data ======
SELECT empno, ename, job, sal, deptno FROM emp ORDER BY empno;

PROMPT ====== Test Function ======
SELECT fn_yearly_salary(7369) AS yearly_sal FROM DUAL;

PROMPT ====== Test Procedure ======
VARIABLE v_success NUMBER;
VARIABLE v_msg VARCHAR2(200);
EXEC sp_promote_employee(7369, 'SENIOR CLERK', 1800, :v_success, :v_msg);
PRINT v_success v_msg;

PROMPT ====== Migration test data created successfully! ======
PROMPT Next step: run ora2pg to export and convert.
