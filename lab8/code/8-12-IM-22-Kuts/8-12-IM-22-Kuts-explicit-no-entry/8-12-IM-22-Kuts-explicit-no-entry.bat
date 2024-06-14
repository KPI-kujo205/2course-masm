\masm32\bin\ml /c /coff "8-12-IM-22-Kuts-explicit-no-entry-proc.asm"
\masm32\bin\link32.exe /out:"8-12-IM-22-Kuts-explicit-no-entry-proc.dll" /def:"8-12-IM-22-Kuts-explicit-no-entry.def" /dll /noentry "8-12-IM-22-Kuts-explicit-no-entry-proc.obj"
\masm32\bin\ml /c /coff "8-12-IM-22-Kuts-explicit-no-entry-prog.asm"
\masm32\bin\link32.exe /subsystem:windows "8-12-IM-22-Kuts-explicit-no-entry-prog.obj"	
8-12-IM-22-Kuts-explicit-no-entry-prog.exe
timeout 777