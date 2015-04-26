;	Pokemon card maker script 1
;
;	Description : Creates pokemon cards.;
;	Returns the created image.
;
;	Dependence : pk-card-parameters.scm
;	Function-prefix : pk1
;
;	Date : 17 / 08 / 2008
;	Author : Guevara

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; HELPER FUNCTIONS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (get-small-type-filename
				type)
	(cond ((eqv? type PK1_OPT_FIRE)			
					(string-append ENERGY_DIR SMALL_FIRE_E) )
				((eqv? type PK1_OPT_WATER)			
					(string-append ENERGY_DIR SMALL_WATER_E) )
				((eqv? type PK1_OPT_LEAF)			
					(string-append ENERGY_DIR SMALL_LEAF_E) )
				((eqv? type PK1_OPT_ELECTRIC)			
					(string-append ENERGY_DIR SMALL_ELECTRIC_E) )
				((eqv? type PK1_OPT_PSY)			
					(string-append ENERGY_DIR SMALL_PSY_E) )
				((eqv? type PK1_OPT_PUNCH)			
					(string-append ENERGY_DIR SMALL_PUNCH_E) )
				((eqv? type PK1_OPT_WHITE)			
					(string-append ENERGY_DIR SMALL_WHITE_E) )
	)
)

(define (token-to-type-filename
				token)
	(cond ((char=? token PK1_TOKEN_FIRE)			
					(string-append ENERGY_DIR MINI_FIRE_E) )
				((char=? token PK1_TOKEN_WATER)			
					(string-append ENERGY_DIR MINI_WATER_E) )
				((char=? token PK1_TOKEN_LEAF)			
					(string-append ENERGY_DIR MINI_LEAF_E) )
				((char=? token PK1_TOKEN_ELECTRIC)			
					(string-append ENERGY_DIR MINI_ELECTRIC_E) )
				((char=? token PK1_TOKEN_PSY)			
					(string-append ENERGY_DIR MINI_PSY_E) )
				((char=? token PK1_TOKEN_PUNCH)			
					(string-append ENERGY_DIR MINI_PUNCH_E) )
				((char=? token PK1_TOKEN_WHITE)			
					(string-append ENERGY_DIR MINI_WHITE_E) )
	)
)

(define (get-type-color
				type)
	(cond ((eqv? type PK1_OPT_FIRE)			FIRE_COLOR)
				((eqv? type PK1_OPT_WATER) 		WATER_COLOR)
				((eqv? type PK1_OPT_LEAF)		LEAF_COLOR)
				((eqv? type PK1_OPT_ELECTRIC)	ELECTRIC_COLOR)
				((eqv? type PK1_OPT_PSY)			PSY_COLOR)
				((eqv? type PK1_OPT_PUNCH)	PUNCH_COLOR)
				((eqv? type PK1_OPT_WHITE)		WHITE_COLOR)
	)
)

;;;;;;;;;;;;;;;;;;;;;; DRAW BACKGROUND
(define ( pk1-draw-background
				image type)
(let* ( (layer)
		)
	(set! layer (car
		(gimp-layer-new image (car CARD_DIMENSION) (cadr CARD_DIMENSION)
			RGBA-IMAGE PK1_LY_BACKGROUND 100 NORMAL-MODE)))
	(gimp-image-add-layer image layer 0)
	(gimp-context-set-foreground BACKGROUND_COLOR)
	(gimp-drawable-fill layer FOREGROUND-FILL)
	
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
	
	(gimp-rect-select image CARD_BORDER CARD_BORDER 
		(- (car CARD_DIMENSION) CARD_BORDER CARD_BORDER)
		(- (cadr CARD_DIMENSION) CARD_BORDER CARD_BORDER)
		CHANNEL-OP-REPLACE FALSE 0)
	(python-fu-foggify  RUN-NONINTERACTIVE image layer "temp1" 
		(get-type-color type) (car PK1_FOG_PARAMETERS) (cadr PK1_FOG_PARAMETERS))
	(python-fu-foggify  RUN-NONINTERACTIVE image layer "temp2" 
		(get-type-color type) (car PK1_FOG_PARAMETERS) (cadr PK1_FOG_PARAMETERS))
	(python-fu-foggify  RUN-NONINTERACTIVE image layer "temp2" 
		(get-type-color type) (car PK1_FOG_PARAMETERS) (cadr PK1_FOG_PARAMETERS))
	(python-fu-foggify  RUN-NONINTERACTIVE image layer "temp2" 
		(get-type-color type) (car PK1_FOG_PARAMETERS) (cadr PK1_FOG_PARAMETERS))
	(python-fu-foggify  RUN-NONINTERACTIVE image layer "temp2" 
		(get-type-color type) (car PK1_FOG_PARAMETERS) (cadr PK1_FOG_PARAMETERS))
		
	(set! layer (car 
		(gimp-image-merge-visible-layers image EXPAND-AS-NECESSARY)))
	(gimp-drawable-set-name layer PK1_LY_BACKGROUND)
	
	layer
))

;;;;;;;;;;;;;;;;;;;;;;;;; DRAW BORDERS
(define ( pk1-draw-borders
				image)
(let* ( (layer)
			(corner1 (list (- (car PK1_IMAGE_CORNER) PK1_IMAGE_BORDER) 
				(- (cadr PK1_IMAGE_CORNER) PK1_IMAGE_BORDER) ))
			(corner2 (list (- (car PK1_DESCRIPTION_CORNER) PK1_DESCRIPTION_BORDER) 
				(- (cadr PK1_DESCRIPTION_CORNER) PK1_DESCRIPTION_BORDER) ))
			(dim1 (list (+ (car PK1_IMAGE_DIMENSION) PK1_IMAGE_BORDER PK1_IMAGE_BORDER)
				(+ (cadr PK1_IMAGE_DIMENSION) PK1_IMAGE_BORDER PK1_IMAGE_BORDER) ))
			(dim2 (list (+ (car PK1_DESCRIPTION_DIMENSION) PK1_DESCRIPTION_BORDER 
				PK1_DESCRIPTION_BORDER) (+ (cadr PK1_DESCRIPTION_DIMENSION) 
				PK1_DESCRIPTION_BORDER PK1_DESCRIPTION_BORDER) ))
		)
	(set! layer (car (gimp-layer-new image 
		(car CARD_DIMENSION) (cadr CARD_DIMENSION) RGBA-IMAGE PK1_LY_BORDERS
		100 NORMAL-MODE) ))
	(gimp-image-add-layer image layer 0)
	(gimp-selection-all image)
	(gimp-edit-clear layer)
	
	(gimp-rect-select image (car corner1) (cadr corner1) (car dim1) (cadr dim1)
		CHANNEL-OP-REPLACE FALSE 0)
	(gimp-rect-select image (car PK1_IMAGE_CORNER) (cadr PK1_IMAGE_CORNER) 
		(car PK1_IMAGE_DIMENSION) (cadr PK1_IMAGE_DIMENSION) CHANNEL-OP-SUBTRACT
		 FALSE 0)
	(gimp-context-set-gradient PK1_GRAD_IMAGE_BORDER)
	(gimp-edit-blend layer CUSTOM-MODE NORMAL-MODE GRADIENT-LINEAR 100
		0 REPEAT-NONE FALSE FALSE 1 0 TRUE (car corner1) (cadr corner1)
		(+ (car corner1) (car dim1)) (+ (cadr corner1) (cadr dim1)) )
		
	(gimp-rect-select image (car corner2) (cadr corner2) (car dim2) (cadr dim2)
		CHANNEL-OP-REPLACE FALSE 0)
	(gimp-rect-select image (car PK1_DESCRIPTION_CORNER) (cadr PK1_DESCRIPTION_CORNER) 
		(car PK1_DESCRIPTION_DIMENSION) (cadr PK1_DESCRIPTION_DIMENSION) 
		CHANNEL-OP-SUBTRACT FALSE 0)
	(gimp-context-set-gradient PK1_GRAD_DESCRIPTION_BORDER)
	(gimp-edit-blend layer CUSTOM-MODE NORMAL-MODE GRADIENT-LINEAR 100
		0 REPEAT-NONE FALSE FALSE 1 0 TRUE (car corner2) (cadr corner2)
		(+ (car corner2) (car dim2)) (+ (cadr corner2) (cadr dim2)) )
		
	layer
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW DESCRIPTION
(define ( pk1-draw-description
				image description)
(let* ( (layer) (formattedDescription "") (xOffset 0)
		)
	(set! formattedDescription (make-string-fit
		description "" (car PK1_DESCRIPTION_DIMENSION) 10 "Sans" 
		PK1_DESCRIPTION_FONT_SIZE PK1_DESCRIPTION_FONT) )
		
	(gimp-context-set-foreground PK1_DESCRIPTION_FONT_COLOR)
	(set! layer (car (gimp-text-fontname
		image -1 (car PK1_DESCRIPTION_CORNER) (cadr PK1_DESCRIPTION_CORNER) 
		formattedDescription -1 TRUE PK1_DESCRIPTION_FONT_SIZE PIXELS 
		PK1_DESCRIPTION_FONT)))
	(gimp-drawable-set-name layer PK1_LY_DESCRIPTION)	
	
	(set! xOffset (/ (- (car CARD_DIMENSION) (car (gimp-drawable-width layer))) 2) )
	(gimp-layer-set-offsets layer xOffset (cadr PK1_DESCRIPTION_CORNER))
	
	layer
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW IMAGE
(define ( pk1-draw-image
				image imageFile)
(let* ( (layer) 
		)		
	(set! layer (car (gimp-file-load-layer
		RUN-NONINTERACTIVE image imageFile)))	
	(gimp-image-add-layer image layer 0)
	(gimp-drawable-set-name layer PK1_LY_IMAGE)
	
	(gimp-layer-scale layer (car PK1_IMAGE_DIMENSION) (cadr PK1_IMAGE_DIMENSION) FALSE)
	(gimp-layer-set-offsets layer (car PK1_IMAGE_CORNER) (cadr PK1_IMAGE_CORNER))
	
	layer
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW BACK LAYERS
(define ( pk1-draw-back-layers
				image type pkDescription imageFile
				)
(let* ( (backgroundLayer -1) (descriptionLayer -1)
			(borderLayer -1) (imageLayer -1)
		)
	(set! backgroundLayer (pk1-draw-background image type))
	(set! borderLayer (pk1-draw-borders image))
	(set! descriptionLayer (pk1-draw-description image pkDescription))
	(set! imageLayer (pk1-draw-image image imageFile))
	
	(list backgroundLayer borderLayer imageLayer descriptionLayer)
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW HEADER
(define ( pk1-draw-header
				image name evolution hp type)
(let* ( (nameLayer -1) (evolutionLayer -1)
			(hpLayer -1) (typeLayer -1)
			(hpXStart 0)
		)
	(set! typeLayer (car (gimp-file-load-layer
		RUN-NONINTERACTIVE image (get-small-type-filename type)) ))
	(gimp-image-add-layer image typeLayer 0)
	(gimp-layer-set-offsets typeLayer (car PK1_TYPE_CORNER) (cadr PK1_TYPE_CORNER))
	(gimp-drawable-set-name typeLayer PK1_LY_TYPE)
	
	(gimp-context-set-foreground PK1_NAME_FONT_COLOR)
	(set! nameLayer (car (gimp-text-fontname
		image -1 (car PK1_NAME_CORNER) (cadr PK1_NAME_CORNER) name -1 TRUE 
		PK1_NAME_FONT_SIZE PIXELS PK1_NAME_FONT)))
	(gimp-drawable-set-name nameLayer PK1_LY_NAME)
	
	(gimp-context-set-foreground PK1_EVOLUTION_FONT_COLOR)
	(set! evolutionLayer (car (gimp-text-fontname
		image -1 (car PK1_EVOLUTION_CORNER) (cadr PK1_EVOLUTION_CORNER) evolution -1 TRUE 
		PK1_EVOLUTION_FONT_SIZE PIXELS PK1_EVOLUTION_FONT)))
	(gimp-drawable-set-name evolutionLayer PK1_LY_EVOLUTION)
	
	(gimp-context-set-foreground PK1_HP_FONT_COLOR)
	(set! hpLayer (car (gimp-text-fontname image -1 0 0 (string-append hp "HP ") 
		-1 TRUE PK1_HP_FONT_SIZE PIXELS PK1_HP_FONT)))
	(set! hpXStart (- (car PK1_TYPE_CORNER) (car (gimp-drawable-width hpLayer)) ) )
	(gimp-layer-set-offsets hpLayer hpXStart (cadr PK1_TYPE_CORNER))
	(gimp-drawable-set-name hpLayer PK1_LY_HP)
	
	(list nameLayer evolutionLayer hpLayer typeLayer)
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW FOOTER
(define ( pk1-draw-footer
				image weakness resistance retreatCost)
(let* ( (weaknessLayer) (resistanceLayer) (retreatLayer)
			(weaknessELayer -1) (resistanceELayer -1) (retreatELayer -1)
			(width 0)
		 )
	(gimp-context-set-foreground PK1_WEAKNESS_FONT_COLOR)
	(set! weaknessLayer (car (gimp-text-fontname
		image -1 (car PK1_WEAKNESS_CORNER) (cadr PK1_WEAKNESS_CORNER)
		"weakness" -1 TRUE PK1_WEAKNESS_FONT_SIZE PIXELS PK1_WEAKNESS_FONT)))
	(gimp-drawable-set-name weaknessLayer PK1_LY_WEAKNESS)
	
	(gimp-context-set-foreground PK1_RESISTANCE_FONT_COLOR)
	(set! resistanceLayer (car (gimp-text-fontname
		image -1 (car PK1_RESISTANCE_CORNER) (cadr PK1_RESISTANCE_CORNER)
		"resistance" -1 TRUE PK1_RESISTANCE_FONT_SIZE PIXELS PK1_RESISTANCE_FONT)))
	(gimp-drawable-set-name resistanceLayer PK1_LY_RESISTANCE)
	
	(gimp-context-set-foreground PK1_RETREAT_FONT_COLOR)
	(set! retreatLayer (car (gimp-text-fontname
		image -1 (car PK1_RETREAT_CORNER) (cadr PK1_RETREAT_CORNER)
		"retreat cost" -1 TRUE PK1_RETREAT_FONT_SIZE PIXELS PK1_RETREAT_FONT)))
	(gimp-drawable-set-name retreatLayer PK1_LY_RETREAT)
	
	(if (not (= PK1_OPT_NONE weakness))
		(begin 
			(set! weaknessELayer (car (gimp-file-load-layer
				RUN-NONINTERACTIVE image (get-small-type-filename weakness)) ))
			(gimp-image-add-layer image weaknessELayer 0)
			(gimp-layer-set-offsets weaknessELayer (car PK1_WEAKNESS_ECORNER)
				(cadr PK1_WEAKNESS_ECORNER))
			(gimp-drawable-set-name weaknessELayer PK1_LY_WEAKNESS_E)
		)
	)
	
	(if (not (= PK1_OPT_NONE resistance))
		(begin 
			(set! resistanceELayer (car (gimp-file-load-layer
				RUN-NONINTERACTIVE image (get-small-type-filename resistance)) ))
			(gimp-image-add-layer image resistanceELayer 0)
			(gimp-layer-set-offsets resistanceELayer (car PK1_RESISTANCE_ECORNER)
				(cadr PK1_RESISTANCE_ECORNER))
			(gimp-drawable-set-name resistanceELayer PK1_LY_RESISTANCE_E)
		)
	)
	
	(cond 
		((= retreatCost 1)
			(begin
				(set! retreatELayer (car (gimp-file-load-layer
					RUN-NONINTERACTIVE image (get-small-type-filename PK1_OPT_WHITE)) ))
				(gimp-image-add-layer image retreatELayer 0)
				(gimp-layer-set-offsets retreatELayer (car PK1_RETREAT_ECORNER_1)
					(cadr PK1_RETREAT_ECORNER_1))
				(gimp-drawable-set-name retreatELayer PK1_LY_RETREAT_E)
			)
		) 
		((= retreatCost 2)
			(begin
				(set! retreatELayer (car (gimp-file-load-layer
					RUN-NONINTERACTIVE image (get-small-type-filename PK1_OPT_WHITE)) ))
				(gimp-image-add-layer image retreatELayer 0)
				(gimp-layer-set-offsets retreatELayer (car PK1_RETREAT_ECORNER_2)
					(cadr PK1_RETREAT_ECORNER_2))
				(set! width (+ (car (gimp-drawable-width retreatELayer)) 2))
					
				(set! retreatELayer (car (gimp-file-load-layer
					RUN-NONINTERACTIVE image (get-small-type-filename PK1_OPT_WHITE)) ))
				(gimp-image-add-layer image retreatELayer 0)
				(gimp-layer-set-offsets retreatELayer 
					(+ (car PK1_RETREAT_ECORNER_2) width) (cadr PK1_RETREAT_ECORNER_2))
					
				(set! retreatELayer (car (gimp-image-merge-down 
					image retreatELayer EXPAND-AS-NECESSARY)))
				(gimp-drawable-set-name retreatELayer PK1_LY_RETREAT_E)
			)
		)
		((= retreatCost 3)
			(begin
				(set! retreatELayer (car (gimp-file-load-layer
					RUN-NONINTERACTIVE image (get-small-type-filename PK1_OPT_WHITE)) ))
				(gimp-image-add-layer image retreatELayer 0)
				(gimp-layer-set-offsets retreatELayer (car PK1_RETREAT_ECORNER_3)
					(cadr PK1_RETREAT_ECORNER_3))
				(set! width (+ (car (gimp-drawable-width retreatELayer)) 2))
					
				(set! retreatELayer (car (gimp-file-load-layer
					RUN-NONINTERACTIVE image (get-small-type-filename PK1_OPT_WHITE)) ))
				(gimp-image-add-layer image retreatELayer 0)
				(gimp-layer-set-offsets retreatELayer 
					(+ (car PK1_RETREAT_ECORNER_3) width) (cadr PK1_RETREAT_ECORNER_3))
					
				(set! retreatELayer (car (gimp-file-load-layer
					RUN-NONINTERACTIVE image (get-small-type-filename PK1_OPT_WHITE)) ))
				(gimp-image-add-layer image retreatELayer 0)
				(gimp-layer-set-offsets retreatELayer 
					(+ (car PK1_RETREAT_ECORNER_3) width width) (cadr PK1_RETREAT_ECORNER_3))
					
				(set! retreatELayer (car (gimp-image-merge-down 
					image retreatELayer EXPAND-AS-NECESSARY)))
				(set! retreatELayer (car (gimp-image-merge-down 
					image retreatELayer EXPAND-AS-NECESSARY)))
				(gimp-drawable-set-name retreatELayer PK1_LY_RETREAT_E)
			)
		)
		((= retreatCost 4)
			(begin
				(set! retreatELayer (car (gimp-file-load-layer
					RUN-NONINTERACTIVE image (get-small-type-filename PK1_OPT_WHITE)) ))
				(gimp-image-add-layer image retreatELayer 0)
				(gimp-layer-set-offsets retreatELayer (car PK1_RETREAT_ECORNER_4)
					(cadr PK1_RETREAT_ECORNER_4))
				(set! width (+ (car (gimp-drawable-width retreatELayer)) 2))
					
				(set! retreatELayer (car (gimp-file-load-layer
					RUN-NONINTERACTIVE image (get-small-type-filename PK1_OPT_WHITE)) ))
				(gimp-image-add-layer image retreatELayer 0)
				(gimp-layer-set-offsets retreatELayer 
					(+ (car PK1_RETREAT_ECORNER_4) width) (cadr PK1_RETREAT_ECORNER_4) )
					
				(set! retreatELayer (car (gimp-file-load-layer
					RUN-NONINTERACTIVE image (get-small-type-filename PK1_OPT_WHITE)) ))
				(gimp-image-add-layer image retreatELayer 0)
				(gimp-layer-set-offsets retreatELayer 
					(+ (car PK1_RETREAT_ECORNER_4) width width) (cadr PK1_RETREAT_ECORNER_4) )
					
				(set! retreatELayer (car (gimp-file-load-layer
					RUN-NONINTERACTIVE image (get-small-type-filename PK1_OPT_WHITE)) ))
				(gimp-image-add-layer image retreatELayer 0)
				(gimp-layer-set-offsets retreatELayer 
					(+ (car PK1_RETREAT_ECORNER_4) width width width) 
					(cadr PK1_RETREAT_ECORNER_4))
					
				(set! retreatELayer (car (gimp-image-merge-down 
					image retreatELayer EXPAND-AS-NECESSARY)))
				(set! retreatELayer (car (gimp-image-merge-down 
					image retreatELayer EXPAND-AS-NECESSARY)))
				(set! retreatELayer (car (gimp-image-merge-down 
					image retreatELayer EXPAND-AS-NECESSARY)))
				(gimp-drawable-set-name retreatELayer PK1_LY_RETREAT_E)
			)
		)
	)
	(list weaknessLayer resistanceLayer retreatLayer 
		weaknessELayer resistanceELayer retreatELayer)
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW ENERGY COST
(define ( pk1-draw-energy-cost
				image layerName
				whECost colECost colEType )
(let* ( (eLayer -1) (tempLayers '())
			(totalE 0) (j 0) (corners '())
			(layer -1) (corner '()) (eType "")
		)
	(set! totalE (+ colECost whECost) )
	(set! eType (get-small-type-filename colEType))
	(cond
		((= totalE 1)
			(set! corners '((0 0)) )	)
		((= totalE 2)
			(set! corners '((0 0) (32 0)) ))
		((= totalE 3)
			(set! corners '((0 0) (32 0) (16 32)) ))
		((= totalE 4)
			(set! corners '((0 0) (32 0) (0 32) (32 32)) ))
	)
	
	(do ( (i 0 (begin (set! j (+ j 1)) (+ i 1))) )
		((>= i colECost) )
		(set! tempLayers (append tempLayers (gimp-file-load-layer
			RUN-NONINTERACTIVE image eType) ))
		(set! layer (list-ref tempLayers j))
		(gimp-image-add-layer image layer 0)
		(set! corner (list-ref corners j))
		(gimp-layer-set-offsets layer (car corner) (cadr corner))
	)
	(do ( (i 0 (begin (set! j (+ j 1)) (+ i 1))) )
		((>= i whECost) )
		(set! tempLayers (append tempLayers (gimp-file-load-layer
			RUN-NONINTERACTIVE image (get-small-type-filename PK1_OPT_WHITE)) ))
		(set! layer (list-ref tempLayers j))
		(gimp-image-add-layer image layer 0)
		(set! corner (list-ref corners j))
		(gimp-layer-set-offsets layer (car corner) (cadr corner))
	)
	
	(do ( (i 0 (+ i 1)) )
		((>= i (- (length tempLayers) 1)) )
		(gimp-image-merge-down image (get-layer-by-index image 0) 
			EXPAND-AS-NECESSARY)
	)	
	(set! eLayer (get-layer-by-index image 0))
	(if (= totalE 1)
		(gimp-layer-set-offsets eLayer 
			(+ (/ (car (gimp-drawable-width eLayer)) 2) PK1_E_COST_START) 0 )
		(gimp-layer-set-offsets eLayer PK1_E_COST_START 0)
	)
	(gimp-drawable-set-name eLayer layerName)
	
	eLayer
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW ACTION TEXT
(define ( pk1-draw-action-text
				image actionNumber
				isPower name description damage )
(let* ( (nameLayer -1) (descriptionLayer -1) (damageLayer -1)
			(alignX 0) (alignY 0) (descriptionText "") 
		)
	(cond ((= isPower PK1_OPT_PK_POWER)
		(set! descriptionText (make-string-fit description name 
			(- PK1_PW_END PK1_PW_START) PK1_PW_NAME_FONT_SIZE PK1_PW_NAME_FONT
			PK1_PW_DESCRIPTION_FONT_SIZE PK1_PW_DESCRIPTION_FONT) )
		(gimp-context-set-foreground PK1_PW_NAME_FONT_COLOR)
		
		(set! nameLayer (car (gimp-text-fontname image -1 PK1_PW_START
			0 name -1 TRUE PK1_PW_NAME_FONT_SIZE PIXELS PK1_PW_NAME_FONT)) )
		(gimp-context-set-foreground PK1_PW_DESCRIPTION_FONT_COLOR)
		(set! descriptionLayer (car (gimp-text-fontname image -1 PK1_PW_START
			PK1_PW_DESCRIPTION_Y_OFFSET descriptionText -1 TRUE 
			PK1_PW_DESCRIPTION_FONT_SIZE PIXELS PK1_PW_DESCRIPTION_FONT)) )
			
		(gimp-drawable-set-name nameLayer PK1_LY_PK_PW_NAME)
		(gimp-drawable-set-name descriptionLayer PK1_LY_PK_PW_DESCRIPTION)
		)
	((string=? description "") ; HAS TO HAVE DAMAGE
		(gimp-context-set-foreground PK1_AT_NAME_FONT_COLOR)
		(set! nameLayer (car (gimp-text-fontname image -1 0
			0 name -1 TRUE PK1_AT_NAME_FONT_SIZE PIXELS PK1_AT_NAME_FONT)) )
		(set! alignX (+ (/ (- PK1_ATTACK_END PK1_ATTACK_START (car (
			gimp-drawable-width nameLayer))) 2) PK1_ATTACK_START) )
		(gimp-layer-set-offsets nameLayer alignX 0)
		
		(gimp-context-set-foreground PK1_DAMAGE_FONT_COLOR)
		(set! damageLayer (car (gimp-text-fontname image -1 PK1_DAMAGE_START
			0 damage -1 TRUE PK1_DAMAGE_FONT_SIZE PIXELS PK1_DAMAGE_FONT)) )
		(set! alignY (/ (- (car (gimp-drawable-height nameLayer))
			(car (gimp-drawable-height damageLayer))) 2) )
		(gimp-layer-set-offsets damageLayer PK1_DAMAGE_START alignY)
		
		(if (= actionNumber 1)
			(begin
				(gimp-drawable-set-name nameLayer PK1_LY_AT1_NAME)
				(gimp-drawable-set-name damageLayer PK1_LY_AT1_DAMAGE)
			)
			(begin
				(gimp-drawable-set-name nameLayer PK1_LY_AT2_NAME)
				(gimp-drawable-set-name damageLayer PK1_LY_AT2_DAMAGE)
		))	
		)
	(else
		(set! descriptionText (make-string-fit description name 
			(- PK1_ATTACK_END PK1_ATTACK_START) PK1_AT_NAME_FONT_SIZE
			PK1_AT_NAME_FONT PK1_AT_DESCRIPTION_FONT_SIZE 
			PK1_AT_DESCRIPTION_FONT) )
		(gimp-context-set-foreground PK1_AT_NAME_FONT_COLOR)
		
		(set! nameLayer (car (gimp-text-fontname image -1 PK1_ATTACK_START
			0 name -1 TRUE PK1_AT_NAME_FONT_SIZE PIXELS PK1_AT_NAME_FONT)) )
		(gimp-context-set-foreground PK1_AT_DESCRIPTION_FONT_COLOR)
		(set! descriptionLayer (car (gimp-text-fontname image -1 PK1_ATTACK_START
			PK1_AT_DESCRIPTION_Y_OFFSET descriptionText -1 TRUE 
			PK1_AT_DESCRIPTION_FONT_SIZE PIXELS PK1_AT_DESCRIPTION_FONT)) )
			
		(cond ( (not (string=? damage ""))
			(gimp-context-set-foreground PK1_DAMAGE_FONT_COLOR)
			(set! damageLayer (car (gimp-text-fontname image -1 PK1_DAMAGE_START
				0 damage -1 TRUE PK1_DAMAGE_FONT_SIZE PIXELS PK1_DAMAGE_FONT)) )
			(set! alignY (/ (- (car (gimp-drawable-height descriptionLayer))
				(car (gimp-drawable-height damageLayer))) 2) )
			(gimp-layer-set-offsets damageLayer PK1_DAMAGE_START alignY)
		))
		
		(cond ( (= actionNumber 1)
			(gimp-drawable-set-name nameLayer PK1_LY_AT1_NAME)
			(gimp-drawable-set-name descriptionLayer PK1_LY_AT1_DESCRIPTION)
			(if (not (string=? damage ""))
			(gimp-drawable-set-name damageLayer PK1_LY_AT1_DAMAGE))
			)
		(else
			(gimp-drawable-set-name nameLayer PK1_LY_AT2_NAME)
			(gimp-drawable-set-name descriptionLayer PK1_LY_AT2_DESCRIPTION)
			(if (not (string=? damage ""))
			(gimp-drawable-set-name damageLayer PK1_LY_AT2_DAMAGE))
		))	
		)
	)
	(list nameLayer descriptionLayer damageLayer)
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ARRANGE ATTACK LAYERS
(define ( pk1-arrange-attack-layers
				image actionNumber
				eLayer1 nameLayer1 descriptionLayer1 damageLayer1
				eLayer2 nameLayer2 descriptionLayer2 damageLayer2
				)
(let* ( (startYAttack 0) (alignY 0) (temp 0)
			(separatorY -1)
		)
	(set! startYAttack (+ (cadr PK1_IMAGE_CORNER) PK1_IMAGE_BORDER
		(cadr PK1_IMAGE_DIMENSION)) )
	
	(cond ( (and (= actionNumber 1) (not (eqv? descriptionLayer1 -1)) )
		(set! alignY (+ (/ (- (cadr PK1_SEPARATOR_CORNER) startYAttack 
			(car (gimp-drawable-height descriptionLayer1))) 2) startYAttack) )
		(if (not (eqv? eLayer1 -1))
			(gimp-layer-set-offsets eLayer1 (car (gimp-drawable-offsets eLayer1))
				(+ alignY PK1_AT_DESCRIPTION_Y_OFFSET
				(/ (- (car (gimp-drawable-height descriptionLayer1))
				(car (gimp-drawable-height eLayer1))) 2) ))
		)
		(gimp-layer-set-offsets nameLayer1 (car (gimp-drawable-offsets
			nameLayer1)) alignY)
		(gimp-layer-set-offsets descriptionLayer1 (car (gimp-drawable-offsets
			descriptionLayer1)) (+ alignY (cadr (gimp-drawable-offsets
			descriptionLayer1))) )
		(if (not (eqv? damageLayer1 -1))
			(gimp-layer-set-offsets damageLayer1 (car (gimp-drawable-offsets
				damageLayer1)) (+ alignY PK1_AT_DESCRIPTION_Y_OFFSET
				(/ (- (car (gimp-drawable-height descriptionLayer1))
				(car (gimp-drawable-height damageLayer1))) 2) ))
		)
	)
		
	( (= actionNumber 1)
		(set! alignY (+ (/ (- (cadr PK1_SEPARATOR_CORNER) startYAttack 
			(car (gimp-drawable-height nameLayer1))) 2) startYAttack) )
		(if (not (eqv? eLayer1 -1))
			(gimp-layer-set-offsets eLayer1 (car (gimp-drawable-offsets eLayer1))
				(+ alignY (/ (- (car (gimp-drawable-height nameLayer1))
				(car (gimp-drawable-height eLayer1))) 2) ))
		)
		(gimp-layer-set-offsets nameLayer1 (car (gimp-drawable-offsets
			nameLayer1)) alignY)
		(if (not (eqv? damageLayer1 -1))
			(gimp-layer-set-offsets damageLayer1 (car (gimp-drawable-offsets
				damageLayer1)) (+ alignY (/ (- (car (gimp-drawable-height 
				nameLayer1)) (car (gimp-drawable-height damageLayer1))) 2) ))
		)
	)
		
	( (and (not (eqv? descriptionLayer2 -1)) (not (eqv? descriptionLayer1 -1)) )
		(set! temp (+ (car (gimp-drawable-height descriptionLayer1)) 
			(car (gimp-drawable-height descriptionLayer2)) ) )
		(set! alignY (+ (/ (- (cadr PK1_SEPARATOR_CORNER) startYAttack temp) 
			4) startYAttack) )
		(if (not (eqv? eLayer1 -1))
			(gimp-layer-set-offsets eLayer1 (car (gimp-drawable-offsets eLayer1))
				(+ alignY PK1_AT_DESCRIPTION_Y_OFFSET
				(/ (- (car (gimp-drawable-height descriptionLayer1))
				(car (gimp-drawable-height eLayer1))) 2) ))
		)
		(gimp-layer-set-offsets nameLayer1 (car (gimp-drawable-offsets
			nameLayer1)) alignY)
		(gimp-layer-set-offsets descriptionLayer1 (car (gimp-drawable-offsets
			descriptionLayer1)) (+ alignY (cadr (gimp-drawable-offsets
			descriptionLayer1))))
		(if (not (eqv? damageLayer1 -1))
			(gimp-layer-set-offsets damageLayer1 (car (gimp-drawable-offsets
				damageLayer1)) (+ alignY PK1_AT_DESCRIPTION_Y_OFFSET
				(/ (- (car (gimp-drawable-height descriptionLayer1))
				(car (gimp-drawable-height damageLayer1))) 2) ))
		)
		
		(set! alignY (- alignY startYAttack))
		(set! separatorY (+ startYAttack (* alignY 2) 
			(car (gimp-drawable-height descriptionLayer1))) )
		(set! alignY (+ startYAttack (* alignY 3) 
			(car (gimp-drawable-height descriptionLayer1))) )
		(if (not (eqv? eLayer2 -1))
			(gimp-layer-set-offsets eLayer2 (car (gimp-drawable-offsets eLayer2))
				(+ alignY PK1_AT_DESCRIPTION_Y_OFFSET
				(/ (- (car (gimp-drawable-height descriptionLayer2))
				(car (gimp-drawable-height eLayer2))) 2) ))
		)
		(gimp-layer-set-offsets nameLayer2 (car (gimp-drawable-offsets
			nameLayer2)) alignY)
		(gimp-layer-set-offsets descriptionLayer2 (car (gimp-drawable-offsets
			descriptionLayer2)) (+ alignY (cadr (gimp-drawable-offsets
			descriptionLayer2))))
		(if (not (eqv? damageLayer2 -1))
			(gimp-layer-set-offsets damageLayer2 (car (gimp-drawable-offsets
				damageLayer2)) (+ alignY PK1_AT_DESCRIPTION_Y_OFFSET
				(/ (- (car (gimp-drawable-height descriptionLayer2))
				(car (gimp-drawable-height damageLayer2))) 2) ))
		)
	)
	
	( (and (eqv? descriptionLayer1 -1) (not (eqv? descriptionLayer2 -1)) )
		(set! temp (+ (car (gimp-drawable-height nameLayer1)) 
			(car (gimp-drawable-height descriptionLayer2)) ) )
		(set! alignY (+ (/ (- (cadr PK1_SEPARATOR_CORNER) startYAttack temp) 
			4) startYAttack) )
		(if (not (eqv? eLayer1 -1))
			(gimp-layer-set-offsets eLayer1 (car (gimp-drawable-offsets eLayer1))
				(+ alignY (/ (- (car (gimp-drawable-height nameLayer1))
				(car (gimp-drawable-height eLayer1))) 2) ))
		)
		(gimp-layer-set-offsets nameLayer1 (car (gimp-drawable-offsets
			nameLayer1)) alignY)
		(if (not (eqv? damageLayer1 -1))
			(gimp-layer-set-offsets damageLayer1 (car (gimp-drawable-offsets
				damageLayer1)) (+ alignY (/ (- (car (gimp-drawable-height 
				nameLayer1)) (car (gimp-drawable-height damageLayer1))) 2) ))
		)
		
		(set! alignY (- alignY startYAttack))
		(set! separatorY (+ startYAttack (* alignY 2) 
			(car (gimp-drawable-height nameLayer1))) )
		(set! alignY (+ startYAttack (* alignY 3) 
			(car (gimp-drawable-height nameLayer1))) )
		(if (not (eqv? eLayer2 -1))
			(gimp-layer-set-offsets eLayer2 (car (gimp-drawable-offsets eLayer2))
				(+ alignY PK1_AT_DESCRIPTION_Y_OFFSET
				(/ (- (car (gimp-drawable-height descriptionLayer2))
				(car (gimp-drawable-height eLayer2))) 2) ))
		)
		(gimp-layer-set-offsets nameLayer2 (car (gimp-drawable-offsets
			nameLayer2)) alignY)
		(gimp-layer-set-offsets descriptionLayer2 (car (gimp-drawable-offsets
			descriptionLayer2)) (+ alignY (cadr (gimp-drawable-offsets
			descriptionLayer2))))
		(if (not (eqv? damageLayer2 -1))
			(gimp-layer-set-offsets damageLayer2 (car (gimp-drawable-offsets
				damageLayer2)) (+ alignY PK1_AT_DESCRIPTION_Y_OFFSET
				(/ (- (car (gimp-drawable-height descriptionLayer2))
				(car (gimp-drawable-height damageLayer2))) 2) ))
		)
	)
	
	( (and (not (eqv? descriptionLayer1 -1)) (eqv? descriptionLayer2 -1) )
		(set! temp (+ (car (gimp-drawable-height descriptionLayer1)) 
			(car (gimp-drawable-height nameLayer2)) ) )
		(set! alignY (+ (/ (- (cadr PK1_SEPARATOR_CORNER) startYAttack temp) 
			4) startYAttack) )
		(if (not (eqv? eLayer1 -1))
			(gimp-layer-set-offsets eLayer1 (car (gimp-drawable-offsets eLayer1))
				(+ alignY PK1_AT_DESCRIPTION_Y_OFFSET
				(/ (- (car (gimp-drawable-height descriptionLayer1))
				(car (gimp-drawable-height eLayer1))) 2) ))
		)
		(gimp-layer-set-offsets nameLayer1 (car (gimp-drawable-offsets
			nameLayer1)) alignY)
		(gimp-layer-set-offsets descriptionLayer1 (car (gimp-drawable-offsets
			descriptionLayer1)) (+ alignY (cadr (gimp-drawable-offsets
			descriptionLayer1))))
		(if (not (eqv? damageLayer1 -1))
			(gimp-layer-set-offsets damageLayer1 (car (gimp-drawable-offsets
				damageLayer1)) (+ alignY PK1_AT_DESCRIPTION_Y_OFFSET
				(/ (- (car (gimp-drawable-height descriptionLayer1))
				(car (gimp-drawable-height damageLayer1))) 2) ))
		)
		
		(set! alignY (- alignY startYAttack))
		(set! separatorY (+ startYAttack (* alignY 2) 
			(car (gimp-drawable-height descriptionLayer1))) )
		(set! alignY (+ startYAttack (* alignY 3) 
			(car (gimp-drawable-height descriptionLayer1))) )
		(if (not (eqv? eLayer2 -1))
			(gimp-layer-set-offsets eLayer2 (car (gimp-drawable-offsets eLayer2))
				(+ alignY (/ (- (car (gimp-drawable-height nameLayer2))
				(car (gimp-drawable-height eLayer2))) 2) ))
		)
		(gimp-layer-set-offsets nameLayer2 (car (gimp-drawable-offsets
			nameLayer2)) alignY)
		(if (not (eqv? damageLayer2 -1))
			(gimp-layer-set-offsets damageLayer2 (car (gimp-drawable-offsets
				damageLayer2)) (+ alignY (/ (- (car (gimp-drawable-height 
				nameLayer2)) (car (gimp-drawable-height damageLayer2))) 2) ))
		)
	)
	( (and (eqv? descriptionLayer1 -1) (eqv? descriptionLayer2 -1) )
		(set! temp (+ (car (gimp-drawable-height nameLayer1)) 
			(car (gimp-drawable-height nameLayer2)) ) )
		(set! alignY (+ (/ (- (cadr PK1_SEPARATOR_CORNER) startYAttack temp) 
			4) startYAttack) )
		(if (not (eqv? eLayer1 -1))
			(gimp-layer-set-offsets eLayer1 (car (gimp-drawable-offsets eLayer1))
				(+ alignY (/ (- (car (gimp-drawable-height nameLayer1))
				(car (gimp-drawable-height eLayer1))) 2) ))
		)
		(gimp-layer-set-offsets nameLayer1 (car (gimp-drawable-offsets
			nameLayer1)) alignY)
		(if (not (eqv? damageLayer1 -1))
			(gimp-layer-set-offsets damageLayer1 (car (gimp-drawable-offsets
				damageLayer1)) (+ alignY (/ (- (car (gimp-drawable-height 
				nameLayer1)) (car (gimp-drawable-height damageLayer1))) 2) ))
		)
		
		(set! alignY (- alignY startYAttack))
		(set! separatorY (+ startYAttack (* alignY 2) 
			(car (gimp-drawable-height nameLayer1))) )
		(set! alignY (+ startYAttack (* alignY 3) 
			(car (gimp-drawable-height nameLayer1))) )
		(if (not (eqv? eLayer2 -1))
			(gimp-layer-set-offsets eLayer2 (car (gimp-drawable-offsets eLayer2))
				(+ alignY (/ (- (car (gimp-drawable-height nameLayer2))
				(car (gimp-drawable-height eLayer2))) 2) ))
		)
		(gimp-layer-set-offsets nameLayer2 (car (gimp-drawable-offsets
			nameLayer2)) alignY)
		(if (not (eqv? damageLayer2 -1))
			(gimp-layer-set-offsets damageLayer2 (car (gimp-drawable-offsets
				damageLayer2)) (+ alignY (/ (- (car (gimp-drawable-height 
				nameLayer2)) (car (gimp-drawable-height damageLayer2))) 2) ))
		)
	))
	separatorY
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW SEPARATORS
(define ( pk1-draw-separators
				image startCorner1 startCorner2 )
(let* ( (separatorLayer -1)
		)
	(set! separatorLayer (car (gimp-layer-new
		image (car CARD_DIMENSION) (cadr CARD_DIMENSION) RGBA-IMAGE
		PK1_LY_SEPARATOR 100 NORMAL-MODE)))
	(gimp-image-add-layer image separatorLayer 0)
	(gimp-selection-all image)
	(gimp-edit-clear separatorLayer)	
	(gimp-context-set-foreground PK1_SEPARATOR_COLOR)
	
	(cond ( (not (null? startCorner1))
		(gimp-rect-select image (car startCorner1) (cadr startCorner1)
			(car PK1_SEPARATOR_DIMENSION) (cadr PK1_SEPARATOR_DIMENSION)
			CHANNEL-OP-REPLACE FALSE 0)
		(gimp-edit-bucket-fill separatorLayer FG-BUCKET-FILL NORMAL-MODE 100
			0 FALSE 0 0)
	))
	(gimp-rect-select image (car startCorner2) (cadr startCorner2)
		(car PK1_SEPARATOR_DIMENSION) (cadr PK1_SEPARATOR_DIMENSION)
		CHANNEL-OP-REPLACE FALSE 0)
	(gimp-edit-bucket-fill separatorLayer FG-BUCKET-FILL NORMAL-MODE 100
		0 FALSE 0 0)
		
	separatorLayer
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW ACTION SECTION
(define ( pk1-draw-action-section
				 image
				 firstAction fstAcWhECost fstAcColECost fstAcColEType 
					fstAcName fstActDescription fstAcDamage
				secondAction scdAcWhECost scdAcColECost scdAcColEType 
					scdAcName scdActDescription scdAcDamage
			)
(let* ( (eLayer1 -1) (nameLayer1 -1) 
			(descriptionLayer1 -1) (damageLayer1 -1) 
			(eLayer2 -1) (nameLayer2 -1) 
			(descriptionLayer2 -1) (damageLayer2 -1) 
			(separatorLayer -1) 
			(temp '()) (y 0)
		)	
	(cond ( (and (= firstAction PK1_OPT_PK_POWER) (= secondAction PK1_OPT_NOTHING))
		(set! temp (pk1-draw-action-text image 1 PK1_OPT_PK_POWER fstAcName
			(pk1-markup-replace fstActDescription #f) ""))
		(set! nameLayer1 (car temp))
		(set! descriptionLayer1 (cadr temp))
		(pk1-arrange-attack-layers image 1 -1 nameLayer1 descriptionLayer1
			-1 -1 -1 -1 -1)
		(set! separatorLayer (pk1-draw-separators image '() PK1_SEPARATOR_CORNER))
	)
	( (and (= firstAction PK1_OPT_PK_POWER) (= secondAction PK1_OPT_ATTACK))
		(set! temp (pk1-draw-action-text image 1 PK1_OPT_PK_POWER fstAcName
			(pk1-markup-replace fstActDescription #f) ""))
		(set! nameLayer1 (car temp))
		(set! descriptionLayer1 (cadr temp))
		(set! temp (pk1-draw-action-text image 2 PK1_OPT_ATTACK scdAcName
			(pk1-markup-replace scdActDescription #f) scdAcDamage))
		(set! nameLayer2 (car temp))
		(set! descriptionLayer2 (cadr temp))
		(set! damageLayer2 (caddr temp))
		(set! eLayer2 (pk1-draw-energy-cost image PK1_LY_AT2_E
			scdAcWhECost scdAcColECost scdAcColEType))
		(set! y (pk1-arrange-attack-layers image 2 -1 nameLayer1 descriptionLayer1 -1
			eLayer2 nameLayer2 descriptionLayer2 damageLayer2))
		(set! separatorLayer (pk1-draw-separators image 
			(list (car PK1_SEPARATOR_CORNER) y) PK1_SEPARATOR_CORNER))
	)
	( (and (= firstAction PK1_OPT_ATTACK) (= secondAction PK1_OPT_NOTHING))
		(set! temp (pk1-draw-action-text image 1 PK1_OPT_ATTACK fstAcName
			(pk1-markup-replace fstActDescription #f) fstAcDamage))
		(set! nameLayer1 (car temp))
		(set! descriptionLayer1 (cadr temp))
		(set! damageLayer1 (caddr temp))
		(set! eLayer1 (pk1-draw-energy-cost image PK1_LY_AT1_E
			fstAcWhECost fstAcColECost fstAcColEType))
		(pk1-arrange-attack-layers image 1 eLayer1 nameLayer1 descriptionLayer1 
			damageLayer1 -1 -1 -1 -1)
		(set! separatorLayer (pk1-draw-separators image '() PK1_SEPARATOR_CORNER))
	)
	( (and (= firstAction PK1_OPT_ATTACK) (= secondAction PK1_OPT_ATTACK))
		(set! temp (pk1-draw-action-text image 1 PK1_OPT_ATTACK fstAcName
			(pk1-markup-replace fstActDescription #f) fstAcDamage))
		(set! nameLayer1 (car temp))
		(set! descriptionLayer1 (cadr temp))
		(set! damageLayer1 (caddr temp))
		(set! eLayer1 (pk1-draw-energy-cost image PK1_LY_AT1_E
			fstAcWhECost fstAcColECost fstAcColEType))
		(set! temp (pk1-draw-action-text image 2 PK1_OPT_ATTACK scdAcName
			(pk1-markup-replace scdActDescription #f) scdAcDamage))
		(set! nameLayer2 (car temp))
		(set! descriptionLayer2 (cadr temp))
		(set! damageLayer2 (caddr temp))
		(set! eLayer2 (pk1-draw-energy-cost image PK1_LY_AT2_E
			scdAcWhECost scdAcColECost scdAcColEType))
		(set! y (pk1-arrange-attack-layers image 2 eLayer1 nameLayer1 descriptionLayer1
			damageLayer1 eLayer2 nameLayer2 descriptionLayer2 damageLayer2))
		(set! separatorLayer (pk1-draw-separators image 
			(list (car PK1_SEPARATOR_CORNER) y) PK1_SEPARATOR_CORNER))
	))
	
	(list eLayer1 nameLayer1 descriptionLayer1 damageLayer1
		eLayer2 nameLayer2 descriptionLayer2 damageLayer2
		separatorLayer)
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DRAW MINI ENERGIES
(define ( pk1-draw-mini-energies
				image textLayer1 textLayer2
				name1 name2 text1 text2
				action1 action2 )
(let* ( (indexList '())
			(layer -1) (layerNumber 0)
			(indentedText1 (pk1-markup-replace text1 #f)) 
			(indentedText2 (pk1-markup-replace text2 #f))
		)
	(cond
		((not (eqv? textLayer1 -1))
		(set! indentedText1 (pk1-get-indented-text name1 indentedText1 action1))
		(set! indexList (find-in-string indentedText1 PK1_TOKEN))
		(set! layerNumber (+ layerNumber (length indexList)))
		(do ( (i 0 (+ i 1)) )
			((>= i (length indexList)) )
			(pk1-draw-mini-energy image textLayer1 indentedText1 (list-ref indexList i) action1)
		))
	)
	(cond
		((not (eqv? textLayer2 -1))
		(set! indentedText2 (pk1-get-indented-text name2 indentedText2 action2))
		(set! indexList (find-in-string indentedText2 PK1_TOKEN))
		(set! layerNumber (+ layerNumber (length indexList)))
		(do ( (i 0 (+ i 1)) )
			((>= i (length indexList)) )
			(pk1-draw-mini-energy image textLayer2 indentedText2 (list-ref indexList i) action2)
		))
	)
	(merge-topmost-layers image layerNumber)
	(if (> layerNumber 1)
		(gimp-drawable-set-name (get-layer-by-index image 0) PK1_LY_MINI_E)
	)
	layer
))

(define ( pk1-get-indented-text
				name text actionType )
(let* ( (indentedText "")
			(font "") (fontSize 0) (ifont "") (ifontSize 0)
		)
	(cond 
		((= PK1_OPT_PK_POWER actionType)
		(set! font PK1_PW_DESCRIPTION_FONT)
		(set! fontSize PK1_PW_DESCRIPTION_FONT_SIZE)
		(set! ifont PK1_PW_NAME_FONT)
		(set! ifontSize PK1_PW_NAME_FONT_SIZE)
		(set! indentedText (make-string-fit text name (- PK1_PW_END PK1_PW_START)
			ifontSize ifont fontSize font))
		)
		(else
		(set! font PK1_AT_DESCRIPTION_FONT)
		(set! fontSize PK1_AT_DESCRIPTION_FONT_SIZE)
		(set! ifont PK1_AT_NAME_FONT)
		(set! ifontSize PK1_AT_NAME_FONT_SIZE)
		(set! indentedText (make-string-fit text name (- PK1_ATTACK_END PK1_ATTACK_START)
			ifontSize ifont fontSize font))
		)
	)
	indentedText
))

(define ( pk1-draw-mini-energy
				image textLayer 
				text index actionType)
(let* ( (layer -1) (corner '()) (fileName "")
			(font "") (fontSize 0)
		)
	(cond 
		((= PK1_OPT_PK_POWER actionType)
		(set! font PK1_PW_DESCRIPTION_FONT)
		(set! fontSize PK1_PW_DESCRIPTION_FONT_SIZE)
		)
		(else
		(set! font PK1_AT_DESCRIPTION_FONT)
		(set! fontSize PK1_AT_DESCRIPTION_FONT_SIZE)
		)
	)
	(set! corner (get-char-position-in-text text index fontSize font))
	(set! fileName (token-to-type-filename (string-ref text (+ index 1))))
	(set! layer (car (gimp-file-load-layer RUN-NONINTERACTIVE image fileName)))
	(gimp-image-add-layer image layer 0)
	(gimp-layer-set-offsets layer (+ (car (gimp-drawable-offsets textLayer)) (- (car corner) 2))
		(+ (cadr (gimp-drawable-offsets textLayer)) (cadr corner)))
	
	layer
))

(define ( pk1-markup-replace
				str simpleSubstitute)
(let* ( (targets (list PK1_MARKUP_FIRE PK1_MARKUP_WATER PK1_MARKUP_LEAF
				PK1_MARKUP_ELECTRIC PK1_MARKUP_PSY PK1_MARKUP_PUNCH
				PK1_MARKUP_WHITE))
			(substitutes '())
		)
	(if (eqv? simpleSubstitute #t)
		(set! substitutes (list PK1_SUBSTITUTE PK1_SUBSTITUTE PK1_SUBSTITUTE
			PK1_SUBSTITUTE PK1_SUBSTITUTE PK1_SUBSTITUTE PK1_SUBSTITUTE))
		(set! substitutes (list (string PK1_TOKEN PK1_TOKEN_FIRE)
			(string PK1_TOKEN PK1_TOKEN_WATER) (string PK1_TOKEN PK1_TOKEN_LEAF)
			(string PK1_TOKEN PK1_TOKEN_ELECTRIC) (string PK1_TOKEN PK1_TOKEN_PSY)
			(string PK1_TOKEN PK1_TOKEN_PUNCH) (string PK1_TOKEN PK1_TOKEN_WHITE)))
	)
	(replace-words-in-string str targets substitutes)
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SAVE IMAGE
(define ( pk1-save-image
				image filename)
(let* ( (xcfFilename (string-append filename ".xcf"))
		   (pngFilename (string-append filename ".png"))
		)
	(gimp-xcf-save 0 image image (string-append CARD_DIR xcfFilename)
		(string-append CARD_DIR xcfFilename))
	(file-png-save RUN-NONINTERACTIVE image (car (gimp-image-merge-visible-layers
		image EXPAND-AS-NECESSARY)) (string-append CARD_DIR pngFilename) 
		(string-append CARD_DIR pngFilename) FALSE 9 TRUE FALSE FALSE TRUE TRUE)
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MAIN FUNCTION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (script-fu-pk-card-1
				evolution name hp type imageFile 
				firstAction fstAcWhECost fstAcColECost fstAcColEType 
					fstAcName fstActDescription	fstAcDamage
				secondAction scdAcWhECost scdAcColECost scdAcColEType 
					scdAcName scdActDescription scdAcDamage
				weakness resistance retreatCost pkDescription
				)
(let* ( (mainImage) 
			(backLayers) ; order : background border image description
			(headerLayers) ; order : name, evolution, hp and type
			(footerLayers) ; order : weakness resistance retreat (text then Energy)
			(actionLayers) ; order : energyCost name description damage (1 then 2)
									;			 and separator
			(lastLayers) ; order miniEnergies
		)
					
	(set! mainImage (car 
		(gimp-image-new (car CARD_DIMENSION) (cadr CARD_DIMENSION) RGB)))
	(gimp-image-undo-disable mainImage)
	
	(set! backLayers (pk1-draw-back-layers mainImage type pkDescription imageFile))
	(set! headerLayers (pk1-draw-header mainImage name evolution hp type))
	(set! footerLayers (pk1-draw-footer mainImage weakness resistance retreatCost))
	(set! actionLayers (pk1-draw-action-section mainImage firstAction fstAcWhECost 
		fstAcColECost fstAcColEType fstAcName fstActDescription fstAcDamage
		secondAction scdAcWhECost scdAcColECost scdAcColEType scdAcName
		scdActDescription scdAcDamage))
	(set! lastLayers (pk1-draw-mini-energies mainImage (list-ref actionLayers 2)
		(list-ref actionLayers 6) fstAcName scdAcName fstActDescription scdActDescription
		firstAction secondAction))
		
	(gimp-image-undo-enable mainImage)
	(gimp-display-new mainImage)
	(gimp-selection-none mainImage)
	;(pk1-save-image mainImage name)
	
	(gimp-image-clean-all mainImage)
	(list mainImage)
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;; REGISTERING ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(script-fu-register
	"script-fu-pk-card-1"
	"PokeCard1"
	"Creates a Pokemon Card."
	"Esteban Guevara"
	"copyleft"
	"2008"
	""	;image type to be used in the script
	;;;;;;;;;;;;;;;;;;;;;;;; main function parameters ;;;;;;;;;;;;;;;;;;;;;;;;;;;
	SF-STRING		"Evolution:"					"Basic Pokemon"
	SF-STRING		"Name:"						"Drowzee"
	SF-STRING		"Hit Points:"					"40"
	SF-OPTION		"Type:"						'("Fire" "Water" "Leaf" "Electric" "Psy" "Punch" "White")
	SF-FILENAME	"Image file:"					(string-append IMAGE_DIR "drowzee3.jpg")
	SF-OPTION		"First Action:"				'("Attack" "Pokemon Power")
	SF-VALUE			"White Energy Cost:"	"1"
	SF-VALUE			"Color Energy Cost:"	"0"
	SF-OPTION		"Color Energy Type:"		'("Fire" "Water" "Leaf" "Electric" "Psy" "Punch")
	SF-STRING		"First Action Name:"		""
	SF-TEXT			"Action Description:"	""
	SF-STRING		"Action Damage:"		"10"
	SF-OPTION		"Scd Action:"				'("Attack" "Nothing")
	SF-VALUE			"White Energy Cost:"	"1"
	SF-VALUE			"Color Energy Cost:"	"0"
	SF-OPTION		"Color Energy Type:"		'("Fire" "Water" "Leaf" "Electric" "Psy" "Punch")
	SF-STRING		"Scd Action Name:"		""
	SF-TEXT			"Action Description:"	""
	SF-STRING		"Action Damage:"		"10"
	SF-OPTION		"Weakness"				'("Fire" "Water" "Leaf" "Electric" "Psy" "Punch" "None")
	SF-OPTION		"Resistance"				'("Fire" "Water" "Leaf" "Electric" "Psy" "Punch" "None")
	SF-VALUE			"Retreat Cost"				"1"
	SF-TEXT			"Poke Description"		""
)

(script-fu-menu-register
	"script-fu-pk-card-1"
	"<Toolbox>/Xtns/Poke"
)
