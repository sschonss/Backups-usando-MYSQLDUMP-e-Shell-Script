# Define usuario e senha do banco
USER='root'
PASS='root'

# Diretorio onde serão salvos os backups
DIR_BK=/home/schons/codes/backup_sh_doc/database/backup/files

# Lista dos bancos de dados que serão realizados o backup
DATABASES=(testdb)

# Verifica se existe o diretorio para o backupsh 
if [ ! -d $DIR_BK ]; then
    mkdir -p $DIR_BK
fi


# Loop para backupear todos os bancos
for db in "${DATABASES[@]}"; do
    docker exec database_backup /usr/bin/mysqldump -u$USER -p$PASS $db > $DIR_BK/backup.sql
done


# Meia noite executa o backup
# 0 0 * * * bash /home/schons/codes/backup_sh_doc/database/backup/backup.sh