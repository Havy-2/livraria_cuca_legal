
DROP TABLE IF EXISTS Entrega;
DROP TABLE IF EXISTS Item_Pedido;
DROP TABLE IF EXISTS Pedido;
DROP TABLE IF EXISTS Lanche;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Entregador;
DROP TABLE IF EXISTS Veiculo;
DROP TABLE IF EXISTS Forma_de_pagamento;

CREATE TABLE Cliente (
  idCliente INT PRIMARY KEY AUTO_INCREMENT,
  Nome VARCHAR(45) NOT NULL,
  Telefone VARCHAR(11),
  Email VARCHAR(45),
  Endereco VARCHAR(45),
  CPF VARCHAR(45)
);

CREATE TABLE Lanche (
  idLanche INT PRIMARY KEY AUTO_INCREMENT,
  Nome VARCHAR(45) NOT NULL,
  Descricao VARCHAR(45),
  Preco DECIMAL(10,2) NOT NULL,
  TempoPreparo INT
);

CREATE TABLE Entregador (
  idEntregador INT PRIMARY KEY AUTO_INCREMENT,
  Nome VARCHAR(45) NOT NULL,
  Telefone VARCHAR(45),
  CPF VARCHAR(45),
  Status VARCHAR(45)
);

CREATE TABLE Veiculo (
  idVeiculo INT PRIMARY KEY AUTO_INCREMENT,
  Placa VARCHAR(45) NOT NULL,
  Tipo VARCHAR(45),
  Status VARCHAR(45)
);

CREATE TABLE Forma_de_pagamento (
  CodFormaPag INT PRIMARY KEY AUTO_INCREMENT,
  Descricao VARCHAR(45) NOT NULL
);

CREATE TABLE Pedido (
  idPedido INT PRIMARY KEY AUTO_INCREMENT,
  DataHora DATETIME,
  ValorTotal DECIMAL(10,2),
  Status VARCHAR(45),
  Observacao VARCHAR(45),
  Cliente_idCliente INT,
  FormaPag_CodFormaPag INT,
  FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente),
  FOREIGN KEY (FormaPag_CodFormaPag) REFERENCES Forma_de_pagamento(CodFormaPag)
);

CREATE TABLE Item_Pedido (
  NumPedido INT PRIMARY KEY AUTO_INCREMENT,
  Quantidade INT,
  PrecoUnitario DECIMAL(10,2),
  ObservacoesItem VARCHAR(45),
  Pedido_idPedido INT,
  Lanche_idLanche INT,
  FOREIGN KEY (Pedido_idPedido) REFERENCES Pedido(idPedido),
  FOREIGN KEY (Lanche_idLanche) REFERENCES Lanche(idLanche)
);

CREATE TABLE Entrega (
  idEntrega INT PRIMARY KEY AUTO_INCREMENT,
  DataHoraSaida DATETIME,
  DataHoraEntrega DATETIME,
  Status VARCHAR(45),
  Pedido_idPedido INT,
  Entregador_idEntregador INT,
  Veiculo_idVeiculo INT,
  FOREIGN KEY (Pedido_idPedido) REFERENCES Pedido(idPedido),
  FOREIGN KEY (Entregador_idEntregador) REFERENCES Entregador(idEntregador),
  FOREIGN KEY (Veiculo_idVeiculo) REFERENCES Veiculo(idVeiculo)
);

INSERT INTO Cliente (Nome, Telefone, Email, Endereco, CPF) VALUES
('Ana Souza',        '11987654321', 'ana.souza@email.com',    'Rua das Flores, 120', '111.222.333-44'),
('Bruno Lima',       '11976543210', 'bruno.lima@email.com',   'Av. Brasil, 890',     '222.333.444-55'),
('Carla Mendes',     '11965432109', 'carla.m@email.com',      'Rua do Sol, 45',      '333.444.555-66'),
('Diego Ferreira',   '11954321098', 'diego.f@email.com',      'Rua Nova, 300',       '444.555.666-77'),
('Elena Costa',      '11943210987', 'elena.costa@email.com',  'Av. Central, 15',     '555.666.777-88');

INSERT INTO Lanche (Nome, Descricao, Preco, TempoPreparo) VALUES
('X-Burguer',     'Pao, carne e queijo',           18.90, 12),
('X-Bacon',       'Pao, carne, queijo e bacon',    22.50, 15),
('X-Salada',      'Pao, carne, alface e tomate',   20.00, 12),
('X-Tudo',        'Completo com tudo',             26.90, 18),
('Batata Frita',  'Porcao media',                  12.00, 8),
('Refrigerante',  'Lata 350ml',                     6.00, 1),
('Milk Shake',    'Chocolate 400ml',               14.50, 6);

INSERT INTO Entregador (Nome, Telefone, CPF, Status) VALUES
('Joao Pedrosa',  '11911112222', '666.777.888-99', 'Disponivel'),
('Marina Alves',  '11922223333', '777.888.999-00', 'Em rota'),
('Paulo Santos',  '11933334444', '888.999.000-11', 'Disponivel');

INSERT INTO Veiculo (Placa, Tipo, Status) VALUES
('ABC1D23', 'Moto',  'Disponivel'),
('EFG4H56', 'Moto',  'Em uso'),
('IJK7L89', 'Carro', 'Disponivel');

INSERT INTO Forma_de_pagamento (Descricao) VALUES
('Dinheiro'),
('Cartao de Credito'),
('Cartao de Debito'),
('Pix');

INSERT INTO Pedido (DataHora, ValorTotal, Status, Observacao, Cliente_idCliente, FormaPag_CodFormaPag) VALUES
('2026-09-25 12:10:00', 28.50, 'Entregue',     'Sem cebola',           1, 4),
('2026-09-25 12:35:00', 44.90, 'Em entrega',   'Troco nao precisa',    2, 2),
('2026-09-25 13:05:00', 33.40, 'Preparando',   'Shake bem gelado',     3, 1),
('2026-09-25 13:20:00', 52.00, 'Recebido',     'Um sem tomate',        4, 4),
('2026-09-25 13:40:00', 47.40, 'Entregue',     NULL,                   5, 3);

INSERT INTO Item_Pedido (Quantidade, PrecoUnitario, ObservacoesItem, Pedido_idPedido, Lanche_idLanche) VALUES
(1, 22.50, 'Sem cebola',     1, 2), -- pedido 1: X-Bacon
(1,  6.00, NULL,             1, 6), -- pedido 1: Refrigerante
(1, 26.90, NULL,             2, 4), -- pedido 2: X-Tudo
(1, 12.00, 'Bem sequinha',   2, 5), -- pedido 2: Batata
(1,  6.00, NULL,             2, 6), -- pedido 2: Refrigerante
(1, 18.90, NULL,             3, 1), -- pedido 3: X-Burguer
(1, 14.50, 'Bem gelado',     3, 7), -- pedido 3: Milk Shake
(2, 20.00, '1 sem tomate',   4, 3), -- pedido 4: 2x X-Salada
(1, 12.00, NULL,             4, 5), -- pedido 4: Batata
(1, 22.50, NULL,             5, 2), -- pedido 5: X-Bacon
(1, 18.90, NULL,             5, 1), -- pedido 5: X-Burguer
(1,  6.00, NULL,             5, 6); -- pedido 5: Refrigerante

INSERT INTO Entrega (DataHoraSaida, DataHoraEntrega, Status, Pedido_idPedido, Entregador_idEntregador, Veiculo_idVeiculo) VALUES
('2026-09-25 12:25:00', '2026-09-25 12:48:00', 'Concluida',    1, 1, 1),
('2026-09-25 12:55:00', NULL,                  'Em andamento', 2, 2, 2),
('2026-09-25 13:55:00', '2026-09-25 14:12:00', 'Concluida',    5, 3, 3);

