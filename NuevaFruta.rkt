#lang racket

(require racket/gui/base)
(require "Conexion.rkt")
(require db)

(provide insertarNuevaFruta)
(provide insertarNutriente)

;insertar nueva fruta
(define (insertarNuevaFruta txtNombreFruta)
  (query-exec conn insertarfruta txtNombreFruta) "Fruta ingresada correctamente")

;insertar nueva fruta en la tabla FRUTAS
(define insertarfruta (prepare conn "INSERT INTO FRUTAS(fru_nombre) VALUES(?)"))

;insertarmos los nutrientes de la fruta

#| 1. para ello necesitamos el id de la nueva fruta
   2. e insertarmos los datos del nutriente
   TODO el nutriente deberia estar en comboBox |#

(define (insertarNutriente txtNombre txtAporte txtIdFruta)
  (query-exec conn insertarNutrientes (query-value conn nutrienteIdByName txtNombre) txtAporte (query-value conn frutaIdByName txtIdFruta)) " Nutriente ingresado correctamente")

;consulta para obtener el id de la fruta
(define frutaIdByName (prepare conn "SELECT fru_id FROM FRUTAS WHERE fru_nombre = ?"))

;consulta para obtener el id del nutriente
(define nutrienteIdByName (prepare conn "SELECT nut_id FROM NUTRIENTES WHERE nut_nombre = ?"))

;insertar datos en la tabla NUTRIENTES
(define insertarNutrientes (prepare conn "INSERT INTO DATOSNUT(nut_id,nut_aporte,fru_id) VALUES(?,?,?)"))