#lang racket
(require racket/gui/base)

(require "NuevaFruta.rkt")

(provide nuevaFruta-frame)

(define nuevaFruta-frame
  (new frame%
    [label "Agregar Fruta - Nutrismart"]
    [width 600]
    [height 400]))

(define panel1 (new vertical-panel%
                    [alignment '(center center)]
                    [parent nuevaFruta-frame]))

(define txtFrutaIngresa (new text-field% [parent panel1][label "Fruta que ingresa"]))
(define btnAgregarFruta(new button%
                        [parent panel1]
                        [enabled #t]
                        [label "AGREGAR FRUTA"]
                        [callback (lambda (button event)
                                    (insertarNuevaFruta (send txtFrutaIngresa get-value)))]))
                        

(define msg (new message% [parent panel1]
                          [label "Componente Nutricional (mg)"]))

(define panel3 (new horizontal-panel%
                    [alignment '(center center)]
                    [parent panel1]))


(define txtAporte (new text-field% [parent panel3][label "Aporte (mg)"]))
(define txtNutriente (new text-field% [parent panel3][label "Nutriente"]))
(define btnAgregar(new button%
                        [parent panel3]
                        [enabled #t]
                        [label "AGREGAR COMPONENTE"]
                        [callback (lambda (button event)
                                    (insertarNutriente (send txtNutriente get-value) (send txtAporte get-value) (send txtFrutaIngresa get-value)))]))


;(send nuevaFruta-frame show #t)



