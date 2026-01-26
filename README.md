# Dashboard de Vendas (Kaggle → PostgreSQL → Power BI)

Dashboard de análise de vendas usando um dataset real do Kaggle (Online Retail).  
Os dados são carregados em um banco **PostgreSQL** (via Docker) e consumidos no Power BI para geração de KPIs e visualizações.

## 🎯 Objetivo
Construir um mini pipeline de dados e um dashboard profissional para análise de vendas, demonstrando domínio prático de:
- **PostgreSQL** (tabelas, views, carga de dados)
- **Power BI** (modelagem simples, medidas DAX, filtros e visuais)
- Organização de projeto para portfólio (GitHub)

## 🧱 Arquitetura
**Kaggle (CSV) → PostgreSQL (Docker) → Power BI**

## 📊 O que o dashboard entrega
KPIs:
- Faturamento Total
- Pedidos
- Clientes Únicos
- Ticket Médio

Visuais:
- Faturamento por mês
- Faturamento por país (Top 10)
- Top 10 produtos por faturamento

Filtros:
- Período (data)
- País

## 🖼️ Prints
> (adicione aqui depois de salvar os prints em /docs)

![Visão Geral](docs/print_dashboard_01.png)
![Filtro por país](docs/print_dashboard_02_filtro.png)

## 🧰 Stack
- PostgreSQL 16 (Docker)
- Power BI Desktop
- SQL (DDL + views)
- Dataset Kaggle (Online Retail)

## ▶️ Como reproduzir

### 1) Subir o PostgreSQL com Docker
Na raiz do projeto:

```bash
docker compose up -d
```

### 2) Criar tabelas e carregar dados
```bash
docker compose exec -T postgres psql -U postgres -d ecommerce -f /scripts/criar_tabelas.sql
docker compose exec -T postgres psql -U postgres -d ecommerce -f /scripts/carregar_dados.sql
```

### 3) Abrir o Power BI

Abra o arquivo:

- powerbi/dashboard_vendas.pbix

Se precisar reconectar:

- Servidor: localhost:5433

- Banco: ecommerce

- Tabela/View: ecommerce.fato_vendas

## 📂 Estrutura do repositório

dashboard-vendas-powerbi-postgres/
├─ db/
│  ├─ criar_tabelas.sql
│  └─ carregar_dados.sql
├─ docs/
│  ├─ dashboard_01_visao_geral.png
│  └─ dashboard_02_filtro_pais.png
├─ powerbi/
│  └─ dashboard_vendas.pbix
├─ docker-compose.yml
├─ .gitignore
└─ README.md

## 📝 Observações

- O dataset original utiliza moeda £ (GBP) e foi mantido no padrão do arquivo para consistência.

- Views foram utilizadas para simplificar a camada de consumo do Power BI.