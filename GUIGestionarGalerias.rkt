#lang racket
(require racket/gui/base)

(provide galerias-frame)
(require "GUINuevaFruta.rkt")
(require "GestionarGalerias.rkt")
(require "Recomendaciones.rkt")

(define galerias-frame
  (new frame%
    [label "Gestionar Galerias - Nutrismart"]
    [width 600]
    [height 400]))


(define comboGalerias (new combo-field%
                   [choices getGaleriasSQL]
                   [label "Seleccione la galeria"]               
                   (vert-margin 10)(horiz-margin 50)[min-height 10][min-width 150]
                   [parent galerias-frame]
                   ))

(define panel1 (new vertical-panel%
                    [min-width 100][min-height 10]
                    [parent galerias-frame]))


(define comboFrutas (new combo-field%
                   [choices getFrutasSQL]         
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
                                    (send msgRes set-label (obtieneDatosIngresados (send comboGalerias get-value) (send comboFrutas get-value)
                                                             (send txtCantidadIngresa get-value) (send txtCantidadDesperdicia get-value))))]))

(define btnAgregarFruta(new button%
                        [parent panel2]
                        [enabled #t]
                        [label "AGREGAR NUEVA FRUTA"]
                        [callback (lambda (button event)
                                    (send nuevaFruta-frame show #t))]))


;(send galerias-frame show #t)



