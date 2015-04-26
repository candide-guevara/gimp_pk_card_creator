;	Pokemon Trainer card parameters
;
;	Constant-prefix : TR1
;	cm / pixel = 75
;	Esteban Guevara
;	2008

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CARD PARAMETERS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define TR1_CARD_PATTERN "Paper")

(define TR1_IMAGE_DIMENSION '(383 210))
(define TR1_IMAGE_CORNER '(45 150))
(define TR1_IMAGE_SH '(8 8 15 (200 200 200) 80))

(define TR1_DESCRIPTION_DIMENSION '(383 225))
(define TR1_DESCRIPTION_CORNER '(45 383))
(define TR1_DESCRIPTION_MARGIN 10)
(define TR1_DESCRIPTION_SH '(8 8 15 (100 100 130) 80))
(define TR1_DESCRIPTION_PATTERN "Rain")

(define TR1_DESCRIPTION_FONT_COLOR '(100 0 0))
(define TR1_DESCRIPTION_FONT "Comic Sans MS")
(define TR1_DESCRIPTION_FONT_SIZE 20)

(define TR1_NAME_CORNER '(45 118))

(define TR1_NAME_FONT_COLOR '(0 0 0))
(define TR1_NAME_FONT "Sans")
(define TR1_NAME_FONT_SIZE 24)

(define TR1_TRAINER_DIMENSION '(383 68))
(define TR1_TRAINER_CORNER '(45 35))
(define TR1_TRAINER_SH '(8 8 15 (100 100 100) 80))
(define TR1_TRAINER_PATTERN "Crystals")

(define TR1_TRAINER_FONT_COLOR '(155 0 0))
(define TR1_TRAINER_FONT "Exocet Heavy")
(define TR1_TRAINER_FONT_SIZE 36)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LAYER NAMES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define TR1_LY_BACKGROUND 			"Background")
(define TR1_LY_TRAINER_BACK 			"Trainer Background")
(define TR1_LY_TRAINER 					"Trainer")
(define TR1_LY_NAME 						"Name")
(define TR1_LY_IMAGE 						"Image")
(define TR1_LY_DESCRIPTION_BACK	"Description Background")
(define TR1_LY_DESCRIPTION 			"Description")


