-- Script SQL - Sistema de Gestão para Restaurante/Bar (STRAGALAR)
-- DDL + DML

CREATE DATABASE IF NOT EXISTS stragalar;
USE stragalar;

-- Categorias de produtos (bebidas, comidas, etc.)
CREATE TABLE Categoria (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255)
);

-- Funcionários
CREATE TABLE Funcionario (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    cargo VARCHAR(80) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    data_admissao DATE
);

-- Clientes
CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100)
);

-- Mesas
CREATE TABLE Mesa (
    id_mesa INT PRIMARY KEY AUTO_INCREMENT,
    numero INT NOT NULL UNIQUE,
    capacidade INT NOT NULL,
    status VARCHAR(30) DEFAULT 'Livre'  -- Livre, Ocupada, Reservada
);

-- Produtos (cardápio / estoque)
CREATE TABLE Produto (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    descricao VARCHAR(255),
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0,
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

-- Pedidos / Comandas
CREATE TABLE Pedido (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_mesa INT NOT NULL,
    id_cliente INT,
    id_funcionario INT,
    data_hora DATETIME NOT NULL,
    status VARCHAR(30) DEFAULT 'Aberto',  -- Aberto, Fechado, Cancelado
    valor_total DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (id_mesa) REFERENCES Mesa(id_mesa),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario)
);

-- Itens do Pedido
CREATE TABLE ItemPedido (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- Pagamentos (controle de caixa)
CREATE TABLE Pagamento (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    forma_pagamento VARCHAR(50) NOT NULL,  -- Dinheiro, Credito, Debito, Pix
    valor DECIMAL(10,2) NOT NULL,
    data_pagamento DATETIME NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

-- ============================================
-- DML - Dados de teste
-- ============================================

INSERT INTO Categoria (nome, descricao) VALUES
('Bebidas', 'Refrigerantes, sucos e cervejas'),
('Comidas', 'Pratos principais e petiscos'),
('Sobremesas', 'Doces e sobremesas'),
('Porções', 'Porções para compartilhar');

INSERT INTO Funcionario (nome, cargo, telefone, email, data_admissao) VALUES
('Carlos Mendes', 'Garçom', '(27) 99999-1111', 'carlos@stragalar.com', '2023-03-10'),
('Ana Souza', 'Gerente', '(27) 98888-2222', 'ana@stragalar.com', '2022-01-15'),
('Pedro Lima', 'Cozinheiro', '(27) 97777-3333', 'pedro@stragalar.com', '2023-06-20');

INSERT INTO Cliente (nome, telefone, email) VALUES
('João Silva', '(27) 99111-2222', 'joao@email.com'),
('Maria Oliveira', '(27) 99222-3333', 'maria@email.com'),
('Lucas Costa', '(27) 99333-4444', NULL);

INSERT INTO Mesa (numero, capacidade, status) VALUES
(1, 4, 'Ocupada'),
(2, 2, 'Livre'),
(3, 6, 'Reservada'),
(4, 4, 'Ocupada'),
(5, 8, 'Livre');

INSERT INTO Produto (nome, descricao, preco, estoque, id_categoria) VALUES
('Cerveja Long Neck', 'Cerveja 355ml', 8.00, 120, 1),
('Refrigerante Lata', '350ml', 5.00, 80, 1),
('Porção de Batata', 'Porção grande com molho', 28.00, 40, 4),
('Hambúrguer Artesanal', 'Com batata frita', 32.00, 30, 2),
('Suco Natural', 'Laranja ou limão 400ml', 12.00, 25, 1),
('Pudim', 'Pudim de leite', 10.00, 15, 3);

INSERT INTO Pedido (id_mesa, id_cliente, id_funcionario, data_hora, status, valor_total) VALUES
(1, 1, 1, '2026-10-20 19:30:00', 'Fechado', 48.00),
(4, 2, 1, '2026-10-20 20:15:00', 'Aberto', 60.00);

INSERT INTO ItemPedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 2, 8.00),
(1, 3, 1, 28.00),
(1, 5, 1, 12.00),
(2, 4, 1, 32.00),
(2, 1, 2, 8.00),
(2, 2, 2, 5.00);

INSERT INTO Pagamento (id_pedido, forma_pagamento, valor, data_pagamento) VALUES
(1, 'Pix', 48.00, '2026-10-20 20:10:00');
