#lang racket
(require racket/gui/base)

(require "NuevaFruta.rkt")
(require "Recomendaciones.rkt")

(provide nuevaFruta-frame)

(define nuevaFruta-frame
  (new frame%
    [label "Agregar Fruta - Nutrismart"]
    [width 600]
    [height 400]))

(define panel1 (new vertical-panel%
                    [alignment '(center center)]
                    [parent nuevaFruta-frame]))

(define txtFrutaIngresa (new text-field% [parent panel1](vert-margin 20)(horiz-margin 50)[min-height 10][min-width 150][label "Fruta que ingresa"]))
(define btnAgregarFruta(new button%
                        [parent panel1]
                        [enabled #t]
                        [label "AGREGAR FRUTA"]
                        [callback (lambda (button event)
                                    (send msgRes set-label (insertarNuevaFruta (send txtFrutaIngresa get-value))))]))

(define msgRes (new message% [parent panel1][label "Resultado"][min-height 1][min-width 400]))
                        



(define panel3 (new vertical-panel%
                    [alignment '(center center)]
                    [parent panel1]))

(define msg (new message% [parent panel3]
                          [label "Componente Nutricional (mg)"]))

(define txtNutriente (new combo-field%
                   [choices getNutrientesSQL]
                   [label "Nutriente"]               
                   (horiz-margin 50)[min-height 10][min-width 150]
                   [parent panel3]
                   ))
(define txtAporte (new text-field% [parent panel3](horiz-margin 50)[min-height 10][min-width 150][label "Aporte (mg)"]))
;(define txtNutriente (new text-field% [parent panel3](horiz-margin 50)[min-height 10][min-width 150][label "Nutriente"]))
(define btnAgregar(new button%
                        [parent panel3]
                        [enabled #t]
                        [label "AGREGAR COMPONENTE"]
                        [callback (lambda (button event)
                                    (send msgResNut set-label (insertarNutriente (send txtNutriente get-value) (send txtAporte get-value) (send txtFrutaIngresa get-value))))]))

(define msgResNut (new message% [parent panel3]
                          [min-height 1][min-width 400]
                          [label "Resultado"]))

(define panel4 (new vertical-panel%
                    [alignment '(center center)]
                    [parent panel1]))

(define btnVolver(new button%
                        [parent panel4]
                        [enabled #t]
                        [label "VOLVER"]
                        [callback (lambda (button event)
                                   (send nuevaFruta-frame show #f))]))



;(send nuevaFruta-frame show #t)



