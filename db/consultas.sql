SELECT * FROM USERS;
SELECT * FROM GALERIAS;

SELECT * FROM USERS WHERE usu_email = "dan@hotmail.com" and usu_pass = "dan12345";

SELECT * FROM USER WHERE usu_email = usu_emailSUPERMERCADOSUSERS;
UPDATE USERS
SET usu_estado = 'Activo', super_id = 1, gal_id = 1, com_id = 1
WHERE usu_id = 2;


SELECT * FROM NUTRIENTES;

-- mostrar el aporte de potasio del banano

SELECT n.nut_aporte
FROM frutas f INNER JOIN NUTRIENTES n
ON  f.fru_id = n.fru_id
WHERE f.fru_nombre = 'banano';

-- muestra todas las frutas de la base de datos

SELECT * FROM DATOSGAL;
SELECT * FROM GALERIAS;

SELECT * FROM COMUNAS;
SELECT * FROM DATOSCOM;

-- muestra todas las galerias que tiene asignadas el usuario con ese email

SELECT g.gal_nombre
 FROM USERS u INNER JOIN Galerias g
 ON u.gal_id = g.gal_id
WHERE u.usu_email = 'grace@hotmail.com';

-- insertar datos de la galeria

	-- id de la fruta por el nombre
    
    SELECT fru_id
    FROM FRUTAS
    WHERE fru_nombre = 'nombre del comboBox';
    
INSERT INTO GALERIAS (gal_id, gal_nombre, fru_id, gal_ingresa, gal_desperdicia)
VALUES ('Cardinal', 'Tom B. Erichsen', 'Skagen 21', 'Stavanger', '4006', 'Norway');

SELECT * FROM NUTRIENTES;
SELECT * FROM DATOSGAL;
SELECT * FROM GALERIAS;
SELECT * FROM COMUNAS;
SELECT * FROM DATOSCOM;
ALTER TABLE REFERENCIAS AUTO_INCREMENT=1;


SELECT * FROM NUTRIENTES;
SELECT * FROM DATOSNUT;
SELECT * FROM CARENCIAS;


-- MOSTRAR CANTIDAD  DE NIÑOS CON BAJO POTASIO
SELECT car_numpersonas
FROM CARENCIAS car INNER JOIN NUTRIENTES nut
ON car.nut_id = nut.nut_id
WHERE tipo_persona = "niños";

-- SUMA DE TODOS LOS NINOS CON BAJO POTASIO
SELECT sum(car_numpersonas)
FROM CARENCIAS car INNER JOIN NUTRIENTES nut
ON car.nut_id = nut.nut_id
WHERE tipo_persona = "niños";

SELECT * FROM PERSONAS;
SELECT * FROM REFERENCIAS;
SELECT * FROM USERS;
SELECT * FROM FRUTAS;
SELECT * FROM CARENCIAS;
SELECT * FROM NUTRIENTES;

-- Obtener el porcentaje de carencia del tipo de personas

-- Si son niños y estan con carencia de potasio
SELECT car_porcentaje
FROM CARENCIAS car INNER JOIN NUTRIENTES nut
ON car.nut_id = nut.nut_id
WHERE nut_nombre = 'magnesio' and   tipo_persona = (SELECT per_id
										                         FROM PERSONAS
                                                                 WHERE per_id = 1);
                                                                 
-- Obtiene la cantidad al dia de carencia en un elemento especifico de 150 niños
-- potasio en niños debe ser de 3800gr al dia

SELECT (((car.car_porcentaje * ref.ref_referencia) / 100)  * car.car_numpersonas)
FROM CARENCIAS as car 
INNER JOIN REFERENCIAS as ref on ref.per_id = car.tipo_persona and ref.nut_id = car.nut_id
WHERE car.nut_id = (SELECT nut_id FROM NUTRIENTES WHERE nut_nombre = 'potasio');

-- Se obtiene todas las carencias de la la comuna actual
SELECT *
FROM CARENCIAS
WHERE com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = 'comuna1')

-- Se obtiene el valor de las carencias de la comuna actual para los niños

SELECT (((car.car_porcentaje * ref.ref_referencia) / 100)  * car.car_numpersonas) as Total, 
(SELECT nut_nombre FROM NUTRIENTES WHERE nut_id =  car.nut_id ) as Nutriente
FROM CARENCIAS as car 
INNER JOIN REFERENCIAS as ref on ref.per_id = car.tipo_persona and ref.nut_id = car.nut_id
WHERE car.tipo_persona = (SELECT per_id FROM PERSONAS WHERE per_tipo = 'niño') 
			 and car.com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = 'comuna1');
             
-- Se obtiene el valor de las carencias de la comuna actual para los ancianos

SELECT (((car.car_porcentaje * ref.ref_referencia) / 100)  * car.car_numpersonas) as Total, 
(SELECT nut_nombre FROM NUTRIENTES WHERE nut_id =  car.nut_id ) as Nutriente
FROM CARENCIAS as car 
INNER JOIN REFERENCIAS as ref on ref.per_id = car.tipo_persona and ref.nut_id = car.nut_id
WHERE car.tipo_persona = (SELECT per_id FROM PERSONAS WHERE per_tipo = 'anciano') 
			 and car.com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = 'comuna1');




								










































