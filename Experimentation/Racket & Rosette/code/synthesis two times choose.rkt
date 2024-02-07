#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches
(require rosette/lib/angelic)

(define (choose_num)
  (choose* 0 1 2 3 4 5)
)

(solve
 (begin
   (define first (choose_num))
   (define second (choose_num))
   (assert
    (and
     (equal? 0 first)
     (equal? 1 second)
     ;;(equal? first second)
    )
   )
 )
)
(display "\n")

; --- Synthesis skeleton start ---
(define-symbolic i1 integer?)
(define-symbolic* i2 integer?)
(define solution
  (synthesize
   #:forall (list i1)
   #:guarantee
    (begin
      (define first (choose_num))
      (define second (choose_num))
      (assert
       (and
         (equal? 0 first)
         (equal? 5 second)
        ;;(equal? first second)
       )
      )
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