@echo off

echo Build Started

IF EXIST s2built.bin move /Y s2built.bin s2built.prev.bin >NUL

asm68k /k /p /q /o ae- Sonic2Alpha.asm, s2built.bin, , list.lst > log.txt
IF NOT EXIST s2built.bin goto LABLERR

echo Build Successful!

goto LABLDONE

:LABLERR
type log.txt
echo There was a problem building. Please check through the error message and fix the error.
:LABLDONE
pause