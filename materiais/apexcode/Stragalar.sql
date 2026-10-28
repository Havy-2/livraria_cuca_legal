
-- ============================================
-- 1. CRIAR O BANCO DE DADOS
-- ============================================

CREATE DATABASE IF NOT EXISTS Stragalar;

USE Stragalar;


-- ============================================
-- 2. CADASTRO DE USUARIOS
-- ============================================

CREATE TABLE usuario (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cargo VARCHAR(80) NOT NULL,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    login VARCHAR(50) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL
);


-- ============================================
-- 3. CADASTRO DE PRODUTOS
-- ============================================

CREATE TABLE produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    descricao VARCHAR(255),
    preco DECIMAL(10,2) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    quantidade_estoque INT NOT NULL DEFAULT 0,

    CONSTRAINT chk_produto_preco
        CHECK (preco >= 0),

    CONSTRAINT chk_produto_estoque
        CHECK (quantidade_estoque >= 0)
);


-- ============================================
-- 4. CADASTRO DE VENDAS
-- ============================================

CREATE TABLE venda (
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


-- ============================================
-- 5. ITENS DE CADA VENDA
-- ============================================

CREATE TABLE itens_venda (
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


-- ============================================
-- 6. CADASTRAR USUARIOS DE EXEMPLO
-- ============================================

-- Senhas abaixo sao apenas exemplos didaticos.
-- Em um sistema real, armazene hashes seguros.

INSERT INTO usuario (nome, cargo, login, senha)
VALUES
('Administrador do Sistema', 'admin',
 'admin01', 'HASH_DE_EXEMPLO_1'),

('Funcionario do Estoque', 'estoquista',
 'estoque01', 'HASH_DE_EXEMPLO_2'),

('Operador de Caixa', 'operador caixa',
 'caixa01', 'HASH_DE_EXEMPLO_3');


-- ============================================
-- 7. CADASTRAR PRODUTOS DE EXEMPLO
-- ============================================

INSERT INTO produto
(nome, descricao, preco, categoria, quantidade_estoque)
VALUES
('Teclado', 'Teclado USB', 75.00, 'Perifericos', 20),

('Mouse', 'Mouse USB', 45.00, 'Perifericos', 30),

('Monitor', 'Monitor de 24 polegadas', 650.00, 'Monitores', 10),

('Cabo HDMI', 'Cabo HDMI de 2 metros', 25.00, 'Acessorios', 50);


-- ============================================
-- 8. CADASTRAR UMA VENDA DE EXEMPLO
-- ============================================

INSERT INTO venda
(total, status, id_funcionario)
VALUES
(120.00, 'Concluida', 3);


-- ============================================
-- 9. CADASTRAR OS ITENS DA VENDA
-- ============================================

INSERT INTO itens_venda
(quantidade, preco_unitario, id_venda, id_produto)
VALUES
(1, 75.00, 1, 1),
(1, 45.00, 1, 2);


-- ============================================
-- 10. CONSULTAR OS CADASTROS
-- ============================================

SELECT * FROM usuario;

SELECT * FROM produto;

SELECT * FROM venda;

SELECT * FROM itens_venda;


-- ============================================
-- 11. CONSULTAR UMA VENDA COMPLETA
-- ============================================

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
