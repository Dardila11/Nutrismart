#lang racket
(require racket/gui/base)
(require "Recomendaciones.rkt")
(require db)
(require "Conexion.rkt")

(define recomendaciones-frame
  (new frame%
    [label "Recomendaciones - Nutrismart"]
    [width 300]
    [height 300]))

(define panel1 (new horizontal-panel%
                    [alignment '(center top)]
                    (vert-margin 10)(horiz-margin 50)[min-height 1][min-width 150]
                    [parent recomendaciones-frame]))


(define comboComunas (new combo-field%
                   [choices (list "Comuna1" "Comuna2" "Comuna3" "Comuna4")]
                   [label "Comunas"]
                   [init-value "Comuna1"]
                   (horiz-margin 50)[min-height 10][min-width 150]
                   [parent panel1]
                   ))
(define comboGalerias (new combo-field%
                   [choices (list "Bolivar" "Esmeralda")]
                   [label "Galerias"]
                   [init-value "Bolivar"]
                   (horiz-margin 50)[min-height 10][min-width 150]
                   [parent panel1]
                   ))

(define panel2 (new vertical-panel%
                    [alignment '(center top)]
                    [parent recomendaciones-frame]))

(define btnEstadisticas(new button%   
                        [parent panel2]
                        [enabled #t]
                        [label "GENERAR RECOMENDACIONES"]
                        [callback (lambda (button event)
                                    (resultado (send comboComunas get-value) (send comboGalerias get-value)))])
                        
                        )

(define msgRes (new message% [parent panel2]
                          [label "Resultado"]))


(send recomendaciones-frame show #t)


;============================================== LOGICA ===================================================






