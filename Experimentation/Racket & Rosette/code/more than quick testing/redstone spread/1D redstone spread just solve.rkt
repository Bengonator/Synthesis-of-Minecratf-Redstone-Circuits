#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches

(define-symbolic i0 integer?)
(define-symbolic i1 integer?)
(define-symbolic i2 integer?)
(define-symbolic i3 integer?)
(define-symbolic i4 integer?)
(define-symbolic i5 integer?)

(define world (list i0 i1 i2 i3 i4 i5))

(display world)
(display "\n\n")

(define source (list (??) (??)))
(define start 0)
(define end 6)

(for ([i (in-range end)])
  (define w (if (eq? i start) -1 (list-ref world (- i 1))))
  (define m (list-ref world i))
  (define e (if (eq? i (- end 1)) -1 (list-ref world (+ i 1))))

  (assert (< m 16))
  
  (cond
    [(member i source)(assert (eq? m 15))]
    [(eq? i start)(assert (eq? m (- e 1)))]
    [(eq? i end)(assert (eq? m (- w 1)))]
    [else (assert (eq? m (max (- w 1) (- e 1))))])
  )

(assert
 (and
  (eq? (list-ref world 0) 14)
  (eq? (list-ref world 5) 13)))

(solve (vc))





