#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F430BXA   ºAutor  ³Felipe Alves        º Data ³  25/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F430BXA()
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
			
		aSE2 := {{"E2_FILIAL", SE2->E2_FILIAL , Nil}, ;
		  		{"E2_PREFIXO", "INS"          , Nil}, ;
				{"E2_NUM"    , SE2->E2_NUM    , Nil}, ;
				{"E2_PARCELA", "1"            , Nil}, ;
				{"E2_TIPO"   , "TX"           , Nil}, ;
				{"E2_NATUREZ", StrTran(GetMv("MV_INSS"),'"','')          , Nil}, ;
				{"E2_FORNECE", SubStr(GetMv("MV_FORINSS"), 1, TamSX3("A2_COD")[1]), Nil}, ;
				{"E2_EMISSAO", dDataBase      , Nil}, ;
				{"E2_VENCTO" , dVencto        , Nil}, ;
				{"E2_VENCREA", dVencto        , Nil}, ;
				{"E2_ORIGEM" , "F430BXA"      , Nil}, ;
				{"E2_VALOR"  , nValor         , Nil}, ;
				{"E2_XRECPAI", "SE2" + cValToChar(SE2->(Recno())), Nil}}
				
		MsExecAuto({|x,y,z| FINA050(x,y,z)}, aSE2, , 3)
		
		If (lMsErroAuto)
			MostraErro()
			DisarmTransaction()
			lRet := .F.
		Endif
		
		END TRANSACTION
	Endif
Endif

aEval(aArea, {|x| RestArea(x)})
Return(lRet)