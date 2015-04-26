(define (script-fu-text-box 
				inText inFont inFontSize inFontColor)
(let* ( (theImage) 
			(theDimension)
			(theLayer) (theTextLayer))
				
	(set! theImage (car (gimp-image-new 50 50 RGB)))
	(set! theLayer (car 
		(gimp-layer-new theImage 1 1 RGBA-IMAGE "layer1" 100 NORMAL-MODE)))
	(gimp-image-add-layer theImage theLayer 0)
	(gimp-layer-resize-to-image-size theLayer)
	(gimp-drawable-fill theLayer TRANSPARENT-FILL)
	
	(gimp-context-set-background '(255 255 255))
	(gimp-context-set-foreground inFontColor)	
	
	(set! theDimension (gimp-text-get-extents-fontname inText inFontSize PIXELS inFont))
	(gimp-image-resize theImage (car theDimension) (cadr theDimension) 0 0)
	(set! theTextLayer (car 
		(gimp-text-fontname theImage -1 0 0 inText -1 TRUE inFontSize PIXELS inFont)))
	
	(gimp-display-new theImage)
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;; REGISTERING ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(script-fu-register
	"script-fu-text-box"
	"TextBox"
	"Creates a simple text box, sized to fit around the user's choice of text"
	"Michael Terry"
	"copyright"
	"1997"
	""	;image type to be used in the script
	;;;;;;;;;;;;;;;;;;;;;;;; main function parameters ;;;;;;;;;;;;;;;;;;;;;;;;;;;
	SF-STRING	"Text:"	"Default parameter"
	SF-FONT	"Font:"	"Sans"
	SF-ADJUSTMENT	"Font Size:"	'(50 1 1000 1 10 0 1)
	SF-COLOR	"Font Color:"		'(0 0 0)
)

(script-fu-menu-register
	"script-fu-text-box"
	"<Toolbox>/Xtns/Misc"
)
