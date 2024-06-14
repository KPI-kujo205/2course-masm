\masm32\bin\ml /c /coff "8-12-IM-22-Kuts-implicit-no-entry-proc.asm"
\masm32\bin\link32.exe /out:"8-12-IM-22-Kuts-implicit-no-entry-proc.dll" /export:ivanKutsCalculate /dll /noentry "8-12-IM-22-Kuts-implicit-no-entry-proc.obj"
\masm32\bin\ml /c /coff "8-12-IM-22-Kuts-implicit-no-entry-prog.asm"
\masm32\bin\link32.exe /subsystem:windows "8-12-IM-22-Kuts-implicit-no-entry-prog.obj"	
8-12-IM-22-Kuts-implicit-no-entry-prog.exe
