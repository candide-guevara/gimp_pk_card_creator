;	STRING HELP FUNCTIONS
;
;	Esteban Guevara
;	2008


(define ( string-to-word-list
				str)
(let* ( (result (list "first")) (char) (word "") (isSpace) (isWordEmpty)
		)
	(do ( (i 0 (+ i 1)) )
		((>= i (string-length str)) )
		(set! char (string-ref str i))		
		(set! isSpace (or 
			(char=? #\space char) (char=? #\tab char) (char=? char #\newline)))
		(set! isWordEmpty (or (string=? "" word) (string=? " " word)))
		(cond
			 ((and isSpace (not isWordEmpty))
				(begin (set! result (append result (list (string-copy word)))) (set! word "") ))
			((not isSpace)
				(set! word (string-append word (string-copy (string char)) )))
		)
	)
	(if (not isWordEmpty)
		(set! result (append result (list (string-copy word))))
	)
	(cdr result)
))

(define (string-to-word-list-indented
				str indentStr 
				indentfontSize indentfontName
				fontSize fontName)
(let* ( (result '()) (spaceStr "")
			(width 0) (spaceSize 0) (spaceNumber 0)
		)
	(set! width (car (gimp-text-get-extents-fontname
		indentStr indentfontSize PIXELS indentfontName)))
	(set! spaceSize (car (gimp-text-get-extents-fontname
		" " fontSize PIXELS fontName)) )
		
	(do ( (i 0 (+ i 1)) )
		((> i  (/ width spaceSize))
			(set! spaceNumber i) )
	)
	(set! spaceStr (make-string spaceNumber #\space))
			
	(set! result (string-to-word-list str))
	(set! result (append (list spaceStr) result) )
))

(define (word-list-to-string
				wordList n)
(do ( (i 0 (+ i 1)) (str "" str) )		
	((or (>= i n) (>= i (length wordList))) str)
	(set! str (string-append str (string-copy (list-ref wordList i))))		 
	(if (and (not (eqv? i (- n 1))) (not (eqv? i (- (length wordList) 1))) )
		(set! str (string-append str " "))
	)
))

(define ( word-list-to-width-list
				wordList fontSize fontName)
(let* ( (result '())
		)
	(do ( (i 0 (+ i 1)) )
		((>= i (- (length wordList) 1)) ) 
		(set! result (append result (list (car (gimp-text-get-extents-fontname
			(string-append (list-ref wordList i) " ") fontSize PIXELS fontName)))) )
	)
	(if (> (length wordList) 0)
		(set! result (append result (list (car (gimp-text-get-extents-fontname
			(list-ref wordList (- (length wordList) 1)) fontSize PIXELS fontName)))) )
	)
	result
))

(define ( make-it-fit
				wordList width fontSize fontName)
(let* ( (result "") (tempList wordList)
			(widthList '()) (temp "")
		)
	(set! widthList (word-list-to-width-list wordList fontSize fontName))
	(do ( (n 0 n) )
		((>= n (length wordList)) )
		(do ( (i 0 i) (w 0 w) (j 0 j) )
			((or (> w width) (>= i (length tempList)))
				(if (and (<= w width) (>= i (length tempList)))
					(set! j i)
					(set! j (- i 1))
				)
				(set! temp (word-list-to-string tempList j))
				(set! result (string-append result temp (string #\newline)))
				(set! tempList (list-tail tempList j))
				(set! n (+ n j))
			)
			(set! w (+ w (list-ref widthList (+ n i) )))
			(set! i (+ i 1))
		)
	)
	(if (not (string=? result ""))
		(substring result 0 (- (string-length result) 1))
		(quote "No description available")
	)
))

(define ( make-string-fit
				str indentStr width
				indentFontSize indentFontName
				fontSize fontName
				)
(let* ( (wordList "") 
		)
	(if (string=? indentStr "")
		(set! wordList (string-to-word-list str))
		(set! wordList (string-to-word-list-indented
			str indentStr indentFontSize indentFontName fontSize fontName))
	)
	(make-it-fit wordList width fontSize fontName)
))

(define ( get-last-line
				str )
(let * ( (lastLine str)
			)
	(do ( (i 0 (+ i 1)) )
		((>= i (string-length str)) )
		(cond
			( (and (char=? (string-ref str i) #\newline) (< i (string-length str)))
				(set! lastLine (substring str (+ i 1) (string-length str))))
			( (char=? (string-ref str i) #\newline)	
				(set! lastLine ""))
		)
	)
	lastLine
))

(define ( find-in-string
				str charToken )
(do ( (i 0 (+ i 1)) (tokenIndex '() tokenIndex) )
	((>= i (string-length str)) tokenIndex)
	(if (char=? charToken (string-ref str i))
		(set! tokenIndex (append tokenIndex (list i)))
	)
))

(define ( get-char-position-in-text
				str charIndex fontSize font )
(let* ( (width 0) (height 0) (temp 0)
			(subStr (substring str 0 charIndex))
		)
	(set! height (cadr (gimp-text-get-extents-fontname subStr fontSize PIXELS font)))
	(set! temp (cadr (gimp-text-get-extents-fontname " " fontSize PIXELS font)))
	(set! height (- height temp) )
	
	(set! subStr (get-last-line subStr))
	(set! width (car (gimp-text-get-extents-fontname subStr fontSize PIXELS font)))
		
	(list width height)
))

(define ( replace-words-in-string
				str targets substitutes )
(let* ( (wordList (string-to-word-list str))
			(newWordList '()) (newStr "")
		)
	(do ( (i 0 (+ i 1)) (word 0 word))
		((>= i (length wordList)) )
		(set! word (list-ref wordList i))
		(do ( (j 0 (+ j 1)) )
			((>= j (length targets)) )
			(if (string=? (list-ref wordList i) (list-ref targets j))
				(set! word (list-ref substitutes j))
			)
		)
		(set! newWordList (append newWordList (list word)))
	)
	(word-list-to-string newWordList (length newWordList))
)) 

