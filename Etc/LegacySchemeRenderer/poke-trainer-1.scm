;	Pokemon trainer card maker script 1
;
;	Description : Creates pokemon trainer cards.
;	Returns the created image.
;
;	Dependence : trainer-card-paramenters, pk-card-parameters
;							string-functions.scm, access-layers.scm
;	Function-prefix : trainer1
;
;	Date : 17 / 08 / 2008
;	Author : Guevara

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; HELPER FUNCTIONS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SAVE IMAGE
(define ( trainer1-save-image
				image filename)
(let* ( (xcfFilename (string-append filename ".xcf"))
		   (pngFilename (string-append filename ".png"))
		)
	(gimp-xcf-save 0 image image (string-append TRAINER_DIR xcfFilename)
		(string-append TRAINER_DIR xcfFilename))
	(file-png-save RUN-NONINTERACTIVE image (car (gimp-image-merge-visible-layers
		image EXPAND-AS-NECESSARY)) (string-append TRAINER_DIR pngFilename) 
		(string-append TRAINER_DIR pngFilename) FALSE 9 TRUE FALSE FALSE TRUE TRUE)
))

;;;;;;;;;;;;;;;;;;;;;; DRAW BACKGROUND
(define ( trainer1-draw-background
				 image)
(let* ( (layer -1)
		)
	(set! layer (car
		(gimp-layer-new image (car CARD_DIMENSION) (cadr CARD_DIMENSION)
			RGBA-IMAGE TR1_LY_BACKGROUND 100 NORMAL-MODE)))
	(gimp-image-add-layer image layer 0)
	(gimp-context-set-pattern TR1_CARD_PATTERN)
	(gimp-drawable-fill layer PATTERN-FILL)
	
	(gimp-selection-all image)
	(gimp-rect-select image CARD_BORDER CARD_BORDER 
		(- (car CARD_DIMENSION) CARD_BORDER CARD_BORDER)
		(- (cadr CARD_DIMENSION) CARD_BORDER CARD_BORDER)
		CHANNEL-OP-SUBTRACT FALSE 0)
	
	(gimp-context-set-gradient GRAD_CARD_BORDER)
	(gimp-edit-blend layer CUSTOM-MODE NORMAL-MODE GRADIENT-LINEAR
		100 0 REPEAT-NONE FALSE FALSE 1 0 TRUE 
		CARD_BORDER CARD_BORDER
		(- (car CARD_DIMENSION) CARD_BORDER) (- (cadr CARD_DIMENSION) CARD_BORDER))
	(gimp-drawable-set-name layer TR1_LY_BACKGROUND)
	
	layer
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW IMAGE
(define ( trainer1-draw-image
				image imageFile)
(let* ( (layer -1) 
		)		
	(set! layer (car (gimp-file-load-layer
		RUN-NONINTERACTIVE image imageFile)))	
	(gimp-image-add-layer image layer 0)
	
	(gimp-layer-scale layer (car TR1_IMAGE_DIMENSION) (cadr TR1_IMAGE_DIMENSION) FALSE)
	(gimp-layer-set-offsets layer (car TR1_IMAGE_CORNER) (cadr TR1_IMAGE_CORNER))
	
	(gimp-rect-select image (car TR1_IMAGE_CORNER) (cadr TR1_IMAGE_CORNER) 
		(car TR1_IMAGE_DIMENSION) (cadr TR1_IMAGE_DIMENSION) CHANNEL-OP-REPLACE
		FALSE 0)
	(script-fu-drop-shadow image layer (car TR1_IMAGE_SH) (cadr TR1_IMAGE_SH) 
		(caddr TR1_IMAGE_SH) (list-ref TR1_IMAGE_SH 3) (list-ref TR1_IMAGE_SH 4) TRUE)
	(set! layer (car (gimp-image-merge-down image 
		(get-layer-by-index image 0) EXPAND-AS-NECESSARY)))	
	(gimp-drawable-set-name layer TR1_LY_IMAGE)
	
	layer
))

;;;;;;;;;;;;;;;;;;;;;; DRAW TRAINER BACK
(define ( trainer1-draw-trainer-back
				image)
(let* ( (layer -1)
		)
	(set! layer (car
		(gimp-layer-new image (car TR1_TRAINER_DIMENSION) (cadr TR1_TRAINER_DIMENSION)
			RGBA-IMAGE TR1_LY_BACKGROUND 100 NORMAL-MODE)))
	(gimp-image-add-layer image layer 0)
	(gimp-context-set-pattern TR1_TRAINER_PATTERN)
	(gimp-drawable-fill layer PATTERN-FILL)
	(gimp-layer-set-offsets layer (car TR1_TRAINER_CORNER) (cadr TR1_TRAINER_CORNER))
	
	(gimp-rect-select image (car TR1_TRAINER_CORNER) (cadr TR1_TRAINER_CORNER) 
		(car TR1_TRAINER_DIMENSION) (cadr TR1_TRAINER_DIMENSION) CHANNEL-OP-REPLACE
		FALSE 0)
	(script-fu-drop-shadow image layer (car TR1_TRAINER_SH) (cadr TR1_TRAINER_SH) 
		(caddr TR1_TRAINER_SH) (list-ref TR1_TRAINER_SH 3) (list-ref TR1_TRAINER_SH 4) TRUE)
	(set! layer (car (gimp-image-merge-down image 
		(get-layer-by-index image 0) EXPAND-AS-NECESSARY)))	
	(gimp-drawable-set-name layer TR1_LY_TRAINER_BACK)
	
	layer
))

;;;;;;;;;;;;;;;;;;;;;; DRAW DESCRIPTION BACK
(define ( trainer1-draw-description-back
				image)
(let* ( (layer -1)
		)
	(set! layer (car
		(gimp-layer-new image (car TR1_DESCRIPTION_DIMENSION) (cadr TR1_DESCRIPTION_DIMENSION)
			RGBA-IMAGE TR1_LY_BACKGROUND 100 NORMAL-MODE)))
	(gimp-image-add-layer image layer 0)
	(gimp-context-set-pattern TR1_DESCRIPTION_PATTERN)
	(gimp-drawable-fill layer PATTERN-FILL)
	(gimp-layer-set-offsets layer (car TR1_DESCRIPTION_CORNER) 
		(cadr TR1_DESCRIPTION_CORNER))
	
	(gimp-rect-select image (car TR1_DESCRIPTION_CORNER) (cadr TR1_DESCRIPTION_CORNER) 
		(car TR1_DESCRIPTION_DIMENSION) (cadr TR1_DESCRIPTION_DIMENSION) 
		CHANNEL-OP-REPLACE
		FALSE 0)
	(script-fu-drop-shadow image layer (car TR1_DESCRIPTION_SH) (cadr TR1_DESCRIPTION_SH) 
		(caddr TR1_DESCRIPTION_SH) (list-ref TR1_DESCRIPTION_SH 3) 
		(list-ref TR1_DESCRIPTION_SH 4) TRUE)
	(set! layer (car (gimp-image-merge-down image 
		(get-layer-by-index image 0) EXPAND-AS-NECESSARY)))	
	(gimp-hue-saturation layer ALL-HUES 0 -10 -80)
	(gimp-drawable-set-name layer TR1_LY_DESCRIPTION_BACK)
	
	layer
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW BACKGROUND LAYERS
(define ( trainer1-draw-background-layers
				image imageFile)
(let* ( (backgroundLayer -1) (imageLayer -1)
			(trainerBackLayer -1) (descriptionBackLayer -1)
		)
	(set! backgroundLayer (trainer1-draw-background image))
	(set! imageLayer (trainer1-draw-image image imageFile))
	(set! trainerBackLayer (trainer1-draw-trainer-back image))
	(set! descriptionBackLayer (trainer1-draw-description-back image))
	
	(list backgroundLayer imageLayer trainerBackLayer descriptionBackLayer)
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW TEXT LAYERS
(define ( trainer1-draw-text-layers
				 image name description )
(let* ( (trainerLayer -1) (nameLayer -1) (descriptionLayer -1)
			(tempStr "") (alignX 0) (alignY 0)
		)
	(gimp-context-set-foreground TR1_TRAINER_FONT_COLOR)
	(set! trainerLayer (car (gimp-text-fontname image -1 0 0
		"TRAINER" -1 TRUE TR1_TRAINER_FONT_SIZE PIXELS TR1_TRAINER_FONT)))
		
	(set! alignX (/ (- (car CARD_DIMENSION) (car (gimp-drawable-width 
		trainerLayer))) 2))	
	(set! alignY (+ (/ (- (cadr TR1_TRAINER_DIMENSION) (car (gimp-drawable-height 
		trainerLayer))) 2) (cadr TR1_TRAINER_CORNER)))
	(gimp-layer-set-offsets trainerLayer alignX alignY)
	(gimp-drawable-set-name trainerLayer TR1_LY_TRAINER)
	
	(gimp-context-set-foreground TR1_NAME_FONT_COLOR)
	(set! nameLayer (car (gimp-text-fontname image -1 (car TR1_NAME_CORNER)
		(cadr TR1_NAME_CORNER) name -1 TRUE TR1_NAME_FONT_SIZE PIXELS TR1_NAME_FONT)))
	(gimp-drawable-set-name nameLayer TR1_LY_NAME)
	
	(set! tempStr (make-string-fit description "" (- (car TR1_DESCRIPTION_DIMENSION)
		TR1_DESCRIPTION_MARGIN TR1_DESCRIPTION_MARGIN) -1 "" TR1_DESCRIPTION_FONT_SIZE
		TR1_DESCRIPTION_FONT))	
	(gimp-context-set-foreground TR1_DESCRIPTION_FONT_COLOR)
	(set! descriptionLayer (car (gimp-text-fontname image -1 0 0 tempStr -1 TRUE
		TR1_DESCRIPTION_FONT_SIZE PIXELS TR1_DESCRIPTION_FONT)))
		
	(set! alignX (/ (- (car CARD_DIMENSION) (car (gimp-drawable-width 
		descriptionLayer))) 2))	
	(set! alignY (+ (/ (- (cadr TR1_DESCRIPTION_DIMENSION) (car (gimp-drawable-height 
		descriptionLayer))) 2) (cadr TR1_DESCRIPTION_CORNER)))
	(gimp-layer-set-offsets descriptionLayer alignX alignY)
	(gimp-drawable-set-name descriptionLayer TR1_LY_DESCRIPTION)
	
	(list trainerLayer nameLayer descriptionLayer)
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MAIN FUNCTION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (script-fu-pk-trainer-1
				name description imageFile
				)
(let* ( (mainImage -1) 
			(backgroundLayers '()) ; order : background image trainerBack descriptionBack
			(textLayers '()) ; order : trainer name description
		)					
	(set! mainImage (car 
		(gimp-image-new (car CARD_DIMENSION) (cadr CARD_DIMENSION) RGB)))
	(gimp-image-undo-disable mainImage)
	
	(set! backgroundLayers (trainer1-draw-background-layers mainImage imageFile))
	(set! textLayers (trainer1-draw-text-layers mainImage name description))
	
	(gimp-image-undo-enable mainImage)
	(gimp-display-new mainImage)
	(gimp-selection-none mainImage)
	;(trainer1-save-image mainImage name)
	
	(gimp-image-clean-all mainImage)
	(list mainImage)
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;; REGISTERING ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(script-fu-register
	"script-fu-pk-trainer-1"
	"TrainerCard1"
	"Creates a Pokemon Trainer Card."
	"Esteban Guevara"
	"copyleft"
	"2008"
	""	;image type to be used in the script
	;;;;;;;;;;;;;;;;;;;;;;;; main function parameters ;;;;;;;;;;;;;;;;;;;;;;;;;;;
	SF-STRING		"Name:"					"Trainer"
	SF-TEXT			"Description:"			""
	SF-FILENAME	"Image file:"				(string-append TRAINER_DIR "")	
)

(script-fu-menu-register
	"script-fu-pk-trainer-1"
	"<Toolbox>/Xtns/Poke"
)
