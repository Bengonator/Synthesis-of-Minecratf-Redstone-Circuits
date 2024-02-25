#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches

(define (update_nb in neighbours)
  (display "in: ")
  (display in)
  (display "\n")
  ;; print world in a way, that zeros are invisible 
  ;; and digits have a trailing space
  (display "-")
  (for ([i nCols])
      (display "-----")
  )
  (display "\n")
  
  (for ([row_idx (range nRows)])
    (display "| ")
    
    (for ([col world])
      (define num (list-ref col row_idx))
      (when (< num 10)
        (display " ")
      )
      ;;(if (eq? num 0)
      ;;    (display " ")
          (display num)
      ;;)
      (display " | ")
    )
    (display "\n")

    (display "-")
    (for ([i nCols])
      (display "-----")
    )
    (display "\n")
  )
  (display "\n")

  ;; actual redstone spread
  (if (and
       (integer? in)
       (list? neighbours)
       (not (null? neighbours))
      )
      (begin
        (for ([nb neighbours])
          (define nb_col_idx (list-ref nb 0))
          (define nb_row_idx (list-ref nb 1))
          
          (if (and
               (> nb_col_idx -1)
               (< nb_col_idx nCols)
               (> nb_row_idx -1)
               (< nb_row_idx nRows)
              )
              (begin
                (when (<
                       (list-ref
                        (list-ref world nb_col_idx)
                        nb_row_idx
                       )
                       in
                      )
                  (set! world
                        (list-set world
                                  nb_col_idx
                                  (list-set
                                   (list-ref world nb_col_idx)
                                   nb_row_idx
                                   (- in 1)
                                  )
                        )
                  )
                  
                  ;; call recursively to progress redstone spread
                  (when (> in 0)
                    (update_nb
                     (- in 1)
                     (list
                      (list nb_col_idx (- nb_row_idx 1))
                      (list (+ nb_col_idx 1) nb_row_idx)
                      (list nb_col_idx (+ nb_row_idx 1))
                      (list (- nb_col_idx 1) nb_row_idx)
                     )
                    )
                  )
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

(define size (list 5 5))
(define src (list 1 3))

(define nCols (list-ref size 0))
(define nRows (list-ref size 1))
(define src_col_idx (list-ref src 0))
(define src_row_idx (list-ref src 1))

(define world
  (build-list
   nCols
   (lambda
     (x)
     (build-list nRows (lambda (x) 0))
   )
  )
)

(display "Start:\n")
(display world)
(display "\n\n")

(set! world
      (list-set world
                src_col_idx
                (list-set
                 (list-ref world src_col_idx)
                 src_row_idx
                 15
                )
      )
)

(update_nb
 (list-ref (list-ref world src_col_idx) src_row_idx)
 (list
  (list src_col_idx (- src_row_idx 1))
  (list (+ src_col_idx 1) src_row_idx)
  (list src_col_idx (+ src_row_idx 1))
  (list (- src_col_idx 1) src_row_idx)
 )
)

(display "\nEnd:\n")
(display world)
(display "\n\n")
