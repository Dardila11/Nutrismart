#lang racket
(require racket/gui/base)
(require db)
(require "Conexion.rkt")

(provide obtieneDatosComuna)
(provide obtieneDatosCarencias)


;Ingresar datos a comuna
;Obtener id de la comuna
(define comunaIdByName (prepare conn "SELECT com_id FROM COMUNAS WHERE com_nombre = ?"))
;(query-value conn comunaIdByName "Comuna2")

(define (obtieneDatosComuna comboComunas txtPoblacion txtCantNinos txtCantNinosDes txtCantAncianos txtCantAncianosDes)
    ;(format "~v" (query-value conn galeriaIdByName comboGaleria)))
  (query-exec conn insertarDATOSCOM (query-value conn comunaIdByName comboComunas) txtPoblacion txtCantNinos txtCantNinosDes txtCantAncianos txtCantAncianosDes))

;insertar datos en la tabla DATOSCOM
(define insertarDATOSCOM (prepare conn "INSERT INTO DATOSCOM(com_id,com_cantidad_total,com_cant_ninos,com_cant_ninosdes,com_cant_ancianos,com_cant_ancianosdes) VALUES(?,?,?,?,?,?)"))

;Insertar datos de la carencia de nutrientes
;Obtenemos el id del nutriente seleccionado en el comboBox
(define nutrienteIdByName (prepare conn "SELECT nut_id FROM NUTRIENTES WHERE nut_nombre = ?"))
;(query-value conn nutrienteIdByName "Potasio")


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

;(carenciasComuna "comuna1")

;(length (carenciasComuna "comuna1"))
;(car (carenciasComuna "comuna1"))

;se obtiene el valor de las carencias de la comuna actual

(define valorCarenciasComunaSQL (prepare conn "SELECT (((car.car_porcentaje * ref.ref_referencia) / 100)  * car.car_numpersonas) as Total
                                               
                                               FROM CARENCIAS as car 
                                               INNER JOIN REFERENCIAS as ref on ref.per_id = car.tipo_persona and ref.nut_id = car.nut_id
                                               WHERE car.tipo_persona = (SELECT per_id FROM PERSONAS WHERE per_tipo = ?) 
			                       and car.com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = ?);"))

(define nombreCarenciaComunaSQL (prepare conn "SELECT (SELECT nut_nombre FROM NUTRIENTES WHERE nut_id =  car.nut_id )
                                               FROM CARENCIAS as car 
                                               INNER JOIN REFERENCIAS as ref on ref.per_id = car.tipo_persona and ref.nut_id = car.nut_id
                                               WHERE car.tipo_persona = (SELECT per_id FROM PERSONAS WHERE per_tipo = ?) 
			                       and car.com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = ?);"))

(define frutasEnGaleriaSQL (prepare conn "SELECT  fru.fru_nombre
                                          FROM DATOSGAL as datg INNER JOIN FRUTAS fru
                                          ON datg.fru_id = fru.fru_id
                                          WHERE datg.gal_id = ?;"))

(define (frutasEnGaleria nombreGaleria)
  (query-list conn frutasEnGaleriaSQL nombreGaleria))

(define (valorCarenciasComunas tipoPersona comboComunas)
  (query-list conn valorCarenciasComunaSQL tipoPersona comboComunas))

(define (nombreCarenciaComunas tipoPersona comboComunas)
  (query-list conn nombreCarenciaComunaSQL tipoPersona comboComunas))

;(valorCarenciasComunas "niño" "comuna1")
;(car (valorCarenciasComunas "niño" "comuna1"))
;(nombreCarenciaComunas "niño" "comuna1")
;(car (nombreCarenciaComunas "niño" "comuna1"))



;Ahora buscamos las frutas de alguna galeria 1 que tengan la cantidad de nutrientes que requiere la comuna
;recorremos la lista de nombreCarenciaComunas sacando la cabeza y evaluandola

(define nutrienteByFrutaSQL (prepare conn "SELECT nut.nut_nombre
                                           FROM DATOSNUT as datn
                                           INNER JOIN NUTRIENTES as nut ON datn.nut_id = nut.nut_id
                                           WHERE datn.fru_id = (SELECT fru_id FROM FRUTAS WHERE fru_nombre = ?)"))

(define (nutrienteByFruta nombreFruta)
  (query-list conn nutrienteByFrutaSQL nombreFruta))

(define aporteByFrutayNutrienteSQL (prepare conn "SELECT datn.nut_aporte
                                                  FROM DATOSNUT as datn
                                                  INNER JOIN FRUTAS as fru ON datn.fru_id = fru.fru_id
                                                  WHERE fru.fru_id = (SELECT fru_id FROM FRUTAS WHERE fru_nombre = ?) 
                                                  and datn.nut_id = (SELECT nut_id FROM NUTRIENTES WHERE nut_nombre = ?);"))
(define (aporteByFrutayNutriente fruta nutriente)
  (query-value conn aporteByFrutayNutrienteSQL fruta nutriente))

(define cantidad (valorCarenciasComunas "niño" "comuna1"))
(define carencia (nombreCarenciaComunas "niño" "comuna1"))
(define carenciaList (nombreCarenciaComunas "niño" "comuna1"))
(define frutas   (frutasEnGaleria "2"))

;cantidad
carencia
;(car carencia)
frutas
;(car frutas)
;(car (cdr frutas))
;(nutrienteByFruta (car frutas))
;(nutrienteByFruta "banano")
;(nutrienteByFruta (car frutas))
;(nutrienteByFruta (car (nutrienteByFruta (car (cdr frutas)))))
(define nutrienteObtenido (car (nutrienteByFruta (car frutas))))
(aporteByFrutayNutriente "naranja" "magnesio")




(define (nutrienteNecesario carencia nutriente)
  (cond
    ;[(empty? carencia) "nutriente no existe : evalua la siquiente fruta"]
    [(empty? carencia) (nutrienteNecesario carenciaList (car (nutrienteByFruta (car (cdr frutas)))))]
    [(equal? nutriente (car carencia))"nutriente correcto : sacaria el aporte de la fruta naranja con ese nutriente (potasio)"]
    [else (nutrienteNecesario (cdr carencia) nutriente)]
    ))

(nutrienteNecesario carencia nutrienteObtenido)




















