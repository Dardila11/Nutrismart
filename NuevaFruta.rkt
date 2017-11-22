#lang racket

(require racket/gui/base)
(require "Conexion.rkt")
(require db)

(provide insertarNuevaFruta)
(provide insertarNutriente)

;insertar nueva fruta

(define (insertarNuevaFruta txtNombreFruta)
  (query-exec conn insertarfruta txtNombreFruta))

;insertar nueva fruta en la tabla FRUTAS
(define insertarfruta (prepare conn "INSERT INTO FRUTAS(fru_nombre) VALUES(?)"))

;insertarmos los nutrientes de la fruta

#| 1. para ello necesitamos el id de la nueva fruta
   2. e insertarmos los datos del nutriente
   TODO el nutriente deberia estar en comboBox |#

(define (insertarNutriente txtNombre txtAporte txtIdFruta)
  (query-exec conn insertarNutrientes txtNombre txtAporte (query-value conn frutaIdByName txtIdFruta)))

;consulta para obtener el id de la fruta
(define frutaIdByName (prepare conn "SELECT fru_id FROM FRUTAS WHERE fru_nombre = ?"))
;(query-value conn galeriaIdByName "Bolivar")

;insertar datos en la tabla NUTRIENTES
(define insertarNutrientes (prepare conn "INSERT INTO NUTRIENTES(nut_nombre,nut_aporte,fru_id) VALUES(?,?,?)"))
;(query-exec conn insertarDATOSGAL (query-value conn galeriaIdByName "Bolivar") (query-value conn frutaIdByName "Banano") "20" "40")