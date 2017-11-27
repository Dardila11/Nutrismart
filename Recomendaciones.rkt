#lang racket
(require racket/gui/base)
(require db)
(require "Conexion.rkt")


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
(define frutas   (frutasEnGaleria "1"))

cantidad
carencia
;(car carencia)
frutas
;(car frutas)
;(car (cdr frutas))
(nutrienteByFruta (car frutas))
;(nutrienteByFruta "banano")
;(nutrienteByFruta (car frutas))
;(nutrienteByFruta (car (nutrienteByFruta (car (cdr frutas)))))
(define nutrienteObtenido (car (nutrienteByFruta (car frutas))))
;(aporteByFrutayNutriente "naranja" "magnesio")




(define (nutrienteNecesario carencia nutriente)
  (cond
    ;[(empty? carencia) "nutriente no existe : evalua la siquiente fruta"]
    [(empty? carencia) (nutrienteNecesario (valorCarenciasComunas "niño" "comuna1") (car (nutrienteByFruta (car (cdr frutas)))))]
    [(equal? nutriente (car carencia)) (aporteByFrutayNutriente (car frutas) nutriente)]
    [else (nutrienteNecesario (cdr carencia) nutriente)]
    ))

(nutrienteNecesario carencia nutrienteObtenido)

;obtiene la posicion del nutriente en la lista carencia
(define posicionNut (index-of carencia "vitaminaC"))
;obtiene el elemento en la posicion dada
(define elementoPos (list-ref cantidad posicionNut))
elementoPos

;ahora tenemos que buscar cuantos gramos entran de la fruta a la galeria

(define gramosFrutaSQL (prepare conn "SELECT datg.dat_ingresa
                                      FROM DATOSGAL as datg
                                      WHERE datg.fru_id = (SELECT fru_id FROM FRUTAS WHERE fru_nombre = ?);"))

(define (gramosFruta fruta )
  (query-value conn gramosFrutaSQL fruta))

(gramosFruta "manzana")

(define refByPersonaNutSQL (prepare conn "SELECT ref.ref_referencia
                                      FROM REFERENCIAS ref
                                      WHERE ref.per_id = (SELECT per_id FROM PERSONAS WHERE per_tipo = ?)
                                      and ref.nut_id = (SELECT nut_id FROM NUTRIENTES WHERE nut_nombre = ?);"))

(define (refByPersonaNut persona nutriente )
  (query-value conn refByPersonaNutSQL persona nutriente))

;(refByPersonaNut "niño" "vitaminaC")

;calcular si la cantidad que entra de la fruta a la galeria es mayor a la carencia en gramos de la comuna

