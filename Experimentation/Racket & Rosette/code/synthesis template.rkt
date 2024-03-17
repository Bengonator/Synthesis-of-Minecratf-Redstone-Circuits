#lang rosette

(require rosette/lib/synthax) ;; defining holes in sketches
(require rosette/lib/destruct) ;; 
(require rosette/lib/value-browser) ;; better model printing
(require rosette/lib/angelic) ;; for choose*

(error-print-width 1000) ;; Show more symbolic values in print
;;(output-smt (current-output-port)) ;; Print SMT output to console



; --- Synthesis skeleton start ---
(define-symbolic i1 integer?)
(define-symbolic* i2 integer?)
(define solution
  (synthesize
   #:forall (list i1)
   #:guarantee
    (begin
      (assert
       
      )
    )
  )
)
(display "\n")

(if (sat? solution)
    (begin
      (display "Display Solution:\n")
      (display solution)
      (display "\n")
      (display "\n")
      (display "Generate Forms:\n")
      (generate-forms solution)
    )
    (display "UNSAT")
)
; --- Synthesis skeleton end ---