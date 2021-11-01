USE BD1_Proyecto2;

CREATE TABLE Temporal(
Nombre_Eleccion VARCHAR(100),
Anho_Eleccion INT,
Pais VARCHAR(100),
Region VARCHAR(100),
Depto VARCHAR(100),
Municipio VARCHAR(100),
Partido VARCHAR(100),
Nombre_Partido VARCHAR(100),
Sexo VARCHAR(100),
Raza VARCHAR(100),
Analfabetos INT,
Alfabetos INT,
Sexo VARCHAR(100),
Raza VARCHAR(100),
Primaria INT,
Nivel_Medio INT,
Universitarios INT
);
SELECT * FROM Temporal;

INSERT INTO Pais(pais)
SELECT DISTINCT T.Pais FROM Temporal t;

INSERT INTO Region(region)
SELECT DISTINCT T.Region FROM Temporal T;

INSERT INTO Pais_Region(Pais_idPais, Region_idRegion)
SELECT DISTINCT P.idPais, R.idRegion FROM Temporal T, Pais P, Region R 
WHERE P.pais = T.pais
AND T.Region = R.region;



INSERT INTO Departamento(departamento, PaisRegion_idPaisRegion)
SELECT DISTINCT T.Depto, PR.idPaisRegion FROM Temporal T, Region R, Pais P, Pais_Region PR
WHERE T.Region = R.Region
AND P.pais = T.Pais
AND PR.Pais_idPais = P.idPais
AND PR.Region_idRegion = R.idRegion;


INSERT INTO Municipio(municipio, Departamento_idDepartamento)
SELECT DISTINCT T.Municipio, D.idDepartamento FROM Temporal T, Departamento D
WHERE T.depto = D.departamento;

INSERT INTO Raza(raza)
SELECT DISTINCT T.Raza FROM Temporal T;

INSERT INTO Sexo(sexo)
SELECT DISTINCT T.sexo FROM TEMPORAL T;

INSERT INTO Escolaridad(escolaridad)
VALUES('PRIMARIA');

INSERT INTO Escolaridad(escolaridad)
VALUES('NIVEL MEDIO');

INSERT INTO Escolaridad(escolaridad)
VALUES('UNIVERSITARIOS');

INSERT INTO Educacion(educacion)
VALUES('ANALFABETOS');

INSERT INTO Educacion(educacion)
VALUES('ALFABETOS');

INSERT INTO Partido_Politico(partido, acronimo)
SELECT DISTINCT T.nombre_partido, T.partido FROM TEMPORAL T;

INSERT INTO Eleccion(eleccion, Municipio_idMunicipio, Partido_idPartido)
SELECT DISTINCT T.Nombre_Eleccion, M.idMunicipio, P.idPartido
FROM Temporal T, Municipio M, Partido_politico P
WHERE T.Municipio = M.municipio
AND P.partido = T.nombre_partido;

INSERT INTO Educacion_Escolaridad(cantidad, Escolaridad_idEscolaridad, Educacion_idEducacion)
SELECT DISTINCT T.Analfabetos, NULL, 1
FROM Temporal T;

INSERT INTO Educacion_Escolaridad(cantidad, Escolaridad_idEscolaridad, Educacion_idEducacion)
SELECT DISTINCT T.Primaria, 1, 2
FROM Temporal T;

INSERT INTO Educacion_Escolaridad(cantidad, Escolaridad_idEscolaridad, Educacion_idEducacion)
SELECT DISTINCT T.Nivel_Medio, 2, 2
FROM Temporal T;

INSERT INTO Educacion_Escolaridad(cantidad, Escolaridad_idEscolaridad, Educacion_idEducacion)
SELECT DISTINCT T.Universitarios, 3, 2
FROM Temporal T;

INSERT INTO Votos(cantidad, Eleccion_idEleccion, Educacion_idEducacion, Raza_idRaza, Sexo_idSexo, Escolaridad_idEscolaridad)
SELECT DISTINCT T.


