#lang rosette
;; Import library for defining holes in sketches
(require rosette/lib/synthax)

;;Original function: polynomial
(define (poly x)
   (+ (* 1 x x x) (* -1 x x) (* -2 x))
)

;; Target: factored polynomial
(define (factored x)
  (* (+ x 1) (- x (??)) x)
)

;; Expressing the synthesis probLem
;; We want forall x integer, (poly x) = (factored x)
(define (same p f x)  
  (assert (= (p x) (f x)))
)

;; Synthesis problem
(displayln "starting ...")
(define-symbolic x integer?) ;; Define symbolic x, represents any integer
(define solution
  (synthesize
   #:forall (list x) ;; forall x ...
   #:guarantee (same poly factored x)))

(if (sat? solution)
    (begin
      (print solution)
      (display "\n")
      (display "\n")
      (print-forms solution)
    )
    (print "UNSAT")
 )