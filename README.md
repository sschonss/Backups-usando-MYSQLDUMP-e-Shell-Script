# Backups usando MYSQLDUMP e Shellscript
---

## Introdução

Esse script foi desenvolvido para fins didaticos, para que possamos ter uma noção de como funciona o backup de um banco de dados MySQL utilizando o mysqldump e o shellscript.

## Requisitos

Nesse exemplo, utilizamos algumas tecnologias para facilitar o processo:

- Ubuntu 18.04 ou superior
- [Cron](https://help.ubuntu.com/community/CronHowto)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [MySQL](https://www.mysql.com/) ou [MariaDB](https://mariadb.org/)
- Alguma IDE para editar os scripts de sua preferência, no meu caso, utilizei o [Visual Studio Code](https://code.visualstudio.com/)
- Alguma IDE para Banco de Dados de sua preferência, no meu caso, utilizei o [DataGrip](https://www.jetbrains.com/pt-br/datagrip/)

---

## Criação do Banco de Dados

Para criar o banco de dados, utilizamos o Docker e o Docker Compose, para isso, crie uma pasta chamada `database` e dentro dela um arquivo chamado `docker-compose.yml` e adicione o seguinte conteúdo:

```yml
version: '3.7'

services:
  db:
    image: mysql:5.7
    volumes:
      - mysql:/var/lib/mysql
    restart: always
    environment:
      TZ: America/Sao_Paulo
      MYSQL_ROOT_PASSWORD: root
    ports:
      - "3306:3306"

```

Agora, execute o comando `docker-compose up -d` para criar o container do banco de dados.

Lembrando que as configurações de timezone e senha do root, podem ser alteradas conforme sua necessidade. Para mais informações, acesse a documentação do [MySQL](https://hub.docker.com/_/mysql) ou [MariaDB](https://hub.docker.com/_/mariadb).

Nesse exemplo, utilizamos o MySQL, mas você pode utilizar o MariaDB, basta alterar a imagem do container no arquivo `docker-compose.yml`:

```yml
image: mariadb:10.5
```
As senhas e portas de acesso, devem ser alteradas conforme a necessidade.

---

## Populando o Banco de Dados

Depois de criar o container do banco de dados, vamos criar uma tabela e inserir alguns dados, para isso, utilizei o DataGrip, mas você pode utilizar qualquer outra IDE para Banco de Dados.

Crie uma nova conexão com o banco de dados, utilizando o host `localhost` e a porta `3306`, o usuário `root` e a senha `root`.

Após criar a conexão, crie uma nova base de dados usando o script abaixo:

```sql

create database testdb;

create table users (id int, name varchar(255), email varchar(255), password varchar(255), created_at datetime, updated_at datetime, primary key (id));

insert into users (id, name, email, password, created_at, updated_at)
values (1, 'John Doe', 'jonh@email.com', '123456', now(), now()),
       (2, 'Jane Doe', 'jane@email.com', '123456', now(), now()),
       (3, 'John Smith', 'smith@email.com', '123456', now(), now());

```

Aqui criamos uma base de dados chamada `testdb` e uma tabela chamada `users`, com os campos `id`, `name`, `email`, `password`, `created_at` e `updated_at`.

Logo após, inserimos alguns dados na tabela `users`.

---

## Criando o Script de Backup

Agora, vamos criar o script de backup, para isso, dentro da pasta `database`, crie uma pasta chamada `backup` e dentro dela um arquivo chamado `backup.sh` e adicione o seguinte conteúdo:

```sh

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

```

Aqui, definimos o usuário e senha do banco de dados, o diretório onde serão salvos os backups e a lista dos bancos de dados que serão realizados o backup.

Depois, verificamos se existe o diretório para o backup, caso não exista, criamos o diretório.

Por fim, fazemos um loop para backupear todos os bancos de dados.

O comando `docker exec database_backup /usr/bin/mysqldump -u$USER -p$PASS $db > $DIR_BK/backup.sql` é responsável por executar o comando `mysqldump` dentro do container do banco de dados, passando o usuário, senha e o banco de dados que será realizado o backup.

Perceba que o nome do container do banco de dados é `database_backup`, isso porque, no arquivo `docker-compose.yml`, definimos o nome do container como `database_backup`.

---

**ATENÇÃO** 

- Para a sua segurança, não utilize a senha `root` em produção, crie uma senha mais segura. Para mais informações, acesse a documentação do MySQL ou MariaDB.
- O diretório `/home/schons/codes/backup_sh_doc/database/backup/files` é apenas um exemplo, você deve alterar o diretório conforme sua necessidade.

- Use variáveis de ambiente para armazenar as senhas e usuários do banco de dados, para mais informações, acesse a documentação do [Docker](https://docs.docker.com/compose/environment-variables/).

---

## Automatizando o Backup

Agora, vamos automatizar o backup, para isso, no seu terminal, execute o comando `crontab -e` e adicione a seguinte linha:

```sh

0 0 * * * /home/schons/codes/backup_sh_doc/database/backup/backup.sh

```

Aqui, estamos dizendo que o script de backup será executado todos os dias, às 00:00.

Caso voce queira executar o backup a cada 5 minutos, por exemplo, basta alterar a linha para:

```sh

*/5 * * * * /home/schons/codes/backup_sh_doc/database/backup/backup.sh

```

Para entender um pouco mais como funciona o cron, acesse a documentação do [crontab](https://crontab.guru/). Nele, você pode testar a sua configuração e entender melhor como funciona.

---

Chegando até aqui, você já deve ter entendido como criar um script de backup para o banco de dados, utilizando o Docker e o cron.

Relembrando novamente, o script de backup é apenas um exemplo didatico, você pode criar o seu próprio script de backup, de acordo com a sua necessidade.

Espero que tenha gostado do artigo, até a próxima!

Qualquer dúvida, sugestão, criticas ou correções, fique a vontade para comentar abaixo.

---

## Referências

- [Docker](https://www.docker.com/)
- [MySQL](https://www.mysql.com/)
- [MariaDB](https://mariadb.org/)
- [Crontab](https://crontab.guru/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Docker Compose Environment Variables](https://docs.docker.com/compose/environment-variables/)

---