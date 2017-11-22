#lang racket
(require racket/gui/base)

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

(define txtPoblacionTotal (new text-field% [parent panel1][label "Población total"]))
(define txtCantidadNinos (new text-field% [parent panel1][label "Cantidad de niños"]))
(define txtCantidadNinosDesnu (new text-field% [parent panel1][label "Cantidad de niños con desnutrición"]))
(define txtCantidadAncianos (new text-field% [parent panel1][label "Cantidad de ancianos"]))
(define txtCantidadAncianosDesnu (new text-field% [parent panel1][label "Cantidad de ancianos con desnutrición"]))
(define btnAgregarComuna(new button%
                        [parent panel1]
                        [enabled #t]
                        [label "AGREGAR COMUNA"]
                        ))


(define msg (new message% [parent panel1]
                          [label "Componente Nutricional (mg)"]))

(define panel2 (new vertical-panel%
                    [alignment '(left top)]
                    [parent comunas-frame]))

(define txtNutriente (new text-field% [parent panel2][label "Nutriente"]))
(define txtPorcentaje (new text-field% [parent panel2][label "Porcentaje en Carencia (%)"]))
(define txtPersonas (new text-field% [parent panel2][label "Cantidad de personas"]))

(define panel3 (new horizontal-panel%
                    [alignment '(center top)]
                    [parent comunas-frame]))

(define btnAgregarNutriente(new button%
                        [parent panel3]
                        [enabled #t]
                        [label "AGREGAR NUTRIENTE"]
                        ))

(define btnEstadisticas(new button%
                        [parent panel3]
                        [enabled #t]
                        [label "GENERAR ESTADISTICAS"]
                        ))


;(send comunas-frame show #t)