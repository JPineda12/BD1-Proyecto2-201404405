USE BD1_Proyecto2;

/* CONSULTA 1:
		Desplegar para cada elección el país y el partido político que obtuvo mayor
		porcentaje de votos en su país. Debe desplegar el nombre de la elección, el
		año de la elección, el país, el nombre del partido político y el porcentaje que
		obtuvo de votos en su país.
*/
SELECT A.eleccion, A.anho, A.pais, D.partido, CONCAT(ROUND(A.total_votos/C.votos*100,4), '%') AS porcentaje
FROM ( SELECT B.nombre AS eleccion, B.anho AS anho, B.pais AS pais, MAX(B.votos) as total_votos
	FROM (SELECT c.eleccion as nombre, c.anho AS anho, g.pais as pais, a.partido as partido, SUM(t1.alfabeta + t1.analfabeta) as votos
			FROM Votos t1
            INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
            INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
            INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
            INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
            INNER JOIN Region f on f.idRegion = e.Region_idRegion
            INNER JOIN Pais g on g.idPais = f.Pais_idPais
            GROUP BY c.eleccion, c.anho, g.pais, a.partido
            ORDER BY g.pais) AS B
		GROUP BY B.nombre, B.anho, B.pais) AS A
	INNER JOIN (SELECT c.eleccion as nombre, c.anho as anho, g.pais as pais, SUM(t1.alfabeta + t1.analfabeta) as votos
					FROM Votos t1
					INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
                    INNER JOIN Eleccion c ON c.idEleccion = t1.Eleccion_idEleccion
                    INNER JOIN Municipio d ON d.idMunicipio = c.Municipio_idMunicipio
                    INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
					INNER JOIN Region f on f.idRegion = e.Region_idRegion
					INNER JOIN Pais g on g.idPais = f.Pais_idPais                    
                    GROUP BY c.eleccion, c.anho, g.pais) AS C
INNER JOIN 
(SELECT c.eleccion as nombre, c.anho as anho, g.pais as pais, a.partido as partido, SUM(t1.alfabeta + t1.analfabeta) as votos
		FROM Votos t1
					INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
                    INNER JOIN Eleccion c ON c.idEleccion = t1.Eleccion_idEleccion
                    INNER JOIN Municipio d ON d.idMunicipio = c.Municipio_idMunicipio
                    INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
					INNER JOIN Region f on f.idRegion = e.Region_idRegion
					INNER JOIN Pais g on g.idPais = f.Pais_idPais 
                    GROUP BY c.eleccion, c.anho, g.pais, a.partido
                    ORDER BY g.pais) as D
ON C.nombre = A.eleccion 
AND A.anho = C.anho
AND A.pais = C.pais
AND A.eleccion = D.nombre
AND A.anho = D.anho
AND A.pais = D.pais
AND A.total_votos = D.votos;


/* CONSULTA 2:
		. Desplegar total de votos y porcentaje de votos de mujeres por departamento
		y país. El ciento por ciento es el total de votos de mujeres por país. (Tip:
		Todos los porcentajes por departamento de un país deben sumar el 100%)
*/
SELECT B.pais, B.depto AS departamento, B.votos AS Total_Votos, CONCAT(ROUND(B.votos/A.votos*100,4), '%') AS Porcentaje
FROM ( SELECT SUM(t1.alfabeta + t1.analfabeta) AS votos, g.pais as Pais
		FROM Votos t1
            INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
            INNER JOIN Sexo b on b.idSexo = t1.Sexo_idSexo
            INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
            INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
            INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
            INNER JOIN Region f on f.idRegion = e.Region_idRegion
            INNER JOIN Pais g on g.idPais = f.Pais_idPais
            WHERE LOWER(b.sexo) = 'mujeres'
            GROUP BY g.pais) AS A
	INNER JOIN 
			(SELECT SUM(t1.alfabeta + t1.analfabeta) AS votos, g.pais as Pais, e.departamento as depto
			FROM Votos t1
				INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
				INNER JOIN Sexo b on b.idSexo = t1.Sexo_idSexo
				INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
				INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
				INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
				INNER JOIN Region f on f.idRegion = e.Region_idRegion
				INNER JOIN Pais g on g.idPais = f.Pais_idPais
				WHERE LOWER(b.sexo) = 'mujeres'
				GROUP BY g.pais, e.departamento) AS B
ON A.pais = B.pais
ORDER BY A.pais, B.depto;              


/* CONSULTA 3:
		Desplegar el nombre del país, nombre del partido político y número de
			alcaldías de los partidos políticos que ganaron más alcaldías por país
*/

WITH FAT AS(
	WITH ganadores AS(SELECT g1.pais as Pais, a1.partido AS Partido, d1.Municipio as Muni
				FROM Votos VotosB
				INNER JOIN Partido_Politico a1 ON a1.idPartido = VotosB.Partido_idPartido
				INNER JOIN Eleccion c1 on c1.idEleccion = VotosB.Eleccion_idEleccion
				INNER JOIN Municipio d1 on d1.idMunicipio = c1.Municipio_idMunicipio
				INNER JOIN Departamento e1 on e1.idDepartamento = d1.Departamento_idDepartamento
				INNER JOIN Region f1 on f1.idRegion = e1.Region_idRegion
				INNER JOIN Pais g1 on g1.idPais = f1.Pais_idPais
                GROUP BY c1.anho , g1.pais, a1.partido, f1.idRegion, e1.idDepartamento, d1.idMunicipio
                HAVING (SELECT SUM(VotosA.alfabeta + VotosA.analfabeta) AS total_sum
					FROM Votos VotosA
					INNER JOIN Partido_Politico a ON a.idPartido = VotosA.Partido_idPartido
					INNER JOIN Eleccion c on c.idEleccion = VotosA.Eleccion_idEleccion
					INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
					INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
					INNER JOIN Region f on f.idRegion = e.Region_idRegion
					INNER JOIN Pais g on g.idPais = f.Pais_idPais
                    WHERE d.municipio = d1.municipio 
                    AND g.pais = g1.pais
                    GROUP BY c.anho, g.pais, a.partido, f.idRegion, e.idDepartamento, d.idMunicipio
                    ORDER BY total_sum DESC LIMIT 1 ) = SUM(VotosB.alfabeta + VotosB.analfabeta))
				SELECT G.Pais, G.Partido, COUNT(*) AS Conteo FROM ganadores G
                GROUP BY G.Pais, G.Partido)
			SELECT FATD.Pais, (SELECT S.partido FROM FAT S WHERE S.Conteo = MAX(FATD.Conteo) AND S.Pais = FATD.Pais) AS Partido,
			MAX(FATD.Conteo) AS Alcaldias
			FROM FAT AS FATD
            GROUP BY FATD.Pais;

/* CONSULTA 4:
		Desplegar todas las regiones por país en las que predomina la raza indígena.
		Es decir, hay más votos que las otras razas.
*/
SELECT A.pais as Pais, A.region as Region, A.Votos as Votos_Indigenas
		FROM (SELECT b.raza, f.idRegion, f.region, g.idPais, g.pais, SUM(t1.analfabeta + t1.alfabeta) as Votos
				FROM Votos t1
					INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
                    INNER JOIN Raza b ON b.idRaza = t1.Raza_idRaza
					INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
					INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
					INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
					INNER JOIN Region f on f.idRegion = e.Region_idRegion
					INNER JOIN Pais g on g.idPais = f.Pais_idPais
                    WHERE UPPER(b.raza) = 'INDIGENAS'
                    GROUP BY b.raza, f.region, g.pais) A
 INNER JOIN
			(SELECT b.raza, f.idRegion, f.region, g.idPais, g.pais, SUM(t1.analfabeta + t1.alfabeta) as Votos
				FROM Votos t1
					INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
                    INNER JOIN Raza b ON b.idRaza = t1.Raza_idRaza
					INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
					INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
					INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
					INNER JOIN Region f on f.idRegion = e.Region_idRegion
					INNER JOIN Pais g on g.idPais = f.Pais_idPais
                    WHERE UPPER(b.raza) = 'GARIFUNAS'
                    GROUP BY b.raza, f.region, g.pais) B
    ON A.idRegion = B.idRegion
    AND A.idPais = B.idPais                    
INNER JOIN (SELECT b.raza, f.idRegion, f.region, g.idPais, g.Pais, SUM(t1.analfabeta + t1.alfabeta) as Votos
				FROM Votos t1
					INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
                    INNER JOIN Raza b ON b.idRaza = t1.Raza_idRaza
					INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
					INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
					INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
					INNER JOIN Region f on f.idRegion = e.Region_idRegion
					INNER JOIN Pais g on g.idPais = f.Pais_idPais
                    WHERE UPPER(b.raza) = 'LADINOS'
					GROUP BY b.raza, f.region, g.pais) C
        ON A.idRegion = C.idregion
        AND A.idPais = C.idPais
WHERE A.Votos > B.Votos
AND A.Votos > C.Votos
ORDER BY A.pais, A.region;

                
                
/* CONSULTA 5:
		Desplegar el nombre del país, el departamento, el municipio y la cantidad de
		votos universitarios de todos aquellos municipios en donde la cantidad de
		votos de universitarios sea mayor que el 25% de votos de primaria y menor
		que el 30% de votos de nivel medio. Ordene sus resultados de mayor a
		menor.
*/             
SELECT A.pais, A.region, A.departamento, A.municipio, A.Votos_U, (25 * B.Votos_P/100) as Primaria, 30 * B.Votos_P/100 as Medio
		FROM 	(SELECT g.pais, f.idRegion, f.Region, e.idDepartamento, e.departamento, d.idMunicipio, d.municipio, SUM(t1.universitario) as Votos_U
					FROM Votos t1
					INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
					INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
					INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
					INNER JOIN Region f on f.idRegion = e.Region_idRegion
					INNER JOIN Pais g on g.idPais = f.Pais_idPais
                    GROUP BY g.pais,f.region, e.departamento , d.municipio) A
	INNER JOIN
				(SELECT g.pais, f.idRegion, f.Region, e.idDepartamento, e.departamento, d.idMunicipio, d.municipio, SUM(t1.primaria) as Votos_P
				FROM Votos t1
					INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
					INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
					INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
					INNER JOIN Region f on f.idRegion = e.Region_idRegion
					INNER JOIN Pais g on g.idPais = f.Pais_idPais
                    GROUP BY g.pais,f.region, e.departamento , d.municipio) B
	ON A.pais = B.pais
    AND A.idRegion = B.idRegion
    AND A.idDepartamento = B.idDepartamento
    AND A.idMunicipio = B.idMunicipio
INNER JOIN 
				(SELECT g.pais, f.idRegion, f.Region, e.idDepartamento, e.departamento, d.idMunicipio, d.municipio, SUM(t1.medio) as Votos_M
								FROM Votos t1
									INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
									INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
									INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
									INNER JOIN Region f on f.idRegion = e.Region_idRegion
									INNER JOIN Pais g on g.idPais = f.Pais_idPais
									GROUP BY g.pais,f.region, e.departamento , d.municipio) C
	ON A.pais = C.pais
    AND A.idRegion = C.idRegion
    AND A.idDepartamento = C.idDepartamento
    AND A.idMunicipio = C.idMunicipio
	AND A.Votos_U > (25 * B.Votos_P/100)
    AND A.Votos_U < (30 * C.Votos_M/100);



/* CONSULTA 6:
		Desplegar el porcentaje de mujeres universitarias y hombres universitarios
		que votaron por departamento, donde las mujeres universitarias que votaron
		fueron más que los hombres universitarios que votaron.

*/
SELECT A.pais as Pais, A.region as Region,A.Departamento, A.Votos as Mujeres, B.Votos as Hombres, 
												CONCAT(ROUND(((A.Votos)/C.Votos_Total * 100), 4), '%') AS Porcentaje
		FROM (SELECT s.sexo, e.idDepartamento, e.departamento AS Departamento, 
				f.idRegion, f.region, g.idPais, g.Pais, SUM(t1.universitario) as Votos
				FROM Votos t1
					INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
                    INNER JOIN Sexo s ON s.idSexo = t1.Sexo_idSexo
					INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
					INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
					INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
					INNER JOIN Region f on f.idRegion = e.Region_idRegion
					INNER JOIN Pais g on g.idPais = f.Pais_idPais
                    WHERE UPPER(s.sexo) = 'MUJERES'
                    GROUP BY s.sexo, e.departamento ) A
 INNER JOIN
			(SELECT s.sexo, e.idDepartamento, e.departamento AS Departamento, 
            f.idRegion, f.region, g.idPais, g.Pais, SUM(t1.universitario) as Votos
				FROM Votos t1
					INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
                    INNER JOIN Sexo s ON s.idSexo = t1.Sexo_idSexo
					INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
					INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
					INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
					INNER JOIN Region f on f.idRegion = e.Region_idRegion
					INNER JOIN Pais g on g.idPais = f.Pais_idPais
                    WHERE UPPER(s.sexo) = 'HOMBRES'
                    GROUP BY s.sexo, e.departamento) B
	ON A.idDepartamento = B.idDepartamento
    AND A.idRegion = B.idRegion
    AND A.idPais = B.idPais                    
INNER JOIN (
				SELECT e.idDepartamento, e.departamento AS Departamento, 
							f.idRegion, f.region, g.idPais, g.Pais, SUM(t1.analfabeta + t1.alfabeta) as Votos_Total
								FROM Votos t1
									INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
									INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
									INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
									INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
									INNER JOIN Region f on f.idRegion = e.Region_idRegion
									INNER JOIN Pais g on g.idPais = f.Pais_idPais
									GROUP BY e.departamento ) C
		ON A.idDepartamento = C.idDepartamento
        AND A.idRegion = C.idregion
        AND A.idPais = C.idPais
WHERE A.Votos > B.Votos
ORDER BY A.pais, A.departamento;
                
   /* CONSULTA 7:
		Desplegar el nombre del país, la región y el promedio de votos por
		departamento. Por ejemplo: si la región tiene tres departamentos, se debe
		sumar todos los votos de la región y dividirlo dentro de tres (número de
		departamentos de la región).


*/
SELECT g1.pais as Pais, f1.region as Region, ROUND(SUM(t11.alfabeta + t11.analfabeta) / (
		SELECT COUNT(*)
			FROM (SELECT g.pais AS pais, f.region as Region, e.departamento as Depto
				FROM Votos t1
					INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
					INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
					INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
					INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
					INNER JOIN Region f on f.idRegion = e.Region_idRegion
					INNER JOIN Pais g on g.idPais = f.Pais_idPais
					WHERE g1.pais = g.pais
                    AND f1.region = f.region 
                    AND e1.departamento = e.departamento
                    GROUP BY g.pais, f.region, e.departamento) AS A), 4) As Promedio
	FROM Votos t11
			INNER JOIN Partido_Politico a1 ON a1.idPartido = t11.Partido_idPartido
			INNER JOIN Eleccion c1 on c1.idEleccion = t11.Eleccion_idEleccion
			INNER JOIN Municipio d1 on d1.idMunicipio = c1.Municipio_idMunicipio
			INNER JOIN Departamento e1 on e1.idDepartamento = d1.Departamento_idDepartamento
			INNER JOIN Region f1 on f1.idRegion = e1.Region_idRegion
			INNER JOIN Pais g1 on g1.idPais = f1.Pais_idPais
            GROUP BY g1.pais, f1.region
ORDER BY g1.pais, f1.region;




/* CONSULTA 8:
		 Desplegar el total de votos de cada nivel de escolaridad (primario, medio,
			universitario) por país, sin importar raza o sexo.


*/
SELECT g.pais as Pais, SUM(t1.universitario) as Universitario, SUM(t1.medio) as Medio, SUM(t1.primaria) as Primaria
	FROM Votos t1
	INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
	INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
	INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
	INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
	INNER JOIN Region f on f.idRegion = e.Region_idRegion
	INNER JOIN Pais g on g.idPais = f.Pais_idPais
    GROUP BY g.pais
    ORDER BY g.pais ASC;

/* CONSULTA 9:
		Desplegar el nombre del país y el porcentaje de votos por raza

*/      
SELECT A.Pais, A.Raza, CONCAT(ROUND((A.total_sum/B.total_sum * 100), 4), '%') AS Porcentaje FROM
	(SELECT g.pais As Pais, b.raza as Raza, SUM(t1.analfabeta + t1.alfabeta) AS total_sum
		FROM Votos t1
			INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
            INNER JOIN Raza b ON b.idRaza = t1.Raza_idRaza
			INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
			INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
			INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
			INNER JOIN Region f on f.idRegion = e.Region_idRegion
			INNER JOIN Pais g on g.idPais = f.Pais_idPais
			GROUP BY g.pais, b.raza
            ORDER BY g.pais DESC, b.raza DESC) AS A
INNER JOIN
	(SELECT g.pais AS Pais, SUM(t1.analfabeta + t1.alfabeta) AS total_sum
		FROM Votos t1
			INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
			INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
			INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
			INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
			INNER JOIN Region f on f.idRegion = e.Region_idRegion
			INNER JOIN Pais g on g.idPais = f.Pais_idPais        
			GROUP BY g.pais 
            ORDER BY g.pais DESC) AS B
ON A.Pais = B.Pais
ORDER BY A.Pais;

       

/* CONSULTA 10:
		Desplegar el nombre del país en el cual las elecciones han sido más
		peleadas. Para determinar esto se debe calcular la diferencia de porcentajes
		de votos entre el partido que obtuvo más votos y el partido que obtuvo menos
		votos.

*/
SELECT C.Pais, (MAX(C.total) - MIN(C.total)) AS Diferencia FROM(
	SELECT A.Pais, A.Partido, A.total_sum + B.total_sum AS total
    FROM
		(SELECT g.pais as Pais, a.partido as Partido, SUM(t1.analfabeta + t1.alfabeta) AS total_sum
			FROM Votos t1
            	INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
                INNER JOIN Raza b ON b.idRaza = t1.Raza_idRaza
				INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
				INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
				INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
				INNER JOIN Region f on f.idRegion = e.Region_idRegion
				INNER JOIN Pais g on g.idPais = f.Pais_idPais
                GROUP BY g.pais, a.partido) AS A
		INNER JOIN
			(SELECT g.pais as Pais, SUM(t1.analfabeta + t1.alfabeta) AS total_sum
            FROM Votos t1
			INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
			INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
			INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
			INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
			INNER JOIN Region f on f.idRegion = e.Region_idRegion
			INNER JOIN Pais g on g.idPais = f.Pais_idPais            
            GROUP BY g.pais) AS B
	ON A.Pais = B.Pais 
    ORDER BY A.Pais) AS C
GROUP BY C.Pais
LIMIT 1;


/* CONSULTA 11:
		 Desplegar el total de votos y el porcentaje de votos emitidos por mujeres
		indígenas alfabetas.
*/

SELECT B.Pais, B.total_sum as votos_alfabetas_mujeres, CONCAT(ROUND(B.total_sum/A.total_sum*100, 4), '%') AS porcentaje
		FROM (SELECT g.pais AS Pais, SUM(t1.alfabeta + t1.analfabeta) AS total_sum
				FROM Votos t1
				INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
				INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
				INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
				INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
				INNER JOIN Region f on f.idRegion = e.Region_idRegion
				INNER JOIN Pais g on g.idPais = f.Pais_idPais    
				GROUP BY g.pais                
				ORDER BY g.pais) A
	INNER JOIN
    (SELECT g.pais AS Pais, SUM(t1.alfabeta) AS total_sum
				FROM Votos t1
				INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
                INNER JOIN Sexo b on b.idSexo = t1.Sexo_idSexo
				INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
				INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
				INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
				INNER JOIN Region f on f.idRegion = e.Region_idRegion
				INNER JOIN Pais g on g.idPais = f.Pais_idPais 
                INNER JOIN Raza r on r.idRaza = t1.Raza_idRaza                
                WHERE UPPER(b.sexo) = 'MUJERES'
                AND UPPER(r.raza) = 'INDIGENAS'
				GROUP BY g.pais                
				ORDER BY g.pais) B
	ON A.Pais = B.Pais;


/* CONSULTA 12:
		Desplegar el nombre del país, el porcentaje de votos de ese país en el que
		han votado mayor porcentaje de analfabetas. (tip: solo desplegar un nombre
		de país, el de mayor porcentaje).

*/
SELECT B.Pais, B.total_sum as total_analfabetas, CONCAT(ROUND(B.total_sum/A.total_sum*100, 4), '%') AS porcentaje
	FROM (SELECT g.pais AS Pais, SUM(t1.alfabeta + t1.analfabeta) AS total_sum
				FROM Votos t1
				INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
				INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
				INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
				INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
				INNER JOIN Region f on f.idRegion = e.Region_idRegion
				INNER JOIN Pais g on g.idPais = f.Pais_idPais                
                GROUP BY g.pais
				ORDER BY g.pais) A
	INNER JOIN
	(SELECT g.pais AS Pais, SUM(t1.analfabeta) AS total_sum
					FROM Votos t1
					INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
					INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
					INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
					INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
					INNER JOIN Region f on f.idRegion = e.Region_idRegion
					INNER JOIN Pais g on g.idPais = f.Pais_idPais                
					GROUP BY g.pais
					ORDER BY g.pais) B
ON A.Pais = B.Pais
ORDER BY porcentaje DESC
LIMIT 1;
/* CONSULTA 13:
		Desplegar la lista de departamentos de Guatemala y número de votos
		obtenidos, para los departamentos que obtuvieron más votos que el
		departamento de Guatemala.
*/
SELECT B.Pais, B.Departamento, B.total_sum as Votos_Total, A.total_sum as total_Guatemala
	FROM (SELECT g.Pais as Pais, e.departamento AS Departamento, SUM(t1.alfabeta + t1.analfabeta) AS total_sum
				FROM Votos t1
				INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
				INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
				INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
				INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
				INNER JOIN Region f on f.idRegion = e.Region_idRegion
				INNER JOIN Pais g on g.idPais = f.Pais_idPais                
                WHERE UPPER(e.departamento) = 'GUATEMALA'
                GROUP BY e.departamento) A
	INNER JOIN
	(SELECT g.pais as Pais, e.departamento AS Departamento, SUM(t1.analfabeta + t1.alfabeta) AS total_sum
					FROM Votos t1
					INNER JOIN Partido_Politico a ON a.idPartido = t1.Partido_idPartido
					INNER JOIN Eleccion c on c.idEleccion = t1.Eleccion_idEleccion
					INNER JOIN Municipio d on d.idMunicipio = c.Municipio_idMunicipio
					INNER JOIN Departamento e on e.idDepartamento = d.Departamento_idDepartamento
					INNER JOIN Region f on f.idRegion = e.Region_idRegion
					INNER JOIN Pais g on g.idPais = f.Pais_idPais
                    WHERE UPPER(g.pais) = 'GUATEMALA'
					GROUP BY e.departamento) B
ON A.Pais= B.Pais
WHERE B.total_sum > A.total_sum
ORDER BY B.total_sum DESC;
