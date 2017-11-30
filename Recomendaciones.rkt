#lang racket
(require racket/gui/base)
(require db)
(require "Conexion.rkt")

(define listaDefinitiva '(frutas))
(define variableResultado "")

(provide carenciasComuna)
(provide frutasEnGaleria)
(provide valorCarenciasComunas)
(provide nombreCarenciaComunas)
(provide nutrienteByFruta)
(provide aporteByFrutayNutriente)
(provide gramosFruta)
(provide resultadoRecomendaciones)
(provide resultado)
(provide recomendar)
(provide getGaleriasSQL getFrutasSQL)



;-------------------------------------- OBTENCION DE DATOS -----------------------------------------------------------------------------------------
;al precionar el boton GENERAR RECOMENDACIONES:
;Se obtiene todas las carencias de la la comuna actual
;================================================================================================================================================================

;obtenemos todas las galerias
(define getGaleriasSQL (query-list conn "SELECT gal_nombre FROM GALERIAS"))
(define getPersonasSQL (query-list conn "SELECT per_tipo FROM PERSONAS"))
(define getComunasSQL (query-list conn "SELECT com_nombre FROM COMUNAS"))
(define getFrutasSQL (query-list conn "SELECT fru_nombre FROM FRUTAS"))

;tenemos que borrar todos los datos de la tabla recomendaciones
(define borrarDatos (query-exec conn "TRUNCATE TABLE RECOMENDACIONES"))




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

;insertar valores a recomendaciones
(define insertarRecomendacionesSQL (prepare conn "INSERT INTO RECOMENDACIONES (rec_fruta, rec_nutriente, rec_comuna, rec_galeria, rec_persona)
                                                  VALUES (?,?,?,?,?);"))

(define (insertarRecomendaciones fruta nutriente comboComuna comboGaleria tipoPersona)
  (query-exec conn insertarRecomendacionesSQL fruta nutriente comboComuna comboGaleria tipoPersona))

;obtener valores de recomendaciones
(define valoresRecomendacionesSQL (query-rows conn "SELECT * FROM RECOMENDACIONES"))


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

(define (pos elemento comboComuna tipoPersona)
  (elemByPos (valorCarenciasComunas tipoPersona comboComuna) (posicionElem (nombreCarenciaComunas tipoPersona comboComuna) elemento)))

(define (mostrar fruta nutriente)
  (list fruta nutriente))

;agregar elemento a la lista
(define (insertar listaNut fruta)
  (cond
    [(empty? listaNut) (list fruta)]
    [(append listaNut (list fruta))]
    [else (cons (car listaNut) (insertar (cdr listaNut) fruta))]))


(define (insertar-elem fruta lista)
  (insertar lista fruta))

(define (mostrarLista lista)
  (display listaDefinitiva))

;================================================================================================================================================================

#|TODO: FALTA POR DEFINIR COMO MOSTRAR EL MENSAJE DE RESULTADO

   - TALVES SE PUEDA COLOCAR mostrarFruta EN LA FUNCION APORTE
   - AGREGAR PARA QUE TIPO DE PERSONA VA DIRIGIDO
   - HAY QUE AGREGAR LA FUNCION PARA NIÑOS Y ANCIANOS
|#

;aqui tendriamos que hacer una funcion para obtener la fruta que si sirva pero que ademas pueda hacer el 'else'
(define variableRes "")

;(define (mostrarFruta comboGaleria comboComuna fruta listaNutrientes)
 ;   (print (~a "La galeria " comboGaleria " posee la fruta " fruta " la cual tiene los nutrientes " listaNutrientes " los cuales son necesario para la comuna " comboComuna)))

(define (mostrarFruta comboGaleria comboComuna fruta listaNutrientes)
    (~a "La galeria " comboGaleria " posee la fruta " fruta " la cual tiene los nutrientes " listaNutrientes " los cuales son necesario para la comuna " comboComuna))

;================================================================================================================================================================


;- cuando hayamos encontrado un nutriente en carencia con el nutriente ofrecido por las galerias. llamamos este metodo
;el cual devuelve falso o verdadero si hay suficiendo cantidad de frutas para proveer.

(define (aporte fruta nutriente comboComuna comboGaleria tipoPersona)
   (cond
   [(eqv? (gramosFruta fruta comboGaleria ) #f) #f] ;"fruta no existe en la galeria"
   ;si hay suficiente, se guarda la informacion de la fruta (nombre,nutriente,galeria) en una lista
   [(> (/ (* (gramosFruta fruta comboGaleria) (aporteByFrutayNutriente fruta nutriente)) 100) (pos nutriente comboComuna tipoPersona))
    (cond
      ;[(write (list fruta)) #t])]
      [(insertarRecomendaciones fruta nutriente comboComuna comboGaleria tipoPersona) #t])]
   [else #f]))

;================================================================================================================================================================

;compara UN SOLO nutriente de la LISTA DE NUTRIENTES de UNA SOLA fruta de la lista FRUTAS con la lista de CARENCIAS

(define (compNutNut nutrienteFruta listaNutrientes fruta comboComuna comboGaleria tipoPersona)
  (cond
    [(empty? listaNutrientes) #f]
    [(equal? nutrienteFruta (car listaNutrientes))
     ; "se ha encontrado"
     (cond
       [(eqv? (aporte fruta nutrienteFruta comboComuna comboGaleria tipoPersona) #t)  #t]
       [else (compNutNut nutrienteFruta (cdr listaNutrientes) fruta comboComuna comboGaleria tipoPersona)]; "no es suficiente aporte de la fruta a la carencia"
       ;si es #t se agrega la fruta y su componente a una lista
       )]
    [else (compNutNut nutrienteFruta (cdr listaNutrientes) fruta comboComuna comboGaleria tipoPersona)]
  ))


;================================================================================================================================================================

;compara los nutrientes de UNA SOLA fruta de la lista FRUTAS con la lista de CARENCIAS

(define (compFrutaNutriente nutrientesFruta listaNutrientes fruta comboComuna comboGaleria tipoPersona)
  (cond
    [(empty? listaNutrientes) #f]
    [(equal? nutrientesFruta '()) #f ]
    [(equal? (compNutNut (car nutrientesFruta) listaNutrientes fruta comboComuna comboGaleria tipoPersona) #f) (compFrutaNutriente (cdr nutrientesFruta) listaNutrientes fruta comboComuna comboGaleria tipoPersona)] ;no está el nutriente
    ;Aqui se haria la insercion de datos a la tabla Recomendaciones
    ;se tiene la fruta, nutriente, comuna, galeria, persona
    [else (compFrutaNutriente (cdr nutrientesFruta) listaNutrientes fruta comboComuna comboGaleria tipoPersona)]
    ;[else (set! variableRes (mostrarFruta comboGaleria comboComuna fruta nutrientesFruta)) (compFrutaNutriente (cdr nutrientesFruta) listaNutrientes fruta comboComuna comboGaleria tipoPersona)]
    ))




;================================================================================================================================================================

;compara UNA SOLA fruta de la lista FRUTAS con la lista Carencias
(define (compFruta fruta listaNutrientes comboComuna comboGaleria tipoPersona)
  (cond
    [(empty? listaNutrientes) #f]
    [(equal? (compFrutaNutriente (nutrienteByFruta fruta) listaNutrientes fruta comboComuna comboGaleria tipoPersona) #t) #t] ; hay unafruta correcta
    [else #f]))

;================================================================================================================================================================
;compara una lista de frutas con la lista de nutrientes
(define (compListaFrutaNut listaFruta listaNutrientes comboComuna comboGaleria tipoPersona)
  (cond
    [(empty? listaFruta) #t ] ;variableRes ] ;"ListaFrutas vacia: esta galeria no tiene frutas para aportar a la comuna"]
    [(empty? listaNutrientes) #t] ; "ListaNutrientes vacia: no hay frutas que tengan los nutrientes en esta galeria que aporten a la comuna"]
    [(equal? (compFruta (car listaFruta) listaNutrientes comboComuna comboGaleria tipoPersona) #t) "se encontró por lo menos una fruta que sirva"]
    [else (compListaFrutaNut (cdr listaFruta) listaNutrientes comboComuna comboGaleria tipoPersona)]))

;sacamos la lista de valores de carencias de la comuna seleccionada
;la lista de frutas que hay en la galeria
(define (carencias tipoPersona comboComuna comboGaleria )  
      (compListaFrutaNut (frutasEnGaleriaByName comboGaleria) (nombreCarenciaComunas tipoPersona comboComuna) comboComuna comboGaleria tipoPersona))

;================================================================================================================================================================

(define (resultadoRecomendaciones tipoPersona comboComuna comboGaleria )
  ;verificamos que la comuna y la galeria no esten vacias
  (cond
    [(equal? (datosComuna comboComuna) 0) #t ];"la comuna no tiene datos"]
    [(equal? (datosGaleria comboGaleria) 0) #t ];"la galeria no tiene datos"]
    ;si la comuna si tiene datos
    ;obtenemos la carencias de esa comuna
    [(carencias tipoPersona comboComuna comboGaleria)]
  ))


(define (resultado comboComuna comboGaleria)
  (cond
    [(equal? (resultadoRecomendaciones "anciano" comboComuna comboGaleria) (resultadoRecomendaciones "niño" comboComuna comboGaleria)) #t]))
;================================================================================================================================================================

;recorre SOLO una COMUNA en la LISTA de GALERIAS
(define (recComunaListaGalerias comuna listaGaleria)
  (cond
    [(empty? listaGaleria) #t]
    [else (eqv? (resultado comuna (car listaGaleria)) #t) (recComunaListaGalerias comuna (cdr listaGaleria))]))

;recorre LISTA DE COMUNA en
(define (recListaComunaListaGaleria listaComuna listaGaleria)
  (cond
    [(empty? listaComuna) "ya no hay mas comunas"]
    ;esta comprueba solo una comuna en la lista de galerias
    [else (eqv? (recComunaListaGalerias (car listaComuna) listaGaleria) #t) (recListaComunaListaGaleria (cdr listaComuna) listaGaleria)]))
    ;corta la cabeza y sigue con el resto de la lista
    ;[else (recListaComunaListaGaleria (cdr listaComuna) listaGaleria)]))

;(recListaComunaListaGaleria getComunasSQL getGaleriasSQL)


(define (exportarDatos lista)
  (cond
    ;recorremos toda la lista de datos
    [(empty? lista) "ya se leyó toda la lista"]
    ;hacemos lo requerido para cada fila
    [(exportarDatos (car lista))]
    ;seguimos con lo que queda de la lista
    [else (exportarDatos (cdr lista))]))


(define out (open-output-file #:exists 'truncate "recomendaciones.txt"))
;(write "holaa\n" out)
(define in (open-input-file "recomendaciones.txt"))


(define ( mostrarDatos datos)
;(writeln (~a "La galeria " (fifth datos) " tiene la fruta " (second datos) " la cual tiene el nutriente "
 ;   (third datos) " suficiente para alimentar a los " (sixth datos) "s de la comuna " (fourth datos))))
  (~a "La galeria " (fifth datos) " tiene la fruta " (second datos) " la cual tiene el nutriente "
   (third datos) " suficiente para alimentar a los " (sixth datos) "s de la comuna " (fourth datos)))



(define (recursivoDatos  listaVector)
  (cond
    [(eqv? listaVector '())]
    [else (writeln (mostrarDatos (vector->list(car listaVector)))  out) (recursivoDatos (cdr listaVector))]))

(define (recomendar) 
  (recListaComunaListaGaleria getComunasSQL getGaleriasSQL)
  ;mostramos las recomendaciones
  (cond
   [(recursivoDatos (query-rows conn "select * from recomendaciones")) (close-output-port out) "se han guardado todos los datos"]))





;(recomendar)



;ahora queremos mostrar toda la lista de datos de la misma manera



;(recursivoDatos (query-rows conn "select * from recomendaciones"))



;(~a "la galeria " (fifth datos) " tiene la fruta " (second datos) " la cual tiene el nutriente "
;    (third datos) " suficiente para alimentar a los " (sixth datos) "s de la comuna " (fourth datos) )






  
 
;================================================================================================================================================================








