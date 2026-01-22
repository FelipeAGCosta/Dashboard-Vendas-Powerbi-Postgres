-- =========================================================
-- Projeto: Dashboard Kaggle -> PostgreSQL -> Power BI
-- Etapa 2: Estrutura (staging + tabela final + view)
-- =========================================================

CREATE SCHEMA IF NOT EXISTS ecommerce;

-- Função: tenta interpretar data/hora em dois formatos comuns.
-- 1) MM/DD/YYYY HH:MI  (muito comum nesse dataset)
-- 2) DD/MM/YYYY HH:MI
CREATE OR REPLACE FUNCTION ecommerce.fn_parse_data_hora(data_texto TEXT)
RETURNS TIMESTAMP
LANGUAGE plpgsql
AS $$
DECLARE
    ts TIMESTAMP;
BEGIN
    -- Tenta: mês/dia/ano
    BEGIN
        ts := (to_timestamp(data_texto, 'MM/DD/YYYY HH24:MI') AT TIME ZONE 'UTC');
        RETURN ts;
    EXCEPTION WHEN others THEN
        NULL;
    END;

    -- Tenta: dia/mês/ano
    BEGIN
        ts := (to_timestamp(data_texto, 'DD/MM/YYYY HH24:MI') AT TIME ZONE 'UTC');
        RETURN ts;
    EXCEPTION WHEN others THEN
        RETURN NULL;
    END;
END;
$$;

-- Tabela staging (texto) para COPY não “quebrar” por nulls/formatos.
CREATE TABLE IF NOT EXISTS ecommerce.vendas_brutas (
    invoice_no    TEXT,
    stock_code    TEXT,
    description   TEXT,
    quantity      TEXT,
    invoice_date  TEXT,
    unit_price    TEXT,
    customer_id   TEXT,
    country       TEXT
);

-- Tabela final tipada (com nomes PT-BR)
CREATE TABLE IF NOT EXISTS ecommerce.vendas (
    id_venda         BIGSERIAL PRIMARY KEY,
    id_pedido        VARCHAR(20)  NOT NULL,
    codigo_produto   VARCHAR(20)  NOT NULL,
    descricao_produto TEXT,
    quantidade       INTEGER      NOT NULL,
    data_pedido      TIMESTAMP    NOT NULL,
    preco_unitario   NUMERIC(10,2) NOT NULL,
    id_cliente       BIGINT,
    pais             VARCHAR(100) NOT NULL,
    faturamento      NUMERIC(12,2) GENERATED ALWAYS AS (quantidade * preco_unitario) STORED
);

-- Índices úteis pro Power BI
CREATE INDEX IF NOT EXISTS idx_vendas_data_pedido    ON ecommerce.vendas (data_pedido);
CREATE INDEX IF NOT EXISTS idx_vendas_pais          ON ecommerce.vendas (pais);
CREATE INDEX IF NOT EXISTS idx_vendas_id_pedido     ON ecommerce.vendas (id_pedido);
CREATE INDEX IF NOT EXISTS idx_vendas_codigo_produto ON ecommerce.vendas (codigo_produto);
CREATE INDEX IF NOT EXISTS idx_vendas_id_cliente    ON ecommerce.vendas (id_cliente);

-- View “pronta pro dashboard” (remove cancelamentos e devoluções)
-- Cancelamento no dataset: InvoiceNo começando com 'C'. :contentReference[oaicite:1]{index=1}
CREATE OR REPLACE VIEW ecommerce.vendas_validas AS
SELECT
    *
FROM ecommerce.vendas
WHERE
    UPPER(id_pedido) NOT LIKE 'C%'
    AND quantidade > 0
    AND preco_unitario > 0;
