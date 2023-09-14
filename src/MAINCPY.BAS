DECLARE SUB MouseStateUpdate ()
DECLARE SUB MouseShow ()
DECLARE SUB gfxRectFill (x1%, y1%, x2%, y2%, colr%)
DECLARE SUB mMainLoop ()
DECLARE SUB MouseInit ()
DECLARE SUB mRender ()
DECLARE SUB mRenderCursor ()
DECLARE SUB mRenderWallpaper (wallPaper AS INTEGER)
DECLARE SUB mRenderWindow (winHandle%)
DECLARE SUB wpBackup (X AS INTEGER, Y AS INTEGER)
DECLARE SUB wpInit ()
DECLARE SUB wpRestore (X AS INTEGER, Y AS INTEGER)




OPTION BASE 0

'\\\
'$INCLUDE: 'QBX.BI'

'============= OS ===============


DECLARE SUB OSEnterGfx ()
DECLARE SUB OSLeaveGfx ()
DECLARE SUB OSMouse (var1%, var2%)


DIM SHARED inreg AS RegTypeX
DIM SHARED outreg AS RegTypeX


'============= GFX ==============
DECLARE SUB GfxRect (x1%, y1%, x2%, y2%, colr%)


'============ MOUSE =============

TYPE MouseStruct
   X AS INTEGER
   Y AS INTEGER
   LEFTDOWN AS INTEGER
   LEFTCLICK AS INTEGER
   RIGHTDOWN AS INTEGER
   RIGHTCLICK AS INTEGER
END TYPE

DIM SHARED MouseState AS MouseStruct


'========= WALLPAPER ===================

'640*450 screen divided into 12*9 blocks of 50*50 pixels each,
'of which 20 can be saved as downgraded sprites of 5*5 pixels
DIM SHARED wpIsBackedUp(12 * 9) AS INTEGER
DIM SHARED wpBackupIndex(20) AS INTEGER
DIM SHARED wpBackupData(5 * 5 * 20) AS INTEGER


'=========== WINDOWS ===================


TYPE WinType
   X AS INTEGER
   Y AS INTEGER
   w AS INTEGER
   h AS INTEGER
   z AS INTEGER
END TYPE


DIM SHARED Win0 AS WinType

Win0.X = 150
Win0.Y = 150
Win0.w = 300
Win0.h = 200
Win0.z = 1

'=======================================
'
'=======================================




CALL wpInit
CALL MouseInit

CALL OSEnterGfx
CALL MouseShow

CALL mRenderWallpaper(0)
CALL mRenderWindow(0)
CALL mMainLoop

CALL OSLeaveGfx

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

SUB mMainLoop

     STATIC mustExit AS INTEGER
     STATIC isEsc AS INTEGER
     mustExit = 0

     DO
	key$ = INKEY$
       
	'IF key$ = CHR$(27) THEN
	IF key$ = "q" OR key$ = "Q" THEN
	   mustExit = 1
	END IF


	
	CALL MouseStateUpdate
	CALL mRender

     LOOP UNTIL mustExit = 1

END SUB

SUB MouseHide
   CALL OSMouse(2, 0)
END SUB

SUB MouseInit
   CALL OSMouse(0, 0)

   'IF OutReg.AX <= 0 THEN
   '   PRINT "No mouse or no mouse driver"
   '   SYSTEM
   'END IF
END SUB

SUB MouseShow
   CALL OSMouse(1, 0)
END SUB

SUB MouseStateUpdate
  
   'Position
   CALL OSMouse(3, 0)

   'IF OutReg.AX = &HFFFF THEN
   '   PRINT "No mouse"
   '   SYSTEM
   'END IF

   MouseState.X = outreg.cx
   MouseState.Y = outreg.dx

   'Buttons

   MouseState.LEFTDOWN = 0
   MouseState.LEFTCLICK = 0
   MouseState.RIGHTDOWN = 0
   MouseState.RIGHTCLICK = 0

   CALL OSMouse(5, 0)

   'Left
   IF (outreg.ax AND 1) = 1 THEN
      MouseState.LEFTDOWN = 1  ' Mouse is held down
      IF (outreg.bx > 0) THEN
	MouseState.LEFTCLICK = 1 'Mouse was down now it's up again
	'PRINT "Click"
      END IF
   END IF

   'Right
   IF (outreg.ax AND 2) = 2 THEN
      MouseState.RIGHTDOWN = 1  ' Mouse is held down
      IF (outreg.bx > 0) THEN
	MouseState.RIGHTCLICK = 1 'Mouse was down now it's up again
       
      END IF
   END IF

END SUB

SUB mRender
    
    'LINE (160, 0)-(160, 199)
    'LINE (0, 100)-(319, 100)

    CALL mRenderCursor


    'SLEEP 10
 
    
END SUB

SUB mRenderCursor
    IF MouseState.LEFTDOWN > 0 THEN
       mouseColor% = 6 'Red
    ELSE
       mouseColor% = 15 'White
    END IF

    LINE (MouseState.X - 10, MouseState.Y)-(MouseState.X - 2, MouseState.Y), mouseColor%
    LINE (MouseState.X + 2, MouseState.Y)-(MouseState.X + 10, MouseState.Y), mouseColor%
    LINE (MouseState.X, MouseState.Y - 10)-(MouseState.X, MouseState.Y - 2), mouseColor%
    LINE (MouseState.X, MouseState.Y + 2)-(MouseState.X, MouseState.Y + 10), mouseColor%
END SUB

SUB mRenderWallpaper (wallPaper AS INTEGER)
    
    DIM colrOffset AS INTEGER
    DIM colr AS INTEGER

    'wallpaper 0 (diagonal lines)

    IF wallPaper = 0 THEN
       DIM offset AS INTEGER
       FOR j% = 0 TO 450
       colrOffset = 0
       FOR i% = 0 TO 10
	  colr = colrOffset + 7 'goal : Always 7, 8 or 9
	  LINE (i% * 100 + offset, j%)-(i% * 100 + 99 + offset, j%), colr
	  colrOffset = (colrOffset + 1) MOD 3
       NEXT
       offset = offset - 1
       NEXT


    ' Wallpaper 1 (large squares)

    ELSEIF wallPaper = 1 THEN
    colr% = 7

    FOR j% = 0 TO 2
	FOR i% = 0 TO 3
	    CALL gfxRectFill(i% * 10 * 16, j% * 10 * 16, i% * 10 * 16 + 159, j% * 10 * 16 + 159, colr%)
	    colr% = colr% + 1
	    IF colr% = 10 THEN colr% = 7
	NEXT
    NEXT
    END IF

END SUB

SUB mRenderWindow (winHandle%)
    IF winHandle% <> 0 THEN
	PRINT "Not implemented: Extra windows"
	SYSTEM
    END IF

    X% = Win0.X
    Y% = Win0.Y
    w% = Win0.w
    h% = Win0.h

    outLineColor% = 0 'black
    insideColor% = 7 'gray
    CALL GfxRect(X%, Y%, X% + w%, Y% + h%, outLineColor%)
    CALL gfxRectFill(X% + 1, Y% + 1, X% + w% - 1, Y% + h% - 1, insideColor%)

    'shadow
    offset% = 15
    shadowColor% = 8 'dark gray
    CALL gfxRectFill(X% + offset%, Y% + h% + 1, X% + w% + offset%, Y% + h% + offset%, shadowColor%)
    CALL gfxRectFill(X% + w% + 1, Y% + offset%, X% + w% + offset%, Y% + h%, shadowColor%)


    'Title bar
    barColor% = 1 'dark blue
    barHeight% = 25
    CALL gfxRectFill(X% + 1, Y% + 1, X% + w% - 1, Y% + barHeight% - 1, barColor%)
    LINE (X% + 1, Y% + barHeight%)-(X% + w% - 1, Y% + barHeight%), 0

END SUB

SUB OSEnterGfx
'originalScreenMode = SCREEN(0)
SCREEN 12
END SUB

SUB OSLeaveGfx
    SCREEN 10

END SUB

SUB OSMouse (var1%, var2%)
    inreg.ax = var1%
    inreg.bx = var2%
    CALL InterruptX(&H33, inreg, outreg)
END SUB

SUB wpBackup (X AS INTEGER, Y AS INTEGER)

   ' compute which 50*50 area this is
   DIM i AS INTEGER
   DIM j AS INTEGER

   i = X \ 50  'backslash = integer division!
   j = Y \ 50


   'Reminder : screen = 640*450 -> 12*9 squares of 50*50
   index% = j * 12 + i

   currentBackup% = wpIsBackedUp(index%)

   'already backed up
   IF currentBackup% >= 0 THEN
      RETURN
   END IF

   'need to back up
   ' Find a free square
   FOR squareIndex% = 0 TO 19
      IF wpBackupIndex(squareIndex%) = -1 THEN

	 EXIT FOR
      END IF
   NEXT

   'Reserve the square
   wpIsBackedUp(index%) = squareIndex%


   'DIM BUFFER(250) AS INTEGER
   DIM buffer(1000) AS INTEGER

   'temporarily save the screen area at normal resolution
   x1% = i * 50
   y1% = j * 50
   x2% = i * 50 + 49
   y2% = j * 50 + 49
   GET (x1%, y1%)-(x2%, y2%), buffer(0)

   'store the downgraded screen area
   FOR sy% = 0 TO 4

       FOR sx% = 0 TO 4

	   wpBackupData(squareIndex% + sx% * 5 + sy%) = buffer(sy% * 10 * 50 + sx% * 10)
       NEXT
   NEXT


   


END SUB

SUB wpInit

    FOR i% = 0 TO (12 * 9 - 1)
	wpIsBackedUp(i%) = -1
    NEXT


    FOR i% = 0 TO 19

	wpBackupIndex(i%) = -1
    NEXT


END SUB

SUB wpRestore (X AS INTEGER, Y AS INTEGER)

   ' compute which 50*50 area this is
   DIM i AS INTEGER
   DIM j AS INTEGER

   i = X \ 50  'backslash = integer division!
   j = Y \ 50


   'Reminder : screen = 640*450 -> 12*9 squares of 50*50
   index% = j * 12 + i

   currentBackup% = wpIsBackedUp(index%)


   IF currentBackup% < 0 THEN
	PRINT "This wallpaper area was never backed up"
	SYSTEM
   END IF

   squareIndex% = wpBackupIndex(currentBackup%)

   'Free the index for future use
   wpBackupIndex(currentBackup%) = -1


   alignedX% = i * 50
   alignedY% = j * 50

   FOR sy% = 0 TO 4

       FOR sx% = 0 TO 4

	  colr% = wpBackupData(squareIndex% + sy% * 5 + sx%)

	  CALL gfxRectFill(alignedX%, alignedY%, alignedX% + 50, alignedY% + 50, colr%)

       NEXT
   NEXT
    

END SUB

