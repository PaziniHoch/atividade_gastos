/* ============================================================
   PROJETO: CONTROLE DE GASTOS FAMILIARES
   Banco: PostgreSQL
   ============================================================ */

/* ------------------------------------------------------------
   CONVENÇÃO DE NOMES
   - Tabelas: sempre no plural         (usuarios, gastos)
   - Foreign keys: singular + _id      (usuario_id, categoria_id)
   ------------------------------------------------------------ */


/* ============================================================
   1. CRIAÇÃO DAS TABELAS
   ============================================================ */

/* Tabela de usuários (pessoas que registram gastos) */
CREATE TABLE usuarios (
    id            SERIAL PRIMARY KEY,
    nome          VARCHAR(50) NOT NULL,
    email         VARCHAR(100) UNIQUE NOT NULL,
    data_criacao  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/* Tabela de gastos (cada gasto pertence a um usuário) */
CREATE TABLE gastos (
    id          SERIAL PRIMARY KEY,
    usuario_id  INTEGER NOT NULL REFERENCES usuarios(id),
    valor       NUMERIC(10,2) NOT NULL,
    descricao   TEXT NOT NULL,
    data        DATE NOT NULL
);


/* ============================================================
   2. INSERÇÃO DE DADOS
   ============================================================ */

/* Cadastro dos usuários */
INSERT INTO usuarios (nome, email) VALUES
    ('Andre', 'pazinihoch@gmail.com'),
    ('Caua',  'caua@hotmail.com');

/* Conferir os ids gerados antes de inserir os gastos */
SELECT * FROM usuarios;

/* Inserção dos gastos, referenciando o usuario_id */
INSERT INTO gastos (usuario_id, valor, descricao, data) VALUES
    (1, 100.00, 'Gasolina', '2026-07-02'),
    (1, 52.60,  'Ifood',    '2026-07-08'),
    (1, 12.50,  'Uber',     '2026-07-09');


/* ============================================================
   3. CONSULTAS DE ANÁLISE
   ============================================================ */

/* Gastos de um usuário específico */
SELECT
    usuarios.nome,
    gastos.valor,
    gastos.data
FROM gastos
JOIN usuarios ON gastos.usuario_id = usuarios.id
WHERE usuarios.nome = 'Andre';

/* Total gasto no mês de julho de 2026 */
SELECT
    SUM(valor) AS total_julho
FROM gastos
WHERE TO_CHAR(data, 'YYYY-MM') = '2026-07';

/* Total gasto por pessoa (do maior para o menor) */
SELECT
    usuarios.nome,
    SUM(gastos.valor) AS total_gasto
FROM gastos
JOIN usuarios ON gastos.usuario_id = usuarios.id
GROUP BY usuarios.nome
ORDER BY total_gasto DESC;

/* Total gasto por pessoa, filtrado só por julho de 2026 */
SELECT
    usuarios.nome,
    SUM(gastos.valor) AS total_julho
FROM gastos
JOIN usuarios ON gastos.usuario_id = usuarios.id
WHERE TO_CHAR(gastos.data, 'YYYY-MM') = '2026-07'
GROUP BY usuarios.nome
ORDER BY total_julho DESC;

/* Gasto médio por pessoa */
SELECT
    usuarios.nome,
    AVG(gastos.valor) AS gasto_medio
FROM gastos
JOIN usuarios ON gastos.usuario_id = usuarios.id
GROUP BY usuarios.nome;
