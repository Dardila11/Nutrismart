#lang racket
(require racket/gui/base)
(require db)
(require "Conexion.rkt")

(provide obtieneDatosComuna)
(provide obtieneDatosCarencias)


;Ingresar datos a comuna
;Obtener id de la comuna
(define comunaIdByName (prepare conn "SELECT com_id FROM COMUNAS WHERE com_nombre = ?"))
(query-value conn comunaIdByName "Comuna2")

(define (obtieneDatosComuna comboComunas txtPoblacion txtCantNinos txtCantNinosDes txtCantAncianos txtCantAncianosDes)
    ;(format "~v" (query-value conn galeriaIdByName comboGaleria)))
  (query-exec conn insertarDATOSCOM (query-value conn comunaIdByName comboComunas) txtPoblacion txtCantNinos txtCantNinosDes txtCantAncianos txtCantAncianosDes))

;insertar datos en la tabla DATOSCOM
(define insertarDATOSCOM (prepare conn "INSERT INTO DATOSCOM(com_id,com_cantidad_total,com_cant_ninos,com_cant_ninosdes,com_cant_ancianos,com_cant_ancianosdes) VALUES(?,?,?,?,?,?)"))

;Insertar datos de la carencia de nutrientes
;Obtenemos el id del nutriente seleccionado en el comboBox
(define nutrienteIdByName (prepare conn "SELECT nut_id FROM NUTRIENTES WHERE nut_nombre = ?"))
(query-value conn nutrienteIdByName "Potasio")


;insertamos las carencias con el nut_id, cantidadPersonas, com_id
(define (obtieneDatosCarencias txtNombreNutriente txtCantPersonas comboComunas txtPorcentaje comboPersonas)
    ;(format "~v" (query-value conn galeriaIdByName comboGaleria)))
  (query-exec conn insertarCARENCIAS (query-value conn nutrienteIdByName txtNombreNutriente) txtCantPersonas (query-value conn comunaIdByName comboComunas) txtPorcentaje (query-value conn personaIdByName comboPersonas)))

;Obtenemos el id de la persona seleccionado en el comboBox
(define personaIdByName (prepare conn "SELECT per_id FROM PERSONAS WHERE per_tipo = ?"))

;insertar datos en la tabla CARENCIAS
(define insertarCARENCIAS (prepare conn "INSERT INTO CARENCIAS(nut_id,car_numpersonas,com_id,car_porcentaje,tipo_persona) VALUES(?,?,?,?,?)"))



;-------------------------------------- OBTENCION DE DATOS -----------------------------------------------------------------------------------------

;al precionar el botton GENERAR RECOMENDACIONES:
;Se obtiene todas las carencias de la la comuna actual

(define carenciasComunaSQL (prepare conn "SELECT * FROM CARENCIAS
                                       WHERE com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = ?)"))

(define (carenciasComuna comboComunas)
  (query-rows conn carenciasComunaSQL "comuna1"))

(carenciasComuna "comuna1")

(length (carenciasComuna "comuna1"))
(car (carenciasComuna "comuna1"))

;se obtiene el valor de las carencias de la comuna actual

(define valorCarenciasComunaSQL (prepare conn "SELECT (((car.car_porcentaje * ref.ref_referencia) / 100)  * car.car_numpersonas) as Total, 
                                               (SELECT nut_nombre FROM NUTRIENTES WHERE nut_id =  car.nut_id ) as Nutriente
                                               FROM CARENCIAS as car 
                                               INNER JOIN REFERENCIAS as ref on ref.per_id = car.tipo_persona and ref.nut_id = car.nut_id
                                               WHERE car.tipo_persona = (SELECT per_id FROM PERSONAS WHERE per_tipo = 'niño') 
			                       and car.com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = ?);"))

(define (valorCarenciasComunas comboComunas)
  (query-rows conn valorCarenciasComunaSQL comboComunas))

(valorCarenciasComunas "comuna1")
(car (valorCarenciasComunas "comuna1"))
(list (car (valorCarenciasComunas "comuna1")))
















