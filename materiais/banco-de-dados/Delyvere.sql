-- apaga as tabelas se já existirem (ordem inversa por causa das FKs)
DROP TABLE IF EXISTS Entrega;
DROP TABLE IF EXISTS Item_Pedido;
DROP TABLE IF EXISTS Pedido;
DROP TABLE IF EXISTS Lanche;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Entregador;
DROP TABLE IF EXISTS Veiculo;
DROP TABLE IF EXISTS Forma_de_pagamento;

-- cliente
CREATE TABLE Cliente (
  idCliente INT PRIMARY KEY AUTO_INCREMENT,
  Nome VARCHAR(45),
  Telefone VARCHAR(11),
  Email VARCHAR(45),
  Endereco VARCHAR(45),
  CPF VARCHAR(45)
);

-- lanche do cardápio
CREATE TABLE Lanche (
  idLanche INT PRIMARY KEY AUTO_INCREMENT,
  Nome VARCHAR(45),
  Descricao VARCHAR(45),
  Preco DECIMAL(10,2),
  TempoPreparo INT
);

-- quem entrega
CREATE TABLE Entregador (
  idEntregador INT PRIMARY KEY AUTO_INCREMENT,
  Nome VARCHAR(45),
  Telefone VARCHAR(45),
  CPF VARCHAR(45),
  Status VARCHAR(45)
);

-- moto / carro
CREATE TABLE Veiculo (
  idVeiculo INT PRIMARY KEY AUTO_INCREMENT,
  Placa VARCHAR(45),
  Tipo VARCHAR(45),
  Status VARCHAR(45)
);

-- dinheiro, cartão, pix...
CREATE TABLE Forma_de_pagamento (
  CodFormaPag INT PRIMARY KEY AUTO_INCREMENT,
  Descricao VARCHAR(45)
);

-- pedido do cliente
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

-- itens de cada pedido (quantos lanches)
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

-- entrega do pedido
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