#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches

(define (nl) (display "\n"))

(define (test op)
  (when (index-of (list + -) op)
    (op 4 9)))

(test -)

;; (or "b" "txt" "tct")
;; 
;; (eq? "tct" (or "tct" "txt"))

;; 
;; (define (fun op a b)
;;   (op a b))
;; 
;; 
;; (fun + 5 7)
  

;; (string-append "test" "" "fg")
;; 
;; (display (format "\n			/setblock  ~~~a ~~~a ~~~a" 5 5 9))

;; 
;; (define command_start
;;   "/summon falling_block ~ ~1 ~ {BlockState:{Name:redstone_block},Passengers:[
;; 	{id:armor_stand,Health:0,Passengers:[
;;                 {id:falling_block,BlockState:{Name:activator_rail},Passengers:[")
;;     
;; (define command_blocks "
;; 			setblocks")
;; 
;; (define command_end ",
;; 			{id:command_block_minecart,Command:'setblock ~ ~1 ~ command_block{auto:1,Command:\"fill ~ ~ ~ ~ ~-3 ~ air\"}'},
;; 			{id:command_block_minecart,Command:'kill @e[type=command_block_minecart,distance=..1]'}
;; 		]}
;; 	]}
;; ]}")
;; 
;; (display (string-append command_start command_blocks command_end))
;; 

;; (define (outer)
;;   (display "outer")

;; (display (apply max (list )))

;; ((lambda (x) (* 2 x))
;; 4)

;; (define WORLD_BLOCKS (list "ai" "rb" "rb" "tw" "ai"))
;; 
;; 
;; (length
;;  (filter
;;   (lambda (x) (index-of (list 1 2 3 4 5 6 7) x))
;;   WORLD_BLOCKS))

;; (define s "Apple")
;; (string-set! s 4 "y")
;; s

;; (define str "+-")
;; 
;; (define ch (string-ref str 0))
;; 
;; (display (string-append " " (string ch)))

;; (require rosette/lib/angelic)  ;; choose*
;; (solve
;;  (assert 
;;  (choose*
;;   (eq? 7 7)
;;   (eq? 15 715)
;;   ;;(assert (eq? val (- (apply max 1 nbs) 1)))
;;   )
;;  )
;; )
;; 
;; (define-symbolic var integer?)
;; (define-symbolic var2 integer?)
;; (vc)
;; (assert (eq? 5 var))
;; (vc)
;; 
;; (solve (assert (eq? 50 var2)))
;; (vc)
;; (solve vc)
;; (solve (vc))


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
