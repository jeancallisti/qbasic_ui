DECLARE SUB Test2 ()
DECLARE SUB Test1b ()
DECLARE SUB Test1 ()
DECLARE SUB Decode4Words (buffer() AS INTEGER, startOffset AS INTEGER, result() AS INTEGER)
'============= OS ===============


DECLARE SUB OSEnterGfx ()
DECLARE SUB OSLeaveGfx ()

'============= GFX ==============


DECLARE SUB GfxRect (x1%, y1%, x2%, y2%, colr%)
DECLARE SUB gfxRectFill (x1%, y1%, x2%, y2%, colr%)


'===================================
'===================================
'===================================



'\\\
'$INCLUDE: 'QBX.BI'




'================ GLOBALS: COLORS ==================

DIM SHARED BLACK AS INTEGER
BLACK = 0
DIM SHARED DARKBLUE AS INTEGER
DARKBLUE = 1
DIM SHARED BROWN AS INTEGER
BROWN = 4
DIM SHARED RED AS INTEGER
RED = 6
DIM SHARED GRAY AS INTEGER
GRAY = 7
DIM SHARED DARKGRAY AS INTEGER
DARKGRAY = 8




'============================================
'============================================
'============================================


OSEnterGfx


DIM SHARED result(16) AS INTEGER
DIM SHARED buffer(1000) AS INTEGER


Test1
Test1b
Test2




OSLeaveGfx
PRINT "Bye bye"


   '========================================================

' Result expected to be an array of 16
' Buffer expected to have at least 4 INTEGERS starting from startOffset
SUB Decode4Words (buffer() AS INTEGER, startOffset AS INTEGER, result() AS INTEGER)


   w0% = buffer(startOffset + 0)
   w1% = buffer(startOffset + 1)
   w2% = buffer(startOffset + 2)
   w3% = buffer(startOffset + 3)



   'PRINT "words = "; w0%; ","; w1%; ","; w2%; ","; w3%

   'SLEEP


   'we get the highest order bit first before we blast it
   '(negative 16-bit integer means highest bit == 1)
   highb0% = -(w0% < 0)
   highb1% = -(w1% < 0)
   highb2% = -(w2% < 0)
   highb3% = -(w3% < 0)


   'zeroify the highest order bit, to work only with positive integers
   w0% = w0% AND 32767
   w1% = w1% AND 32767
   w2% = w2% AND 32767
   w3% = w3% AND 32767



   FOR bit% = 0 TO 7
	b0% = (w0% \ (2 ^ bit%)) AND 1
	b1% = (w1% \ (2 ^ bit%)) AND 1
	b2% = (w2% \ (2 ^ bit%)) AND 1
	b3% = (w3% \ (2 ^ bit%)) AND 1
	

      
	'the order is not right
	position% = 7 - bit%
	result(position%) = b3% * 8 + b2% * 4 + b1% * 2 + b0%


	'PRINT b0%; ","; b1%; ","; b2%; ","; b3%
	IF bit% = 3 THEN PRINT " "

   NEXT

   PRINT " "

   FOR bit% = 8 TO 14


	b0% = (w0% \ (2 ^ bit%)) AND 1
	b1% = (w1% \ (2 ^ bit%)) AND 1
	b2% = (w2% \ (2 ^ bit%)) AND 1
	b3% = (w3% \ (2 ^ bit%)) AND 1


	'the order is not right
	position% = 8 + 15 - bit%
	result(position%) = b3% * 8 + b2% * 4 + b1% * 2 + b0%

	'PRINT b0%; ","; b1%; ","; b2%; ","; b3%
	IF bit% = 11 THEN PRINT " "

   NEXT

   'very last bit (highest-order) : 1 if negative

   'PRINT highb0%; ","; highb1%; ","; highb2%; ","; highb3%

   result(8) = highb3% * 8 + highb2% * 4 + highb1% * 2 + highb0%


   'SLEEP

END SUB

SUB GfxRect (x1%, y1%, x2%, y2%, colr%)
   LINE (x1%, y1%)-(x1%, y2%), colr%
   LINE (x2%, y1%)-(x2%, y2%), colr%
   LINE (x1%, y1%)-(x2%, y1%), colr%
   LINE (x1%, y2%)-(x2%, y2%), colr%
END SUB

SUB gfxRectFill (x1%, y1%, x2%, y2%, colr%)
   FOR j% = y1% TO y2%
       LINE (x1%, j%)-(x2%, j%), colr%
   NEXT
END SUB

SUB OSEnterGfx
    'originalScreenMode = SCREEN(0)
    SCREEN 12
END SUB

SUB OSLeaveGfx
    SCREEN 10
END SUB

SUB Test1


'=============TEST 1 : COLORS 0 TO 15 ======


CLS
FOR inputColor% = 0 TO 15
    PSET (inputColor%, 0), inputColor%

    CALL gfxRectFill(100 + inputColor% * 20, 30 + 20, 100 + inputColor% * 20 + 19, 30 + 20 + 19, inputColor%)
NEXT

SLEEP

'=================


bufferSize% = 16 \ 16 + 100

GET (0, 0)-(15, 0), buffer(0)
'PRINT "w=", buffer(0), ", h="; buffer(1)
'SLEEP




'=================


CALL Decode4Words(buffer(), 2, result())

'=================

FOR outputColor% = 0 TO 15
    colr% = result(outputColor%)
    PSET (outputColor%, 0), colr%
    CALL gfxRectFill(100 + outputColor% * 20, 100, 100 + outputColor% * 20 + 19, 100 + 19, colr%)

NEXT

SLEEP

END SUB

SUB Test1b

' ARBITRARY SEQUENCE


CLS

FOR i% = 0 TO 40
   IF i% < 10 THEN
   colr% = 11
   ELSE
	IF i% < 20 THEN
	colr% = 5
	ELSE
		IF i% < 30 THEN
		colr% = 0
		ELSE
			IF i% < 40 THEN
			colr% = 4
			END IF
		END IF
	END IF
   END IF


   PSET (i%, 0), colr%
NEXT


GET (0, 0)-(39, 0), buffer(0)

' picels 0 to 15
CALL Decode4Words(buffer(), 2, result())


sResult$ = ""
FOR i% = 0 TO 15
   'PRINT result(i%)
   val$ = STR$(result(i%))
   sResult$ = sResult$ + val$ + ","
NEXT
PRINT sResult$


' pixels 16 to 31
CALL Decode4Words(buffer(), 6, result())

sResult$ = ""
FOR i% = 0 TO 15
   'PRINT result(i%)
   val$ = STR$(result(i%))
   sResult$ = sResult$ + val$ + ","
NEXT
PRINT sResult$

'pixels 32 to 47
CALL Decode4Words(buffer(), 10, result())

sResult$ = ""
FOR i% = 0 TO 15
   'PRINT result(i%)
   val$ = STR$(result(i%))
   sResult$ = sResult$ + val$ + ","
NEXT
PRINT sResult$


SLEEP

END SUB

SUB Test2

CLS




u% = 100
v% = 100

'Draw 30x10 tiles of random colors
DIM generated(31) AS INTEGER
FOR i% = 0 TO 29
      FOR j% = 0 TO 9
	  colr% = RND * 15

	  'we save the first pixels for control later
	  index% = i% * 5
	  IF index% < 30 THEN generated(index%) = colr%
	  index% = i% * 5 + 1
	  IF index% < 30 THEN generated(index%) = colr%
	  index% = i% * 5 + 2
	  IF index% < 30 THEN generated(index%) = colr%
	  index% = i% * 5 + 3
	  IF index% < 30 THEN generated(index%) = colr%
	  index% = i% * 5 + 4
	  IF index% < 30 THEN generated(index%) = colr%

	  CALL gfxRectFill(u% + i% * 5, v% + j% * 5, u% + i% * 5 + 4, v% + j% * 5 + 4, colr%)
      NEXT


NEXT

' write control pixels
PRINT generated(0); ","; generated(1); ","; generated(2); ","; generated(3); generated(4); ","; generated(5); ","; generated(6); ",..."

' Capture with a GET
xTopLeft% = u%
yTopLeft% = v%
xBottomRight% = u% + 30 * 5 - 1
yBottomRight% = v% + 10 * 5 - 1

DIM buffer2(10000) AS INTEGER
GET (xTopLeft%, yTopLeft%)-(xBottomRight%, yBottomRight%), buffer2

' Do come omputations
pixelsCount% = 30 * 5 * 10 * 5
wordsCount% = pixelsCount \ 16 + 1 * 4

x% = 0
y% = 0

spriteWidth% = buffer2(0)
spriteHeight% = buffer2(1)

PRINT "Sprite size ="; spriteWidth%; "*"; spriteHeight%
SLEEP

FOR word% = 0 TO wordsCount% - 1
    CALL Decode4Words(buffer2(), 2, result())


PRINT result(0); ","; result(1); ","; result(2); ","; result(3); result(4); ","; result(5); ","; result(6); ",..."
SLEEP

    FOR pixel% = 0 TO 15
	colr% = result(pixel%)
	PSET (u% + x%, v% + 100 + y%), colr%
	x% = x% + 1
	IF (x% > spriteWidth%) THEN
	  x% = 0
	  y% = y% + 1
	END IF

    NEXT
NEXT


SLEEP


END SUB

