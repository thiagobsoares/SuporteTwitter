## Suporte Twitter.

Aplicativo desenvolvido para listar em uma página web, os tweets do Twitter que mencionam um usuário especifico, ordenando-os (decrescente) pelo número de seguidores, retweets e likes.

Foi utilizado a linguaguem ruby, framework rails e rspec-rails para teste.

**Utilizando API:**

- API deve ser clonada no diretório de preferência
- Deve subir o servidor da API com o comando 'rails s' (servidor utilizado: **Puma**)
- Link para acesso: **http://localhost:3000/tweets**


_Obs: O nível do logger padrão esta como debug_

Se necessário mudar o nível do logger, deve seguir os seguintes passos:

- Entrar no diretório config/environment.rb
- Alterar Rails.logger.level para o nível necessário.
(0 - debug, 1 - info, 2 - warn, 3 - error, 4 - fatal, 5 - unknown)

Para executar os teste dentro do diretório da API, deve ser usado o comando:
_rspec spec_

**Estrutura da API:**

@@@@
Pacote: integration 
Classes utilizadas para chamar serviços devem ser inseridas neste pacote.<br>

Class: IntegrationLocawebMock
Responsável por chamar o serviço 'http://tweeps.locaweb.com.br/tweeps' e devolver apenas o corpo do serviço sem nenhuma formatação.


@@@@
Pacote: error
Classes criadas para notificar algum erro da aplicação devem ser inseridas neste pacote.

Class: BadConnection
Caso aconteça algum erro na conexão com o serviço, está classe é lançada.

@@@@
Pacote: factories
Classes responsáveis pela criação de outras classes.

Class: TweetsJsonFactory 
Classe utilizada para facilitar a criação de casos de teste, criando estruturas de JSON igual a do service.

Class: UserTweetsObjFactory 
Classe utilizada para facilitar a criação de casos de teste, criando objetos das classes User e Tweets.

@@@@
Pacote: model
Pacote para armazenar as classes de modelos da aplicação.


Class: Tweet 
Representa um tweet, para manter o encapsulamento, não existe métodos para alterar os valores, somente na criação do objeto.

Atributos:
id - id do tweet
user - usuário que criou
retweets - quantidade de retweets
likes - quantidade de likes
text - texto do tweet
date - data de criação

Métodos:
url = retorna a url para o link direito, foi utilizado como contexto (https://twitter.com)
date_format =  formata a data para dia/mês/ano hora:minuto:segundo


Class: User 
Representa um user, para manter o encapsulamento, não existe métodos para alterar os valores, somente na criação do objeto.

Atributos do objeto:
id - id do user
name - nome da página do usuário
fallowers - quantidade de seguidores
tweets - lista de todos tweets do usuário

Métodos:
url = retorna a url para o link direito, foi utilizado como contexto (https://twitter.com)

Importante: Ambas classes verificam se os atributos NÃO são nil, caso algum atributo esteja nil é lançado um erro (ArgumentError) na inicialização do objeto.


@@@@
Pacote: controllers
Responsável por armazenar todos os controllers da aplicação

Class: TweetsController
Responsável por chamar as classes de modelos, neste controlle é inicializado uma constante aonde é armazenado o id utilizado para filtrar os tweets, além disso ele inicializa a classe de serviço e passa como parametro para classe responsável pela lógica.

@@@
Pacote: facade
Pacote responsavel por armazenar as classes facade

Class: TwitterFacade
Construtor: Recebe como parâmetro a implementação de uma classe que se comunica com o serviço (na aplicação é utilizada IntegrationLocawebMock que se comunica com o serviço http://tweeps.locaweb.com.br/tweeps)

Métodos:
tweets_json = Recebe o corpo de um response do serviço e faz o parse para json.
json_valid? = Verifica se o json é valido.
usuario_mencionado? = Verifica se o usuário foi mencionado no tweet (ambos passados por parâmetro)
parse_json_to_obj = Faz o parse de json para objeto (Tweet e User)
filter_by_user_mention = Filtra os tweets recebidos pelo serviço (seguindo a espeficicação, verifica se o usuário foi mencionado e não seja replay do mesmo usuário), além de filtar o método faz o agrupamento dos tweets por usuários.
order_tweets = Ordena os tweets conforme foi especificado, primeiro verifica o numero de seguidores do usuário, depois verifica os números de retweets e por últimos os likes.

Importante, se no serviço retornado estiver faltando algum parametro que é utilizado pela API, será lançado um erro (ArgumentError) informando o campo.
