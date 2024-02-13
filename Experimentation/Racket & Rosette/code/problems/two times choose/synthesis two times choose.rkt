#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches
(require rosette/lib/angelic) ;; Needed for 'choose*'
;;(output-smt (current-output-port))

(define (choose_num)
  (choose* 0 1 2 3 4 5)
)

(define sol
  (solve
   (begin
     (define first (choose 0 1 2 3))
     (define second (choose 2 3 4))
     (assert
      (and
       (equal? 0 first)
       (equal? 3 second)
      )
     )
   )
  )
)
(display "\n")

(display "Solve sol:\n")
sol
(display "\n")

; --- Synthesis skeleton start ---
(define-symbolic i1 integer?)
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
       )
      )
    )
  )
)
(display "\n")

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