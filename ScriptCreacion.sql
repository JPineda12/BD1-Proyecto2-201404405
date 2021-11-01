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

CREATE TABLE Eleccion(
idEleccion INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
eleccion VARCHAR(45),
Municipio_idMunicipio INT,
FOREIGN KEY(Municipio_idMunicipio) REFERENCES Municipio(idMunicipio)
);

CREATE TABLE Partido_Politico(
idPartido INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
partido VARCHAR(100)
);

CREATE TABLE Puesto(
idPuesto INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
puesto VARCHAR(50),
Partido_idPartido INT,
FOREIGN KEY(Partido_idPartido) REFERENCES Partido_Politico(idPartido)
);

CREATE TABLE Detalle_Eleccion(
idDetalle_Eleccion INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
Puesto_idPuesto INT,
Eleccion_idEleccion INT,
FOREIGN KEY(Puesto_idPuesto) REFERENCES Puesto(idPuesto),
FOREIGN KEY(Eleccion_idEleccion) REFERENCES Eleccion(idEleccion)
);

CREATE TABLE Votos(
idVotos INT,
cantidad INT,
Detalle_idEleccion INT,
Educacion_idEducacion INT,
Raza_idRaza INT,
Sexo_idSexo INT,
Escolaridad_idEscolaridad INT,
FOREIGN KEY(Detalle_idEleccion) REFERENCES Detalle_Eleccion(idDetalle_Eleccion),
FOREIGN KEY(Educacion_idEducacion) REFERENCES Educacion(idEducacion),
FOREIGN KEY(Raza_idRaza) REFERENCES Raza(idRaza),
FOREIGN KEY(Escolaridad_idEscolaridad) REFERENCES Escolaridad(idEscolaridad)

);
