USE est_cadastro;-- SELECIONA BANCO PARA USO

DROP DATABASE est_cadastro;

CREATE DATABASE cadastro -- CRIANDO BANCO DE DADOS
DEFAULT CHARACTER SET UTF8
DEFAULT COLLATE UTF8_GENERAL_CI;

CREATE TABLE pessoas (
    idcurso INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(30) NOT NULL,
    nascimento DATE,
    sexo ENUM('M', 'F'),
    peso DECIMAL(5 , 2 ),
    altura DECIMAL(3 , 2 ),
    nascionalidade VARCHAR(20) DEFAULT 'BRASIL',
    PRIMARY KEY (idcurso)
)  DEFAULT CHARSET=UTF8;

DESCRIBE cursos; /* DESCREVE A TABELA*/

ALTER TABLE pessoas
ADD COLUMN profissao VARCHAR(10) AFTER nome; /*COLOCAR EM DETERMINADA POSIÇÃO EM RELAÇÃO AOS CAMPOS*/

ALTER TABLE cursos
ADD COLUMN idcurso INT FIRST; /*COLOCAR CAMPO EM PRIMEIRO LUGAR*/

ALTER TABLE pessoas
DROP COLUMN profissao; /*RETIRAR CAMPO*/

ALTER TABLE pessoas
MODIFY COLUMN profissao VARCHAR(30) NOT NULL DEFAULT 'ESTAGIARIO'; /*ALTERAR CAMPO DE TABELA E COLOCANDO NOT NULL*/

ALTER TABLE pessoas
CHANGE COLUMN nascimento nascimento DATE NOT NULL; /*MUDAR NOME DO CAMPO*/

ALTER TABLE CIDADAO
RENAME TO pessoas;  /*MUDAR NOME DA TABELA*/

ALTER TABLE cursos
ADD PRIMARY KEY (idcurso); -- ALTERANDO CAMPO PARA CHAVE PRIMARIA

ALTER TABLE `usuarios_token` ADD FOREIGN KEY (id_usuarios) REFERENCES usuarios(id);

SELECT 
    *
FROM
    pessoas WHERE nascionalidade = 'PORTUGAL';

INSERT INTO banco.pessoas
(id, nome, nacimento, sexo, peso, altura, nascionalidade) -- inserção completa do comando
VALUES
(DEFAULT,'CREUZA','ESTAGIÁRIO', '1920-12-30', 'F', '50.2', '1.65', DEFAULT);

INSERT INTO banco.pessoas VALUES
(DEFAULT,'ADALGINA', 'CAIXA', '1930-11-2', 'F', '63.2', '1.75', 'IRLANDA'); -- inserção apenas na sequencia da ordem dos dados dos campos

INSERT INTO pessoas VALUES
(DEFAULT,'CLÁUDIO', 'GERENTE','1980-08-01','M', '99.3', '1.75', 'ARGENTINA'), 
(DEFAULT,'JANAÍNA', 'ESTAGIARIO', '1985-07-15','F', '70.3', '1.60', DEFAULT), -- inserção de varias pessoas de uma vez
(DEFAULT,'LAÍS', 'TESTER', '2000-07-25','F', '70.3', '1.69', 'AFRICA DO SUL');

CREATE TABLE IF NOT EXISTS cursos (
	nome VARCHAR(30) NOT NULL UNIQUE, --valor unico
    descricao TEXT,
    carga INT UNSIGNED, --somente valores positivos
    totaulas INT UNSIGNED,
    ano YEAR DEFAULT '2016'
)DEFAULT CHARSET = UTF8;
TRUNCATE TABLE cursos;
-- quando se usa ZEROFILL o campo se completa com zeros onde não foi preenchido
UPDATE `cursos` SET CARGA='40', ANO='2016' WHERE `IDCURSO`=7 LIMIT 1;
UPDATE `est_cadastro`.`pessoas` SET nascionalidade='PORTUGAL' WHERE ID='2';
DELETE FROM `cursos` WHERE ANO='2050' LIMIT 2; --limit faz limite de deletes
SELECT * FROM cursos;
SELECT * FROM pessoas;
INSERT INTO cursos VALUES
('2', 'ALGORITIMOS','LÓGICA DE PROGRAMAÇÃO','20', '15','2014'),
('3', 'PHOTOSHOP','DICAS DE PHOTOSHOP CC','10', '8','2014'),
('4', 'PHP','CURSO DE PHP PARA INICIANTES','40', '20','2010'),
('5', 'JAVA','INTRODUÇÃO À LINGUAGEM JAVA','10', '29','2000'),
('6', 'MYSQL','BANCO DE DADOS MYSQL','30', '15','2016'),
('7', 'WORD','CURSO COMPLETO DE WORD','40', '30','2018'),
('8', 'SAPATEADO','DANÇAS RÍTMICAS','40', '30','2018'),
('9', 'COZINHA ÁRABE','APRENDA A FAZER KIBE','40', '30','2018'),
('10', 'YOUTUBER','GERAR POLÊMICA E GANHAR INSCRITOS','5', '2','2018');
INSERT INTO usuario (`nome`, `senha`) VALUES ('FULANO', MD5('123'));
UPDATE `banco`.`tabela` SET senha=MD5('novasenha');

-- AGREGAÇÃO --
SELECT nome, ano FROM `est_cadastro`.`cursos` WHERE ano > 2010 ORDER BY nome;
SELECT nome, ano FROM `est_cadastro`.`cursos` WHERE ano BETWEEN 2010 AND 2014 ORDER BY ano, nome;
SELECT nome, ano FROM `est_cadastro`.`cursos` WHERE ano IN (2010, 2016) ORDER BY ano, nome;

SELECT nome, ano, carga, totaulas FROM `est_cadastro`.`cursos` WHERE carga >35 AND totaulas<35; /*OR*/

SELECT nome, ano FROM `est_cadastro`.`cursos` WHERE nome LIKE '%P_P%'; /*NOT LIKE*/-- TAMBEM USAR UM _ PARA MOSTRAR EXISTENCIA DE CARACTER
-- AGRUPAMENTO--
SELECT DISTINCT nascionalidade FROM `est_cadastro`.`pessoas` ORDER BY nascionalidade;
SELECT COUNT(*) FROM pessoas; /*SELECT COUNT(*) as c FROM pessoas;*/
SELECT MAX(carga) FROM cursos WHERE ano='2016'; /*SELECT MAX(carga) as m FROM cursos WHERE ano='2016';*/
SELECT MIN(carga) FROM cursos WHERE ano='2016'; /*SELECT MIN(carga) as m FROM cursos WHERE ano='2016';*/
SELECT SUM(totaulas) FROM cursos; /*SELECT SUM(totaulas) as s FROM cursos;*/
SELECT AVG(totaulas) FROM cursos; /*MÉDIA - SELECT AVG(totaulas) as m FROM cursos;*/ 
-- ==============
-- exercicios--  
-- ==============
SELECT * FROM pessoas WHERE sexo = 'F';
SELECT * FROM pessoas WHERE sexo = 'M' AND cargo = 'programador';
SELECT * FROM pessoas WHERE sexo = 'F' AND nascionalidade = 'BRASIL' AND nome LIKE 'J%';
SELECT nome, nacionalidade FROM pessoas WHERE sexo='M' AND nacionalidade !='BRASIL' AND peso<'100' AND nome LIKE '%SILVA%';
SELECT MAX(altura) FROM pessoas WHERE nacionalidade='brasil';
SELECT AVG(peso) FROM pessoas;
SELECT MIN(peso) FROM pessoas WHERE sexo='F' AND nacionalidade !='BRASIL' AND nascimento BETWEEN '1990-01-01' AND '2000-12-31';
SELECT COUNT(*) FROM pessoas WHERE sexo='F' AND altura > '1.9';
DESCRIBE pessoas;
 
SELECT DISTINCT totaulas FROM cursos ORDER BY totaulas;
SELECT totaulas, COUNT(*) FROM cursos GROUP BY totaulas ORDER BY totaulas;
SELECT carga, COUNT(nome) FROM cursos WHERE totaulas = '30' GROUP BY carga;
SELECT nacionalidade, COUNT(*) FROM pessoas GROUP BY nacionalidade ORDER BY nacionalidade;

SELECT totaulas, COUNT(*) FROM cursos
GROUP BY totaulas
ORDER BY totaulas;

SELECT ano, COUNT(*) FROM cursos
GROUP BY ano
HAVING COUNT(ano) >=2
ORDER BY COUNT(*) DESC;

SELECT AVG(carga) FROM cursos;

SELECT carga, COUNT(*) FROM cursos
WHERE ano >2002
GROUP BY carga
HAVING carga > (SELECT AVG(carga) FROM cursos);

-- ==============
-- exercicios--  
-- ==============
SELECT * FROM cursos;
SELECT * FROM pessoas;
SELECT cargo, COUNT(*) FROM pessoas GROUP BY cargo;
SELECT sexo, COUNT(*) FROM pessoas WHERE nascimento > '2005-01-01' GROUP BY sexo;

SELECT nacionalidade, COUNT(*) FROM pessoas 
WHERE nacionalidade <> 'BRASIL' 
GROUP BY nacionalidade 
HAVING COUNT(*) > 1 ORDER BY nacionalidade;

SELECT altura, COUNT(*) FROM pessoas 
WHERE peso >'60'
GROUP BY altura
HAVING altura > (SELECT AVG(altura) FROM pessoas);

-- CHAVE ESTRANGEIRA-- 
USE est_cadastro;
DESC pessoas;
ALTER TABLE pessoas ADD cursopreferido INT;

ALTER TABLE pessoas 
ADD FOREIGN KEY (cursopreferido) 
REFERENCES cursos (idcurso);

UPDATE pessoas SET cursopreferido='6' WHERE id='1';

SELECT pessoas.nome AS ALUNO, cursos.nome AS `CURSO PREFERIDO`, cursos.ano AS `ANO DO CURSO`
FROM pessoas INNER JOIN cursos
ON cursos.idcurso=pessoas.cursopreferido
ORDER BY pessoas.nome;

SELECT p.nome , c.nome , c.ano
FROM pessoas AS p JOIN cursos AS c
ON c.idcurso=p.cursopreferido
ORDER BY p.nome;

SELECT pessoas.nome AS ALUNO, cursos.nome AS `CURSO PREFERIDO`, cursos.ano AS `ANO DO CURSO`
FROM pessoas LEFT OUTER JOIN cursos -- PODE USAR SEM OUTER "LEFT JOIN" ou USAR RIGHT OUTER JOIN ou "RIGHT JOIN" -- 
ON cursos.idcurso=pessoas.cursopreferido
ORDER BY pessoas.nome;

CREATE TABLE turma(
	idturma INT NOT NULL AUTO_INCREMENT,
    data DATE,
    idpessoas INT,
    idcurso INT,
    PRIMARY KEY (idturma),
    FOREIGN KEY (idpessoas) REFERENCES pessoas(id),
    FOREIGN KEY (idcurso) REFERENCES cursos(idcurso)
    )DEFAULT CHARSET = UTF8;
    
INSERT INTO turma VALUES
	(DEFAULT, '2014-03-01', '1', '2');
SELECT * FROM turma;

SELECT * FROM pessoas p JOIN turma t ON p.id=t.idpessoas;

SELECT p.nome, c.nome as `nome do curso` FROM pessoas p 
JOIN turma t 
ON p.id=t.idturma 
JOIN cursos c 
ON c.idcurso = t.idcurso 
ORDER BY p.nome;