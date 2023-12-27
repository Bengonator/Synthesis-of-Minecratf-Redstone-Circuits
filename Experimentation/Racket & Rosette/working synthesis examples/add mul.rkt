#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches

(define (add first second)
  (+ first second)
)

(define
  (mul first second)
  (* first second)
)

(define (same x)
  (assert
   (=
    (add x x)
    (mul x x)
   )
  )
)

(define-symbolic x y integer?)
(define solution
  (synthesize
   #:forall (list x)
   #:guarantee
   (begin
     (assume (> y 0)) ;; unsat if (> y 2), as only 0 and 2 can be solutions (obviously)
     (same y)
   )
  )
)

(if (sat? solution)
    (begin
      (display solution)
      (display "\n")
      (display "\n")
      (print-forms solution)
    )
    (display "UNSAT")
)