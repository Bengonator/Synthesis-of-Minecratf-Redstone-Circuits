#lang rosette

(require rosette/lib/synthax) ;; Import library for defining holes in sketches

; input parameters
(define XX 4) ; length
(define YY 4) ; width

; functions
(define (printAsList)
  (for ([r XX])
    (for ([c YY])
      (display "x: ")
      (display r)
      (display " y: ")
      (display c)
      (display "\n")
    )
  )
)

(define (printAsGrid)
  (for ([r XX])
    (for ([c YY])
      (display r)
      (display c)
      (display " ")
    )
    (display "\n")
  )
)

; main
(printAsGrid)
