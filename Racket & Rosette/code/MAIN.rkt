#lang rosette

; === IMPORTS ===
(begin
  
  (require rosette/lib/destruct) ; destruct
  (require rosette/lib/angelic)  ; choose*
  (require dyoo-while-loop)      ; while loop
  )

; === ABBREVIATIONS ===
(begin
  
  ; xx = error
  ; ai = air
  ; so = solid block
  ; rb = redstone block
  ; rs = redstone dust
  ; tn = torch north
  ; te = torch east
  ; ts = torch south
  ; tw = torch west
  
  ; col = column
  ; len = length
  ; err = error
  ; str = strength
  ; nbs = neighbours
  )

; === FUNCTIONS ===
(begin
  
  ; (set_input col row name str1 str2)
  (define (set_input col row name str1 str2)
    (set! WORLD_BLOCKS
          (list-set WORLD_BLOCKS (get_index col row) (get_number name)))
    
    (set! WORLD_REDSTONE
          (list-set WORLD_REDSTONE (get_index col row) str1))
    
    (set! WORLD_REDSTONE_2
          (list-set WORLD_REDSTONE_2 (get_index col row) str2)))
  
  ; (get_index col row)
  (define (get_index col row [throw_error #t])
    (if (and
         (>= col 0)
         (>= row 0)
         (< col nCOLs)
         (< row nROWs))
        (+ col (* row nCOLs))
        
        ; else
        (begin
          (when throw_error
            (raise (format "Invalid index at col ~a and row ~a. Maximum indices are ~a and ~a."
                           col row (- nCOLs 1) (- nROWs 1))))
          -1)))
  
  ; (get_number name)
  (define (get_number name)
    (define indexOrFalse (index-of BLOCKS name))
    
    (when (not indexOrFalse)
      (raise (format "Invalid block name '~a'. Name must be one of the follwing: ~a"
                     name BLOCKS)))
    
    indexOrFalse)
  
  ; (get_block col row [throw_error #t])
  (define (get_block col row [throw_error #t])    
    (define index (get_index col row throw_error))
    
    (if (eq? index -1)
        (get_number "xx")
        (list-ref WORLD_BLOCKS index)))
  
  ; (add_block_goal name col[s] row[s]
  (define (add_block_goal name col row)
    (define is_col_list (list? col))
    (define is_row_list (list? row))
    
    (cond
      [(and (not is_col_list) (not is_row_list))
       (assert (eq? (get_block col row) (get_number name)))]
      
      [(and (not is_col_list) is_row_list)
       (for ([r row])
         (assert (eq? (get_block col r) (get_number name))))]
      
      [(and is_col_list (not is_row_list))
       (for ([c col])
         (assert (eq? (get_block c row) (get_number name))))]
      
      [(and is_col_list is_row_list)
       (for ([c col])
         (for ([r row])
           (assert (eq? (get_block c r) (get_number name)))))])
    
    (display ""))
  
  ; (get_str col row [is_initial #t])
  (define (get_str col row [is_initial #t])
    (list-ref (if is_initial WORLD_REDSTONE WORLD_REDSTONE_2) (get_index col row)))
  
  ; (add_str_goal operator str col[s] row[s] [is_initial #t])
  (define (add_str_goal operator str col row [is_initial #t])
    (when (not (index-of (list = < > <= >=) operator))
      (raise (format "Invalid operator '~a'. Operators must be '=' '<' '>' '<=' or '>='."
                     operator)))
    
    (define is_col_list (list? col))
    (define is_row_list (list? row))
    
    (cond
      [(and (not is_col_list) (not is_row_list))
       (assert (operator (get_str col row is_initial) str))]
      
      [(and (not is_col_list) is_row_list)
       (for ([r row])
         (assert (operator (get_str col r is_initial) str)))]
      
      [(and is_col_list (not is_row_list))
       (for ([c col])
         (assert (operator (get_str c row is_initial) str)))]
      
      [(and is_col_list is_row_list)
       (for ([c col])
         (for ([r row])
           (assert (operator (get_str c r is_initial) str))))])
    
    (display ""))
  
  ; (add_block_str_goal name operator str col[s] row[s] [is_initial #t])
  (define (add_block_str_goal name operator str col row [is_initial #t])
    (add_block_goal name col row)
    (add_str_goal operator str col row is_initial))
  
  ; (is_torch? number)
  (define (is_torch? number)
    (or
     (eq? number (get_number "tn"))
     (eq? number (get_number "te"))
     (eq? number (get_number "ts"))
     (eq? number (get_number "tw"))))
  
  ; (add_torch_goal col row)
  (define (add_torch_goal col row)
    (assert (is_torch? (get_block col row))))
  
  ; (add_unlit_torch_goal col row [is_initial #t])
  (define (add_unlit_torch_goal col row [is_initial #t])
    (add_torch_goal col row)
    (add_str_goal = 0 col row is_initial))
  
  ; (add_lit_torch_goal col row [is_initial #t])
  (define (add_lit_torch_goal col row [is_initial #t])
    (add_torch_goal col row)
    (add_str_goal > 0 col row is_initial))
  
  ; (add_off_on_torch_goal col row)
  (define (add_off_on_torch_goal col row)
    (add_unlit_torch_goal col row)
    (add_lit_torch_goal col row #f))
  
  ; (add_on_off_torch_goal col row)
  (define (add_on_off_torch_goal col row)
    (add_lit_torch_goal col row)
    (add_unlit_torch_goal col row #f))
  
  ; (add_off_on_torch_or_solid_goal col row)
  (define (add_off_on_torch_or_solid_goal col row)
    (assert (or
             (is_torch? (get_block col row))
             (eq? (get_block col row) (get_number "so"))))
    
    (add_str_goal = 0 col row)
    (add_str_goal > 0 col row #f))
  
  ; (add_on_off_torch_or_solid_goal col row)
  (define (add_on_off_torch_or_solid_goal col row)
    (assert (or
             (is_torch? (get_block col row))
             (eq? (get_block col row) (get_number "so"))))
    
    (add_str_goal > 0 col row)
    (add_str_goal = 0 col row #f))
  
  ; (add_world_asserts)
  (define (add_world_asserts)
    
    ; (add_solid_asserts str1 str2 col row)
    (define (add_solid_asserts str1 str2 col row)
      
      ; (add_to_nbs nbs col row is_north_or_south is_initial)
      (define (add_to_nbs nbs col row is_north_or_south is_initial)
        
        ; (is_rb_or_rs_or_torch block)
        (define (is_rb_or_rs_or_torch block)
          (or
           (eq? block (get_number "rb"))
           (eq? block (get_number "rs"))
           (is_torch? block)))
        
        (define block (get_block col row))
        
        (if (not (eq? block (get_number "rs")))
            nbs
            
            ; else
            (begin
              (define col_offset (if is_north_or_south 1 0))
              (define row_offset (if is_north_or_south 0 1))
              
              (define nb_one (get_block (+ col col_offset) (- row row_offset) #f))
              (define nb_two (get_block (- col col_offset) (+ row row_offset) #f))
              
              (if (or
                   (is_rb_or_rs_or_torch nb_one)
                   (is_rb_or_rs_or_torch nb_two))
                  nbs
                  (append nbs (list (get_str col row is_initial)))))))
      
      (define nbs1 (list))
      (define nbs2 (list))
      
      (when (not (eq? row 0)) ; North
        (set! nbs1 (add_to_nbs nbs1 col (- row 1) #t #t))
        (set! nbs2 (add_to_nbs nbs2 col (- row 1) #t #f)))
      
      (when (not (eq? col (- nCOLs 1))) ; East
        (set! nbs1 (add_to_nbs nbs1 (+ col 1) row #f #t))
        (set! nbs2 (add_to_nbs nbs2 (+ col 1) row #f #f)))
      
      (when (not (eq? row (- nROWs 1))) ; South
        (set! nbs1 (add_to_nbs nbs1 col (+ row 1) #t #t))
        (set! nbs2 (add_to_nbs nbs2 col (+ row 1) #t #f)))
      
      (when (not (eq? col 0)) ; West
        (set! nbs1 (add_to_nbs nbs1 (- col 1) row #f #t))
        (set! nbs2 (add_to_nbs nbs2 (- col 1) row #f #f)))
      
      (assert (eq? str1 (apply max 0 nbs1)))
      (assert (eq? str2 (apply max 0 nbs2))))
    
    ; (add_rsdust_asserts str1 str2 col row)
    (define (add_rsdust_asserts str1 str2 col row)
      
      ; (add_to_nbs nbs col row is_initial)
      (define (add_to_nbs nbs col row is_initial)
        (if (eq? (get_block col row) (get_number "so"))
            nbs
            (append nbs (list (get_str col row is_initial)))))
      
      (define nbs1 (list))
      (define nbs2 (list))
      
      (when (not (eq? row 0)) ; North
        (set! nbs1 (add_to_nbs nbs1 col (- row 1) #t))
        (set! nbs2 (add_to_nbs nbs2 col (- row 1) #f)))
      
      (when (not (eq? col (- nCOLs 1))) ; East
        (set! nbs1 (add_to_nbs nbs1 (+ col 1) row #t))
        (set! nbs2 (add_to_nbs nbs2 (+ col 1) row #f)))
      
      (when (not (eq? row (- nROWs 1))) ; South
        (set! nbs1 (add_to_nbs nbs1 col (+ row 1) #t))
        (set! nbs2 (add_to_nbs nbs2 col (+ row 1) #f)))
      
      (when (not (eq? col 0)) ; West
        (set! nbs1 (add_to_nbs nbs1 (- col 1) row #t))
        (set! nbs2 (add_to_nbs nbs2 (- col 1) row #f)))
      
      (assert (eq? str1 (- (apply max 1 nbs1) 1)))
      (assert (eq? str2 (- (apply max 1 nbs2) 1))))
    
    ; (add_torch_asserts str1 str2 col row)
    (define (add_torch_asserts str1 str2 col row)
      (define nb (get_block col row))
      
      (assert (or
               (eq? nb (get_number "so"))
               (eq? nb (get_number "rb"))))
      
      (if (eq? nb (get_number "rb"))
          (and
           (assert (eq? str1 0))
           (assert (eq? str2 0)))
          
          ; else
          (begin
            (if (eq? (get_str col row) 0)
                (assert (eq? str1 16))
                (assert (eq? str1 0)))
            
            (if (eq? (get_str col row #f) 0)
                (assert (eq? str2 16))
                (assert (eq? str2 0))))))
    
    ; (interpret structure)
    (define (interpret structure)
      (destruct structure
                [(air col row str1 str2)
                 (add_block_goal "ai" col row)
                 (assert (eq? str1 0))
                 (assert (eq? str2 0))]
                
                [(solid col row str1 str2)
                 (add_block_goal "so" col row)
                 (add_solid_asserts str1 str2 col row)]
                
                [(rs_block col row str1 str2)
                 (add_block_goal "rb" col row)
                 (assert (eq? str1 16))
                 (assert (eq? str2 16))]
                
                [(rs_dust col row str1 str2)
                 (add_block_goal "rs" col row)
                 (add_rsdust_asserts str1 str2 col row)]
                
                [(torch_north col row str1 str2)
                 (add_block_goal "tn" col row)
                 (assert (not (eq? row (- nROWs 1))))
                 (add_torch_asserts str1 str2 col (+ row 1))]
                
                [(torch_east col row str1 str2)
                 (add_block_goal "te" col row)
                 (assert (not (eq? col 0)))
                 (add_torch_asserts str1 str2 (- col 1) row)]
                
                [(torch_south col row str1 str2)
                 (add_block_goal "ts" col row)
                 (assert (not (eq? row 0)))
                 (add_torch_asserts str1 str2 col (- row 1))]
                
                [(torch_west col row str1 str2)
                 (add_block_goal "tw" col row)
                 (assert (not (eq? col (- nCOLs 1))))
                 (add_torch_asserts str1 str2 (+ col 1) row)]
                
                [_ (raise (format "Invalid structure, which can not be interpreted: ~a" structure))]))
    
    ; block structures
    (begin
      (struct air (col row str1 str2))
      (struct solid (col row str1 str2))
      (struct rs_block (col row str1 str2))
      (struct rs_dust (col row str1 str2))
      (struct torch_north (col row str1 str2))
      (struct torch_east (col row str1 str2))
      (struct torch_south (col row str1 str2))
      (struct torch_west (col row str1 str2)))
    
    (for ([row nROWs])
      (for ([col nCOLs])        
        (define block (get_block col row))
        (define str1 (get_str col row))
        (define str2 (get_str col row #f))
        
        (define is_block_symbolic (symbolic? block))
        (define is_str1_symbolic (symbolic? str1))
        (define is_str2_symbolic (symbolic? str2))
        
        (if (and is_block_symbolic is_str1_symbolic is_str2_symbolic)
            (interpret (choose*
                        (air col row str1 str2)
                        (solid col row str1 str2)
                        (rs_block col row str1 str2)
                        (rs_dust col row str1 str2)
                        (torch_north col row str1 str2)
                        (torch_east col row str1 str2)
                        (torch_south col row str1 str2)
                        (torch_west col row str1 str2)))
            
            ; else
            (begin
              (when (or is_block_symbolic is_str1_symbolic is_str2_symbolic)
                (raise (format "Invalid values at column '~a' and row '~a'. The values in all three worlds must either all be symbolic or concrete."
                               col row))))))))
  
  ; (nl)
  (define (nl) (display "\n"))
  
  ; (solve_world)
  (define (solve_world)
    
    ; (get_model_block binding col row)
    (define (get_model_block binding col row)
      (define model_block (hash-ref binding (get_block col row) -1))
      
      (if (= model_block -1)
          (get_block col row)
          model_block))
    
    ; (get_costs)
    (define (get_costs)
      (if (not USE_SPECIFIED_COSTS)
          (apply + WORLD_REDSTONE)
          
          ; else
          (begin
            (define costs 0)
            
            (for ([col nCOLs])
              (for ([row nROWs])
                (set! costs (+ costs (list-ref SPECIFIED_COSTS (get_block col row))))))
            
            costs)))
    
    ; (get_block_costs)
    (define (get_block_costs)      
      (define costs 0)
      
      (for ([col nCOLs])
        (for ([row nROWs])          
          (when (not (eq? (get_block col row) (get_number "ai")))
            (set! costs (+ costs 1)))))
      
      costs)
    
    ; (get_model_str binding col row [is_initial #t])
    (define (get_model_str binding col row [is_initial #t])
      (define model_str (hash-ref binding (get_str col row is_initial) -1))
      
      (if (= model_str -1)
          (get_str col row is_initial)
          model_str))
    
    ; (get_name number)
    (define (get_name number)
      (when (or
             (< number 0)
             (>= number (length BLOCKS)))
        (raise (format "Invalid block number '~a'. Number must be between 0 and ~a."
                       number ( - (length BLOCKS) 1))))
      
      (list-ref BLOCKS number))
    
    ; (print_layers binding)
    (define (print_layers binding n_prints)
      
      ; (get_fancy_name number str)
      (define (get_fancy_name number str)
        (when (or
               (< number 0)
               (>= number (length BLOCKS)))
          (raise (format "Invalid block number '~a'. Number must be between 0 and ~a."
                         number ( - (length BLOCKS) 1))))
        
        (define name (get_name number))
        (define fancy_name (list-ref BLOCKS_FANCY number))
        
        (cond
          [(eq? name "rs")
           (string-append " "
                          (if (eq? str 0)
                              (string (string-ref fancy_name 1))
                              (string (string-ref fancy_name 0))))]
          
          [(index-of (list "tn" "te" "ts" "tw") name)
           (if (eq? str 0)
               fancy_name
               (string-append " " (string (string-ref fancy_name 1))))]
          
          [else fancy_name]))
      
      (when (> n_prints 0)
        
        (define max_prints (length PRINTED_LAYERS))
        (define last_print (last (indexes-of PRINTED_LAYERS #t)))
        
        ; column header
        (begin
          (for ([nth max_prints])
            (when (list-ref PRINTED_LAYERS nth)
              (display
               (cond
                 [(= 0 nth) "BL"] ; blocks
                 [(= 1 nth) "IR"] ; initial redstone
                 [(= 2 nth) "IF"] ; initial fancy
                 [(= 3 nth) "SR"] ; step redstone
                 [(= 4 nth) "SF"] ; step fancy
                 [else "  "]))
              
              (display " | ")
              
              (for ([c nCOLs])
                (when (< c 10) (display " "))
                (display c)
                (when (not (and
                            (= c (- nCOLs 1))
                            (eq? nth last_print)))
                  (display " ")))
              
              (when (not (eq? nth last_print)) (display " |  "))))
          
          (nl)
          
          (for ([nth max_prints])
            (when (list-ref PRINTED_LAYERS nth)
              (display "----")
    
              (for ([c nCOLs]) (display "---"))
    
              (when (not (eq? nth last_print)) (display "  |  ")))))
        
        (nl)
        
        (for ([r nROWs])
          (for ([nth max_prints])
            (when (list-ref PRINTED_LAYERS nth)
              
              ; row header
              (when (< r 10) (display " "))
              (display r)
              (display " | ")
              
              ; cell value
              (begin
                (for ([c nCOLs])
                  (cond              
                    [(eq? nth 0)
                     (display (get_name (get_model_block binding c r)))]
                    
                    [(eq? nth 1)
                     (begin
                       (define str (get_model_str binding c r))
                       (when (<= 0 str 9) (display " "))
                       (display str))]
                    
                    [(eq? nth 2)
                     (define str (get_model_str binding c r))
                     (display (get_fancy_name (get_model_block binding c r) str))]
                    
                    [(eq? nth 3)
                     (begin
                       (define str (get_model_str binding c r #f))
                       (when (<= 0 str 9) (display " "))
                       (display str))]
                    
                    [(eq? nth 4)
                     (define str (get_model_str binding c r #f))
                     (display (get_fancy_name (get_model_block binding c r) str))])
                  
                  (when (not (and
                              (= c (- nCOLs 1))
                              (eq? nth last_print)))
                    (display " "))))
              
              (when (not (eq? nth last_print)) (display " |  "))))
          
          (nl))))
    
    ; (print_line length)
    (define (print_line length)
      (when (> length 0)
        (display (make-string length #\=)))
      (nl))
    
    ; (round_down number)
    (define (round_down number)
      (inexact->exact (floor number)))
    
    ; (print_command binding x_offset y_offset z_offset)
    (define (print_command binding x_offset y_offset z_offset)
      
      ; (new_block_command col row name)
      (define (new_block_command col row name)
        (string-append
         tab tab tab
         (format "{id:command_block_minecart,Command:'setblock ~~~a ~~~a ~~~a ~a'},"
                 (+ col x_offset) (- y_offset 2) (+ row z_offset) name)
         nwl))
      
      (define tab "")
      (define nwl "")
      
      (when PRETTIFY_COMMANDS
        (set! tab "\t")
        (set! nwl "\n"))
      
      (define command_start (string-append
                             "/summon falling_block ~ ~1 ~ {BlockState:{Name:redstone_block},Passengers:[" nwl
                             tab "{id:armor_stand,Health:0,Passengers:[" nwl
                             tab tab "{id:falling_block,BlockState:{Name:activator_rail},Passengers:[" nwl))
      
      (define commands_set_blocks "")
      (define commands_clear_blocks "")
      
      (define command_end (string-append
                           (when REPLACE_COMMAND_BLOCK (string-append tab tab tab "{id:command_block_minecart,Command:'summon falling_block ~ ~-1.5 ~ {BlockState:{Name:command_block}}'}," nwl))
                           tab tab tab "{id:command_block_minecart,Command:'setblock ~ ~1 ~ command_block{auto:1,Command:\"fill ~ ~ ~ ~ ~-3 ~ air\"}'}," nwl
                           tab tab tab "{id:command_block_minecart,Command:'kill @e[type=command_block_minecart,distance=..1]'}" nwl
                           tab tab "]}" nwl
                           tab "]}" nwl
                           "]}\n\n"))
      
      (for ([r nROWs])
        (for ([c nCOLs])
          (define block (get_name (get_model_block binding c r)))
          (define str (get_model_str binding c r))
          
          (when (not (or (eq? block "ai") (eq? block "oi")))
            (define name_in_game "")
            
            (cond
              [(eq? block "so") (set! name_in_game "stone")]
              [(eq? block "rb") (set! name_in_game "redstone_block")]
              [(eq? block "rs") (set! name_in_game "redstone_wire")]
              [(is_torch? (get_number block))
               (set! name_in_game
                     (string-append
                      "redstone_wall_torch["
                      (cond
                        [(eq? block "tn") "facing=north"]
                        [(eq? block "te") "facing=east"]
                        [(eq? block "ts") "facing=south"]
                        [(eq? block "tw") "facing=west"])
                      (if (eq? str 0) ",lit=false]" "]")))])
            
            (define new_set_block_command (new_block_command c r name_in_game))          
            (set! commands_set_blocks (string-append commands_set_blocks new_set_block_command))
            
            (define new_clear_block_command (new_block_command c r "air"))         
            (set! commands_clear_blocks (string-append commands_clear_blocks new_clear_block_command)))))
      
      (display "Copy command")
      (when PRINT_CLEAR_COMMAND (display "s"))
      (display " into a command block:\n")
      (nl)
      (display "Command to set the blocks:\n")
      (display (string-append command_start commands_set_blocks command_end))
      
      (when PRINT_CLEAR_COMMAND
        (display "Command to clear the blocks:\n")
        (display (string-append command_start commands_clear_blocks command_end))))
    
    (define n_prints (- (length PRINTED_LAYERS) (length (filter false? PRINTED_LAYERS))))
    (define (colon_nl) (display (if (eq? n_prints 0) "\n" ":\n")))
    
    ; (
    ;    column header width
    ;    + (size per column * number of columns)
    ;    + space after last column
    ; )
    ; * number of tables
    ; - space after last column of last table
    (define line_len (- (* n_prints (+ 4 (* nCOLs 3) 5)) 5))
    
    (add_world_asserts)
    
    (display "\nStarting the calculation:\n\n")
    
    (define solution (solve vc))
    
    (if (not (sat? solution))
        (display "UNSAT\n\n")
        
        ; else
        (begin          
          (display "SAT without any bounds")
          (colon_nl)
          (print_layers (model solution) n_prints)
          (nl)
          
          ; minimizing cost power level 
          (begin
            (when PRINT_STEPS
              (print_line line_len)
              (display "Minimizing cost power level:\n"))
            
            (define last_sat_solution solution)
            
            (define max_cost_bound
              (if (not USE_SPECIFIED_COSTS)
                  (* LEN 16)
                  
                  ; else
                  (begin
                    (define costs 0)
                    
                    (for ([col nCOLs])
                      (for ([row nROWs])
                        (set! costs (+ costs (list-ref SPECIFIED_COSTS (get_model_block (model solution) col row))))))
                    
                    costs)))
            
            (define last_sat_cost_bound max_cost_bound)
            (define last_unsat_cost_bound -1)
            
            (define cost_bound (real->double-flonum max_cost_bound))
            (define exponent 0)
            (while (<= 0 cost_bound max_cost_bound)
                   (when (eq? 1 (- (floor last_sat_cost_bound) (floor last_unsat_cost_bound))) (break))
                   
                   (set! solution (solve (assert (<= (get_costs) cost_bound))))
                   
                   (set! exponent (+ exponent 1))
                   
                   (if (sat? solution)
                       (begin                     
                         (when PRINT_STEPS
                           (display (format "\nStep ~a: SAT with cost bound ~a" exponent cost_bound))
                           (colon_nl)
                           (print_layers (model solution) n_prints))
                         
                         (set! last_sat_solution solution)
                         (set! last_sat_cost_bound cost_bound)
                         (set! cost_bound (- cost_bound (/ max_cost_bound (expt 2 exponent)))))
                       
                       ; else
                       (begin
                         (when PRINT_STEPS
                           (display (format "\nStep ~a: UNSAT with cost bound ~a\n" exponent cost_bound)))
                         
                         (set! last_unsat_cost_bound cost_bound)
                         (set! cost_bound (+ cost_bound (/ max_cost_bound (expt 2 exponent)))))))
            
            (when PRINT_STEPS
              (print_line line_len)
              (nl))
            
            (display (format "SAT with minimal cost bound ~a" (round_down last_sat_cost_bound)))
            (colon_nl)
            (print_layers (model last_sat_solution) n_prints)
            (nl))
          
          ; minimizing amount of non-air blocks
          (begin
            (when PRINT_STEPS
              (print_line line_len)
              (display "Minimizing amount of non-air blocks:\n"))
            
            (set! last_sat_solution solution)
            (define max_blocks_bound (* nCOLs nROWs))
            (define last_sat_blocks_bound max_blocks_bound)
            (define last_unsat_blocks_bound -1)
            
            (define blocks_bound (real->double-flonum max_blocks_bound))
            (set! exponent 0)
            
            (while (<= 0 blocks_bound max_blocks_bound)
                   (when (eq? 1 (- (floor last_sat_blocks_bound) (floor last_unsat_blocks_bound))) (break))
                   
                   (set! solution
                         (solve (and
                                 (assert (<= (get_costs) last_sat_cost_bound))
                                 (assert (<= (get_block_costs) blocks_bound)))))
                   
                   (set! exponent (+ exponent 1))
                   
                   (if (sat? solution)
                       (begin                     
                         (when PRINT_STEPS
                           (display (format "\nStep ~a: SAT with blocks bound ~a" exponent blocks_bound))
                           (colon_nl)
                           (print_layers (model solution) n_prints))
                     
                         (set! last_sat_solution solution)
                         (set! last_sat_blocks_bound blocks_bound)
                         (set! blocks_bound (- blocks_bound (/ max_blocks_bound (expt 2 exponent)))))
                       
                       ; else
                       (begin
                         (when PRINT_STEPS
                           (display (format "\nStep ~a: UNSAT with blocks bound ~a\n" exponent blocks_bound)))
                         
                         (set! last_unsat_blocks_bound blocks_bound)
                         (set! blocks_bound (+ blocks_bound (/ max_blocks_bound (expt 2 exponent)))))))
            
            (when PRINT_STEPS
              (print_line line_len)
              (nl))
            
            (define binding (model last_sat_solution))
            (display (format "SAT with minimal blocks bound ~a" (round_down last_sat_blocks_bound)))
            (colon_nl)
            (print_layers binding n_prints)
            (nl))
          
          (when (and PRINT_STEPS PRINT_COMMAND)
            (print_line line_len))
          
          (when (and
                 PRINT_COMMAND
                 (not (null? binding)))
            (print_command binding xOFFSET yOFFSET zOFFSET)))))
  )

; === SETTINGS ===
(begin
  
  (define nCOLs 2)
  (define nROWs 2)
  
  (define USE_SPECIFIED_COSTS #f)
  (define SPECIFIED_COSTS
    '(99  ; error
      0   ; air
      1   ; solid block
      9   ; redstone block
      2   ; redstone dust
      4   ; torch north
      4   ; torch east
      4   ; torch south 
      4)  ; torch west
    ) ; SPECIFIED_COSTS

  (define PRINT_STEPS #f)
  (define PRINTED_LAYERS
    '(#t   ; blocks
      #f   ; initial redstone
      #t   ; initial fancy
      #f   ; step redstone
      #t)  ; step fancy
    ) ; PRINTED_LAYERS

  (define PRINT_COMMAND #t)
  (define PRINT_CLEAR_COMMAND #f)
  
  (define xOFFSET 0)
  (define yOFFSET 0)
  (define zOFFSET 0)
  (define REPLACE_COMMAND_BLOCK #t)
  (define PRETTIFY_COMMANDS #t)
  )

; === GLOBAL VARIABLES ===
(begin
  
  (define BLOCKS       '("xx" "ai" "so" "rb" "rs" "tn" "te" "ts" "tw"))
  (define BLOCKS_FANCY '("??" "  " " O" " X" "*." "!^" "!>" "!v" "!<"))
  
  (when (not (eq? (length SPECIFIED_COSTS) (length BLOCKS)))
    (raise (format
            "Length of specified costs must be equal to length of blocks, but they are '~a' and '~a'."
            (length SPECIFIED_COSTS) (length BLOCKS))))
  
  (define WORLD_BLOCKS (list))
  (define WORLD_REDSTONE (list))
  (define WORLD_REDSTONE_2 (list))
  
  (when (or (<= nCOLs 0) (<= nROWs 0))
    (raise "Amount of columns and rows must each be higher than 0."))
  
  (define LEN (* nCOLs nROWs))
  
  (define-symbolic sym_world_blocks integer? #:length LEN)
  (set! WORLD_BLOCKS sym_world_blocks)
  
  (define-symbolic sym_world_redstone integer? #:length LEN)
  (set! WORLD_REDSTONE sym_world_redstone)
  
  (define-symbolic sym_world_redstone_2 integer? #:length LEN)
  (set! WORLD_REDSTONE_2 sym_world_redstone_2)
  )

; === MAIN: add goals here ===

; (set_input col row name str1 str2)

; (add_block_goal name col[s] row[s])
; (add_str_goal operator str col[s] row[s] [is_initial])
; (add_block_str_goal name operator str col[s] row[s] [is_initial])

; (add_torch_goal col row)
; (add_unlit_torch_goal col row [is_initial])
; (add_lit_torch_goal col row [is_initial])

; (add_off_on_torch_goal col row)
; (add_on_off_torch_goal col row)
; (add_off_on_torch_or_solid_goal col row)
; (add_on_off_torch_or_solid_goal col row)

(add_block_goal "rb" '(0 1) 0)

(solve_world)