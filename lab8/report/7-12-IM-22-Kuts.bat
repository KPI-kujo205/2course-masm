@echo off
ml /c /coff "7-12-IM-22-Kuts-publicextern.asm"
ml /c /coff "7-12-IM-22-Kuts.asm"
link /subsystem:windows "7-12-IM-22-Kuts.obj" "7-12-IM-22-Kuts-publicextern.obj"
7-12-IM-22-Kuts.exe
pause