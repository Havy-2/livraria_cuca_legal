
CREATE DATABASE IF NOT EXISTS Stragalar
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE Stragalar;

-- =====================================================
-- 1. FUNCIONARIOS / USUARIOS DO SISTEMA
-- =====================================================

CREATE TABLE IF NOT EXISTS usuario (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cargo VARCHAR(80) NOT NULL,
    data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    login VARCHAR(50) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL
);

-- =====================================================
-- 2. PRODUTOS DO CARDAPIO
-- O preco aceita NULL porque alguns itens do documento
-- nao tinham valor informado.
-- =====================================================

CREATE TABLE IF NOT EXISTS produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    descricao VARCHAR(255),
    preco DECIMAL(10,2) NULL,
    categoria VARCHAR(100) NOT NULL,
    quantidade_estoque INT NOT NULL DEFAULT 0,
    disponivel BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT chk_produto_preco
        CHECK (preco IS NULL OR preco >= 0),

    CONSTRAINT chk_produto_estoque
        CHECK (quantidade_estoque >= 0)
);

-- =====================================================
-- 3. VENDAS
-- =====================================================

CREATE TABLE IF NOT EXISTS venda (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    status VARCHAR(30) NOT NULL DEFAULT 'Aberta',
    id_funcionario INT NOT NULL,

    CONSTRAINT chk_venda_total
        CHECK (total >= 0),

    CONSTRAINT fk_venda_usuario
        FOREIGN KEY (id_funcionario)
        REFERENCES usuario(id_funcionario)
);

-- =====================================================
-- 4. ITENS DE CADA VENDA
-- O preco_unitario registra o preco praticado no momento
-- da venda, mesmo que o preco do cardapio mude depois.
-- =====================================================

CREATE TABLE IF NOT EXISTS itens_venda (
    id_itens_venda INT AUTO_INCREMENT PRIMARY KEY,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,

    CONSTRAINT chk_item_quantidade
        CHECK (quantidade > 0),

    CONSTRAINT chk_item_preco
        CHECK (preco_unitario >= 0),

    CONSTRAINT fk_item_venda
        FOREIGN KEY (id_venda)
        REFERENCES venda(id_venda)
        ON DELETE CASCADE,

    CONSTRAINT fk_item_produto
        FOREIGN KEY (id_produto)
        REFERENCES produto(id_produto)
);

-- =====================================================
-- 5. USUARIOS DE EXEMPLO
-- Senhas ilustrativas: em sistema real, guardar hashes
-- seguros gerados pela aplicacao, nunca texto puro.
-- =====================================================

INSERT INTO usuario (nome, cargo, login, senha)
VALUES
('Administrador do Sistema', 'admin', 'admin01', 'HASH_DE_EXEMPLO_1'),
('Funcionario do Estoque', 'estoquista', 'estoque01', 'HASH_DE_EXEMPLO_2'),
('Operador de Caixa', 'operador caixa', 'caixa01', 'HASH_DE_EXEMPLO_3');

-- =====================================================
-- 6. ITENS DO CARDAPIO STRAGALAR
-- Categorias "Cardapio" e "Petiscos" seguem a organizacao
-- visivel no documento. Precos nao informados ficam NULL.
-- =====================================================

INSERT INTO produto
(nome, descricao, preco, categoria, quantidade_estoque, disponivel)
VALUES
('Rabada com batata', NULL, 139.00, 'Cardapio', 0, TRUE),
('Salaminho e palmito', NULL, 67.00, 'Cardapio', 0, TRUE),
('Salaminho', NULL, 45.00, 'Cardapio', 0, TRUE),
('Azeitona', NULL, 30.00, 'Cardapio', 0, TRUE),
('Pasteis - 10 unidades', 'Sabores: carne, queijo e camarao', 48.00, 'Cardapio', 0, TRUE),
('Pastel - unidade', 'Sabores: carne, queijo e camarao', 6.00, 'Cardapio', 0, TRUE),
('File de peixe', NULL, 89.00, 'Cardapio', 0, TRUE),
('Dadinhos de tapioca', 'Acompanha geleia de pimenta', 39.00, 'Cardapio', 0, TRUE),
('Tulipinhas de frango', 'Acompanha molho tartato', 49.00, 'Cardapio', 0, TRUE),

('Frango a passarinho', NULL, 79.00, 'Petiscos', 0, TRUE),
('File de frango a palito', NULL, 70.00, 'Petiscos', 0, TRUE),
('Kieber de frango', NULL, 79.00, 'Petiscos', 0, TRUE),
('Camarao a dore', NULL, 79.00, 'Petiscos', 0, TRUE),
('Cacao a dore', NULL, 79.00, 'Petiscos', 0, TRUE),
('File bovino a palito', NULL, NULL, 'Petiscos', 0, TRUE),
('File bovino com fritas', NULL, NULL, 'Petiscos', 0, TRUE),
('Calabresa', NULL, NULL, 'Petiscos', 0, TRUE),
('Batata frita', NULL, NULL, 'Petiscos', 0, TRUE),
('Aipim frito', NULL, NULL, 'Petiscos', 0, TRUE),
('Carne de sol com aipim', NULL, NULL, 'Petiscos', 0, TRUE),
('Costelinha suina', NULL, NULL, 'Petiscos', 0, TRUE);

-- =====================================================
-- 7. CONSULTAS PARA CONFERIR OS CADASTROS
-- =====================================================

SELECT * FROM usuario;

SELECT
    id_produto,
    nome,
    descricao,
    preco,
    categoria,
    disponivel
FROM produto
ORDER BY categoria, nome;

SELECT * FROM venda;

SELECT * FROM itens_venda;

-- =====================================================
-- 8. CONSULTA DE UMA VENDA COMPLETA
-- =====================================================

SELECT
    v.id_venda,
    v.data_hora,
    u.nome AS funcionario,
    v.status,
    p.nome AS produto,
    iv.quantidade,
    iv.preco_unitario,
    (iv.quantidade * iv.preco_unitario) AS subtotal,
    v.total
FROM venda v
INNER JOIN usuario u
    ON v.id_funcionario = u.id_funcionario
INNER JOIN itens_venda iv
    ON v.id_venda = iv.id_venda
INNER JOIN produto p
    ON iv.id_produto = p.id_produto;
