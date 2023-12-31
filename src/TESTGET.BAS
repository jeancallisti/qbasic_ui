DECLARE FUNCTION Compare1Word% (w1() AS INTEGER, w2() AS INTEGER)
DECLARE SUB Decode1wordUnitTests ()
DECLARE SUB set1word (array() AS INTEGER, b0%, b1%, b2%, b3%, b4%, b5%, b6%, b7%, b8%, b9%, b10%, b11%, b12%, b13%, b14%, b15%)
DECLARE SUB Test6 ()
DECLARE SUB Test4 ()
DECLARE SUB Test3 ()
DECLARE SUB Decode1wordv2 (w AS INTEGER, outArray() AS INTEGER)
DECLARE SUB Decode1word (w AS INTEGER, outArray() AS INTEGER)
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



'CALL Decode1wordUnitTests

DIM SHARED result(16) AS INTEGER
DIM SHARED buffer(1000) AS INTEGER


'Test1
'Test1b
'Test2
'Test3
'Test4
Test6


OSLeaveGfx
PRINT "Bye bye"


   '========================================================

' Returns 0 if identical , 1 if different
FUNCTION Compare1Word% (w1() AS INTEGER, w2() AS INTEGER)

FOR i% = 0 TO 15

  IF (w1(i%) <> w2(i%)) THEN
     Compare1Word% = 1
  END IF

  Compare1Word% = 0


NEXT

END FUNCTION

SUB Decode1word (w AS INTEGER, outArray() AS INTEGER)
   'PRINT "word to decode = "; w%;

   'SLEEP


   'we get the highest order bit first before we blast it
   '(negative 16-bit integer means highest bit == 1)
   highb% = -(w% < 0)

   'zeroify the highest order bit, to work only with positive integers
   w% = w% AND 32767



   FOR bit% = 0 TO 7
	b% = (w% \ (2 ^ bit%)) AND 1

	'the order is not right
	position% = 7 - bit%
	outArray(position%) = b%


	'PRINT b%
	'IF bit% = 3 THEN PRINT " "

   NEXT

   'PRINT " "


   ' The bytes are inverted inside a Word;
   ' 0 to 7 need to come after 8 to 14
   FOR bit% = 8 TO 14


	b% = (w% \ (2 ^ bit%)) AND 1


	'the order is not right
	position% = 8 + 15 - bit%
	outArray(position%) = b%

	'PRINT b%
	'IF bit% = 11 THEN PRINT " "

   NEXT

   'very last bit (highest-order) : 1 if negative

   'PRINT highb%

   outArray(8) = highb%


   'SLEEP

END SUB

' This SUB decodes several 16-bits signed integers (Qbasic's INTEGER) type
' and checks that the binary result is correct
SUB Decode1wordUnitTests

   DIM expected(16) AS INTEGER

   DIM decoded(16) AS INTEGER


   '===================


   'Reset
   FOR i% = 0 TO 15
     expected(i%) = 0
   NEXT
   FOR i% = 0 TO 15
     decoded(i%) = 0
   NEXT


   w% = 0

   CALL set1word(expected(), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
   CALL Decode1wordv2(w%, decoded())

   IF (Compare1Word(expected(), decoded()) <> 0) THEN
      PRINT "binary decoding test failed"
      SLEEP
      SYSTEM
   END IF


   '===================


   'Reset
   FOR i% = 0 TO 15
     expected(i%) = 0
   NEXT
   FOR i% = 0 TO 15
     decoded(i%) = 0
   NEXT


   w% = 1

   CALL set1word(expected(), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1)
   CALL Decode1wordv2(w%, decoded())

   IF (Compare1Word(expected(), decoded()) <> 0) THEN
      PRINT "binary decoding test failed"
      SLEEP
      SYSTEM
   END IF


   '===================


   'Reset
   FOR i% = 0 TO 15
     expected(i%) = 0
   NEXT
   FOR i% = 0 TO 15
     decoded(i%) = 0
   NEXT


   w% = 3

   CALL set1word(expected(), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1)
   CALL Decode1wordv2(w%, decoded())

   IF (Compare1Word(expected(), decoded()) <> 0) THEN
      PRINT "binary decoding test failed"
      SLEEP
      SYSTEM
   END IF


   '===================


   'Reset
   FOR i% = 0 TO 15
     expected(i%) = 0
   NEXT
   FOR i% = 0 TO 15
     decoded(i%) = 0
   NEXT


   w% = 7

   CALL set1word(expected(), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1)
   CALL Decode1wordv2(w%, decoded())

   IF (Compare1Word(expected(), decoded()) <> 0) THEN
      PRINT "binary decoding test failed"
      SLEEP
      SYSTEM
   END IF


   '===================


   'Reset
   FOR i% = 0 TO 15
     expected(i%) = 0
   NEXT
   FOR i% = 0 TO 15
     decoded(i%) = 0
   NEXT


   w% = 255

   CALL set1word(expected(), 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1)
   CALL Decode1wordv2(w%, decoded())

   IF (Compare1Word(expected(), decoded()) <> 0) THEN
      PRINT "binary decoding test failed"
      SLEEP
      SYSTEM
   END IF


   '===================


   'Reset
   FOR i% = 0 TO 15
     expected(i%) = 0
   NEXT
   FOR i% = 0 TO 15
     decoded(i%) = 0
   NEXT


   w% = 254

   CALL set1word(expected(), 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0)
   CALL Decode1wordv2(w%, decoded())

   IF (Compare1Word(expected(), decoded()) <> 0) THEN
      PRINT "binary decoding test failed"
      SLEEP
      SYSTEM
   END IF



   '===================


   'Reset
   FOR i% = 0 TO 15
     expected(i%) = 0
   NEXT
   FOR i% = 0 TO 15
     decoded(i%) = 0
   NEXT


   w% = 256

   CALL set1word(expected(), 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0)
   CALL Decode1wordv2(w%, decoded())

   IF (Compare1Word(expected(), decoded()) <> 0) THEN
      PRINT "binary decoding test failed"
      SLEEP
      SYSTEM
   END IF



   '===================


   'Reset
   FOR i% = 0 TO 15
     expected(i%) = 0
   NEXT
   FOR i% = 0 TO 15
     decoded(i%) = 0
   NEXT


   w% = -1

   CALL set1word(expected(), 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)
   CALL Decode1wordv2(w%, decoded())

   IF (Compare1Word(expected(), decoded()) <> 0) THEN
      PRINT "binary decoding test failed"
      SLEEP
      SYSTEM
   END IF


   '===================


   'Reset
   FOR i% = 0 TO 15
     expected(i%) = 0
   NEXT
   FOR i% = 0 TO 15
     decoded(i%) = 0
   NEXT


   w% = -32768

   CALL set1word(expected(), 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
   CALL Decode1wordv2(w%, decoded())

   IF (Compare1Word(expected(), decoded()) <> 0) THEN
      PRINT "binary decoding test failed"
      SLEEP
      SYSTEM
   END IF

   '=====================


   PRINT "Unit tests OK"
   'SLEEP
   'SYSTEM
END SUB

SUB Decode1wordv2 (w AS INTEGER, outArray() AS INTEGER)


   'we get the highest order bit first before we blast it
   '(negative 16-bit integer means highest bit == 1)
   highb% = -(w% < 0)


   outArray(0) = highb%

   'zeroify the highest order bit, to work only with positive integers
   w% = w% AND 32767


   'SLEEP

   FOR bit% = 15 TO 1 STEP -1


     'PRINT "bit:"; bit%; "  word:"; w%

     b% = w% AND 1

     w% = w% \ 2

     outArray(bit%) = b%

     'PRINT "result: "; b%
     'SLEEP

   NEXT



   'PRINT "bit:"; 0; "  word:"; w%
   'PRINT "result: "; highb%

END SUB

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

  DIM sixteenPixels(0 TO 15) AS INTEGER

  w% = in(0)
  h% = in(1)


  PRINT "Decoding "; w%; " * "; h%; " pixels from GET buffer"

  IF w% = 0 OR h% = 0 THEN
     RETURN
  END IF

  totalPixels% = w% * h%
  totalWords% = (w% * h% * 4) \ 16 + 1

  IF totalWords% < 1 THEN
     PRINT "Woops"
     SYSTEM
  END IF

  overallWord% = 0

  'decode first word
  wordValue% = in(2 + overallWord%)
  CALL Decode1wordv2(wordValue%, sixteenPixels())
  PRINT "Decoded 16 bits: "
  CALL PrintArray(sixteenPixels(), 16, 0)
  

  row% = 0
  bitPlane% = 0
  bitOnRow% = 0
  overallPixel% = 0
  overallBit% = 0
  totalBits% = w% * h% * 4
  bitInWord% = 0

  WHILE overallBit% < totalBits% - 1

    bitValue% = sixteenPixels(bitInWord%)

    PRINT "row "; row%; "plane "; bitPlane%; "bit "; (overallBit% MOD w%); ":"; bitValue%

    currentValue% = outArray(overallPixel%)
    currentValue% = currentValue% + (bitValue% * (2 ^ bitPlane%))
    outArray(overallPixel%) = currentValue%


    overallBit% = overallBit% + 1


    'advance and/or loop word cursor
    bitInWord% = bitInWord% + 1

    IF bitInWord% >= 16 THEN

      bitInWord% = 0

      overallWord% = overallWord% + 1

      wordValue% = in(2 + overallWord%)
      CALL Decode1wordv2(wordValue%, sixteenPixels())
      PRINT "Decoded 16 bits: "
      CALL PrintArray(sixteenPixels(), 16, 0)

    END IF


    'advance and/or loop pixels row cursor
    bitOnRow% = bitOnRow% + 1
    overallPixel% = overallPixel% + 1
    IF bitOnRow% = w% THEN


       PRINT "end of bits row (bitPlane "; bitPlane%; ")"
       
       bitOnRow% = 0

       overallPixel% = overallPixel% - w%

       PRINT "overallPixel has been reverted back to "; overallPixel%
       SLEEP

       bitPlane% = bitPlane% + 1
       IF bitPlane% = 4 THEN

	 PRINT "End of bit plane. Next row of pixels."

	 bitPlane% = 0
	 row% = row% + 1
	 overallPixel% = overallPixel% + w%

	 PRINT "overallPixel has been increased to "; overallPixel%
	 SLEEP

       END IF

    END IF



  WEND


  PRINT "Decoding finished."
  SLEEP

END SUB

SUB DRawArray (arr() AS INTEGER, count AS INTEGER, startAt AS INTEGER)

  FOR i% = 0 TO count - 1
    colr% = arr(startAt + i%)
    PSET (i%, 0), colr%

  NEXT



END SUB

SUB DRawArrayEnlarged (arr() AS INTEGER, count AS INTEGER, startAt AS INTEGER)


  FOR i% = 0 TO count - 1
    colr% = arr(startAt + i%)
    CALL gfxRectFill(i% * 5, 20, i% * 5 + 4, 20 + 5, colr%)

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
  FOR i% = 0 TO count - 1
    val$ = STR$(arr(startAt + i%))
    sResult$ = sResult$ + val$ + ","
  NEXT
  PRINT sResult$

END SUB

SUB set1word (array() AS INTEGER, b0%, b1%, b2%, b3%, b4%, b5%, b6%, b7%, b8%, b9%, b10%, b11%, b12%, b13%, b14%, b15%)


   array(0) = b0%
   array(1) = b1%
   array(2) = b2%
   array(3) = b3%
   array(4) = b4%
   array(5) = b5%
   array(6) = b6%
   array(7) = b7%
   array(8) = b8%
   array(9) = b9%
   array(10) = b10%
   array(11) = b11%
   array(12) = b12%
   array(13) = b13%
   array(14) = b14%
   array(15) = b15%

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
  IF atttempt% = 0 THEN

    FOR i% = 0 TO 8
      sequenceRow0(i%) = 0
      sequenceRow1(i%) = 15
    NEXT

  ELSE
  IF attempt% = 1 THEN
    'First sequence: 0 to 15 followed by 15 to 0
    FOR i% = 0 TO 15
      sequenceRow0(i%) = i%
      sequenceRow1(i%) = 15 - i%
    NEXT
    FOR i% = 0 TO 15
      sequenceRow0(16 + i%) = 15 - i%
      sequenceRow1(16 + i%) = i%
    NEXT
  ELSE
    ' Random
    FOR i% = 0 TO 31
      sequenceRow0(i%) = RND * 15
      sequenceRow1(i%) = RND * 15
    NEXT

  END IF
  END IF


  '3 extra pixels that are easy to spot in the data
  PSET (32, 0), 15
  PSET (33, 0), 15
  PSET (34, 0), 15


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
  getWidth% = 9
  getHeight% = 2
  PRINT "Capturing screen: "; getWidth%; "*"; getHeight%; " area"
  GET (0, 0)-(getWidth% - 1, getHeight% - 1), buffer2(0)

  PRINT ""
  PRINT "Result of GET:"
  CALL PrintArray(buffer2(), getWidth * getHeight, 0)
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


  PRINT "Decoded (first N):"
  CALL PrintArray(decodedPixels(), getWidth% * getHeight%, 0)

  'Verification of row 0
  FOR i% = 0 TO 99
    IF i% > 31 THEN
       IF decodedPixels(i%) <> 0 THEN
	   PRINT "Incorrect at "; i%; ", 0"
	   SYSTEM
       END IF
    ELSE
       IF sequenceRow0(i%) <> decodedPixels(i%) THEN
	  PRINT "Incorrect at "; i%; ", 0"
	  SLEEP
	  SYSTEM
       END IF
    END IF
  NEXT


  'Verification of row 1
  FOR i% = 0 TO 99
    IF i% > 31 THEN
       IF decodedPixels(100 + i%) <> 0 THEN
	   PRINT "Incorrect at "; i%; ", 1"
	   SYSTEM
       END IF
    ELSE
       IF sequenceRow1(i%) <> decodedPixels(100 + i%) THEN
	  PRINT "Incorrect at "; i%; ", 1"
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
FOR i% = 0 TO 15
   'PRINT result(i%)
   val$ = STR$(result(i%))
   sResult$ = sResult$ + val$ + ","
NEXT
PRINT sResult$

'pixels 32 to 47
CALL Decode4words(-1, -1, -1, -1, result())

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

SUB Test3

PRINT ""
PRINT ""

DIM buffer4(100) AS INTEGER


'Reset
FOR j% = 0 TO 5
  FOR i% = 0 TO 100
   PSET (i%, j%), 0
  NEXT
NEXT

'Reset
FOR i% = 0 TO 99
  buffer4(i%) = 0
NEXT

FOR i% = 0 TO 7
   PSET (i%, 0), 15
NEXT

PRINT "0"
PRINT ""


GET (0, 0)-(7, 0), buffer4(0)

CALL PrintArray(buffer4(), 8, 0)

SLEEP

PRINT ""
PRINT ""


'===========================


'Reset
FOR j% = 0 TO 5
  FOR i% = 0 TO 100
   PSET (i%, j%), 0
  NEXT
NEXT

'Reset
FOR i% = 0 TO 99
  buffer4(i%) = 0
NEXT


FOR i% = 0 TO 5
   PSET (i%, 0), 15
NEXT

PRINT "1"
PRINT ""


GET (0, 0)-(7, 0), buffer4(0)

CALL PrintArray(buffer4(), 8, 0)

SLEEP

PRINT ""
PRINT ""


'===========================


'Reset
FOR j% = 0 TO 5
  FOR i% = 0 TO 100
   PSET (i%, j%), 0
  NEXT
NEXT

'Reset
FOR i% = 0 TO 99
  buffer4(i%) = 0
NEXT


FOR i% = 0 TO 9
   PSET (i%, 0), 15
NEXT

PRINT "2"
PRINT ""


GET (0, 0)-(7, 0), buffer4(0)

CALL PrintArray(buffer4(), 8, 0)

SLEEP

PRINT ""
PRINT ""



'===========================


'Reset
FOR j% = 0 TO 5
  FOR i% = 0 TO 100
   PSET (i%, j%), 0
  NEXT
NEXT

'Reset
FOR i% = 0 TO 99
  buffer4(i%) = 0
NEXT



FOR i% = 0 TO 7
   PSET (i%, 0), 15
NEXT

PRINT "3"
PRINT ""


GET (0, 0)-(7, 1), buffer4(0)

CALL PrintArray(buffer4(), 8, 0)

SLEEP

PRINT ""
PRINT ""





'===========================


'Reset
FOR j% = 0 TO 5
  FOR i% = 0 TO 100
   PSET (i%, j%), 0
  NEXT
NEXT

'Reset
FOR i% = 0 TO 99
  buffer4(i%) = 0
NEXT


FOR i% = 0 TO 9
   PSET (i%, 0), 15
NEXT

PRINT "4"
PRINT ""


GET (0, 0)-(7, 1), buffer4(0)

CALL PrintArray(buffer4(), 8, 0)

SLEEP

PRINT ""
PRINT ""



'===========================


'Reset
FOR j% = 0 TO 5
  FOR i% = 0 TO 100
   PSET (i%, j%), 0
  NEXT
NEXT

'Reset
FOR i% = 0 TO 99
  buffer4(i%) = 0
NEXT


FOR i% = 0 TO 5
   PSET (i%, 0), 15
NEXT

PRINT "5"
PRINT ""


GET (0, 0)-(7, 1), buffer4(0)

CALL PrintArray(buffer4(), 8, 0)

SLEEP

PRINT ""
PRINT ""

END SUB

SUB Test4

CLS

PRINT ""
PRINT ""
PRINT ""

DIM buffer5(100) AS INTEGER

PSET (0, 0), 15
GET (0, 0)-(0, 0), buffer5(0)

CALL PrintArray(buffer5(), 100, 0)

SLEEP

END SUB

SUB Test6

PRINT ""
PRINT ""

DIM buffer6(100) AS INTEGER



'===========================

'Reset
FOR j% = 0 TO 5
  FOR i% = 0 TO 100
   PSET (i%, j%), 0
  NEXT
NEXT

'Reset
FOR i% = 0 TO 99
  buffer6(i%) = 0
NEXT

PSET (0, 0), 15
PSET (0, 1), 15




PRINT "0"
PRINT ""


GET (0, 0)-(0, 1), buffer6(0)

CALL PrintArray(buffer6(), 97, 2)

SLEEP

PRINT ""
PRINT ""


'===========================


'Reset
FOR j% = 0 TO 5
  FOR i% = 0 TO 100
   PSET (i%, j%), 0
  NEXT
NEXT

'Reset
FOR i% = 0 TO 99
  buffer6(i%) = 0
NEXT


PSET (0, 0), 15


PRINT "1"
PRINT ""


GET (0, 0)-(0, 1), buffer6(0)

CALL PrintArray(buffer6(), 30, 2)

SLEEP

PRINT ""
PRINT ""


'===========================


'Reset
FOR j% = 0 TO 5
  FOR i% = 0 TO 100
   PSET (i%, j%), 0
  NEXT
NEXT

'Reset
FOR i% = 0 TO 99
  buffer6(i%) = 0
NEXT


FOR i% = 0 TO 9
  PSET (i%, 0), 15
  PSET (i%, 1), 15
NEXT


PRINT "2"
PRINT ""

	

GET (0, 0)-(9, 1), buffer6(0)

CALL PrintArray(buffer6(), 30, 2)

SLEEP

PRINT ""
PRINT ""



END SUB

