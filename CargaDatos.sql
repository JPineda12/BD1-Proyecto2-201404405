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

INSERT INTO Region(region, Pais_idPais)
SELECT DISTINCT T.Region, P.idPais FROM Temporal T, Pais P 
WHERE P.Pais = T.Pais;

INSERT INTO Departamento(departamento, Region_idRegion)
SELECT DISTINCT T.Depto, R.idRegion FROM Temporal T, Region R
WHERE T.Region = R.Region;

INSERT INTO Municipio(municipio, Departamento_idDepartamento)
SELECT DISTINCT T.Municipio, D.idDepartamento FROM Temporal T, Departamento D
WHERE T.Municipio = D.departamento;