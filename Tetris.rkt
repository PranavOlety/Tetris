(require 2htdp/image)
(require 2htdp/universe)



;; Exercise  6 7 & 8

;; Tetris Game


;; TETRIS WORLD


;                                                                                  
;                                                                                  
;                                                                                  
;                                                                                  
;                                                                             ;;;; 
;   ;;;;;;                ;                           ;;;;;;                 ;     
;    ;    ;               ;                            ;    ;                ;     
;    ;     ;    ;;;;    ;;;;;;;     ;;;;               ;     ;    ;;;;     ;;;;;;  
;    ;     ;   ;    ;     ;        ;    ;              ;     ;   ;    ;      ;     
;    ;     ;        ;     ;             ;              ;     ;  ;      ;     ;     
;    ;     ;   ;;;;;;     ;        ;;;;;;              ;     ;  ;;;;;;;;     ;     
;    ;     ;  ;     ;     ;       ;     ;              ;     ;  ;            ;     
;    ;     ;  ;     ;     ;       ;     ;              ;     ;  ;            ;     
;    ;    ;   ;    ;;     ;    ;  ;    ;;              ;    ;    ;     ;     ;     
;   ;;;;;;     ;;;; ;;     ;;;;    ;;;; ;;            ;;;;;;      ;;;;;    ;;;;;;  
;                                                                                  
;                                                                                  
;                                                                                  
;                                                                                  
;


;; Meta Comment for Grader : We changed the world data definition to include a score
;; seeing that the score is to be updated each tick of the main function and also needs to be
;; displayed via our to-draw
;; Piazza Post @784 is our basis for this decision
(define-struct world [p pob score])
;; a World is a (make-world Piece PileOfBricks Natural)
;; Interpretation : represents the World where
;; - (_p_) is a Piece
;; - (_pob_) is a PileOfBricks as a [List-of Brick]
;; - (_score_) is a Natural 

;; a Form is one of :
;; - O 1
;; - I 2
;; - L 3
;; - J 4
;; - T 5
;; - Z 6
;; - S 7
;; - D 8
;; - F 9
;; Interpretation : represents the shape of a Piece based upon the relative positions of the Bricks

(define-struct piece [c lob])
;; A Piece is a (make-piece Posn NonEmptyListOfBricks)
;; Interpretation : represents
;; - (_c_) as a Posn which is the center point around which the piece spins when rotated
;; - (_nelob_) as a NonEmptyListOfBricks (NeLOB) which dictates the relative locations
;; of all of the bricks and holds them in a container is dependent on the (_c_), or center point

;; A NonEmptyListOfBricks (NeLOB) is one of :
;; - (cons Brick empty)
;; - (cons Brick NeLOB)
;; Interpretation : represents a non empty list of bricks

;; a PileOfBricks is a [List-of Brick] 

(define-struct brick [x y color])
;; A Brick is a (make-brick Integer Integer Color)
;; Interpretation : A (make-brick x-g y-g c) represents a square brick 
;; at position (x-g, y-g) in the grid, to be rendered in color c.

;; A Color is one of :
;; - "green"
;; - "blue"
;; - "purple"
;; - "cyan"
;; - "orange"
;; - "pink"
;; - "red"
;; - "magenta"
;; - "darkgreen"
;; Interpretation : represents the various different colors possible for a brick

;; Direction is one of:
;; - "left"
;; - "right"
;; Interpretation : represents the direction of the movement of the piece as a String

;; Rotation is one of:
;; - "clockwise"
;; - "counter-clockwise"
;; Interpretation : represents the rotation of the movement of the piece as a String

;; a Probability is a Natural in the range of [0 - 100]



;                                                                                  
;                                                                                  
;                                                                                  
;                                                                                  
;                                                       ;;;                        
;   ;;;;;;;;                                              ;                        
;    ;     ;                                              ;                        
;    ;     ;  ;;;  ;;;    ;;;;   ;; ; ;;    ;; ;;;        ;       ;;;;     ;;;; ;  
;    ;  ;      ;    ;    ;    ;   ;; ;; ;    ;;   ;       ;      ;    ;   ;    ;;  
;    ;;;;       ;  ;          ;   ;  ;  ;    ;     ;      ;     ;      ;  ;        
;    ;  ;        ;;      ;;;;;;   ;  ;  ;    ;     ;      ;     ;;;;;;;;   ;;;;;   
;    ;     ;     ;;     ;     ;   ;  ;  ;    ;     ;      ;     ;               ;  
;    ;     ;    ;  ;    ;     ;   ;  ;  ;    ;     ;      ;     ;               ;  
;    ;     ;   ;    ;   ;    ;;   ;  ;  ;    ;;   ;       ;      ;     ;  ;     ;  
;   ;;;;;;;;  ;;;  ;;;   ;;;; ;; ;;; ;; ;;   ; ;;;     ;;;;;;;    ;;;;;   ;;;;;;   
;                                            ;                                     
;                                            ;                                     
;                                           ;;;                                    
;                                                                                  
;                                                                                  



;; Rotation Examples
(define rot1 "clockwise")
(define rot2 "counter-clockwise")

;; Direction Examples
(define dir1 "left")
(define dir2 "right")

;; Color Examples
(define color1 "orange")
(define color2 "pink")
(define color3 "red")

;; Brick Examples
(define brick1 (make-brick 1 1 "red"))
(define brick2 (make-brick 2 12 "blue"))
(define brick3 (make-brick 6 2 "yellow"))
(define brick4 (make-brick 5 9 "purple"))

;; NeLOB Examples
(define nelob1 (cons brick1 empty))
(define nelob2 (cons brick2 nelob1))
(define nelob3 (cons brick3 nelob2))
(define nelob4 (cons brick4 nelob3))

;; PileOfBricks Examples
(define pobempty empty)
(define pob1 (list brick1))
(define pob2 (list brick1 brick2))
(define pob3 (list brick1 brick2 brick3))

;; Piece Examples
(define piece1 (make-piece (make-posn 1 1) nelob1))
(define piece2 (make-piece (make-posn 3 11) nelob2))
(define piece3 (make-piece (make-posn 9 2) nelob3))
(define piece4 (make-piece (make-posn 3 3) nelob4))

;; Form Examples
(define O-FORM 1)
(define I-FORM 2)
(define L-FORM 3)
(define J-FORM 4)
(define T-FORM 5)
(define Z-FORM 6)
(define S-FORM 7)
(define D-FORM 8)
(define F-FORM 9)

;; World Examples
(define world1 (make-world piece1 empty 0))
(define world2 (make-world piece2 empty 10))
(define world3 (make-world piece3 empty 20))

;; Probability Examples
(define prob1 0)
(define prob2 56)
(define prob3 100)



;                                                                                            
;                                                                                            
;                                                                                            
;                                                                                            
;                                             ;;;                                            
;   ;;;;;;;;;                                   ;                 ;                          
;   ;   ;   ;                                   ;                 ;                          
;   ;   ;   ;   ;;;;   ;; ; ;;    ;; ;;;        ;       ;;;;    ;;;;;;;     ;;;;     ;;;; ;  
;   ;   ;   ;  ;    ;   ;; ;; ;    ;;   ;       ;      ;    ;     ;        ;    ;   ;    ;;  
;       ;     ;      ;  ;  ;  ;    ;     ;      ;           ;     ;       ;      ;  ;        
;       ;     ;;;;;;;;  ;  ;  ;    ;     ;      ;      ;;;;;;     ;       ;;;;;;;;   ;;;;;   
;       ;     ;         ;  ;  ;    ;     ;      ;     ;     ;     ;       ;               ;  
;       ;     ;         ;  ;  ;    ;     ;      ;     ;     ;     ;       ;               ;  
;       ;      ;     ;  ;  ;  ;    ;;   ;       ;     ;    ;;     ;    ;   ;     ;  ;     ;  
;     ;;;;;     ;;;;;  ;;; ;; ;;   ; ;;;     ;;;;;;;   ;;;; ;;     ;;;;     ;;;;;   ;;;;;;   
;                                  ;                                                         
;                                  ;                                                         
;                                 ;;;                                                        
;                                                                                            
;                                                                                            



;; world-templ : World -> ???
#;(define (world-templ w)
    (... (world-p w) ...
         (world-pob w) ...
         (world-score w) ...))

;; form-templ : Form -> ???
#;(define (form-templ f)
    (cond [(string=? O-FORM f) ...]
          [(string=? I-FORM f) ...]
          [(string=? L-FORM f) ...]
          [(string=? J-FORM f) ...]
          [(string=? T-FORM f) ...]
          [(string=? Z-FORM f) ...]
          [(string=? S-FORM f) ...]
          [(string=? D-FORM f) ...]
          [(string=? F-FORM f) ...]))

;; piece-templ : Piece -> ???
#;(define (piece-templ p)
    (... (piece-c p) ...
         (piece-lob p) ...))

;; posn-templ : Posn -> ???
#;(define (posn-templ p)
    (... (posn-x p) ...
         (posn-y p) ...))

;; nelob-templ : NonEmptyListOfBricks -> ???
#;(define (lob-templ lob)
    (cond [(empty? (rest lob)) ... (brick-templ (first lob)) ...]
          [(cons? (rest lob)) ... (brick-templ (first lob))
                              ... (lob-templ (rest lob)) ...]))

;; brick-templ : Brick -> ???
#;(define (brick-templ b)
    (... (brick-x b) ...
         (brick-y b) ...
         (brick-color b) ...))

;; color-templ : Color -> ???
#;(define (color-templ c)
    (cond [(string=? "green" c) ...]
          [(string=? "blue" c) ...]
          [(string=? "purple" c) ...]
          [(string=? "cyan" c) ...]
          [(string=? "orange" c) ...]
          [(string=? "pink" c) ...]
          [(string=? "red" c) ...]
          [(string=? "magenta" c) ...]
          [(string=? "darkgreen" c) ...]))

;; dir-templ : Direction -> ???
#;(define (dir-templ d)
    (cond [(string=? "left" d) ...]
          [(string=? "right" d) ...]))

;; rotation-templ : Rotation -> ???
#;(define (rotation-templ d)
    (cond  [(string=? "clockwise" d) ...]
           [(string=? "counter-clockwise" d) ...]))



;                                                                                  
;                                                                                  
;                                                                                  
;                 ;                                       ;                        
;                 ;               ;;          ;;;         ;                        
;   ;;;; ;;;;                      ;            ;                           ;      
;    ;     ;                       ;            ;                           ;      
;    ;  ;  ;    ;;;      ;;;; ;    ; ;;;        ;       ;;;      ;;;; ;   ;;;;;;;  
;    ;  ;  ;      ;     ;    ;;    ;;   ;       ;         ;     ;    ;;     ;      
;    ;  ;  ;      ;     ;          ;    ;       ;         ;     ;           ;      
;    ; ; ; ;      ;      ;;;;;     ;    ;       ;         ;      ;;;;;      ;      
;    ; ; ; ;      ;           ;    ;    ;       ;         ;           ;     ;      
;    ; ; ; ;      ;           ;    ;    ;       ;         ;           ;     ;      
;    ; ; ; ;      ;     ;     ;    ;    ;       ;         ;     ;     ;     ;    ; 
;     ;   ;    ;;;;;;;  ;;;;;;    ;;;  ;;;   ;;;;;;;   ;;;;;;;  ;;;;;;       ;;;;  
;                                                                                  
;                                                                                  
;                                                                                  
;                                                                                  
;                                                                                  



;; big-bang clauses
#;(big-bang (gen-world BACKGROUND)
    (to-draw world->scene)
    (on-tick world->world)
    (on-key key-handler))

;; world->scene : World -> Image*
;; brick->img : Brick -> Image*
;; lob+scene : Piece Scene -> Image*
;; brick+scene : Brick Scene -> Image*

;; world->world : World -> World*

;; gen-rand-piece : Piece Scene -> World*
;; random-location : ??? -> ??? Did not need this because I used a top down approach
;; and used random-place instead

;; perform-action : Piece Direction -> Piece Did not need this because it was too general
;; move-piece : Piece Direction -> Piece*
;; rotate-piece : Piece Direction -> Piece* 

;; wall-touch? : World -> Boolean*
;; lob-touch? : NeLOB -> Boolean*
;; brick-touch? : Brick -> Boolean*

;; key-handler : World Key-Event -> World*



;                                                                                            
;                                                                                            
;                                                                                            
;                                                                                            
;                                                                                            
;     ;;;; ;                                  ;                             ;                
;    ;    ;;                                  ;                             ;                
;   ;      ;    ;;;;    ;; ;;;     ;;;; ;   ;;;;;;;     ;;;;    ;; ;;;    ;;;;;;;    ;;;; ;  
;   ;          ;    ;    ;;   ;   ;    ;;     ;        ;    ;    ;;   ;     ;       ;    ;;  
;   ;         ;      ;   ;    ;   ;           ;             ;    ;    ;     ;       ;        
;   ;         ;      ;   ;    ;    ;;;;;      ;        ;;;;;;    ;    ;     ;        ;;;;;   
;   ;         ;      ;   ;    ;         ;     ;       ;     ;    ;    ;     ;             ;  
;   ;         ;      ;   ;    ;         ;     ;       ;     ;    ;    ;     ;             ;  
;    ;     ;   ;    ;    ;    ;   ;     ;     ;    ;  ;    ;;    ;    ;     ;    ;  ;     ;  
;     ;;;;;     ;;;;    ;;;  ;;;  ;;;;;;       ;;;;    ;;;; ;;  ;;;  ;;;     ;;;;   ;;;;;;   
;                                                                                            
;                                                                                            
;                                                                                            
;                                                                                            
;                                                                                            



;; Grid Constants
(define BRICK-SIZE 40) ; width and height of a brick measured in pixels
(define BOARD-HEIGHT 20) ; height of the board measured in bricks
(define BOARD-WIDTH 10) ; width of the board measured in bricks
(define BOARD-HEIGHT/PIX (* BOARD-HEIGHT BRICK-SIZE)) ; board height in pixels
(define BOARD-WIDTH/PIX (* BOARD-WIDTH BRICK-SIZE)) ; board width in pixels
(define BACKGROUND (empty-scene BOARD-WIDTH/PIX BOARD-HEIGHT/PIX))

;; Tick Rate Constant
(define TICK-RATE 0.2)

;; Brick Constants
(define SOLID "solid")
(define OUTLINE "outline")
(define BLACK "black")

;; # Of Forms Constant
(define NUMOFFORMS 9) ; Previously was 7 in first implementation

;; Example Lists for Row Clearing 
(define EX-LIST-1 (list
                   (make-brick 1 2 "magenta")
                   (make-brick 0 0 "orange")
                   (make-brick 1 0 "cyan")
                   (make-brick 3 0 "pink")
                   (make-brick 4 0 "purple")
                   (make-brick 5 0 "red")
                   (make-brick 7 0 "blue")
                   (make-brick 1 1 "darkgreen")
                   (make-brick 6 1 "red")
                   (make-brick 7 1 "pink")
                   (make-brick 8 1 "red")
                   (make-brick 0 2 "pink")
                   (make-brick 2 2 "green")
                   (make-brick 3 2 "darkgreen")
                   (make-brick 4 2 "red")
                   (make-brick 5 2 "orange")
                   (make-brick 6 2 "pink")
                   (make-brick 7 2 "purple")
                   (make-brick 8 2 "blue")
                   (make-brick 9 2 "purple")))
(define EX-FULLROW (list 
                    (make-brick 0 2 "pink")
                    (make-brick 1 2 "magenta")
                    (make-brick 2 2 "green")
                    (make-brick 3 2 "darkgreen")
                    (make-brick 4 2 "red")
                    (make-brick 5 2 "orange")
                    (make-brick 6 2 "pink")
                    (make-brick 7 2 "purple")
                    (make-brick 8 2 "blue")
                    (make-brick 9 2 "purple")))

;                                                                                            
;                                                                                            
;                                                                                            
;                                                         ;                                  
;                                                         ;                                  
;   ;;;;;;;;                                  ;                                              
;    ;     ;                                  ;                                              
;    ;     ;  ;;   ;;   ;; ;;;      ;;;; ;  ;;;;;;;     ;;;       ;;;;    ;; ;;;     ;;;; ;  
;    ;  ;      ;    ;    ;;   ;    ;    ;;    ;           ;      ;    ;    ;;   ;   ;    ;;  
;    ;;;;      ;    ;    ;    ;   ;           ;           ;     ;      ;   ;    ;   ;        
;    ;  ;      ;    ;    ;    ;   ;           ;           ;     ;      ;   ;    ;    ;;;;;   
;    ;         ;    ;    ;    ;   ;           ;           ;     ;      ;   ;    ;         ;  
;    ;         ;    ;    ;    ;   ;           ;           ;     ;      ;   ;    ;         ;  
;    ;         ;   ;;    ;    ;    ;     ;    ;    ;      ;      ;    ;    ;    ;   ;     ;  
;   ;;;;;       ;;; ;;  ;;;  ;;;    ;;;;;      ;;;;    ;;;;;;;    ;;;;    ;;;  ;;;  ;;;;;;   
;                                                                                            
;                                                                                            
;                                                                                            
;                                                                                            
;                                                                                            



;; play-tetris : PosInt Probability -> Natural
;; Plays the tetris game with a randomized PileOfBricks
;; within a predetermined range of the number of rows
(define (play-tetris n p)
  (world-score
   (big-bang (gen-world (gen-pob n p) 0)
     (to-draw world->scene)
     (on-tick world->world TICK-RATE)
     (on-key key-handler)
     (stop-when out-of-bounds?))))

;; ------------------Image Rendering Functions-----------------

;; world->scene : World -> Image
;; Purpose Statement : To render a World onto the defined Scene
(check-expect (world->scene world1)
              (beside (piece->scene (piece-lob piece1) (pob->scene empty))
                      (draw-score 0)))
(check-expect (world->scene world2)
              (beside (piece->scene (piece-lob piece2) (pob->scene empty))
                      (draw-score 10)))

(define (world->scene w)
  (beside (piece->scene (piece-lob (world-p w)) (pob->scene (world-pob w)))
          (draw-score (world-score w))))

;; draw-score : PositiveNumber -> Image
;; Draws the Number as an Image
(check-expect (draw-score 10)
              (text (string-append "Score : " "10" "    ") 20 "blue"))
(check-expect (draw-score 0)
              (text (string-append "Score : " "0" "    ") 20 "blue"))

(define (draw-score score)
  (text (string-append "Score : " (number->string score) "    ") 20 "blue"))

;; piece->scene : NonEmptyListOfBricks Image -> Image
;; Purpose Statement : To render a Piece onto a given scene
(check-expect (piece->scene nelob1 BACKGROUND)
              (foldr brick->scene BACKGROUND nelob1))
(check-expect (piece->scene nelob2 BACKGROUND)
              (foldr brick->scene BACKGROUND nelob2))

(define (piece->scene lob scene)
  (foldr brick->scene scene lob))

;; pob->scene : [List-of Brick] -> Image
;; Draws the PileOfBrick as an Image
(check-expect
 (pob->scene (list (make-brick 1 1 "red") (make-brick 2 2 "red")))
 (foldr brick->scene BACKGROUND (list (make-brick 1 1 "red") (make-brick 2 2 "red"))))
(check-expect (pob->scene (list (make-brick 6 8 "green")))
              (foldr brick->scene BACKGROUND (list (make-brick 6 8 "green"))))

(define (pob->scene pob)
  (foldr brick->scene BACKGROUND pob))

;; brick->scene : Brick Image -> Image
;; Purpose Statement : To render a Brick onto a given scene
(check-expect (brick->scene brick1 BACKGROUND) .)
(check-expect (brick->scene brick3 BACKGROUND) .)

(define (brick->scene b scene)
  (local [;; make-outline : Brick -> Image
          ;; Adds an outline to the image of the brick
          (define (make-outline b)
            (overlay (square BRICK-SIZE OUTLINE BLACK) (brick->img b)))]
    (place-on-grid (make-outline b) (brick-x b) (brick-y b) scene)))

;; brick->img : Brick -> Image
;; Purpose Statement : To render a Brick with given color
(check-expect (brick->img brick2)
              (square BRICK-SIZE SOLID "blue"))
(check-expect (brick->img brick1)
              (square BRICK-SIZE SOLID "red"))

(define (brick->img b)
  (square BRICK-SIZE SOLID (brick-color b)))

;; place-on-grid : Image Integer Integer Image -> Image
;; Purpose Statement : performs same action as place-image, but uses grid coords
(check-expect
 (place-on-grid (brick->img brick1) 2 2 BACKGROUND) .)
(check-expect
 (place-on-grid (brick->img brick2) 6 3 BACKGROUND) .)

(define (place-on-grid img1 x y img2)
  (place-image img1 
               (+ (* BRICK-SIZE x) (quotient BRICK-SIZE 2))
               (- BOARD-HEIGHT/PIX 
                  (+ (* BRICK-SIZE y) (quotient BRICK-SIZE 2)))
               img2))

;;  ------------------Randomize and Generation Functions-----------------

;; gen-world : [List-of Brick] Natural -> World
;; Purpose Statement : Generates a random World with a PileOfBricks at a random location
(check-satisfied (gen-world empty 0) world?)

(define (gen-world pob score)
  (make-world (generate-piece (+ (random NUMOFFORMS) 1)) pob score))

;; generate-piece : Form -> Piece
;; Purpose Statement : Generates a base Piece based on Form
(check-satisfied (generate-piece 1) piece?)
(check-satisfied (generate-piece 2) piece?)
(check-satisfied (generate-piece 3) piece?)
(check-satisfied (generate-piece 4) piece?)
(check-satisfied (generate-piece 5) piece?)
(check-satisfied (generate-piece 6) piece?)
(check-satisfied (generate-piece 7) piece?)
(check-satisfied (generate-piece 8) piece?)
(check-satisfied (generate-piece 9) piece?)

(define (generate-piece t)
  (cond   [(= 1 t) (O-gen (+ 1 (random (- BOARD-WIDTH 1))) BOARD-HEIGHT)]
          [(= 2 t) (I-gen (+ 2 (random (- BOARD-WIDTH 3))) BOARD-HEIGHT)]
          [(= 3 t) (L-gen (+ 2 (random (- BOARD-WIDTH 2))) BOARD-HEIGHT)]
          [(= 4 t) (J-gen (+ 1 (random (- BOARD-WIDTH 2))) BOARD-HEIGHT)]
          [(= 5 t) (T-gen (+ 1 (random (- BOARD-WIDTH 2))) BOARD-HEIGHT)]
          [(= 6 t) (Z-gen (+ 1 (random (- BOARD-WIDTH 2))) BOARD-HEIGHT)]
          [(= 7 t) (S-gen (+ 2 (random (- BOARD-WIDTH 2))) BOARD-HEIGHT)]
          [(= 8 t) (D-gen (random BOARD-WIDTH) BOARD-HEIGHT)]
          [(= 9 t) (F-gen (+ 2 (random (- BOARD-WIDTH 4))) BOARD-HEIGHT)]))

;; O-gen : Natural Natural -> Piece
;; Purpose Statement : Generates the O Form Piece at a random X coordinate
;; within the bounds of the grid and the Y coordinate
;; as the coordinate relative to the grid height
(check-expect (O-gen 2 3) (make-piece (make-posn 2 3)
                                      (list (make-brick 1 4 "green")
                                            (make-brick 1 3 "green")
                                            (make-brick 2 4 "green")
                                            (make-brick 2 3 "green"))))
(check-expect (O-gen 9 5) (make-piece (make-posn 9 5)
                                      (list (make-brick 8 6 "green")
                                            (make-brick 8 5 "green")
                                            (make-brick 9 6 "green")
                                            (make-brick 9 5 "green")))) 

(define (O-gen x y)
  (make-piece
   (make-posn x y)
   (list (make-brick (- x 1) (+ y 1) "green")
         (make-brick (- x 1) y "green")
         (make-brick x (+ y 1) "green")
         (make-brick x y "green"))))

;; I-gen : Natural Natural -> Piece
;; Purpose Statement : Generates the I Form Piece at a random X coordinate
;; within the bounds of the grid and the Y coordinate
;; as the coordinate relative to the grid height
(check-expect (I-gen 2 3) (make-piece (make-posn 2 3)
                                      (list (make-brick 0 4 "blue")
                                            (make-brick 1 4 "blue")
                                            (make-brick 2 4 "blue")
                                            (make-brick 3 4 "blue"))))
(check-expect (I-gen 9 5) (make-piece (make-posn 9 5)
                                      (list (make-brick 7 6 "blue")
                                            (make-brick 8 6 "blue")
                                            (make-brick 9 6 "blue")
                                            (make-brick 10 6 "blue"))))

(define (I-gen x y)
  (make-piece
   (make-posn x y)
   (list (make-brick (- x 2) (+ y 1) "blue")
         (make-brick (- x 1) (+ y 1) "blue")
         (make-brick x (+ y 1) "blue")
         (make-brick (+ x 1) (+ y 1) "blue"))))


;; L-gen : Natural Natural -> Piece
;; Purpose Statement : Generates the L Form Piece at a random X coordinate
;; within the bounds of the grid and the Y coordinate
;; as the coordinate relative to the grid height
(check-expect (L-gen 2 3) (make-piece (make-posn 2 3)
                                      (list (make-brick 2 4 "purple")
                                            (make-brick 2 3 "purple")
                                            (make-brick 1 3 "purple")
                                            (make-brick 0 3 "purple"))))
(check-expect (L-gen 9 5) (make-piece (make-posn 9 5)
                                      (list (make-brick 9 6 "purple")
                                            (make-brick 9 5 "purple")
                                            (make-brick 8 5 "purple")
                                            (make-brick 7 5 "purple"))))

(define (L-gen x y)
  (make-piece
   (make-posn x y)
   (list (make-brick x (+ y 1) "purple")
         (make-brick x y "purple")
         (make-brick (- x 1) y "purple")
         (make-brick (- x 2) y "purple"))))

;; J-gen : Natural Natural -> Piece
;; Purpose Statement : Generates the J Form Piece at a random X coordinate
;; within the bounds of the grid and the Y coordinate
;; as the coordinate relative to the grid height
(check-expect (J-gen 2 3) (make-piece (make-posn 2 3)
                                      (list (make-brick 1 4 "cyan")
                                            (make-brick 1 3 "cyan")
                                            (make-brick 2 3 "cyan")
                                            (make-brick 3 3 "cyan"))))
(check-expect (J-gen 9 5) (make-piece (make-posn 9 5)
                                      (list (make-brick 8 6 "cyan")
                                            (make-brick 8 5 "cyan")
                                            (make-brick 9 5 "cyan")
                                            (make-brick 10 5 "cyan"))))

(define (J-gen x y)
  (make-piece
   (make-posn x y)
   (list (make-brick (- x 1) (+ y 1) "cyan")
         (make-brick (- x 1) y "cyan")
         (make-brick x y "cyan")
         (make-brick (+ x 1) y "cyan"))))

;; T-gen : Natural Natural -> Piece
;; Purpose Statement : Generates the T Form Piece at a random X coordinate
;; within the bounds of the grid and the Y coordinate
;; as the coordinate relative to the grid height
(check-expect (T-gen 2 3) (make-piece (make-posn 2 3)
                                      (list (make-brick 1 3 "orange")
                                            (make-brick 2 3 "orange")
                                            (make-brick 3 3 "orange")
                                            (make-brick 2 4 "orange"))))
(check-expect (T-gen 9 5) (make-piece (make-posn 9 5)
                                      (list (make-brick 8 5 "orange")
                                            (make-brick 9 5 "orange")
                                            (make-brick 10 5 "orange")
                                            (make-brick 9 6 "orange"))))

(define (T-gen x y)
  (make-piece
   (make-posn x y)
   (list (make-brick (- x 1) y "orange")
         (make-brick x y "orange")
         (make-brick (+ x 1) y "orange")
         (make-brick x (+ y 1) "orange"))))

;; Z-gen : Natural Natural -> Piece
;; Purpose Statement : Generates the Z Form Piece at a random X coordinate
;; within the bounds of the grid and the Y coordinate
;; as the coordinate relative to the grid height
(check-expect (Z-gen 2 3) (make-piece (make-posn 2 3)
                                      (list (make-brick 1 4 "pink")
                                            (make-brick 2 4 "pink")
                                            (make-brick 2 3 "pink")
                                            (make-brick 3 3 "pink"))))
(check-expect (Z-gen 9 5) (make-piece (make-posn 9 5)
                                      (list (make-brick 8 6 "pink")
                                            (make-brick 9 6 "pink")
                                            (make-brick 9 5 "pink")
                                            (make-brick 10 5 "pink"))))

(define (Z-gen x y)
  (make-piece
   (make-posn x y)
   (list (make-brick (- x 1) (+ y 1) "pink")
         (make-brick x (+ y 1) "pink")
         (make-brick x y "pink")
         (make-brick (+ x 1) y "pink"))))

;; S-gen : Natural Natural -> Piece
;; Purpose Statement : Generates the S Form Piece at a random X coordinate
;; within the bounds of the grid and the Y coordinate
;; as the coordinate relative to the grid height
(check-expect (S-gen 2 3) (make-piece (make-posn 2 3)
                                      (list (make-brick 2 4 "red")
                                            (make-brick 1 4 "red")
                                            (make-brick 1 3 "red")
                                            (make-brick 0 3 "red"))))
(check-expect (S-gen 9 5) (make-piece (make-posn 9 5)
                                      (list (make-brick 9 6 "red")
                                            (make-brick 8 6 "red")
                                            (make-brick 8 5 "red")
                                            (make-brick 7 5 "red"))))

(define (S-gen x y)
  (make-piece
   (make-posn x y)
   (list (make-brick x (+ y 1) "red")
         (make-brick (- x 1) (+ y 1) "red")
         (make-brick (- x 1) y "red")
         (make-brick (- x 2) y "red"))))

;; D-gen : Natural Natural -> Piece
;; Purpose Statement : Generates the D Form Piece at a random X coordinate
;; within the bounds of the grid and the Y coordinate
;; as the coordinate relative to the grid height
(check-expect (D-gen 2 3) (make-piece (make-posn 2 3) (list (make-brick 2 3 "magenta"))))
(check-expect (D-gen 9 5) (make-piece (make-posn 9 5) (list (make-brick 9 5 "magenta"))))

(define (D-gen x y)
  (make-piece
   (make-posn x y)
   (list (make-brick x y "magenta"))))

;; F-gen : Natural Natural -> Piece
;; Purpose Statement : Generates the F Form Piece at a random X coordinate
;; within the bounds of the grid and the Y coordinate
;; as the coordinate relative to the grid height
(check-expect (F-gen 2 3) (make-piece
                           (make-posn 2 3)
                           (list
                            (make-brick 0 3 "darkgreen")
                            (make-brick 1 3 "darkgreen")
                            (make-brick 2 3 "darkgreen")
                            (make-brick 3 3 "darkgreen")
                            (make-brick 4 3 "darkgreen"))))
(check-expect (F-gen 9 5) (make-piece
                           (make-posn 9 5)
                           (list
                            (make-brick 7 5 "darkgreen")
                            (make-brick 8 5 "darkgreen")
                            (make-brick 9 5 "darkgreen")
                            (make-brick 10 5 "darkgreen")
                            (make-brick 11 5 "darkgreen"))))

(define (F-gen x y)
  (make-piece
   (make-posn x y)
   (list (make-brick (- x 2) y "darkgreen")
         (make-brick (- x 1) y "darkgreen")
         (make-brick x y "darkgreen")
         (make-brick (+ x 1) y "darkgreen")
         (make-brick (+ x 2) y "darkgreen"))))

;; gen-pob : PosInt Probability -> [List-of Brick]
;; Generates a random list of bricks based upon a given Probability and Number of Rows
(check-satisfied (gen-pob 3 40) list?)
(check-satisfied (gen-pob 0 0) list?)

(define (gen-pob n p)
  (gen-list p (build-list 10 (lambda (x) x)) (build-list n (lambda (x) x))))

;; gen-list : Probability [List-of Number] [List-of Number] -> [List-of Brick]
;; Generates a random list of bricks based upon a given Probability
(check-satisfied (gen-list 30 (list 0 1 2 3 4 5 6 7 8 9) (list 0 1 2)) list?)
(check-satisfied (gen-list 0 (list 0 1 2 3 4 5 6 7 8 9) (list 0)) list?)

(define (gen-list pr lx ly)
  (local [;; give-lor : Integer
          ;; Gives the [List-of Number] and Probability to create-listx
          (define (give-lor i)
            (create-listx i lx pr))]
    (foldr append empty (map give-lor ly))))         

;; create-listx : Integer [List-of Number] Probability -> [List-of Brick]
;; Generates a random list of bricks for a given single row mapped onto a build-list of all columns
;; based upon the given Probability
(check-satisfied (create-listx 3 (list 0 1 2 3 4 5 6 7 8 9) 30) list?)
(check-satisfied (create-listx 0 (list 0 1 2 3 4 5 6 7 8 9) 0) list?)


(define (create-listx row lx pr)
  (filter (λ (brick) (>= pr (random 101)))
          (build-list (length lx) (λ (x) (make-random-brick x row)))))



;; make-random-brick: Natural Natural -> Brick
;; Given an x and y coordinate, a random colored brick is generate at the spot

(check-satisfied (make-random-brick 0 3) brick?)
(check-satisfied (make-random-brick 5 7) brick?)


(define (make-random-brick x y)
  (make-brick x y (random-color (random NUMOFFORMS))))



;; random-color : Natural [0,8] -> Color
;; Generates a random Color
(check-expect (random-color 2) "purple")
(check-expect (random-color 0) "green")

(define (random-color n)
  (cond [(= n 0) "green"]
        [(= n 1) "blue"]
        [(= n 2) "purple"]
        [(= n 3) "cyan"]
        [(= n 4) "orange"]
        [(= n 5) "pink"]
        [(= n 6) "red"]
        [(= n 7) "magenta"]
        [(= n 8) "darkgreen"]))

;;  ------------------Row Clearing Functions-----------------

;; need-clear? : [List-of Booleans] -> Boolean
;; Determines if we need to clear any rows
(check-expect (need-clear? (list #true #false)) #true)
(check-expect (need-clear? (list #false #false #false)) #false)

(define (need-clear? lobool)
  (ormap (λ (x) x) lobool))

;; clear-row? : [List-of Brick] -> [List-of Booleans]
;; determines if any rows in the pile of bricks need to be cleared
;; by returning the rows that need to be cleared as booleans
(check-expect (clear-row? EX-FULLROW) (list #false #false #true)) 
(check-expect (clear-row? empty) (list #false))

(define (clear-row? pob)
  (row-filled? pob (build-list (+ 1 (max-height pob)) (λ (x) x))))

;; max-height : [List-of Brick] -> Natural
;; Finds the maximum height of the rows of the PileOfBricks
(check-expect (max-height EX-FULLROW) 2)
(check-expect (max-height EX-LIST-1) 2)
(check-expect (max-height empty) 0)

(define (max-height pob)
  (foldr max 0 (map (λ (b) (brick-y b)) pob)))

;; row-filled? : [List-of Brick] [List-of Number] -> [List-of Booleans]
;; Determines which rows are filled by counting the sum of the x values for each row
;; and returns the rows that are filled
(check-expect (row-filled? EX-LIST-1 (list 0 1 2)) (list #false #false #true))
(check-expect (row-filled? EX-FULLROW (list 0 1 2)) (list #false #false #true))
(check-expect (row-filled? empty empty) empty)

(define (row-filled? pob lon)
  (local [;; check-y : Brick -> Boolean
          ;; Determines if the brick is in the same y value as the number
          (define (check-y b)
            ((λ (b y) (= (brick-y b) y)) b (first lon)))]         
    (cond [(empty? lon) empty]
          [(cons? lon) (cons (filled-row? (filter check-y pob)) (row-filled? pob (rest lon)))])))

;; filled-row? : [List-of Brick] -> Boolean
;; Takes in a row from a PieceOfBricks and determines
;; if the row is indeed full
(check-expect (filled-row? (list brick1 brick2)) #false)
(check-expect (filled-row? EX-FULLROW) #true)

(define (filled-row? lob)
  (= (/ (* (+ BOARD-WIDTH 1) BOARD-WIDTH) 2)
     (add-row lob)))

;; add-row : [List-of Brick] -> Number
;; Sums the x values of the row
(check-expect (add-row EX-FULLROW) 55)
(check-expect (add-row empty) 0)

(define (add-row lob)
  (foldr + 0 (map (λ (b) (add1 (brick-x b))) lob)))

;; clear : [List-of Brick] -> [List-of Brick]
;; Clears the rows that are filled in the PileOfBricks and moves them down accordingly
(check-expect (clear EX-LIST-1) (list
                                 (make-brick 0 0 "orange")
                                 (make-brick 1 0 "cyan")
                                 (make-brick 3 0 "pink")
                                 (make-brick 4 0 "purple")
                                 (make-brick 5 0 "red")
                                 (make-brick 7 0 "blue")
                                 (make-brick 1 1 "darkgreen")
                                 (make-brick 6 1 "red")
                                 (make-brick 7 1 "pink")
                                 (make-brick 8 1 "red")))
(check-expect (clear empty) empty)

(define (clear pob)
  (gravity (clear-rows pob (convert-lob make-list-of-y (clear-row? pob)))
           (convert-lob make-list-of-y (clear-row? pob))))

;; convert-lob :
;; [[List-of Boolean] [List-of Number] -> [List-of Number]] [List-of Boolean] -> [List-of Number]
;; Converts the [List-of Boolean] to a [List-of Number]
(check-expect (convert-lob make-list-of-y (list #true #true #false)) (list 2))
(check-expect (convert-lob make-list-of-clear (list #true #true #false)) (list 0 1))

(define (convert-lob f lob)
  (f lob (build-list ((λ (lob1) (length lob1)) lob) (λ (x) x)))) ; look at later

;; clear-rows : [List-of Brick] [List-of Number] -> [List-of Brick]
;; Clears the filled rows in the PileOfBricks
(check-expect (clear-rows EX-LIST-1 (list 0 1))
              (list
               (make-brick 0 0 "orange")
               (make-brick 1 0 "cyan")
               (make-brick 3 0 "pink")
               (make-brick 4 0 "purple")
               (make-brick 5 0 "red")
               (make-brick 7 0 "blue")
               (make-brick 1 1 "darkgreen")
               (make-brick 6 1 "red")
               (make-brick 7 1 "pink")
               (make-brick 8 1 "red")))
(check-expect (clear-rows empty empty) empty)

(define (clear-rows pob lon)
  (local (;; expedite-filter : Brick -> [List-of Brick]
          ;; Expedite parameters for the filter
          (define (expedite-filter b)
            (= (first lon) (brick-y b))))
    (cond [(empty? lon) empty]
          [(cons? lon) (append (filter expedite-filter pob) (clear-rows pob (rest lon)))])))

;; make-list-of-y : [List-of Boolean] [List-of Number] -> [List-of Number]
;; Converts the [List-of Boolean] to a [List-of Number]
;; where the result is all rows that are not filled
(check-expect (make-list-of-y (list #true #true #false) (list 0 1 2)) (list 2))
(check-expect (make-list-of-y (list #true #true #false #true #false) (list 0 1 2 3 4)) (list 2 4))

(define (make-list-of-y lob lon)
  (cond [(empty? lob) empty]
        [(cons? lob) (if (not (first lob))
                         (cons (first lon) (make-list-of-y (rest lob) (rest lon)))
                         (make-list-of-y (rest lob) (rest lon)))]))

;; make-list-of-clear : [List-of Boolean] [List-of Number] -> [List-of Number]
;; Converts the [List-of Boolean] to a [List-of Number]
;; where the result is all rows that are filled
(check-expect (make-list-of-clear (list #true #true #false) (list 0 1 2)) (list 0 1))
(check-expect (make-list-of-clear
               (list #true #true #false #true #false) (list 0 1 2 3 4)) (list 0 1 3))

(define (make-list-of-clear lob lon)
  (cond [(empty? lob) empty]
        [(cons? lob) (if (first lob)
                         (cons (first lon) (make-list-of-clear (rest lob) (rest lon)))
                         (make-list-of-clear (rest lob) (rest lon)))]))

            
;; -------------------Gravity Functions-----------------

;; gravity : [List-of Brick] [List-of Number] -> [List-of Brick]
;; Moves down the rows of the [List-of Brick] to account for the clears
(check-expect (gravity (list 
                        (make-brick 0 0 "orange")
                        (make-brick 1 0 "cyan")
                        (make-brick 3 0 "pink")
                        (make-brick 4 0 "purple")
                        (make-brick 5 0 "red")
                        (make-brick 7 0 "blue")
                        (make-brick 1 1 "darkgreen")
                        (make-brick 6 1 "red")
                        (make-brick 7 1 "pink")
                        (make-brick 8 1 "red")
                        (make-brick 0 3 "pink")
                        (make-brick 1 3 "magenta")
                        (make-brick 2 3 "green")
                        (make-brick 3 3 "darkgreen")
                        (make-brick 4 3 "red")
                        (make-brick 5 3 "orange")
                        (make-brick 6 3 "pink")
                        (make-brick 7 3 "purple")
                        (make-brick 8 3 "blue")
                        (make-brick 9 3 "purple"))
                       (list 0 1 3))
              (list 
               (make-brick 0 0 "orange")
               (make-brick 1 0 "cyan")
               (make-brick 3 0 "pink")
               (make-brick 4 0 "purple")
               (make-brick 5 0 "red")
               (make-brick 7 0 "blue")
               (make-brick 1 1 "darkgreen")
               (make-brick 6 1 "red")
               (make-brick 7 1 "pink")
               (make-brick 8 1 "red")
               (make-brick 0 2 "pink")
               (make-brick 1 2 "magenta")
               (make-brick 2 2 "green")
               (make-brick 3 2 "darkgreen")
               (make-brick 4 2 "red")
               (make-brick 5 2 "orange")
               (make-brick 6 2 "pink")
               (make-brick 7 2 "purple")
               (make-brick 8 2 "blue")
               (make-brick 9 2 "purple")))
(check-expect (gravity empty empty) empty)

(define (gravity pob lon)
  (help-gravity pob lon (build-list ((λ (lon1) (length lon1)) lon) (λ (x) x))))

;; help-gravity : [List-of Brick] [List-of Number] [List-of Number] -> [List-of Brick]
;; Compares the list of rows that were not cleared and a list of numbers of the same length
;; and index each row and replaces the y value in the [List-of Brick] with the associated
;; number
(check-expect (help-gravity
               (list 
                (make-brick 0 0 "orange")
                (make-brick 1 0 "cyan")
                (make-brick 3 0 "pink")
                (make-brick 4 0 "purple")
                (make-brick 5 0 "red")
                (make-brick 7 0 "blue")
                (make-brick 1 1 "darkgreen")
                (make-brick 6 1 "red")
                (make-brick 7 1 "pink")
                (make-brick 8 1 "red")
                (make-brick 0 3 "pink")
                (make-brick 1 3 "magenta")
                (make-brick 2 3 "green")
                (make-brick 3 3 "darkgreen")
                (make-brick 4 3 "red")
                (make-brick 5 3 "orange")
                (make-brick 6 3 "pink")
                (make-brick 7 3 "purple")
                (make-brick 8 3 "blue")
                (make-brick 9 3 "purple"))
               (list 0 1 3)
               (list 0 1 2))
              (list 
               (make-brick 0 0 "orange")
               (make-brick 1 0 "cyan")
               (make-brick 3 0 "pink")
               (make-brick 4 0 "purple")
               (make-brick 5 0 "red")
               (make-brick 7 0 "blue")
               (make-brick 1 1 "darkgreen")
               (make-brick 6 1 "red")
               (make-brick 7 1 "pink")
               (make-brick 8 1 "red")
               (make-brick 0 2 "pink")
               (make-brick 1 2 "magenta")
               (make-brick 2 2 "green")
               (make-brick 3 2 "darkgreen")
               (make-brick 4 2 "red")
               (make-brick 5 2 "orange")
               (make-brick 6 2 "pink")
               (make-brick 7 2 "purple")
               (make-brick 8 2 "blue")
               (make-brick 9 2 "purple")))
(check-expect (help-gravity empty empty empty) empty)

(define (help-gravity pob lor lon)
  (local (;; y-value-same? : Brick -> [List-of Brick]
          ;; Checks if the y value of the brick is the same as that of the list of rows
          (define (y-value-same? b)
            (= (first lor) (brick-y b))))
    (cond [(empty? lon) empty]
          [(cons? lon) (append (move-down-to (first lon) (filter y-value-same? pob))
                               (help-gravity pob (rest lor) (rest lon)))])))

;; move-down-to : Number [List-of Brick] -> [List-of Brick]
;; Moves the row down to y value given
(check-expect (move-down-to 3
                            (list
                             (make-brick 0 4 "orange")
                             (make-brick 1 4 "orange")
                             (make-brick 3 4 "orange")
                             (make-brick 6 4 "orange")
                             (make-brick 9 4 "orange")))
              (list
               (make-brick 0 3 "orange")
               (make-brick 1 3 "orange")
               (make-brick 3 3 "orange")
               (make-brick 6 3 "orange")
               (make-brick 9 3 "orange")))
(check-expect (move-down-to 0 empty) empty)

(define (move-down-to num pob)
  (map (λ (b) (make-brick (brick-x b) num (brick-color b))) pob))


;; -------------------Key Handler Function-----------------

;; key-handler : World Key-Event -> World
;; Purpose Statement : To take in user input and modify the World based on its current condition
(check-expect (key-handler world1 "left")
              (make-world (make-piece (make-posn 0 1) (list (make-brick 0 1 "red"))) empty 0))
(check-expect (key-handler world1 "right")
              (make-world (make-piece (make-posn 2 1) (list (make-brick 2 1 "red"))) empty 0))
(check-expect (key-handler world1 "a")
              (make-world (make-piece (make-posn 1 1) (list (make-brick 1 1 "red"))) empty 0))
(check-expect (key-handler world1 "s")
              (make-world (make-piece (make-posn 1 1) (list (make-brick 1 1 "red"))) empty 0))

(define (key-handler w key)
  (cond [(key=? key "left")
         (move-piece-checker (world-p w) (world-pob w) -1 0 (world-score w))]
        [(key=? key "right")
         (move-piece-checker (world-p w) (world-pob w) 1 0 (world-score w))]
        [(key=? key "a")
         (rotate-piece-checker (world-p w) (world-pob w) "clockwise" (world-score w))]
        [(key=? key "s")
         (rotate-piece-checker (world-p w) (world-pob w) "counter-clockwise" (world-score w))]
        [else w]))

;;  ------------------Rotation Functions-----------------

;; rotate-piece-checker : Piece [List-of Brick] Rotation Natural -> World
;; Purpose Statement : Checks if the rotated piece is within the bounds of the grid
(check-expect (rotate-piece-checker piece1 empty "clockwise" 0)
              (make-world (make-piece (make-posn 1 1) (list (make-brick 1 1 "red"))) empty 0))
(check-expect (rotate-piece-checker piece1 empty "counter-clockwise" 0)
              (make-world (make-piece (make-posn 1 1) (list (make-brick 1 1 "red"))) empty 0))

(define (rotate-piece-checker p pob dir score)
  (if (or (pob-lob-touch? (rotate-piece p dir) pob)
          (wall-touch?
           (make-world (make-piece (piece-c p) (rotate-piece p dir)) pob score)))
      (make-world p pob score)
      (make-world (make-piece (piece-c p) (rotate-piece p dir)) pob score)))

;; rotate-piece : Piece Rotation -> NonEmptyListOfBricks
;; Rotates a piece based on a given Rotation and gives the new NonEmptyListOfBricks
(check-expect (rotate-piece piece1 "clockwise")
              (list (make-brick 1 1 "red")))
(check-expect (rotate-piece piece1 "counter-clockwise")
              (list (make-brick 1 1 "red")))

(define (rotate-piece p dir)
  (cond [(string=? dir "clockwise")
         (rotate-lob-clockwise (piece-lob p) (piece-c p))]
        [(string=? dir "counter-clockwise")
         (rotate-lob-counter (piece-lob p) (piece-c p))]))

;; rotate-lob-counter : NonEmptyListOfBricks Posn -> NonEmptyListOfBricks
;; Purpose Statement : Rotates each brick in a NeLOB counterclockwise
(check-expect (rotate-lob-counter nelob1 (make-posn 1 1)) (list (make-brick 1 1 "red")))
(check-expect (rotate-lob-counter nelob3 (make-posn 1 1)) 
              (list (make-brick 2 -4 "yellow")
                    (make-brick 12 0 "blue")
                    (make-brick 1 1 "red")))

(define (rotate-lob-counter lob posn)
  (map (lambda (b) (rotate-brick-counter posn b)) lob))
    
;; rotate-lob-clockwise : NonEmptyListOfBricks Posn -> NonEmptyListOfBricks
;; Purpose Statement : Rotates each brick in a NeLOB clockwise
(check-expect (rotate-lob-clockwise nelob2 (make-posn 1 1))
              (list (make-brick -10 2 "blue") (make-brick 1 1 "red")))
(check-expect (rotate-lob-clockwise nelob3 (make-posn 2 2))
              (list (make-brick 2 6 "yellow") (make-brick -8 2 "blue") (make-brick 3 1 "red")))

(define (rotate-lob-clockwise lob posn)
  (map (lambda (b) (rotate-brick-clockwise posn b)) lob))

;; rotate-brick-counter : Posn Brick -> Brick
;; Purpose Statement : To rotate the brick _b_ 90 degrees counterclockwise around the center _c_.
(check-expect (rotate-brick-counter (make-posn 1 1) brick1) (make-brick 1 1 "red"))
(check-expect (rotate-brick-counter (make-posn 6 7) brick3) (make-brick 1 7 "yellow"))

(define (rotate-brick-counter posn b)
  (rotate-brick-clockwise posn (rotate-brick-clockwise posn (rotate-brick-clockwise posn b))))
         
;; rotate-brick-clockwise : Posn Brick -> Brick
;; Purpose Statement : To rotate the brick _b_ 90 degrees clockwise around the center _c_.
(check-expect (rotate-brick-clockwise (make-posn 6 7) brick3) (make-brick 11 7 "yellow"))
(check-expect (rotate-brick-clockwise (make-posn 1 1) brick1) (make-brick 1 1 "red"))

(define (rotate-brick-clockwise c b)
  (make-brick (+ (posn-x c)
                 (- (posn-y c)
                    (brick-y b)))
              (+ (posn-y c)
                 (- (brick-x b)
                    (posn-x c)))
              (brick-color b)))

;; -------------------Direction Functions-----------------

;; move-piece-checker : Piece [List-of Brick] Integer Integer Natural -> World
;; Purpose Statement : Makes sure that the Piece is within the bounds of the grid
(check-expect (move-piece-checker
               (make-piece (make-posn 0 0) (list (make-brick 0 0 "red"))) empty -1 0 0)
              (make-world (make-piece (make-posn 0 0) (list (make-brick 0 0 "red"))) empty 0))
(check-expect (move-piece-checker
               (make-piece (make-posn 10 16) (list (make-brick 10 16 "red"))) empty 1 0 0)
              (make-world (make-piece (make-posn 10 16) (list (make-brick 10 16 "red"))) empty 0))

(define (move-piece-checker p pob x y score)
  (if (or (pob-lob-touch?
           (piece-lob (world-p (move-piece p pob x y score)))
           (world-pob (move-piece p pob x y score)))
          (wall-touch?
           (move-piece p pob x y score))) (make-world p pob score) (move-piece p pob x y score))) 

;; move-piece : Piece [List-of Brick] Integer Integer Natural -> World
;; Purpose Statement : To move the Piece based on given value
(check-expect (move-piece piece1 empty 1 1 0)
              (make-world (make-piece (make-posn 2 2) (list (make-brick 2 2 "red"))) empty 0))
(check-expect (move-piece piece3 empty 1 2 0)
              (make-world (make-piece
                           (make-posn 10 4)
                           (list (make-brick 7 4 "yellow")
                                 (make-brick 3 14 "blue")
                                 (make-brick 2 3 "red"))) '() 0))

(define (move-piece p pob x y score)
  (make-world (make-piece
               (make-posn
                (+ x (posn-x (piece-c p)))
                (+ y (posn-y (piece-c p))))
               (perform-movement (piece-lob p) x y)) pob score))

;; perform-movement : NeLOB Integer Integer -> NonEmptyListOfBricks
;; Purpose Statement : Adds the pertinent values to the bricks in the NeLOB
(check-expect (perform-movement nelob1 1 1) (list (make-brick 2 2 "red")))
(check-expect (perform-movement nelob4 2 2)
              (list
               (make-brick 7 11 "purple")
               (make-brick 8 4 "yellow")
               (make-brick 4 14 "blue")
               (make-brick 3 3 "red")))

(define (perform-movement lob x y)
  (map (lambda (b) (new-brick b x y)) lob))
    
;; new-brick : Brick Integer Integer -> Brick
;; Purpose Statement : Performs the adding operation, then makes a new brick
(check-expect (new-brick brick1 1 1) (make-brick 2 2 "red"))
(check-expect (new-brick brick2 9 19) (make-brick 11 31 "blue"))

(define (new-brick b x y)
  (make-brick (+ x (brick-x b)) (+ y (brick-y b)) (brick-color b)))

;; -------------------Collide Functions-----------------

;; wall-touch? : World -> Boolean
;; Purpose Statement : Determines if the given World is outside the bounds of the grid
(check-expect (wall-touch?
               (make-world
                (make-piece (make-posn 3 3)
                            (list (make-brick 401 322 "red"))) empty 0)) #true)
(check-expect (wall-touch?
               (make-world
                (make-piece (make-posn 3 3)
                            (list (make-brick 5 20 "red"))) empty 0)) #false)

(define (wall-touch? w)
  (lob-touch? (piece-lob (world-p w))))

;; lob-touch? : NonEmptyListOfBricks -> Boolean
;; Purpose Statement : Determines if the given NonEmptyListOfBricks is outside the bounds of the grid
(check-expect (lob-touch? nelob1) #false)
(check-expect (lob-touch? (list (make-brick 401 322 "red"))) #true)
(check-expect (lob-touch? (list (make-brick 233 32 "red") brick1)) #true)

(define (lob-touch? lob)
  (ormap brick-touch? lob))

;; brick-touch? : Brick -> Boolean
;; Purpose Statement : Determines if the given Brick is outside the bounds of the grid
(check-expect (brick-touch? brick1) #false)
(check-expect (brick-touch? (make-brick 401 322 "red")) #true)
(check-expect (brick-touch? (make-brick -1 -3 "red")) #true)

(define (brick-touch? b)
  (or (< (brick-x b) 0)
      (> (brick-x b) (- BOARD-WIDTH 1))
      (> (brick-y b) BOARD-HEIGHT)))

;; floor-or-pob-touch? : World -> Boolean
;; Determines if the given World has touched the floor of the grid
(check-expect (floor-or-pob-touch?
               (make-world
                (make-piece (make-posn 0 -1)
                            (list (make-brick 0 -1 "red"))) empty 0)) #true)
(check-expect (floor-or-pob-touch?
               (make-world
                (make-piece (make-posn 1 1)
                            (list (make-brick 1 1 "green"))) empty 0)) #false)

(define (floor-or-pob-touch? w)
  (or (floor-lob-touch?
       (piece-lob (world-p w))) (pob-lob-touch? (piece-lob (world-p w)) (world-pob w))))

;; floor-lob-touch? : NonEmptyListOfBricks -> Boolean
;; Determines if the given NonEmptyListOfBricks has touched the floor of the grid
(check-expect (floor-lob-touch? (list (make-brick 0 -1 "red"))) #true)
(check-expect (floor-lob-touch? (list (make-brick 1 1 "green"))) #false)

(define (floor-lob-touch? lob)
  (ormap floor-brick-touch? lob))

;; floor-brick-touch? : Brick -> Boolean
;; Determines if the given Brick has touched the floor of the grid
(check-expect (floor-brick-touch? (make-brick 0 -1 "red")) #true)
(check-expect (floor-brick-touch? (make-brick 1 1 "green")) #false)

(define (floor-brick-touch? b)
  (< (brick-y b) 0))

;; pob-lob-touch? : NonEmptyListOfBricks [List-of Brick] -> Boolean
;; Determines if any of the pieces in the NeLOB have touched the PileOfBricks
(check-expect (pob-lob-touch?
               (list (make-brick 1 3 "red") (make-brick 2 3 "red"))
               (list (make-brick 1 3 "red") (make-brick 3 3 "red"))) #true)
(check-expect (pob-lob-touch?
               (list (make-brick 1 3 "red") (make-brick 2 3 "red"))
               (list (make-brick 5 3 "red") (make-brick 3 3 "red"))) #false)

(define (pob-lob-touch? lob pob)
  (local [;; expedite-pob-b : Brick -> Boolean
          ;; Expedites the two parameters into one for pob-b-touch?
          (define (expedite-pob-b b2)
            (pob-b-touch? b2 pob))]
    (ormap expedite-pob-b lob)))

;; pob-b-touch? : Brick [List-of Brick] -> Boolean
;; Determines if the given Brick from the Piece
;; is colliding with any of the Bricks in the PileOfBricks
(check-expect (pob-b-touch? (make-brick 1 3 "red")
                            (list (make-brick 1 3 "red") (make-brick 2 3 "red"))) #true)
(check-expect (pob-b-touch? (make-brick 4 3 "red")
                            (list (make-brick 1 3 "red") (make-brick 2 3 "red"))) #false)

(define (pob-b-touch? b pob)
  (local [;; expedite-b-b : Brick -> Boolean
          ;; Expedites the two parameters into one for b-b-collide?
          (define (expedite-b-b b1)
            (b-b-collide? b b1))]
    (ormap expedite-b-b pob)))

;; b-b-collide? : Brick Brick -> Boolean
;; Determines if the given Brick has touched another Brick
(check-expect (b-b-collide? (make-brick 1 1 "red") (make-brick 1 1 "red")) #true)
(check-expect (b-b-collide? (make-brick 1 1 "red") (make-brick 1 0 "red")) #false)

(define (b-b-collide? gb ab)
  (and (= (brick-x gb) (brick-x ab)) (= (brick-y gb) (brick-y ab))))

;; out-of-bounds? : World -> Boolean
;; Determines whether the World has pierced the heavens and gone above the grid D:
(check-expect (out-of-bounds? world1) #false)
(check-expect (out-of-bounds? (make-world
                               (make-piece (make-posn 3 3) (list (make-brick 3 3 "red")))
                               (list (make-brick 1 21 "red")) 0)) #true)

(define (out-of-bounds? w)
  (pob-out-of-bounds? (world-pob w)))

;; pob-out-of-bounds? : [List-of Brick] -> Boolean
;; Determines whether the PileOfBricks has pierced the heavens and gone above the grid
(check-expect (pob-out-of-bounds? (list (make-brick 1 21 "red"))) #true)
(check-expect (pob-out-of-bounds? empty) #false)

(define (pob-out-of-bounds? pob)
  (ormap (λ (b) (>= (brick-y b) BOARD-HEIGHT)) pob))
           
;; -------------------On-Tick Functions-----------------

;; world->world : World -> World
;; Purpose Statement : moves the world one step
(check-satisfied (world->world
                  (make-world (make-piece (make-posn 9 21)
                                          (list (make-brick 9 -1 "red"))) empty 0)) world?)
(check-expect
 (world->world world1)
 (make-world (make-piece (make-posn 1 0) (list (make-brick 1 0 "red"))) empty 0))
(check-expect
 (world->world world2)
 (make-world
  (make-piece (make-posn 3 10) (list (make-brick 2 11 "blue") (make-brick 1 0 "red"))) empty 10))

(define (world->world w)
  (if (floor-or-pob-touch? (move-piece (world-p w) (world-pob w) 0 -1 (world-score w)))
      (gen-world (world->pob w)
                 (calc-score w))
      (move-piece (world-p w) (world-pob w) 0 -1 (world-score w))))

;; calc-score : World -> Natural
;; Calculates the new score to be added to the existing score
(check-expect (calc-score (make-world piece1
                                      (list
                                       (make-brick 1 2 "magenta")
                                       (make-brick 0 0 "orange")
                                       (make-brick 1 0 "cyan")
                                       (make-brick 3 0 "pink")
                                       (make-brick 4 0 "purple")
                                       (make-brick 5 0 "red")
                                       (make-brick 7 0 "blue")
                                       (make-brick 1 1 "darkgreen")
                                       (make-brick 6 1 "red")
                                       (make-brick 7 1 "pink")
                                       (make-brick 8 1 "red"))
                                      0))
              0)
(check-expect (calc-score (make-world piece1
                                      (list
                                       (make-brick 1 2 "magenta")
                                       (make-brick 0 0 "orange")
                                       (make-brick 1 0 "cyan")
                                       (make-brick 3 0 "pink")
                                       (make-brick 4 0 "purple")
                                       (make-brick 5 0 "red")
                                       (make-brick 7 0 "blue")
                                       (make-brick 1 1 "darkgreen")
                                       (make-brick 6 1 "red")
                                       (make-brick 7 1 "pink")
                                       (make-brick 8 1 "red")
                                       (make-brick 0 2 "pink")
                                       (make-brick 2 2 "green")
                                       (make-brick 3 2 "darkgreen")
                                       (make-brick 4 2 "red")
                                       (make-brick 5 2 "orange")
                                       (make-brick 6 2 "pink")
                                       (make-brick 7 2 "purple")
                                       (make-brick 8 2 "blue")
                                       (make-brick 9 2 "purple"))
                                      0))
              10)
(check-expect (calc-score (make-world piece1
                                      (list
                                       (make-brick 1 2 "magenta")
                                       (make-brick 0 0 "orange")
                                       (make-brick 1 0 "cyan")
                                       (make-brick 3 0 "pink")
                                       (make-brick 4 0 "purple")
                                       (make-brick 5 0 "red")
                                       (make-brick 7 0 "blue")
                                       (make-brick 1 1 "darkgreen")
                                       (make-brick 6 1 "red")
                                       (make-brick 7 1 "pink")
                                       (make-brick 8 1 "red")
                                       (make-brick 0 2 "pink")
                                       (make-brick 2 2 "green")
                                       (make-brick 3 2 "darkgreen")
                                       (make-brick 4 2 "red")
                                       (make-brick 5 2 "orange")
                                       (make-brick 6 2 "pink")
                                       (make-brick 7 2 "purple")
                                       (make-brick 8 2 "blue")
                                       (make-brick 9 2 "purple")
                                       (make-brick 0 3 "pink")
                                       (make-brick 1 3 "magenta")
                                       (make-brick 2 3 "green")
                                       (make-brick 3 3 "darkgreen")
                                       (make-brick 4 3 "red")
                                       (make-brick 5 3 "orange")
                                       (make-brick 6 3 "pink")
                                       (make-brick 7 3 "purple")
                                       (make-brick 8 3 "blue")
                                       (make-brick 9 3 "purple"))
                                      20))
              60)

(define (calc-score w)
  (+
   (* 10 (sqr (length (convert-lob make-list-of-clear
                                   (clear-row?
                                    (append (piece-lob (world-p w)) (world-pob w)))))))
   (world-score w)))

;; world->pob : World -> [List-of Brick]
;; Adds the Piece in the world to the PileOfBricks
(check-expect
 (world->pob
  (make-world (make-piece (make-posn 1 1)
                          (list (make-brick 1 1 "red"))) (list (make-brick 0 0 "green")) 0))
 (list
  (make-brick 0 0 "green")
  (make-brick 1 1 "red")))
(check-expect
 (world->pob
  (make-world (make-piece (make-posn 2 2)
                          (list (make-brick 0 0 "red"))) empty 0))
 (list
  (make-brick 0 0 "red")))

(define (world->pob w)
  (clear (append (piece-lob (world-p w)) (world-pob w))))
