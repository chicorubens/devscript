MIGRATE: São arquivos no laravel que fazem o trabalha DDL e DML, 
onde a criação e manipulação de bancos e tabelas ficam armazenados e isso 
independente do SGBD usado, ou seja, pode mudar o banco que vai funcionar, 
podendo assim voltar e reexecutar ações para criações e testes da base de dados,
trabalhando de forma eficaz o controle de versão.

tomando um exemplo de tabela chamada posts em MariaDB ou MySQL:

CREATE TABLE `posts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `author` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

____________________________________________________________________________________

como seria a tabela usando MIGRATION, tanto para a criação 
quanto para reversão da crianção da tabela.

    public function up(): void
    {
        Schema::create('posts', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->text('content');
            $table->string('author');
            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('posts');
    }
_____________________________________________________________________________________

    CRIAÇÂO:

    $ PHP ARTISAN MAKE:MIGRATION <NOME DA MIGRATE> --CREATE = <TABELA>

    EX: $ php artisan make:migration create_posts_table --table=posts

    *obs sem o --create=posts o laravel vai entender que quer a criação de tabela posts
    pela nomeclatura usada.

______________________________________________________________________________________

    EDIÇÃO: 

    *caso altere campos lembre-se de usa: $ composer require doctrine/dbal

    PHP ARTISAN MAKE:MIGRATION <NOME DA MIGRATE> --TABLE = <TABELA>

    EX: $ php artisan make:migration alter_posts_table_foreign --table=posts

    *com esse comando a edição vai respeitar o rollback e assim garantir a versão e
    a reversão da tabela inserindo um campo author.

    public function up(): void
    {
        *para uso avançado do banco, pode-se desabilitar exigencia de checagem da chave estrangeira
        para bancos.
        
        Schema::disableForeignKeyConstraints();

        Schema::table('posts', function (Blueprint $table) {
            //
            -- $table->unsignedbigInteger('user_id');
            -- $table->foreign('user_id')->references('id')->on('users');

            $table->foreignId('user_id')
            ->constrained('users', 'id')
            ->onDelete('CASCADE');
        });

        Schema::enableForeignKeyConstraints();
    }

    public function down(): void
    {
        Schema::table('posts', function (Blueprint $table) {
            $table->dropForeign(['user_id']);
            $table->dropColumn(['user_id']);
        });
    }

______________________________________________________________________________________

    COMANDOS DIRETOS SQL NO BANCO: EXWMPLO COM VIEW

    public function up(): void
    {
        DB::statement('CREATE VIEW view_users AS SELECT name, email FROM users');
    }

    public function down(): void
    {
        DB::statement('DROP VIEW view_users');
    }
______________________________________________________________________________________

    MOSTRANDO STUBS DA MIGRATION E TAMBÉM GERAL DE QUALQUER SCHEMA DOS COMANDOS ARISAN

    $ php artisan stub:publish

        *obs: com isso será criado uma pasta com os modelos dos schemas de crianção
        chamada de STUB e localizada na raiz do projeto e poderá editá-las.

______________________________________________________________________________________

    EXECUTANDO ESQUEMA DUMP DA MIGRATION

        *obs: esse recurso que pode "achatar as migrations", onde será criado um arquivos
        SQL em que criará todas as tabelas do migration e assim despoluindo a pasta
        migrations.
        *obs: cuidado por que se perde a capacidade de versões.
        *pode ser necessário executar comando no Docker para poder funcionar.

        -na pasta do projeto execute:

    usuario@notebook:~/dev/projeto$ sail root-shell

    e ficará assim:

    root@bee49ed48a4:/var/www/html# 

    então execute o comando

    root@bee49ed48a4:/var/www/html# apt remove mysql-client
    root@bee49ed48a4:/var/www/html# apt get update
    root@bee49ed48a4:/var/www/html# apt get instal mariadb-client
    root@bee49ed48a4:/var/www/html# exit

    $ php artisan schema:dump               //cria a pasta schema e o arquivo schema.dump
    ou 
    $ php artisan schema:dump --prune       //para criar e apagar as migrations