FACTORY: serve para preencher o banco de dados para testes
03.10 Criando sua primeira Factory

A partir da criação do MODEL:

php artisan make:model -f 		//para factory: Create a new factory for the model
ou 
php artisan make:model -all 	//para tudo: Generate a migration, seeder, 
								//factory, policy, resource controller, 
								//and form request classes for the model.


class PostFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            //
            'titlehead' => Str::of($this->faker->paragraph)->limit(146)->value(),
            'content' => $this->faker->text,
            'author' =>$this->faker->name,
            'user_id' => rand(1,3)
            //'user_id' => User::factory()->create()->id  //pegando do models User 
            										      //e criando tambem a relação
        ];
    }
*	use App\Models\User;
	use Illuminate\Support\Str;

*obs: para executar Factory

1-

*obs: ir na rota WEB e colocar antes do return o comando

$post = Post::factory()->count(50)->create();

__________________________ou_____________________________________

2-

php artisan tinker
>

ex:
> $post = Post::factory()->count(50)->create();


_________________________________________________________________

03.11 Sobrescrevendo a Convenção SOBRESCREVENDO FACTORY

-crie um novo factory: $ php artisan make:factory novoNome

*obs: Faça a edição do arquivo HasFactory.php declarado no Models, "User.php" por exemplo
*declara esse comando dentro do Model que terá a sobrescrição, /Models/User.php 
   /**
     * Create a new factory instance for the model.
     *
     * @return \Illuminate\Database\Eloquent\Factories\Factory<static>
     */
    protected static function newFactory()
    {
        return novoNomeFactory::new();
    }

    e dentro do arquivo novoNomeFactory.php declaradodeclare até a variavel:


protected $model = User::class; //que é a classe sobrescrita.
ok

faça os comandos na nova factory novoNomeFactory e importe també as classes usadas comando

use App\Models\User;
use Illuminate\Support\Str; se necessário.

pronto!! execute novamente o tinker.

_________________________________________________________________

03.12 Utilizando State na Factory

* Na fabricação de dados podemos usar funcões para representar variaveis
no cadastro de campos das Tabelas do banco.

* Dentro do arquivo Factory, PostFactory por exemplo, crie uma função 
clousure, ou anônima, e denomine.

ex: numa definição de Status de um campo, onde ele possui 2 opções distintas

'status' => rand(1,2) 			//1 será publicado e 2 lixeira por exemplo.

public function published()
{
	return $this->state(function(array $attributes){

		return [
		'status' => 1
		];
	});
}
public function trash()
{
	return $this->state(function(array $attributes){

		return [
		'status' => 2
		];
	});
}

*então no tinker executa da seguinte forma usando as funções
php artisan tinker
>

ex:
> $post = Post::factory()->bublished()->create();
		ou
> $post = Post::factory()->trash()->create();

e com isso muda-se o valor do state conforme o teste, em vez da opção rand();
_________________________________________________________________

03.13 Sobrescrevendo informação da Factory

*então no tinker executa da seguinte forma usando valores direto.

> $post = Post::factory()->create(['status' => 1]);
		ou
> $post = Post::factory()->make(['status' => 2]);

*lembrando que esse dados ainda não foram persistidos no banco.
para isso basta digitar:

$post->save();
_________________________________________________________________

03.14 Relacionamentos na Factory

Dentro das Tabelas Models, nos arquivos referentes as tabelas que
tem relacionamentos entre si.

no caso 1 User.php tem n Post.php

vamos no Model de User.php:

 public function postsRelationship()
    {
        return $this->hasMany(Post::class, 'author', 'id');
    }

agora a parte inversa do relacionamento

vamos no Model de Post.php:

 public function authorRelationship()
    {
        return $this->belongsTo(User::class, 'author', 'id');
    }


no Tinker vamos fazer

> $user = User::HasFactory()->has(Post::Factory(), 'postsRelationship')->create();
*Nesse caso especifica-se, no has(), o 'postsRelationship'por ser declarativo, 

*caso no PostFactory.php estiver usando o comando:
'user_id' => User::factory()->create()->id  //pegando do models User 
                                              //e criando tambem a relação

*pode-se tirar o ->crate()->id, ficando apenas: 'user_id' => User::factory().
*com isso o Laravel cuida do processo automaticamente.

__________________________ou_____________________________________

> $user = User::HasFactory()->has(Post::Factory(), 'postsRelationship')->create();

__________________________ou_____________________________________

> $user = User::HasFactory()->hasPostRelationship()->create();

__________________________ou_____________________________________

> $user = Post::factory()->for(User::Factory(), 'authorRelationship')->create();

__________________________ou_____________________________________

> $user = Post::factory()->forAuthorRelationship()->create();

03.15 Uso de Seeder

$ php artisan make:seeder UserSeeder

 public function run(): void
    {
        DB::table('users')->insert([
            'name' => 'Francisco',
            'email' => 'teste@email',
            'password' => Hash::make('123456'),
        ]);

        // \App\Models\User::factory(10)->create();
    }

*No arquivo /seeder/DatabaseSeeder.php, chame a seed ou sequência de seeders

public function run(): void
    {
        $this->call([
            UserSeeder::class,
        ]);
    }

$ php artisan db:seed           //saida será a execução de DatabaseSeeder

*caso não queira chamar todas as seed listada no vetor de DatabaseSeeder, 
pode-se evocar apenas a seed, no caso do exemplo UserSeeder com comando.

$ php artisan db:seed --class=UserSeeder

*obs importante: caso esteja em ambiente de produção:

$ php artisan db:seed --force    //para que não seja pedido a confirmação e não atrapalhe.

*obs importante: caso esteja em ambiente de produção: e queira automatizar a fabricação de dados use:

$ php artisan migrate:fresh --seed