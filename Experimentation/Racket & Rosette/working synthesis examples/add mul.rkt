#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches

(define
  (add first second)
  (+ first second)
)

(define
  (mul first second)
  (* first second)
)

(define
  (same)
  (define val (??))
  (assert
   (>= val 2)
  )
  (assert
   (=
    (add val val)
    (mul val val)
   )
  )
)

(define
  (same_manual x)
  (assert
   (=
    (add x x)
    (mul x x)
   )
  )
)

(define-symbolic x integer?)
(define solution
  (synthesize
   #:forall (list x)
   #:guarantee (same)
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