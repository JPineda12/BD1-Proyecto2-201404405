-- DROP DATABASE BD1_Proyecto2;
CREATE DATABASE BD1_Proyecto2;
USE BD1_Proyecto2;

CREATE TABLE Pais(
idPais INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
pais VARCHAR(100)
);



CREATE TABLE Region(
idRegion INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
region VARCHAR(100)
);

CREATE TABLE Pais_Region(
idPaisRegion INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
Pais_idPais INT,
Region_idRegion INT,
FOREIGN KEY(Pais_idPais) REFERENCES Pais(idPais),
FOREIGN KEY(Region_idRegion) REFERENCES Region(idRegion)
);


CREATE TABLE Departamento(
idDepartamento INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
departamento VARCHAR(100),
PaisRegion_idPaisRegion INT,
FOREIGN KEY(PaisRegion_idPaisRegion) REFERENCES Pais_Region(idPaisRegion)
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

CREATE TABLE Sexo(
idSexo INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
sexo VARCHAR(10)
);

CREATE TABLE Escolaridad(
idEscolaridad INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
escolaridad VARCHAR(50)
);

CREATE TABLE Educacion(
idEducacion INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
educacion VARCHAR(20)
);

CREATE TABLE Educacion_Escolaridad(
idEducacionEscolaridad INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
cantidad INT,
Escolaridad_idEscolaridad INT,
Educacion_idEducacion INT,
FOREIGN KEY(Escolaridad_idEscolaridad) REFERENCES Escolaridad(idEscolaridad),
FOREIGN KEY(Educacion_idEducacion) REFERENCES Educacion(idEducacion)
);

CREATE TABLE Partido_Politico(
idPartido INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
partido VARCHAR(100),
acronimo VARCHAR(10)
);
 
CREATE TABLE Eleccion(
idEleccion INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
eleccion VARCHAR(45),
Municipio_idMunicipio INT,
Partido_idPartido INT,
FOREIGN KEY(Municipio_idMunicipio) REFERENCES Municipio(idMunicipio),
FOREIGN KEY(Partido_idPartido) REFERENCES Partido_Politico(idPartido)
);
CREATE TABLE Votos(
idVotos INT,
cantidad INT,
Eleccion_idEleccion INT,
Raza_idRaza INT,
Sexo_idSexo INT,
EducacionEscolaridad_idEducacionEscolaridad INT,
FOREIGN KEY(Eleccion_idEleccion) REFERENCES Eleccion(idEleccion),
FOREIGN KEY(Raza_idRaza) REFERENCES Raza(idRaza),
FOREIGN KEY(EducacionEscolaridad_idEducacionEscolaridad) REFERENCES Educacion_Escolaridad(idEducacionEscolaridad)
);
/*
DROP TABLE Votos;
DROP TABLE Educacion_Escolaridad;
DROP TABLE Educacion;
DROP TABLE Escolaridad;
DROP TABLE Sexo;
DROP TABLE Raza; 
DROP TABLE Eleccion;
DROP TABLE Partido_Politico;
DROP TABLE Municipio;
DROP TABLE Departamento;
DROP TABLE Pais_Region;
DROP TABLE Region;

DROP TABLE Pais;
*/