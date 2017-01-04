SuporteTwitter

Aplicativo desenvolvido para listar em uma página web, os tweets do Twitter que mencionam um usuário especifico, ordenando-os (decrescente) pelo número de seguidores, retweets e likes.
Foi utilizado a linguaguem ruby, framework rails e rspec-rails para teste.

Utilizando API:

1 - API deve ser clonada no diretório de preferência
2 - Deve subir o servidor da API com o comando 'rails s' (servidor utilizado: Puma)
3 - Para acessar o link a API via web, deve entrar no link http://localhost:3000/tweets

Obs: O nível do logger padrão esta como debug

Se necessário mudar o nível do logger, deve seguir os seguintes passos:

1 - Entrar no diretóri config/environment.rb
2 - Alterar Rails.logger.level para o nível necessário. (0 - debug, 1 - info, 2 - warn, 3 - error, 4 - fatal, 5 - unknown)


Estrutura da API:

Pacote => integration 
Classes utilizadas para chamar serviços devem ser inseridas neste pacote.
Class => IntegrationLocawebMock
Responsável por chamar o serviço 'http://tweeps.locaweb.com.br/tweeps' e devolver apenas o corpo do serviço sem nenhuma formatação.

Pacote => error
Classes criadas para notificar algum erro da aplicação devem ser inseridas neste pacote.
Class => BadConnection
Caso aconteça algum erro na conexão com o serviço, está classe é lançada.

Pacote => factories
Classes responsáveis pela criação de outras classes.
Class => TweetsJsonFactory 
Classe utilizada para facilitar a criação de casos de teste, criando estruturas de JSON igual a do service.
Class => UserTweetsObjFactory 
Classe utilizada para facilitar a criação de casos de teste, criando objetos da classe User e Tweets.

Pacote => model
Pacote para armazenar as classes de modelos da aplicação.
Class => Tweet 
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


Class => User 
Representa um user, para manter o encapsulamento, não existe métodos para alterar os valores, somente na criação do objeto.
Atributos do objeto:
id - id do user
name - nome da página do usuário
fallowers - quantidade de seguidores
tweets - lista de todos tweets do usuário

Métodos:
url = retorna a url para o link direito, foi utilizado como contexto (https://twitter.com)

Importante: Ambas classes verificam se os atributos NÃO são nil, caso algum atributo esteja nil é lançado um erro (ArgumentError) na inicialização do objeto.
