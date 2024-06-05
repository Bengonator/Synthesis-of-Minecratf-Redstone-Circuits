#lang rosette

(define (nl) (display "\n"))

; --- Settings ---
(define COL 2)
(define ROW 0)
(define HEIGHT 1)
(define NEW_VALUE 1337)

; --- Nested list ---
(define n_lst (list
               (list (list 1 7) (list 2 8) (list 3 9))
               (list (list 4 10) (list 5 11) (list 6 12))))

(display "Nested ref:") (nl)

(display "  Referencing the row: ")
(display (list-ref n_lst ROW)) (nl)

(display "  Referencing the row and the column: ")
(display (list-ref (list-ref n_lst ROW) COL)) (nl)

(display "  Referencing the row and the column and the height: ")
(display (list-ref (list-ref (list-ref n_lst ROW) COL) HEIGHT)) (nl) (nl)

(display "Nested set:") (nl)
(display "  Setting the row: ")
(display (list-set n_lst
                   ROW
                   NEW_VALUE)) (nl)

(display "  Setting the row and the column: ")
(display (list-set n_lst
                   ROW
                   (list-set (list-ref n_lst ROW)
                             COL
                             NEW_VALUE))) (nl)

(display "  Setting the row and the column and the height: ")
(display (list-set n_lst
                   ROW
                   (list-set (list-ref n_lst ROW)
                             COL
                             (list-set (list-ref (list-ref n_lst ROW) COL)
                                       HEIGHT
                                       NEW_VALUE))))

; --- Flattened list ---
(define (get_idx col row height)
  (+ col (* row nCOLs) (* height nCOLs nROWs)))

(define nCOLs 3)
(define nROWs 2)

(define f_lst (list 1 2 3 4 5 6 7 8 9 10 11 12)) (nl) (nl)

(display "Flattened ref: ")
(display (list-ref f_lst (get_idx COL ROW HEIGHT))) (nl)

(display "Flattened set: ")
(display (list-set f_lst (get_idx COL ROW HEIGHT) NEW_VALUE)) (nl)
