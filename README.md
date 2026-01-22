# Dashboard de Vendas (Kaggle → PostgreSQL → Power BI)

Projeto de portfólio para construir um dashboard de vendas de e-commerce no Power BI usando dados reais do Kaggle, carregados e organizados em um banco PostgreSQL.

## Arquitetura
Kaggle (CSV) → PostgreSQL (tabelas) → Power BI (dashboard)

## Tecnologias
- PostgreSQL
- Power BI Desktop
- (Opcional) Python: pandas + SQLAlchemy/psycopg2

PostgreSQL: host localhost, porta 5433 (ou a porta definida no .env), banco ecommerce, usuário postgres.

## Estrutura do repositório
- `data/` instruções do dataset (o CSV completo não é versionado)
- `db/` scripts SQL (criação de tabelas e consultas)
- `powerbi/` arquivos do Power BI (pbix pode ser versionado depois)

## Como reproduzir (visão geral)
1. Baixar o dataset do Kaggle (ver `data/README.md`)
2. Criar tabelas e carregar dados no PostgreSQL (etapas em `db/`)
3. Conectar o Power BI ao PostgreSQL e montar o dashboard

## KPIs do Dashboard (planejado)
- Faturamento total
- Número de pedidos
- Clientes únicos
- Ticket médio
- Vendas por período e por categoria
- Top produtos por faturamento
