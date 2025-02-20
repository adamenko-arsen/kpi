set root=lab1

rem clear previous build

erase %root%\main.obj
erase %root%\main.exe

rem compile sources

tasm.exe /zi %root%\main.asm %root%\main.obj %root%\main.lst

rem link objects

tlink.exe /m /v %root%\main.obj
