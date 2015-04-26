;	LAYER HELPER FUNCTIONS
;
;	Esteban Guevara
;	2008

(define ( get-layer-by-name
				image name)
(let* ( (layers (cadr (gimp-image-get-layers image))) 
			(layer -1) (temp)
		)
	(do ( (i 0 (+ i 1)) )
		((>= i (vector-length layers)) layer)
		(set! temp (vector-ref layers i))
		(if (string=? name (car (gimp-drawable-get-name temp)) )
			(set! layer temp) 
		)
	)
))

(define ( get-layer-by-index
				image index)
	(vector-ref (cadr (gimp-image-get-layers image)) 0)
)

(define ( merge-topmost-layers
				image number )
(do ( (i (- number 1) (- i 1)) )
	((<= i 0) )
	(gimp-image-merge-down image (get-layer-by-index image 0) EXPAND-AS-NECESSARY)
))

