/*1- Crie um banco de dados para gerenciar uma biblioteca.
O sistema deve manter um registro de livros, seus empréstimos e devoluções.
Crie triggers que atualizam automaticamente o número de cópias disponíveis no sistema quando um livro
for emprestado ou devolvido.
Você vai implementar triggers que automatizam a atualização do número de cópias disponíveis de cada
livro.
Crie as tabelas Livro e Emprestimo.
A tabela Livro deve conter informações como ID do livro, título, autor, e número de cópias disponíveis.
A tabela Emprestimo deve armazenar o ID do livro, o ID do usuário que fez o empréstimo, a data do
empréstimo e a data de devolução (que pode ser NULL até a devolução ocorrer).
Crie um trigger AFTER INSERT na tabela Emprestimo para atualizar o número de cópias disponíveis de um
livro quando for realizado um empréstimo (diminua uma cópia).
Crie um trigger AFTER UPDATE na tabela Emprestimo para atualizar o número de cópias disponíveis
quando o livro for devolvido (aumente uma cópia).
*/

DROP DATABASE IF EXISTS aula05_bib;
CREATE DATABASE aula05_bib;
USE aula05_bib;

CREATE TABLE usuario (
    id              INT AUTO_INCREMENT,
    nome            VARCHAR(255) NOT NULL,
    email           VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE livro (
    id              INT AUTO_INCREMENT,
    titulo          VARCHAR(255) NOT NULL,
    autor           VARCHAR(255) NOT NULL,
    qtd_copias      INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE emprestimo (
    id              INT AUTO_INCREMENT,
    id_livro        INT,
    id_usuario      INT,
    data_emprestimo DATE,
    data_devolucao  DATE DEFAULT NULL,
    FOREIGN KEY (id_livro)   REFERENCES livro(id),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id),
    PRIMARY KEY (id)
);

DELIMITER $$
CREATE TRIGGER trg_emprestimo_ai
AFTER INSERT ON emprestimo
FOR EACH ROW
BEGIN
    UPDATE livro
    SET qtd_copias = qtd_copias - 1
    WHERE id = NEW.id_livro;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_emprestimo_au
AFTER UPDATE ON emprestimo
FOR EACH ROW
BEGIN
    UPDATE livro
    SET qtd_copias = qtd_copias + 1
    WHERE id = NEW.id_livro;
END $$
DELIMITER ;

INSERT INTO usuario (nome, email) VALUES ('Astropinto Martins', 'astromar@email.com');
INSERT INTO usuario (nome, email) VALUES ('Gambiarra Lucileide', 'gambi@email.com');
INSERT INTO usuario (nome, email) VALUES ('Sertolino Ganso', 'serto.gan@email.com');

INSERT INTO livro (titulo, autor, qtd_copias) VALUES ('Dom Quixote', 'Miguel de Cervantes', 6);
INSERT INTO livro (titulo, autor, qtd_copias) VALUES ('1984', 'George Orwell', 4);
INSERT INTO livro (titulo, autor, qtd_copias) VALUES ('O Senhor dos Anéis', 'J. R. R. Tolkien', 3);

INSERT INTO emprestimo (id_livro, id_usuario, data_emprestimo) VALUES (1, 1, '2024-01-11');
INSERT INTO emprestimo (id_livro, id_usuario, data_emprestimo) VALUES (2, 2, '2024-02-16');
INSERT INTO emprestimo (id_livro, id_usuario, data_emprestimo) VALUES (3, 3, '2024-03-12');

-- ---------------------------------------

/* 2- Desenvolva um banco de dados de Recursos Humanos que contenha informações sobre os funcionários e
seus bônus anuais. Crie uma procedure que calcule o valor do bônus de acordo com o tempo de serviço e
armazene o resultado em uma tabela de bônus. O sistema precisa de uma procedure para calcular o
bônus de acordo com o salário base e o tempo de serviço.
Crie as tabelas Funcionario e Bonus.
A tabela Funcionario deve conter o ID, nome, salário base e data de contratação.
A tabela Bonus deve conter o ID do funcionário, ano, e o valor do bônus.
Crie uma procedure chamada CalcularBonus que:
• Receba como parâmetros o ID do funcionário, o salário base e a data de contratação.
• Calcule o bônus anual com base no tempo de serviço. Para cada ano de serviço, o funcionário
recebe 5% do seu salário base como bônus.
• Insira o resultado na tabela Bonus
*/

DROP DATABASE IF EXISTS aula05_rh;
CREATE DATABASE aula05_rh;
USE aula05_rh;

CREATE TABLE funcionario (
    id               INT AUTO_INCREMENT,
    nome             VARCHAR(255) NOT NULL,
    salario_base     DECIMAL(10, 2) NOT NULL,
    data_contratacao DATE NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE bonus (
    id             INT AUTO_INCREMENT,
    id_funcionario INT,
    ano            INT,
    vlr_bonus    DECIMAL(10, 2),
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id),
    PRIMARY KEY (id)
);

DELIMITER $$
CREATE PROCEDURE calc_bonus(IN var_id_funcionario INT, IN var_salario_base DECIMAL(10,2), IN var_data_contratacao DATE)
BEGIN
    DECLARE var_vlr_bonus DECIMAL(10,2);
    SET var_vlr_bonus = var_salario_base * 0.05 * (YEAR(CURDATE()) - YEAR(var_data_contratacao));
    
    INSERT INTO bonus (id_funcionario, ano, vlr_bonus)
    VALUES (var_id_funcionario, YEAR(CURDATE()), var_vlr_bonus);
END $$
DELIMITER ;

INSERT INTO funcionario (nome, salario_base, data_contratacao) VALUES ('Ana Pereira', 3500.00, '2019-03-01');
INSERT INTO funcionario (nome, salario_base, data_contratacao) VALUES ('Bruno Costa', 4200.50, '2017-07-15');
INSERT INTO funcionario (nome, salario_base, data_contratacao) VALUES ('Camila Santos', 5000.75, '2020-11-20');

CALL calc_bonus(1, 3500.00, '2019-03-01');
CALL calc_bonus(2, 4200.50, '2017-07-15');
CALL calc_bonus(3, 5000.75, '2020-11-20');

