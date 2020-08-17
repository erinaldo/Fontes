#INCLUDE "rwmake.ch"
                        
// Pesquisa e retorna codigo da conta bancaria do fornecedor
// Data: 14/04/2004.
User Function CNABCC()
                               
cCONTA	:=" "

IF !EMPTY(SE2->E2_CCFV)
	cCONTA:=STRZERO(VAL(STRTRAN(SE2->E2_CCFV,"-","")),12)
ELSE 
	cCONTA:=POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,STRZERO(VAL(STRTRAN(SA2->A2_NUMCON,"-","")),12))
EndIf

Return(cCONTA)