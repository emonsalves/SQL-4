---------------------------------------------------------------------------------------------------------------------
-- Primer paso crear DB
---------------------------------------------------------------------------------------------------------------------
CREATE DATABASE Emonsalves_prueba_final;

---------------------------------------------------------------------------------------------------------------------
--- 1: Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), 
--- respeta las claves primarias, foráneas y tipos de datos. 
"https://prnt.sc/EbLv6eW8SVOg"
---------------------------------------------------------------------------------------------------------------------
CREATE TABLE peliculas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255),
    anno INTEGER
);

CREATE TABLE tags (id SERIAL PRIMARY KEY, tag VARCHAR(32));

CREATE TABLE peliculas_tags (
    id SERIAL PRIMARY KEY,
    pelicula_id INTEGER,
    tag_id INTEGER,
    FOREIGN KEY (pelicula_id) REFERENCES peliculas (id),
    FOREIGN KEY (tag_id) REFERENCES tags (id)
);

---------------------------------------------------------------------------------------------------------------------
--- 2: Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados,
--- la segunda película debe tener dos tags asociados.
---------------------------------------------------------------------------------------------------------------------
--- Peliculas :
---------------------------------------------------------------------------------------------------------------------
INSERT INTO
    peliculas (nombre, anno)
VALUES
    ('Avatar 2', 2022),
    ('The Ugly Truth', 2009),
    ('V de Venganza', 2005),
    ('Top Gun', 1986),
    ('Saw 4', 2007);

---------------------------------------------------------------------------------------------------------------------
--- Tags :
---------------------------------------------------------------------------------------------------------------------
INSERT INTO
    tags (tag)
VALUES
    ('Suspenso'),
    ('Fantasia'),
    ('Humor'),
    ('Accion'),
    ('Romance');

---------------------------------------------------------------------------------------------------------------------
--- Tabla Paso :
---------------------------------------------------------------------------------------------------------------------
INSERT INTO
    peliculas_tags (pelicula_id, tag_id)
VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 1),
    (2, 2);

---------------------------------------------------------------------------------------------------------------------
--- 3: Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
-- mostrar 0.
---------------------------------------------------------------------------------------------------------------------
SELECT
    peliculas.nombre,
    COUNT(peliculas_tags.tag_id) as "Conteo"
FROM
    peliculas
    LEFT JOIN peliculas_tags ON peliculas.id = peliculas_tags.pelicula_id
GROUP by
    peliculas.nombre
ORDER BY
    COUNT(peliculas_tags.tag_id) DESC;

---------------------------------------------------------------------------------------------------------------------
--- 4: Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de
--- datos.
"https://prnt.sc/HIgVwLivCNHn"
---------------------------------------------------------------------------------------------------------------------
--- preguntas
---------------------------------------------------------------------------------------------------------------------
CREATE TABLE preguntas (
    id SERIAL PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_correcta VARCHAR
);

---------------------------------------------------------------------------------------------------------------------
--- usuarios
---------------------------------------------------------------------------------------------------------------------
CREATE TABLE usuarios(
    id SERIAL PRIMARY key,
    nombre VARCHAR(255),
    edad INTEGER
);

---------------------------------------------------------------------------------------------------------------------
--- respuestas
---------------------------------------------------------------------------------------------------------------------
CREATE TABLE respuestas (
    id SERIAL PRIMARY KEY,
    respuesta VARCHAR(255),
    usuario_id INTEGER,
    pregunta_id INTEGER,
    FOREIGN KEY (usuario_id) REFERENCES usuarios (id),
    FOREIGN KEY (pregunta_id) REFERENCES preguntas (id)
);

---------------------------------------------------------------------------------------------------------------------
--- 5: Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada
--- dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada
--- correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas.
---------------------------------------------------------------------------------------------------------------------
--- carga usuarios 
---------------------------------------------------------------------------------------------------------------------
INSERT INTO
    usuarios (nombre, edad)
VALUES
    ('Claudio', 29),
    ('Yenni', 31),
    ('Fabian', 32),
    ('Luis', 27),
    ('Carla', 26);

---------------------------------------------------------------------------------------------------------------------
--- carga preguntas
---------------------------------------------------------------------------------------------------------------------
INSERT INTO
    preguntas (pregunta, respuesta_correcta)
VALUES
    ('En que año estamos?', '2022'),
    ('De que color era el caballo blanco de Napoleon?','blanco'),
    ('Que tocaba Lolo?', 'guitarra'),
    ('donde se esta llevando acabo el mundial?','Qatar'),
    ('cuando se celebran fiestas patrias?','18 Septiembre');

---------------------------------------------------------------------------------------------------------------------
--- carga respuestas
---------------------------------------------------------------------------------------------------------------------
INSERT INTO
    respuestas (respuesta, usuario_id, pregunta_id)
VALUES
    ('2022', 1, 1),
    ('2022', 2, 1),
    ('blanco', 3, 2),
    ('chile', 4, 4),
    ('4 julio', 5, 5);

---------------------------------------------------------------------------------------------------------------------
--- 6: Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
--- pregunta)
---------------------------------------------------------------------------------------------------------------------
SELECT
    usuarios.nombre,
    COUNT(preguntas.respuesta_correcta) AS "correctas"
FROM
    preguntas
    RIGHT JOIN respuestas ON respuestas.respuesta = preguntas.respuesta_correcta
    JOIN usuarios ON usuarios.id = respuestas.usuario_id
GROUP BY
    usuario_id,
    usuarios.nombre
ORDER BY
    correctas DESC;

---------------------------------------------------------------------------------------------------------------------
--- 7: Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la
--- respuesta correcta.
---------------------------------------------------------------------------------------------------------------------
SELECT
    preguntas.pregunta,
    COUNT(respuestas.respuesta) AS correctas
FROM
    respuestas
    RIGHT JOIN preguntas ON preguntas.respuesta_correcta = respuestas.respuesta
GROUP BY
    preguntas.id
ORDER BY
    preguntas.id;

---------------------------------------------------------------------------------------------------------------------
--- 8: Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el
-- primer usuario para probar la implementación.
---------------------------------------------------------------------------------------------------------------------
ALTER TABLE
    respuestas DROP CONSTRAINT respuestas_usuario_id_fkey,
ADD
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE;

---------------------------------------------------------------------------------------------------------------------
--- 9: Crea una restricción que impida insertar usuarios menores de 18 años en la base de
--- datos.
---------------------------------------------------------------------------------------------------------------------
ALTER TABLE
    usuarios
ADD
    CHECK (edad >= 18);

---------------------------------------------------------------------------------------------------------------------
--- 10: Altera la tabla existente de usuarios agregando el campo email con la restricción de
--- único.
---------------------------------------------------------------------------------------------------------------------
ALTER TABLE
    usuarios
ADD
    email VARCHAR UNIQUE;

---------------------------------------------------------------------------------------------------------------------
