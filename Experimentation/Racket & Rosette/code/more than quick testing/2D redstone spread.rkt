#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches

(define (update_nb in neighbours)
  ;; print world in a way, that zeros are invisible 
  ;; and digits have a trailing space
  (display "(")
  (for ([num world])
    (when (< num 10)
      (display " ")
    )
    (if (eq? num 0)
        (display " ")
        (display num)
    )
    (display " ")
  )
  (display ")")
  (display "\n")

  ;; actual redstone spread
  (if (and
       (integer? in)
       (list? neighbours)
       (not (null? neighbours))
      )
      (begin        
        (for ([nb neighbours])
          (if (and
               (> nb -1)
               (< nb (length world))
              )
              (begin
                (when (<
                       (list-ref world nb)
                       in
                      )
                  (set! world
                        (list-set world nb (- in 1))
                  )
                  
                  ;; call recursively to progress redstone spread
                  (update_nb (- in 1) (list (- nb 1) (+ nb 1)))
                )
              )
              
              ;; else
              (begin
                (display "do nothing, out of bounds for: ")
                (display nb)
                (display "\n")
              )
          )        
        )
      )
      
      ;; else
      (display "wrong input\n")
  )
)

(define size 30)
(define source 13)

(define world (build-list size (lambda (x) 0)))
(display "Start:\n")
(display world)
(display "\n\n")

(set! world (list-set world source 15))
(update_nb (list-ref world source) (list (- source 1) (+ source 1)))

(display "\nEnd:\n")
(display world)
(display "\n")

;; ; --- Synthesis skeleton start ---
;; (define-symbolic x integer?)
;; (define solution
;;   (synthesize
;;    #:forall (list x)
;;    #:guarantee
;;     (begin
;;
;;     )
;;   )
;; )
;; 
;; (if (sat? solution)
;;     (begin
;;       (display "Display Solution:\n")
;;       (display solution)
;;       (display "\n")
;;       (display "\n")
;;       (display "Generate Forms:\n")
;;       (generate-forms solution)
;;     )
;;     (display "UNSAT\n")
;; )
;; ; --- Synthesis skeleton end ---
