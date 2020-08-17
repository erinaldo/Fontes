#include "protheus.ch"


User Function xVldTotDg()

Local aArea 	:= GetArea()
Local nQuant	:= ascan(aheader, {|x| alltrim(x[2])==Alltrim("D1_QUANT")})
Local nVunit	:= ascan(aheader, {|x| alltrim(x[2])==AllTrim("D1_VUNIT")})
Local nPosTot	:= aScan(aHeader, {|x| AllTrim(x[2])==AllTrim("D1_TOTAL")})
Local nXTotDig	:= M->D1_XTOTAL //GdFieldGet('D1_XTOTAL',n)
Local aRefer    := {}
Local lRetorno	:= .T.


//VALOR UNITARIO
aCols[N,nVunit] 	:= nXTotDig / aCols[n][nQuant]

//TRIGGER VALOR UNITARIO
If nVunit > 0
	aRefer := MaFisGetRF(aHeader[nVunit][6])
	If !Empty(aRefer[1])
		MaFisRef(aRefer[1],aRefer[2],aCols[N,nVunit])
	EndIf
Else
	lRetorno := .F.
EndIf


//VALOR TOTAL
aCols[N,nPosTot] 	:= aCols[n][nQuant] * aCols[N,nVunit]

//TRIGGER VALOR TOTAL
If nPosTot > 0
	aRefer := MaFisGetRF(aHeader[nPosTot][6])
	If !Empty(aRefer[1])
		MaFisRef(aRefer[1],aRefer[2],aCols[N,nPosTot])
	EndIf
Else
	lRetorno := .F.
EndIf

RestArea(aArea)

Return(lRetorno)