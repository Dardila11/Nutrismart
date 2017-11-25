#lang racket
(require racket/gui/base)
(require db)
(require "GUIGestionarGalerias.rkt")
(require "GUIGestionarComunas.rkt")

;conexion a la bd
(define conn (mysql-connect #:user "dardila"
               #:database "db_nutrismart"
               #:password "dardila12345"))

;Ingreso a nutrismart

#| Se conecta a la bd de MySQL
   Necesita el email y contraseña para poder ingresar a la aplicacion |#

(define application-frame
  (new frame%
    [label "Nutrismart"]
    [width 400]
    [height 300]))


(define panel1 (new vertical-panel%
                    [alignment '(center center)]
                    [parent application-frame]))

;Cajas de texto email y contraseña

(define txtEmail (new text-field% [parent panel1](vert-margin 20)(horiz-margin 50)[min-height 10][min-width 150][label "Email"]))
(define txtPass (new text-field% [parent panel1](horiz-margin 50)[min-height 10][min-width 150][label "Pass"]))

(define msgRes (new message% [parent panel1][label "Resultado"][min-height 1][min-width 400]))


;button ingresar obtiene datos de los textview
(define btnIngresar(new button%
                        [parent panel1]
                        [label "Ingresar"]
                        [callback (lambda (button event)
                                    (send msgRes set-label (consultaLogin conn (send txtEmail get-value) (send txtPass get-value))))]))

(define panel2 (new horizontal-panel%
                    [alignment '(center center)]
                    [parent application-frame]))

(define btnGalerias(new button%
                        [parent panel2]
                        [enabled #f]
                        [label "Galerias"]
                        [callback (lambda (button event)
                                    (send galerias-frame show #t))]))
(define btnComunas(new button%
                        [parent panel2]
                        [enabled #f]
                        [label "Comunas"]
                        [callback (lambda (button event)
                                    (send comunas-frame show #t))
                                   ]))


(define (consultaLogin conn email pass)
  (cond
    [(eqv? email "") "campo email vacio"]
    [(eqv? pass "")  "campo constraseña vacio"]
    [(cond
       [(query-maybe-row conn consultaSQL1 email pass) (send btnGalerias enable #t) (send btnComunas enable #t) "Ingreso Correcto"])]
       ;[(empty? (consultaSQL conn email pass)) "Usuario Incorrecto"]
       ;si no está vacio, significa que el usuario existe y activa los botones Galeria y Comunas
       ;[(empty? (query-rows conn "SELECT * FROM USERS WHERE usu_email = '$1' and usu_pass = '$2'")) "Usuario Incorrecto"]
       [(boolean? (query-maybe-row conn consultaSQL1 email pass)) "Usuario no existe"]))

;(define (consultaSQL conn usu_email ) (prepare conn "SELECT * FROM USERS WHERE usu_pass = ?"))

(define consultaSQL1 (prepare conn "SELECT * FROM USERS WHERE usu_email = ? and usu_pass = ?"))

(query-maybe-row conn consultaSQL1 "dan@hotmail.com" "dan12345")

;(consultaSQL conn "dan@hotmail.com")

;(query-row conn "SELECT * FROM USERS WHERE usu_email = 'dan@hotmail.com'")
                                              
(send application-frame show #t)

;[(query-rows conn "SELECT * FROM USERS WHERE usu_email = '$1' and usu_pass = '$2'") (send btnGalerias enable #t) (send btnComunas enable #t) "Ingreso Correcto"]
 ;   ))



