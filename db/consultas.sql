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
ALTER TABLE DATOSGAL AUTO_INCREMENT=1;


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
WHERE com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = 'comuna1');

-- Se obtiene el valor de las carencias de la comuna actual para los niños

SELECT (((car.car_porcentaje * ref.ref_referencia) / 100)  * car.car_numpersonas) as Total,
(SELECT nut_nombre FROM NUTRIENTES WHERE nut_id =  car.nut_id ) as Nutriente
FROM CARENCIAS as car 
INNER JOIN REFERENCIAS as ref on ref.per_id = car.tipo_persona and ref.nut_id = car.nut_id
WHERE car.tipo_persona = (SELECT per_id FROM PERSONAS WHERE per_tipo = 'anciano') 
			 and car.com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = 'comuna1');
             
-- Se obtiene los nombre de los nutrientes en carencia
SELECT (SELECT nut_nombre FROM NUTRIENTES WHERE nut_id =  car.nut_id )
FROM CARENCIAS as car 
INNER JOIN REFERENCIAS as ref on ref.per_id = car.tipo_persona and ref.nut_id = car.nut_id
WHERE car.tipo_persona = (SELECT per_id FROM PERSONAS WHERE per_tipo = 'anciano') 
			 and car.com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = 'comuna1');

             
-- Se obtiene el valor de las carencias de la comuna actual para los ancianos

SELECT (((car.car_porcentaje * ref.ref_referencia) / 100)  * car.car_numpersonas) as Total, 
(SELECT nut_nombre FROM NUTRIENTES WHERE nut_id =  car.nut_id ) as Nutriente
FROM CARENCIAS as car 
INNER JOIN REFERENCIAS as ref on ref.per_id = car.tipo_persona and ref.nut_id = car.nut_id
WHERE car.tipo_persona = (SELECT per_id FROM PERSONAS WHERE per_tipo = 'anciano') 
			 and car.com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = 'comuna1');


-- Obtiene las frutas con sus nutrientes y lo que aporta cada uno

SELECT fru.fru_nombre, nut.nut_nombre ,dat.nut_aporte
FROM FRUTAS as fru
INNER JOIN  DATOSNUT as dat on dat.fru_id = fru.fru_id
INNER JOIN  NUTRIENTES as nut on nut.nut_id = dat.nut_id;

-- Obtiene las frutas que se encuentran en la galeria 2

SELECT  fru.fru_nombre
FROM DATOSGAL as datg INNER JOIN FRUTAS fru
ON datg.fru_id = fru.fru_id
WHERE datg.gal_id = 2;

-- Obtiene las frutas que se encuentran en la galeria por nombre

SELECT  fru.fru_nombre
FROM DATOSGAL as datg INNER JOIN FRUTAS fru
ON datg.fru_id = fru.fru_id
WHERE datg.gal_id = (SELECT gal_id FROM GALERIAS WHERE gal_nombre = 'bolivar');

-- Obtiene los nutrientes de las frutas de la galeria 2
SELECT nut.nut_nombre
FROM DATOSNUT as datn
INNER JOIN NUTRIENTES as nut  ON datn.nut_id = nut.nut_id
INNER JOIN FRUTAS as fru ON datn.fru_id = fru.fru_id
INNER JOIN DATOSGAL as datg on datg.fru_id = fru.fru_id
WHERE datg.gal_id = 2;

-- Obtiene los nutrientes de una fruta
SELECT nut.nut_nombre
FROM DATOSNUT as datn
INNER JOIN NUTRIENTES as nut ON datn.nut_id = nut.nut_id
WHERE datn.fru_id = (SELECT fru_id FROM FRUTAS WHERE fru_nombre = 'manzana');

-- Obtiene aporte de la fruta con el nutriente 
SELECT datn.nut_aporte
FROM DATOSNUT as datn
INNER JOIN FRUTAS as fru ON datn.fru_id = fru.fru_id
WHERE fru.fru_id = (SELECT fru_id FROM FRUTAS WHERE fru_nombre = 'manzana') 
and datn.nut_id = (SELECT nut_id FROM NUTRIENTES WHERE nut_nombre = 'vitaminaC');

-- obtiene los gramos que ingresan de una fruta especifica

SELECT datg.dat_ingresa
FROM DATOSGAL as datg
WHERE datg.fru_id = (SELECT fru_id FROM FRUTAS WHERE fru_nombre = 'manzana')
and datg.gal_id = (SELECT gal_id FROM GALERIAS WHERE gal_nombre = 'bolivar');

-- obtiene la referencia para un tipo de persona y un nutriente

SELECT ref.ref_referencia
FROM REFERENCIAS ref
WHERE ref.per_id = (SELECT per_id FROM PERSONAS WHERE per_tipo = 'anciano')
and ref.nut_id = (SELECT nut_id FROM NUTRIENTES WHERE nut_nombre = 'potasio');

-- obtiene las frutas de la galeria por nombre
SELECT  fru.fru_nombre
FROM DATOSGAL as datg INNER JOIN FRUTAS fru
ON datg.fru_id = fru.fru_id
WHERE datg.gal_id = (SELECT gal_id FROM GALERIAS WHERE gal_nombre = 'bolivar');

SELECT COUNT(*)
FROM DATOSCOM
WHERE com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = 'comuna2');

SELECT COUNT(*)
FROM DATOSGAL
WHERE gal_id = (SELECT gal_id FROM GALERIAS WHERE gal_nombre = 'esmeralda');



INSERT INTO RECOMENDACIONES (rec_fruta, rec_nutriente, rec_comuna, rec_galeria, rec_persona)
VALUES ('Cardinal', 'Tom B. Erichsen', 'Skagen 21', 'Stavanger', '4006', 'Norway');



-- tienes la comuna y el tipo de peronsa, obten el porcentaje de personas que sufren de desnutricion


