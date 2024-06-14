\masm32\bin\ml /c /coff "8-12-IM-22-Kuts-explicit-entry-proc.asm"
\masm32\bin\link32.exe /out:"8-12-IM-22-Kuts-explicit-entry-proc.dll" /def:"8-12-IM-22-Kuts-explicit-entry.def" /dll /entry:ivanKutsEntryPoint "8-12-IM-22-Kuts-explicit-entry-proc.obj"
\masm32\bin\ml /c /coff "8-12-IM-22-Kuts-explicit-entry-prog.asm"
\masm32\bin\link32.exe /subsystem:windows "8-12-IM-22-Kuts-explicit-entry-prog.obj"	
8-12-IM-22-Kuts-explicit-entry-prog.exe
timeout 777