-- =============================================================================
-- MySQL

/* 00 - Execute o script a seguir. */
DROP DATABASE IF EXISTS biblioteca;
CREATE DATABASE IF NOT EXISTS biblioteca;
USE biblioteca;

CREATE TABLE autor (
 id    INT AUTO_INCREMENT,
 nome  VARCHAR(45) NOT NULL,
 PRIMARY KEY (id)
);

CREATE TABLE livro (
 id         INT AUTO_INCREMENT,
 autor_id   INT NOT NULL,
 titulo     VARCHAR(100) NOT NULL,
 ano_publicacao YEAR,
 PRIMARY KEY (id),
 FOREIGN KEY (autor_id) REFERENCES autor(id)
);

CREATE TABLE emprestimo (
 id         INT AUTO_INCREMENT,
 livro_id   INT NOT NULL,
 data_emprestimo DATE NOT NULL,
 data_devolucao DATE,
 PRIMARY KEY (id),
 FOREIGN KEY (livro_id) REFERENCES livro(id)
);

INSERT INTO autor(nome) VALUES('J.K. Rowling');
INSERT INTO autor(nome) VALUES('J.R.R. Tolkien');
INSERT INTO autor(nome) VALUES('George R.R. Martin');
INSERT INTO autor(nome) VALUES('Agatha Christie');

INSERT INTO livro(autor_id, titulo, ano_publicacao) VALUES(1, "Harry Potter e a Pedra Filosofal", 1997);
INSERT INTO livro(autor_id, titulo, ano_publicacao) VALUES(2, "O Senhor dos Anéis", 1954);
INSERT INTO livro(autor_id, titulo, ano_publicacao) VALUES(3, "A Guerra dos Tronos", 1996);
INSERT INTO livro(autor_id, titulo, ano_publicacao) VALUES(4, "Assassinato no Expresso do Oriente", 1934);

/* 01 - Crie um usuário chamado bib_user com a senha password123. 
Este usuário poderá acessar as três tabelas SOMENTE com permissão de SELECT, INSERT, UPDATE e DELETE. */
CREATE USER 'bib_user'@'localhost' IDENTIFIED BY 'password123';
GRANT SELECT, INSERT, UPDATE, DELETE ON biblioteca.* TO 'bib_user'@'localhost';

/* 02 - Crie um usuário chamado leitor_view com a senha viewonly. 
Este usuário poderá somente fazer SELECT no campo titulo da tabela livro. */
CREATE USER 'leitor_view'@'localhost' IDENTIFIED BY 'viewonly';
GRANT SELECT (titulo) ON biblioteca.livro TO 'leitor_view'@'localhost';

/* 03 - Crie um usuário chamado emprestimo_user com a senha emprestimo123. 
Este usuário poderá fazer SELECT e INSERT na tabela emprestimo. Ele também poderá fazer SELECT na tabela livro. */
CREATE USER 'emprestimo_user'@'localhost' IDENTIFIED BY 'emprestimo123';
GRANT SELECT, INSERT ON biblioteca.emprestimo TO 'emprestimo_user'@'localhost';
GRANT SELECT ON biblioteca.livro TO 'emprestimo_user'@'localhost';

/* 04 - Tire, do usuário emprestimo_user, a permissão de INSERT na tabela emprestimo. */
REVOKE INSERT ON biblioteca.emprestimo FROM 'emprestimo_user'@'localhost';

/* 05 - Crie um gatilho (trigger) que, ao inserir um novo registro na tabela emprestimo, 
verifique se a data de devolução é maior que a data de empréstimo. Se não for, insira um registro na tabela log_emprestimo_invalido. */
CREATE TABLE log_emprestimo_invalido (
  id INT AUTO_INCREMENT PRIMARY KEY,
  livro_id INT NOT NULL,
  data_emprestimo DATE NOT NULL,
  data_devolucao DATE,
  FOREIGN KEY (livro_id) REFERENCES livro(id)
);

CREATE TRIGGER trig_emprestimo_data BEFORE INSERT ON emprestimo
FOR EACH ROW
BEGIN
  IF NEW.data_devolucao < NEW.data_emprestimo THEN
    INSERT INTO log_emprestimo_invalido (livro_id, data_emprestimo, data_devolucao) VALUES (NEW.livro_id, NEW.data_emprestimo, NEW.data_devolucao);
  END IF;
END;

/* 06 - Crie um gatilho (trigger) que, ao deletar um registro da tabela livro, 
insira o título do livro deletado em uma tabela chamada logLivroDeletado. */
CREATE TABLE logLivroDeletado (
  id INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(100) NOT NULL
);

CREATE TRIGGER trig_livro_delete AFTER DELETE ON livro
FOR EACH ROW
BEGIN
  INSERT INTO logLivroDeletado (titulo) VALUES (OLD.titulo);
END;

/* 07 - Crie um gatilho (trigger) que, antes de atualizar o título de um livro na tabela livro, 
registre o valor antigo e o novo título em uma tabela chamada logTituloLivro. */
CREATE TABLE logTituloLivro (
  id INT AUTO_INCREMENT PRIMARY KEY,
  titulo_antigo VARCHAR(100),
  titulo_novo VARCHAR(100)
);

CREATE TRIGGER trig_titulo_update BEFORE UPDATE ON livro
FOR EACH ROW
BEGIN
  IF NEW.titulo <> OLD.titulo THEN
    INSERT INTO logTituloLivro (titulo_antigo, titulo_novo) VALUES (OLD.titulo, NEW.titulo);
  END IF;
END;

/* 08 - Crie uma view chamada viewLivrosAutores que liste todos os livros com seus respectivos autores, 
mostrando o título do livro, ano de publicação e o nome do autor. */
CREATE VIEW viewLivrosAutores AS
SELECT l.titulo, l.ano_publicacao, a.nome AS autor
FROM livro l
INNER JOIN autor a ON l.autor_id = a.id;

/* 09 - Crie um procedimento armazenado (stored procedure) que insira um novo livro na tabela livro. 
O procedimento deve aceitar os parâmetros autor_id, titulo e ano_publicacao. */
DELIMITER $$

CREATE PROCEDURE inserir_livro(
    IN p_autor_id INT,
    IN p_titulo VARCHAR(100),
    IN p_ano_publicacao YEAR
)
BEGIN
    INSERT INTO livro (autor_id, titulo, ano_publicacao)
    VALUES (p_autor_id, p_titulo, p_ano_publicacao);
END $$

DELIMITER ;

-- Exemplo de chamada
CALL inserir_livro(2, 'Novo Livro', 2024);

/* 10 - Faça uma consulta que retorne os nomes dos autores (autor) 
e a quantidade de livros de cada autor, utilizando INNER JOIN e GROUP BY. */
SELECT autor.nome, COUNT(livro.id) AS quantidade_livros
FROM autor
INNER JOIN livro ON autor.id = livro.autor_id
GROUP BY autor.nome;

/* 11 - Faça uma consulta que retorne os autores e a quantidade de livros que eles têm, 
mas somente para aqueles autores que têm mais de 1 livro. A consulta deve incluir o nome do autor 
e a quantidade de livros, utilizando JOIN, GROUP BY e HAVING. */

SELECT a.nome AS autor, COUNT(l.id) AS quantidade_livros
FROM autor a
INNER JOIN livro l ON a.id = l.autor_id
GROUP BY a.nome
HAVING COUNT(l.id) > 1;


-- =============================================================================

/* MongoDB */

/* 01 - No Mongo Shell, crie a coleção Livros e insira os campos: 
titulo, autor, ano_publicacao, genero */
db.createCollection("Livros")

/* 02 - Insira 10 novos livros na coleção Livros: */
db.Livros.insertMany([
  { titulo: "Harry Potter e a Pedra Filosofal", autor: "J.K. Rowling", ano_publicacao: 1997, genero: "Fantasia" },
  { titulo: "O Senhor dos Anéis", autor: "J.R.R. Tolkien", ano_publicacao: 1954, genero: "Fantasia" },
  { titulo: "A Guerra dos Tronos", autor: "George R.R. Martin", ano_publicacao: 1996, genero: "Fantasia" },
  { titulo: "Assassinato no Expresso do Oriente", autor: "Agatha Christie", ano_publicacao: 1934, genero: "Mistério" },
  { titulo: "1984", autor: "George Orwell", ano_publicacao: 1949, genero: "Distopia" },
  { titulo: "O Código Da Vinci", autor: "Dan Brown", ano_publicacao: 2003, genero: "Mistério" },
  { titulo: "Moby Dick", autor: "Herman Melville", ano_publicacao: 1851, genero: "Aventura" },
  { titulo: "Dom Quixote", autor: "Miguel de Cervantes", ano_publicacao: 1605, genero: "Aventura" },
  { titulo: "O Pequeno Príncipe", autor: "Antoine de Saint-Exupéry", ano_publicacao: 1943, genero: "Infantil" },
  { titulo: "Orgulho e Preconceito", autor: "Jane Austen", ano_publicacao: 1813, genero: "Romance" }
])

/* 03 - No Mongo Shell, crie a coleção Autores e insira os autores, definindo o nome, 
a data de nascimento e a nacionalidade */
db.createCollection("Autores")
db.Autores.insertMany([
  { nome: "J.K. Rowling", data_nascimento: "1965-07-31", nacionalidade: "Britânica" },
  { nome: "J.R.R. Tolkien", data_nascimento: "1892-01-03", nacionalidade: "Britânica" },
  { nome: "George R.R. Martin", data_nascimento: "1948-09-20", nacionalidade: "Americana" },
  { nome: "Agatha Christie", data_nascimento: "1890-09-15", nacionalidade: "Britânica" },
  { nome: "George Orwell", data_nascimento: "1903-06-25", nacionalidade: "Britânica" }
])

/* 04 - Faça uma pesquisa que traga todos os livros publicados após o ano 1950 */
db.Livros.find({ ano_publicacao: { $gt: 1950 } })

/* 05 - Faça uma pesquisa que traga todos os autores nascidos após o ano de 1900 */
db.Autores.find({ data_nascimento: { $gt: ISODate("1900-01-01") } })

/* 06 - Faça uma pesquisa que traga todos os livros do gênero Mistério ou Romance */
db.Livros.find({ genero: { $in: ["Mistério", "Romance"] } })

/* 07 - Faça uma pesquisa que traga todos os livros publicados até o ano de 2000 */
db.Livros.find({ ano_publicacao: { $lte: 2000 } })

/* 08 - No Mongo Shell, atualize o ano de publicação de um livro específico: */
db.Livros.updateOne(
  { titulo: "1984" },
  { $set: { ano_publicacao: 1950 } }
)

/* 09 - No Mongo Shell, delete um autor específico: */
db.Autores.deleteOne({ nome: "Agatha Christie" })

/* 10 - Faça uma pesquisa que traga todos os livros do gênero Fantasia */
db.Livros.find({ genero: "Fantasia" })

/* 11 (desafio) - Faça uma consulta que traga todos os livros, 
mostrando o título, autor, ano de publicação e gênero */
db.Livros.find({}, { _id: 0, titulo: 1, autor: 1, ano_publicacao: 1, genero: 1 })
