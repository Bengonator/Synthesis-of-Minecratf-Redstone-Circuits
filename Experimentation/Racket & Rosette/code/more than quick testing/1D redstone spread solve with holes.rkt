#lang rosette

(require rosette/lib/synthax) ;; defining holes in sketches
(require rosette/lib/destruct) ;; 
(require rosette/lib/value-browser) ;; better model printing

(error-print-width 1000) ;; Show more symbolic values in print

(define source (list (??)));; (??) (??)))
(define start 0)
(define len 30)

(define world (list))

(for ([i (in-range len)])
  (define-symbolic* sym_int integer?)
  (set! world (append world (list sym_int))))

(display world)
(display "\n\n")

(for ([i (in-range len)])
  (define w (if (eq? i start) -1 (list-ref world (- i 1))))
  (define m (list-ref world i))
  (define e (if (eq? i (- len 1)) -1 (list-ref world (+ i 1))))
  
  (assert (<= m 15))
  
  (cond
    [(member i source)(assert (eq? m 15))]
    [(eq? i start)(assert (eq? m (- e 1)))]
    [(eq? i len)(assert (eq? m (- w 1)))]
    [else (assert (eq? m (max 0 (- w 1) (- e 1))))])
  )

(assert
 (and
  ;;(eq? (list-ref world 0) 14)
  ;;(eq? (list-ref world 9) 11)
  (eq? (list-ref world 0) 7)))


(solve (vc))



