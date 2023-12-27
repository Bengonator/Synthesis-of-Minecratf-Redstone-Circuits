#lang rosette

(require rosette/lib/synthax)


(define (left)
  (choose 92 (* (choose 8 2 4) 3) 45)
)

(define (right)
  (choose 4 6 23 14 13 52)
)

; --- Synthesis skeleton ---
(define-symbolic x c integer?)
(define solution
  (synthesize
   #:forall (list x)
   #:guarantee
    (begin
       (assert (= (left) (right)))
    )
  )
)

(if (sat? solution)
    (begin
      (print solution)
      (display "\n")
      (display "\n")
      (print-forms solution)
    )
    (display "UNSAT")
)