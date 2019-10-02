#!/bin/bash -   
#title          :mysql_bkp.sh
#description    :script to realize a backup of the all databases in a single file
#author         :luis mauricio kihara
#date           :20190911
#version        :1      
#usage          :./mysql_bkp.sh
#notes          :       
#bash_version   :5.0.7(1)-release
#============================================================================


echo "Initiate the variables" 
DATA=$(date +"%d-%m-%y_%H-%M-%S")
HOST=$(hostname -s)

DB_USER='user'
DB_PASS='password'
DB_HOST='host'
DB_DATABASE=$(mysql -u $DB_USER -p$DB_PASS -h $DB_HOST -e "SHOW DATABASES;" | tr -d "| ")

# Beging of backup
for db in $DB_DATABASE; do

  if [ $db != "information_schema" -a $db != "Database" -a $db != "mysql" -a $db != "test" -a $db != "performance_schema" ]; then
    echo "Initiate the backup of $db"
    BKP_DIR="path"
    BKP_NAME=$HOST"_"$db"_"$DATA.sql
    BKP_COMP=$HOST"_"$db"_"$DATA.tar

    mysqldump --single-transaction --routines -u$DB_USER -p$DB_PASS -h$DB_HOST --databases $db > $BKP_DIR/$BKP_NAME

    tar -cf $BKP_DIR/$BKP_COMP -C $BKP_DIR $BKP_NAME
    bzip2 $BKP_DIR/$BKP_COMP

    echo "Remove the .sql files"
    rm -rf $BKP_DIR/$BKP_NAME
  fi
done

mount -t nfs nfs_server:nfs_path mount_path

if mountpoint -q "mount_path"; then

  echo "Verifying if the directory already exist"
  if [ -d /mnt/documentos/backups/pgz-srv-ds/bkp_diario_Mysql/$(date +"%m-%Y") ]; then
  echo "Copying the files"
    cp $BKP_DIR/* /mnt/documentos/backups/pgz-srv-ds/bkp_diario_Mysql//$(date +"%m-%Y")
    umount /mnt/documentos
  else
  echo "Create the directory and copy the files"
    mkdir -p /mnt/documentos/backups/pgz-srv-ds/bkp_diario_Mysql/$(date +"%m-%Y")
    cp $BKP_DIR/* /mnt/documentos/backups/pgz-srv-ds/bkp_diario_Mysql//$(date +"%m-%Y")
    umount /mnt/documentos
  fi
else
  echo "It's not possible to mount the path"
fi

echo "End of backup"
