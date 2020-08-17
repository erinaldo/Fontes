#INCLUDE "rwmake.ch"
                        
// Pesquisa e retorna codigo da agencia bancaria do fornecedor
// Data: 14/04/2004.
User Function CNABAG()       

cAGENCIA	:=" "

IF !EMPTY(SE2->E2_AGENFV)
	cAGENCIA:=STRZERO(VAL(SE2->E2_AGENFV),5)
ELSE 
	cAGENCIA:=POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,STRZERO(VAL(SA2->A2_AGENCIA),5))
EndIf

Return(cAGENCIA)