# Pessoa API - Delphi

## 📌 Descrição

O sistema foi desenvolvido em arquitetura de 3 camadas, utilizando API REST com Horse, persistência via FireDAC e SQLite embarcado, garantindo fácil execução sem dependências externas.

A rotina de integração com ViaCEP foi implementada utilizando Threads, evitando bloqueio da aplicação principal.

Optei por SQLite para simplificar a execução do teste e eliminar dependências externas de instalação/configuração de banco de dados, mantendo a arquitetura em três camadas, persistência com FireDAC e integridade relacional entre as tabelas. O sistema cria automaticamente a base e a estrutura inicial na primeira execução.

A inserção em lote foi implementada utilizando queries preparadas e transações controladas em blocos, reduzindo overhead de execução e melhorando a performance para grandes volumes de dados.

---

## 🚀 Como executar

1. Executar `PessoaAPI.exe`  
2. A API estará disponível em:  
   http://localhost:9000  
3. Executar `Cliente.exe`  
4. Informar a URL da API no cliente  

Na primeira execução:
- O banco SQLite será criado automaticamente
- As tabelas serão geradas

---

## 📡 Endpoints

### Pessoas

| Método | Endpoint | Descrição |
|--------|---------|----------|
| POST   | /pessoas        | Inserir pessoa |
| PUT    | /pessoas/:id    | Atualizar pessoa |
| DELETE | /pessoas/:id    | Excluir pessoa |
| GET    | /pessoas/:id    | Buscar por ID |
| GET    | /pessoas        | Listar todas |
| POST   | /pessoas/lote   | Inserção em lote |

---

### Integração CEP

| Método | Endpoint | Descrição |
|--------|---------|----------|
| POST   | /integracao/ceps | Atualiza dados via ViaCEP |

---

## 🧪 Testes

### Postman

Collection disponível em: /postman/PessoaAPI.postman.json



---

### Inserção em lote (teste de carga)

Arquivo disponível:/pessoas_50000.json


Utilizar no endpoint: POST /pessoas/lote

Objetivo:
- validar performance
- testar processamento em volume
- demonstrar estratégia de inserção em lote

---

## 🧱 Arquitetura

O projeto segue o padrão de 3 camadas:

- **Controller** → exposição da API (rotas REST)
- **Service** → regras de negócio
- **Repository** → acesso a dados (FireDAC)

Estruturas adicionais:

- **Model** → entidades
- **Thread** → integração assíncrona de CEP
- **Infra** → conexão e inicialização do banco

---

## 🔄 Integração ViaCEP

- Executada em **Thread**
- Não bloqueia a API
- Consome: https://viacep.com.br/ws/{cep}/json/
- Atualiza a tabela `endereco_integracao`

---

## 🗄️ Banco de Dados

- SQLite embarcado
- Criado automaticamente na primeira execução
- Relacionamentos com integridade referencial
- Exclusão em cascata configurada

---

## ⚙️ Tecnologias utilizadas

- Delphi
- Horse (REST)
- FireDAC
- SQLite

---

# 💻 Cliente Pessoa API

## 📌 Descrição

Aplicação cliente desenvolvida em Delphi (VCL) para consumo da API REST.

---

## 🖥️ Funcionalidades

- Inserir pessoa
- Alterar pessoa
- Excluir pessoa
- Buscar por ID
- Listar registros
- Inserção em lote via JSON
- Disparar integração de CEP
- Visualização de retorno JSON
- Exibição em grid

---

## ▶️ Como utilizar

1. Executar o Cliente
2. Informar a URL da API: http://localhost:9000
3. Utilizar os botões da interface

---

## 📋 Operações disponíveis

### CRUD
- Inserir
- Alterar
- Excluir
- Buscar por ID
- Listar

### Lote
- Envio de múltiplos registros via JSON

### Integração CEP
- Dispara atualização via ViaCEP no servidor

---

## 📊 Interface

- Grid com dados retornados
- Campos de edição para cadastro
- Área de visualização do JSON retornado

---

## 📌 Observações

- Cliente simples focado em testes e validação da API
- Interface objetiva para demonstrar funcionalidades
- Tratamento de erros baseado no retorno da API




## 🚀 Explicação
Estruturei o projeto seguindo uma separação próxima ao MVC, adaptada para uma API REST em 3 camadas. 
A View ficou no cliente VCL, responsável apenas pela interação com o usuário. 
O Controller ficou no servidor, concentrando as rotas Horse e tratando entrada e saída JSON. 
As regras de negócio ficaram nos Services, como validações, transações e inserção em lote. 
A persistência ficou nos Repositories, isolando o acesso ao banco via FireDAC. 
Os Models representam as entidades do domínio, e a camada Infra concentra conexão e inicialização do banco. 
Essa separação evita acoplamento, facilita manutenção e permite trocar partes do sistema com menor impacto.


- Model: Criei os Models para representar as entidades do domínio e facilitar o transporte de dados entre Controller, Service e Repository.

- View: Mantive a camada visual separada no projeto cliente, evitando que a interface acessasse diretamente o banco de dados.

- Controller: Criei os Controllers para concentrar as rotas REST e manter a comunicação HTTP separada das regras de negócio.

-  Service: Usei Services para concentrar regras de negócio e manter os Controllers simples e desacoplados da persistência.

- Repository: Os Repositories foram criados para isolar a persistência e evitar SQL espalhado pela aplicação.

- Infra: A camada Infra concentra configurações técnicas da aplicação, como conexão e inicialização do banco.

- Thread: Separei a rotina de CEP em Thread para executar o processamento em segundo plano sem travar a aplicação principal.


View      → Tela do cliente
Controller→ Rotas REST no Horse
Model     → Entidades Pessoa/Endereco
Service   → Regras de negócio
Repository→ SQL e banco
Infra     → Conexão e criação do banco
Thread    → Integração ViaCEP em segundo plano

