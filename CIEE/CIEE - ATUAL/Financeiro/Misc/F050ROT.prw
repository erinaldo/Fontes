#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

User Function F050ROT()

Local aRotinaNew := {}

aRotinaNew	:= aClone(ParamIxb)

aadd(aRotinaNew,{OemToAnsi("Vis Amortiza��o"),"u_CFINA71()",0, 2})

Return(aRotinaNew)