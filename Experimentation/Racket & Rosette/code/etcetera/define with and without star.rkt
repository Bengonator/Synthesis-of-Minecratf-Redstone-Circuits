#lang rosette

;; using the * but assigning var before loop, will make it act like without *
(define (always-different)
    (define-symbolic* x integer?)
    x
)

(eq? (always-different)(always-different))

(define t1 (always-different))
(define t2 (always-different))

(for ([i (in-range 3)])
  (display i)
  (display "\n")
  (display t1)
  (display "\n")
  (display t2)
  (display "\n")
  (display "\n")
)
