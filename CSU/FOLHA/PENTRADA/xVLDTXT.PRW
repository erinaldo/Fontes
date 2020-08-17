#INCLUDE "rwmake.ch"

User function Xvldtxt()
Local Lret:=.T.
Local Cbairro:= &(Readvar())

For I := 0 To 10
	
	If Alltrim(Str(I)) $ Cbairro
		Lret:=.F.
		MsgSTOP("Este campo deverá conter apenas letras, numero não será válido")
		Exit
	endif
	
Next I


Return Lret
