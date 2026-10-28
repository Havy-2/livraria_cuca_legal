CREATE DATABASE INFESPDB;
USE INFESPDB;

CREATE TABLE departamentos
( num_departamento	INTEGER NOT NULL,
 nome VARCHAR(40) NOT NULL,
 localizacao VARCHAR(15) NOT NULL, 
PRIMARY KEY (num_departamento)
);

CREATE TABLE empregados
( numero	INTEGER NOT NULL, 
  nome	VARCHAR(40) NOT NULL,
  funcao	VARCHAR(20) NOT NULL,
  salario	DECIMAL(10,2) NOT NULL,
  premios	INTEGER DEFAULT NULL,
  num_departamento	INTEGER NOT NULL,
PRIMARY KEY (numero),
FOREIGN KEY (num_departamento) REFERENCES departamentos (num_departamento)
);

ALTER TABLE empregados
ADD (sexo CHAR(1) DEFAULT 'F' CHECK (sexo IN ('M', 'F'))
);

ALTER TABLE empregados
MODIFY sexo CHAR(3);

ALTER TABLE departamentos
ADD primary key(num_departamento);

ALTER TABLE empregados
DROP sexo;

INSERT INTO departamentos VALUES (10, 'Contabilidade', 'Condeixa');
INSERT INTO departamentos VALUES (20, 'Investigação', 'Mealhada');
INSERT INTO departamentos VALUES (30, 'Vendas', 'Coimbra');
INSERT INTO departamentos VALUES (40, 'Planejamento', 'Montemor');

SELECT * FROM departamentos;

INSERT INTO empregados (numero, nome, funcao, salario, premios, num_departamento)
VALUES (1839, 'Jorge Sampaio', 'Presidente', 49000, null, 10);

select * from empregados;

INSERT INTO empregados VALUES(1566, 'Augusto Reis', 'Encarregado', 4509,  null, 20);
INSERT INTO empregados VALUES(1698, 'Duarte Guedes',  'Encarregado', 3808,  null, 30);
INSERT INTO empregados VALUES(1782, 'Silvia Teles',  'Encarregado', 2794,  null, 10);
INSERT INTO empregados VALUES(1788, 'Maria Dias', 'Analista', 5650,  null, 20);
INSERT INTO empregados VALUES(1902, 'Catarina Silva', 'Analista', 4350,  null, 20);
INSERT INTO empregados VALUES(1499, 'Joana Mendes', 'Vendedor', 1456, 5630, 30);
INSERT INTO empregados VALUES(1521, 'Nelson Neves', 'Vendedor', 2122, 9850, 30);
INSERT INTO empregados VALUES(1654, 'Ana Rodrigues',  'Vendedor', 2212, 8140, 30);
INSERT INTO empregados VALUES(1844, 'Manuel Madeira', 'Vendedor', 1578, 0, 30);
INSERT INTO empregados VALUES(1900, 'Tome Ribeiro', 'Continuo', 5695,  null, 30);
INSERT INTO empregados VALUES(1876, 'Rita Pereira', 'Continuo', 6510,  null, 20);
INSERT INTO empregados VALUES(1934, 'Olga Costa', 'Continuo', 6830,  null, 10);
INSERT INTO empregados VALUES(1369, 'Antonio Silva',  'Continuo', 7080,  null, 20);

SELECT nome, numero, salario FROM empregados;

SELECT nome, salario * 14
FROM empregados;

SELECT nome, salario * 14 'Remuneração Anual'
FROM empregados;

SELECT CONCAT (nome, "/", funcao) 'Nome / função'
FROM empregados;

SELECT CONCAT ('O Exmo Sr. '," ",nome ," ", ' trabalha como ' ," ",funcao)  'Descrição Formal'
FROM empregados;

SELECT DISTINCT funcao, num_departamento 'Profissão e departamento'
FROM empregados
ORDER BY num_departamento, funcao;

SELECT DISTINCT nome, funcao, salario*14 + IFNULL(premios,0) 'Ganho Anual'
FROM empregados
ORDER BY 2 ASC, 'Ganho Anual' DESC, nome ASC;

SELECT num_departamento, nome, funcao, salario
FROM empregados
ORDER BY num_departamento, salario DESC, nome;

SELECT * FROM empregados
WHERE num_departamento = 10;

SELECT * FROM empregados
WHERE num_departamento = 10 AND NOT funcao = 'Encarregado';

SELECT * FROM empregados
WHERE num_departamento = 10 AND (NOT funcao = 'Encarregado'
OR num_departamento = 20);
 
SELECT nome, salario
FROM empregados
WHERE salario BETWEEN 10000 AND 20000;

SELECT nome, numero
FROM empregados
WHERE nome IN ('Jorge Sampaio', 'Augusto Reis', 'Duarte Guedes');

SELECT nome, numero
FROM empregados
WHERE nome LIKE 'A%' OR nome LIKE '_O%';

SELECT nome 'Sem Premios'
FROM empregados
WHERE premios IS NULL;

SELECT nome 'Com Premios'
FROM empregados
WHERE premios IS NOT NULL;

UPDATE empregados
SET salario = salario * 1.1;

UPDATE empregados
SET salario = salario * 1.1
WHERE num_departamento = 20;

UPDATE empregados
SET salario = salario = 100000, funcao = 'CHEFAO'
WHERE nome = 'Jorge Sampaio';

SELECT nome, salario
FROM empregados;

DELETE FROM departamentos;