CREATE DATABASE INFVESDB;
USE INFVESDB;

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

SELECT * FROM empregados;

INSERT INTO empregados (numero, nome, funcao, salario, premios, num_departamento)
VALUES (1839, 'Jorge Sampaio', 'Presidente', 49000, null, 10);

INSERT INTO empregados (numero, nome, funcao, salario, premios, num_departamento)
VALUES(1566, 'Augusto Reis', 'Encarregado', 4509,  null, 20);
INSERT INTO empregados (numero, nome, funcao, salario, premios, num_departamento)
VALUES(1698, 'Duarte Guedes',  'Encarregado', 3808,  null, 30);
INSERT INTO empregados (numero, nome, funcao, salario, premios, num_departamento) 
VALUES(1782, 'Silvia Teles',  'Encarregado', 2794,  null, 10);
INSERT INTO empregados (numero, nome, funcao, salario, premios, num_departamento) 
VALUES(1788, 'Maria Dias', 'Analista', 5650,  null, 20);
INSERT INTO empregados (numero, nome, funcao, salario, premios, num_departamento)
 VALUES(1902, 'Catarina Silva', 'Analista', 4350,  null, 20);
INSERT INTO empregados (numero, nome, funcao, salario, premios, num_departamento)
VALUES(1499, 'Joana Mendes', 'Vendedor', 1456, 5630, 30);
INSERT INTO empregados (numero, nome, funcao, salario, premios, num_departamento) 
VALUES(1521, 'Nelson Neves', 'Vendedor', 2122, 9850, 30);
INSERT INTO empregados (numero, nome, funcao, salario, premios, num_departamento) 
VALUES(1654, 'Ana Rodrigues',  'Vendedor', 2212, 8140, 30);
INSERT INTO empregados (numero, nome, funcao, salario, premios, num_departamento) 
VALUES(1844, 'Manuel Madeira', 'Vendedor', 1578, 0, 30);
INSERT INTO empregados (numero, nome, funcao, salario, premios, num_departamento) 
VALUES(1900, 'Tome Ribeiro', 'Continuo', 5695,  null, 30);
INSERT INTO empregados (numero, nome, funcao, salario, premios, num_departamento) 
VALUES(1876, 'Rita Pereira', 'Continuo', 6510,  null, 20);
INSERT INTO empregados (numero, nome, funcao, salario, premios, num_departamento)
VALUES(1934, 'Olga Costa', 'Continuo', 6830,  null, 10);
INSERT INTO empregados (numero, nome, funcao, salario, premios, num_departamento) 
VALUES(1369, 'Antonio Silva',  'Continuo', 7080,  null, 20);

SELECT nome, numero, salario FROM empregados;

SELECT nome, salario * 14
FROM empregados;

SELECT nome, salario * 14 'Remuneração Anual'
FROM empregados;

SELECT CONCAT (nome, "/", funcao) 'Nome / função'
FROM empregados;

SELECT CONCAT ('O Exmo Sr. '," ",nome ," ", ' trabalha como ' ," ",funcao)  'Descrição Formal'
FROM empregados;

use infvesdb;

select distinct funcao from empregados;

SELECT DISTINCT funcao, num_departamento 'Profissão e departamento'
FROM empregados
ORDER BY num_departamento, funcao;

SELECT num_departamento, nome, funcao, salario
FROM empregados
ORDER BY num_departamento, salario DESC, nome;

SELECT DISTINCT nome, funcao, salario*14 + IFNULL(premios,0) 'Ganho Anual'
FROM empregados
ORDER BY 2 ASC, 'Ganho Anual' DESC, nome ASC;

SELECT * FROM empregados
WHERE num_departamento = 10;

SELECT * 
FROM empregados
WHERE num_departamento = 10 
AND funcao != 'Encarregado';

SELECT * FROM empregados
WHERE num_departamento = 10 
AND (NOT funcao = 'Encarregado'
OR num_departamento = 20);

SELECT nome, salario
FROM empregados
WHERE salario BETWEEN 1000 AND 3000;

SELECT nome, numero
FROM empregados
WHERE nome IN ('Jorge Sampaio', 'Augusto Reis', 'Duarte Guedes');

SELECT nome, numero
FROM empregados
WHERE nome LIKE 'A%' 
or nome LIKE '%O';

SELECT nome 'Com Premios'
FROM empregados
WHERE premios <> NULL;

UPDATE empregados
SET salario = salario * 1.1
Where num_departamento = 30;

Select  salario , funcao 
from empregados
WHERE nome = 'Jorge Sampaio';

UPDATE empregados
SET salario = salario = 100000 , funcao = 'CHEFAO'
WHERE nome = 'Jorge Sampaio';

SELECT num_departamento, funcao, max(salario) Sal_Max, min(salario) Sal_Min,
avg(salario)Sal_Med, count(*) Quantos, sum(salario) Somatorio 
FROM empregados 
GROUP BY num_departamento, funcao 
ORDER BY 1, 3;

SELECT funcao, max(salario)
FROM empregados
WHERE funcao != 'Presidente'
GROUP BY funcao
ORDER BY max(salario) ASC; 

SELECT funcao, max(salario)
FROM empregados
WHERE max(salario) > 300000
GROUP BY funcao
ORDER BY max(salario) ASC;

SELECT COUNT(*)	"Todos",
COUNT(salario)	"#Salario não null",
COUNT(premios)	"#Premios não null",
COUNT(salario*14+premios) "#Expressão não null"
FROM empregados;

SELECT count(ALL funcao) "Todos",
count(DISTINCT funcao) "Profissões",
count(funcao)"Igual a ALL"
FROM empregados;

select * from empregados;

DESCRIBE empregados;

SELECT nome_empregado, funcao, salario
FROM empregados
ORDER BY salario DESC;

SELECT num_empregado, nome_empregado
FROM empregados
WHERE nome_empregado LIKE '%Silva%';

SELECT nome_empregado, funcao, num_departamento
FROM empregados
WHERE num_departamento IN (10, 30);

SELECT nome_empregado, salario
FROM empregados
WHERE num_departamento = 30
  AND salario BETWEEN 1500 AND 4000;

SELECT nome_empregado, funcao, salario
FROM empregados
WHERE funcao = 'Analista'
   OR salario > 6000;

SELECT nome_empregado, premios
FROM empregados
WHERE premios IS NOT NULL;

SELECT COUNT(*) AS total_empregados
FROM empregados, departamentos
WHERE empregados.num_departamento = departamentos.num_departamento
  AND departamentos.localizacao = 'Mealhada';

ALTER TABLE empregados
ADD COLUMN email VARCHAR(100);

UPDATE empregados
SET salario = salario * 1.10
WHERE funcao = 'Vendedor';

SELECT nome_empregado, salario
FROM empregados
WHERE funcao = 'Vendedor';

DELETE FROM empregados
WHERE num_empregado = 1844;

SELECT *
FROM empregados
WHERE num_empregado = 1844;

INSERT INTO empregados (num_empregado, nome_empregado, funcao, salario, premios, num_departamento, email)
VALUES (2001, 'Lucas Almeida', 'Analista', 4200, NULL, 20, NULL);

SELECT *
FROM empregados
WHERE num_empregado = 2001;

USE infvesdb;

ALTER TABLE empregados
  CHANGE COLUMN numero num_empregado INT NOT NULL;

ALTER TABLE empregados
  CHANGE COLUMN nome nome_empregado VARCHAR(80) NOT NULL;

ALTER TABLE empregados
  ADD COLUMN email VARCHAR(100) NULL;