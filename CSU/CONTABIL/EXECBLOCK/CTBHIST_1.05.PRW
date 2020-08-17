#Include "PROTHEUS.Ch"


/*  Alterado - SEA - 07/04 - conta de depreciação
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBHIST_1.03ºAutor  ³Daniele           º Data ³  08/16/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Devolver o historico de acordo com os paramentros recebidos º±±
±±º          ³CTBHIST(lExpr1,cExpr2)                                      º±±
±±º          ³lExpr1 : Indica se função esta sendo chamada da rotina de   º±±
±±º          ³         calculo ou de descalculo							  º±±
±±º          ³cExpr2 : Indica se função esta sendo chamada do lancamento  º±±
±±º          ³         padronizado de amortização ou de depreciação       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTBHIST(_lCalc,_cParam)

// Declaracao das Variaveis
Local _aAreaCT1 := CT1->(GetArea())
Local _cHist	:=" "
Local dDataMov  := IIF(Upper(FUNNAME())=="U_RMANA01",Stod(StrZero(Year(dDataBase),4)+StrZero(nMes,2)+"01"),dDataBase)
Default _lCalc 	:=.t.
Default _cParam :="A"                 

CT1->(MsSeek(xFilial("CT1")+SN3->N3_CDEPREC))
If _cParam == 'A'  // Amortizacao
//SDM
	_cHist := If(_lCalc,"","DESCALC ")+"AMORTIZACAO MES" +" "+(SUBSTR(DTOC(dDataMov),4,5)+" - "+Alltrim(CT1->CT1_DESC01))
Else    // Depreciacao
	_cHist := If(_lCalc,"","DESCALC ")+"MES" +" "+(SUBSTR(DTOC(dDataMov),4,5)+" - "+Alltrim(CT1->CT1_DESC01))
EndIf

//RestArea(_aSDMeaCT1)
RestArea(_aAreaCT1)
Return (_cHist)