-- =========================================================
-- Consultas base para o Dashboard (Power BI)
-- Fonte recomendada: ecommerce.vendas_validas
-- =========================================================

-- 0) Visão geral rápida (checagem)
SELECT
  COUNT(*)                          AS linhas,
  COUNT(DISTINCT id_pedido)         AS pedidos_distintos,
  COUNT(DISTINCT id_cliente)        AS clientes_distintos,
  SUM(faturamento)                  AS faturamento_total
FROM ecommerce.vendas_validas;

-- 1) Faturamento por mês (linha/área)
SELECT
  date_trunc('month', data_pedido)::date AS mes,
  SUM(faturamento)                       AS faturamento
FROM ecommerce.vendas_validas
GROUP BY 1
ORDER BY 1;

-- 2) Pedidos por mês
SELECT
  date_trunc('month', data_pedido)::date AS mes,
  COUNT(DISTINCT id_pedido)              AS pedidos
FROM ecommerce.vendas_validas
GROUP BY 1
ORDER BY 1;

-- 3) Clientes únicos por mês (ignora cliente nulo)
SELECT
  date_trunc('month', data_pedido)::date AS mes,
  COUNT(DISTINCT id_cliente)             AS clientes_unicos
FROM ecommerce.vendas_validas
WHERE id_cliente IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- 4) Faturamento por país (barras / mapa)
SELECT
  pais,
  SUM(faturamento) AS faturamento
FROM ecommerce.vendas_validas
GROUP BY 1
ORDER BY faturamento DESC;

-- 5) Top 20 produtos por faturamento
SELECT
  codigo_produto,
  descricao_produto,
  SUM(quantidade)   AS quantidade_total,
  SUM(faturamento)  AS faturamento
FROM ecommerce.vendas_validas
GROUP BY 1,2
ORDER BY faturamento DESC
LIMIT 20;

-- 6) Top 20 produtos por quantidade
SELECT
  codigo_produto,
  descricao_produto,
  SUM(quantidade) AS quantidade_total
FROM ecommerce.vendas_validas
GROUP BY 1,2
ORDER BY quantidade_total DESC
LIMIT 20;

-- 7) Ticket médio por mês (faturamento / pedidos)
SELECT
  date_trunc('month', data_pedido)::date AS mes,
  SUM(faturamento) / NULLIF(COUNT(DISTINCT id_pedido), 0) AS ticket_medio
FROM ecommerce.vendas_validas
GROUP BY 1
ORDER BY 1;

-- 8) Produtos com maior faturamento por país (top 10 por país)
-- Útil se você fizer uma página de “Detalhamento por região”
WITH base AS (
  SELECT
    pais,
    codigo_produto,
    descricao_produto,
    SUM(faturamento) AS faturamento
  FROM ecommerce.vendas_validas
  GROUP BY 1,2,3
),
ranked AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY pais ORDER BY faturamento DESC) AS rn
  FROM base
)
SELECT
  pais, codigo_produto, descricao_produto, faturamento
FROM ranked
WHERE rn <= 10
ORDER BY pais, faturamento DESC;

-- 9) (Opcional) Detectar cancelamentos no dataset (para documentação)
SELECT
  COUNT(*) AS linhas_canceladas
FROM ecommerce.vendas
WHERE UPPER(id_pedido) LIKE 'C%';
