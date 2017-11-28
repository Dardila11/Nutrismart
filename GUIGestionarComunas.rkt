#lang racket
(require racket/gui/base)
(require "GestionarComunas.rkt")

(provide comunas-frame)

;TODO 1. Construir todo  el GUI para gestionar Comunas
;     2. FECHA LIMITE MARTES 21 18:00

(define comunas-frame
  (new frame%
    [label "Gestionar Comunas - Nutrismart"]
    [width 700]
    [height 600]))

(define panel1 (new vertical-panel%
                    [parent comunas-frame]))

(define comboComunas (new combo-field%
                   [choices (list "Comuna1" "Comuna2" "Comuna3" "Comuna4")]
                   [label "Seleccione la Comuna asignada"]
                   [init-value "Comuna1"]
                   (vert-margin 20)(horiz-margin 50)[min-height 10][min-width 150]
                   [parent panel1]
                   ))


(define panel2 (new vertical-panel%
                    [alignment '(center top)]
                    [parent comunas-frame]))

(define msg (new message% [parent panel2]
                          [label "Componente Nutricional (mg)"]))

(define msgRes (new message% [parent panel2]
                          [label "Resultado"]))

(define comboNutrientes (new combo-field%
                   [choices (list "Potasio" "vitaminaC" "Magnesio")]
                   [label "Seleccione un Nutriente     "]
                   [init-value "Potasio"]
                   (horiz-margin 50)[min-height 10][min-width 150]
                   [parent panel2]
                   ))
(define txtPorcentaje (new text-field% [parent panel2](horiz-margin 50)[min-height 10][min-width 150][label "Porcentaje en Carencia (%)"]))
(define txtPersonas (new text-field% [parent panel2](horiz-margin 50)[min-height 10][min-width 150][label "Cantidad de personas        "]))
(define comboPersonas (new combo-field%
                   [choices (list "Niño" "Anciano")]
                   [label "Seleccione un tipo              "]
                   [init-value "Niño"]
                   (horiz-margin 50)[min-height 10][min-width 150]
                   [parent panel2]
                   ))

(define panel3 (new horizontal-panel%
                    [alignment '(center top)]
                    [parent comunas-frame]))

(define btnAgregarNutriente(new button%
                        [parent panel3]
                        [enabled #t]
                        [label "AGREGAR CARENCIA"]
                        [callback (lambda (button event)
                                    (obtieneDatosCarencias (send comboNutrientes get-value) 
                                                             (send txtPersonas get-value) (send comboComunas get-value) (send txtPorcentaje get-value)
                                                             (send comboPersonas get-value)))]))

                        


(send comunas-frame show #t)