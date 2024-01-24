#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches


;(define test (block 1 2 5))
;(block-x test)
;(define newer (struct-copy block test [x 4]))
;(block-x newer)

; --- change value of 2d Array ---
; (define XX 0)
; (define YY 1)
; (define val 5)
; 
; (define grid (list (list 1 2) (list 8 9)))
; (displayln grid)
; 
; (define row (list-ref grid XX))
; (displayln row)
; 
; (define row_changed (list-set row YY val))
; (displayln row_changed)
; 
; (define grid_changed (list-set grid XX row_changed))
; (displayln grid_changed)
; 
;(define (changeValue x y value)
;  (define lenR (length grid)
;  (define lenC (length (list-ref grid 0))))
;
;  (for ([r lenR])
;    (for ([c lenC])
;      (if (and
;           (= r x)
;           (= c y)
;          )
;          (
;      )
;    )
;  )
;)


(define (adding num)
  (for ([i (in-range 6)])
    (display i)
    (if (odd? i)
        (display " odd")
        (display " even")
    )
    (display "\n")
  )
)

; --- Synthesis skeleton ---
(define-symbolic b1 boolean?)
(define-symbolic* b2 boolean?)
(define solution
  (synthesize
   #:forall (list b1)
   #:guarantee
    (begin
       (assert (and
                 (or b1 b2)
                 (or (not b1) b2)
               )
       )
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
