;	IMAGE HELP FUNCTIONS
;
;	Esteban Guevara
;	2008

(define ( my-scale-image
				image scale )
(let* ( (width 0) (height 0)
		)
	(set! width (my-floor (* scale (car (gimp-image-width image)))))
	(set! height (my-floor (* scale (car (gimp-image-height image)))))
	(if (not (= scale 1.0))
		(gimp-image-scale image width height)
	)
))
