#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches

(define (get_neighbours cell)
  (if (and
       (list? cell)
       (not (null? cell))
      )
      (begin
        (define col (list-ref cell 0))
        (define row (list-ref cell 1))

        (list
         (list col (- row 1))
         (list (+ col 1) row)
         (list col (+ row 1))
         (list (- col 1) row)
        )
      )

      ;; else
      (display "wrong input\n")
  )
)

(define (update_nb cell)
  
  ;; print world in a way, that zeros are invisible 
  ;; and digits have a trailing space
  (begin
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
  )

  ;; actual redstone spread
  (define src_col_idx (list-ref cell 0))
  (define src_row_idx (list-ref cell 1))
  (define str (list-ref (list-ref world src_col_idx) src_row_idx))
  (define nbs (get_neighbours cell))
  
  (if (and
       (integer? str)
       (list? nbs)
       (not (null? nbs))
      )
      (begin
        (for ([nb nbs])
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
                       str
                      )
                  (set! world
                        (list-set world
                                  nb_col_idx
                                  (list-set
                                   (list-ref world nb_col_idx)
                                   nb_row_idx
                                   (- str 1)
                                  )
                        )
                  )
                  
                  ;; call recursively to progress redstone spread
                  (when (> str 1)
                    (update_nb nb)
                  )
                )
              )
              
              ;; else
              (begin
                (+ 1 2)
;;                 (display "do nothing, out of bounds for: ")
;;                 (display nb)
;;                 (display "\n")
              )
          )        
        )
      )
      
       ;; else
       (display "wrong input\n")
  )
)

(define size (list 4 4))
(define src (list 0 0))

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

(update_nb src)

(display "\nEnd:\n")
(display world)
(display "\n\n")
