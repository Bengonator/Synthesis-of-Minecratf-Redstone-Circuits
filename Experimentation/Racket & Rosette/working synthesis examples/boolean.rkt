#lang rosette

;; Import library for defining holes in sketches
(require rosette/lib/synthax)

(define (first b1)
  (assert (or b1 (not (?? boolean?)))
  )
)

(define (second b1)
  (assert (or b1 (?? boolean?)))
  ;;(assert (or b1 b1)) ;; unsat when this line is not commented out (obviously)
)

(define (same b1)  
  (first b1)  
  (second b1)
  
)

;; Synthesis problem
(displayln "starting ...")
(define-symbolic b1 boolean?)
;; (define-symbolic b2 boolean?)
(define solution
  (synthesize
   #:forall (list b1) ;; forall x ...
   #:guarantee (same b1)))

(if (sat? solution)
    (begin
      (print solution)
      (display "\n")
      (display "\n")
      (print-forms solution)
    )
    (print "UNSAT")
 )