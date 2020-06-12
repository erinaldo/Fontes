#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA080OWN  ºAutor  ³Felipe Alves        º Data ³  25/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA080OWN()
Local aArea := {GetArea(), SF1->(GetArea()), SD1->(GetArea()), SA2->(GetArea()), SE2->(GetArea())}
Local lRet := .T.
Local aSE2 := {}
Local cDia
Local cMes
Local cAno
Local dVencto
Local nValor := 0

Private lMsErroAuto := .F.

DbSelectArea("SA2")
SA2->(DbSetOrder(1))
If (SA2->(DbSeek(xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA)))
	If (AllTrim(SA2->A2_XINSSP) == "2")
		BEGIN TRANSACTION
		
		//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		nValor := (SE2->E2_VALOR+SE2->(E2_VRETINS+E2_VRETIRF+E2_VRETISS+E2_VRETCOF+E2_VRETPIS+E2_VRETCSL)) * (SA2->A2_XPERCP / 100)
			
		cDia := SA2->A2_XVENCP
		cMes := Iif((Month(dDataBase)+1) > 12, "01", StrZero(Month(dDataBase)+1, 2))
		cAno := cValToChar(Iif((Month(dDataBase)+1) > 12, Year(dDataBase) + 1, Year(dDataBase)))
		dVencto := SToD(cAno + cMes + cDia)
		
		DbSelectArea("SE2")
		SE2->(DbSetOrder(1))
		
		If (SE2->(DbSeek( SE2->E2_FILIAL + "INS" + SE2->E2_NUM + SUBSTR("1  ",1,TamSX3("E2_PARCELA")[1]) + "TX " + SubStr(GetMv("MV_FORINSS"), 1, TamSX3("A2_COD")[1]) )))
			aSE2 := {{"E2_FILIAL", SE2->E2_FILIAL , Nil}, ;
			  		{"E2_PREFIXO", SE2->E2_PREFIXO, Nil}, ;
					{"E2_NUM"    , SE2->E2_NUM    , Nil}, ;
					{"E2_PARCELA", SE2->E2_PARCELA, Nil}, ;
					{"E2_TIPO"   , SE2->E2_TIPO   , Nil}, ;
					{"E2_FORNECE", SubStr(GetMv("MV_FORINSS"), 1, TamSX3("A2_COD")[1]), Nil}}
					
			MsExecAuto({|x,y,z| FINA050(x,y,z)}, aSE2, , 5)
			
			If (lMsErroAuto)
				MostraErro()
				DisarmTransaction()
				lRet := .F.
			Endif
		Endif
		
		END TRANSACTION
	Endif
Endif

aEval(aArea, {|x| RestArea(x)})
Return(lRet)