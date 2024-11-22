# globoplay desafio mobile

## Preparo de ambiente

Para preparar o ambiente de desenvolvimento

baixar xcodegen

```shell
brew install xcodegen
```

e executa-lo na raíz deste projeto para criar projeto de xcode 

```shell
xcodegen
```

## Decisões técnincas

### Uso de request pelo URL session

A documentação da api TMDB faz sugestões de código competentes para as request. Com pouca modificações foi possível gerar a base das requests

Ao mesmo tempo as bibliotecas _wrappers_ sugeridas são pouco específicas.
Requisições mais complexas, com queries variadas, ou usando a query _append_to_response_ não são simples de serem feitas, os modelos de resposta não atendem completamente o que foi levantado

### Sobre o uso resources JSON para dados constantes

Foi identificado que algums tratamentos de gêneros são baseados em id. Para não ter necessidade de manter um `enum` com baixa manutenção, foi preferível manter as respostas da API que lista os gêneros em portugês como recurso, sem necessidade de realizar a requisição ou manter essa informação em memória de usuário (`UserDefault`, `CoreData`, `SwiftData`)
Seria possível também automatizar esse processo com _scripts_ pré _build_, ou com `swiftgen`. Isso está fora do escopo aqui por questões de tempo 

Considerando aqui que não à grandes mudanças que necessitem atualizações constantes dessa informação
