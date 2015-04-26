;	GROUP CARDS
;
;	Groups cards in a single image file whose size can be adjusted.
;	Dependence : pk-card-parameters.scm
;	
;	Function-prefix : group
;	Constant-prefix : GROUP
;
;	Esteban Guevara
;	2008

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CONSTANTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define GROUP_OPT_LAYOUT_22 0)
(define GROUP_OPT_LAYOUT_32 1)
(define GROUP_OPT_LAYOUT_33 2)
(define GROUP_OPT_LAYOUT_44 3)
(define GROUP_OPT_LAYOUT_64 4)

(define GROUP_OPT_PNG 0)
(define GROUP_OPT_XCF 1)
(define GROUP_OPT_JPG 2)
(define GROUP_OPT_GIF 3)
(define GROUP_OPT_BMP 4)

(define GROUP_MARGIN 2)
(define GROUP_BACKGROUND_COLOR '(0 0 0))
(define GROUP_LY_BACKGROUND "Background")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; HELPER FUNCTIONS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define ( group-get-type-extension
				type )
(cond
	((= type GROUP_OPT_PNG) "png")
	((= type GROUP_OPT_XCF) "xcf")
	((= type GROUP_OPT_JPG) "jpg")
	((= type GROUP_OPT_GIF) "gif")
	((= type GROUP_OPT_BMP) "bmp")
))

(define ( group-get-card-number
				layout )
(cond
	((= layout GROUP_OPT_LAYOUT_22) 4)
	((= layout GROUP_OPT_LAYOUT_32) 6)
	((= layout GROUP_OPT_LAYOUT_33) 9)
	((= layout GROUP_OPT_LAYOUT_44) 16)
	((= layout GROUP_OPT_LAYOUT_64) 24)
))

(define ( group-get-layout
				layout )
(cond
	((= layout GROUP_OPT_LAYOUT_22) '(2 2))
	((= layout GROUP_OPT_LAYOUT_32) '(3 2))
	((= layout GROUP_OPT_LAYOUT_33) '(3 3))
	((= layout GROUP_OPT_LAYOUT_44) '(4 4))
	((= layout GROUP_OPT_LAYOUT_64) '(6 4))
))

(define ( group-get-image-group
				fileList layout
			)
(let* ( (cardNumber 0)
			(newFileList '()) (imageGroup '())
		)
	(set! cardNumber (group-get-card-number layout))
	(cond 
		((> (length fileList) cardNumber) 
		 (set! imageGroup (list-tail fileList (- (length fileList) cardNumber)))
		 (set! newFileList (list-tail (reverse fileList) cardNumber))
		)
		((<= (length fileList) cardNumber) 
		 (set! imageGroup fileList)
		 (set! newFileList '())
		)
	)	
	(list imageGroup newFileList)
))

(define ( group-create-background-image
				layout )
(let* ( (width 0) (height 0)
			(layoutList '()) (layer -1) (image -1)
		)
	(set! layoutList (group-get-layout layout))
	(set! width (+ (* (car layoutList) (car CARD_DIMENSION)) 
		(* GROUP_MARGIN (- (car layoutList) 1))))
	(set! height (+ (* (cadr layoutList) (cadr CARD_DIMENSION)) 
		(* GROUP_MARGIN (- (cadr layoutList) 1))))
	(set! image (car 	(gimp-image-new width height RGB)))
	(gimp-image-undo-disable image)	
	
	(set! layer (car (gimp-layer-new image width height RGBA-IMAGE GROUP_LY_BACKGROUND
		100 NORMAL-MODE )))
	(gimp-image-add-layer image layer 0)
	(gimp-context-set-foreground GROUP_BACKGROUND_COLOR)
	(gimp-selection-all image)
	(gimp-drawable-fill layer FOREGROUND-FILL)
	
	image
))

(define ( group-create-image
				fileList layout scale )
(let* ( (layoutList '())
			(layers '()) (image -1)
		)
	(set! layoutList (group-get-layout layout))
	(set! image (group-create-background-image layout))
	
	(do ( (i 0 (+ i 1)) (x 0 x) (y 0 y) (layer -1 layer) )
		((>= i (length fileList)) )		
		(set! x (modulo i (car layoutList)) )
		(set! y (quotient i (car layoutList)) )
		(set! x (* x (+ (car CARD_DIMENSION) GROUP_MARGIN)))
		(set! y (* y (+ (cadr CARD_DIMENSION) GROUP_MARGIN)))
		
		(set! layer (car (gimp-file-load-layer RUN-NONINTERACTIVE image (list-ref fileList i) )))
		(gimp-image-add-layer image layer 0)
		(gimp-layer-set-offsets layer x y)
	)
	(my-scale-image image scale)
	
	(gimp-image-undo-enable image)
	(gimp-selection-none image)
	(gimp-image-clean-all image)
	image
))

(define ( group-save-image
				image baseFileName number type outputDir)
(let* ( (fileName "")
		)
	(set! fileName (string-append outputDir "/" baseFileName "-" 
		(number->string number) "." type))
	(if (string=? type "xcf")
		(gimp-xcf-save 0 image image fileName fileName)
		(gimp-file-save RUN-NONINTERACTIVE image (car (gimp-image-merge-visible-layers
		image EXPAND-AS-NECESSARY)) fileName fileName)
	)	
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MAIN FUNCTION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (script-fu-group-cards
				sourceDir outputDir sourceType outputType
				baseName layout scale
			)
(let* ( (fileList '()) (imageList '())
			(sourceExtension (group-get-type-extension sourceType))
			(outputExtension (group-get-type-extension outputType))
		)					
	(set! fileList (cadr (file-glob (string-append sourceDir "/*." sourceExtension) 0)))
	(do ( (temp '() temp) (image -1 image) (i 0 (+ i 1)) )
		((null? fileList) )
		(set! temp (group-get-image-group fileList layout))
		(set! fileList (cadr temp))
		(cond ((not (null? (car temp)))
			(set! image (group-create-image (car temp) layout scale))
			(group-save-image image baseName i outputExtension outputDir)
			(set! imageList (append imageList (list image)))
		))
	)
	imageList
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;; REGISTERING ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(script-fu-register
	"script-fu-group-cards"
	"GroupCards"
	"Creates a Pokemon Trainer Card."
	"Esteban Guevara"
	"copyleft"
	"2008"
	""	;image type to be used in the script
	;;;;;;;;;;;;;;;;;;;;;;;; main function parameters ;;;;;;;;;;;;;;;;;;;;;;;;;;;
	SF-DIRNAME	"Source Dir"							CARD_DIR
	SF-DIRNAME	"Output Dir"							CARD_DIR
	SF-OPTION		"Source image type"			'("png" "xcf" "jpg" "gif" "bmp")
	SF-OPTION		"Output image type"			'("png" "xcf" "jpg" "gif" "bmp")
	SF-STRING		"Output base filename"		"cards"
	SF-OPTION		"Cards per image"				'("2*2" "3*2" "3*3" "4*4" "6*4")
	SF-VALUE			"Scale Card size"					"1.0"
)

(script-fu-menu-register
	"script-fu-group-cards"
	"<Toolbox>/Xtns/Poke"
)
