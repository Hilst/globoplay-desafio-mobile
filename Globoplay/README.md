# globoplay desafio mobile

## Preparo de ambiente

Ter ambiente de desenvolvimento iOS 17 e o comando python3 instalado.

Ter um develoment teams e trocá-lo no [project.yml](project.yml) onde indicado

Ter uma [chave para a API do TMDB](https://www.themoviedb.org/settings/api)

Expor no seu ambiente uma variável com sua chave da api como a seguir ou no contexto local de execução do comando de preparo:

```shell
export TMDB_API_KEY= '...'
```

baixar [xcodegen](https://github.com/yonaskolb/XcodeGen)

```shell
brew install xcodegen
```

e executa-lo na raíz deste projeto para criar projeto de xcode 

```shell
xcodegen
```

Com o projeto gerado é possível executá-lo com suporte às linguagens português brasileiro e inglês, a depender da sua configuração de desenvolvimento ou configuração de linguagens do iOS executando 

## Decisões técnincas

### Sobre uso de request pelo URL session

A documentação da api TMDB faz sugestões de código competentes para as request. Com pouca modificações foi possível gerar a base das requests

Ao mesmo tempo as bibliotecas _wrappers_ sugeridas são pouco específicas.
Requisições mais complexas, com _queries_ variadas, ou usando a _query_ _append_to_response_ não são simples de serem feitas e os modelos de resposta não atendem completamente o que foi levantado

Então foi desenvolvido em [Network](./Sources/Network/)

### Sobre o uso resources JSON para dados constantes

Foi identificado que algums tratamentos de gêneros e países são baseados em ids constantes ou de longuíssima duração. Para não ter necessidade de manter um `enum` com baixa manutenção, foi preferível manter as respostas da API que lista os gêneros e os países como recurso, sem necessidade de realizar a requisição em _runtime_ ou manter essa informação em memória de usuário

Seria possível também automatizar esse processo com _scripts_ pré _build_, ou com `swiftgen`. Mas considerando que essa informação seria manejada pelo _backend_. Foi dada prioridade à outros pontos. 

### Sobre o uso de iOS 17.0 e `SwiftData`

Foi escolhido para a manutenção de memória perene, para satisfazer a [_feature_ de favoritos](./Sources/Views/MyListView.swift) o uso do `SwiftData`

Por já ter trabalhado com a biblioteca em projetos pessoais e poder diminuir/simplificar para manutenção de estados persistentes.
Seria possível optar por outros modelos do iOS para informações perenes, como `UserDefaults` salvando os ids dos favoritos e `CoreData`.
Como idealmente essa também seria atribuição do _backend_ usando e manejando informações da sessão, igualmente foi dad prioridade à oturos pontos do projeto.

### Sobre uso do gyb para segurança da chave encriptatda

Para manter chaves encriptadas sem necessidade de relacionar o projeto a mais serviços terceiros, firebase, CloudKit, etc. Ou conectar com outros _backends_ que garantam a segurança por segregação de contextos.

Foi decidido por montar um arquivo com criptação simples e variável por build. Cada _xcodegen_ gerária um _salt_ e criptografia diferente para a chave.

Para isso foi usada a biblioteca [gyb](https://github.com/swiftlang/swift/blob/main/utils/gyb.py) também usada no repositório core da linguagem swift. Que monta um template baseado em _python_ para criação de arquivos.

Aqui o uso está sendo aplicado pelo script [gen_secrets.sh](./../scripts/secrets/gen_secrets.sh), que está mapeado na execução do _xcodegen_, para gerar o uma arquivo Secrets.swift em `./Sources/Network/Secrets.swift` baseado no template [Secrets.swift.gyb](./../scripts/secrets/Secrets.swift.gyb) 

## Resultado

[demonstração](https://youtube.com/shorts/svsFLSOralg?feature=share)
