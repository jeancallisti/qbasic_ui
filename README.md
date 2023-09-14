# qbasic_ui
A pet project to see if I can create a Windows-like UI for MS-DOS in QBASIC. 


I am in no way an expert in QBASIC; I just want to see if I could create better programs than 15-yo me from decades ago.

I'm a decent programmer, though. This isn't just a Fibonacci sequence in text mode :-P

In this repository, you will find : 
- A little bit of calling DOS interrupts (for basic mouse, screen control)
- A little bit of memory addressing
- Some bit manipulation (especially to decode the result of the **GET** graphical command)
- etc.

Please note that this uses graphical mode **SCREEN 12** (640x480 pixels , 16 colors) and I haven't see a lot of QBASIC code on the Internet dealing with that mode. It's usually mostly MS-DOS mode 13h (320x200, 256 colors), better suited for video games.
