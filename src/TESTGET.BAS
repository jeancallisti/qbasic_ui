DECLARE SUB DecodeGetPixels (in() AS INTEGER, outArray() AS INTEGER)
DECLARE SUB DRawArray (arr() AS INTEGER, count AS INTEGER, startAt AS INTEGER)
DECLARE SUB DRawArrayEnlarged (arr() AS INTEGER, count AS INTEGER, startAt AS INTEGER)
DECLARE SUB PrintArray (sequence() AS INTEGER, count AS INTEGER, startAt AS INTEGER)
DECLARE SUB Test2 ()
DECLARE SUB Test1b ()
DECLARE SUB Test1 ()
DECLARE SUB Decode4words (w0 AS INTEGER, w1 AS INTEGER, w2 AS INTEGER, w3 AS INTEGER, result() AS INTEGER)
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

OPTION BASE 0



'================ GLOBALS: COLORS ==================

DIM SHARED black AS INTEGER
black = 0
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


'Test1
Test1b
'Test2




OSLeaveGfx
PRINT "Bye bye"


   '========================================================

' Out expected to be an array of 16
SUB Decode4words (w0 AS INTEGER, w1 AS INTEGER, w2 AS INTEGER, w3 AS INTEGER, outArray() AS INTEGER)


   'PRINT "words to decode = "; w0%; ","; w1%; ","; w2%; ","; w3%

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
	outArray(position%) = b3% * 8 + b2% * 4 + b1% * 2 + b0%


	'PRINT b0%; ","; b1%; ","; b2%; ","; b3%
	IF bit% = 3 THEN PRINT " "

   NEXT

   'PRINT " "

   FOR bit% = 8 TO 14


	b0% = (w0% \ (2 ^ bit%)) AND 1
	b1% = (w1% \ (2 ^ bit%)) AND 1
	b2% = (w2% \ (2 ^ bit%)) AND 1
	b3% = (w3% \ (2 ^ bit%)) AND 1


	'the order is not right
	position% = 8 + 15 - bit%
	outArray(position%) = b3% * 8 + b2% * 4 + b1% * 2 + b0%

	'PRINT b0%; ","; b1%; ","; b2%; ","; b3%
	IF bit% = 11 THEN PRINT " "

   NEXT

   'very last bit (highest-order) : 1 if negative

   'PRINT highb0%; ","; highb1%; ","; highb2%; ","; highb3%

   outArray(8) = highb3% * 8 + highb2% * 4 + highb1% * 2 + highb0%


   'SLEEP

END SUB

' This SUB only works for mode SCREEN 12
'
SUB DecodeGetPixels (in() AS INTEGER, outArray() AS INTEGER)

  DIM SixteenPixels(0 TO 15) AS INTEGER

  w% = in(0)
  h% = in(1)


  PRINT "Decoding "; w%; " * "; h%; " pixels from GET buffer"

  'rounded like this:
  ' 0 pixels -> 0
  '1 to 16 pixels -> 1
  '17 to 32 pixels -> 2
  '33 to 48 pixels -> 3
  '49 to 64 -> 4
  '65 to 80 -> 5
  '81 to 96 -> 6
  '97 to 112-> 7
  wordsPerRowForOneBitPlane% = (w% + 15) \ 16
  
  PRINT "wordsPerRowForOneBitPlane: "; wordsPerRowForOneBitPlane%

  row% = 0
  totalPixels% = w% * h%
  currentPixel% = 0
  currentWord% = 0


  DO
    PRINT "DO : currentPixel "; currentPixel%; ", row "; row%; ", currentWord "; currentWord%
    
    w0% = in(2 + currentWord% + 0)
    w1% = in(2 + currentWord% + 1 * wordsPerRowForOneBitPlane% - 1)
    w2% = in(2 + currentWord% + 2 * wordsPerRowForOneBitPlane% - 1)
    w3% = in(2 + currentWord% + 3 * wordsPerRowForOneBitPlane% - 1)

    PRINT "4 words to decode : "; w0%; ","; w1%; ","; w2%; ","; w3%
    SLEEP

    CALL Decode4words(w0%, w1%, w2%, w3%, SixteenPixels())

    PRINT "Decoded as 16 pixels: "
    CALL PrintArray(SixteenPixels(), 16, 0)
    SLEEP

    currentPixelOnRow% = currentPixel% MOD w%

    PRINT "currentPixelOnRow%: "; currentPixelOnRow%


    FOR pixel% = 0 TO 15
       outArray(row% * w% + currentPixelOnRow% + pixel%) = SixteenPixels(pixel%)

    NEXT


    PRINT "outArray is now (first 100):"
    CALL PrintArray(outArray(), 100, 0)
    SLEEP

    currentWord% = currentWord% + 1

    ' at the end of each row of pixels
    ' we need to continue working with the same word
    ' because it contains pixels from this row and the next row.
    IF currentPixelOnRow% + 16 > w% THEN
       PRINT "Reached end of row of pixels. Staying on same current word."
       currentWord% = currentWord% - 1
       row% = row% + 1

       currentPixel% = currentPixel% + (w% - currentPixelOnRow%)
    ELSE
      
       currentPixel% = currentPixel% + 16

       
    END IF


    SYSTEM

  LOOP WHILE currentPixel% < totalPixels% - 1



  ' TODO: Finish with the last unprocessed words
  ' ...



END SUB

SUB DRawArray (arr() AS INTEGER, count AS INTEGER, startAt AS INTEGER)

  FOR I% = 0 TO count - 1
    colr% = arr(startAt + I%)
    PSET (I%, 0), colr%

  NEXT



END SUB

SUB DRawArrayEnlarged (arr() AS INTEGER, count AS INTEGER, startAt AS INTEGER)


  FOR I% = 0 TO count - 1
    colr% = arr(startAt + I%)
    CALL gfxRectFill(I% * 5, 20, I% * 5 + 4, 20 + 5, colr%)

  NEXT

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

SUB PrintArray (arr() AS INTEGER, count AS INTEGER, startAt AS INTEGER)
  sResult$ = ""
  FOR I% = 0 TO count - 1
    val$ = STR$(arr(startAt + I%))
    sResult$ = sResult$ + val$ + ","
  NEXT
  PRINT sResult$

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


DIM buffer1(500)

'=================

' Taking the contiguous words (2,3,4,5)
' works only because the GET captured 16 pixels wide.
' If GET captures more pixels then we need to compute
' the positions of the words we need.
w0% = buffer1(2 + 0)
w1% = buffer1(2 + 1)
w2% = buffer1(2 + 2)
w3% = buffer1(2 + 3)

CALL Decode4words(w0%, w1%, w2%, w3%, result())

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



'TODO: compute correct size for buffers
DIM buffer2(500) AS INTEGER

'sequence of 32*2 pixels (split into two arrays because I'm lazy)
DIM sequenceRow0(32) AS INTEGER
DIM sequenceRow1(32) AS INTEGER

'DIM result2(16) AS INTEGER


FOR attempt% = 0 TO 3

  IF attempt% = 0 THEN
    'First sequence: 0 to 15 followed by 15 to 0
    FOR I% = 0 TO 15
      sequenceRow0(I%) = I%
      sequenceRow1(I%) = 15 - I%
    NEXT
    FOR I% = 0 TO 15
      sequenceRow0(16 + I%) = 15 - I%
      sequenceRow1(16 + I%) = I%
    NEXT
  ELSE
    ' Random
    FOR I% = 0 TO 31
      sequenceRow0(I%) = RND * 15
      sequenceRow1(I%) = RND * 15
    NEXT

  END IF

  CLS
  PRINT ""
  PRINT ""
  PRINT ""

  PRINT "Random sequence "; attempt%; " (0 to 3)"

  PRINT ""
  PRINT "Pixels displayed on screen: "
  CALL PrintArray(sequenceRow0(), 32, 0)
  CALL PrintArray(sequenceRow1(), 32, 0)

  'For test: display pixels in small, at top-left of screen
  CALL DRawArray(sequenceRow0(), 32, 0)
  CALL DRawArray(sequenceRow1(), 32, 0)

  'For human verification: draw same, but enlarged, anywhere
  CALL DRawArrayEnlarged(sequenceRow0(), 32, 0)
  CALL DRawArrayEnlarged(sequenceRow1(), 32, 0)

  'Capture both rows of pixels,
  'along with some extra non-drawn pixels (i.e. black)on the right
  getWidth% = 100
  getHeight% = 2
  PRINT "Capturing screen: "; getWidth%; "*"; getHeight%; " area"
  GET (0, 0)-(getWidth% - 1, getHeight% - 1), buffer2(0)

  PRINT ""
  PRINT "Result of GET (first 100):"
  CALL PrintArray(buffer2(), 100, 0)
  PRINT ""

  w% = buffer2(0)
  h% = buffer2(1)
  PRINT "Width  : "; w%
  PRINT "Height : "; h%

  IF w% <> getWidth% OR h% <> getHeight% THEN
      PRINT "width or height incorrect"
      SYSTEM
  END IF

  spriteSizeInPixels% = w% * h%
  DIM decodedPixels(spriteSizeInPixels%) AS INTEGER
  CALL DecodeGetPixels(buffer2(), decodedPixels())


  PRINT "Decoded (first 100):"
  CALL PrintArray(decodedPixels(), 100, 0)

  'Verification of row 0
  FOR I% = 0 TO 99
    IF I% > 31 THEN
       IF decodedPixels(I%) <> 0 THEN
	   PRINT "Incorrect at "; I%; ", 0"
	   SYSTEM
       END IF
    ELSE
       IF sequenceRow0(I%) <> decodedPixels(I%) THEN
	  PRINT "Incorrect at "; I%; ", 0"
	  SLEEP
	  SYSTEM
       END IF
    END IF
  NEXT


  'Verification of row 1
  FOR I% = 0 TO 99
    IF I% > 31 THEN
       IF decodedPixels(100 + I%) <> 0 THEN
	   PRINT "Incorrect at "; I%; ", 1"
	   SYSTEM
       END IF
    ELSE
       IF sequenceRow1(I%) <> decodedPixels(100 + I%) THEN
	  PRINT "Incorrect at "; I%; ", 1"
	  SLEEP
	  SYSTEM
       END IF
    END IF
  NEXT

  PRINT "All correct"

  SLEEP

NEXT

SYSTEM

'== TODO ===


'pixels 16 to 31
CALL Decode4words(-1, -1, -1, -1, result())

sResult$ = ""
FOR I% = 0 TO 15
   'PRINT result(i%)
   val$ = STR$(result(I%))
   sResult$ = sResult$ + val$ + ","
NEXT
PRINT sResult$

'pixels 32 to 47
CALL Decode4words(-1, -1, -1, -1, result())

sResult$ = ""
FOR I% = 0 TO 15
   'PRINT result(i%)
   val$ = STR$(result(I%))
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
FOR I% = 0 TO 29
      FOR j% = 0 TO 9
	  colr% = RND * 15

	  'we save the first pixels for control later
	  index% = I% * 5
	  IF index% < 30 THEN generated(index%) = colr%
	  index% = I% * 5 + 1
	  IF index% < 30 THEN generated(index%) = colr%
	  index% = I% * 5 + 2
	  IF index% < 30 THEN generated(index%) = colr%
	  index% = I% * 5 + 3
	  IF index% < 30 THEN generated(index%) = colr%
	  index% = I% * 5 + 4
	  IF index% < 30 THEN generated(index%) = colr%

	  CALL gfxRectFill(u% + I% * 5, v% + j% * 5, u% + I% * 5 + 4, v% + j% * 5 + 4, colr%)
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
    '== TODO ==
    CALL Decode4words(-1, -1, -1, -1, result())


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

