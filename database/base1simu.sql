-- BD2 - Simulado

DROP DATABASE IF EXISTS simulinha;
CREATE DATABASE simulinha;
USE simulinha;

CREATE TABLE livro (
    id     INT AUTO_INCREMENT,
    titulo VARCHAR(100),
    autor  VARCHAR(100),
    qtd_exemplares INT,
    PRIMARY KEY (id)
);

CREATE TABLE usuario (
    id    INT AUTO_INCREMENT,
    nome  VARCHAR(100),
    email VARCHAR(100),
    PRIMARY KEY (id)
);

CREATE TABLE emprestimo (
    id              INT AUTO_INCREMENT,
    id_livro        INT,
    id_usuario      INT,
    data_emprestimo DATE,
    data_devolucao  DATE DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id_livro)   REFERENCES livro(id),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

INSERT INTO livro (titulo, autor, qtd_exemplares) VALUES
('O Tronco do Ipê', 'José de Alencar', 5),
('Dom Casmurro', 'Machado de Assis', 3),
('Quincas Berro DÁgua', 'Jorge Amado', 4),
('O Escaravelho do Diabo', 'Lúcia Machado de Almeida', 2),
('O Guarani', 'José de Alencar', 5),
('Robinson Crusoé', 'Daniel Defoe', 6),
('O Sítio do Picapau Amarelo', 'Monteiro Lobato', 7),
('O Cachorrinho Samba na Fazenda', 'Maria José Dupré', 3),
('A Moreninha', 'Joaquim Manuel de Macedo', 4),
('Memórias de um Sargento de Milícias', 'Manuel Antônio de Almeida', 5);

INSERT INTO usuario (nome, email) VALUES
('Juan Ivanov', 'juan@gmail.com'),
('Miguel Petrov', 'miguel@gmail.com'),
('Pedro Smirnov', 'pedro@gmail.com'),
('Ana Kuznetsova', 'ana@gmail.com'),
('José Pavlov', 'jose@gmail.com'),
('Carlos Romanov', 'carlos@gmail.com'),
('Maria Volkov', 'maria@gmail.com'),
('Sofia Fedorova', 'sofia@gmail.com'),
('Luis Popov', 'luis@gmail.com'),
('Gabriela Sokolov', 'gabriela@gmail.com');

/* 1. Crie um trigger que diminua o número de cópias 
disponíveis ao registrar um empréstimo. */
DELIMITER $$
CREATE TRIGGER trg_baixa_copia
AFTER INSERT ON emprestimo
FOR EACH ROW
BEGIN
  UPDATE livro
  SET qtd_exemplares = qtd_exemplares - 1
  WHERE id = NEW.id_livro;
END$$
DELIMITER ;

/* 2. Crie um trigger que aumente o número 
de cópias disponíveis ao devolver um livro. */
DELIMITER $$
CREATE TRIGGER trg_devolve_copia
AFTER UPDATE ON emprestimo
FOR EACH ROW
BEGIN
  IF NEW.data_devolucao IS NOT NULL THEN
    UPDATE livro
    SET qtd_exemplares = qtd_exemplares + 1
    WHERE id = NEW.id_livro;
  END IF;
END$$
DELIMITER ;

/* 3. Crie uma procedure que exiba a quantidade 
de livros emprestados por um usuário. */
DELIMITER $$
CREATE PROCEDURE qtd_livros_emprestados(IN id_usuario INT)
BEGIN
  SELECT COUNT(*) AS total_emprestimos
  FROM emprestimo
  WHERE id_usuario = id_usuario;
END$$
DELIMITER ;

/* 4. Faça uma consulta que retorne o título dos 
livros que possuem mais de 3 cópias disponíveis. */
SELECT titulo
FROM livro
WHERE qtd_exemplares > 3;

/* 5. Faça uma consulta que retorne os usuários 
que não realizaram nenhum empréstimo. */
SELECT nome
FROM usuario
WHERE id NOT IN (SELECT id_usuario FROM emprestimo);

/* 6. Crie uma procedure que exiba 
todos os usuários que devolveram livros. */
DELIMITER $$
CREATE PROCEDURE usuarios_devolveram_livros()
BEGIN
  SELECT DISTINCT u.nome
  FROM usuario u
  JOIN emprestimo e ON u.id = e.id_usuario
  WHERE e.data_devolucao IS NOT NULL;
END$$
DELIMITER ;

/* 7. Crie um trigger que impeça o empréstimo 
de um livro quando não houver mais cópias disponíveis. */
DELIMITER $$
CREATE TRIGGER trg_impedir_emprestimo
BEFORE INSERT ON emprestimo
FOR EACH ROW
BEGIN
  IF (SELECT qtd_exemplares FROM livro WHERE id = NEW.id_livro) < 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não há cópias disponíveis.';
  END IF;
END$$
DELIMITER ;

/* 8. Faça uma consulta que retorne os livros que nunca foram emprestados. */
SELECT titulo
FROM livro
WHERE id NOT IN (SELECT id_livro FROM emprestimo);

/* 9. Crie um trigger que registre a data de devolução 
automaticamente ao atualizar um empréstimo. */
DELIMITER $$
CREATE TRIGGER trg_data_devolucao
BEFORE UPDATE ON emprestimo
FOR EACH ROW
BEGIN
  IF NEW.data_devolucao IS NULL THEN
    SET NEW.data_devolucao = CURDATE();
  END IF;
END$$
DELIMITER ;

/* 10. Faça uma consulta que retorne todos os 
empréstimos realizados no último mês. */
SELECT *
FROM emprestimo
WHERE data_emprestimo >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

/* 11. Crie uma procedure que insira um novo empréstimo 
e retorne uma mensagem se o livro estiver disponível ou não. */
DELIMITER $$
CREATE PROCEDURE novo_emprestimo(IN id_livro INT, IN id_usuario INT)
BEGIN
  IF (SELECT qtd_exemplares FROM livro WHERE id = id_livro) > 0 THEN
    INSERT INTO emprestimo (id_livro, id_usuario, data_emprestimo) VALUES (id_livro, id_usuario, CURDATE());
    SELECT 'Empréstimo realizado com sucesso.';
  ELSE
    SELECT 'Não há cópias disponíveis para este livro.';
  END IF;
END$$
DELIMITER ;

/* 12. Desabilite o autocommit e realize uma transação 
para inserir um empréstimo e depois fazer rollback. */
SET autocommit = 0;
START TRANSACTION;
INSERT INTO emprestimo (id_livro, id_usuario, data_emprestimo) VALUES (1, 1, CURDATE());
ROLLBACK;

/* 13. Faça uma consulta que retorne a lista de todos os livros 
e as cópias disponíveis com um lock de leitura para garantir 
que os dados não sejam modificados enquanto a consulta está em execução. */
SELECT * FROM livro LOCK IN SHARE MODE;

/* 14. Crie um usuário 'bibliotecario' com permissão para 
inserir, atualizar e excluir dados nas tabelas do banco 'bibliotecaBD'. */
CREATE USER 'bibliotecario'@'localhost' IDENTIFIED BY 'senha123';
GRANT INSERT, UPDATE, DELETE ON bibliotecaBD.* TO 'bibliotecario'@'localhost';

/* 15. Revogue as permissões de DELETE do usuário 'bibliotecario'. */
REVOKE DELETE ON bibliotecaBD.* FROM 'bibliotecario'@'localhost';
