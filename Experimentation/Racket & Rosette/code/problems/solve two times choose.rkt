#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches
(require rosette/lib/angelic) ;; Needed for 'choose*'
;;(output-smt (current-output-port))

(define (choose_num)
  (choose* 0 1 2 3 4 5)
)

;;(complete-solution sol)

(define sol1
  (solve
   (begin
     (define first (choose 0 1 2 3))
     (define second (choose 2 3 4))
     
     (assert
      (and
       (equal? 1 first)
       (equal? 2 second)
      )
     )
   )
  )
)
(display "\n")

(display "warum macht er nach #t noch weiter? bzw warum zeigt er nur 5 zeilen an?:\n")
sol1
(display "\n")


(define sol2
  (solve
   (begin
     (define first (choose 0 1 2 3))
     (define second (choose 2 3 4))
     
     (assert
      (and
       (equal? 3 first)
       (equal? 2 second)
      )
     )
   )
  )
)
(display "\n")

(display "Warum verschwindet des #t von 'first' bzw warum zeigts 3 lines first und 2 liens second an?:\n")
sol2
(display "\n")


(define sol3
  (solve
   (begin     
     (define first (choose_num)) 3
     (define second (choose_num)) 2
     (assert
      (and
       (equal? 3 first)
       (equal? 2 second)
      )
     )
   )
  )
)
(display "\n")

(display "Warum fehlt quasi a Zeile für 'second'?:\n")
(display "(Da is a Erklärung in da ToDo Liste)\n")
sol3
(display "\n")
