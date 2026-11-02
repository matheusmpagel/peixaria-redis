-- Modelagem relacional equivalente (SQL Server / T-SQL) para o estudo de caso da Peixaria

CREATE TABLE usuarios (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE produtos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL CHECK (preco >= 0),
    categoria VARCHAR(50) NOT NULL
);

CREATE TABLE sessoes (
    token VARCHAR(64) PRIMARY KEY,
    usuario_id INT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    criada_em DATETIME2 NOT NULL DEFAULT GETDATE(),
    expira_em DATETIME2 NOT NULL
);

CREATE INDEX idx_sessoes_expira_em ON sessoes(expira_em);

CREATE TABLE itens_carrinho (
    usuario_id INT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    produto_id INT NOT NULL REFERENCES produtos(id) ON DELETE CASCADE,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    atualizado_em DATETIME2 NOT NULL DEFAULT GETDATE(),
    expira_em DATETIME2 NOT NULL,
    PRIMARY KEY (usuario_id, produto_id)
);

CREATE TABLE pedidos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    usuario_id INT NOT NULL REFERENCES usuarios(id),
    criado_em DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE itens_pedido (
    pedido_id INT NOT NULL REFERENCES pedidos(id) ON DELETE CASCADE,
    produto_id INT NOT NULL REFERENCES produtos(id),
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (pedido_id, produto_id)
);

CREATE INDEX idx_itens_pedido_produto ON itens_pedido(produto_id);
GO

-- ============================================================================
-- CONSULTAS REESCRITAS EM SQL SERVER (T-SQL)
-- ============================================================================

-- 1. Equivalente da Consulta 2: O que tem no carrinho do usuário 11 e quanto custa?
SELECT
    p.id AS produto_id,
    p.nome,
    p.preco,
    ic.quantidade,
    (p.preco * ic.quantidade) AS subtotal
FROM itens_carrinho ic
INNER JOIN produtos p ON p.id = ic.produto_id
WHERE ic.usuario_id = 11
  AND ic.expira_em > GETDATE();
GO

-- 2. Equivalente da Consulta 3: Quais são os 5 produtos mais vendidos da peixaria?
SELECT TOP 5
    p.id AS produto_id,
    p.nome,
    SUM(ip.quantidade) AS unidades_vendidas
FROM itens_pedido ip
INNER JOIN produtos p ON p.id = ip.produto_id
GROUP BY p.id, p.nome
ORDER BY unidades_vendidas DESC;
GO

-- 3. (Extra) Equivalente da Consulta 1: Este token é de uma sessão válida e de quem?
SELECT
    s.token,
    s.criada_em,
    u.id AS usuario_id,
    u.nome,
    u.email
FROM sessoes s
INNER JOIN usuarios u ON u.id = s.usuario_id
WHERE s.token = '9f3a7c21'
  AND s.expira_em > GETDATE();
GO
