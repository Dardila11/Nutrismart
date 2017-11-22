#lang racket
(require racket/gui/base)
(require "Conexion.rkt")
(require db)

(provide obtieneDatosIngresados)

;Insertar datos a la galeria

#| 1. Obtiene el id de la Galeria
   2. Obtiene el id de la fruta
   3. Insertarmos los datos obtenidos a la Tabla DATOSGAL. |#

(define (obtieneDatosIngresados comboGaleria comboFruta txtCantidadIngresa txtCantidaDesperdicia)
  ;realizamos la consulta para obtener el id de la galeria
    ;(format "~v" (query-value conn galeriaIdByName comboGaleria)))
  (query-exec conn insertarDATOSGAL (query-value conn galeriaIdByName comboGaleria) (query-value conn frutaIdByName comboFruta) txtCantidadIngresa txtCantidaDesperdicia))



;consulta para obtener el id de la galeria
(define galeriaIdByName (prepare conn "SELECT gal_id FROM GALERIAS WHERE gal_nombre = ?"))
;(query-value conn galeriaIdByName "Bolivar")

;consulta para obtener el id de la fruta
(define frutaIdByName (prepare conn "SELECT fru_id FROM FRUTAS WHERE fru_nombre = ?"))
;(query-value conn frutaIdByName "Banano")

;insertar datos en la tabla DATOSGAL
(define insertarDATOSGAL (prepare conn "INSERT INTO DATOSGAL(gal_id,fru_id,dat_ingresa,dat_desperdicia) VALUES(?,?,?,?)"))
;(query-exec conn insertarDATOSGAL (query-value conn galeriaIdByName "Bolivar") (query-value conn frutaIdByName "Banano") "20" "40")



