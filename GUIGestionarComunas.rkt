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

(define txtPoblacionTotal (new text-field% [parent panel1](horiz-margin 50)[min-height 10][min-width 150][label "Población total"]))
(define txtCantidadNinos (new text-field% [parent panel1](horiz-margin 50)[min-height 10][min-width 150][label "Cantidad de niños"]))
(define txtCantidadNinosDesnu (new text-field% [parent panel1](horiz-margin 50)[min-height 10][min-width 150][label "Cantidad de niños con desnutrición"]))
(define txtCantidadAncianos (new text-field% [parent panel1](horiz-margin 50)[min-height 10][min-width 150][label "Cantidad de ancianos"]))
(define txtCantidadAncianosDesnu (new text-field% [parent panel1](horiz-margin 50)[min-height 10][min-width 150][label "Cantidad de ancianos con desnutrición"]))

;TODO 1: AGREGAR MENSAJES DE GUARDADO 
(define btnAgregarComuna(new button%
                        [parent panel1]
                        [enabled #t]
                        [label "AGREGAR COMUNA"]
                        [callback (lambda (button event)
                                    (obtieneDatosComuna (send comboComunas get-value) (send txtPoblacionTotal get-value)
                                                             (send txtCantidadNinos get-value) (send txtCantidadNinosDesnu get-value)
                                                             (send txtCantidadAncianos get-value) (send txtCantidadAncianosDesnu get-value)))]))




(define panel2 (new vertical-panel%
                    [alignment '(center top)]
                    [parent comunas-frame]))

(define msg (new message% [parent panel2]
                          [label "Componente Nutricional (mg)"]))

(define comboNutrientes (new combo-field%
                   [choices (list "Potasio" "Calcio" "Magnesio")]
                   [label "Seleccione un Nutriente     "]
                   [init-value "Potasio"]
                   (horiz-margin 50)[min-height 10][min-width 150]
                   [parent panel2]
                   ))
(define txtPorcentaje (new text-field% [parent panel2](horiz-margin 50)[min-height 10][min-width 150][label "Porcentaje en Carencia (%)"]))
(define txtPersonas (new text-field% [parent panel2](horiz-margin 50)[min-height 10][min-width 150][label "Cantidad de personas        "]))
(define comboPersonas (new combo-field%
                   [choices (list "Niños" "Ancianos")]
                   [label "Seleccione un tipo              "]
                   [init-value "Niños"]
                   (horiz-margin 50)[min-height 10][min-width 150]
                   [parent panel2]
                   ))

(define panel3 (new horizontal-panel%
                    [alignment '(center top)]
                    [parent comunas-frame]))

(define btnAgregarNutriente(new button%
                        [parent panel3]
                        [enabled #t]
                        [label "AGREGAR NUTRIENTE"]
                        [callback (lambda (button event)
                                    (obtieneDatosCarencias (send comboNutrientes get-value) 
                                                             (send txtPersonas get-value) (send comboComunas get-value) (send txtPorcentaje get-value)
                                                             (send comboPersonas get-value)))]))

(define btnEstadisticas(new button%
                        [parent panel3]
                        [enabled #t]
                        [label "GENERAR ESTADISTICAS"]
                        ))


(send comunas-frame show #t)