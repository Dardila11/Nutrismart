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
(provide resultadoRecomendaciones)



;-------------------------------------- OBTENCION DE DATOS -----------------------------------------------------------------------------------------
;al precionar el boton GENERAR RECOMENDACIONES:
;Se obtiene todas las carencias de la la comuna actual
;================================================================================================================================================================



;verificamos que hayan datos en la comuna. si el resultado es 0 muestra mensaje que no hay nada para mostrar
(define datosComunaSQL (prepare conn "SELECT COUNT(*)
                                   FROM DATOSCOM
                                   WHERE com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = ?);"))

(define (datosComuna comboComuna)
  (query-value conn datosComunaSQL comboComuna))

;verificamos que hayan datos en la galeria. si el resultado es 0 muestra mensaje que no que nada para mostrar
(define datosGaleriaSQL (prepare conn "SELECT COUNT(*)
                                      FROM DATOSGAL
                                      WHERE gal_id = (SELECT gal_id FROM GALERIAS WHERE gal_nombre = ?);"))

(define (datosGaleria comboGaleria)
  (query-value conn datosGaleriaSQL comboGaleria))

;todos carencias de la comuna por el nombre de la comuna
(define carenciasComunaSQL (prepare conn "SELECT * FROM CARENCIAS
                                       WHERE com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = ?)"))

(define (carenciasComuna comboComunas)
  (query-rows conn carenciasComunaSQL "comuna1"))

;valor de carencias de la comuna actual con el tipo de persona (niño o anciano)
(define valorCarenciasComunaSQL (prepare conn "SELECT (((car.car_porcentaje * ref.ref_referencia) / 100)  * car.car_numpersonas) as Total
                                               
                                               FROM CARENCIAS as car 
                                               INNER JOIN REFERENCIAS as ref on ref.per_id = car.tipo_persona and ref.nut_id = car.nut_id
                                               WHERE car.tipo_persona = (SELECT per_id FROM PERSONAS WHERE per_tipo = ?) 
			                       and car.com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = ?);"))

(define (valorCarenciasComunas tipoPersona comboComunas)
  (query-list conn valorCarenciasComunaSQL tipoPersona comboComunas))

;nombre de carencias de la comuna actual con el tipo de persona (niño o anciano)
(define nombreCarenciaComunaSQL (prepare conn "SELECT (SELECT nut_nombre FROM NUTRIENTES WHERE nut_id =  car.nut_id )
                                               FROM CARENCIAS as car 
                                               INNER JOIN REFERENCIAS as ref on ref.per_id = car.tipo_persona and ref.nut_id = car.nut_id
                                               WHERE car.tipo_persona = (SELECT per_id FROM PERSONAS WHERE per_tipo = ?) 
			                       and car.com_id = (SELECT com_id FROM COMUNAS WHERE com_nombre = ?);"))
(define (nombreCarenciaComunas tipoPersona comboComunas)
  (query-list conn nombreCarenciaComunaSQL tipoPersona comboComunas))

;lista de nombres de las frutas por el id de la galeria
(define frutasEnGaleriaSQL (prepare conn "SELECT  fru.fru_nombre
                                          FROM DATOSGAL as datg INNER JOIN FRUTAS fru
                                          ON datg.fru_id = fru.fru_id
                                          WHERE datg.gal_id = ?;"))

(define (frutasEnGaleria nombreGaleria)
  (query-list conn frutasEnGaleriaSQL nombreGaleria))

;lista de nombre de las FRUTAS por el NOMBRE de la GALERIA
(define frutasEnGaleriaByNameSQL (prepare conn "SELECT  fru.fru_nombre
                                                FROM DATOSGAL as datg INNER JOIN FRUTAS fru
                                                ON datg.fru_id = fru.fru_id
                                                WHERE datg.gal_id = (SELECT gal_id FROM GALERIAS WHERE gal_nombre = ?);"))
(define (frutasEnGaleriaByName nombreGaleria)
  (query-list conn frutasEnGaleriaByNameSQL nombreGaleria))

;Ahora buscamos las frutas de alguna galeria 1 que tengan la cantidad de nutrientes que requiere la comuna
;recorremos la lista de nombreCarenciaComunas sacando la cabeza y evaluandola
;lista de nutrientes por el nombre de la fruta
(define nutrienteByFrutaSQL (prepare conn "SELECT nut.nut_nombre
                                           FROM DATOSNUT as datn
                                           INNER JOIN NUTRIENTES as nut ON datn.nut_id = nut.nut_id
                                           WHERE datn.fru_id = (SELECT fru_id FROM FRUTAS WHERE fru_nombre = ?)"))

(define (nutrienteByFruta nombreFruta)
  (query-list conn nutrienteByFrutaSQL nombreFruta))

;el aporte de la fruta por su nutriente
(define aporteByFrutayNutrienteSQL (prepare conn "SELECT datn.nut_aporte
                                                  FROM DATOSNUT as datn
                                                  INNER JOIN FRUTAS as fru ON datn.fru_id = fru.fru_id
                                                  WHERE fru.fru_id = (SELECT fru_id FROM FRUTAS WHERE fru_nombre = ?) 
                                                  and datn.nut_id = (SELECT nut_id FROM NUTRIENTES WHERE nut_nombre = ?);"))
(define (aporteByFrutayNutriente fruta nutriente)
  (query-value conn aporteByFrutayNutrienteSQL fruta nutriente))


;================================================================================================================================================================

(define cantidad (valorCarenciasComunas "niño" "comuna1"))
(define carencia (nombreCarenciaComunas "niño" "comuna1"))
(define carenciaList (nombreCarenciaComunas "niño" "comuna1"))
(define frutas   (frutasEnGaleria "1"))

;================================================================================================================================================================


;ahora tenemos que buscar cuantos gramos entran de la fruta a la galeria
;cantidad de gramos de FRUTA que entra a la GALERIA
(define gramosFrutaSQL (prepare conn "SELECT datg.dat_ingresa
                                      FROM DATOSGAL as datg
                                      WHERE datg.fru_id = (SELECT fru_id FROM FRUTAS WHERE fru_nombre = ?)
                                      and datg.gal_id = (SELECT gal_id FROM GALERIAS WHERE gal_nombre = ?);"))

(define (gramosFruta fruta galeria )
  (query-maybe-value conn gramosFrutaSQL fruta galeria))

;referencia de NUTRIENTE por PERSONA
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



;================================================================================================================================================================

(define listaNutrientesByFruta  (nutrienteByFruta (car (frutasEnGaleriaByName "bolivar"))))

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
          [(eqv? (cdr (nutrienteByFruta (car listaFrutas))) '()) (compararNutriente (cdr listaFrutas) listaNutrientes)] ; (nombreCarenciaComunas "niño" "comuna1")
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
    [(equal? (compFrutaNutriente (nutrienteByFruta fruta) listaNutrientes fruta) #t) #t] ; hay unafruta correcta
    [else #f]))


;(nutrienteByFruta "banano")

;(compFruta "naranja" (nombreCarenciaComunas "niño" "comuna1"))
;================================================================================================================================================================
;compara una lista de frutas con la lista de nutrientes
(define (compListaFrutaNut listaFruta listaNutrientes)
  (cond
    [(empty? listaNutrientes) "no hay frutas en esta galeria que le sirvan a la comuna"]
    [(equal? (compFruta (car listaFruta) listaNutrientes) #t) "se encontró por lo menos una fruta que sirva"]
    [else (compListaFrutaNut (cdr listaFruta) listaNutrientes)]))

;sacamos la lista de valores de carencias de la comuna seleccionada
;la lista de frutas que hay en la galeria
(define (carencias tipoPersona comboComuna comboGaleria)  
      (compListaFrutaNut (frutasEnGaleriaByName comboGaleria) (nombreCarenciaComunas tipoPersona comboComuna)))


;================================================================================================================================================================

(define (resultadoRecomendaciones tipoPersona comboComuna comboGaleria)
  ;verificamos que la comuna y la galeria no esten vacias
  (cond
    [(equal? (datosComuna comboComuna) 0) "la comuna no tiene datos"]
    [(equal? (datosGaleria comboGaleria) 0) "la comuna no tiene datos"]
    ;si la comuna si tiene datos
    ;obtenemos la carencias de esa comuna
    [(carencias tipoPersona comboComuna comboGaleria)]
    
    
    
    
  ))


(resultadoRecomendaciones "niño" "comuna1" "bolivar")


  
 
;================================================================================================================================================================








