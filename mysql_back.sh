#!/bin/bash
#mysql 备份脚本
#保留最近10天备份

#备份目录
backupDir=/home/backup/database
#备份日志目录
backuplogDir=/home/backup/log
#mysqlDump
mysqldump=/usr/local/mysql/bin/mysqldump  
#ip
host=127.0.0.1
#用户名
username= xxx
password=123456


#今天日期
today=`date +%Y%m%d`
#十天前的日期
timeTenDayAgo=`date -d -10day +%Y%m%d`
#要备份的数据库数组
databases=(zuyunsys)


# echo $databaseCount

for database in ${databases[@]}
  do
#    echo '开始备份'$database
    $mysqldump -h$host -u$username -p$password --flush-logs --single-transaction $database  > $backupDir/$database-$today.sql

    if [ "$?" == 0 ];then
      echo "$today: $database backup Succ" >> $backuplogDir/mysql_back.log
    else
      echo -e "\033[31m$today: $database backup Failed\033[0m" >> $backuplogDir/mysql_back.log
    fi

    if [ ! -f "$backupDir/$database-$timeTenDayAgo.sql" ]; then
      echo "$today: 10天前备份不存在，无需删除"  >> $backuplogDir/mysql_del.log
    else
      echo -e "\033[31m$today: '删除10天前备份文件' $backupDir/$database-$timeTenDayAgo.sql\033[0m"  >> $backuplogDir/mysql_del.log
      #rm -f $backupDir/$database-$timeTenDayAgo.sql
    fi
  done