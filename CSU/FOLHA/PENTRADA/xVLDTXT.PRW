#INCLUDE "rwmake.ch"

User function Xvldtxt()
Local Lret:=.T.
Local Cbairro:= &(Readvar())

For I := 0 To 10
	
	If Alltrim(Str(I)) $ Cbairro
		Lret:=.F.
		MsgSTOP("Este campo dever� conter apenas letras, numero n�o ser� v�lido")
		Exit
	endif
	
Next I


Return Lret
