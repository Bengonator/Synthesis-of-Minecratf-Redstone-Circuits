#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches

(define (add first second)
  (+ first second)
)

(define
  (mul first second)
  (* first second)
)

(define (same var sym)
  (assert
   (=
    (* sym (add var var))
    (* sym (mul var var))
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
     (same y x)
   )
  )
)

(if (sat? solution)
    (begin
      (display solution)
      (display "\n")
      (display "\n")
      (generate-forms solution)
    )
    (display "UNSAT")
)