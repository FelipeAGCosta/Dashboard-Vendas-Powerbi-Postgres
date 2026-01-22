-- =========================================================
-- Etapa 2: Carga do CSV -> staging -> tabela final
-- Requisito (Docker): ./data montado em /dados no container
-- Arquivo esperado: /dados/vendas_kaggle.csv
-- =========================================================

TRUNCATE TABLE ecommerce.vendas_brutas;
TRUNCATE TABLE ecommerce.vendas RESTART IDENTITY;

-- 1) Importa CSV para staging (texto)
COPY ecommerce.vendas_brutas (
    invoice_no, stock_code, description, quantity, invoice_date, unit_price, customer_id, country
)
FROM '/dados/vendas_kaggle.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ENCODING 'LATIN1');

-- 2) Converte para tipos corretos e insere na tabela final
INSERT INTO ecommerce.vendas (
    id_pedido,
    codigo_produto,
    descricao_produto,
    quantidade,
    data_pedido,
    preco_unitario,
    id_cliente,
    pais
)
SELECT
    TRIM(invoice_no) AS id_pedido,
    TRIM(stock_code) AS codigo_produto,
    NULLIF(TRIM(description), '') AS descricao_produto,
    (NULLIF(TRIM(quantity), '')::INTEGER) AS quantidade,
    ecommerce.fn_parse_data_hora(TRIM(invoice_date)) AS data_pedido,
    (REPLACE(NULLIF(TRIM(unit_price), ''), ',', '.')::NUMERIC(10,2)) AS preco_unitario,
    CASE
        WHEN NULLIF(TRIM(customer_id), '') IS NULL THEN NULL
        ELSE (NULLIF(TRIM(customer_id), '')::NUMERIC)::BIGINT
    END AS id_cliente,
    COALESCE(NULLIF(TRIM(country), ''), 'Desconhecido') AS pais
FROM ecommerce.vendas_brutas
WHERE
    NULLIF(TRIM(invoice_no), '') IS NOT NULL
    AND NULLIF(TRIM(stock_code), '') IS NOT NULL
    AND ecommerce.fn_parse_data_hora(TRIM(invoice_date)) IS NOT NULL
    AND NULLIF(TRIM(quantity), '') IS NOT NULL
    AND NULLIF(TRIM(unit_price), '') IS NOT NULL;
