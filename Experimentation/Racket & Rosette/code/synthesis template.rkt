#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches


; --- Synthesis skeleton start ---
(define-symbolic i1 integer?)
(define-symbolic* i2 integer?)
(define solution
  (synthesize
   #:forall (list i1)
   #:guarantee
    (begin
      
    )
  )
)

(if (sat? solution)
    (begin
      (display "Display Solution:\n")
      (display solution)
      (display "\n")
      (display "\n")
      (display "Generate Forms:\n")
      (generate-forms solution)
    )
    (display "UNSAT\n")
)
; --- Synthesis skeleton end ---