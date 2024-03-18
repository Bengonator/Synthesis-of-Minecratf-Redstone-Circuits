#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches

(define (nl) (display "\n"))


(require rosette/lib/angelic)  ;; choose*
(solve
 (assert 
 (choose*
  (eq? 7 7)
  (eq? 15 715)
  ;;(assert (eq? val (- (apply max 1 nbs) 1)))
  )
 )
)

;; (define-symbolic var integer?)
;; (define-symbolic var2 integer?)
;; (vc)
;; (assert (eq? 5 var))
;; (vc)
;; 
;; (solve (assert (eq? 50 var2)))
;; (vc)


;; ; --- Synthesis skeleton start ---
;; (define-symbolic x integer?)
;; (define solution
;;   (synthesize
;;    #:forall (list x)
;;    #:guarantee
;;     (begin
;; ;;       (define multi (??))
;; ;;       (assert (even? (* multi x)))
;; ;;       (assert (> multi 0))
;;       
;;       (assume (> x 1))
;;       (assert (> x 0))
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
;;  ; --- Synthesis skeleton end ---
