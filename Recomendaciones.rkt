#lang racket
(require racket/gui/base)
(require db)
(require "Conexion.rkt")


;-------------------------------------- OBTENCION DE DATOS -----------------------------------------------------------------------------------------

;al precionar el boton GENERAR RECOMENDACIONES:
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


;cantidad
;carencia
;(car carencia)
;frutas
;(car frutas)
;(car (cdr frutas))
;(nutrienteByFruta (car frutas))
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

;(nutrienteNecesario carencia nutrienteObtenido)



;ahora tenemos que buscar cuantos gramos entran de la fruta a la galeria

(define gramosFrutaSQL (prepare conn "SELECT datg.dat_ingresa
                                      FROM DATOSGAL as datg
                                      WHERE datg.fru_id = (SELECT fru_id FROM FRUTAS WHERE fru_nombre = ?)
                                      and datg.gal_id = (SELECT gal_id FROM GALERIAS WHERE gal_nombre = ?);"))

(define (gramosFruta fruta galeria )
  (query-value conn gramosFrutaSQL fruta galeria))

;(gramosFruta "manzana")

(define refByPersonaNutSQL (prepare conn "SELECT ref.ref_referencia
                                      FROM REFERENCIAS ref
                                      WHERE ref.per_id = (SELECT per_id FROM PERSONAS WHERE per_tipo = ?)
                                      and ref.nut_id = (SELECT nut_id FROM NUTRIENTES WHERE nut_nombre = ?);"))

(define (refByPersonaNut persona nutriente )
  (query-value conn refByPersonaNutSQL persona nutriente))

;(refByPersonaNut "niño" "vitaminaC")

;calcular si la cantidad que entra de la fruta a la galeria es mayor a la carencia en gramos de la comuna

(define (recomendacionNino comboGaleria comboComuna)
    (valorCarenciasComunas "niño" comboComuna)
    
    )

(define (recomendacionAnciano comboGaleria comboComuna)
    (valorCarenciasComunas "anciano" comboComuna)
    
    )

;(recomendacionNino "Bolivar" "comuna1")
;(nombreCarenciaComunas "niño" "comuna1")
;(recomendacionAnciano "Esmeralda" "comuna1")




;================================================================================================================================================================


;sacamos los nombre de las carencias por tipo persona

(nombreCarenciaComunas "niño" "comuna1") ;-- LISTANUTRIENTES

;sacamos el valor de las carencias por tipo persona

(valorCarenciasComunas "niño" "comuna1")

;================================================================================================================================================================

;sacamos la lista de frutas de la galeria seleccionada

(define frutasEnGaleriaByNameSQL (prepare conn "SELECT  fru.fru_nombre
                                          FROM DATOSGAL as datg INNER JOIN FRUTAS fru
                                          ON datg.fru_id = fru.fru_id
                                          WHERE datg.gal_id = (SELECT gal_id FROM GALERIAS WHERE gal_nombre = ?);"))

(define (frutasEnGaleriaByName nombreGaleria)
  (query-list conn frutasEnGaleriaByNameSQL nombreGaleria))

(frutasEnGaleriaByName "Bolivar") ;-- LISTAFRUTAS

;================================================================================================================================================================

;sacamos primer elemento de las frutas

(car (frutasEnGaleriaByName "Bolivar")) ;-- primera fruta en LISTAFRUTAS

;sacamos los nutriente de cada fruta de la lista de frutas por Galeria

(nutrienteByFruta (car (frutasEnGaleriaByName "Bolivar"))) ;-- Lista de nutrientes de la primer fruta en FRUTAS

(define listaNutrientesByFruta  (nutrienteByFruta (car (frutasEnGaleriaByName "Bolivar"))))

;obtenemos el primer elemento de la lista de nutrientes de la primera fruta en FRUTAS

(car listaNutrientesByFruta) ;-- primer elemento de la lista de nutrientes



;================================================================================================================================================================

(gramosFruta "manzana" "bolivar")
(aporteByFrutayNutriente "manzana" "vitaminaC")

;-- posicion de un elemento en una lista

(define (posicionElem lista elemento)
  (index-of lista elemento))

;- elemento por su posicion
(define (elemByPos lista posicion)
  (list-ref lista posicion))

(define (conversionGramos mg)
  (/ mg 1000))

(define (pos elemento)
  (elemByPos (valorCarenciasComunas "niño" "comuna1") (posicionElem (nombreCarenciaComunas "niño" "comuna1") elemento)))

(define (aporte fruta nutriente)
  ;aporteByFrutayNutriente devuelve el aporte de la manzana en este caso que es 141 mg
  ;falta obtener la cantidad de gramos que hay disponible en la galera
  ;((equal? (aporteByFrutayNutriente fruta nutriente)(aporteByFrutayNutriente fruta nutriente)) (gramosFruta fruta "bolivar")))
   (cond
   [(<= (/ (* (gramosFruta fruta "bolivar") (aporteByFrutayNutriente fruta nutriente)) 100) (pos nutriente)) "no es suficiente"]
   [else "justo lo que necesitamos"]))
  
 


(define (compararNutriente listaFrutas listaNutrientes existen)
  (cond
    [(empty? listaNutrientes) "no existe el nutriente en la listaNutrientes: evaluar la siguiente fruta"]
    ;sacamos el nutriente de la cabeza de la listaFrutas y el nutriente de la cabeza de la listaNutrientes
    [(equal? (car listaNutrientes) (car (nutrienteByFruta (car listaFrutas)))) (aporte (car listaFrutas) (car (nutrienteByFruta (car listaFrutas))))]
    ;(append existen (list (car listaFrutas) (car (nutrienteByFruta (car listaFrutas)))))]
   
    [else (compararNutriente listaFrutas (cdr listaNutrientes) existen)]
    ;comparar el mismo nutriente de la cabeza de la listaFrutas con el nutriente de la cabeza del resto de la lista
    ))

(compararNutriente (frutasEnGaleriaByName "bolivar") (nombreCarenciaComunas "niño" "comuna1") '())






    
  

;================================================================================================================================================================


;recorremos la lista de carencias por cada una de las frutas de la galeria

(define (nutNecesario carencia nutriente)
  (cond
    ;[(empty? carencia) "nutriente no existe : evalua la siquiente fruta"]
    [(empty? carencia) (nutNecesario (valorCarenciasComunas "niño" "comuna1") (car (nutrienteByFruta (car (cdr (frutasEnGaleriaByName "Esmeralda"))))))]
    [(equal? nutriente (car carencia)) (aporteByFrutayNutriente (car (frutasEnGaleriaByName "Esmeralda")) nutriente)]
    [else (nutNecesario (cdr carencia) nutriente)]
    ))

;(nutNecesario  (nombreCarenciaComunas "niño" "comuna1") (car (nutrienteByFruta (car (frutasEnGaleriaByName "Esmeralda")))))



;================================================================================================================================================================







