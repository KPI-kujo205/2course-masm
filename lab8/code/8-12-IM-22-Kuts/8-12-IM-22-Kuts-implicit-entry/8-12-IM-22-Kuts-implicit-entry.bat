\masm32\bin\ml /c /coff "8-12-IM-22-Kuts-implicit-entry-proc.asm"
\masm32\bin\link32.exe /out:"8-12-IM-22-Kuts-implicit-entry-proc.dll" /export:ivanKutsCalculate /dll /entry:ivanKutsEntryPoint "8-12-IM-22-Kuts-implicit-entry-proc.obj"
\masm32\bin\ml /c /coff "8-12-IM-22-Kuts-implicit-entry-prog.asm"
\masm32\bin\link32.exe /subsystem:windows "8-12-IM-22-Kuts-implicit-entry-prog.obj"	
8-12-IM-22-Kuts-implicit-entry-prog.exe
