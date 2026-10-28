-- ============================================================
-- Script SQL - Sistema de Gestão do Restaurante/Bar STRAGALAR (v2)
-- Baseado no DER (modelo conceitual), no script anterior e no cardápio.
-- SGBD: MySQL 8.0.16 ou superior (versões antigas ignoram o CHECK)
-- DDL + DML
-- ============================================================

-- ATENÇÃO: se você já rodou o script antigo, as tabelas antigas (Pedido, Mesa,
-- Cliente...) ainda existem e o Produto antigo tem estrutura diferente.
-- Descomente a linha abaixo para APAGAR o banco antigo e recriar do zero.
-- DROP DATABASE IF EXISTS stragalar;

CREATE DATABASE IF NOT EXISTS stragalar
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE stragalar;

-- ============================================================
-- DDL - Criação das tabelas
-- ============================================================

-- Entidade genérica do DER: todo funcionário que acessa o sistema
CREATE TABLE Usuario (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    cargo VARCHAR(80) NOT NULL,
    data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    login VARCHAR(50) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL   -- guardar o HASH da senha, nunca o texto puro
);

-- Especializações de Usuario (total e compartilhada: todo usuário tem pelo
-- menos um papel e pode ter mais de um). A PK é também FK para Usuario.
CREATE TABLE Administrador (
    id_funcionario INT PRIMARY KEY,
    FOREIGN KEY (id_funcionario) REFERENCES Usuario(id_funcionario) ON DELETE CASCADE
);

CREATE TABLE Estoquista (
    id_funcionario INT PRIMARY KEY,
    FOREIGN KEY (id_funcionario) REFERENCES Usuario(id_funcionario) ON DELETE CASCADE
);

CREATE TABLE OperadorCaixa (
    id_funcionario INT PRIMARY KEY,
    FOREIGN KEY (id_funcionario) REFERENCES Usuario(id_funcionario) ON DELETE CASCADE
);

-- Produtos (cardápio)
CREATE TABLE Produto (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    descricao VARCHAR(255),
    categoria VARCHAR(50) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    CHECK (preco >= 0)
);

-- Estoque: relação 1:1 com Produto (id_produto é UNIQUE)
CREATE TABLE Estoque (
    id_estoque INT PRIMARY KEY AUTO_INCREMENT,
    id_produto INT NOT NULL UNIQUE,
    quantidade INT NOT NULL DEFAULT 0,
    CHECK (quantidade >= 0),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto) ON DELETE CASCADE
);

-- Relacionamento "opera" (N:N) entre Estoquista e Estoque
CREATE TABLE OperaEstoque (
    id_funcionario INT NOT NULL,
    id_estoque INT NOT NULL,
    PRIMARY KEY (id_funcionario, id_estoque),
    FOREIGN KEY (id_funcionario) REFERENCES Estoquista(id_funcionario) ON DELETE CASCADE,
    FOREIGN KEY (id_estoque) REFERENCES Estoque(id_estoque) ON DELETE CASCADE
);

-- Vendas: cada venda é realizada por exatamente um operador de caixa
CREATE TABLE Venda (
    id_venda INT PRIMARY KEY AUTO_INCREMENT,
    id_funcionario INT NOT NULL,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    status VARCHAR(20) NOT NULL DEFAULT 'Aberta',  -- Aberta, Finalizada, Cancelada
    CHECK (status IN ('Aberta', 'Finalizada', 'Cancelada')),
    FOREIGN KEY (id_funcionario) REFERENCES OperadorCaixa(id_funcionario)
);

-- Itens da venda: preco_unitario guarda o preço NO MOMENTO da venda
CREATE TABLE ItensVenda (
    id_itens_venda INT PRIMARY KEY AUTO_INCREMENT,
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    CHECK (quantidade > 0),
    FOREIGN KEY (id_venda) REFERENCES Venda(id_venda) ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- ============================================================
-- DML - Dados de teste
-- ============================================================

-- Usuários (senhas de teste, já gravadas como hash SHA-256)
INSERT INTO Usuario (nome, cargo, login, senha) VALUES
('Ana Souza',     'Gerente',    'ana',    SHA2('ana123', 256)),
('Carlos Mendes', 'Caixa',      'carlos', SHA2('carlos123', 256)),
('Pedro Lima',    'Estoquista', 'pedro',  SHA2('pedro123', 256));

-- Papéis: a Ana é administradora e também opera o caixa (papel compartilhado)
INSERT INTO Administrador (id_funcionario) VALUES (1);
INSERT INTO OperadorCaixa (id_funcionario) VALUES (1), (2);
INSERT INTO Estoquista (id_funcionario) VALUES (3);

-- Produtos do cardápio do Stragalar
-- ATENÇÃO: os itens com preço 0.00 estão SEM PREÇO no cardápio original.
-- Preencha com UPDATE Produto SET preco = ... WHERE id_produto = ...;
INSERT INTO Produto (nome, descricao, categoria, preco) VALUES
('Rabada com batata',       NULL,                                 'Entradas e Pratos', 139.00),
('Salaminho e palmito',     NULL,                                 'Entradas e Pratos',  67.00),
('Salaminho',               NULL,                                 'Entradas e Pratos',  45.00),
('Azeitona',                NULL,                                 'Entradas e Pratos',  30.00),
('Pastéis 10 unidades',     'Sabores: carne, queijo e camarão',   'Entradas e Pratos',  48.00),
('Pastel unidade',          'Sabores: carne, queijo e camarão',   'Entradas e Pratos',   6.00),
('Filé de peixe',           NULL,                                 'Entradas e Pratos',  89.00),
('Dadinhos de tapioca',     'Acompanha geleia de pimenta',        'Entradas e Pratos',  39.00),
('Tulipinhas de frango',    'Acompanha molho tártaro',            'Entradas e Pratos',  49.00),
('Frango à passarinho',     NULL,                                 'Petiscos',           79.00),
('Filé de frango à palito', NULL,                                 'Petiscos',           70.00),
('Kieber de frango',        NULL,                                 'Petiscos',           79.00),
('Camarão à doré',          NULL,                                 'Petiscos',           79.00),
('Cação à doré',            NULL,                                 'Petiscos',           79.00),
('Filé bovino à palito',    NULL,                                 'Petiscos',            0.00),
('Filé bovino com fritas',  NULL,                                 'Petiscos',            0.00),
('Calabresa',               NULL,                                 'Petiscos',            0.00),
('Batata frita',            NULL,                                 'Petiscos',            0.00),
('Aipim frito',             NULL,                                 'Petiscos',            0.00),
('Carne de sol com aipim',  NULL,                                 'Petiscos',            0.00),
('Costelinha suína',        NULL,                                 'Petiscos',            0.00);

-- Estoque inicial de teste: 20 unidades de cada produto
INSERT INTO Estoque (id_produto, quantidade)
SELECT id_produto, 20 FROM Produto;

-- O estoquista Pedro (id 3) opera alguns estoques
INSERT INTO OperaEstoque (id_funcionario, id_estoque) VALUES
(3, 1), (3, 6), (3, 8);

-- Vendas de teste
INSERT INTO Venda (id_funcionario, data_hora, total, status) VALUES
(2, '2026-10-20 19:30:00', 130.00, 'Finalizada'),
(1, '2026-10-20 20:15:00',  97.00, 'Aberta');

INSERT INTO ItensVenda (id_venda, id_produto, quantidade, preco_unitario) VALUES
(1,  8, 1, 39.00),   -- Dadinhos de tapioca
(1, 10, 1, 79.00),   -- Frango à passarinho
(1,  6, 2,  6.00),   -- Pastel unidade
(2,  5, 1, 48.00),   -- Pastéis 10 unidades
(2,  9, 1, 49.00);   -- Tulipinhas de frango

-- ============================================================
-- Consulta de conferência: o total da venda deve bater com a soma dos itens
-- ============================================================
SELECT v.id_venda,
       u.nome AS operador,
       v.total AS total_gravado,
       SUM(i.quantidade * i.preco_unitario) AS total_calculado
FROM Venda v
JOIN Usuario u ON u.id_funcionario = v.id_funcionario
JOIN ItensVenda i ON i.id_venda = v.id_venda
GROUP BY v.id_venda, u.nome, v.total;