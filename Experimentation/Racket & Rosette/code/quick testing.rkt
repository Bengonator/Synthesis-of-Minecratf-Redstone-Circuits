#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches

(define (nl) (display "\n"))




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
