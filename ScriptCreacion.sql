-- DROP DATABASE BD1_Proyecto2;
CREATE DATABASE BD1_Proyecto2;
USE BD1_Proyecto2;

CREATE TABLE Pais(
idPais INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
pais VARCHAR(100)
);



CREATE TABLE Region(
idRegion INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
region VARCHAR(100),
Pais_idPais INT,
FOREIGN KEY(Pais_idPais) REFERENCES Pais(idPais)
);


CREATE TABLE Departamento(
idDepartamento INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
departamento VARCHAR(100),
Region_idRegion INT,
FOREIGN KEY(Region_idRegion) REFERENCES Region(idRegion)
);

CREATE TABLE Municipio(
idMunicipio INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
municipio VARCHAR(100),
Departamento_idDepartamento INT,
FOREIGN KEY(Departamento_idDepartamento) REFERENCES Departamento(idDepartamento)
);

CREATE TABLE Raza(
idRaza INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
raza VARCHAR(50)
);

CREATE TABLE Partido_Politico(
idPartido INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
partido VARCHAR(100),
acronimo VARCHAR(10)
);
 
CREATE TABLE Eleccion(
idEleccion INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
eleccion VARCHAR(45),
anho YEAR,
Municipio_idMunicipio INT,
FOREIGN KEY(Municipio_idMunicipio) REFERENCES Municipio(idMunicipio)
);

CREATE TABLE Votos(
idVotos INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
sexo VARCHAR(10),
analfabeta INT,
alfabeta INT,
primaria INT,
medio INT,
universitario INT,
Eleccion_idEleccion INT,
Raza_idRaza INT,
Partido_idPartido INT,
FOREIGN KEY(Eleccion_idEleccion) REFERENCES Eleccion(idEleccion),
FOREIGN KEY(Raza_idRaza) REFERENCES Raza(idRaza),
FOREIGN KEY(Partido_idPartido) REFERENCES Partido_Politico(idPartido),
);
/*
DROP TABLE Votos;
DROP TABLE Raza; 
DROP TABLE Eleccion;
DROP TABLE Partido_Politico;
DROP TABLE Municipio;
DROP TABLE Departamento;
DROP TABLE Region;

DROP TABLE Pais;
*/