set root=lab3

erase %root%\main.obj
erase %root%\main.exe

tasm.exe /m /zi %root%\main.asm %root%\main.obj %root%\main.lst

tlink.exe /m /v %root%\main.obj
