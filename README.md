# Sistema de Gestão Transacional para Controle de Estoque e Vendas

## Visão Geral
Este projeto foi desenvolvido como parte do curso de Ciência da Computação na FIB. Ele demonstra a aplicação de **Modelagem de Dados Relacional** e a criação de **Lógica de Negócio** diretamente no banco de dados utilizando **T-SQL (SQL Server)**.

O objetivo é simular as transações críticas de um sistema de vendas, garantindo a integridade e a segurança dos dados.

## Funcionalidades e Habilidades Demonstradas
O sistema implementa as seguintes regras de negócio e utiliza as habilidades:

* **Modelagem de Dados:** Criação de um esquema relacional com 4 entidades (Produtos, Clientes, Vendas e Entradas).
* **Controle de Transações (Stored Procedures):** Automação de processos complexos através de procedimentos armazenados (`gerenciamentoprod` e `atualizacoes`).
* **Validação de Negócio Crítica:** Uso de estruturas de controle (`IF/ELSE`) para:
    * Verificar o **Limite de Crédito** do cliente antes de finalizar uma venda.
    * Checar a **Disponibilidade de Estoque** antes de registrar a saída de um produto.
* **Atualização de Dados:** Lógica para ajuste de preço baseado em porcentagem.
* **Análise Agregada:** Consultas para calcular o valor total de estoque, preço médio, e contagem de produtos (`SUM`, `AVG`, `COUNT`).
