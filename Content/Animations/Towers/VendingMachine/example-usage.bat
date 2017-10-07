ECHO OFF

REM
REM	This script can show you how you can easily use merge.py to automate some mundane tasks.
REM   Suppose you have 8 single animation frames as PNG files, and you want a 2X4 spritesheet ...
REM


REM Now, we want to vertically merge the two lines that we just created to make our finished
REM  spritesheet.
merge.py --vert  VendingMachineAttack.png VendingMachineIdle.png

REM The possibilities are endless!
REM Visit http://www.fydo.net

pause