#lang racket
(require racket/gui/base)

(provide galerias-frame)
(require "GUINuevaFruta.rkt")
(require "GestionarGalerias.rkt")

(define galerias-frame
  (new frame%
    [label "Gestionar Galerias - Nutrismart"]
    [width 600]
    [height 400]))

;TODO 1. Construir todo (incluyendo los GUI para las frutas) el GUI para gestionar Galerias
;     2. FECHA LIMITE MARTES 21 12:00

(define comboGalerias (new combo-field%
                   [choices (list "Bolivar" "Esmeralda")]
                   [label "Seleccione la galeria asignada"]
                   [init-value "Bolivar"]
                   (vert-margin 20)(horiz-margin 50)[min-height 10][min-width 150]
                   [parent galerias-frame]
                   ))

(define panel1 (new vertical-panel%
                    [min-width 100][min-height 10]
                    [parent galerias-frame]))


(define comboFrutas (new combo-field%
                   [choices (list "Banano" "Papaya" "Manzana" "Naranja")]
                   [init-value "Banano"]
                   [label "Seleccione la fruta"]
                   (horiz-margin 50)[min-height 10][min-width 150]
                   [parent panel1]
                   ))


;Cajas de texto

(define txtCantidadIngresa (new text-field% [parent panel1](horiz-margin 50)[min-height 10][min-width 150][label "Cantidad que ingresa (g)"]))
(define txtCantidadDesperdicia (new text-field% [parent panel1](horiz-margin 50)[min-height 10][min-width 150][label "Cantidad desperdiciada (g)"]))

;mensaje

(define msgRes (new message% [parent panel1][label "Resultado"][min-height 1][min-width 400]))

(define panel2 (new horizontal-panel%
                    [alignment '(center top)]
                    [parent galerias-frame]))

;TODO 1: AGREGAR MENSAJES DE GUARDADO

(define btnGuardar(new button%
                        [parent panel2]
                        [enabled #t]
                        [label "GUARDAR"]
                        [callback (lambda (button event)
                                    (obtieneDatosIngresados (send comboGalerias get-value) (send comboFrutas get-value)
                                                             (send txtCantidadIngresa get-value) (send txtCantidadDesperdicia get-value)))]))

(define btnAgregarFruta(new button%
                        [parent panel2]
                        [enabled #t]
                        [label "AGREGAR NUEVA FRUTA"]
                        [callback (lambda (button event)
                                    (send nuevaFruta-frame show #t))]))


(send galerias-frame show #t)



