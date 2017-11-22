#lang racket
(require db)
(provide conn)

(define conn (mysql-connect #:user "dardila"
               #:database "db_nutrismart"
               #:password "dardila12345"))