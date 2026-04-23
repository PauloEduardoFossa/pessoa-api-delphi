## Como executar

1. Execute PessoaAPI.exe
2. A API estará disponível em http://localhost:9000
3. Execute o Cliente.exe
4. Informe a URL da API e utilize as funcionalidades


# SERVIDOR (API) - Pessoa API

## 📌 Descrição

O sistema foi desenvolvido em arquitetura de 3 camadas, utilizando API REST com Horse, persistência via FireDAC e SQLite embarcado, garantindo fácil execução sem dependências externas.

A rotina de integração com ViaCEP foi implementada utilizando Threads, evitando bloqueio da aplicação principal.

Optei por SQLite para simplificar a execução do teste e eliminar dependências externas de instalação/configuração de banco de dados, mantendo a arquitetura em três camadas, persistência com FireDAC e integridade relacional entre as tabelas. O sistema cria automaticamente a base e a estrutura inicial na primeira execução.

A inserção em lote foi implementada utilizando queries preparadas e transações controladas em blocos, reduzindo overhead de execução e melhorando a performance para grandes volumes de dados.

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

## 🚀 Como executar

1. Compilar o projeto `PessoaAPI`
2. Executar o `.exe`
3. A API estará disponível em: http://localhost:9000



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

## 📌 Observações

- Não é necessário instalar banco de dados
- Projeto focado em clareza arquitetural e organização
- Estrutura preparada para fácil evolução


# Cliente Pessoa API

## 📌 Descrição

Aplicação cliente desenvolvida em Delphi (VCL) para consumo da API REST PessoaAPI.

Permite realizar operações de cadastro, consulta, exclusão, inserção em lote e integração de CEP.

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

## 🔗 Configuração

Antes de utilizar, informe a URL da API: http://localhost:9000


---

## ▶️ Como executar

1. Compilar o projeto Cliente
2. Executar o `.exe`
3. Informar a URL da API
4. Utilizar os botões da interface

---

## 📋 Operações disponíveis

### CRUD

- Inserir
- Alterar
- Excluir
- Buscar por ID
- Listar

---

### Lote

- Permite envio de arquivo JSON com múltiplos registros
- Ideal para testes de performance

---

### Integração CEP

- Dispara a rotina de atualização via API ViaCEP
- Execução assíncrona no servidor

---

## 📊 Interface

- Grid com dados retornados
- Campos de edição para cadastro
- Área de visualização do JSON retornado

---

## ⚙️ Tecnologias utilizadas

- Delphi VCL
- THTTPClient
- JSON (System.JSON)

---

## 📌 Observações

- Cliente simples focado em testes e validação da API
- Interface objetiva para demonstrar funcionalidades
- Tratamento de erros baseado no retorno da API
