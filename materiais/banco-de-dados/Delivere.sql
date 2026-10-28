-- ============================================================
-- Schema: lanchonete / delivery
-- MySQL Workbench
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `Item_Pedido`;
DROP TABLE IF EXISTS `Entrega`;
DROP TABLE IF EXISTS `Pedido`;
DROP TABLE IF EXISTS `Lanche`;
DROP TABLE IF EXISTS `Cliente`;
DROP TABLE IF EXISTS `Entregador`;
DROP TABLE IF EXISTS `Veiculo`;
DROP TABLE IF EXISTS `Forma_de_pagamento`;

SET FOREIGN_KEY_CHECKS = 1;

-- ------------------------------------------------------------
-- Tabelas independentes
-- ------------------------------------------------------------

CREATE TABLE `Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `Telefone` VARCHAR(11) NULL,
  `Email` VARCHAR(45) NULL,
  `Endereco` VARCHAR(45) NULL,
  `CPF` VARCHAR(45) NULL,
  PRIMARY KEY (`idCliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Lanche` (
  `idLanche` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `Descricao` VARCHAR(255) NULL,
  `Preco` DECIMAL(10,2) NOT NULL,
  `TempoPreparo` INT NULL,
  PRIMARY KEY (`idLanche`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Entregador` (
  `idEntregador` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `Telefone` VARCHAR(45) NULL,
  `CPF` VARCHAR(45) NULL,
  `Status` VARCHAR(45) NULL,
  PRIMARY KEY (`idEntregador`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Veiculo` (
  `idVeiculo` INT NOT NULL AUTO_INCREMENT,
  `Placa` VARCHAR(45) NOT NULL,
  `Tipo` VARCHAR(45) NULL,
  `Status` VARCHAR(45) NULL,
  PRIMARY KEY (`idVeiculo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `Forma_de_pagamento` (
  `CodFormaPag` INT NOT NULL AUTO_INCREMENT,
  `Descricao` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CodFormaPag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Pedido (Cliente 1:N Pedido | Forma_de_pagamento 1:N Pedido)
-- ------------------------------------------------------------

CREATE TABLE `Pedido` (
  `idPedido` INT NOT NULL AUTO_INCREMENT,
  `DataHora` DATETIME NOT NULL,
  `ValorTotal` DECIMAL(10,2) NULL,
  `Status` VARCHAR(45) NULL,
  `Observacao` VARCHAR(45) NULL,
  `Cliente_idCliente` INT NOT NULL,
  `Forma_de_pagamento_CodFormaPag` INT NOT NULL,
  PRIMARY KEY (`idPedido`),
  INDEX `fk_Pedido_Cliente_idx` (`Cliente_idCliente`),
  INDEX `fk_Pedido_FormaPag_idx` (`Forma_de_pagamento_CodFormaPag`),
  CONSTRAINT `fk_Pedido_Cliente`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `Cliente` (`idCliente`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Pedido_FormaPag`
    FOREIGN KEY (`Forma_de_pagamento_CodFormaPag`)
    REFERENCES `Forma_de_pagamento` (`CodFormaPag`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Item_Pedido (Pedido 1:N Item | Lanche 1:N Item)
-- ------------------------------------------------------------

CREATE TABLE `Item_Pedido` (
  `NumPedido` INT NOT NULL AUTO_INCREMENT,
  `Quantidade` INT NOT NULL DEFAULT 1,
  `PrecoUnitario` DECIMAL(10,2) NOT NULL,
  `ObservacoesItem` VARCHAR(45) NULL,
  `Pedido_idPedido` INT NOT NULL,
  `Pedido_Cliente_idCliente` INT NOT NULL,
  `Pedido_Forma_de_pagamento_CodFormaPag` INT NOT NULL,
  `Lanche_idLanche` INT NOT NULL,
  PRIMARY KEY (`NumPedido`),
  INDEX `fk_Item_Pedido_idx` (`Pedido_idPedido`),
  INDEX `fk_Item_Lanche_idx` (`Lanche_idLanche`),
  CONSTRAINT `fk_Item_Pedido`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `Pedido` (`idPedido`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Item_Lanche`
    FOREIGN KEY (`Lanche_idLanche`)
    REFERENCES `Lanche` (`idLanche`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Entrega (Pedido 1:1/N Entrega | Entregador 1:N | Veiculo 1:N)
-- ------------------------------------------------------------

CREATE TABLE `Entrega` (
  `idEntrega` INT NOT NULL AUTO_INCREMENT,
  `DataHoraSaida` DATETIME NULL,
  `DataHoraEntrega` DATETIME NULL,
  `Status` VARCHAR(45) NULL,
  `Pedido_idPedido` INT NOT NULL,
  `Pedido_Cliente_idCliente` INT NOT NULL,
  `Pedido_Forma_de_pagamento_CodFormaPag` INT NOT NULL,
  `Entregador_idEntregador` INT NOT NULL,
  `Veiculo_idVeiculo` INT NOT NULL,
  PRIMARY KEY (`idEntrega`),
  INDEX `fk_Entrega_Pedido_idx` (`Pedido_idPedido`),
  INDEX `fk_Entrega_Entregador_idx` (`Entregador_idEntregador`),
  INDEX `fk_Entrega_Veiculo_idx` (`Veiculo_idVeiculo`),
  CONSTRAINT `fk_Entrega_Pedido`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `Pedido` (`idPedido`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Entrega_Entregador`
    FOREIGN KEY (`Entregador_idEntregador`)
    REFERENCES `Entregador` (`idEntregador`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Entrega_Veiculo`
    FOREIGN KEY (`Veiculo_idVeiculo`)
    REFERENCES `Veiculo` (`idVeiculo`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

select * from cliente;
