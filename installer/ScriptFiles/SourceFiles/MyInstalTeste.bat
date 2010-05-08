msiexec.exe /qb /i mysql-5.1.33-win32.msi
"%programfiles%\MySQL\MySQL Server 5.1\bin\MySQLInstanceConfig" -r
"%programfiles%\MySQL\MySQL Server 5.1\bin\MySQLInstanceConfig" -i -q RootPassword=masterkey ServiceName=MySQL  "-p%programfiles%\MySQL\MySQL Server 5.1" AddBinToPath=yes ServerType=SERVER DatabaseType=MIXED ConnectionUsage=DSS Port=3306 StrictMode=yes Charset=latin1 "-l%programfiles%\MySQL\MySQL Server 5.1\instanceConfig.log"
"%programfiles%\Mysql\MySQL Server 5.1\bin\mysql" -u root -pmasterkey --execute="source dumpNutWin.sql"