# qbasic_ui
A pet project to see if I can create a Windows-like UI for MS-DOS in QBASIC. 

# Code base highlights 
I am in no way an expert in QBASIC; I just want to see if I could create better programs than 15-yo me from decades ago.

I'm not a complete beginner, though. This isn't that "Guess the random number" game in text mode that you've seen  million times. You know the one. :-P

In this repository, you will find : 
- A little bit of calling DOS interrupts (for basic mouse, screen control)
- A little bit of memory addressing
- Some bit manipulation (especially to decode the result of the **GET** graphical command)
- etc.

Please note that this uses graphical mode **SCREEN 12** (640x480 pixels , 16 colors) and I haven't see a lot of QBASIC code on the Internet dealing with that mode. It's usually mostly MS-DOS mode 13h (320x200, 256 colors), better suited for video games.


# How to run

- Get DosBox.
- At the end of your DosBox config file (in the [autoexec] section), add this so that QBX.EXE can be run from any folder :
     `SET PATH=C:\bc7\bin;`
- Still in DosBox, use the classic `mount` command to mount the  repo's directory structure at the root of Dosbox's C:\
  For example if the project is in _C:\MyRepos\ThisProject_ on your computer, type this in DosBox :
  
  `mount c "C:\MyRepos\ThisProject"`

  Now if you run DosBox you see this in DOS:
     `C:\SRC`
     `C:\BC7`
  
     Note: **BC7** is the latest version of QBasic that was released back in the days. I think?
           It lets you compile to .EXE and even to binary libraries (.QLB)

     Note: Other folders are not really used, they remain from trial and error to make everything work.

- Go to C:\SRC
    `cd C:\SRC`
  
- Run `QBX.bat`.

  That batch file does 2 things :
    1. opens QBASIC in "high resolution" (/H switch), for comfort
    2. makes sure that library QBX.QLB gets loaded in memory (/L switch). It's supposed to be loaded by default anyways but you never know
 
- Open C:\SRC\MAIN.BAS or C:\SRC\MAINCPY.BAS, I'm not sure which. Every other .BAS file is just test tools or code stolen from the Internet to study the language.
- Run it with F5
- Press key Q to exit the program (I haven't managed to remember yet how to use INKEY$ to check ESC key  ;-))
