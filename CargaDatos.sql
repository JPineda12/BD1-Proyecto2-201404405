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
Sexo2 VARCHAR(100),
Raza2 VARCHAR(100),
Primaria INT,
Nivel_Medio INT,
Universitarios INT
);
SELECT * FROM Temporal;
ALTER DATABASE BD1_Proyecto2 CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE Temporal CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE Region CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE Pais CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE Partido_Politico CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE Municipio CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE Eleccion CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE Departamento CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE Votos CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;


INSERT INTO Pais(pais)
SELECT DISTINCT T.Pais FROM Temporal T;

INSERT INTO Region(region, Pais_idPais)
SELECT DISTINCT T.Region, P.idPais FROM Temporal T, Pais P
WHERE T.pais = P.pais;


INSERT INTO Departamento(departamento, Region_idRegion)
SELECT DISTINCT T.Depto, R.idRegion FROM Temporal T, Region R, Pais P
WHERE T.Region = R.Region
AND P.pais = T.Pais
AND R.Pais_idPais = P.idPais;


INSERT INTO Municipio(municipio, Departamento_idDepartamento)
SELECT DISTINCT T.Municipio, D.idDepartamento FROM Temporal T, Departamento D
WHERE T.depto = D.departamento;
SELECT * FROM Municipio
ORDER BY municipio asc;

INSERT INTO Raza(raza)
SELECT DISTINCT T.Raza FROM Temporal T;

INSERT INTO Partido_Politico(partido, acronimo)
SELECT DISTINCT T.nombre_partido, T.partido FROM Temporal T, Pais P
WHERE T.Pais = P.pais;

INSERT INTO Eleccion(eleccion, anho, Municipio_idMunicipio)
SELECT DISTINCT T.Nombre_Eleccion, T.anho_eleccion, M.idMunicipio
FROM Temporal T, Municipio M, Pais P, Departamento D, Region R
WHERE T.Municipio = M.Municipio
AND D.departamento = T.Depto
AND R.region = T.Region
AND P.pais = T.pais
AND P.idPais = R.Pais_idPais
AND D.Region_idRegion = R.idRegion
AND M.Departamento_idDepartamento = D.idDepartamento;


INSERT INTO Sexo(sexo)
SELECT DISTINCT T.sexo FROM Temporal T;



INSERT INTO Votos(Sexo_idSexo, analfabeta, alfabeta, primaria, medio, universitario, 
					Raza_idRaza, Eleccion_idEleccion, Partido_idPartido, Municipio_idMunicipio)
SELECT DISTINCT S.idSexo, T.analfabetos, T.alfabetos, T.primaria, 
				T.nivel_medio, T.universitarios, R.idRaza, E.idEleccion,
                P.idPartido, M.idMunicipio
FROM Temporal T, Raza R, Eleccion E, Partido_Politico P, Municipio M, Sexo S, Departamento D, Region RE, Pais PA
WHERE PA.pais = T.pais
AND RE.region = T.Region
AND D.departamento = T.Depto
AND M.municipio = T.municipio
AND T.Anho_eleccion = E.anho
AND E.Municipio_idMunicipio = M.idMunicipio
AND T.raza = R.raza
AND S.sexo = T.sexo
AND P.partido = T.nombre_partido
AND P.acronimo = T.partido
AND PA.idPais = RE.Pais_idPais
AND RE.idRegion = D.Region_idRegion
AND M.Departamento_idDepartamento = D.idDepartamento
AND E.Municipio_idMunicipio = M.idMunicipio;



