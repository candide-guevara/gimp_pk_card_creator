;	NUMBER HELP FUNCTIONS
;
;	Esteban Guevara
;	2008

(define ( my-floor
				number )
(do ( (i 0 (+ i 1)) )
	((> i number) (- i 1))
))
