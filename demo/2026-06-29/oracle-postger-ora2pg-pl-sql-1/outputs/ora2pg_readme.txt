名称 Ora2Pg - Oracle 转 PostgreSQL 数据库模式转换器

描述 Ora2Pg 是一款免费工具，用于将 Oracle 数据库迁移至与 PostgreSQL 兼容的模式。它连接到您的 Oracle 数据库，自动扫描并提取其结构或数据，然后生成可加载到 PostgreSQL 数据库的 SQL 脚本。

Ora2Pg 可用于从对 Oracle 数据库进行逆向工程，到大型企业数据库迁移，或简单地将部分 Oracle 数据复制到 PostgreSQL 数据库等各种场景。它非常易于使用，除了提供连接 Oracle 数据库所需的参数外，不需要任何 Oracle 数据库知识。

功能特性 Ora2Pg 由一个 Perl 脚本（ora2pg）和一个 Perl 模块（Ora2Pg.pm）组成。您唯一需要修改的是配置文件 ora2pg.conf，通过设置 Oracle 数据库的 DSN 以及可选的模式名称。完成后，您只需设置所需的导出类型：TABLE（含约束）、VIEW、MVIEW、TABLESPACE、SEQUENCE、INDEXES、TRIGGER、GRANT、FUNCTION、PROCEDURE、PACKAGE、PARTITION、TYPE、INSERT 或 COPY、FDW、QUERY、KETTLE、SYNONYM。

默认情况下，Ora2Pg 会将导出内容保存到文件中，您可以使用 psql 客户端将其加载到 PostgreSQL。但您也可以通过在配置文件中设置 PostgreSQL 数据库的 DSN，将数据直接导入到 PostgreSQL 数据库。借助 ora2pg.conf 的所有配置选项，您可以完全控制应导出的内容以及导出方式。

包含的功能特性：

        - 导出完整的数据库模式（表、视图、序列、索引），包括唯一约束、主键、外键和检查约束。
        - 导出用户和组的权限/特权。
        - 导出范围/列表分区和子分区。
        - 导出选定的表（通过指定表名）。
        - 将 Oracle 模式导出为 PostgreSQL 8.4+ 模式。
        - 导出预定义函数、触发器、过程、包和包体。
        - 导出完整数据或根据 WHERE 子句导出数据。
        - 全面支持将 Oracle BLOB 对象作为 PG BYTEA。
        - 将 Oracle 视图导出为 PG 表。
        - 导出 Oracle 用户定义类型。
        - 提供一些基本的 PLSQL 代码到 PLPGSQL 的自动转换。
        - 可在任何平台上运行。
        - 将 Oracle 表导出为外部数据包装器（foreign data wrapper）表。
        - 导出物化视图。
        - 显示 Oracle 数据库内容的报告。
        - Oracle 数据库的迁移成本评估。
        - Oracle 数据库的迁移难度等级评估。
        - 评估文件中 PL/SQL 代码的迁移成本。
        - 评估文件中存储的 Oracle SQL 查询的迁移成本。
        - 生成可用于 Pentaho Data Integrator (Kettle) 的 XML ktr 文件。
        - 将 Oracle locator 和空间几何数据导出到 PostGIS。
        - 将 DBLINK 导出为 Oracle FDW。
        - 将 SYNONYMS 导出为视图。
        - 将 DIRECTORY 导出为外部表或 external_file 扩展的目录。
        - 通过多个 PostgreSQL 连接分发 SQL 命令列表。
        - 在 Oracle 和 PostgreSQL 数据库之间执行差异比较以进行测试。
        - 支持 MySQL/MariaDB 和 Microsoft SQL Server 迁移。

Ora2Pg 会尽最大努力自动将您的 Oracle 数据库转换为 PostgreSQL，但仍有一些工作需要手动完成。为函数、过程、包和触发器生成的 Oracle 特定 PL/SQL 代码必须经过审查，以匹配 PostgreSQL 语法。您可以在“从其他数据库迁移到 PostgreSQL”的 Oracle 部分（http://wiki.postgresql.org/wiki/Main_Page）找到一些将 Oracle PL/SQL 代码移植到 PostgreSQL PL/PGSQL 的有用建议。

有关 Oracle 数据库迁移报告的 HTML 示例，请参见 http://ora2pg.darold.net/report.html。

安装 所有 Perl 模块都可以在 CPAN（http://search.cpan.org/）上找到。只需在搜索框中输入模块的全名（例如：DBD::Oracle），它就会带您进入下载页面。

Ora2Pg 的发行版发布在 SF.net（https://sourceforge.net/projects/ora2pg/）。

在 Windows(TM) 上，您应该安装 Strawberry Perl（http://strawberryperl.com/）以及相应操作系统的 Oracle 客户端。从 5.32 版本开始，该 Perl 发行版包含预编译的 DBD::Oracle 和 DBD::Pg 驱动程序。

必需组件 系统上必须安装 Oracle Instant Client 或完整的 Oracle 安装。您可以从 Oracle 下载中心下载 RPM：

rpm -ivh oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm
    rpm -ivh oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm
    rpm -ivh oracle-instantclient12.2-jdbc-12.2.0.1.0-1.x86_64.rpm
    rpm -ivh oracle-instantclient12.2-sqlplus-12.2.0.1.0-1.x86_64.rpm

或者，只需从 Oracle 下载中心下载相应的 ZIP 归档文件，并将它们安装到您想要的位置，例如：/opt/oracle/instantclient_12_2/

您还需要一个现代的 Perl 发行版（Perl 5.10 或更高版本）。要连接到数据库并进行迁移，您需要 DBI Perl 模块版本 > 1.614。要迁移 Oracle 数据库，需要安装 DBD::Oracle Perl 模块。

要安装并使 DBD::Oracle 正常工作，您需要安装 Oracle 客户端库，并且必须定义 ORACLE_HOME 环境变量。

如果您计划导出 MySQL 数据库，则需要安装 Perl 模块 DBD::MySQL，这需要安装 MySQL 客户端库。

如果您计划导出 SQL Server 数据库，则需要安装 Perl 模块 DBD::ODBC，这需要安装 unixODBC 包。

在某些 Perl 发行版上，您可能需要安装 Time::HiRes Perl 模块。

如果您的发行版不包含这些 Perl 模块，您可以使用 CPAN 安装它们：

        perl -MCPAN -e 'install DBD::Oracle'
        perl -MCPAN -e 'install DBD::MySQL'
        perl -MCPAN -e 'install DBD::ODBC'
        perl -MCPAN -e 'install Time::HiRes'

否则，请使用您的发行版提供的软件包。

可选组件 默认情况下，Ora2Pg 将导出内容转储到平面文件。要将它们加载到您的 PostgreSQL 数据库，您需要 PostgreSQL 客户端（psql）。如果运行 Ora2Pg 的主机上没有 psql，您始终可以将这些文件传输到安装了 psql 客户端的主机。如果您希望“即时”加载导出内容，则需要 Perl 模块 DBD::Pg。

Ora2Pg 允许您将所有输出转储到压缩的 gzip 文件中。要执行此操作，您需要 Compress::Zlib Perl 模块，或者，如果您更喜欢使用 bzip2 压缩，则程序 bzip2 必须在您的 PATH 中可用。

如果您的发行版不包含这些 Perl 模块，您可以使用 CPAN 安装它们：

        perl -MCPAN -e 'install DBD::Pg'
        perl -MCPAN -e 'install Compress::Zlib'

否则，请使用您的发行版提供的软件包。

SQL Server 安装说明 对于 SQL Server，您需要安装 unixodbc 包和 Perl DBD::ODBC 驱动程序：

    sudo apt install unixodbc
        sudo apt install libdbd-odbc-perl

或者

        sudo yum install unixodbc
        sudo yum install perl-DBD-ODBC
        sudo yum install perl-DBD-Pg

然后安装 Microsoft ODBC Driver for SQL Server。按照此处针对您的操作系统的说明进行操作：

        https://docs.microsoft.com/fr-fr/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver16

完成后，通过调整 SQL Server ODBC 驱动程序版本，在 /etc/odbcinst.ini 文件中设置以下内容：

        [msodbcsql18]
        Description=Microsoft ODBC Driver 18 for SQL Server
        Driver=/opt/microsoft/msodbcsql18/lib64/libmsodbcsql-18.0.so.1.1
        UsageCount=1

有关如何使用驱动程序连接到您的 MSSQL 数据库，请参见 ORACLE_DSN。

安装 Ora2Pg 与任何其他 Perl 模块一样，可以使用以下命令安装 Ora2Pg：

    tar xjf ora2pg-x.x.tar.bz2
        cd ora2pg-x.x/
        perl Makefile.PL
        make && make install

这会将 Ora2Pg.pm 安装到您的站点 Perl 存储库中，将 ora2pg 安装到 /usr/local/bin/，并将 ora2pg.conf 安装到 /etc/ora2pg/。

在 Windows(TM) 上，您可以改用：

        perl Makefile.PL
        gmake && gmake install

这会将脚本和库安装到您的 Perl 站点安装目录，并将 ora2pg.conf 文件以及所有文档文件安装到 C:\ora2pg\。

要将 ora2pg 安装到非默认目录，只需使用以下命令：

        perl Makefile.PL PREFIX=<your_install_dir>
        make && make install

然后在使用 Ora2Pg 之前，将 PERL5LIB 设置为您的安装目录路径。

        export PERL5LIB=<your_install_dir>
        ora2pg -c config/ora2pg.conf -t TABLE -b outdir/

打包 如果您想为您首选的 Linux 发行版构建二进制包，请查看源 tarball 的 packaging/ 目录。它包含构建 RPM、Slackware 和 Debian 包所需的一切。请参阅该目录中的 README 文件。

安装 DBD::Oracle Ora2Pg 需要 Perl 模块 DBD::Oracle，以便通过 Perl DBI 连接到 Oracle 数据库。您可以从 CPAN（一个 Perl 模块仓库）获取 DBD::Oracle。

以 root 用户身份设置 ORACLE_HOME 和 LD_LIBRARY_PATH 环境变量后，安装 DBD::Oracle。操作如下：

        export LD_LIBRARY_PATH=/usr/lib/oracle/12.2/client64/lib
        export ORACLE_HOME=/usr/lib/oracle/12.2/client64
        perl -MCPAN -e 'install DBD::Oracle'

如果您是首次运行，它会询问许多问题；您可以按 ENTER 键保留默认值，但您需要为 CPAN 提供一个合适的镜像站点以下载模块。如果上述方法不起作用，请通过 CPAN 手动安装：

        #perl -MCPAN -e shell
        cpan> get DBD::Oracle
        cpan> quit
        cd ~/.cpan/build/DBD-Oracle*
        export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib
        export ORACLE_HOME=/usr/lib/oracle/11.2/client64
        perl Makefile.PL
        make
        make install

安装 DBD::Oracle 需要安装三个 Oracle 包：instant-client、SDK 和 SQLplus，以及 libaio1 库。

如果您使用的是 ZIP 归档文件中的 Instant Client，则 LD_LIBRARY_PATH 和 ORACLE_HOME 将相同，并且必须设置为您安装文件的目录。例如：/opt/oracle/instantclient_12_2/

配置 配置 Ora2Pg 可以很简单，只需选择要导出的 Oracle 数据库并选择导出类型。这可以在一分钟内完成。

通过阅读本文档，您还将能够：

        - 仅选择某些表和/或列进行导出。
        - 在导出过程中重命名某些表和/或列。
        - 按照每个表的 WHERE 子句选择要导出的数据。
        - 在数据加载期间延迟数据库约束。
        - 压缩导出的数据以节省磁盘空间。
        - 以及更多。

Oracle 数据库迁移完全通过一个名为 ora2pg.conf 的配置文件控制。此文件的格式由大写的指令名称、后跟一个制表符和一个值组成。注释是以 # 开头的行。

配置指令的放置没有特定顺序，它们在配置文件中被读取时设置。

对于只接受单个值的配置指令，您可以在配置文件中多次使用它们，但只有在文件中找到的最后一次出现才会被使用。对于允许值列表的配置指令，您可以多次使用它们，值将被追加到列表中。如果您使用 IMPORT 指令加载自定义配置文件，此文件中定义的指令将从 IMPORT 指令所在的位置开始存储，因此最好将其放在配置文件的末尾。

命令行选项中设置的值将覆盖配置文件中的值。

Ora2Pg 使用方法 首先，请确保库和二进制文件路径包含 Oracle Instant Client 安装：

export LD_LIBRARY_PATH=/usr/lib/oracle/11.2/client64/lib export PATH="/usr/lib/oracle/11.2/client64/bin:$PATH"

默认情况下，Ora2Pg 会查找 /etc/ora2pg/ora2pg.conf 配置文件。如果该文件存在，您只需执行：

        /usr/local/bin/ora2pg

或者在 Windows(TM) 系统下，运行位于 Perl bin 目录中的 ora2pg.bat 文件。Windows(TM) 用户还可以在 C:\ora2pg 中找到模板配置文件。

如果您想使用其他配置文件，只需将路径作为命令行参数传入：

        /usr/local/bin/ora2pg -c /etc/ora2pg/new_ora2pg.conf

以下是使用 ora2pg 时可用的所有命令行参数：

用法：ora2pg [-dhpqv --estimate_cost --dump_as_html] [--选项 值]

    -a | --allow str  : 允许导出的对象的逗号分隔列表。也可与 SHOW_COLUMN 一起使用。
    -b | --basedir dir: 设置默认输出目录，导出产生的文件将存储在此处。
    -c | --conf file  : 设置替代默认 /etc/ora2pg/ora2pg.conf 的配置文件。
    -C | --cdc_file file: 用于在导出期间存储/读取每个表的 SCN 的文件。默认：当前目录下的 TABLES_SCN.log。这是由 --cdc_ready 选项写入的文件。
    -d | --debug      : 启用详细输出。
    -D | --data_type str : 允许在命令行进行自定义类型替换。
    -e | --exclude str: 排除导出的对象的逗号分隔列表。也可与 SHOW_COLUMN 一起使用。
    -h | --help       : 打印此简短帮助信息。
    -g | --grant_object type : 从给定的对象类型中提取权限。有关可能的值，请参见 GRANT_OBJECT 配置。
    -i | --input file : 包含要转换的 Oracle PL/SQL 代码的文件，不会初始化 Oracle 数据库连接。
    -j | --jobs num   : 发送数据到 PostgreSQL 的并行进程数。
    -J | --copies num : 从 Oracle 提取数据的并行连接数。
    -l | --log file   : 设置日志文件。默认为标准输出。
    -L | --limit num  : 从 Oracle 提取并存储在内存中然后写入的元组数，默认：10000。
    -m | --mysql      : 导出 MySQL 数据库而非 Oracle 模式。
    -M | --mssql      : 导出 Microsoft SQL Server 数据库。
    -n | --namespace schema : 设置要从中提取的 Oracle 模式。
    -N | --pg_schema schema : 设置 PostgreSQL 的 search_path。
    -o | --out file   : 设置将写入 SQL 的输出文件路径。默认：运行目录下的 output.sql。
    -O | --options    : 用于覆盖任何配置参数，可以多次使用。语法：-O "参数名=值"
    -p | --plsql      : 启用 PLSQL 到 PLPGSQL 代码的转换。
    -P | --parallel num: 同时提取的并行表数量。
    -q | --quiet      : 禁用进度条。
    -r | --relative   : 在生成的 psql 脚本中使用 \ir 而非 \i。
    -s | --source DSN : 允许设置 Oracle DBI 数据源。
    -S | --scn    SCN : 允许设置用于导出数据的 Oracle 系统更改号 (SCN)。它将用于 WHERE 子句来获取数据。用于 COPY 或 INSERT 操作。
    -t | --type export: 设置导出类型。它将覆盖配置文件中给出的类型 (TYPE)。
    -T | --temp_dir dir: 当两个或多个 ora2pg 并行运行时，设置一个不同的临时目录。
    -u | --user name  : 设置 Oracle 数据库连接用户。也可使用 ORA2PG_USER 环境变量。
    -v | --version    : 显示 Ora2Pg 版本并退出。
    -w | --password pwd : 设置 Oracle 数据库用户的密码。也可使用 ORA2PG_PASSWD 环境变量。
    -W | --where clause : 设置应用于 Oracle 查询以检索数据的 WHERE 子句。可多次使用。
    --forceowner      : 强制 ora2pg 将表和序列的所有者设置为与 Oracle 数据库中相同。如果该值设置为用户名，则该用户将用作对象所有者。默认情况下，连接到 Pg 数据库的用户将成为所有者。
    --nls_lang code: 设置 Oracle NLS_LANG 客户端编码。
    --client_encoding code: 设置 PostgreSQL 客户端编码。
    --view_as_table str: 要导出为表的视图的逗号分隔列表。
    --estimate_cost   : 结合 SHOW_REPORT 激活迁移成本评估。
    --cost_unit_value minutes: 成本评估单位的分钟数。默认：5 分钟，对应于 PostgreSQL 专家进行的迁移。如果是首次迁移，可设置为 10。
   --dump_as_html     : 强制 ora2pg 将报告以 HTML 格式转储，仅用于 SHOW_REPORT。默认以纯文本格式转储报告。
   --dump_as_csv      : 同上，但强制 ora2pg 将报告以 CSV 格式转储。
   --dump_as_json     : 同上，但强制 ora2pg 将报告以 JSON 格式转储。
   --dump_as_sheet    : 以每个数据库一行 CSV 的形式报告迁移评估。
   --init_project name: 初始化典型的 ora2pg 项目树。顶级目录将在项目基目录下创建。
   --project_base dir : 定义 ora2pg 项目树的基目录。默认为当前目录。
   --print_header     : 与 --dump_as_sheet 一起使用，以打印 CSV 标题，特别是在首次运行 ora2pg 时。
   --human_days_limit num : 设置迁移评估级别从 B 切换到 C 的人天限制数。默认为 5 人天。
   --audit_user list  : DBA_AUDIT_TRAIL 表中用于过滤查询的用户名逗号分隔列表。仅用于 SHOW_REPORT 和 QUERY 导出类型。
   --pg_dsn DSN       : 设置用于直接导入的 PostgreSQL 数据源。
   --pg_user name     : 设置要使用的 PostgreSQL 用户。
   --pg_pwd password  : 设置要使用的 PostgreSQL 密码。
   --count_rows       : 强制 ora2pg 在 TEST、TEST_COUNT 和 SHOW_TABLE 操作中执行实际的行数计数。
   --no_header        : 不将 Ora2Pg 头部信息附加到输出文件。
   --oracle_speed     : 用于了解 Oracle 能够发送数据的速度。不会处理或写入任何数据。
   --ora2pg_speed     : 用于了解 Ora2Pg 能够发送转换后数据的速度。不会写入任何内容。
   --blob_to_lo       : 将 BLOB 导出为大对象，只能与 SHOW_COLUMN、TABLE 和 INSERT 操作一起使用。
   --cdc_ready        : 使用每个表的当前 SCN 导出数据，并将它们注册到默认名为 TABLES_SCN.log 的文件中。可使用 -C | --cdc_file 更改。
   --lo_import        : 使用 psql \lo_import 命令将 BLOB 导入为大对象。可用于通过 COPY 导入数据，并在第二次传递中手动导入大对象。对于大于 1GB 的 BLOB 是必需的。有关更多说明，请参见文档。
   --mview_as_table str: 要导出为普通表的物化视图的逗号分隔列表。
   --drop_if_exists   : 如果对象存在，则在创建前删除它。
   --delete clause    : 设置在导入数据前应用于 Oracle 查询的 DELETE 子句。可多次使用。
   --oracle_fdw_prefetch: 设置 oracle_fdw 预取值。较大的值通常会加快数据传输速度，但会增加目标端的内存利用率。

有关更多帮助，请参见完整文档 https://ora2pg.darold.net/ 或使用 'man ora2pg' 查看手册页。

ora2pg 成功时返回 0，错误时返回 1。当子进程被中断并且您收到警告消息：“WARNING: an error occured during data export. Please check what's happened.” 时，它将返回 2。大多数情况下这是内存不足问题，因此首先尝试降低 DATA_LIMIT 值。

对于开发人员，可以在 Perl 脚本 ora2pg 中添加自己的自定义选项，因为 ora2pg.conf 中的任何配置指令都可以小写形式传递给新的 Ora2Pg 对象实例。请参见 ora2pg 代码了解如何添加自己的选项。

注意，通过更新 Oracle 上的统计信息可能会提高性能：

        BEGIN
        DBMS_STATS.GATHER_SCHEMA_STATS
        DBMS_STATS.GATHER_DATABASE_STATS 
        DBMS_STATS.GATHER_DICTIONARY_STATS
        END;

生成迁移模板 --project_base 和 --init_project 这两个选项指示 ora2pg 创建一个带有工作树、配置文件和用于从 Oracle 数据库导出所有对象的脚本的项目模板。以下是命令用法示例：

    ora2pg --project_base /app/migration/ --init_project test_project
        Creating project test_project.
        /app/migration/test_project/
                schema/
                        dblinks/
                        directories/
                        functions/
                        grants/
                        mviews/
                        packages/
                        partitions/
                        procedures/
                        sequences/
                        synonyms/
                        tables/
                        tablespaces/
                        triggers/
                        types/
                        views/
                sources/
                        functions/
                        mviews/
                        packages/
                        partitions/
                        procedures/
                        triggers/
                        types/
                        views/
                data/
                config/
                reports/

        Generating generic configuration file
        Creating script export_schema.sh to automate all exports.
        Creating script import_all.sh to automate all imports.

它会创建一个通用配置文件，您只需在其中定义 Oracle 数据库连接，以及一个名为 export_schema.sh 的 shell 脚本。sources/ 目录将包含 Oracle 代码，schema/ 目录将包含移植到 PostgreSQL 的代码。reports/ 目录将包含带有迁移成本评估的 HTML 和 JSON 报告。

如果您想使用自己的默认配置文件，请使用 -c 选项指定该文件的路径。如果希望 ora2pg 应用通用配置值，请将其重命名为带有 .dist 后缀；否则，配置文件将被原样复制。

设置好与 Oracle 数据库的连接后，您可以执行 export_schema.sh 脚本，该脚本将从您的 Oracle 数据库导出所有对象类型，并将 DDL 文件输出到 schema 的子目录中。导出结束时，它会给出稍后在模式导入完成并验证后导出数据的命令。

您可以选择手动加载生成的 DDL 文件，或使用第二个脚本 import_all.sh 交互式地导入这些文件。如果这种迁移对您来说不常见，建议使用这些脚本。

Oracle 数据库连接 有 5 个配置指令用于控制对 Oracle 数据库的访问。

ORACLE_HOME 用于为 DBD::Oracle Perl 模块所需的 Oracle 库设置 ORACLE_HOME 环境变量。

ORACLE_DSN
    此指令用于以标准 DBI DSN 形式设置数据源名称。例如：

            dbi:Oracle:host=oradb_host.myhost.com;sid=DB_SID;port=1521

    或者

            dbi:Oracle:DB_SID

    在 18c 上，例如可以是：

            dbi:Oracle:host=192.168.1.29;service_name=pdb1;port=1521

    对于第二种表示法，SID 应在众所周知的文件 $ORACLE_HOME/network/admin/tnsnames.ora 中声明，或在 TNS_ADMIN 环境变量给出的路径中声明。

    对于 MySQL，DSN 将如下所示：

            dbi:mysql:host=192.168.1.10;database=sakila;port=3306

    'sid' 部分被 'database' 替换。

    对于 MS SQL Server，它将如下所示：

            dbi:ODBC:driver=msodbcsql18;server=mydb.database.windows.net;database=testdb;TrustServerCertificate=yes

ORACLE_USER 和 ORACLE_PWD
    这两个指令用于定义 Oracle 数据库连接的用户和密码。请注意，如果可能，最好以 Oracle 超级管理员身份登录，以避免数据库扫描期间的权限问题并确保没有遗漏任何内容。

    如果您没有通过 ORACLE_PWD 提供凭据，并且已安装 Term::ReadKey Perl 模块，Ora2Pg 将以交互方式询问密码。如果未设置 ORACLE_USER，也会以交互方式询问。

    要以 "as sysdba" 身份连接到本地 ORACLE 实例，必须将 ORACLE_USER 设置为 "/" 并使用空密码。

    要使用 Oracle 安全外部密码存储 (SEPS) 进行连接，首先配置 Oracle Wallet，然后将 ORACLE_USER 和 ORACLE_PWD 指令都设置为特殊值 "__SEPS__"（不带引号，但带有双下划线）。

USER_GRANTS
    如果您以普通用户身份连接到 Oracle 数据库，并且没有足够的权限从 DBA_... 表中提取内容，请将此指令设置为 1。它将改用 ALL_... 表。

    警告：如果使用导出类型 GRANT，则必须将此配置选项设置为 0，否则将无法工作。

TRANSACTION
    此指令可用于更改数据导出事务的默认隔离级别。现在默认将级别设置为可序列化事务，以确保数据一致性。此指令允许的值为：

            readonly: 'SET TRANSACTION READ ONLY',
            readwrite: 'SET TRANSACTION READ WRITE',
            serializable: 'SET TRANSACTION ISOLATION LEVEL SERIALIZABLE'
            committed: 'SET TRANSACTION ISOLATION LEVEL READ COMMITTED',

    6.2 之前的版本曾将隔离级别设置为 READ ONLY 事务，但在某些情况下这会破坏数据一致性，因此现在默认设置为 SERIALIZABLE。

INPUT_FILE
    此指令不控制 Oracle 数据库连接，而是通过接受文件作为参数来完全禁用任何 Oracle 数据库的使用。将此指令设置为包含 PL/SQL Oracle 代码（如函数、过程或完整包体）的文件，可防止 Ora2Pg 连接到 Oracle 数据库，而只是将其转换工具应用于文件内容。这可用于大多数导出类型：TABLE、TRIGGER、PROCEDURE、VIEW、FUNCTION 或 PACKAGE 等。

ORA_INITIAL_COMMAND
    此指令可用于在连接后立即向 Oracle 发送初始命令。例如，在读取对象之前解锁策略或设置一些会话参数。此指令可以多次使用。

与 Oracle 服务器的数据加密 如果您的 Oracle 客户端配置文件已包含加密方法，则 DBD::Oracle 会使用这些设置在提取数据时加密连接。例如，如果您已使用以下信息配置 Oracle 客户端配置文件（sqlnet.ora 或 .sqlnet）：

    # 配置到 Oracle 的连接加密
        SQLNET.ENCRYPTION_CLIENT = required
        SQLNET.ENCRYPTION_TYPES_CLIENT = (AES256, RC4_256)
        SQLNET.CRYPTO_SEED = '应包含 10-70 个随机字符'

如上文所示设置会话加密后，任何使用 Oracle 客户端与数据库通信的工具都将具有加密连接。

例如，Perl 的 DBI 使用 DBD::Oracle，后者使用 Oracle 客户端进行实际的数据库通信。如果 Perl 使用的 Oracle 客户端安装被设置为请求加密连接，那么您的 Perl 到 Oracle 数据库的连接也将被加密。

完整详细信息请参见
https://kb.berkeley.edu/jivekb/entry.jspa?externalID=1005

测试连接 设置好 Oracle 数据库 DSN 后，您可以执行 ora2pg 来查看是否正常工作：

    ora2pg -t SHOW_VERSION -c config/ora2pg.conf

将显示 Oracle 数据库服务器版本。请花些时间在此处测试您的安装，因为大多数问题都出在这里。其他配置步骤更具技术性。

故障排除 如果 output.sql 文件除了 PostgreSQL 事务头部和尾部外没有导出任何内容，可能有两个原因：1) perl 脚本 ora2pg 输出 ORA-XXX 错误，这意味着您的 DSN 或登录信息错误 - 检查错误和您的设置，然后重试。2) perl 脚本没有任何提示，且输出文件为空：用户缺乏从数据库提取内容的权限。尝试以超级用户身份连接到 Oracle，或查看上面的 USER_GRANTS 指令以及下一节，特别是 SCHEMA 指令。

LOGFILE 默认情况下，所有消息都发送到标准输出。如果您为此指令提供文件路径，所有输出将附加到此文件。

要导出的 Oracle 模式 Oracle 数据库导出可以限制到特定的 Schema 或 Namespace；根据数据库连接用户的不同，这可能是必需的。

SCHEMA 此指令用于设置导出时使用的模式名称。 例如：

            SCHEMA  APPS

    将提取与 APPS 模式相关联的对象。

    当未提供模式名称且 EXPORT_SCHEMA 已启用时，Ora2Pg
    将从 Oracle 实例的所有模式中导出所有对象，并在其名称前加上模式名称作为前缀。

EXPORT_SCHEMA
    默认情况下，Oracle 模式不会导出到 PostgreSQL
    数据库中，所有对象都创建在默认的 Pg 命名空间下。
    如果希望同时导出此模式并在该命名空间下创建所有对象，请将 EXPORT_SCHEMA 指令设置为 1。这将在导出的 SQL 文件顶部将模式搜索路径设置为 SCHEMA 指令中设置的模式名称以及默认的 pg_catalog 模式。如果要更改此路径，请使用 PG_SCHEMA 指令。

CREATE_SCHEMA
    启用/禁用在输出文件开头生成 CREATE SCHEMA SQL 命令。默认情况下启用，并且适用于 TABLE 导出类型。

COMPILE_SCHEMA
    默认情况下，Ora2Pg 仅导出有效的 PL/SQL 代码。您可以强制 Oracle 重新编译失效的代码，以使其有机会获得有效状态，然后能够导出它。

    启用此指令可在导出代码前强制 Oracle 编译模式。当启用此指令且 SCHEMA 设置为特定模式名称时，仅会重新编译该模式中的失效对象。如果未设置 SCHEMA，则会重新编译所有模式。要强制重新编译特定模式中的失效对象，请将 COMPILE_SCHEMA 设置为您要重新编译的模式名称。

    这将要求 Oracle 验证可能在导出/导入后失效的 PL/SQL。“VALID”或“INVALID”状态适用于函数、过程、包和用户定义类型。它还涉及已禁用的触发器。

EXPORT_INVALID
    如果上述配置指令不足以验证您的 PL/SQL 代码，请启用此配置指令以允许导出所有 PL/SQL 代码，即使其标记为无效。“VALID”或“INVALID”状态适用于函数、过程、包、触发器和用户定义类型。

PG_SCHEMA
    允许您定义/强制使用的 PostgreSQL 模式。默认情况下，如果将 EXPORT_SCHEMA 设置为 1，PostgreSQL 的 search_path 将被设置为 SCHEMA 指令值所指定的导出模式名称。

    该值可以是逗号分隔的模式名称列表，但在使用 TABLE 导出类型时不行，因为在这种情况下会生成 CREATE SCHEMA 语句，而该语句不支持多个模式名称。例如，如果将 PG_SCHEMA 设置为类似 "user_schema, public"，搜索路径将设置如下：

            SET search_path = user_schema, public;

    这将强制使用（此处为 user_schema）不同于 SCHEMA 指令中设置的 Oracle 模式的另一个模式。

    您还可以通过以下方式为用于连接目标数据库的 PostgreSQL 用户设置默认 search_path：

            ALTER ROLE username SET search_path TO user_schema, public;

    在这种情况下，您无需设置 PG_SCHEMA。

SYSUSERS
    在没有明确指定模式的情况下，Ora2Pg 将导出所有不属于系统模式或角色的对象：

            SYSTEM,CTXSYS,DBSNMP,EXFSYS,LBACSYS,MDSYS,MGMT_VIEW,
            OLAPSYS,ORDDATA,OWBSYS,ORDPLUGINS,ORDSYS,OUTLN,
            SI_INFORMTN_SCHEMA,SYS,SYSMAN,WK_TEST,WKSYS,WKPROXY,
            WMSYS,XDB,APEX_PUBLIC_USER,DIP,FLOWS_020100,FLOWS_030000,
            FLOWS_040100,FLOWS_010600,FLOWS_FILES,MDDATA,ORACLE_OCM,
            SPATIAL_CSW_ADMIN_USR,SPATIAL_WFS_ADMIN_USR,XS$NULL,PERFSTAT,
            SQLTXPLAIN,DMSYS,TSMSYS,WKSYS,APEX_040000,APEX_040200,
            DVSYS,OJVMSYS,GSMADMIN_INTERNAL,APPQOSSYS,DVSYS,DVF,
            AUDSYS,APEX_030200,MGMT_VIEW,ODM,ODM_MTR,TRACESRV,MTMSYS,
            OWBSYS_AUDIT,WEBSYS,WK_PROXY,OSE$HTTP$ADMIN,
            AURORA$JIS$UTILITY$,AURORA$ORB$UNAUTHENTICATED,
            DBMS_PRIVILEGE_CAPTURE,CSMIG,MGDSYS,SDE,DBSFWUSER

    根据您的 Oracle 安装情况，可能会定义其他几个系统角色。要将这些用户添加到模式排除列表，只需将 SYSUSERS 配置指令设置为以逗号分隔的要排除的系统用户列表。例如：

            SYSUSERS        INTERNAL,SYSDBA,BI,HR,IX,OE,PM,SH

    会将用户 INTERNAL 和 SYSDBA 添加到模式排除列表中。

FORCE_OWNER
    默认情况下，数据库对象的所有者是您使用 psql 命令连接到 PostgreSQL 时所使用的用户。如果您使用其他用户（例如 postgres），可以通过将该指令设置为 1，强制 Ora2Pg 将对象所有者设置为 Oracle 数据库中使用的所有者，或者通过将指令值设置为完全不同的用户名来指定其他所有者。

FORCE_SECURITY_INVOKER
    Ora2Pg 使用在 Oracle 中设置的函数安全权限，该权限通常定义为 SECURITY DEFINER。如果您想覆盖所有函数的这些安全权限并改用 SECURITY DEFINER，请启用此指令。

USE_TABLESPACE
    启用此指令后，ora2pg 将强制使用 Oracle 数据库中定义的表空间名称导出所有表和索引。这仅适用于非 TEMP、USERS 或 SYSTEM 的表空间。

WITH_OID
    激活此指令将强制 Ora2Pg 在创建表或作为表的视图时添加 WITH (OIDS)。默认值与 PostgreSQL 相同，为禁用。

LOOK_FORWARD_FUNCTION
    用于获取当前模式导出中使用的函数/过程元信息的模式列表。当替换对带有 OUT 参数的函数的调用时，如果函数在另一个包中声明，则无法重写函数调用，因为 Ora2Pg 只知道当前模式中声明的函数。通过将此指令的值设置为逗号分隔的模式列表，Ora2Pg 将在继续当前模式导出之前，在这些包中查找所有函数/过程/包声明。

NO_FUNCTION_METADATA
    强制 Ora2Pg 不查找函数声明。请注意，这将阻止 Ora2Pg 在需要时重写函数替换调用。除非查找函数会破坏其他导出，否则不要启用此选项。

导出类型 导出操作是按照单个配置指令 'TYPE' 执行的，其他一些指令可对导出内容进行更多控制。

类型 以下是 TYPE 指令的不同取值，默认值为 TABLE：

            - TABLE：提取所有表，包括索引、主键、唯一键、外键和检查约束。
            - VIEW：仅提取视图。
            - GRANT：提取转换为 Pg 组的角色、用户以及所有对象上的授权。
            - SEQUENCE：提取所有序列及其最后位置。
            - TABLESPACE：提取表和索引的存储空间（Pg >= v8）。
            - TRIGGER：提取基于操作定义的触发器。
            - FUNCTION：提取函数。
            - PROCEDURE：提取过程。
            - PACKAGE：提取包和包体。
            - INSERT：以 INSERT 语句形式提取数据。
            - COPY：以 COPY 语句形式提取数据。
            - PARTITION：提取范围和列表类型的 Oracle 分区及其子分区。
            - TYPE：提取用户定义的 Oracle 类型。
            - FDW：将 Oracle 表导出为 Oracle、MySQL 和 SQL Server FDW 的外部表。
            - MVIEW：导出物化视图。
            - QUERY：尝试自动转换 Oracle SQL 查询。
            - KETTLE：生成供 Kettle 使用的 XML ktr 模板文件。
            - DBLINK：生成 Oracle 外部数据包装器服务器以用作 dblink。
            - SYNONYM：将 Oracle 的同义词导出为其他模式对象上的视图。
            - DIRECTORY：将 Oracle 的目录导出为 external_file 扩展对象。
            - LOAD：通过多个 PostgreSQL 连接分发查询列表。
            - TEST：在 Oracle 和 PostgreSQL 数据库之间执行差异比较。
            - TEST_COUNT：在 Oracle 和 PostgreSQL 表之间执行行数差异比较。
            - TEST_VIEW：在 Oracle 和 PostgreSQL 视图之间执行行数差异比较。
            - TEST_DATA：在两侧对行执行数据验证检查。
            - SEQUENCE_VALUES：导出用于设置序列最后值的 DDL

    一次只能执行一种类型的导出，因此 TYPE 指令必须是唯一的。如果存在多个 TYPE 指令，则仅注册文件中最后出现的那个。

    某些导出类型无法或不应直接加载到 PostgreSQL 数据库中，仍需要少量手动编辑。对于 GRANT、TABLESPACE、TRIGGER、FUNCTION、PROCEDURE、TYPE、QUERY 和 PACKAGE 导出类型尤其如此，特别是当其中包含 PL/SQL 代码或 Oracle 特定 SQL 时。

    对于 TABLESPACE，必须确保系统上存在文件路径；对于 SYNONYM，可能需要确保对象的所有者和模式与新的 PostgreSQL 数据库设计相对应。

    请注意，可以通过为 TYPE 指令提供逗号分隔的导出类型列表来链接多个导出，但在这种情况下，不得将 COPY 或 INSERT 与其他导出类型一起使用。

    Ora2Pg 将使用表继承、触发器和函数来转换 Oracle 分区。请参阅 PostgreSQL 文档：http://www.postgresql.org/docs/current/interactive/ddl-partitioning.html

    TYPE 导出允许导出用户定义的 Oracle 类型。如果不使用 --plsql 命令行参数，它会按原样转储 Oracle 用户类型；否则 Ora2Pg 将尝试将其转换为 PostgreSQL 语法。

    KETTLE 导出类型要求已定义 Oracle 和 PostgreSQL DNS。

    从 Ora2Pg v8.1 开始，新增了三种导出类型：

            SHOW_VERSION：显示 Oracle 版本
            SHOW_SCHEMA：显示数据库中可用的模式列表。
            SHOW_TABLE：显示可用的表列表。
            SHOW_COLUMN：显示可用的表列列表以及将应用的从 Oracle 到 PostgreSQL 的 Ora2PG 转换类型。如果 Oracle 对象名称中包含 PostgreSQL 保留字，它还会发出警告。

    以下是 SHOW_COLUMN 输出的示例：

            [2] TABLE CURRENT_SCHEMA (1 行)（警告：'CURRENT_SCHEMA' 是 PostgreSQL 中的保留字）
                    CONSTRAINT : NUMBER(22) => bigint（警告：'CONSTRAINT' 是 PostgreSQL 中的保留字）
                    FREEZE : VARCHAR2(25) => varchar(25)（警告：'FREEZE' 是 PostgreSQL 中的保留字）
            ...
            [6] TABLE LOCATIONS (23 行)
                    LOCATION_ID : NUMBER(4) => smallint
                    STREET_ADDRESS : VARCHAR2(40) => varchar(40)
                    POSTAL_CODE : VARCHAR2(12) => varchar(12)
                    CITY : VARCHAR2(30) => varchar(30)
                    STATE_PROVINCE : VARCHAR2(25) => varchar(25)
                    COUNTRY_ID : CHAR(2) => char(2)

    这些提取关键字仅用于显示请求的信息并退出。这使您可以快速了解将要处理的内容。

    SHOW_COLUMN 允许另一个 ora2pg 命令行选项：'--allow relname' 或 '-a relname'，用于将显示的信息限制为指定的表。

    SHOW_ENCODING 导出类型将显示 Ora2Pg 将使用的 NLS_LANG 和 CLIENT_ENCODING 值，以及 Oracle 数据库的实际编码和可用于 PostgreSQL 的相应客户端编码。

    Ora2Pg 允许您将 Oracle、MySQL 或 MSSQL 表定义导出，以用于 oracle_fdw、mysql_fdw 或 tds_fdw 外部数据包装器。通过使用 FDW 类型，您的表将按如下方式导出：

            CREATE FOREIGN TABLE oratab (
                    id        integer           NOT NULL,
                    text      character varying(30),
                    floating  double precision  NOT NULL
            ) SERVER oradb OPTIONS (table 'ORATAB');

    现在，您可以像使用常规 PostgreSQL 表一样使用该表。

    版本 10 新增了一种导出类型，用于评估要迁移的数据库内容，包括对象和完成迁移的成本：

            SHOW_REPORT：显示 Oracle 数据库内容的详细报告。

    报告示例请参见：http://ora2pg.darold.net/report.html

    还有一个包含迁移成本的更高级报告。请参阅关于迁移成本评估的专门章节。

ESTIMATE_COST
    激活迁移成本评估。必须仅与 SHOW_REPORT、FUNCTION、PROCEDURE、PACKAGE 和 QUERY 导出类型一起使用。默认禁用。您可能希望使用 --estimate_cost 命令行选项来激活此功能。请注意，启用此指令将强制激活 PLSQL_PGSQL。

COST_UNIT_VALUE
    设置迁移成本评估单位的分钟数。默认每个单位为五分钟。请参见 --cost_unit_value 在命令行更改单位值。

DUMP_AS_HTML
    默认情况下，使用 SHOW_REPORT 时，迁移报告生成为纯文本。启用此指令将强制 ora2pg 创建 HTML 格式的报告。

    报告示例请参见：http://ora2pg.darold.net/report.html

DUMP_AS_JSON
    默认情况下，使用 SHOW_REPORT 时，迁移报告生成为纯文本。启用此指令将强制 ora2pg 创建 JSON 格式的报告。

    报告示例请参见：http://ora2pg.darold.net/report.html

DUMP_AS_CSV
    默认情况下，使用 SHOW_REPORT 时，迁移报告生成为纯文本，启用此指令将强制 ora2pg 创建 CSV 格式的报告。

    报告示例请参见：http://ora2pg.darold.net/report.html

DUMP_AS_FILE_PREFIX
    默认情况下，使用 SHOW_REPORT 时，迁移报告生成到标准输出。将此指令与 DUMP_AS_* 指令结合使用将强制 ora2pg 创建具有给定扩展名和格式的报告文件。此选项允许您组合多种 DUMP_AS_* 格式。

    报告示例请参见：http://ora2pg.darold.net/report.html

HUMAN_DAYS_LIMIT
    使用此指令重新定义人员天数限制，超过该限制时迁移评估级别必须从 B 切换到 C。默认设置为 10 人天。

JOBS
    此配置指令为 COPY、FUNCTION 和 PROCEDURE 导出类型添加多进程支持。该值是要使用的进程数。默认禁用多进程。

    此指令用于设置用于并行化数据导入到 PostgreSQL 的核心数。在 FUNCTION 或 PROCEDURE 导出类型期间，每个函数将使用新进程转换为 plpgsql。当您有大量函数需要转换时，性能提升可能非常显著。

    并行处理的唯一限制是核心数和 PostgreSQL I/O 性能能力。

    在 Windows 操作系统下不起作用，会被简单禁用。

ORACLE_COPIES
    此配置指令为从 Oracle 提取数据添加多进程支持。该值是用于并行化 select 查询的进程数。默认禁用并行查询。

    并行性是通过按照 ORACLE_COPIES 给定的核心数拆分查询来实现的，如下所示：

            SELECT * FROM MYTABLE WHERE ABS(MOD(COLUMN, ORACLE_COPIES)) = CUR_PROC

    其中 COLUMN 是用于拆分的技术键，如主键或唯一键，CUR_PROC 是查询使用的当前核心。您也可以使用 DEFINED_PK 配置指令强制使用的列名。

    在 Windows 操作系统下不起作用，会被简单禁用。

DEFINED_PK
    此指令用于定义技术键，以便在 ORACLE_COPIES 变量设置的核心数之间拆分查询。例如：

            DEFINED_PK      EMPLOYEES:employee_id

    假设 -J 或 ORACLE_COPIES 设置为 8，将使用的并行查询为：

            SELECT * FROM EMPLOYEES WHERE ABS(MOD(employee_id, 8)) = N

    其中 N 是从 0 开始的当前分叉进程。

PARALLEL_TABLES
    此指令用于定义将并行处理数据提取的表数量。限制是您机器上的核心数。Ora2Pg 将为每个并行表提取打开一个数据库连接。当此指令的值大于 1 时，将使 ORACLE_COPIES 无效，但不会使 JOBS 无效，因此实际使用的进程数为 PARALLEL_TABLES * JOBS。

    请注意，当此指令设置为大于 1 时，如果您正在导出到文件，它还将自动启用 FILE_PER_TABLE 指令。这用于将表和视图导出到单独的文件中。

    使用 PARALLEL_TABLES 在 COPY、INSERT 和 TEST_DATA 操作中使用并行性。如果 --count_rows 用于实际行数计数，它也对 TEST、TEST_COUNT 和 SHOW_TABLE 有用。

DEFAULT_PARALLELISM_DEGREE
    通过将此指令设置为大于 1 的值，您可以强制 Ora2Pg 在每个用于从 Oracle 导出数据的查询中使用 /*+ PARALLEL(tbname, degree) */ 提示。值为 0 或 1 禁用并行提示。默认禁用。

FDW_SERVER
    此指令用于设置在 "CREATE SERVER name FOREIGN DATA WRAPPER <fdw_extension> ..." 命令中使用的外部数据服务器的名称。此名称随后将用于 "CREATE FOREIGN TABLE ..." SQL 命令以及使用 oracle_fdw 导入数据。默认情况下，未定义外部服务器。这仅涉及 FDW、COPY 和 INSERT 导出类型。对于 FDW 导出类型，默认值为 orcl。

FDW_IMPORT_SCHEMA
    将为数据迁移创建外部表的模式。如果您通过外部数据包装器使用多个 ora2pg 实例进行数据迁移，可能需要为每个实例更改模式名称。默认值：ora2pg_fdw_import

ORACLE_FDW_PREFETCH
    Ora2Pg 的默认行为是在用于 COPY 和 INSERT 时不为 oracle_fdw 设置 "prefetch" 选项。此指令允许设置预取。有关当前默认值，请参见 oracle_fdw 文档。

ORACLE_FDW_COPY_MODE
    当将 Ora2Pg COPY 与 oracle_fdw 一起使用时，可以使用两种不同的模式：1) "local"，它使用运行 Ora2Pg 的主机上的 psql 来处理 "TO" 二进制流；2) "server"，它使用 PostgreSQL 服务器端 COPY 来处理 "TO" 二进制流。两种模式都使用 psql 来处理 "FROM STDIN BINARY"。但是，"local" 模式在运行 Ora2Pg 的主机上运行 psql "FROM STDIN BINARY"，而 "server" 模式在 PostgreSQL 服务器上运行 psql "FROM STDIN BINARY"。"local" 模式应适用于任何基于 PostgreSQL 的系统，包括托管服务，这些服务由于权限原因预计不支持 "server" 模式。默认值为 "local"，因为它与更多配置兼容。

ORACLE_FDW_COPY_FORMAT
    当将 Ora2Pg COPY 与 oracle_fdw 一起使用时，可以使用 BINARY 或 CSV 数据格式。BINARY 提供更好的性能，但要求 FDW 和目标表之间的数据类型完全匹配。CSV 在数据类型匹配方面提供更大的灵活性：如果 FDW 和目标数据类型在功能上兼容，则可以复制列。默认值为 "binary"。

DROP_FOREIGN_SCHEMA
    默认情况下，Ora2Pg 在每次新导入之前会删除用于导入 Oracle 外部模式的临时模式 ora2pg_fdw_import。如果由于修改或使用第三方服务器而希望保留现有模式，请禁用此指令。

EXTERNAL_TO_FDW
    此指令默认启用，允许将 Oracle 的外部表导出为 file_fdw 外部表。要完全不导出这些表，请将该指令设置为 0。

INTERNAL_DATE_MAX
    从自定义类型检索的内部时间戳以下列格式提取：01-JAN-77 12.00.00.000000 AM。无法知道必须使用的确切世纪，因此默认情况下，任何低于 49 的年份将被添加到 2000 年，其他年份添加到 1900 年。您可以使用此指令更改默认值 49。这仅在您有带时间戳列的用户定义类型时相关。

AUDIT_USER
    设置必须用于从 DBA_AUDIT_TRAIL 表过滤查询的用户名逗号分隔列表。默认不扫描此表，也从不查找查询。此参数仅用于 SHOW_REPORT 和 QUERY 导出类型，且没有查询输入文件时。请注意，与使用 -i 选项或 INPUT 指令在输入时提供文件不同，查询在输出前会被规范化。

FUNCTION_CHECK
    如果要禁用 check_function_bodies，请禁用此指令。

            SET check_function_bodies = false;

    它会在 CREATE FUNCTION 期间禁用对函数体字符串的验证。默认使用 postgresql.conf 中的设置，该设置默认启用它。

ENABLE_BLOB_EXPORT
    导出 BLOB 需要时间；在某些情况下，您可能希望导出除 BLOB 列之外的所有数据。在这种情况下，禁用此指令，BLOB 列将不包含在数据导出中。请注意，目标 bytea 列没有 NOT NULL 约束。

ENABLE_CLOB_EXPORT
    与 ENABLE_BLOB_EXPORT 行为相同，但适用于 CLOB。

DATA_EXPORT_ORDER
    默认情况下，数据导出顺序将按表名排序。如果字母顺序末尾有大型表，并且您正在使用多进程，将排序顺序设置为按大小排序可能更好，这样多个小型表可以在最大的表完成之前处理。在这种情况下，将此指令设置为 size。可能的值为 name 和 size。请注意，SHOW_TABLE 和 SHOW_COLUMN 导出类型也将使用此排序顺序，而不仅仅是 COPY 或 INSERT 导出类型。如果要自定义导出顺序，只需提供一个包含要导出的有序表列表的文件名作为值。必须是每行一个表的列表，对于 Oracle 为大写。

限制要导出的对象 您可能希望仅导出 Oracle 数据库的一部分。以下是一组配置指令，允许您控制应导出数据库的哪些部分。

ALLOW 此指令允许您设置导出必须限制的对象列表，排除相同导出类型的所有其他对象。该值是一个以空格或逗号分隔的要导出的对象名称列表。您可以在列表中包含有效的正则表达式。例如：

            ALLOW           EMPLOYEES SALE_.* COUNTRIES .*_GEOM_SEQ

    将导出名称为 EMPLOYEES、COUNTRIES 的对象，所有以 'SALE_' 开头的对象以及所有名称以 '_GEOM_SEQ' 结尾的对象。对象取决于导出类型。请注意，正则表达式在 8i 数据库中不起作用，您必须改用 % 占位符，Ora2Pg 将使用 LIKE 运算符。

    这是声明将用于当前导出类型的全局过滤器的方式。您还可以使用将应用于特定对象或仅应用于其相关导出类型的扩展过滤器。例如：

            ora2pg -p -c ora2pg.conf -t TRIGGER -a 'TABLE[employees]'

    将触发器的导出限制为在 employees 表上定义的触发器。如果您想提取所有触发器，但排除某些 INSTEAD OF 触发器：

            ora2pg -c ora2pg.conf -t TRIGGER -e 'VIEW[trg_view_.*]'

    或者更复杂的形式：

            ora2pg -p -c ora2pg.conf -t TABLE -a 'TABLE[EMPLOYEES]' \
                    -e 'INDEX[emp_.*];CKEY[emp_salary_min]'

    此命令将导出 employee 表的定义，但会排除所有以 'emp_' 开头的索引和名为 'emp_salary_min' 的 CHECK 约束。

    导出分区时，您可以使用以下命令排除某些分区表：

            ora2pg -p -c ora2pg.conf -t PARTITION -e 'PARTITION[PART_199.* PART_198.*]'

    这将从导出中排除 1980 至 1999 年的分区表，但不排除主分区表。触发器也会相应调整以排除这些表。

    对于 GRANT 导出，您可以使用这种扩展形式来排除某些用户或限制导出到其他用户：

            ora2pg -p -c ora2pg.conf -t GRANT -a 'USER1 USER2'

    或者

            ora2pg -p -c ora2pg.conf -t GRANT -a 'GRANT[USER1 USER2]'

    将 GRANT 的导出限制为用户 USER1 和 USER2。但是，如果您不想为这些用户导出某些函数上的 GRANT，例如：

            ora2pg -p -c ora2pg.conf -t GRANT -a 'USER1 USER2' -e 'FUNCTION[adm_.*];PROCEDURE[adm_.*]'

    高级过滤器可能需要一些学习。

    Oracle 不允许使用前瞻表达式，因此您可能希望排除一些与您定义的 ALLOW 正则表达式匹配的对象。例如，如果您想导出所有以 E 开头的表，但不包括那些以 EXP 开头的表，则无法在单个表达式中完成。这就是为什么您可以以 ! 字符开头的正则表达式来排除紧随其后的正则表达式所匹配的对象。我们前面的例子可以写成如下形式：

            ALLOW   E.* !EXP.*

    它将被翻译成：

             REGEXP_LIKE(..., '^E.*$') AND NOT REGEXP_LIKE(..., '^EXP.*$')

    在对象搜索表达式中。

EXCLUDE
    此指令与前一个指令相反。它允许您定义一个以空格或逗号分隔的要从导出中排除的对象名称列表。您可以在列表中包含有效的正则表达式。例如：

            EXCLUDE         EMPLOYEES TMP_.* COUNTRIES

    将排除名称为 EMPLOYEES、COUNTRIES 的对象以及所有以 'tmp_' 开头的表。

    例如，您可以使用此指令禁止导出某些不需要的函数：

            EXCLUDE         write_to_.* send_mail_.*

    此示例将排除所有名称以此类正则表达式开头的函数、过程或包中的函数。请注意，正则表达式在 8i 数据库中不起作用，您必须改用 % 占位符，Ora2Pg 将使用 NOT LIKE 运算符。

    有关扩展语法，请参见上文（指令 'ALLOW'）。

NO_EXCLUDED_TABLE
    默认情况下，Ora2Pg 会从导出中排除一些 Oracle“垃圾”表，这些表永远不应成为导出的一部分。此行为会生成大量 REGEXP_LIKE 表达式，在查找表时会减慢导出速度。要禁用此行为，请启用此指令，您将不得不自己排除不需要的表或在以后进行清理。用于排除表的正则表达式在 lib/Ora2Pg.pm 中的 @EXCLUDED_TABLES 数组中定义。请注意，此行为独立于 EXCLUDE 配置指令。

VIEW_AS_TABLE
    设置要作为表导出的视图。默认情况下无。值必须是以空格或逗号分隔的视图名称或正则表达式列表。如果对象名称是视图且导出类型是 TABLE，则该视图将作为创建表语句导出。如果导出类型是 COPY 或 INSERT，则会导出相应的数据。

    有关更多详细信息，请参见“将视图导出为 PostgreSQL 表”章节。

MVIEW_AS_TABLE
    设置要作为表导出的物化视图。默认情况下无。值必须是以空格或逗号分隔的物化视图名称或正则表达式列表。如果对象名称是物化视图且导出类型是 TABLE，则该视图将作为创建表语句导出。如果导出类型是 COPY 或 INSERT，则会导出相应的数据。

NO_VIEW_ORDERING
    默认情况下，Ora2Pg 尝试对视图进行排序，以避免在导入时嵌套视图出现错误。对于大量视图，这可能需要很长时间，您可以通过启用此指令绕过此排序。

GRANT_OBJECT
    导出 GRANT 时，您可以指定一个逗号分隔的对象列表，将为这些对象导出权限。默认是导出所有对象的权限。可能的值包括：TABLE、VIEW、MATERIALIZED VIEW、SEQUENCE、PROCEDURE、FUNCTION、PACKAGE BODY、TYPE、SYNONYM、DIRECTORY。一次只允许一种对象类型。例如，如果您只想导出表上的权限，可将其设置为 TABLE。您可以使用 -g 选项覆盖它。

    使用此指令时，除非将其设置为 USER，否则会阻止用户的导出。在这种情况下，仅导出用户定义。

WHERE
    此指令允许您在转储表内容时指定 WHERE 子句过滤器。该值的构造如下：TABLE_NAME[WHERE_CLAUSE]，或者如果您对所有表只有一个 WHERE 子句，只需将 where 子句作为值。两者也可以同时存在。以下是一些示例：

            # 应用于导出中包含的所有表的全局 where 子句
            WHERE  1=1

            # 仅将 where 子句应用于表 TABLE_NAME
            WHERE  TABLE_NAME[ID1='001']

            # 对表 TABLE_NAME 和 OTHER_TABLE 应用两个不同的子句
            # 并对所有其他表应用一个关于 DATE_CREATE 的通用 where 子句
            WHERE  TABLE_NAME[ID1='001' OR ID1='002] DATE_CREATE > '2001-01-01' OTHER_TABLE[NAME='test']

    任何未包含在表名括号子句中的 WHERE 子句都将应用于所有导出的表，包括在 WHERE 子句中定义的表。这些 WHERE 子句非常有用，如果你想归档一些数据或只导出一些最近的数据。

    为了能够快速测试数据导入，将每个表的数据导出限制为前一千行是很有用的。对于 Oracle，定义以下子句：

            WHERE   ROWNUM < 1000

    对于 MySQL，使用以下子句：

            WHERE   1=1 LIMIT 1,1000

    这也可以限制为某些表的数据导出。

    命令行选项 -W 或 --where 将覆盖此指令的全局部分，如果表名相同，也会覆盖每个表的部分。

TOP_MAX
    此指令用于限制 top N 列表中显示的项目数量，例如按行数排列的表 top 列表和按兆字节排列的最大表 top 列表。默认设置为 10 个项目。

LOG_ON_ERROR
    如果您希望在发生错误时继续直接数据导入，请启用此指令。当 Ora2Pg 从 PostgreSQL 的 COPY 或 INSERT 语句中收到错误时，它会将该语句记录到输出目录中名为 TABLENAME_error.log 的文件中，并继续处理下一批数据。这样您可以尝试修复该语句并手动重新加载错误日志文件。默认禁用：出错时中止导入。

REPLACE_QUERY
    有时您可能希望从 Oracle 表中提取数据，但需要为此使用自定义查询。而不是像 Ora2Pg 那样使用“SELECT * FROM table”，而是更复杂的查询。此指令允许您覆盖 Ora2Pg 用于提取数据的查询。格式为 TABLE_NAME[SQL_QUERY]。如果您有多个表需要通过替换 Ora2Pg 查询来提取，可以定义多个 REPLACE_QUERY 行。

            REPLACE_QUERY   EMPLOYEES[SELECT e.id,e.firstname,lastname FROM EMPLOYEES e JOIN EMP_UPDT u ON (e.id=u.id AND u.cdate>'2014-08-01 00:00:00')]

全文搜索导出控制 可以使用多个指令来控制 Ora2Pg 如何导出 Oracle 的文本搜索索引。默认情况下，CONTEXT 索引将导出为 PostgreSQL FTS 索引，而 CTXCAT 索引将导出为使用 pg_trgm 扩展的索引。

CONTEXT_AS_TRGM 强制 Ora2Pg 将 Oracle Text 索引转换为使用 pg_trgm 扩展的 PostgreSQL 索引。默认情况下，CONTEXT 索引转换为 FTS 索引，CTXCAT 索引使用 pg_trgm。大多数情况下，使用 pg_trgm 就足够了，这就是此指令存在的原因。在导入对象之前，您需要在目标数据库中创建 pg_trgm 扩展：

            CREATE EXTENSION pg_trgm;

FTS_INDEX_ONLY
    默认情况下，Ora2Pg 创建基于函数的索引来转换 Oracle Text 索引：

            CREATE INDEX ON t_document
                    USING gin(to_tsvector('pg_catalog.french', title));

    您将不得不使用 to_tsvector() 重写 CONTAINS() 子句，例如：

            SELECT id,title FROM t_document
                    WHERE to_tsvector(title) @@ to_tsquery('search_word');

    要强制 Ora2Pg 为 FTS 索引创建额外的 tsvector 列和专用触发器，请禁用此指令。在这种情况下，Ora2Pg 将按如下方式添加列：ALTER TABLE t_document ADD COLUMN tsv_title tsvector; 然后，如果之前已加载数据，则更新该列以计算 FTS 向量：UPDATE t_document SET tsv_title = to_tsvector('pg_catalog.french', coalesce(title,'')); 为了在 title 列发生修改时自动更新该列，Ora2Pg 添加以下触发器：

            CREATE FUNCTION tsv_t_document_title() RETURNS trigger AS $$
            BEGIN
                   IF TG_OP = 'INSERT' OR new.title != old.title THEN
                           new.tsv_title :=
                           to_tsvector('pg_catalog.french', coalesce(new.title,''));
                   END IF;
                   return new;
            END
            $$ LANGUAGE plpgsql;
            CREATE TRIGGER trig_tsv_t_document_title BEFORE INSERT OR UPDATE
             ON t_document
             FOR EACH ROW EXECUTE PROCEDURE tsv_t_document_title();

    当 Oracle 文本索引在多个列上定义时，Ora2Pg 将使用 setweight() 按列声明的顺序设置权重。

FTS_CONFIG
    使用此指令强制使用哪个文本搜索配置。未设置时，Ora2Pg 将自动检测每个索引使用的 Oracle 词干分析器，如果未找到该信息，则使用 pg_catalog.english。

USE_UNACCENT
    如果您想以不区分重音的方式执行文本搜索，请启用此指令。Ora2Pg 将使用 unaccent() 创建一个辅助函数，并使用此函数创建 pg_trgm 索引。对于 FTS，Ora2Pg 将重新定义您的文本搜索配置，例如：

          CREATE TEXT SEARCH CONFIGURATION fr (COPY = french); 
          ALTER TEXT SEARCH CONFIGURATION fr
                  ALTER MAPPING FOR hword, hword_part, word WITH unaccent, french_stem;

    然后将 FTS_CONFIG ora2pg.conf 指令设置为 fr 而不是 pg_catalog.english。

    启用后，Ora2pg 将创建包装函数：

          CREATE OR REPLACE FUNCTION unaccent_immutable(text)
          RETURNS text AS
          $$
              SELECT public.unaccent('public.unaccent', $1);
          $$ LANGUAGE sql IMMUTABLE
             COST 1;

    索引导出如下：

          CREATE INDEX t_document_title_unaccent_trgm_idx ON t_document 
              USING gin (unaccent_immutable(title) gin_trgm_ops);

    在您的查询中，您需要在搜索中使用相同的函数才能使用基于函数的索引。例如：

            SELECT * FROM t_document
                    WHERE unaccent_immutable(title) LIKE '%donnees%';

USE_LOWER_UNACCENT
    与上述相同，但在 unaccent_immutable() 函数中调用 lower()：

          CREATE OR REPLACE FUNCTION unaccent_immutable(text)
          RETURNS text AS
          $$
              SELECT lower(public.unaccent('public.unaccent', $1));
          $$ LANGUAGE sql IMMUTABLE;

修改对象结构 Ora2Pg 的一大用途是其灵活性，能够将 Oracle 数据库复制到结构或模式不同的 PostgreSQL 数据库中。有三个配置指令允许您映射这些差异。

REORDERING_COLUMNS 启用此指令可对列进行重新排序，以最小化磁盘占用空间，从而使更多行能够容纳在一个数据页上，这是提升速度的最重要因素。默认情况下为禁用状态，即保持与 Oracle 表定义相同的列顺序，这对于大多数用途来说已经足够。此指令仅在 TABLE 导出模式下使用。

MODIFY_STRUCT
    此指令允许您为指定的表限制要提取的列。其值由空格分隔的表名列表组成，每个表名后用括号包含一组列，格式如下：

            MODIFY_STRUCT   表名(列名1,列名2,...) ...

    例如：

            MODIFY_STRUCT   T_TEST1(id,dossier) T_TEST2(id,fichier)

    这将仅从表 T_TEST1 中提取 'id' 和 'dossier' 列，从表 T_TEST2 中提取 'id' 和 'fichier' 列。此指令只能与 TABLE、COPY 或 INSERT 导出模式一起使用。在 TABLE 导出模式下，创建表的 DDL 将遵循新的列列表，并且所有指向或来自已移除列的索引或外键都不会被导出。

EXCLUDE_COLUMNS
    您可能希望从表导出中排除某些列，而不是使用 MODIFY_STRUCT 重新定义表结构。其值由空格分隔的表名列表组成，每个表名后用括号包含一组列，格式如下：

            EXCLUDE_COLUMNS 表名(列名1,列名2,...) ...

    例如：

            EXCLUDE_COLUMNS T_TEST1(id,dossier) T_TEST2(id,fichier)

    这将从导出中排除表 T_TEST1 的 'id' 和 'dossier' 列以及表 T_TEST2 的 'id' 和 'fichier' 列。此指令只能与 TABLE、COPY 或 INSERT 导出模式一起使用。在 TABLE 导出模式下，创建表的 DDL 将遵循新的列列表，并且所有指向或来自已移除列的索引或外键都不会被导出。

REPLACE_TABLES
    此指令允许您在导出期间将 Oracle 表名列表重新映射为 PostgreSQL 表名。其值是一个空格分隔的值列表，结构如下：

            REPLACE_TABLES  原始表名1:目标表名1 原始表名2:目标表名2

    Oracle 表 ORIG_TBNAME1 和 ORIG_TBNAME2 将分别重命名为 DEST_TBNAME1 和 DEST_TBNAME2。

REPLACE_COLS
    与表名类似，可以使用以下语法将列名重新映射为不同的名称：

            REPLACE_COLS    原始表名(原始列名1:新列名1,原始列名2:新列名2)

    例如：

            REPLACE_COLS    T_TEST(dico:dictionary,dossier:folder)

    这会将 Oracle 表 T_TEST 中的列 'dico' 和 'dossier' 重命名为新名称 'dictionary' 和 'folder'。

REPLACE_AS_BOOLEAN
    如果您希望在导出期间将某些 Oracle 列的类型更改为 PostgreSQL boolean 类型，可以在此处定义一个由空格分隔的表和列列表，格式如下：

            REPLACE_AS_BOOLEAN     表名1:列名1 表名1:列名2 表名2:列名2

    布尔列列表中设置的值将按照默认替换值以及在 BOOLEAN_VALUES 指令中额外设置的值替换为 't' 和 'f'。

    请注意，如果您已使用 REPLACE_TABLES 修改了表名和/或使用 REPLACE_COLS 修改了列名，则需要使用原始的表名和/或列名。

            REPLACE_COLS            表名1(旧列名1:新列名1)
            REPLACE_AS_BOOLEAN      表名1:旧列名1

    您还可以指定类型和精度，以自动将所有该类型的字段转换为布尔值。例如：

            REPLACE_AS_BOOLEAN      NUMBER:1 CHAR:1 表名1:列名1 表名1:列名2

    这也会将所有导出表中类型为 number(1) 或 char(1) 的字段替换为布尔值。

BOOLEAN_VALUES
    使用此指令可添加 Oracle 字段中可能使用的布尔值的其他定义。您必须设置一个由 TRUE:FALSE 值组成的空格分隔列表。默认情况下，Ora2Pg 识别以下值：

            BOOLEAN_VALUES          yes:no y:n 1:0 true:false enabled:disabled

    此处定义的任何值都将添加到默认列表中。

REPLACE_ZERO_DATE
    当 Ora2Pg 发现“零”日期：0000-00-00 00:00:00 时，会将其替换为 NULL。如果您的列定义了 NOT NULL 约束，这可能会成为问题。如果您无法移除该约束，可以使用此指令设置一个将被用来替代的任意日期。如果您不想使用假日期，也可以使用 -INFINITY。

INDEXES_SUFFIX
    将给定值作为后缀添加到索引名称。如果您有与表同名的索引，这会很有用。例如：

            INDEXES_SUFFIX          _idx

    这会在所有索引名称的末尾添加 _idx。这种情况不太常见，但很有帮助。

INDEXES_RENAMING
    启用此指令可使用“表名_列名”的方式重命名所有索引。对于存在多个同名索引或索引与表同名（这在 PostgreSQL 中是不允许的）的数据库，这可能非常有用。默认情况下为禁用。

USE_INDEX_OPCLASS
    操作符类 text_pattern_ops、varchar_pattern_ops 和 bpchar_pattern_ops 支持对相应类型建立 B-tree 索引。与默认操作符类的区别在于，这些值是严格按字符逐个比较的，而不是根据特定于区域设置的排序规则。这使得这些操作符类适用于涉及模式匹配表达式（LIKE 或 POSIX 正则表达式）的查询，当数据库不使用标准的“C”区域设置时。如果将此指令的值启用为 1，Ora2Pg 将强制为所有在 varchar2() 和 char() 列上定义的索引使用这些操作符。如果将其设置为大于 1 的值，它将仅更改字符限制大于或等于此值的列上的索引。例如，将其设置为 128，将为类型为 varchar2(N) 且 N >= 128 的列创建此类索引。

RENAME_PARTITION
    如果您希望重命名分区表，请启用此指令。默认情况下为禁用。如果您有多个分区表，当导出到 PostgreSQL 时，某些分区可能具有相同的名称但不同的父表。这是不允许的——表名必须是唯一的。在这种情况下，请启用此指令。分区将按照以下规则重命名：“表名”_part“位置”，其中“位置”是分区编号。对于子分区，规则是：“表名”_part“位置”_subpart“位置”。如果是默认分区/子分区：“表名”_part_default，“表名”_part“位置”_subpart_default。

DISABLE_PARTITION
    如果您不想像在 Oracle 中那样重现分区，而是希望将所有 Oracle 分区数据导出到 PostgreSQL 中的单个主表，请启用此指令。Ora2Pg 将把所有数据导出到主表名。默认设置是使用分区——Ora2Pg 会从每个分区导出数据，并将它们导入到 PostgreSQL 的专用分区表中。

PARTITION_BY_REFERENCE
    如何导出按引用分区。可能的值为 none、duplicate 或要创建的哈希分区数。默认值为 none，表示不导出按引用分区。

    值 'none' 表示不进行转换，像以前一样导出按引用分区。值 'duplicate' 将在分区表中复制被引用的列，并将被引用表的相同分区应用于该分区表。如果该值是一个数字，则该表将使用 HASH 方法进行分区，并使用该值作为模。例如，如果您将其设置为 4，它将创建 4 个 HASH 分区。

DISABLE_UNLOGGED
    默认情况下，Ora2Pg 会将具有 NOLOGGING 属性的 Oracle 表导出为 UNLOGGED 表。您可能希望完全禁用此功能，因为在 PostgreSQL 崩溃的情况下，您将丢失所有未记录日志的表中的数据。将其设置为 1 可将所有表导出为普通表。

DOUBLE_MAX_VARCHAR
    当源数据库对字符而非字节应用长度约束时，增加 varchar 的最大字符约束以支持 PostgreSQL 的双字节字符编码。默认情况下为禁用。

Oracle Spatial 到 PostGIS Ora2Pg 完全导出 Oracle 数据库中的空间对象。有一些配置指令可用于控制导出。

AUTODETECT_SPATIAL_TYPE 默认情况下，Ora2Pg 通过查看索引来确定 Oracle 下定义的空间约束类型和维度。这些约束在创建索引时传递，例如：

            CREATE INDEX ... INDEXTYPE IS MDSYS.SPATIAL_INDEX
            PARAMETERS('sdo_indx_dims=2, layer_gtype=point');

    如果未设置这些 Oracle 约束参数，默认情况下会将这些列导出为通用类型 GEOMETRY，以便能够接收任何空间类型。

    AUTODETECT_SPATIAL_TYPE 指令允许 Ora2Pg 自动检测空间列中使用的实际空间类型和维度；否则将使用非约束的“geometry”类型。启用此功能将强制 Ora2Pg 扫描 50,000 个列样本以查看所使用的 GTYPE。您可以通过将 AUTODETECT_SPATIAL_TYPE 的值设置为所需的扫描行数来增加或减少样本大小。此指令默认启用。

    例如，对于名为 shape 且定义为 Oracle 类型 SDO_GEOMETRY 的列，当 AUTODETECT_SPATIAL_TYPE 禁用时，它将被转换为：

        shape geometry(GEOMETRY) 或 shape geometry(GEOMETRYZ, 4326)

    如果启用了该指令，并且该列仅包含使用单一维度的单一几何类型，则会转换为：

        shape geometry(POLYGON, 4326) 或 shape geometry(POLYGONZ, 4326)

    即二维或三维多边形。

CONVERT_SRID
    此指令允许您控制 Oracle SRID 到标准 EPSG 的自动转换。如果启用，Ora2Pg 将使用 Oracle 函数 sdo_cs.map_oracle_srid_to_epsg() 来转换所有 SRID。默认情况下为启用。

    如果 Oracle 返回的 SDO_SRID 为 NULL，它将被替换为默认值 8307 转换后的 EPSG 值：4326（请参见 DEFAULT_SRID）。

    如果该值大于 1，所有 SRID 将被强制设为此值。在这种情况下，当 Oracle 返回空值时，DEFAULT_SRID 将不被使用，而是将值强制设为 CONVERT_SRID。

    请注意，如果您想在 Oracle 端 sdo_cs.map_oracle_srid_to_epsg() 返回 NULL 时强制设置 EPSG 值，也可以这样做：

      system@db> UPDATE sdo_coord_ref_sys SET legacy_code=41014 WHERE srid = 27572;

DEFAULT_SRID
    使用此指令可覆盖默认使用的 EPSG SRID：4326。可以被上述 CONVERT_SRID 覆盖。

GEOMETRY_EXTRACT_TYPE
    此指令可以取三个值：WKT（默认）、WKB 和 INTERNAL。当设置为 WKT 时，Ora2Pg 将使用 SDO_UTIL.TO_WKTGEOMETRY() 提取几何数据。当设置为 WKB 时，Ora2Pg 将使用 SDO_UTIL.TO_WKBGEOMETRY() 的二进制输出。如果在 Oracle 端调用这两种提取类型，速度会很慢，并且当您有大量行时，很容易出现内存不足的情况。此外，WKB 无法导出 3D 几何图形和某些几何图形（如 CURVEPOLYGON）。在这种情况下，您可以使用 INTERNAL 提取类型。它将使用纯 Perl 库将 SDO_GEOMETRY 数据转换为 WKT 表示，转换在 Ora2Pg 端完成。这是一项正在进行的工作，请在使用前验证您导出的几何数据。默认的空间对象提取类型是 INTERNAL。

POSTGIS_SCHEMA
    使用此指令可将特定模式添加到搜索路径中，以查找 PostGIS 函数。

ST_SRID_FUNCTION
    用于从 ST_Geometry 元信息中提取 SRID 的 Oracle 函数。默认值：ST_SRID，例如对于 ArcSDE，应将其设置为 sde.st_srid。

ST_DIMENSION_FUNCTION
    用于从 ST_Geometry 元信息中提取维度的 Oracle 函数。默认值：ST_DIMENSION，例如对于 ArcSDE，应将其设置为 sde.st_dimension。

ST_GEOMETRYTYPE_FUNCTION
    用于从 ST_Geometry 列中提取几何类型的 Oracle 函数。默认值：ST_GEOMETRYTYPE，例如对于 ArcSDE，应将其设置为 sde.st_geometrytype。

ST_ASBINARY_FUNCTION
    用于将 ST_Geometry 值转换为 WKB 格式的 Oracle 函数。默认值：ST_ASBINARY，例如对于 ArcSDE，应将其设置为 sde.st_asbinary。

ST_ASTEXT_FUNCTION
    用于将 ST_Geometry 值转换为 WKT 格式的 Oracle 函数。默认值：ST_ASTEXT，例如对于 ArcSDE，应将其设置为 sde.st_astext。

PostgreSQL 导入 默认情况下，转换后的 PostgreSQL 格式将写入名为 'output.sql' 的文件。命令：

psql mydb < output.sql

会将文件 output.sql 的内容导入到 PostgreSQL 数据库 mydb 中。

DATA_LIMIT
    执行 INSERT/COPY 导出时，Ora2Pg 会按 DATA_LIMIT 元组的块处理数据以提高速度。元组在写入磁盘前会先存储在内存中，因此如果您追求速度且系统资源充足，可以将此限制提高到更高的值，例如：100000 或 1000000。在 7.0 版本之前，值为 0 表示无限制，所有元组会先存储在内存中，然后再刷新到磁盘。在 7.x 版本分支中，此设置已被移除，块大小将设为默认值：10000。

BLOB_LIMIT
    当 Ora2Pg 检测到包含 BLOB 数据的表时，它会自动将此指令的值除以 10，直到其值低于 1000。您可以通过设置 BLOB_LIMIT 来控制此值。导出 BLOB 会占用大量资源；将其设置得过高可能会导致 OOM（内存溢出）错误。

CLOB_AS_BLOB
    对 CLOB 应用与 BLOB 相同的 BLOB_LIMIT 设置行为。如果您有大型 CLOB 数据，此设置特别有用。默认值：启用。

OUTPUT
    可以使用此指令更改 Ora2Pg 的输出文件名。默认值为 output.sql。如果您设置的文件名带有 .gz 或 .bz2 扩展名，输出将被自动压缩。这要求如果文件扩展名为 .gz，则需要安装 Compress::Zlib Perl 模块；如果为 .bz2 扩展名，则需要安装 bzip2 系统命令。

OUTPUT_DIR
    从 7.0 版本开始，您可以定义一个基本目录，文件将写入该目录。该目录必须存在。

BZIP2
    如果在 PATH 环境变量中找不到 bzip2 程序，此指令允许您指定 bzip2 程序的完整路径。

FILE_PER_CONSTRAINT
    允许在模式导出期间将对象约束保存到单独的文件中。该文件将命名为 CONSTRAINTS_OUTPUT，其中 OUTPUT 是相应配置指令的值。您可以使用 .gz 或 .bz2 扩展名来启用压缩。默认情况下，所有数据都保存在 OUTPUT 文件中。此指令仅适用于 TABLE 导出类型。

    可以使用 LOAD 导出类型，通过多个（-j 或 JOBS）连接并行创建约束，从而快速将约束导入 PostgreSQL。

FILE_PER_INDEX
    允许在模式导出期间将索引保存到单独的文件中。该文件将命名为 INDEXES_OUTPUT，其中 OUTPUT 是相应配置指令的值。您可以使用 .gz 或 .bz2 文件扩展名来启用压缩。默认情况下，所有数据都保存在 OUTPUT 文件中。此指令仅适用于 TABLE 和 TABLESPACE 导出类型。对于 TABLESPACE 导出，它用于将“ALTER INDEX ... TABLESPACE ...”写入一个名为 TBSP_INDEXES_OUTPUT 的单独文件，该文件可在迁移结束时、索引创建完成后加载，以移动索引。

    可以使用 LOAD 导出类型，通过多个（-j 或 JOBS）连接并行创建索引，从而快速将索引导入 PostgreSQL。

FILE_PER_FKEYS
    允许在模式导出期间将外键声明保存到单独的文件中。默认情况下，外键会导出到主输出文件或 CONSTRAINT_output.sql 文件中。启用此选项后，外键将导出到名为 FKEYS_output.sql 的文件中。

FILE_PER_TABLE
    允许将数据导出保存到每个表/视图一个文件中。文件将命名为 tablename_OUTPUT，其中 OUTPUT 是相应配置指令的值。您仍然可以在 OUTPUT 指令中使用 .gz 或 .bz2 扩展名来启用压缩。默认值 0 表示将所有数据保存到一个文件中，设置为 1 可启用此功能。此功能仅在 INSERT 或 COPY 导出类型期间可用。

FILE_PER_FUNCTION
    允许将函数、过程和触发器保存到每个对象一个文件中。文件将命名为 objectname_OUTPUT，其中 OUTPUT 是相应配置指令的值。您仍然可以在 OUTPUT 指令中使用 .gz 或 .bz2 扩展名来启用压缩。默认值 0 表示将所有内容保存到一个文件中，设置为 1 可启用此功能。此功能仅在相应的导出类型期间可用；包体导出有特殊行为。

    当导出类型为 PACKAGE 且启用了此指令时，Ora2Pg 将为每个包创建一个目录，目录名称为包的小写名称，并在该目录中为每个函数/过程创建一个文件。如果未启用此配置指令，它将为每个包创建一个文件，命名为 packagename_OUTPUT，其中 OUTPUT 是相应指令的值。

TRUNCATE_TABLE
    如果此指令设置为 1，在加载数据前会添加一条 TRUNCATE TABLE 指令。此功能仅在 INSERT 或 COPY 导出类型期间可用。

    启用后，仅当没有全局 DELETE 子句或当前表没有特定的 DELETE 子句（见下文）时，才会添加该指令。

DELETE
    支持在导入数据前包含 DELETE FROM ... WHERE 子句过滤器，以执行某些行的删除操作，而不是截断表。值的构造如下：TABLE_NAME[DELETE_WHERE_CLAUSE]，或者如果您对所有表只有一个 where 子句，只需将 delete 子句作为单个值。两者也可以同时存在。以下是一些示例：

            DELETE  1=1    # 应用于所有表并删除所有元组
            DELETE  TABLE_TEST[ID1='001']   # 仅应用于表 TABLE_TEST
            DELETE  TABLE_TEST[ID1='001' OR ID1='002] DATE_CREATE > '2001-01-01' TABLE_INFO[NAME='test']

    最后一个示例对表 TABLE_TEST 和 TABLE_INFO 应用了两个不同的 delete where 子句，并对所有其他表应用了一个关于 DATE_CREATE 的通用 delete where 子句。如果启用了 TRUNCATE_TABLE，它将应用于所有未被 DELETE 定义覆盖的表。

    这些 DELETE 子句在进行常规“更新”时可能很有用。

STOP_ON_ERROR
    将此参数设置为 0，Ora2Pg 生成的所有 SQL 脚本中将不包含 \set ON_ERROR_STOP ON 调用。默认情况下，此命令始终存在，以便脚本在遇到错误时立即中止。

COPY_FREEZE
    启用此指令可使用 COPY FREEZE 代替简单的 COPY 来导出数据，使行处于已冻结状态。这旨在作为初始数据加载的性能选项。仅当正在加载的表是在当前子事务中创建或截断的，行才会被冻结。这仅在导出到文件且未设置 -J 或 ORACLE_COPIES（或其默认值为 1）时有效。在相同条件下，它也可用于直接导入到 PostgreSQL，但 -j 或 JOBS 也必须未设置（或默认值为 1）。

CREATE_OR_REPLACE
    默认情况下，Ora2Pg 在函数和视图的 DDL 中使用 CREATE OR REPLACE。如果您不需要覆盖现有函数或视图，禁用此配置指令——DDL 将不包含 OR REPLACE。

DROP_IF_EXISTS
    要在创建对象前添加 DROP <OBJECT> IF EXISTS，请启用此指令。在迭代工作中可能很有用。默认值为禁用。

EXPORT_GTT
    PostgreSQL 本身不支持全局临时表（Global Temporary Tables），但您可以使用 pgtt 扩展来模拟此行为。启用此指令可导出全局临时表。

PGTT_NOSUPERUSER
    默认情况下，pgtt 扩展使用超级用户权限加载。如果您使用非超级用户运行生成的 SQL 脚本，请启用此选项。它将使用：

        LOAD '$libdir/plugins/pgtt';

    而非默认的：

        LOAD 'pgtt';

NO_HEADER
    启用此指令将阻止 Ora2Pg 在输出文件中打印其头部信息。只会写入转换后的代码。

PSQL_RELATIVE_PATH
    默认情况下，Ora2Pg 使用 \i psql 命令来执行生成的 SQL 文件。如果您希望使用跟随脚本执行文件的相对路径，启用此选项将使用 \ir。有关更多信息，请参见 psql 帮助。

DATA_VALIDATION_ROWS
    为进行数据验证，必须在两侧检索的行数。默认情况下比较前 10000 行。值为 0 表示比较所有行。

DATA_VALIDATION_ORDERING
    数据修改后，两侧行的顺序可能不同。在这种情况下，数据必须使用主键或唯一索引进行排序，这意味着没有此类对象的表无法进行比较。如果在数据迁移后未进行任何数据修改就执行验证，则可以对所有表进行无排序验证。

DATA_VALIDATION_ERROR
    在出现一定数量的行不匹配后停止验证表数据。默认情况下，在出现 10 行验证错误后停止。

TRANSFORM_VALUE
    使用此指令指定导出数据时应应用于列的转换。值必须是由分号分隔的列表，格式为：

       TABLE[COLUMN_NAME, <SELECT 目标列表中的替换代码>]

    例如，要在 varchar2 列中将字符串 'Oracle' 替换为 'PostgreSQL'，请使用以下设置：

       TRANSFORM_VALUE   ERROR_LOG_SAMPLE[DBMS_TYPE:regexp_replace("DBMS_TYPE",'Oracle','PostgreSQL')]

    或者要将字符串中所有 Oracle char(0) 替换为空格字符：

        TRANSFORM_VALUE   CLOB_TABLE[CHARDATA:translate("CHARDATA", chr(0), ' ')]

    该表达式将应用于从源数据库提取数据的 SQL 语句中。

NO_START_SCN
    如果不希望基于当前 SCN 导出所有数据，请启用此指令。默认情况下，Ora2Pg 首先获取当前 SCN，然后使用此 SCN 检索所有表数据，以确保在数据修改情况下的一致性。

当使用 Ora2Pg 的 INSERT 或 COPY 导出类型将数据转储到文件且启用 FILE_PER_TABLE 时，如果文件已存在，Ora2Pg 将不会再次导出数据，并会发出警告。这是为了在处理大量数据时防止重复下载表数据。要强制从这些表下载数据，必须先删除现有的输出文件。

如果要实时将数据导入 PostgreSQL 数据库，有三个配置指令用于设置 PostgreSQL 数据库连接。这仅适用于 COPY 或 INSERT 导出类型，因为对于数据库模式，这样做没有实际好处。

PG_DSN
    使用此指令通过 DBD::Pg Perl 模块设置 PostgreSQL 数据源命名空间，如下所示：

            dbi:Pg:dbname=pgdb;host=localhost;port=5432

    将连接到 localhost 上 tcp 端口 5432 的数据库 'pgdb'。

    请注意，此指令仅用于数据导出，其他导出需要通过 psql 或任何其他 PostgreSQL 客户端手动导入。

    要使用 SSL 加密连接，必须在连接字符串中添加 sslmode=require，如下所示：

            dbi:Pg:dbname=pgdb;host=localhost;port=5432;sslmode=require

PG_USER 和 PG_PWD
    这两个指令用于设置登录用户和密码。

    如果您未通过 PG_PWD 提供凭据，但已安装 Term::ReadKey Perl 模块，Ora2Pg 将以交互方式询问密码。如果未设置 PG_USER，也会以交互方式询问。

SYNCHRONOUS_COMMIT
    指定事务提交是否会等待 WAL 记录写入磁盘后，才向客户端返回“成功”指示。这相当于在 postgresql.conf 文件中设置 synchronous_commit 指令。这仅在直接将数据加载到 PostgreSQL 时使用；默认值为 off，即禁用同步提交以提高数据写入速度。某些 PostgreSQL 的修改版本（如 Greenplum）没有此设置，因此在这种情况下，将此指令设置为 1，ora2pg 将不会尝试更改该设置。

PG_INITIAL_COMMAND
    此指令可用于在连接后立即向 PostgreSQL 发送初始命令。例如设置一些会话参数。此指令可以多次使用。

INSERT_ON_CONFLICT
    启用后，Ora2Pg 会在为此类数据导出生成的所有 INSERT 语句中添加 ON CONFLICT DO NOTHING 子句。

列类型控制 PG_NUMERIC_TYPE 如果设置为 1，会将可移植的 numeric 类型替换为 PostgreSQL 内部类型。Oracle 数据类型 NUMBER(p,s) 会大致转换为 PostgreSQL 的 real 和 float 数据类型。如果您有货币字段或不希望因额外小数位而出现舍入问题，应保留与 PostgreSQL 相同的 numeric(p,s) 数据类型。仅在需要精确性时才这样做，因为使用 numeric(p,s) 比使用 real 或 double 速度慢。

PG_INTEGER_TYPE 若设为1，则用PostgreSQL内部类型替换可移植的数值类型。Oracle数据类型NUMBER(p)或NUMBER会根据精度值转换为PostgreSQL的smallint、integer或bigint数据类型。若NUMBER没有指定精度，则按DEFAULT_NUMERIC（见下文）处理。

DEFAULT_NUMERIC
    仅当PG_INTEGER_TYPE为true时，无精度的NUMBER默认转换为bigint。您可以将此值覆盖为任何PostgreSQL类型，如integer或float。

DATA_TYPE
    若在数据类型模式转换过程中遇到任何问题，可通过此指令完全控制Oracle与PostgreSQL类型之间的对应关系，从而重新定义Ora2pg中使用的数据类型转换。语法为以逗号分隔的“Oracle数据类型:PostgreSQL数据类型”列表。以下是默认使用的列表：

            DATA_TYPE       VARCHAR2:varchar,NVARCHAR2:varchar,NVARCHAR:varchar,NCHAR:char,DATE:timestamp(0),LONG:text,LONG RAW:bytea,CLOB:text,NCLOB:text,BLOB:bytea,BFILE:bytea,RAW(16):uuid,RAW(32):uuid,RAW:bytea,UROWID:oid,ROWID:oid,FLOAT:double precision,DEC:decimal,DECIMAL:decimal,DOUBLE PRECISION:double precision,INT:integer,INTEGER:integer,REAL:real,SMALLINT:smallint,BINARY_FLOAT:double precision,BINARY_DOUBLE:double precision,TIMESTAMP:timestamp,XMLTYPE:xml,BINARY_INTEGER:integer,PLS_INTEGER:integer,TIMESTAMP WITH TIME ZONE:timestamp with time zone,TIMESTAMP WITH LOCAL TIME ZONE:timestamp with time zone

    该指令及其列表定义必须在同一行。

    请注意，当遇到RAW(16)或RAW(32)列，或者RAW列的默认值为“SYS_GUID()”时，Ora2pg会自动将该列的类型转换为uuid，这在大多数情况下可能是正确的转换。在这种情况下，数据将自动迁移为“uuid-ossp”扩展提供的PostgreSQL uuid数据类型。

    若要替换具有精度和小数位数的类型，需用反斜杠转义逗号。例如，若要将所有NUMBER(*,0)替换为bigint而非numeric(38)，可添加以下内容：

           DATA_TYPE       NUMBER(*\,0):bigint

    您无需重复所有默认的类型转换，只需指定想要重写的那些即可。

    BFILE有一个特殊情况：当它们被转换为TEXT类型时，仅包含外部文件的完整路径。若将目标类型设置为BYTEA（默认值），Ora2pg会将BFILE的内容导出为bytea。第三种情况是当您将目标类型设置为EFILE时，Ora2pg会将其导出为EFILE记录：(DIRECTORY, FILENAME)。使用DIRECTORY导出类型可导出现有目录以及这些目录上的权限。

    没有可用于检索BFILE路径的SQL函数。Ora2pg必须使用DBMS_LOB包创建一个。

            CREATE OR REPLACE FUNCTION ora2pg_get_bfilename( p_bfile IN BFILE )
            RETURN VARCHAR2
            AS
                l_dir   VARCHAR2(4000);
                l_fname VARCHAR2(4000);
                l_path  VARCHAR2(4000);
            BEGIN
                dbms_lob.FILEGETNAME( p_bfile, l_dir, l_fname );
                SELECT directory_path INTO l_path FROM all_directories
                    WHERE directory_name = l_dir;
                l_dir := rtrim(l_path,'/');
                RETURN l_dir || '/' || l_fname;
            END;

    仅当Ora2pg发现包含BFILE列的表且目标类型为TEXT时，才会创建此函数。该函数会在导出结束时删除。这同时涉及COPY和INSERT导出类型。

    没有可用于将BFILE检索为EFILE记录的SQL函数，因此Ora2pg需要使用DBMS_LOB包创建一个。

            CREATE OR REPLACE FUNCTION ora2pg_get_efile( p_bfile IN BFILE )
            RETURN VARCHAR2
            AS
                l_dir   VARCHAR2(4000);
                l_fname VARCHAR2(4000);
            BEGIN
                dbms_lob.FILEGETNAME( p_bfile, l_dir, l_fname );
                RETURN '(' || l_dir || ',' || l_fnamei || ')';
            END;

    仅当Ora2pg发现包含BFILE列的表且目标类型为EFILE时，才会创建此函数。该函数会在导出结束时删除。这涉及COPY和INSERT两种导出类型。

    要设置目标类型，请使用DATA_TYPE配置指令：

            DATA_TYPE       BFILE:EFILE

    例如。

    EFILE类型是由PostgreSQL扩展external_file创建的用户定义类型，可在此处找到：https://github.com/darold/external_file。这是Oracle BFILE类型到PostgreSQL的移植。

    没有可用于检索BFILE内容的SQL函数。Ora2pg需要使用DBMS_LOB包创建一个。

            CREATE OR REPLACE FUNCTION ora2pg_get_bfile( p_bfile IN BFILE ) RETURN
            BLOB
              AS
                    filecontent BLOB := NULL;
                    src_file BFILE := NULL;
                    l_step PLS_INTEGER := 12000;
                    l_dir   VARCHAR2(4000);
                    l_fname VARCHAR2(4000);
                    offset NUMBER := 1;
              BEGIN
                IF p_bfile IS NULL THEN
                  RETURN NULL;
                END IF;

                DBMS_LOB.FILEGETNAME( p_bfile, l_dir, l_fname );
                src_file := BFILENAME( l_dir, l_fname );
                IF src_file IS NULL THEN
                    RETURN NULL;
                END IF;

                DBMS_LOB.FILEOPEN(src_file, DBMS_LOB.FILE_READONLY);
                DBMS_LOB.CREATETEMPORARY(filecontent, true);
                DBMS_LOB.LOADBLOBFROMFILE (filecontent, src_file, DBMS_LOB.LOBMAXSIZE, offset, offset);
                DBMS_LOB.FILECLOSE(src_file);
                RETURN filecontent;
            END;

    仅当Ora2pg发现包含BFILE列的表且目标类型为bytea（默认值）时，才会创建此函数。该函数会在导出结束时删除。这适用于COPY和INSERT两种导出类型。

    关于ROWID和UROWID，默认情况下它们会“逻辑地”转换为OID，但这在数据导入时会抛出错误。没有等效的数据类型，因此您可能需要使用DATA_TYPE指令更改PostgreSQL中的相应类型。您应考虑将此数据类型替换为bigserial（自增序列）、text或uuid数据类型。

MODIFY_TYPE
    有时您需要强制设置目标类型。例如，Ora2pg导出为timestamp的列可以被强制转换为date类型。其值是一个以逗号分隔的TABLE:COLUMN:TYPE结构列表。如果需要在类型定义中使用逗号或空格，必须用反斜杠转义。

            MODIFY_TYPE     TABLE1:COL3:varchar,TABLE1:COL4:decimal(9\,6)

    table1.col3的类型将被替换为varchar，table1.col4的类型将被替换为带有精度和小数位数的decimal。

    如果列的类型是用户定义类型，Ora2pg会自动检测复合类型，并使用ROW()导出其数据。某些Oracle用户定义类型只是原生类型的数组。在这种情况下，您可能希望将此列转换为PostgreSQL原生类型的简单数组。为此，只需将目标类型重新定义为所需类型，Ora2pg也会将数据转换为数组。例如，对于Oracle中的以下定义：

            CREATE OR REPLACE TYPE mem_type IS VARRAY(10) of VARCHAR2(15);
            CREATE TABLE club (Name VARCHAR2(10),
                    Address VARCHAR2(20),
                    City VARCHAR2(20),
                    Phone VARCHAR2(8),
                    Members mem_type
            );

    自定义类型“mem_type”只是一个字符串数组，可以在PostgreSQL中转换为以下内容：

            CREATE TABLE club (
                    name varchar(10),
                    address varchar(20),
                    city varchar(20),
                    phone varchar(8),
                    members text[]
            ) ;

    为此，只需按如下方式使用指令：

            MODIFY_TYPE     CLUB:MEMBERS:text[]

    Ora2pg会负责将此列的所有数据转换为正确的格式。仅支持字符和数值类型的数组。

TO_NUMBER_CONVERSION
    默认情况下，Oracle的TO_NUMBER函数调用会被转换为对numeric的强制转换。例如，TO_NUMBER('10.1234')会转换为PostgreSQL调用to_number('10.1234')::numeric。如果需要，可以通过更改配置指令的值将调用强制转换为integer或bigint。如果需要更好地控制格式，只需将其设置为值，例如：TO_NUMBER_CONVERSION 99999999999999999999.9999999999会将上面的代码转换为：TO_NUMBER('10.1234', '99999999999999999999.9999999999')。任何非numeric、integer或bigint的指令值都将被视为掩码格式。若设为none，则不进行转换。

VARCHAR_TO_TEXT
    默认情况下，无大小约束的varchar2会转换为text。如果希望保留varchar名称，请禁用此指令。

FORCE_IDENTITY_BIGINT
    通常，标识列必须是bigint才能对应自增序列，因此Ora2pg始终将其强制设为bigint。如果出于任何原因希望Ora2pg尊重您为标识列设置的DATA_TYPE，请禁用此指令。

TO_CHAR_NOTIMEZONE
    如果希望Ora2pg从TO_CHAR()函数的格式部分中移除所有时区信息，请启用此指令。默认禁用。

控制导出过程 以下其他配置指令直接与导出过程交互，让您能对数据库导出进行精细控制。

SKIP 在导出表时，您可能不希望导出所有的模式约束， SKIP 配置指令允许您指定一个以空格分隔的约束列表，这些约束不应被导出。 可能的值包括：

            - fkeys：关闭外键约束
            - pkeys：关闭主键
            - ukeys：关闭唯一列约束
            - indexes：关闭所有其他索引类型
            - checks：关闭检查约束

    例如：

            SKIP    indexes,checks

    将从导出中移除索引和检查约束。

PKEY_IN_CREATE
    如果您希望在 CREATE TABLE 语句中添加主键定义，请启用此指令。如果禁用（默认），主键定义将通过 ALTER TABLE 语句添加。如果要导出到 GreenPlum PostgreSQL 数据库，请启用此选项。

KEEP_PKEY_NAMES
    默认情况下，源 Oracle 数据库中主键和唯一键的名称会被忽略，目标 PostgreSQL 数据库中会按照 PostgreSQL 内部默认命名规则自动生成键名。如果您希望保留 Oracle 的主键和唯一键名称，请将此选项设置为 1。

FKEY_ADD_UPDATE
    当外键定义了 ON DELETE CASCADE 时，或者始终，此指令允许您为外键添加 ON UPDATE CASCADE 选项。Oracle 不支持此功能，您必须使用触发器来实现 ON UPDATE CASCADE。由于 PostgreSQL 支持此功能，您可以选择如何添加外键选项。此指令有三个值：never（默认值，意味着外键将完全按照 Oracle 中的定义声明）；delete，意味着仅当外键上已定义 ON DELETE CASCADE 时才添加 ON UPDATE CASCADE 选项；last，将强制所有外键都使用 update 选项定义。

FKEY_DEFERRABLE
    导出表时，Ora2Pg 通常会按原样导出约束，如果它们是非可延迟的，就导出为非可延迟的。然而，在尝试将数据导入到 Pg 时，非可延迟约束可能会导致问题。将 FKEY_DEFERRABLE 选项设置为 1 会使所有外键约束都导出为可延迟的。

DEFER_FKEY
    除了在 DEFER_FKEY 选项设置为 1 时导出数据外，它还会添加一条命令，在数据导出期间延迟所有外键约束，并且导入将在单个事务中完成。这仅在以下情况下有效：外键已导出为可延迟的，并且您没有使用直接导入到 PostgreSQL（未定义 PG_DSN）。然后将在事务结束时检查约束。

    如果您希望在模式导出（TABLE 导出类型）期间强制所有外键创建为可延迟且初始延迟，也可以启用此指令。

DROP_FKEY
    如果由于单个事务中的数据量过大而无法延迟外键，或者您没有将外键导出为可延迟的，或者您正在使用直接导入到 PostgreSQL，则可以使用 DROP_FKEY 指令。

    它将在所有数据导入之前删除所有外键，并在导入结束时重新创建它们。

DROP_INDEXES
    此指令允许您通过移除所有非自动索引（主键索引）并在数据导入结束时重新创建它们，从而在数据导入期间获得显著的速度提升。当然，在导入所有数据之前不导入索引和约束会更好。

DISABLE_TRIGGERS
    此指令用于在 COPY 或 INSERT 导出模式下禁用所有表上的触发器。可用值为 USER（仅禁用用户定义的触发器）和 ALL（包括 RI 系统触发器）。默认值为 0：不添加 SQL 语句在数据导入前禁用触发器。

    如果您想在数据迁移期间禁用触发器，如果以非超级用户身份连接，则将值设置为 USER；如果以 PostgreSQL 超级用户身份连接，则设置为 ALL。值 1 等同于 USER。

DISABLE_SEQUENCE
    如果设置为 1，则在 COPY 或 INSERT 导出模式下禁用对所有表上序列的修改。这用于防止在数据迁移期间更新序列。默认值为 0，即修改序列。

NOESCAPE
    默认情况下，所有非日期或时间类型的数据都会被转义。如果您遇到相关问题，可以将其设置为 1 以在数据导出期间禁用字符转义。此指令仅在 COPY 导出期间使用。有关启用/禁用 INSERT 语句中的转义，请参见 STANDARD_CONFORMING_STRINGS。

STANDARD_CONFORMING_STRINGS
    此选项控制普通字符串字面量（'...'）是否按 SQL 标准将反斜杠视为字面量。在 Ora2Pg v8.5 之前，这是默认设置，因此所有字符串都会首先被转义；现在默认启用此选项，如果未将此参数设置为 0，Ora2Pg 将使用转义字符串语法（E'...'）。这与 PostgreSQL 中相同选项的行为完全一致。此指令仅在构建 INSERT 语句的数据导出期间使用。有关在 COPY 语句中启用/禁用转义，请参见 NOESCAPE。

TRIM_TYPE
    如果您想使用 DATA_TYPE 指令将 Oracle 中的 CHAR(n) 转换为 PostgreSQL 中的 varchar(n) 或 text，您可能需要对数据进行一些修剪。默认情况下，Ora2Pg 会自动检测这种转换，并移除开头和结尾的任何空白。如果您只想移除开头的字符，将值设置为 LEADING。如果您只想移除结尾的字符，将值设置为 TRAILING。默认值为 BOTH。

TRIM_CHAR
    默认的修剪字符是空格；如果您需要更改要移除的字符，请使用此指令。例如，如果您的 char(n) 字段中有前导的 '-', 可以将其设置为 '-'。要使用空格作为修剪字符，请注释掉此指令，这是默认值。

PRESERVE_CASE
    如果您希望保留 Oracle 对象名称的大小写，请将此指令设置为 1。默认情况下，Ora2Pg 会将所有 Oracle 对象名称转换为小写。除非您在所有 SQL 脚本中都必须对对象名称使用双引号，否则不建议启用此选项。

ORA_RESERVED_WORDS
    允许使用 Oracle 保留字对列名进行转义。值是一个以逗号分隔的保留字列表。默认值：audit,comment,references。

USE_RESERVED_WORDS
    如果您的表名或列名是 PostgreSQL 的保留字，请启用此指令。Ora2Pg 将对对象名称使用双引号。

GEN_USER_PWD
    在 GRANT 导出期间，将此指令设置为 1 可为所有提取的用户用随机密码替换默认密码。

PG_SUPPORTS_MVIEW
    从 PostgreSQL 9.3 开始，支持使用 SQL 语法 'CREATE MATERIALIZED VIEW' 创建物化视图。要强制 Ora2Pg 使用原生的 PostgreSQL 支持，您必须启用此配置 - 默认启用。如果您想使用旧的方式（表和一组函数），则应禁用它。

PG_SUPPORTS_IFEXISTS
    9.x 以下版本的 PostgreSQL 不支持 DDL 语句中的 IF EXISTS。将此指令设置为 0 可防止 Ora2Pg 在所有生成的语句中添加这些关键字。默认值为 1，即启用。

PG_VERSION
    设置目标数据库的 PostgreSQL 主版本号。例如：9.6 或 13。默认值是新版本发布时的当前主版本。这将替换下面描述的旧的、已弃用的 PG_SUPPORTS_* 配置指令。

PG_SUPPORTS_ROLE (已弃用)
    此选项自 Ora2Pg v7.3 版本起已弃用。

    默认情况下，Oracle 角色会转换为 PostgreSQL 组。如果您使用的是 PostgreSQL 8.1 或更高版本，可以考虑使用 ROLES 并将此指令设置为 1 以导出角色。

PG_SUPPORTS_INOUT (已弃用)
    此选项自 Ora2Pg v7.3 版本起已弃用。

    如果设置为 0，所有 IN、OUT 或 INOUT 参数将不会在生成的 PostgreSQL 函数声明中使用（对于低于 8.1 版本的 PostgreSQL 数据库，禁用此选项）。现在默认启用。

PG_SUPPORTS_DEFAULT
    此指令启用或禁用在函数导出中使用默认参数值。在 PostgreSQL 8.4 之前，不支持此类默认值。此功能现在默认启用。

PG_SUPPORTS_WHEN (已弃用)
    为触发器添加对 WHEN 子句的支持，因为 PostgreSQL v9.0 现在支持它们。此指令默认启用；设置为 0 可禁用此功能。

PG_SUPPORTS_INSTEADOF (已弃用)
    添加对触发器上 INSTEAD OF 用法的支持（用于 PG >= 9.1）。如果禁用此指令，INSTEAD OF 触发器将被重写为 Pg 规则。

PG_SUPPORTS_CHECKOPTION
    启用时，导出带有 CHECK OPTION 的视图。如果您使用的 PostgreSQL 版本低于 9.4，请禁用它。默认值：1，启用。

PG_SUPPORTS_IFEXISTS
    如果禁用，不导出带有 IF EXISTS 语句的对象。默认启用。

PG_SUPPORTS_PARTITION
    10.0 之前的 PostgreSQL 版本没有原生分区。如果您想使用声明式分区，请启用此指令。默认启用。

PG_SUPPORTS_SUBSTR
    某些 PostgreSQL 版本（如 Redshift）不支持 substr()，需要用 substring() 调用替换。在这种情况下，禁用它。

PG_SUPPORTS_NAMED_OPERATOR
    如果您使用的 PG < 9.5，请禁用此指令。PL/SQL 中用于命名参数的运算符 => 将被替换为 PostgreSQL 的专有运算符 :=。默认启用。

PG_SUPPORTS_IDENTITY
    如果您使用的是 PostgreSQL >= 10，请启用此指令以使用 IDENTITY 列代替 serial 或 bigserial 数据类型。如果 PG_SUPPORTS_IDENTITY 被禁用，并且 Oracle 表中有 IDENTITY 列，它们将被导出为 serial 或 bigserial 列。启用时，它们将被导出为 IDENTITY 列，例如：

          CREATE TABLE identity_test_tab (
                  id bigint GENERATED ALWAYS AS IDENTITY,
                  description varchar(30)
          ) ;

    如果 Oracle 中设置了非默认的序列选项，它们将附加在 IDENTITY 关键字之后。此外，在这两种情况下，Ora2Pg 都会创建一个名为 AUTOINCREMENT_output.sql 的文件，其中包含一个嵌入式函数，用于将关联的序列更新为 "SELECT max(colname)+1 FROM tablename" 设置的重新启动值。当然，此文件必须在数据导入后导入，否则序列将保持起始值。默认启用。

PG_SUPPORTS_PROCEDURE
    PostgreSQL v11 添加了对 PROCEDURE 的支持，如果您使用该版本，请启用它。

BITMAP_AS_GIN
    使用 btree_gin 扩展在 pg >= 9.4 上创建类位图索引。您需要自己创建扩展：create extension btree_gin; 默认情况下创建 GIN 索引，禁用时将创建 btree 索引。

PG_BACKGROUND
    使用 pg_background 扩展创建自治事务，而不是使用 dblink 包装器。仅适用于 pg >= 9.5。默认使用 dblink。有关此扩展的信息，请参见 https://github.com/vibhorkum/pg_background。

DBLINK_CONN
    默认情况下，如果您有使用 dblink 扩展（而非 pg_background）转换的自治事务，连接是使用 PG_DSN、PG_USER 和 PG_PWD 设置的值定义的。如果您想完全覆盖连接字符串，请使用此指令在自治事务包装函数中设置连接。例如：

            DBLINK_CONN    port=5432 dbname=pgdb host=localhost user=pguser password=pgpass

LONGREADLEN
    使用此指令将数据库句柄的 'LongReadLen' 属性设置为大于预期 LOB 大小的值。默认值为 1MB，这可能不足以提取 BLOB 或 CLOB。如果 LOB 的大小超过 'LongReadLen'，DBD::Oracle 将返回 'ORA-24345: A Truncation' 错误。默认值：1023*1024 字节。

    查看此页面了解更多信息：
    http://search.cpan.org/~pythian/DBD-Oracle-1.22/Oracle.pm#Data_Inter
    face_for_Persistent_LOBs

    重要提示：如果您增加此指令的值，请注意 DATA_LIMIT 可能需要减小。即使您只有一个 1MB 的 blob，尝试一次读取 10000 个（默认 DATA_LIMIT）也需要 10GB 的内存。您可以单独从这些表中提取数据，并将 DATA_LIMIT 设置为 500 或更低，否则可能会遇到内存不足的问题。

LONGTRUNKOK
    如果您想绕过 'ORA-24345: A Truncation' 错误，请将此指令设置为 1。它会将提取的数据截断到 LongReadLen 值。默认禁用，以便在 LongReadLen 值不够高时发出警告。

USE_LOB_LOCATOR
    如果您想加载 BLOB 和 CLOB 的完整内容而不使用 LOB 定位器，请禁用此选项。在这种情况下，您必须将 LONGREADLEN 设置为正确的值。请注意，这不会提高 BLOB 导出的速度，因为大部分时间总是消耗在 bytea 转义上，并且在这种情况下，导出是逐行进行的，而不是按 DATA_LIMIT 行的块进行。有关其工作原理的更多信息，请参见
    http://search.cpan.org/~pythian/DBD-Oracle-1.74/lib/DBD/Oracle.pm#Da
    ta_Interface_for_LOB_Locators

    默认启用；它使用 LOB 定位器。

LOB_CHUNK_SIZE
    Oracle 建议使用 LOB 块大小的倍数批量读写 LOB。此块大小默认为 8k (8192)。最近的测试表明，使用更高的值（如 512K 或 4Mb）可以达到最佳性能。

    对 30120 行不同大小的 BLOB（200 个 5Mb、19800 个 212k、10000 个 942K、100 个 17Mb、20 个 156Mb）进行快速基准测试，DATA_LIMIT=100，LONGREADLEN=170Mb，表总大小为 20GB，结果如下：

           不使用 lob 定位器  : 22分46.218秒（1365 秒，平均：22 条记录/秒）
           块大小 8k   : 15分50.886秒（951 秒，平均：31 条记录/秒）
           块大小 512k : 1分28.161秒（88 秒，平均：342 条记录/秒）
           块大小 4Mb  : 1分23.717秒（83 秒，平均：362 条记录/秒）

    总之，将 LOB_CHUNK_SIZE 设置为 4Mb 可以快 10 倍以上。根据大多数 BLOB 的大小，您可能需要在此处调整该值。例如，如果您的大多数小 lob 都小于 8K，使用 8192 更好，以避免浪费空间。LOB_CHUNK_SIZE 的默认值为 512000。

XML_PRETTY
    强制对 XML 数据导出使用 getStringVal() 而不是 getClobVal()。默认值为 1，为了向后兼容而启用。设置为 0 可使用 CLOB 等提取方法。请注意，使用 getStringVal() 提取的 XML 值不得超过 VARCHAR2 大小限制（4000），否则将返回错误。

ENABLE_MICROSECOND
    如果您想禁用从 Oracle 时间戳列导出毫秒，请将其设置为 0。默认情况下，通过使用以下格式导出毫秒：

            'YYYY-MM-DD HH24:MI:SS.FF'

    禁用将强制使用以下 Oracle 格式：

            to_char(..., 'YYYY-MM-DD HH24:MI:SS')

    默认情况下，导出毫秒。

DISABLE_COMMENT
    如果您不想导出与表和列定义相关联的注释，请将此设置为 1。默认启用。

控制 MySQL 导出行为 MYSQL_PIPES_AS_CONCAT 如果双竖线和双与号（|| 和 &&）不应被视为等同于 OR 和 AND，请启用此选项。这取决于变量 @sql_mode。仅在 Ora2Pg 自动检测此行为失败时使用。

MYSQL_INTERNAL_EXTRACT_FORMAT 如果您希望 EXTRACT() 替换使用返回整数的内部格式（例如 DD HH24:MM:SS 将替换为格式 DDHH24MMSS::bigint），请启用此指令，这取决于您的应用程序的使用情况。

控制 SQL Server 导出行为 DROP_ROWVERSION PostgreSQL 没有与 rowversion 数据类型和功能等效的功能。如果您想删除这些无用的列，请启用此指令。数据类型为 'rowversion' 或 'timestamp' 的列将不会被导出。

CASE_INSENSITIVE_SEARCH 模拟 MSSQL 不区分大小写搜索的相同行为。如果值为 citext，它将在表 DDL 中使用 citext 数据类型代替 char/varchar/text（Ora2Pg 将为具有精度的列添加 CHECK 约束）。除了 citext，您还可以设置将在列定义中使用的排序规则名称。要禁用不区分大小写的搜索，请将其设置为：none。

SELECT_TOP
    将 TOP N 子句附加到用于从 SQL Server 提取数据的 SELECT 命令。这相当于 Oracle 的 WHERE ROWNUM < 1000 子句。

处理字符编码的特殊选项 NLS_LANG 和 NLS_NCHAR 默认情况下，Ora2Pg 会将 NLS_LANG 设置为 AMERICAN_AMERICA.AL32UTF8，将 NLS_NCHAR 设置为 AL32UTF8。不建议更改这些设置，但在某些情况下可能有用。使用这些配置指令设置您自己的设置将通过设置环境变量 $ENV{NLS_LANG} 和 $ENV{NLS_NCHAR} 来更改 Oracle 端的客户端编码。

BINMODE 默认情况下，Ora2Pg 会强制 Perl 使用 UTF8 编码。这是通过调用 Perl 编译指示实现的：

            use open ':utf8';

    您可以使用 BINMODE 指令覆盖此编码。例如，您可以将其设置为 :locale 以使用您的区域设置，或设置为 iso-8859-7。它将分别使用：

            use open ':locale';
            use open ':encoding(iso-8859-7)';

    如果您已将 NLS_LANG 更改为非 UTF8 编码，您可能需要设置此指令。有关更多信息，请参阅 http://perldoc.perl.org/5.14.2/open.html。大多数情况下，将此指令保持注释状态。

CLIENT_ENCODING
    默认情况下，PostgreSQL 客户端编码会自动设置为 UTF8，以避免编码问题。如果您更改了 NLS_LANG 的值，可能需要更改 PostgreSQL 客户端的编码。

    您可以在此处查看 PostgreSQL 支持的字符集：http://www.postgresql.org/docs/9.0/static/multibyte.html

FORCE_PLSQL_ENCODING
    启用此指令可强制导出的 PL/SQL 代码使用 UTF 8 编码。在某些特殊情况下可能会有所帮助。

PLSQL to PLPGSQL conversion 将 Oracle PL/SQL 自动转换为 PostgreSQL PL/PGSQL 是 Ora2Pg 中正在进行的工作，您可能需要手动调整。用于自动转换的 Perl 代码存储在名为 Ora2Pg/PLSQL.pm 的特定 Perl 模块中。欢迎修改/添加您自己的代码并发送补丁。主要工作包括函数、过程、包和包体的头部以及参数重写。

PLSQL_PGSQL 启用/禁用 PL/SQL 到 PL/PGSQL 的转换。默认启用。

NULL_EQUAL_EMPTY
    Ora2Pg 可以将所有条件中的 NULL 测试替换为调用 coalesce() 函数，以模拟 Oracle 中字符串为空时等同于 NULL 的行为。

            (field1 IS NULL) 会被替换为 (coalesce(field2 IS NOT NULL) 会被替换为 (field2 IS NOT NULL AND field2::text <> '')

    您可能需要这种替换来确保应用程序的行为一致，但如果您有权修改应用程序，更好的做法是将空字符串转换为 NULL，因为 PostgreSQL 会区分这两者。

EMPTY_LOB_NULL
    将 empty_clob() 和 empty_blob() 导出为 NULL，而不是空字符串（对于前者）和 '\x'（对于后者）。如果列允许 NULL，当存在大量空 LOB 时，这可能会提高数据导出速度。默认情况下会保留 Oracle 中的原始数据。

PACKAGE_AS_SCHEMA
    如果不想将包导出为模式，而是作为简单函数，您可能还需要替换所有对 package_name.function_name 的调用。如果禁用 PACKAGE_AS_SCHEMA 指令，Ora2Pg 会将所有对 package_name.function_name() 的调用替换为 package_name_function_name()。默认情况下，使用模式来模拟包。

    这种替换将在所有类型的 DDL 或由 PL/SQL 到 PL/PGSQL 转换器处理的代码中进行。必须启用 PL/SQL_PGSQL 或在命令行中使用 -p。

REWRITE_OUTER_JOIN
    如果 Oracle 原生的 (+) 连接条件转换不正确，可启用此指令。这将强制 Ora2Pg 不重写此类代码。默认情况下，目前只重写简单的右外连接。

UUID_FUNCTION
    默认情况下，Ora2Pg 将 Oracle 的 SYS_GUID() 函数替换为 uuid-ossp 扩展中的 uuid_generate_v4。您可以将其更改为使用 pgcrypto 扩展中的 gen_random_uuid 函数，只需修改函数名称。默认值为 uuid-ossp 扩展中的 uuid_generate_v4。

    注意，如果发现 RAW(16) 或 RAW(16) 列，或者 RAW 列的默认值为 "SYS_GUID()"，Ora2Pg 会自动将列类型转换为 uuid，这在大多数情况下是正确的。在这种情况下，数据将自动迁移为 PostgreSQL 的 uuid 类型，这需要 "uuid-ossp" 扩展。

FUNCTION_STABLE
    默认情况下，Oracle 函数被标记为 STABLE，因为除非在 PL/SQL 中进行变量赋值或作为条件表达式使用，否则它们不会修改数据。如果要将这些函数创建为 VOLATILE，可以禁用此配置指令。

COMMENT_COMMIT_ROLLBACK
    默认情况下，Ora2Pg 不会修改 COMMIT/ROLLBACK 语句，以便用户检查函数逻辑。如果已经修复了 Oracle 源代码或希望注释掉这些调用，可以启用此指令。

COMMENT_SAVEPOINT
    PL/SQL 过程中经常会使用 SAVEPOINT 以及 ROLLBACK TO savepoint_name。如果启用了 COMMENT_COMMIT_ROLLBACK，可能也需要注释掉 SAVEPOINT，此时可以启用此指令。

STRING_CONSTANT_REGEXP
    在将 PL/SQL 转换为 PL/PGSQL 时，Ora2Pg 会替换所有字符串常量。字符串常量是所有用单引号括起来的文本。如果有一些用于动态 SQL 的占位符，可以设置一个正则表达式，以便在解析时暂时替换它们，避免解析错误。例如：

            STRING_CONSTANT_REGEXP         <placeholder value=".*">

    多个正则表达式用分号分隔。

ALTERNATIVE_QUOTING_REGEXP
    为了支持 Oracle 的替代引用机制（'Q' 或 'Q'），需要设置用于提取文本部分的正则表达式。例如，对于以下变量声明：

            c_sample VARCHAR2(1600) := q'{This doesn't work.}';

    相应的正则表达式为：

            ALTERNATIVE_QUOTING_REGEXP     q'{(.*)}'

    Ora2Pg 将使用 $$ 作为分隔符，上述例子的转换结果为：

            c_sample varchar(1600) := $$This doesn't work.$$;

    此配置项可以包含多个用分号分隔的正则表达式。为了正确提取文本，每个正则表达式都必须有一个捕获组（用括号括起来）。

USE_ORAFCE
    如果您想使用 Orafce 库中的函数，并阻止 Ora2Pg 转换这些函数的调用，可以启用此指令。Orafce 库地址：https://github.com/orafce/orafce

    默认情况下，Ora2Pg 会重写 add_month()、add_year()、date_trunc() 和 to_char() 函数，但您可能希望使用 Ora2Pg 提供的函数，这样就不需要修改代码。

AUTONOMOUS_TRANSACTION
    将自治事务转换为使用 dblink 或 pg_background 扩展的包装函数。如果不想进行此转换，只导出不带 pragma 调用的普通函数，禁用此指令。

Materialized View 由于 PostgreSQL 只支持完全刷新，所以物化视图将作为快照“Snapshot Materialized Views”导出。

如果要在 PostgreSQL 9.3 之前的版本中导入物化视图，必须将配置指令 PG_SUPPORTS_MVIEW 设置为 自动生成。这种情况下，Ora2Pg 会按照以下文档中的说明导出所有物化视图：

        http://tech.jonathangardner.net/wiki/导出物化视图时，Ora2Pg 首先添加创建 "materialized_views" 表的 SQL 代码：

        CREATE TABLE materialized_views (
                mview_name text NOT NULL PRIMARY KEY,
                view_name text NOT NULL,
                iname text,
                last_refresh TIMESTAMP WITH TIME ZONE
        );

所有物化视图都会在该表中创建条目。然后添加创建三个函数的 PL/SQL 代码：

        create_materialized_view(text, text, text)：用于创建物化视图
        drop_materialized_view(text)：用于删除物化视图
        refresh_full_materialized_view(text)：用于刷新视图

然后添加创建视图和物化视图的 SQL 代码：

        CREATE VIEW mviewname_mview AS
        SELECT ... FROM ...;

        SELECT create_materialized_view('mviewname','mviewname_mview', change with the name of the column to be used for the index);

第一个参数是物化视图的名称，第二个参数是该物化视图基于的视图名称，第三个参数是用于创建索引的列名（通常是主键）。由于无法自动推断该列，您需要替换为实际的列名。

如前所述，Ora2Pg 只支持快照物化视图，因此刷新时会先截断表，然后从视图中重新加载所有数据：

         refresh_full_materialized_view('mviewname');

要删除物化视图，只需调用 drop_materialized_view() 函数，并传入物化视图的名称作为参数。

Other configuration directives DEBUG 设置为 1 可启用详细输出。

IMPORT 您可以将常用的 Ora2Pg 配置指令保存在一个文件中，并使用 IMPORT 指令将其导入到其他配置文件中，例如：

            IMPORT  commonfile.conf

    这将把 commonfile.conf 中的所有配置指令导入到当前配置中。

Exporting views as PostgreSQL tables 如果要将 Oracle 视图作为 PostgreSQL 导出，只需将 TYPE 配置选项设置为 TABLE，以获取相应的创建表语句。或者使用 type COPY 或 INSERT 来导出数据。为此，需要在 VIEW_AS_TABLE 配置项中指定要转换的视图。

然后，如果 Ora2Pg 找到该视图，它将（在 TYPE=TABLE 时）提取其结构并转换为 PostgreSQL 的 CREATE TABLE 语句，然后（在 TYPE=COPY 或 INSERT 时）按照视图的结构提取数据。

例如，对于以下视图：

        CREATE OR REPLACE VIEW product_prices (category_id, product_count, low_price, high_price) AS
        SELECT  category_id, COUNT(*) as product_count,
            MIN(list_price) as low_price,
            MAX(list_price) as cost_price
         FROM   product_information
        SELECT  category_id, COUNT(*) as product_count,
            MIN(list_price) as low_price,
            MAX(list_price) as cost_price
         FROM   product_information
        GROUP BY category_id;

将 VIEW_AS_TABLE 设置为 product_prices 并使用 export type TABLE，Ora2Pg 将检测列的数据类型并生成以下 CREATE TABLE 语句：

        CREATE TABLE product_prices (
                category_id bigint,
                product_count integer,
                low_price numeric,
                high_price numeric
        );

数据将根据 COPY 或 INSERT 类型以及视图定义进行加载。

您可以使用 ALLOW 和 EXPORT 指令来过滤要导出的对象。

Export as Kettle transformation XML files 当您想使用 Pentaho Data Integrator (Kettle) 将数据导入 PostgreSQL 时，KETTLE 导出类型非常有用。使用此类型，Ora2Pg 会为每个表生成一个 XML 格式的 Kettle 转换文件（.ktr），并在 output.sql 文件中添加执行转换的命令。例如：

    ora2pg -c ora2pg.conf -t KETTLE -j 12 -a MYTABLE -o load_mydata.sh

这将创建一个名为 'HR.MYTABLE.ktr' 的文件，并在输出文件（load_mydata.sh）中添加以下内容：

        #!/bin/sh

        KETTLE_TEMPLATE_PATH='.'

        JAVAMAXMEM=4096 ./pan.sh -file $KETTLE_TEMPLATE_PATH/HR.MYTABLE.ktr -level Detailed

-j 12 选项会创建一个支持 12 个并行加载进程的模板。您还可以使用 -J 选项指定从 Oracle 提取数据的并行查询数，例如：

        ora2pg -c ora2pg.conf -t KETTLE -J 4 -j 12 -a EMPLOYEES -o load_mydata.sh

要使用此功能，表必须有一个唯一键（数值类型），或者通过 DEFINED_PKEY 配置项指定用于拆分查询的技术键。例如：

        DEFINED_PK      EMPLOYEES:employee_id

这将创建 4 个 Oracle 连接，并在生成的 Kettle XML 文件中生成以下 SQL 语句：

        <sql>SELECT * FROM HR.EMPLOYEES WHERE ABS(MOD(employee_id,${Internal.Step.Unique.Count}))=${Internal.Step.Unique.Number}</sql>

使用此功能需要配置 Oracle 和 PostgreSQL 的连接信息。您还可以启用 TRUNCATE_TABLE 指令，以便在导入前清空表数据。

此功能由 Marc Cousin 开发。

Migration Cost Assessment 评估从 Oracle 迁移到 PostgreSQL 的成本并非易事。为了获得准确的评估，Ora2Pg 会检查所有数据库对象、函数和存储过程，以确定是否存在无法自动转换的代码。

Ora2Pg 具备内容分析模式，该模式能够检查 Oracle 数据库，生成一份文本报告，说明 Oracle 数据库包含哪些内容以及哪些内容无法导出。

要激活“分析和报告”模式，您必须使用导出类型 SHOW_REPORT，命令如下：

    ora2pg -t SHOW_REPORT

以下是使用此命令获得的示例报告：

    --------------------------------------
    Ora2Pg: Oracle Database Content Report
    --------------------------------------
    Version Oracle Database 10g Enterprise Edition Release 10.2.0.1.0
    Schema  HR
    Size  880.00 MB
 
    --------------------------------------
    Object  Number  Invalid Comments
    --------------------------------------
    CLUSTER   2 0 不支持聚簇，且不会导出聚簇。
    FUNCTION  40  0 函数代码总大小：81992。
    INDEX     435 0 232 个索引将参与导出，其他索引为自动生成，在 PostgreSQL 中也会自动生成。1 个位图索引。230 个 B-树索引。1 个反向 B-树索引。请注意，如果存在位图索引，将导出为 B-树索引。聚簇索引、域索引、位图连接索引和 IOT 索引将完全不会导出。反向索引也不会导出，您可以使用基于 trigram 的索引（参见 pg_trgm）或基于 reverse() 函数的索引进行搜索。您还可以在索引中使用 'varchar_pattern_ops'、'text_pattern_ops' 或 'bpchar_pattern_ops' 操作符，以分别提高在 varchar、text 或 char 列上使用 LIKE 操作符的搜索性能。
    MATERIALIZED VIEW 1 0 所有物化视图将导出为快照物化视图，仅在完全刷新时才会更新。
    PACKAGE BODY  2 1 包体代码总大小：20700。
    PROCEDURE 7 0 过程代码总大小：19198。
    SEQUENCE  160 0 序列完全受支持，但所有对 sequence_name.NEXTVAL 或 sequence_name.CURRVAL 的调用将转换为 NEXTVAL('sequence_name') 或 CURRVAL('sequence_name')。
    TABLE     265 0 1 个外部表将导出为标准表。请参阅 EXTERNAL_TO_FDW 配置指令，将其导出为 file_fdw 外部表，或者如果您只想从外部文件加载数据，可以在代码中使用 COPY。2 个二进制列。4 个未知类型。
    TABLE PARTITION 8 0 分区使用表继承和检查约束进行导出。1 个哈希分区。2 个列表分区。6 个范围分区。请注意，不支持哈希分区。
    TRIGGER   30  0 触发器代码总大小：21677。
    TYPE      7 1 5 种类型将参与导出，其他类型不受支持。2 个嵌套表。2 个对象类型。1 个子类型。1 个类型体。1 个继承类型。1 个数组。请注意，继承类型和子类型将转换为表，不支持类型继承。
    TYPE BODY 0 3 不支持导出带有成员方法的类型，它们将不会被导出。
    VIEW      7 0 视图完全受支持，但如果您有可更新视图，则需要使用 INSTEAD OF 触发器。
    DATABASE LINK 1 0 数据库链接不会导出。您可以尝试使用 dblink perl 扩展模块，或通过不同的外部数据包装器（FDW）扩展使用 SQL/MED PostgreSQL 特性。
                
    Note: Invalid code will not be exported unless the EXPORT_INVALID configuration directive is activated.

对数据库进行分析后，Ora2Pg 凭借其将 SQL 和 PL/SQL 代码从 Oracle 语法转换为 PostgreSQL 语法的能力，可以进一步估算执行完整数据库迁移所需的代码复杂度和时间。

要估算以人天为单位的迁移成本，Ora2Pg 允许您使用名为 ESTIMATE_COST 的配置指令，您也可以在命令行启用该指令：

    --estimate_cost

此功能只能与 SHOW_REPORT、FUNCTION、PROCEDURE、PACKAGE 和 QUERY 导出类型一起使用。

    ora2pg -t SHOW_REPORT  --estimate_cost

生成的报告与上述报告相同，但会增加一个新的“Estimated cost”列，如下所示：

    --------------------------------------
    Ora2Pg: Oracle Database Content Report
    --------------------------------------
    Version Oracle Database 10g Express Edition Release 10.2.0.1.0
    Schema  HR
    Size  890.00 MB
 
    --------------------------------------
    Object  Number  Invalid Estimated cost  Comments
    --------------------------------------
    DATABASE LINK  3 0 9 数据库链接将使用 oracle_fdw 导出为 SQL/MED PostgreSQL 的外部数据包装器（FDW）扩展。
    FUNCTION  2 0 7 函数代码总大小：369 字节。HIGH_SALARY: 2，VALIDATE_SSN: 3。
    INDEX 21  0 11  11 个索引将参与导出，其他索引为自动生成，在 PostgreSQL 中也会自动生成。11 个 B-树索引。请注意，如果存在位图索引，将导出为 B-树索引。聚簇索引、域索引、位图连接索引和 IOT 索引将完全不会导出。反向索引也不会导出，您可以使用基于 trigram 的索引（参见 pg_trgm）或基于 reverse() 函数的索引进行搜索。您还可以在索引中使用 'varchar_pattern_ops'、'text_pattern_ops' 或 'bpchar_pattern_ops' 操作符，以分别提高在 varchar、text 或 char 列上使用 LIKE 操作符的搜索性能。
    JOB 0 0 0 作业不会导出。您可以为它们设置外部 cron 作业。
    MATERIALIZED VIEW 1 0 3 所有物化视图将导出为快照物化视图，仅在完全刷新时才会更新。
    PACKAGE BODY  0 2 54  包体代码总大小：2487 字节。在这些包中找到的过程和函数数量：7。two_proc.get_table: 10，emp_mgmt.create_dept: 4，emp_mgmt.hire: 13，emp_mgmt.increase_comm: 4，emp_mgmt.increase_sal: 4，emp_mgmt.remove_dept: 3，emp_mgmt.remove_emp: 2。
    PROCEDURE 4 0 39  过程代码总大小：2436 字节。TEST_COMMENTAIRE: 2，SECURE_DML: 3，PHD_GET_TABLE: 24，ADD_JOB_HISTORY: 6。
    SEQUENCE  3 0 0 序列完全受支持，但所有对 sequence_name.NEXTVAL 或 sequence_name.CURRVAL 的调用将转换为 NEXTVAL('sequence_name') 或 CURRVAL('sequence_name')。
    SYNONYM   3 0 4 同义词将导出为视图。PostgreSQL 中不存在同义词，但常见的解决方法是使用视图，或在会话中设置 PostgreSQL 的 search_path 以访问当前模式之外的对象。
                                    user1.emp_details_view_v 是 hr.emp_details_view 的别名。
                                    user1.emp_table 是 hr.employees@other_server 的别名。
                                    user1.offices 是 hr.locations 的别名。
    TABLE 17  0 8.5 1 个外部表将导出为标准表。请参阅 EXTERNAL_TO_FDW 配置指令，将其导出为 file_fdw 外部表，或者如果您只想从外部文件加载数据，可以在代码中使用 COPY。2 个二进制列。4 个未知类型。
    TRIGGER 1 1 4 触发器代码总大小：123 字节。UPDATE_JOB_HISTORY: 2。
    TYPE  7 1 5 5 种类型将参与导出，其他类型不受支持。2 个嵌套表。2 个对象类型。1 个子类型。1 个类型体。1 个继承类型。1 个数组。请注意，继承类型和子类型将转换为表，不支持类型继承。
    TYPE BODY 0 3 30  不支持导出带有成员方法的类型，它们将不会被导出。
    VIEW  1 1 1 视图完全受支持，但如果您有可更新视图，则需要使用 INSTEAD OF 触发器。
    --------------------------------------
    Total 65  8 162.5 162.5 个迁移成本单位大约意味着 2 个人工日。

最后一行显示了根据每个对象估算的迁移单位数量得出的总估算迁移成本（以人天为单位）。每个迁移单位大约代表 PostgreSQL 专家工作五分钟。如果这是您的首次迁移，您可以通过配置指令 COST_UNIT_VALUE 或命令行选项 --cost_unit_value 增加此值：

    ora2pg -t SHOW_REPORT  --estimate_cost --cost_unit_value 10

Ora2Pg 还能够为您提供迁移难度等级评估。以下是一个示例：

Migration level: B-5

Migration levels:
    A - 可能自动运行的迁移
    B - 需要代码重写且人工日成本不超过 5 天的迁移
    C - 需要代码重写且人工日成本超过 5 天的迁移
Technical levels:
    1 = 简单：无存储函数和触发器
    2 = 容易：无存储函数但有触发器，无需手动重写
    3 = 较简单：有存储函数和/或触发器，无需手动重写
    4 = 需手动：无存储函数但有触发器或需重写代码的视图
    5 = 困难：有存储函数和/或需重写代码的触发器

此评估由字母 A 或 B 组成，用于指定迁移是否需要手动重写，以及一个从 1 到 5 的数字，表示技术难度级别。您有一个额外的选项 --human_days_limit，用于指定将迁移级别设置为 C 的人工日数限制，以表明它需要大量工作和带有迁移支持的完整项目管理。默认值为 10 个人工日。您可以使用配置指令 HUMAN_DAYS_LIMIT 永久更改此默认值。

开发此功能是为了帮助您或您的上级决定首先迁移哪个数据库，以及必须动员哪个团队来进行迁移。

Global Oracle and MySQL migration assessment Ora2Pg 附带一个脚本 ora2pg_scanner，当您有大量实例和模式需要扫描以进行迁移评估时，可以使用该脚本。

Usage: ora2pg_scanner -l CSVFILE [-o OUTDIR]

   -b | --binpath DIR: ora2pg 二进制文件所在目录的完整路径。
                可能仅在 Windows 操作系统上有用。
   -c | --config FILE: 设置要使用的自定义配置文件，否则 ora2pg
                将使用默认配置文件：/etc/ora2pg/ora2pg.conf。
   -l | --list FILE : 包含要扫描的数据库列表及其所有所需信息的 CSV 文件。
                该文件的第一行可以包含描述必须使用的格式的以下标题：

                "type","schema/database","dsn","user","password"

   -o | --outdir DIR : （可选）默认情况下，所有报告将转储到名为 'output' 的目录，
                该目录将自动创建。如果要更改此目录的名称，请在第二个参数中设置名称。

   -t | --test : 仅尝试通过检索所需的模式或数据库名称来测试所有连接。
                 有助于验证您的 CSV 列表文件。
   -u | --unit MIN : 全局重新定义以分钟为单位的迁移成本单位值。
                 默认值取自 ora2pg.conf（默认为 5 分钟）。

   Here is a full example of a CSV databases list file:

        "type","schema/database","dsn","user","password"
        "MYSQL","sakila","dbi:mysql:host=192.168.1.10;database=sakila;port=3306","root","secret"
        "ORACLE","HR","dbi:Oracle:host=192.168.1.10;sid=XE;port=1521","system","manager"
        "MSSQL","HR","dbi:ODBC:driver=msodbcsql18;server=srv.database.windows.net;database=testdb","system","manager"

   CSV 字段分隔符必须是逗号。

   请注意，如果您要扫描 Oracle 实例中的所有模式，只需将模式字段留空。Ora2Pg 将自动检测所有可用模式，并为每个模式生成报告。当然，您需要使用具有足够权限的连接用户，以便能够扫描所有模式。例如：

        "ORACLE","","dbi:Oracle:host=192.168.1.10;sid=XE;port=1521","system","manager"
        "MSSQL","","dbi:ODBC:driver=msodbcsql18;server=srv.database.windows.net;database=testdb","usrname","passwd"

   将为 XE 实例中的所有模式生成报告。请注意，在这种情况下，ora2pg.conf 中的 SCHEMA 指令不得设置。

它将生成一个包含评估结果的 CSV 文件，每个模式或数据库一行，以及每个扫描数据库的详细 HTML 报告。

提示：事先使用 -t | --test 选项来测试 CSV 文件中的所有连接。

对于 Windows 用户，必须使用 -b 命令行选项来设置 ora2pg_scanner 所在的目录，否则 ora2pg 命令调用将失败。

在关于函数的迁移评估详细信息中，Ora2Pg 默认始终为 TEST 添加 2 个迁移单位，为代码中每 1000 个字符的 SIZE 添加 1 个单位。这意味着默认情况下，每个函数的迁移评估将增加 15 分钟。显然，如果您有单元测试或非常简单的函数，这可能无法代表实际的迁移时间。

Migration assessment method 为每种类型的 Oracle 数据库对象分配的迁移单位分数在 Perl 库 lib/Ora2Pg/PLSQL.pm 的 %OBJECT_SCORE 变量定义中定义。

与迁移单位相关联的 PL/SQL 行数也在此文件中的 $SIZE_SCORE 变量值中定义。

与每种 PL/SQL 代码难度相关联的迁移单位数量可以在同一个 Perl 库 lib/Ora2Pg/PLSQL.pm 的 %UNCOVERED_SCORE 哈希初始化中找到。

这种评估方法仍在不断完善中，因此我期待有关迁移经验的反馈，以优化这些变量中分配的分数/单位。

Improving indexes and constraints creation speed 使用 LOAD 导出类型和包含要执行的 SQL 命令的文件，可以将这些命令分配到多个 PostgreSQL 连接上执行。要能够使用此功能，必须设置 PG_DSN、PG_USER 和 PG_PWD。然后：

    ora2pg -t LOAD -c config/ora2pg.conf -i schema/tables/INDEXES_table.sql -j 4

将在 4 个同时的 PostgreSQL 连接上分配索引创建任务。

对于海量数据，这将显著加快迁移过程中的这部分速度。

Exporting LONG RAW 如果您仍然有定义为 LONG RAW 的列，Ora2Pg 将无法导出这类数据。OCI 库无法导出它们，并且总是返回相同的第一条记录。要能够导出数据，您需要在迁移数据之前通过创建临时表将该字段转换为 BLOB。例如，Oracle 表：

    SQL> DESC TEST_LONGRAW
         Name                 NULL ?   Type
         -------------------- -------- ----------------------------
         ID                            NUMBER
         C1                            LONG RAW

需要“转换”为使用 BLOB 的表，如下所示：

        CREATE TABLE test_blob (id NUMBER, c1 BLOB);

然后使用以下 INSERT 查询复制数据：

        INSERT INTO test_blob SELECT id, to_lob(c1) FROM test_longraw;

然后，您只需从导出中排除原始表（参见 EXCLUDE 指令），并使用 REPLACE_TABLES 配置指令动态重命名新的临时表。

Global variables Oracle 允许使用在包中定义的全局变量。Ora2Pg 会将这些变量导出到 PostgreSQL，作为会话中可用的用户定义自定义变量。Oracle 变量赋值将导出为对以下函数的调用：

PERFORM set_config('pkgname.varname', value, false);

代码中对这些变量的使用将替换为：

    current_setting('pkgname.varname')::global_variables_type;

其中 global_variables_type 是从包定义中提取的变量类型。

如果变量是常量或在声明时分配了默认值，Ora2Pg 将创建一个 global_variables.conf 文件，其中包含要包含在 postgresql.conf 文件中的定义，以便在数据库连接时已经设置它们的值。请注意，用户始终可以修改该值，因此您不能拥有完全意义上的常量。

Hints 在 Oracle 端将使用 Oracle 风格外连接 (+) 语法的查询转换为 ANSI 标准 SQL，可以为您节省大量迁移时间。您可以使用 TOAD Query Builder 用正确的 ANSI 语法重写这些查询，参见： http://www.toadworld.com/products/toad-for-oracle/f/10/t/9518.aspx

还有一个使用 SQL Developer Data Modeler 的替代方法，参见 http://www.thatjeffsmith.com/archive/2012/01/sql-developer-data-modeler- quick-tip-use-oracle-join-syntax-or-ansi/

Toad 还能够将原生 Oracle DECODE() 语法重写为 ANSI 标准 SQL CASE 语句。您可以在 PgConf.RU 的一次演示中找到有关此内容的幻灯片：
http://ora2pg.darold.net/slides/ora2pg_the_hard_way.pdf

Test the migration 这种操作类型要求您检查 Oracle 数据库中的所有对象是否都已在 PostgreSQL 下创建。当然，必须设置 PG_DSN 才能检查 PostgreSQL 端。

请注意，如果定义了 EXPORT_SCHEMA 以及 SCHEMA 或 PG_SCHEMA，此功能会遵循模式名称限制。如果仅设置了 EXPORT_SCHEMA，则会扫描 Oracle 和 PostgreSQL 中的所有模式。您可以使用 SCHEMA 和/或 PG_SCHEMA 筛选单个模式，但不能筛选模式列表。要测试模式列表，您必须重复调用 Ora2Pg，每次指定一个模式。

例如命令：

    ora2pg -t TEST -c config/ora2pg.conf > migration_diff.txt

将创建一个文件，其中包含 Oracle 和 PostgreSQL 两侧所有对象和行计数的报告，以及一个错误部分，为您提供每种对象差异的详细信息。以下是示例结果：

    [TEST INDEXES COUNT]
    ORACLEDB:DEPARTMENTS:2
    POSTGRES:departments:1
    ORACLEDB:EMPLOYEES:6
    POSTGRES:employees:6
    [ERRORS INDEXES COUNT]
    表 departments 在 Oracle (2) 和 PostgreSQL (1) 中的索引数量不同。

    [TEST UNIQUE CONSTRAINTS COUNT]
    ORACLEDB:DEPARTMENTS:1
    POSTGRES:departments:1
    ORACLEDB:EMPLOYEES:1
    POSTGRES:employees:1
    [ERRORS UNIQUE CONSTRAINTS COUNT]
    正常，Oracle 和 PostgreSQL 具有相同数量的唯一约束。

    [TEST PRIMARY KEYS COUNT]
    ORACLEDB:DEPARTMENTS:1
    POSTGRES:departments:1
    ORACLEDB:EMPLOYEES:1
    POSTGRES:employees:1
    [ERRORS PRIMARY KEYS COUNT]
    正常，Oracle 和 PostgreSQL 具有相同数量的主键。

    [TEST CHECK CONSTRAINTS COUNT]
    ORACLEDB:DEPARTMENTS:1
    POSTGRES:departments:1
    ORACLEDB:EMPLOYEES:1
    POSTGRES:employees:1
    [ERRORS CHECK CONSTRAINTS COUNT]
    正常，Oracle 和 PostgreSQL 具有相同数量的检查约束。

    [TEST NOT NULL CONSTRAINTS COUNT]
    ORACLEDB:DEPARTMENTS:1
    POSTGRES:departments:1
    ORACLEDB:EMPLOYEES:1
    POSTGRES:employees:1
    [ERRORS NOT NULL CONSTRAINTS COUNT]
    正常，Oracle 和 PostgreSQL 具有相同数量的非空约束。

    [TEST COLUMN DEFAULT VALUE COUNT]
    ORACLEDB:DEPARTMENTS:1
    POSTGRES:departments:1
    ORACLEDB:EMPLOYEES:1
    POSTGRES:employees:1
    [ERRORS COLUMN DEFAULT VALUE COUNT]
    正常，Oracle 和 PostgreSQL 具有相同数量的列默认值。

    [TEST IDENTITY COLUMN COUNT]
    ORACLEDB:DEPARTMENTS:1
    POSTGRES:departments:1
    ORACLEDB:EMPLOYEES:0
    POSTGRES:employees:0
    [ERRORS IDENTITY COLUMN COUNT]
    正常，Oracle 和 PostgreSQL 具有相同数量的标识列。

    [TEST FOREIGN KEYS COUNT]
    ORACLEDB:DEPARTMENTS:0
    POSTGRES:departments:0
    ORACLEDB:EMPLOYEES:1
    POSTGRES:employees:1
    [ERRORS FOREIGN KEYS COUNT]
    正常，Oracle 和 PostgreSQL 具有相同数量的外键。

    [TEST TABLE COUNT]
    ORACLEDB:TABLE:2
    POSTGRES:TABLE:2
    [ERRORS TABLE COUNT]
    正常，Oracle 和 PostgreSQL 具有相同数量的 TABLE。

    [TEST TABLE TRIGGERS COUNT]
    ORACLEDB:DEPARTMENTS:0
    POSTGRES:departments:0
    ORACLEDB:EMPLOYEES:1
    POSTGRES:employees:1
    [ERRORS TABLE TRIGGERS COUNT]
    正常，Oracle 和 PostgreSQL 具有相同数量的表触发器。

    [TEST TRIGGER COUNT]
    ORACLEDB:TRIGGER:2
    POSTGRES:TRIGGER:2
    [ERRORS TRIGGER COUNT]
    正常，Oracle 和 PostgreSQL 具有相同数量的 TRIGGER。

    [TEST VIEW COUNT]
    ORACLEDB:VIEW:1
    POSTGRES:VIEW:1
    [ERRORS VIEW COUNT]
    正常，Oracle 和 PostgreSQL 具有相同数量的 VIEW。

    [TEST MVIEW COUNT]
    ORACLEDB:MVIEW:0
    POSTGRES:MVIEW:0
    [ERRORS MVIEW COUNT]
    正常，Oracle 和 PostgreSQL 具有相同数量的 MVIEW。

    [TEST SEQUENCE COUNT]
    ORACLEDB:SEQUENCE:1
    POSTGRES:SEQUENCE:0
    [ERRORS SEQUENCE COUNT]
    SEQUENCE 在 Oracle (1) 和 PostgreSQL (0) 中的数量不同。

    [TEST TYPE COUNT]
    ORACLEDB:TYPE:1
    POSTGRES:TYPE:0
    [ERRORS TYPE COUNT]
    TYPE 在 Oracle (1) 和 PostgreSQL (0) 中的数量不同。

    [TEST FDW COUNT]
    ORACLEDB:FDW:0
    POSTGRES:FDW:0
    [ERRORS FDW COUNT]
    正常，Oracle 和 PostgreSQL 具有相同数量的 FDW。

    [TEST FUNCTION COUNT]
    ORACLEDB:FUNCTION:3
    POSTGRES:FUNCTION:3
    [ERRORS FUNCTION COUNT]
    正常，Oracle 和 PostgreSQL 具有相同数量的函数。

    [TEST SEQUENCE VALUES]
    ORACLEDB:EMPLOYEES_NUM_SEQ:1285
    POSTGRES:employees_num_seq:1285
    [ERRORS SEQUENCE VALUES COUNT]
    正常，Oracle 和 PostgreSQL 的序列值相同

    [TEST ROWS COUNT]
    ORACLEDB:DEPARTMENTS:27
    POSTGRES:departments:27
    ORACLEDB:EMPLOYEES:854
    POSTGRES:employees:854
    [ERRORS ROWS COUNT]
    正常，Oracle 和 PostgreSQL 具有相同数量的行。

数据验证 数据验证包括比较从指向源 Oracle 表的外部表检索的数据与数据导出后得到的本地 PostgreSQL 表的数据。

要运行数据验证，您可以像使用任何其他 Ora2Pg 操作一样使用直接连接，但您也可以使用 oracle_fdw、mysql_fdw 或 tds_fdw 扩展，前提是已设置 FDW_SERVER 和 PG_DSN 配置指令。

默认情况下，Ora2Pg 将从两侧提取前 10000 行，您可以使用 DATA_VALIDATION_ROWS 指令更改此值。当设置为零时，将比较表的所有行。

数据验证要求表具有主键或唯一索引，并且键列不是 LOB。行将使用此唯一键进行排序。由于 Oracle 和 PostgreSQL 之间的排序行为存在差异，如果 PostgreSQL 中唯一键列的排序规则不是 'C'，则排序顺序可能与 Oracle 不同。在这种情况下，数据验证将失败。

数据验证必须在任何数据被修改之前完成。

Ora2Pg 将在达到 DATA_VALIDATION_ROWS 或遇到 10 个错误后停止比较两个表，结果默认转储到当前目录中名为“data_validation.log”的文件中。可以使用配置指令 DATA_VALIDATION_ERROR 控制在停止行差异比较之前允许的错误数量。所有有错误的行都将打印到输出文件中供您分析。

可以通过使用 -P 选项或 ora2pg.conf 中的相应配置指令 PARALLEL_TABLES 来并行化数据验证。

系统更改号 (SCN) 的使用 Ora2Pg 能够按特定 SCN 导出数据。您可以在命令行使用 -S 或 --scn 选项设置它。您可以指定特定的 SCN，或者如果您希望在首次连接时使用当前 SCN，请将值设置为 'current'。在后一种情况下，如果连接用户具有“SELECT ANY DICTIONARY”或“SELECT_CATALOG_ROLE”角色，将在 v$database 视图中查找当前 SCN。

使用示例：

    ora2pg -c ora2pg.conf -t COPY --scn 16605281

这会将以下子句添加到用于检索数据的查询中，例如：

    AS OF SCN 16605281

您还可以使用 --scn 选项，通过指定时间戳表达式而不是 SCN 来使用 Oracle 闪回功能。例如：

    ora2pg -c ora2pg.conf -t COPY --scn "TO_TIMESTAMP('2021-12-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')"

这会将以下子句添加到用于检索数据的查询中：

    AS OF TIMESTAMP TO_TIMESTAMP('2021-12-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')

或者例如仅检索昨天的数据：

    ora2pg -c ora2pg.conf -t COPY --scn "SYSDATE - 1"

变更数据捕获 (CDC) Ora2Pg 没有允许导入数据并仅在首次导入后应用更改的功能。但是，您可以使用 --cdc_ready 选项导出数据，并在表导出时注册 SCN。每个表的所有 SCN 默认写入名为 TABLES_SCN.log 的文件，您可以使用 -C | --cdc_file 选项更改该文件名。

在 COPY 或 INSERT 导出期间为每个表注册的这些 SCN 可与 CDC 工具一起使用。该文件的格式为每行 tablename:SCN。

将 BLOB 导入为大对象 默认情况下，Ora2Pg 将 Oracle BLOB 导入为 bytea，目标列使用 bytea 数据类型创建。如果您希望使用大对象而不是 bytea，只需在 ora2pg 命令中添加 --blob_to_lo 选项。它将创建数据类型为 Oid 的目标列，并使用 lo_from_bytea() 函数将 BLOB 保存为大对象。lo_from_bytea() 调用返回的 Oid 将插入到目标列中，而不是 bytea。由于使用了该函数，此选项只能用于 SHOW_COLUMN、TABLE 和 INSERT 操作。不允许使用 COPY 操作。

如果您希望使用 COPY 或拥有无法使用 lo_from_bytea() 导入的超大尺寸 BLOB（> 1GB），可以在 ora2pg 命令中添加 --lo_import 选项。这将允许分两次导入数据。

1) 使用 COPY 或 INSERT 导出数据时，会将 BLOB 的 Oid 目标列设置为值 0，并将 BLOB 值保存到专用文件中。它还会创建一个 Shell 脚本，用于使用 psql 命令 \lo_import 将 BLOB 文件导入数据库，并将表 Oid 列更新为返回的大对象 Oid。该脚本命名为 lo_import-TABLENAME.sh

2) 在设置环境变量 PGDATABASE 以及（可选地）PGHOST、PGPORT、PGUSER 等（如果它们与 libpq 的默认值不对应）之后，执行所有 lo_import-TABLENAME.sh 脚本。

您可能还需要手动对表执行 VACUUM FULL 以消除表更新造成的膨胀。

限制：表必须具有主键，主键用于设置 WHERE 子句，以便在大对象导入后更新 Oid 列。使用第二种方法（--lo_import）导入 BLOB 非常慢，因此应保留用于 BLOB > 1GB 的行。对于所有其他行，使用 --blob_to_lo 选项。要筛选行，您可以在 ora2pg.conf 中使用 WHERE 配置指令。

支持 作者/维护者 Gilles Darold

请将任何错误、补丁、帮助等报告至 。

功能请求 如果您需要新功能，请通过 告知我。这对开发更好/更有用的工具非常有帮助。

如何贡献 任何有助于构建更好工具的贡献都是受欢迎的。只需向我发送您的想法、功能请求或补丁，它们将被采用。

许可 版权所有 (c) 2000-2026 Gilles Darold - 保留所有权利。

    本程序是自由软件：您可以根据自由软件基金会发布的 GNU 通用公共许可证（版本 3 或任何更高版本）重新分发和/或修改它。

    本程序的分发旨在希望它有用，但不提供任何明示或暗示的保证，包括但不限于适销性和特定用途适用性的保证。有关更多详细信息，请参见 GNU 通用公共许可证。

    您应该已随本程序收到 GNU 通用公共许可证的副本。如果没有，请参见 <http://www.gnu.org/licenses/>。

致谢 非常感谢所有伟大的贡献者。有关所有致谢，请参见更改日志。