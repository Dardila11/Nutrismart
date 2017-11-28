#lang racket
(require racket/gui/base)
(require db)
(require "Conexion.rkt")

(define listaDefinitiva '())

(provide carenciasComuna)
(provide frutasEnGaleria)
(provide valorCarenciasComunas)
(provide nombreCarenciaComunas)
(provide nutrienteByFruta)
(provide aporteByFrutayNutriente)
(provide gramosFruta)



;-------------------------------------- OBTENCION DE DATOS -----------------------------------------------------------------------------------------

;al precionar el boton GENERAR RECOMENDACIONES:
;Se obtiene todas las carencias de la la comuna actual


(define carenciasComunaSQL (prepare conn "SELECT * FROM CARENCIAS
                                       WHERE com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = ?)"))

(define (carenciasComuna comboComunas)
  (query-rows conn carenciasComunaSQL "comuna1"))


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

;================================================================================================================================================================




;Ahora buscamos las frutas de alguna galeria 1 que tengan la cantidad de nutrientes que requiere la comuna
;recorremos la lista de nombreCarenciaComunas sacando la cabeza y evaluandola

(define nutrienteByFrutaSQL (prepare conn "SELECT nut.nut_nombre
                                           FROM DATOSNUT as datn
                                           INNER JOIN NUTRIENTES as nut ON datn.nut_id = nut.nut_id
                                           WHERE datn.fru_id = (SELECT fru_id FROM FRUTAS WHERE fru_nombre = ?)"))

(define (nutrienteByFruta nombreFruta)
  (query-list conn nutrienteByFrutaSQL nombreFruta))

;================================================================================================================================================================


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

(define nutrienteObtenido (car (nutrienteByFruta (car frutas))))



;================================================================================================================================================================


(define (nutrienteNecesario carencia nutriente)
  (cond
    ;[(empty? carencia) "nutriente no existe : evalua la siquiente fruta"]
    [(empty? carencia) (nutrienteNecesario (valorCarenciasComunas "niño" "comuna1") (car (nutrienteByFruta (car (cdr frutas)))))]
    [(equal? nutriente (car carencia)) (aporteByFrutayNutriente (car frutas) nutriente)]
    [else (nutrienteNecesario (cdr carencia) nutriente)]
    ))

;(nutrienteNecesario carencia nutrienteObtenido)

;================================================================================================================================================================


;ahora tenemos que buscar cuantos gramos entran de la fruta a la galeria

(define gramosFrutaSQL (prepare conn "SELECT datg.dat_ingresa
                                      FROM DATOSGAL as datg
                                      WHERE datg.fru_id = (SELECT fru_id FROM FRUTAS WHERE fru_nombre = ?)
                                      and datg.gal_id = (SELECT gal_id FROM GALERIAS WHERE gal_nombre = ?);"))

(define (gramosFruta fruta galeria )
  (query-maybe-value conn gramosFrutaSQL fruta galeria))

(define refByPersonaNutSQL (prepare conn "SELECT ref.ref_referencia
                                      FROM REFERENCIAS ref
                                      WHERE ref.per_id = (SELECT per_id FROM PERSONAS WHERE per_tipo = ?)
                                      and ref.nut_id = (SELECT nut_id FROM NUTRIENTES WHERE nut_nombre = ?);"))

(define (refByPersonaNut persona nutriente )
  (query-value conn refByPersonaNutSQL persona nutriente))




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

; (frutasEnGaleriaByName "bolivar") ;-- LISTAFRUTAS

;================================================================================================================================================================

;sacamos primer elemento de las frutas

;(car (frutasEnGaleriaByName "bolivar")) ;-- primera fruta en LISTAFRUTAS

;sacamos los nutriente de cada fruta de la lista de frutas por Galeria

;(nutrienteByFruta (car (frutasEnGaleriaByName "bolivar"))) ;-- Lista de nutrientes de la primer fruta en FRUTAS

(define listaNutrientesByFruta  (nutrienteByFruta (car (frutasEnGaleriaByName "bolivar"))))

;obtenemos el primer elemento de la lista de nutrientes de la primera fruta en FRUTAS

;(car listaNutrientesByFruta) ;-- primer elemento de la lista de nutrientes



;================================================================================================================================================================

;(gramosFruta "manzana" "esmeralda")
;(aporteByFrutayNutriente "manzana" "vitaminaC")

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

(define (mostrar fruta nutriente)
  (list fruta nutriente))

;================================================================================================================================================================


;- cuando hayamos encontrado un nutriente en carencia con el nutriente ofrecido por las galerias. llamamos este metodo
;el cual devuelve falso o verdadero si hay suficiendo cantidad de frutas para proveer.

(define (aporte fruta nutriente)
   (cond
   [(eqv? (gramosFruta fruta "bolivar") #f) "fruta no existe en la galeria"]
   [(<= (/ (* (gramosFruta fruta "bolivar") (aporteByFrutayNutriente fruta nutriente)) 100) (pos nutriente)) #f] ;-- no es suficiente
   ;si es positivo, agregamos la fruta y nutriente a una lista
   ;hace algo para que muestre la fruta y el nutriente y cuanto ofrece
   ;[else (append listaDefinitiva (list fruta nutriente))]))
   [(mostrar fruta nutriente)]
   [else #t]))

;================================================================================================================================================================

  
 


(define (compararNutriente listaFrutas listaNutrientes)
  (cond
    [(empty? listaNutrientes) "no existe el nutriente en la listaNutrientes: evaluar la siguiente fruta"]
    ;sacamos el nutriente de la cabeza de la listaFrutas y el nutriente de la cabeza de la listaNutrientes
    [(equal? (car listaNutrientes) (car (nutrienteByFruta (car listaFrutas))))
     (cond
       [(eqv? (aporte (car listaFrutas) (car (nutrienteByFruta (car listaFrutas)))) #f) "no es suficiente lo que aporta"] ; no es suficiente lo que ofrece la galeria a la comuna
       ;ahora pasamos al otro elemento en la lista 
       [else
        (cond
          [(eqv? (cdr (nutrienteByFruta (car listaFrutas))) '()) (compararNutriente (cdr listaFrutas) (nombreCarenciaComunas "niño" "comuna1"))]
          [else (compararNutriente (cdr listaFrutas) (listaNutrientes))])])]
    [else (compararNutriente listaFrutas (cdr listaNutrientes))]))
    ;comparar el mismo nutriente de la cabeza de la listaFrutas con el nutriente de la cabeza del resto de la lista
  

;(compararNutriente (frutasEnGaleriaByName "bolivar") (nombreCarenciaComunas "niño" "comuna1"))

;================================================================================================================================================================




;================================================================================================================================================================

;compara UN SOLO nutriente de la LISTA DE NUTRIENTES de UNA SOLA fruta de la lista FRUTAS con la lista de CARENCIAS

(define (compNutNut nutrienteFruta listaNutrientes fruta)
  (cond
    [(empty? listaNutrientes) #f]
    [(equal? nutrienteFruta (car listaNutrientes))
     ; "se ha encontrado"
     (cond
       [(eqv? (aporte fruta nutrienteFruta) #t) #t]
       [else (compNutNut nutrienteFruta (cdr listaNutrientes) fruta)]; "no es suficiente aporte de la fruta a la carencia"
       ;si es #t se agrega la fruta y su componente a una lista
       )]
    [else (compNutNut nutrienteFruta (cdr listaNutrientes) fruta)]
  ))

;================================================================================================================================================================

;compara los nutrientes de UNA SOLA fruta de la lista FRUTAS con la lista de CARENCIAS

(define (compFrutaNutriente nutrientesFruta listaNutrientes fruta)
  (cond
    [(empty? listaNutrientes) #f]
    [(equal? nutrientesFruta '()) "no sirve" ]
    [(equal? (compNutNut (car nutrientesFruta) listaNutrientes fruta) #f) (compFrutaNutriente (cdr nutrientesFruta) listaNutrientes fruta) #t ] ;no está el nutriente
    ;[else (compFrutaNutriente (cdr nutrientesFruta listaNutrientes fruta))]
    ))

;================================================================================================================================================================

;compara UNA SOLA fruta de la lista FRUTAS con la lista Carencias

(define (compFruta fruta listaNutrientes)
  (cond
    [(empty? listaNutrientes) #f]
    [(equal? (compFrutaNutriente (nutrienteByFruta fruta) listaNutrientes fruta) #t) "fruta correcta"]
    [else "no sirve"]))

;(nombreCarenciaComunas "niño" "comuna1")
(nutrienteByFruta "banano")

(compFruta "naranja" (nombreCarenciaComunas "niño" "comuna1"))

;================================================================================================================================================================

 









