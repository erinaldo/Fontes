#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICOME06  ºAutor  ³Felipe Alves        º Data ³  25/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gerar o titulo de INSS Patronal                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FICOME06()
Local aArea := {GetArea(), SF1->(GetArea()), SD1->(GetArea()), SA2->(GetArea()), SE2->(GetArea())}
Local lRet := .T.
Local aSE2 := {}
Local cDia
Local cMes
Local cAno
Local dVencto
Local nValor := 0
Local nOpcao := ParamIXB[1]
Local nConfirma := ParamIXB[2]

Private lMsErroAuto := .F.

If (((nOpcao == 3) .or.(nOpcao == 4)).And. (nConfirma == 1)) //Opcao 3 (documento de entrada) - Opcao 4 (classificação de D.entrada)
	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))
	If (SA2->(DbSeek(xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA)))
		If (AllTrim(SA2->A2_XINSSP) == "1")
			BEGIN TRANSACTION
			
			DbSelectArea("SE2")
			SE2->(DbSetOrder(1))
			
			nValor := SF1->F1_VALBRUT * (SA2->A2_XPERCP / 100)
					
			cDia := SA2->A2_XVENCP
			cMes := Iif((Month(dDataBase)+1) > 12, "01", StrZero(Month(dDataBase)+1, 2))
			cAno := cValToChar(Iif((Month(dDataBase)+1) > 12, Year(dDataBase) + 1, Year(dDataBase)))
			dVencto := SToD(cAno + cMes + cDia)

			aSE2 := {{"E2_FILIAL", xFilial("SE2") , Nil}, ;
			  		{"E2_PREFIXO", "INS"          , Nil}, ;
					{"E2_NUM"    , SF1->F1_DOC    , Nil}, ;
					{"E2_PARCELA", "1"            , Nil}, ;
					{"E2_TIPO"   , "TX"           , Nil}, ;
					{"E2_NATUREZ", StrTran(GetMv("MV_INSS"),'"',''), Nil}, ;
					{"E2_FORNECE", SubStr(GetMv("MV_FORINSS"), 1, TamSX3("A2_COD")[1]), Nil}, ;
					{"E2_EMISSAO", dDataBase      , Nil}, ;
					{"E2_VENCTO" , dVencto        , Nil}, ;
					{"E2_VENCREA", dVencto        , Nil}, ;
					{"E2_ORIGEM" , "MT103FIM"     , Nil}, ;
					{"E2_XRECPAI", "SF1" + cValToChar(SF1->(Recno())), Nil}, ;
					{"E2_VALOR"  , nValor         , Nil}}
			
			MsExecAuto({|x,y,z| FINA050(x,y,z)}, aSE2, , 3)
			
			If (lMsErroAuto)
				MostraErro()
				DisarmTransaction()
				lRet := .F.
			Endif
			
			END TRANSACTION
		Endif
	Endif
Elseif ((nOpcao == 5) .And. (nConfirma == 1))
	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))
	If (SA2->(DbSeek(xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA)))
		If (AllTrim(SA2->A2_XINSSP) == "1")
			BEGIN TRANSACTION
			
			nValor := SF1->F1_VALBRUT * (SA2->A2_XPERCP / 100)
					
			cDia := SA2->A2_XVENCP
			cMes := Iif((Month(dDataBase)+1) > 12, "01", StrZero(Month(dDataBase)+1, 2))
			cAno := cValToChar(Iif((Month(dDataBase)+1) > 12, Year(dDataBase) + 1, Year(dDataBase)))
			dVencto := SToD(cAno + cMes + cDia)
			
			DbSelectArea("SE2")
			SE2->(DbSetOrder(1))

			If (SE2->(DbSeek( xFilial("SE2") + ;
							"INS" + ;
							AllTrim(SF1->F1_DOC) + ;
							Space(TamSX3("E2_NUM")[1] - Len(AllTrim(SF1->F1_DOC))) + ;
							SUBSTR("1  ",1,TamSX3("E2_PARCELA")[1]) + ;
							"TX " + ;
							SubStr(GetMv("MV_FORINSS"), 1, TamSX3("A2_COD")[1]))))

				aSE2 := {{"E2_FILIAL", SE2->E2_FILIAL  , Nil}, ;
				  		{"E2_PREFIXO", SE2->E2_PREFIXO , Nil}, ;
						{"E2_NUM"    , SE2->E2_NUM     , Nil}, ;
						{"E2_PARCELA", SE2->E2_PARCELA , Nil}, ;
						{"E2_TIPO"   , SE2->E2_TIPO    , Nil}, ;
						{"E2_FORNECE", SubStr(GetMv("MV_FORINSS"), 1, TamSX3("A2_COD")[1]) , Nil}}
	
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
Endif

aEval(aArea, {|x| RestArea(x)})
Return(lRet)