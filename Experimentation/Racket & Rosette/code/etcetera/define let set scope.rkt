#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches


(define var 1)
(display "var außen vorher: ")
(display var)
(display "\n")
(display "\n")

;; when [var ] then display takes this value. When different name then outer value
(let ([vxar 2])
  (display "var innen vor set!: ")
  (display var)
  (display "\n")
  
  (set! var 3)
  (display "var innen nach set!: ")
  (display var)
)
(display "\n")
(display "\n")

(display "var außen nacher aber vor set!: ")
(display var)
(display "\n")
(set! var 4)
(display "var außen nacher und nach set!: ")
(display var)
(display "\n")
(display "\n")

(define-symbolic x integer?)
(define solution
  (synthesize
   #:forall (list x)
   #:guarantee
    (begin
      (display "var in synthesis und vor set!: ")
      (display var)
      (display "\n")
      (set! var 5)
      (display "var in synthesis und nach set!: ")
      (display var)
      (display "\n")
      (display "\n")

      ;; actual synthesis is not important for testing of scopes
      (define multi (??))
      (assert (even? (* multi x)))
      (assert (> multi 0))
    )
  )
)

(display "var außen nach synthesis: ")
(display var)
(display "\n")
(display "\n")
