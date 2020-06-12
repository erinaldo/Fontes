#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RwMake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ 16/12/13 - Donizeti - Inclusใo de Filtro por Usuแrio x CC  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICDVA01()
Local lRet := .T.
Local aLegenda := {{"Z1_STATUS == 'E'", "BR_VERDE"},;
					{"Z1_STATUS == 'A'", "BR_AMARELO"},;
					{"Z1_STATUS == 'C'", "BR_AZUL"},;
					{"Z1_STATUS == 'U'", "BR_BRANCO"},;
					{"Z1_STATUS == 'S'", "BR_MARROM"},;
					{"Z1_STATUS == 'R'", "BR_PRETO"},;
					{"Z1_STATUS == 'Y'", "BR_PINK"},;
					{"Z1_STATUS == 'F'", "BR_VERMELHO"},;
					{"Z1_STATUS == 'Z'", "BR_VIOLETA"},;
					{"Z1_STATUS == 'W'", "BR_CANCEL"},;
					{"Z1_STATUS == 'T'", "PMSEDT3"},;
					{"Z1_STATUS == 'Q'", "PMSEDT4"},;
					{"Z1_STATUS == 'X'", "BR_LARANJA"}}
Private cString := "SZ1"
Private aRotina
Private cCadastro := "Solicita็ใo de Viagens"
Private aCores := {{"BR_VERDE"     , "Em Elabora็ใo"                            },;
					{"BR_CANCEL"   , "Solicita็ใo Cancelada"                    },;
					{"BR_AZUL"     , "Em Processo de Cota็ใo"                   },;
					{"BR_BRANCO"   , "Ag. Aprov. Solicitante"                   },;
					{"BR_MARROM"   , "Ag. Aprov. Final"                         },;
					{"BR_PINK"     , "Ag. Pedido de Compra"                     },;
					{"PMSEDT3"     , "Ag. Lib. Conting๊ncia"                    },;
					{"PMSEDT4"     , "Ag. Aprov. Al็ada"                        },;
					{"BR_VERMELHO" , "Pedido de Compra/ Ag. Presta็ใo de Contas"},;
					{"BR_LARANJA"  , "Ag. Aprov. Financeira"                    },;
					{"BR_VIOLETA"  , "Encerrada"                                }}
//
//16/12/13 - Donizeti - Inclusใo de Filtro por Usuแrio x CC

_aArea   := GetArea()
_cCentroC:= ""
			SZF->(dbSetOrder(1))
			SZF->(MsSeek(xFilial("SZF")+__cUserId))
			While SZF->(!Eof()) .and. SZF->(ZF_FILIAL+ZF_USERID) == XFilial("SZF")+(__cUserId)
				_cCentroC+=	alltrim(SZF->ZF_CUSTO) + "|"
				SZF->(DbSkip())
			Enddo
RestArea(_aArea)

Private cFiltro := "SZ1->Z1_SOLICIT $ '" + __cUserId + "' .Or. SZ1->Z1_APROV $ '" + __cUserId + " ' .or. ALLTRIM(SZ1->Z1_CCUSTO) $ '" + _cCentroC + "'"

////

Private aIndex := {}
Private bFiltraBrw := {}

&(cString)->(DbOrderNickName("FICDVT01"))

aRotina := {{"Pesquisar"             , "AxPesqui"                                  , 0, 1},;
			{"Visualizar"            , "U_FICDVINC(2)"                             , 0, 2},;
			{"Incluir"               , "U_FICDVINC(3)"                             , 0, 3},;
			{"Alterar"               , "U_FICDVINC(4)"                             , 0, 4},;
			{"Cancelar"              , "U_FICDVCAN(SZ1->Z1_FILIAL, SZ1->Z1_NUM)"   , 0, 5},;
			{"Env. Compras"          , "U_FICDVAPR(SZ1->Z1_FILIAL, SZ1->Z1_NUM)"   , 0, 6},;
			{"Incluir Cota็ใo"       , "U_FICDVCOT(3)"                             , 0, 6},;
			{"Analisar Solicita็ใo"  , "U_FICDVCOT(6)"                             , 0, 6},;
			{"Aprov. Final"          , "U_FICDVCOT(7)"                             , 0, 6},;
			{"Gerar Adiant./ Pedido" , "U_FICDVFIN"                                , 0, 6},;
			{"Inc. Prest. Contas"    , "U_FICDVPRS(3)"                             , 0, 6},;
			{"Aprov. Prest. Contas"  , "U_FICDVPRS(2)"                             , 0, 6},;
			{"Legendas"              , "U_FICDVLEG"                                , 0, 2}}
			
bFiltraBrw := {|| FilBrowse("SZ1", @aIndex, @cFiltro)}

Eval(bFiltraBrw)
			
mBrowse(06, 01, 22, 75, cString, , , , , , aLegenda)
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICDVFIN()
Local lRet := .T.

If !(SZ1->Z1_SOLICIT $ __cUserId)
	Aviso("Aviso", "Este usuแrio nใo possui permissใo para Gerar Adiantamento/ Pedido de Compras.", {"Ok"}, 1)
	lRet := .F.
Endif

If (lRet)
	If !(SZ1->Z1_STATUS $ "Y")
		Aviso("Aviso", "Esta SV nใo estแ disponํvel para finaliza็ใo.", {"Ok"}, 1)
		lRet := .F.
	Endif
	
	If (lRet)
		If (Aviso("Confirma็ใo", "Confirma a gera็ใo do Adiantamento/ Pedido de Compras?", {"Sim", "Nใo"}, 1) == 1)
			//MsgRun("Gerando Adiantamento/ Pedido de Compras. Aguarde...", "", {|| ConfSV()})
			ConfSV()
		Endif
	Endif
Endif

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณMicrosiga           บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ConfSV()
Local aArea := {GetArea(), SZ0->(GetArea()), SZ1->(GetArea()), SZ2->(GetArea()), SZ3->(GetArea()), SZ4->(GetArea()), SZ5->(GetArea()), SE2->(GetArea()), SC7->(GetArea()), SB2->(GetArea())}
Local lRet := .T.
Local cTipo := VerTipo(SZ1->Z1_FILIAL, SZ1->Z1_NUM)
Local aSE2 := {}
Local aCab := {}
Local aItens := {}
Local aLinha := {}
Local aRatCtb := {}
Local aRateio := {}
Local nItemRat := 0
Local cQuery := ""
Local cTab := ""
Local aFornece := {}
Local cFil := SZ1->Z1_FILIAL
Local cNum := SZ1->Z1_NUM
Local cItemCta := SZ1->Z1_ITEMCTA
Local cConta := SZ1->Z1_CONTA
Local cCCusto := SZ1->Z1_CCUSTO
Local cTpVg := SZ1->Z1_TIPO
Local nI := 0
Local nItem := 1
Local lSaldo := .T.
Local cNumPc := ""

Private lMsErroAuto := .F.

BEGIN TRANSACTION

If (lRet)	
	If (cTipo == "1")
		DbSelectArea("SZ0")
		SZ0->(DbSetOrder(1))
		SZ0->(DbSeek(xFilial("SZ0") + SZ1->Z1_NUM))
		
		If (SZ1->Z1_ADIANTA > 0)
			aSE2 := {{"E2_FILIAL", xFilial("SE2"), Nil},;
					{"E2_PREFIXO", GetMv("FI_PFXVIA"), Nil},;
					{"E2_NUM", SZ1->Z1_NUM, Nil},;
					{"E2_TIPO", GetMv("FI_TIPVIA"), Nil},;
					{"E2_NATUREZ", Iif(cTpVg == "1", GetMv("FI_NATVNAC"), GetMv("FI_NATVINT")), Nil},;
					{"E2_FORNECE", SZ1->Z1_CODVIAJ, Nil},;
					{"E2_LOJA", SZ1->Z1_LOJAVIA, Nil},;
					{"E2_EMISSAO", dDataBase, Nil},;
					{"E2_VENCTO", dDataBase, Nil},;
					{"E2_VENCREA", dDataBase, Nil},;
					{"E2_CONTAD", SZ1->Z1_CONTA, Nil},;
					{"E2_CCD", SZ1->Z1_CCUSTO, Nil},;
					{"E2_ITEMD", SZ1->Z1_ITEMCTA, Nil},;
					{"E2_VALOR", SZ1->Z1_ADIANTA, Nil},;
					{"E2_RATEIO", "S", Nil},;
					{"E2_XNUMSV", SZ1->Z1_NUM, Nil},;
					{"E2_ORIGEM", "FICDV01", Nil}}
					
			
			MsExecAuto({|x,y,z| FINA050(x,y,z)}, aSE2, , 3)
			
			If (lMsErroAuto)
				DisarmTransaction()
				MostraErro()
				lRet := .F.
			Endif
		Endif
		
		If (lRet)
			cQuery := "SELECT" + CRLF
			cQuery += "Z2_FORNECE AS FORNECE," + CRLF
			cQuery += "Z2_LOJA AS LOJA" + CRLF
			cQuery += "FROM " + RetSQLName("SZ2") + "" + CRLF
			cQuery += "WHERE Z2_FILIAL = '" + cFil + "'" + CRLF
			cQuery += "AND Z2_NUMSV = '" + cNum + "'" + CRLF
			cQuery += "AND Z2_ITEM NOT IN ('999')" + CRLF
			cQuery += "AND Z2_STATUS = 'A'" + CRLF
			cQuery += "AND D_E_L_E_T_ = ''" + CRLF
			cQuery += "UNION" + CRLF
			cQuery += "SELECT" + CRLF
			cQuery += "Z3_FORNECE AS FORNECE," + CRLF
			cQuery += "Z3_LOJA AS LOJA" + CRLF
			cQuery += "FROM " + RetSQLName("SZ3") + "" + CRLF
			cQuery += "WHERE Z3_FILIAL = '" + cFil + "'" + CRLF
			cQuery += "AND Z3_NUMSV = '" + cNum + "'" + CRLF
			cQuery += "AND Z3_ITEM NOT IN ('999')" + CRLF
			cQuery += "AND Z3_STATUS = 'A'" + CRLF
			cQuery += "AND D_E_L_E_T_ = ''" + CRLF
			cQuery += "UNION" + CRLF
			cQuery += "SELECT" + CRLF
			cQuery += "Z4_FORNECE AS FORNECE," + CRLF
			cQuery += "Z4_LOJA AS LOJA" + CRLF
			cQuery += "FROM " + RetSQLName("SZ4") + "" + CRLF
			cQuery += "WHERE Z4_FILIAL = '" + cFil + "'" + CRLF
			cQuery += "AND Z4_NUMSV = '" + cNum + "'" + CRLF
			cQuery += "AND Z4_ITEM NOT IN ('999')" + CRLF
			cQuery += "AND Z4_STATUS = 'A'" + CRLF
			cQuery += "AND D_E_L_E_T_ = ''" + CRLF
			cQuery += "ORDER BY FORNECE, LOJA"
			
			cQuery := ChangeQuery(cQuery)
			
			cTab := GetNextAlias()
			
			TcQUERY cQuery NEW ALIAS ((cTab))
			
			DbSelectArea((cTab))
			(cTab)->(DbGoTop())
			
			While ((cTab)->(!Eof()))
				aAdd(aFornece, {(cTab)->(FORNECE), (cTab)->(LOJA)})
			
				(cTab)->(DbSkip())
			Enddo
			
			(cTab)->(DbCloseArea())
			
			For nI := 1 To Len(aFornece)
				If (lRet)
					DbSelectArea("SC7")
					
					cNumPc := NextNumero("SC7", 1, "C7_NUM", .T.)
				
					aCab := {{"C7_FILIAL", cFil, Nil},;
							{"C7_NUM", cNumPc, Nil},;
							{"C7_EMISSAO", dDataBase, Nil},;
							{"C7_FORNECE", aFornece[nI][1], Nil},;
							{"C7_LOJA", aFornece[nI][2], Nil},;
							{"C7_COND", GetMv("FI_CNDVIA"), Nil},;
							{"C7_CONTATO", GetMv("FI_CNTVIA"), Nil},;
							{"C7_RATEIO", "1", Nil},;
							{"C7_GRUPCOM", GetMv("FI_GRPCOMV"), Nil},;
							{"C7_FILENT", cFil, Nil}}
							
					ConfirmSX8()
					
					nItem := 1
					
					cQuery := "SELECT" + CRLF
					cQuery += "Z2_ITEM AS ITEM," + CRLF
					cQuery += "Z2_PRODUTO AS PRODUTO," + CRLF
					cQuery += "Z2_VALOR AS VALOR" + CRLF
					cQuery += "FROM " + RetSQLName("SZ2") + "" + CRLF
					cQuery += "WHERE Z2_FILIAL = '" + cFil + "'" + CRLF
					cQuery += "AND Z2_NUMSV = '" + cNum + "'" + CRLF
					cQuery += "AND Z2_FORNECE = '" + aFornece[nI][1] + "'" + CRLF
					cQuery += "AND Z2_LOJA = '" + aFornece[nI][2] + "'" + CRLF
					cQuery += "AND Z2_ITEM NOT IN ('999')" + CRLF
					cQuery += "AND Z2_STATUS = 'A'" + CRLF
					cQuery += "AND D_E_L_E_T_ = ''" + CRLF
					cQuery += "UNION" + CRLF
					cQuery += "SELECT" + CRLF
					cQuery += "Z3_ITEM AS ITEM," + CRLF
					cQuery += "Z3_PRODUTO AS PRODUTO," + CRLF
					cQuery += "Z3_VALOR AS VALOR" + CRLF
					cQuery += "FROM " + RetSQLName("SZ3") + "" + CRLF
					cQuery += "WHERE Z3_FILIAL = '" + cFil + "'" + CRLF
					cQuery += "AND Z3_NUMSV = '" + cNum + "'" + CRLF
					cQuery += "AND Z3_FORNECE = '" + aFornece[nI][1] + "'" + CRLF
					cQuery += "AND Z3_LOJA = '" + aFornece[nI][2] + "'" + CRLF
					cQuery += "AND Z3_ITEM NOT IN ('999')" + CRLF
					cQuery += "AND Z3_STATUS = 'A'" + CRLF
					cQuery += "AND D_E_L_E_T_ = ''" + CRLF
					cQuery += "UNION" + CRLF
					cQuery += "SELECT" + CRLF
					cQuery += "Z4_ITEM AS ITEM," + CRLF
					cQuery += "Z4_PRODUTO AS PRODUTO," + CRLF
					cQuery += "Z4_VALOR AS VALOR" + CRLF
					cQuery += "FROM " + RetSQLName("SZ4") + "" + CRLF
					cQuery += "WHERE Z4_FILIAL = '" + cFil + "'" + CRLF
					cQuery += "AND Z4_NUMSV = '" + cNum + "'" + CRLF
					cQuery += "AND Z4_FORNECE = '" + aFornece[nI][1] + "'" + CRLF
					cQuery += "AND Z4_LOJA = '" + aFornece[nI][2] + "'" + CRLF
					cQuery += "AND Z4_ITEM NOT IN ('999')" + CRLF
					cQuery += "AND Z4_STATUS = 'A'" + CRLF
					cQuery += "AND D_E_L_E_T_ = ''" + CRLF
					cQuery += "ORDER BY PRODUTO, VALOR"
					
					cQuery := ChangeQuery(cQuery)
					
					cTab := GetNextAlias()
					
					TcQUERY cQuery NEW ALIAS ((cTab))
					
					DbSelectArea((cTab))
					(cTab)->(DbGoTop())
					
					aItens := {}
					
					While ((cTab)->(!Eof()))
						aLinha := {}
						
						aAdd(aLinha, {"C7_ITEM"   , StrZero(nItem, TamSX3("C7_ITEM")[1]), Nil})
						aAdd(aLinha, {"C7_PRODUTO", (cTab)->(PRODUTO), Nil})
						aAdd(aLinha, {"C7_QUANT"  , 1, Nil})
						aAdd(aLinha, {"C7_PRECO"  , (cTab)->(VALOR), Nil})
						aAdd(aLinha, {"C7_TOTAL"  , (cTab)->(VALOR), Nil})
						/*aAdd(aLinha, {"C7_ITEMCTA", cItemCta, Nil})
						aAdd(aLinha, {"C7_CONTA"  , Posicione("SB1", 1, cFil + (cTab)->(PRODUTO), "B1_CONTA"), Nil})
						aAdd(aLinha, {"C7_CC"     , cCCusto, Nil})*/
						aAdd(aLinha, {"C7_GRUPCOM", GetMv("FI_GRPCOMV"), Nil})
						aAdd(aLinha, {"C7_RATEIO" , "1", Nil})
						aAdd(aLinha, {"C7_ORIGEM" , "FICDV01", Nil})
						aAdd(aLinha, {"C7_XNUMSV" , cNum, Nil})
						
						aAdd(aItens, aLinha)
						//aAdd(aRateio, aLinha)
						
						DbSelectArea("SZ0")
						SZ0->(DbSetOrder(1))
						If (SZ0->(DbSeek(xFilial("SZ0") + cNum)))
							nItemRat := 1
							//aRatCtb := {}
							
							While ((SZ0->(!Eof())) .And. (xFilial("SZ0") == SZ0->Z0_FILIAL) .And. (cNum == SZ0->Z0_NUMSV))
								//aLinha := {}
								
								RecLock("SCH", .T.)
								SCH->CH_FILIAL := xFilial("SCH")
								SCH->CH_PEDIDO := cNumPc
								SCH->CH_FORNECE := aFornece[nI][1]
								SCH->CH_LOJA := aFornece[nI][2]
								SCH->CH_ITEMPD := StrZero(nItem, TamSX3("C7_ITEM")[1])
								SCH->CH_ITEM := StrZero(nItemRat, TamSX3("CH_ITEM")[1])
								SCH->CH_PERC := SZ0->Z0_PERC
								SCH->CH_CC := SZ0->Z0_CCUSTO
								SCH->CH_CONTA := SZ0->Z0_CONTA
								SCH->CH_ITEMCTA := SZ0->Z0_ITEMCTA
								SCH->CH_CLVL := ""
								SCH->(MsUnlock())
								
								
								/*aAdd(aLinha, {"CH_PEDIDO", cNumPc, Nil})
								aAdd(aLinha, {"CH_FORNECE", aFornece[nI][1], Nil})
								aAdd(aLinha, {"CH_LOJA", aFornece[nI][2], Nil})
								aAdd(aLinha, {"CH_ITEMPD", StrZero(nItem, TamSX3("C7_ITEM")[1]), Nil})
								aAdd(aLinha, {"CH_ITEM", StrZero(nItemRat, TamSX3("CH_ITEM")[1]), Nil})
								aAdd(aLinha, {"CH_PERC", SZ0->Z0_PERC, Nil})
								aAdd(aLinha, {"CH_CC", SZ0->Z0_CCUSTO, Nil})
								aAdd(aLinha, {"CH_CONTA", SZ0->Z0_CONTA, Nil})
								aAdd(aLinha, {"CH_ITEMCTA", SZ0->Z0_ITEMCTA, Nil})
								aAdd(aLinha, {"CH_CLVL", "", Nil})
								
								aAdd(aRatCtb, aLinha)*/
								
								//aAdd(aRateio[nItem], aLinha)
								
								nItemRat++
								
								SZ0->(DbSkip())
							Enddo
							
							aAdd(aRateio, {StrZero(nItemRat, TamSX3("CH_ITEM")[1]), aRatCtb})
							
						Endif
						
						nItem++
			
						(cTab)->(DbSkip())
					Enddo
					
					(cTab)->(DbCloseArea())
					
					MsExecAuto({|v,x,y,z| MATA120(v,x,y,z)}, 1, aCab, aItens, 3)
					
					If (lMsErroAuto)
						DisarmTransaction()
						MostraErro()
						lRet := .F.
					Else
						RecLock("SC7", .F.)
						SC7->C7_ITEMCTA := ""
						SC7->C7_CONTA := ""
						SC7->C7_CC := ""
						SC7->(MsUnlock())
					Endif
				Endif
			Next nI
		Endif
	Else
		If (SZ1->Z1_ADIANTA > 0)
			aSE2 := {{"E2_FILIAL", xFilial("SE2"), Nil},;
					{"E2_PREFIXO", GetMv("FI_PFXVIA"), Nil},;
					{"E2_NUM", SZ1->Z1_NUM, Nil},;
					{"E2_TIPO", GetMv("FI_TIPVIA"), Nil},;
					{"E2_NATUREZ", Iif(cTpVg == "1", GetMv("FI_NATVNAC"), GetMv("FI_NATVINT")), Nil},;
					{"E2_FORNECE", SZ1->Z1_CODVIAJ, Nil},;
					{"E2_LOJA", SZ1->Z1_LOJAVIA, Nil},;
					{"E2_EMISSAO", dDataBase, Nil},;
					{"E2_VENCTO", dDataBase, Nil},;
					{"E2_VENCREA", dDataBase, Nil},;
					{"E2_CONTAD", SZ1->Z1_CONTA, Nil},;
					{"E2_CCD", SZ1->Z1_CCUSTO, Nil},;
					{"E2_ITEMD", SZ1->Z1_ITEMCTA, Nil},;
					{"E2_VALOR", SZ1->Z1_ADIANTA, Nil},;
					{"E2_RATEIO", "S", Nil},;
					{"E2_XNUMSV", SZ1->Z1_NUM, Nil},;
					{"E2_ORIGEM", "FICDV01", Nil}}
					
			
			MsExecAuto({|x,y,z| FINA050(x,y,z)}, aSE2, , 3)
			//FINA050(aSE2, , 3)
			
			If (lMsErroAuto)
				DisarmTransaction()
				MostraErro()
				lRet := .F.
			Endif
		Endif
		
		If (lRet)
			cQuery := "SELECT" + CRLF
			cQuery += "Z2_FORNECE AS FORNECE," + CRLF
			cQuery += "Z2_LOJA AS LOJA" + CRLF
			cQuery += "FROM " + RetSQLName("SZ2") + "" + CRLF
			cQuery += "WHERE Z2_FILIAL = '" + cFil + "'" + CRLF
			cQuery += "AND Z2_NUMSV = '" + cNum + "'" + CRLF
			cQuery += "AND Z2_ITEM IN ('999')" + CRLF
			cQuery += "AND Z2_STATUS = 'A'" + CRLF
			cQuery += "AND D_E_L_E_T_ = ''" + CRLF
			cQuery += "UNION" + CRLF
			cQuery += "SELECT" + CRLF
			cQuery += "Z3_FORNECE AS FORNECE," + CRLF
			cQuery += "Z3_LOJA AS LOJA" + CRLF
			cQuery += "FROM " + RetSQLName("SZ3") + "" + CRLF
			cQuery += "WHERE Z3_FILIAL = '" + cFil + "'" + CRLF
			cQuery += "AND Z3_NUMSV = '" + cNum + "'" + CRLF
			cQuery += "AND Z3_ITEM IN ('999')" + CRLF
			cQuery += "AND Z3_STATUS = 'A'" + CRLF
			cQuery += "AND D_E_L_E_T_ = ''" + CRLF
			cQuery += "UNION" + CRLF
			cQuery += "SELECT" + CRLF
			cQuery += "Z4_FORNECE AS FORNECE," + CRLF
			cQuery += "Z4_LOJA AS LOJA" + CRLF
			cQuery += "FROM " + RetSQLName("SZ4") + "" + CRLF
			cQuery += "WHERE Z4_FILIAL = '" + cFil + "'" + CRLF
			cQuery += "AND Z4_NUMSV = '" + cNum + "'" + CRLF
			cQuery += "AND Z4_ITEM IN ('999')" + CRLF
			cQuery += "AND Z4_STATUS = 'A'" + CRLF
			cQuery += "AND D_E_L_E_T_ = ''" + CRLF
			cQuery += "ORDER BY FORNECE, LOJA"
			
			cQuery := ChangeQuery(cQuery)
			
			cTab := GetNextAlias()
			
			TcQUERY cQuery NEW ALIAS ((cTab))
			
			DbSelectArea((cTab))
			(cTab)->(DbGoTop())
			
			While ((cTab)->(!Eof()))
				aAdd(aFornece, {(cTab)->(FORNECE), (cTab)->(LOJA)})
			
				(cTab)->(DbSkip())
			Enddo
			
			(cTab)->(DbCloseArea())
			
			For nI := 1 To Len(aFornece)
				If (lRet)
					DbSelectArea("SC7")
					
					cNumPc := NextNumero("SC7", 1, "C7_NUM", .T.)
					
					aCab := {{"C7_FILIAL", cFil, Nil},;
							{"C7_NUM", cNumPc, Nil},;
							{"C7_EMISSAO", dDataBase, Nil},;
							{"C7_FORNECE", aFornece[nI][1], Nil},;
							{"C7_LOJA", aFornece[nI][2], Nil},;
							{"C7_COND", GetMv("FI_CNDVIA"), Nil},;
							{"C7_CONTATO", GetMv("FI_CNTVIA"), Nil},;
							{"C7_RATEIO", "1", Nil},;
							{"C7_GRUPCOM", GetMv("FI_GRPCOMV"), Nil},;
							{"C7_FILENT", cFil, Nil}}
					
					nItem := 1
					
					cQuery := "SELECT" + CRLF
					cQuery += "Z2_ITEM AS ITEM," + CRLF
					cQuery += "Z2_PRODUTO AS PRODUTO," + CRLF
					cQuery += "Z2_VALOR AS VALOR" + CRLF
					cQuery += "FROM " + RetSQLName("SZ2") + "" + CRLF
					cQuery += "WHERE Z2_FILIAL = '" + cFil + "'" + CRLF
					cQuery += "AND Z2_NUMSV = '" + cNum + "'" + CRLF
					cQuery += "AND Z2_FORNECE = '" + aFornece[nI][1] + "'" + CRLF
					cQuery += "AND Z2_LOJA = '" + aFornece[nI][2] + "'" + CRLF
					cQuery += "AND Z2_ITEM IN ('999')" + CRLF
					cQuery += "AND Z2_STATUS = 'A'" + CRLF
					cQuery += "AND D_E_L_E_T_ = ''" + CRLF
					cQuery += "UNION" + CRLF
					cQuery += "SELECT" + CRLF
					cQuery += "Z3_ITEM AS ITEM," + CRLF
					cQuery += "Z3_PRODUTO AS PRODUTO," + CRLF
					cQuery += "Z3_VALOR AS VALOR" + CRLF
					cQuery += "FROM " + RetSQLName("SZ3") + "" + CRLF
					cQuery += "WHERE Z3_FILIAL = '" + cFil + "'" + CRLF
					cQuery += "AND Z3_NUMSV = '" + cNum + "'" + CRLF
					cQuery += "AND Z3_FORNECE = '" + aFornece[nI][1] + "'" + CRLF
					cQuery += "AND Z3_LOJA = '" + aFornece[nI][2] + "'" + CRLF
					cQuery += "AND Z3_ITEM IN ('999')" + CRLF
					cQuery += "AND Z3_STATUS = 'A'" + CRLF
					cQuery += "AND D_E_L_E_T_ = ''" + CRLF
					cQuery += "UNION" + CRLF
					cQuery += "SELECT" + CRLF
					cQuery += "Z4_ITEM AS ITEM," + CRLF
					cQuery += "Z4_PRODUTO AS PRODUTO," + CRLF
					cQuery += "Z4_VALOR AS VALOR" + CRLF
					cQuery += "FROM " + RetSQLName("SZ4") + "" + CRLF
					cQuery += "WHERE Z4_FILIAL = '" + cFil + "'" + CRLF
					cQuery += "AND Z4_NUMSV = '" + cNum + "'" + CRLF
					cQuery += "AND Z4_FORNECE = '" + aFornece[nI][1] + "'" + CRLF
					cQuery += "AND Z4_LOJA = '" + aFornece[nI][2] + "'" + CRLF
					cQuery += "AND Z4_ITEM IN ('999')" + CRLF
					cQuery += "AND Z4_STATUS = 'A'" + CRLF
					cQuery += "AND D_E_L_E_T_ = ''" + CRLF
					cQuery += "ORDER BY PRODUTO, VALOR"
					
					cQuery := ChangeQuery(cQuery)
					
					cTab := GetNextAlias()
					
					TcQUERY cQuery NEW ALIAS ((cTab))
					
					DbSelectArea((cTab))
					(cTab)->(DbGoTop())
					
					aItens := {}
					
					While ((cTab)->(!Eof()))
						aLinha := {}
						
						aAdd(aLinha, {"C7_ITEM"   , StrZero(nItem, TamSX3("C7_ITEM")[1]), Nil})
						aAdd(aLinha, {"C7_PRODUTO", (cTab)->(PRODUTO), Nil})
						aAdd(aLinha, {"C7_QUANT"  , 1, Nil})
						aAdd(aLinha, {"C7_PRECO"  , (cTab)->(VALOR), Nil})
						aAdd(aLinha, {"C7_TOTAL"  , (cTab)->(VALOR), Nil})
						/*aAdd(aLinha, {"C7_ITEMCTA", cItemCta, Nil})
						aAdd(aLinha, {"C7_CONTA"  , Posicione("SB1", 1, cFil + (cTab)->(PRODUTO), "B1_CONTA"), Nil})
						aAdd(aLinha, {"C7_CC"     , cCCusto, Nil})*/
						aAdd(aLinha, {"C7_GRUPCOM", GetMv("FI_GRPCOMV"), Nil})
						aAdd(aLinha, {"C7_RATEIO" , "1", Nil})
						aAdd(aLinha, {"C7_ORIGEM" , "FICDV01", Nil})
						aAdd(aLinha, {"C7_XNUMSV" , cNum, Nil})
						
						aAdd(aItens, aLinha)
						
						DbSelectArea("SZ0")
						SZ0->(DbSetOrder(1))
						If (SZ0->(DbSeek(xFilial("SZ0") + cNum)))
							nItemRat := 1
							
							While ((SZ0->(!Eof())) .And. (xFilial("SZ0") == SZ0->Z0_FILIAL) .And. (cNum == SZ0->Z0_NUMSV))
								//aLinha := {}
								
								RecLock("SCH", .T.)
								SCH->CH_FILIAL := xFilial("SCH")
								SCH->CH_PEDIDO := cNumPc
								SCH->CH_FORNECE := aFornece[nI][1]
								SCH->CH_LOJA := aFornece[nI][2]
								SCH->CH_ITEMPD := StrZero(nItem, TamSX3("C7_ITEM")[1])
								SCH->CH_ITEM := StrZero(nItemRat, TamSX3("CH_ITEM")[1])
								SCH->CH_PERC := SZ0->Z0_PERC
								SCH->CH_CC := SZ0->Z0_CCUSTO
								SCH->CH_CONTA := SZ0->Z0_CONTA
								SCH->CH_ITEMCTA := SZ0->Z0_ITEMCTA
								SCH->CH_CLVL := ""
								SCH->(MsUnlock())
								
								/*aAdd(aLinha, {"CH_PEDIDO", cNumPc, Nil})
								aAdd(aLinha, {"CH_FORNECE", aFornece[nI][1], Nil})
								aAdd(aLinha, {"CH_LOJA", aFornece[nI][2], Nil})
								aAdd(aLinha, {"CH_ITEMPD", StrZero(nItem, TamSX3("C7_ITEM")[1]), Nil})
								aAdd(aLinha, {"CH_ITEM", StrZero(nItemRat, TamSX3("CH_ITEM")[1]), Nil})
								aAdd(aLinha, {"CH_PERC", SZ0->Z0_PERC, Nil})
								aAdd(aLinha, {"CH_CC", SZ0->Z0_CCUSTO, Nil})
								aAdd(aLinha, {"CH_CONTA", SZ0->Z0_CONTA, Nil})
								aAdd(aLinha, {"CH_ITEMCTA", SZ0->Z0_ITEMCTA, Nil})
								aAdd(aLinha, {"CH_CLVL", "", Nil})
								
								aAdd(aRatCtb, aLinha)*/
								
								nItemRat++
								
								SZ0->(DbSkip())
							Enddo
							
						Endif
						
						nItem++
			
						(cTab)->(DbSkip())
					Enddo
					
					(cTab)->(DbCloseArea())
					
					MsExecAuto({|v,x,y,z| MATA120(v,x,y,z)}, 1, aCab, aItens, 3)
					
					If (lMsErroAuto)
						DisarmTransaction()
						MostraErro()
						lRet := .F.
					Endif
					
					ConfirmSX8()
				Endif
			Next nI
		Endif
	Endif
	
	If (lRet)
		DbSelectArea("SZ1")
		SZ1->(DbSetOrder(1))
		If (SZ1->(DbSeek(cFil + cNum)))
			RecLock("SZ1", .F.)
			SZ1->Z1_STATUS := "F"
			SZ1->(MsUnlock())
		Endif
		Aviso("Confirma็ใo", "Solicita็ใo finalizada com sucesso.", {"Ok"}, 1)
	Endif
Endif

END TRANSACTION

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณMicrosiga           บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICDVCOT(nOpc)
Local lRet := .T.
Local oDlg
Local oGet
Local cGet
Local aGet := {"1=Por Itens", "2=Por Total"}
Local aButtons := {}

If (nOpc != 7)
	If !(SZ1->Z1_SOLICIT $ __cUserId)
		Aviso("Aviso", "Este usuแrio nใo possui permissใo para Incluir/ Analisar Cota็ใo.", {"Ok"}, 1)
		lRet := .F.
	Endif
Endif

If (lRet)
	aAdd(aButtons, {"Filtro", {|| MsDocument("SZ1", SZ1->(Recno()), 3)}, "Conhecimento"})

	If (cValToChar(nOpc) $ "67")
		If (nOpc == 6)
			If !(SZ1->Z1_STATUS $ "U")
				Aviso("Aviso", "Esta SV nใo estแ em processo de Anแlise de Cota็ใo/ Pedido.", {"Ok"}, 1)
				lRet := .F.
			Endif
		Elseif (nOpc == 7)
			If !(SZ1->Z1_STATUS $ "S")
				Aviso("Aviso", "Esta SV nใo estแ em processo de Aprova็ใo Final.", {"Ok"}, 1)
				lRet := .F.
			Endif
		Endif
	
		If (lRet)
			cGet := VerTipo(SZ1->Z1_FILIAL, SZ1->Z1_NUM)
		
			lRet := FICDVCO2(cGet, SZ1->Z1_STATUS)
		Endif
	Else
		If !(SZ1->Z1_STATUS $ "C")
			Aviso("Aviso", "Esta SV nใo estแ em processo de Cota็ใo/ Pedido.", {"Ok"}, 1)
			lRet := .F.
		Endif
		
		If (lRet)
			Define MsDialog oDlg Title "Inclui Cota็ใo de SV" From 3, 0 To 145, 530 Pixel
		
			@ 005, 005 Say "Esta rotina tem o objetivo de listar os itens aprovados de Solicita็๕es de Viagens para Inclusใo de Cota็ใo." Of oDlg Pixel
							
			@ 025, 005 Say "Selecione a op็ใo de inclusใo:" Of oDlg Pixel
			@ 035, 005 MsComboBox oGet Var cGet ITEMS aGet Size 80, 10 Of oDlg Pixel

			Activate MsDialog oDlg Center On Init (EnchoiceBar(oDlg, {|| lRet := FICDVCO2(cGet, SZ1->Z1_STATUS), oDlg:End()}, {|| oDlg:End()}, , @aButtons))
		Endif
	Endif
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerTipo(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea()), SZ2->(GetArea()), SZ3->(GetArea()), SZ4->(GetArea())}
Local cGet := ""

DbSelectArea("SZ2")
SZ2->(DbSetOrder(1))
If (SZ2->(DbSeek(cFil + cNum)))
	While (SZ2->(!Eof()) .And. (SZ2->Z2_STATUS $ "A"))
		cGet := Iif(SZ2->Z2_TIPOCOT == "I", "1", "2")
	
		SZ2->(DbSkip())
	Enddo
Endif

DbSelectArea("SZ3")
SZ3->(DbSetOrder(1))
If (SZ3->(DbSeek(cFil + cNum)))
	While (SZ3->(!Eof()) .And. (SZ3->Z3_STATUS $ "A"))
		cGet := Iif(SZ3->Z3_TIPOCOT == "I", "1", "2")
	
		SZ3->(DbSkip())
	Enddo
Endif

DbSelectArea("SZ4")
SZ4->(DbSetOrder(1))
If (SZ4->(DbSeek(cFil + cNum)) .And. (SZ4->Z4_STATUS $ "A"))
	While (SZ4->(!Eof()))
		cGet := Iif(SZ4->Z4_TIPOCOT == "I", "1", "2")
	
		SZ4->(DbSkip())
	Enddo
Endif

aEval(aArea, {|x| RestArea(x)})
Return(cGet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณMicrosiga           บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FICDVCO2(nOpc, cTipo)
Local aArea := {GetArea()}
Local lRet := .T.
Local aSize := MsAdvSize()
Local aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 3, 3}
Local aObjects := {{100,040,.T.,.T.}, {100,120,.T.,.T.}}
Local aPosObj := MsObjSize(aInfo, aObjects)
Local cNoCpos := "Z2_NUMSV;Z3_NUMSV;Z4_NUMSV;Z5_NUMSV;Z2_STATUS;Z3_STATUS;Z4_STATUS;Z5_STATUS;Z2_TIPOCOT;Z3_TIPOCOT;Z4_TIPOCOT"
Local oDlg
Local aButtons := {}
Local aFolder := {"Passagem", "Hotel", "Veํculo"}
Local oDadosPass
Local oDadosHot
Local oDadosVei
Local aAux := {}
Local nAux := 0
Local aHeadPass := {}
Local aHeadHot := {}
Local aHeadVei := {}
Local aColsPass := retCotPass(nOpc, SZ1->Z1_FILIAL, SZ1->Z1_NUM, cTipo)
Local aColsHot := retCotHot(nOpc, SZ1->Z1_FILIAL, SZ1->Z1_NUM, cTipo)
Local aColsVei := retCotVei(nOpc, SZ1->Z1_FILIAL, SZ1->Z1_NUM, cTipo)
Local aAltPass := {}
Local aAltHot := {}
Local aAltVei := {}
Local lContinua := .T.

Private oFolder

aAdd(aButtons, {"Filtro", {|| MsDocument("SZ1", SZ1->(Recno()), 3)}, "Conhecimento"})

If (cTipo $ "S")
//	cSuperior := Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_XSUPVIA")
	cSuperior := SZ1->Z1_APROV
	
	If (cSuperior != __cUserId)
		Aviso("Aviso", "Usuแrio nใo pode realizar aprova็ใo desta SV.", {"Ok"}, 1)
		Return(.F.)
	Endif
	aAdd(aButtons, {"FILTRO", {|| RejeiSol(SZ1->Z1_FILIAL, SZ1->Z1_NUM), oDlg:End()}, "Rejeitar"})
Endif

//ฺฤฤฤฤฤฤฤฤฤฟ
//ณPassagensณ
//ภฤฤฤฤฤฤฤฤฤู

SX3->(DbSetOrder(1))
SX3->(DbSeek("SZ2"))
While ((SX3->(!Eof())) .And. (SX3->X3_ARQUIVO == "SZ2"))
	If ((X3USO(SX3->X3_USADO)) .And. (cNivel >= SX3->X3_NIVEL) .And. !(AllTrim(SX3->X3_CAMPO) $ cNoCpos))
		aAdd(aHeadPass,	{TRIM(SX3->X3_TITULO)	,;
						SX3->X3_CAMPO			,;
						SX3->X3_PICTURE			,;
						SX3->X3_TAMANHO			,;
						SX3->X3_DECIMAL			,;
						SX3->X3_VALID			,;
						SX3->X3_USADO			,;
						SX3->X3_TIPO			,;
						SX3->X3_F3				,;
						SX3->X3_CONTEXT			,;
						SX3->X3_CBOX			,;
						SX3->X3_RELACAO			,;
						SX3->X3_WHEN			,;
						SX3->X3_VISUAL			,;
						SX3->X3_VLDUSER			,;
						SX3->X3_PICTVAR			,;
						SX3->X3_OBRIGAT			})
	Endif
	
	SX3->(DbSkip())
Enddo

//ฺฤฤฤฤฤฤฟ
//ณHot้isณ
//ภฤฤฤฤฤฤู

SX3->(DbSetOrder(1))
SX3->(DbSeek("SZ3"))
While ((SX3->(!Eof())) .And. (SX3->X3_ARQUIVO == "SZ3"))
	If ((X3USO(SX3->X3_USADO)) .And. (cNivel >= SX3->X3_NIVEL) .And. !(AllTrim(SX3->X3_CAMPO) $ cNoCpos))
		aAdd(aHeadHot,	{TRIM(SX3->X3_TITULO)	,;
						SX3->X3_CAMPO			,;
						SX3->X3_PICTURE			,;
						SX3->X3_TAMANHO			,;
						SX3->X3_DECIMAL			,;
						SX3->X3_VALID			,;
						SX3->X3_USADO			,;
						SX3->X3_TIPO			,;
						SX3->X3_F3				,;
						SX3->X3_CONTEXT			,;
						SX3->X3_CBOX			,;
						SX3->X3_RELACAO			,;
						SX3->X3_WHEN			,;
						SX3->X3_VISUAL			,;
						SX3->X3_VLDUSER			,;
						SX3->X3_PICTVAR			,;
						SX3->X3_OBRIGAT			})
	Endif
	
	SX3->(DbSkip())
Enddo

//ฺฤฤฤฤฤฤฤฤฟ
//ณVeํculosณ
//ภฤฤฤฤฤฤฤฤู

SX3->(DbSetOrder(1))
SX3->(DbSeek("SZ4"))
While ((SX3->(!Eof())) .And. (SX3->X3_ARQUIVO == "SZ4"))
	If ((X3USO(SX3->X3_USADO)) .And. (cNivel >= SX3->X3_NIVEL) .And. !(AllTrim(SX3->X3_CAMPO) $ cNoCpos))
		aAdd(aHeadVei,	{TRIM(SX3->X3_TITULO)	,;
						SX3->X3_CAMPO			,;
						SX3->X3_PICTURE			,;
						SX3->X3_TAMANHO			,;
						SX3->X3_DECIMAL			,;
						SX3->X3_VALID			,;
						SX3->X3_USADO			,;
						SX3->X3_TIPO			,;
						SX3->X3_F3				,;
						SX3->X3_CONTEXT			,;
						SX3->X3_CBOX			,;
						SX3->X3_RELACAO			,;
						SX3->X3_WHEN			,;
						SX3->X3_VISUAL			,;
						SX3->X3_VLDUSER			,;
						SX3->X3_PICTVAR			,;
						SX3->X3_OBRIGAT			})
	Endif
	
	SX3->(DbSkip())
Enddo

Define MsDialog oDlg Title "Atualiza็ใo de Cota็ใo de Solicita็ใo de Viagens" From 3, 0 To 500, 960 Pixel

oFolder := TFolder():New(aPosObj[2,2], aPosObj[2,2], aFolder, {}, oDlg, 1, , , .T., .F., 475, 235, )

If !(cTipo $ "S")
	aAdd(aAltPass, "Z2_PRODUTO")
	aAdd(aAltPass, "Z2_DATA")
	aAdd(aAltPass, "Z2_HORA")
	aAdd(aAltPass, "Z2_DATACH")
	aAdd(aAltPass, "Z2_HORACH")
	aAdd(aAltPass, "Z2_CLASSE")
	aAdd(aAltPass, "Z2_TICKET")
	aAdd(aAltPass, "Z2_VOO")
	aAdd(aAltPass, "Z2_COMPANH")
	aAdd(aAltPass, "Z2_LOCALIZ")
	aAdd(aAltPass, "Z2_FORNECE")
	aAdd(aAltPass, "Z2_VALOR")
	If (nOpc == "2")
		aAdd(aAltPass, "Z2_TRECHO")
	Endif
Endif

oDadosPass := MsNewGetDados():New(0, 0, 220, 473, GD_UPDATE, ;
								"AllwaysTrue()", "AllwaysTrue()", "", aAltPass, , 0, "AllwaysTrue()", , , oFolder:aDialogs[1], aHeadPass, aColsPass)
oDadosPass:oBrowse:bGotFocus := {|| Fd_Entra(1)}
oDadosPass:oBrowse:bLostFocus := {|| Fd_Sai(1)}
oDadosPass:oBrowse:Default()
oDadosPass:oBrowse:Refresh()
If (Len(aColsPass) == 0)
	oDadosPass:Disable()
Endif
oFolder:aDialogs[1]:Refresh()

If !(cTipo $ "S")
	aAdd(aAltHot, "Z3_PRODUTO")
	aAdd(aAltHot, "Z3_FORNECE")
	aAdd(aAltHot, "Z3_DIARIAS")
	aAdd(aAltHot, "Z3_CHECKIN")
	aAdd(aAltHot, "Z3_CHECKOU")
	aAdd(aAltHot, "Z3_OBS")
	aAdd(aAltHot, "Z3_CONFIRM")
	aAdd(aAltHot, "Z3_VALOR")
	If (nOpc == "2")
		aAdd(aAltHot, "Z3_DESCRI")
	Endif
Endif

oDadosHot := MsNewGetDados():New(0, 0, 220, 473, GD_UPDATE, ;
								"AllwaysTrue()", "AllwaysTrue()", "", aAltHot, , 0, "AllwaysTrue()", , , oFolder:aDialogs[2], aHeadHot, aColsHot)
oDadosHot:oBrowse:bGotFocus := {|| Fd_Entra(2)}
oDadosHot:oBrowse:bLostFocus := {|| Fd_Sai(2)}
oDadosHot:oBrowse:Default()
oDadosHot:oBrowse:Refresh()
If (Len(aColsHot) == 0)
	oDadosHot:Disable()
Endif
oFolder:aDialogs[2]:Refresh()

If !(cTipo $ "S")
	aAdd(aAltVei, "Z4_PRODUTO")
	aAdd(aAltVei, "Z4_FORNECE")
	aAdd(aAltVei, "Z4_RETIRA")
	aAdd(aAltVei, "Z4_HORARET")
	aAdd(aAltVei, "Z4_DEVOLU")
	aAdd(aAltVei, "Z4_HORADEV")
	aAdd(aAltVei, "Z4_CONFIRM")
	aAdd(aAltVei, "Z4_VALOR")
	If (nOpc == "2")
		aAdd(aAltVei, "Z4_DESCRI")
	Endif
Endif

oDadosVei := MsNewGetDados():New(0, 0, 220, 473, GD_UPDATE, ;
								"AllwaysTrue()", "AllwaysTrue()", "", aAltVei, , 0, "AllwaysTrue()", , , oFolder:aDialogs[3], aHeadVei, aColsVei)
oDadosVei:oBrowse:bGotFocus := {|| Fd_Entra(3)}
oDadosVei:oBrowse:bLostFocus := {|| Fd_Sai(3)}
oDadosVei:oBrowse:Default()
oDadosVei:oBrowse:Refresh()
If (Len(aColsVei) == 0)
	oDadosVei:Disable()
Endif
oFolder:aDialogs[3]:Refresh()

//Activate MsDialog oDlg Center On Init (EnchoiceBar(oDlg, {|| MsgRun("Atualizando informa็๕es, aguarde...", "Solicita็๕es de Viagens", {|| CursorWait(), lRet := Iif(cTipo == "S", AprovSol(SZ1->Z1_FILIAL, SZ1->Z1_NUM), FICDVGRC(SZ1->Z1_FILIAL, SZ1->Z1_NUM, oDadosPass:aCols, oDadosHot:aCols, oDadosVei:aCols, nOpc, cTipo)), CursorArrow(), oDlg:End()})}, {|| lRet := .F., oDlg:End()}, , @aButtons))
Activate MsDialog oDlg Center On Init (EnchoiceBar(oDlg, {|| MsgRun("Atualizando informa็๕es, aguarde...", "Solicita็๕es de Viagens", {|| CursorWait(), lRet := Iif(cTipo == "S", AprovSol(SZ1->Z1_FILIAL, SZ1->Z1_NUM), FICDVGRC(SZ1->Z1_FILIAL, SZ1->Z1_NUM, oDadosPass:aCols, oDadosHot:aCols, oDadosVei:aCols, nOpc, cTipo)), CursorArrow(), Iif(lRet, oDlg:End(), )})}, {|| lRet := .F., oDlg:End()}, , @aButtons))

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RejeiSol(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea())}
Local lRet := .T.
Local cEmail := ""
Local cNome := ""
Local cBody := ""

DbSelectArea("SZ1")
SZ1->(DbSetOrder(1))
If (SZ1->(DbSeek(cFil + cNum)))
	RecLock("SZ1", .F.)
	SZ1->Z1_STATUS := "U"
	SZ1->(MsUnlock())
	
	cEmail := Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_EMAIL")
	cNome := Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_NOME")
	cBody := "Prezado(a) " + cNome + "," + CRLF + CRLF
	cBody += "Informamos sua Solicita็ใo de Viagem nบ '" + cNum + "' foi rejeitada." + CRLF
	cBody += "Por favor, revise atrav้s da rotina de Solicita็ใo de Viagens."
	ACSendMail(, , , , cEmail, "SV " + cNum + "", cBody)
Endif

Aviso("Aviso", "Solicita็ใo rejeitada com sucesso.", {"Ok"}, 1)

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AprovSol(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea())}
Local lRet := .T.
Local cEmail := ""
Local cNome := ""
Local cBody := ""
Local cEmCompr  := AllTrim(GetMv("FI_EMCOMPR"))
Local lContinua := .T.

PcoIniLan("900002")
DbSelectArea("SZ0")
SZ0->(DbSetOrder(1))
If (SZ0->(DbSeek(cFil + cNum)))
	While ((SZ0->(!Eof())) .And. (cFil == SZ0->Z0_FILIAL) .And. (cNum == SZ0->Z0_NUMSV))
		lSaldo := PcoVldLan("900002", "01", "FICDVA01", , , .T.)

		If (lSaldo)
			MsgRun("Gerando movimentos. Aguarde...", "", {|| PcoDetLan("900002", "01", "FICDVA01")})

			RecLock("SZ0", .F.)
			SZ0->Z0_CONTLIB := .T.
			SZ0->(MsUnlock())
		Else
			lRet := .F.
		Endif

		SZ0->(DbSkip())
	Enddo
Endif
PcoFinLan("900002")

If !(lRet)
	DbSelectArea("SZ0")
	SZ0->(DbSetOrder(1))
	If (SZ0->(DbSeek(cFil + cNum)))
		While ((SZ0->(!Eof())) .And. (cFil == SZ0->Z0_FILIAL) .And. (cNum == SZ0->Z0_NUMSV))
			If (!(SZ0->Z0_CONTLIB) .And. (Empty(SZ0->Z0_CODCONT)))
				lContinua := .F.
			Endif
			
			SZ0->(DbSkip())
		Enddo
	Endif
	
	If (lContinua)
		DbSelectArea("SZ1")
		SZ1->(DbSetOrder(1))
		If(SZ1->(DbSeek(cFil + cNum)))
			RecLock("SZ1", .F.)
			SZ1->Z1_STATUS := "T"
			SZ1->(MsUnlock())
		Endif
	Else
		Aviso("Aviso", "ษ necessแrio solicitar conting๊ncia do(s) rateio(s) envolvido(s)." + CRLF + ;
						"Por favor, solicite o(s) rateio(s) para dar continuidade ao processo.", {"Ok"}, 2)
	Endif
Endif

If (lRet)
	DbSelectArea("SZ1")
	SZ1->(DbSetOrder(1))
	If (SZ1->(DbSeek(cFil + cNum)))
		If !(Empty(SZ1->Z1_GRPAPRV))
			U_FICOME05(cFil, cNum)
			
			RecLock("SZ1", .F.)
			SZ1->Z1_STATUS := "Q"
			SZ1->(MsUnlock())
		Else
			RecLock("SZ1", .F.)
			SZ1->Z1_STATUS := "Y"
			SZ1->(MsUnlock())
			
			cEmail := Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_EMAIL")
			cNome := Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_NOME")
			cBody := "Prezado(a) " + cNome + "," + CRLF + CRLF
			cBody += "Informamos sua Solicita็ใo de Viagem nบ '" + cNum + "' foi aprovada." + CRLF
			ACSendMail(, , , , cEmail, "SV " + cNum + "", cBody)
			
			cEmail := cEmCompr
			cBody := "Prezado(a) Comprador(a)," + CRLF + CRLF
			cBody += "Informamos sua Solicita็ใo de Viagem nบ '" + cNum + "' foi aprovada e jแ estแ disponํvel para finaliza็ใo." + CRLF
			ACSendMail(, , , , cEmail, "SV " + cNum + "", cBody)
		Endif
	Endif
	
	Aviso("Aviso", "Solicita็ใo aprovada com sucesso.", {"Ok"}, 1)
Endif

aEval(aArea, {|x| RestArea(x)})
Return(lContinua)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FICDVGRC(cFil, cNum, aDadosPass, aDadosHot, aDadosVei, nOpc, cTipo)
Local aArea := {GetArea(), SZ1->(GetArea()), SZ2->(GetArea()), SZ3->(GetArea()), SZ4->(GetArea())}
Local lRet := .T.
Local lTot := Iif(nOpc == "1", .F., .T.)
Local nI := 0
Local cEmail := ""
Local cNome := ""
Local cBody := ""
Local nAdiaAnt := 0

lRet := FICDVCOK(aDadosPass, aDadosHot, aDadosVei)

If (lRet)
	If !(lTot)
		DbSelectArea("SZ2")
		SZ2->(DbSetOrder(1))
		
		For nI := 1 To Len(aDadosPass)
			If (SZ2->(DbSeek(cFil + cNum + aDadosPass[nI][1])))
				RecLock("SZ2", .F.)
				SZ2->Z2_PRODUTO := aDadosPass[nI][2]
				SZ2->Z2_TRECHO  := aDadosPass[nI][3]
				SZ2->Z2_DATA    := aDadosPass[nI][4]
				SZ2->Z2_HORA    := aDadosPass[nI][5]
				SZ2->Z2_DATACH  := aDadosPass[nI][6]
				SZ2->Z2_HORACH  := aDadosPass[nI][7]
				SZ2->Z2_CLASSE  := aDadosPass[nI][8]
				SZ2->Z2_TICKET  := aDadosPass[nI][9]
				SZ2->Z2_VOO     := aDadosPass[nI][10]
				SZ2->Z2_COMPANH := aDadosPass[nI][11]
				SZ2->Z2_LOCALIZ := aDadosPass[nI][12]
				SZ2->Z2_FORNECE := aDadosPass[nI][13]
				SZ2->Z2_LOJA    := aDadosPass[nI][14]
				SZ2->Z2_NOME    := aDadosPass[nI][15]
				SZ2->Z2_VALOR   := aDadosPass[nI][16]
				SZ2->Z2_TIPOCOT := "I"
				SZ2->(MsUnlock())
			Endif
		Next nI
		
		DbSelectArea("SZ3")
		SZ3->(DbSetOrder(1))
		
		For nI := 1 To Len(aDadosHot)
			If (SZ3->(DbSeek(cFil + cNum + aDadosHot[nI][1])))
				RecLock("SZ3", .F.)
				SZ3->Z3_PRODUTO := aDadosHot[nI][2]
				SZ3->Z3_DESCRI  := aDadosHot[nI][3]
				SZ3->Z3_FORNECE := aDadosHot[nI][4]
				SZ3->Z3_LOJA    := aDadosHot[nI][5]
				SZ3->Z3_NOME    := aDadosHot[nI][6]
				SZ3->Z3_DIARIAS := aDadosHot[nI][7]
				SZ3->Z3_CHECKIN := aDadosHot[nI][8]
				SZ3->Z3_CHECKOU := aDadosHot[nI][9]
				SZ3->Z3_OBS     := aDadosHot[nI][10]
				SZ3->Z3_CONFIRM := aDadosHot[nI][11]
				SZ3->Z3_VALOR   := aDadosHot[nI][12]
				SZ3->Z3_TIPOCOT := "I"
				SZ3->(MsUnlock())
			Endif
		Next nI
		
		DbSelectArea("SZ4")
		SZ4->(DbSetOrder(1))
		
		For nI := 1 To Len(aDadosVei)
			If (SZ4->(DbSeek(cFil + cNum + aDadosVei[nI][1])))
				RecLock("SZ4", .F.)
				SZ4->Z4_PRODUTO := aDadosVei[nI][2]
				SZ4->Z4_DESCRI  := aDadosVei[nI][3]
				SZ4->Z4_FORNECE := aDadosVei[nI][4]
				SZ4->Z4_LOJA    := aDadosVei[nI][5]
				SZ4->Z4_NOME    := aDadosVei[nI][6]
				SZ4->Z4_RETIRA  := aDadosVei[nI][7]
				SZ4->Z4_HORARET := aDadosVei[nI][8]
				SZ4->Z4_DEVOLU  := aDadosVei[nI][9]
				SZ4->Z4_HORADEV := aDadosVei[nI][10]
				SZ4->Z4_CONFIRM := aDadosVei[nI][11]
				SZ4->Z4_VALOR   := aDadosVei[nI][12]
				SZ4->Z4_TIPOCOT := "I"
				SZ4->(MsUnlock())
			Endif
		Next nI
	Else
		DbSelectArea("SZ2")
		SZ2->(DbSetOrder(1))
		
		If (SZ2->(DbSeek(cFil + cNum)))
			While ((SZ2->(!Eof())) .And. (cFil == SZ2->(Z2_FILIAL)) .And. (cNum == SZ2->(Z2_NUMSV)))
				RecLock("SZ2", .F.)
				SZ2->Z2_TIPOCOT := "T"
				SZ2->(MsUnlock())
				
				SZ2->(DbSkip())
			Enddo
		Endif
		
		For nI := 1 To Len(aDadosPass)
			If !(Empty(aDadosPass[nI][1]))
				DbSelectArea("SZ2")
				SZ2->(DbSetOrder(1))
				
				If (SZ2->(DbSeek(cFil + cNum + "999")))
					RecLock("SZ2", .F.)
				Else
					RecLock("SZ2", .T.)
				Endif
				SZ2->Z2_FILIAL  := cFil
				SZ2->Z2_NUMSV   := cNum
				SZ2->Z2_ITEM    := "999"
				SZ2->Z2_PRODUTO := aDadosPass[nI][2]
				SZ2->Z2_TRECHO  := aDadosPass[nI][3]
				SZ2->Z2_DATA    := aDadosPass[nI][4]
				SZ2->Z2_HORA    := aDadosPass[nI][5]
				SZ2->Z2_DATACH  := aDadosPass[nI][6]
				SZ2->Z2_HORACH  := aDadosPass[nI][7]
				SZ2->Z2_CLASSE  := aDadosPass[nI][8]
				SZ2->Z2_TICKET  := aDadosPass[nI][9]
				SZ2->Z2_VOO     := aDadosPass[nI][10]
				SZ2->Z2_COMPANH := aDadosPass[nI][11]
				SZ2->Z2_LOCALIZ := aDadosPass[nI][12]
				SZ2->Z2_FORNECE := aDadosPass[nI][13]
				SZ2->Z2_LOJA    := aDadosPass[nI][14]
				SZ2->Z2_NOME    := aDadosPass[nI][15]
				SZ2->Z2_VALOR   := aDadosPass[nI][16]
				SZ2->Z2_STATUS  := "A"
				SZ2->Z2_TIPOCOT := "T"
				SZ2->(MsUnlock())
			Endif
		Next nI
		
		DbSelectArea("SZ3")
		SZ3->(DbSetOrder(1))
		
		If (SZ3->(DbSeek(cFil + cNum)))
			While ((SZ3->(!Eof())) .And. (cFil == SZ3->(Z3_FILIAL)) .And. (cNum == SZ3->(Z3_NUMSV)))
				RecLock("SZ3", .F.)
				SZ3->Z3_TIPOCOT := "T"
				SZ3->(MsUnlock())
				
				SZ3->(DbSkip())
			Enddo
		Endif
		
		For nI := 1 To Len(aDadosHot)
			If !(Empty(aDadosHot[nI][1]))
				DbSelectArea("SZ3")
				SZ3->(DbSetOrder(1))
				
				If (SZ3->(DbSeek(cFil + cNum + "999")))
					RecLock("SZ3", .F.)
				Else
					RecLock("SZ3", .T.)
				Endif
				
				SZ3->Z3_FILIAL  := cFil
				SZ3->Z3_NUMSV   := cNum
				SZ3->Z3_ITEM    := "999"
				SZ3->Z3_PRODUTO := aDadosHot[nI][2]
				SZ3->Z3_DESCRI  := aDadosHot[nI][3]
				SZ3->Z3_FORNECE := aDadosHot[nI][4]
				SZ3->Z3_LOJA    := aDadosHot[nI][5]
				SZ3->Z3_NOME    := aDadosHot[nI][6]
				SZ3->Z3_DIARIAS := aDadosHot[nI][7]
				SZ3->Z3_CHECKIN := aDadosHot[nI][8]
				SZ3->Z3_CHECKOU := aDadosHot[nI][9]
				SZ3->Z3_OBS     := aDadosHot[nI][10]
				SZ3->Z3_CONFIRM := aDadosHot[nI][11]
				SZ3->Z3_VALOR   := aDadosHot[nI][12]
				SZ3->Z3_STATUS  := "A"
				SZ3->Z3_TIPOCOT := "T"
				SZ3->(MsUnlock())
			Endif
		Next nI
		
		DbSelectArea("SZ4")
		SZ4->(DbSetOrder(1))
		
		If (SZ4->(DbSeek(cFil + cNum)))
			While ((SZ4->(!Eof())) .And. (cFil == SZ4->(Z4_FILIAL)) .And. (cNum == SZ4->(Z4_NUMSV)))
				RecLock("SZ4", .F.)
				SZ4->Z4_TIPOCOT := "T"
				SZ4->(MsUnlock())
				
				SZ4->(DbSkip())
			Enddo
		Endif
		
		For nI := 1 To Len(aDadosVei)
			If !(Empty(aDadosVei[nI][1]))
				DbSelectArea("SZ4")
				SZ4->(DbSetOrder(1))
				
				If (SZ4->(DbSeek(cFil + cNum + "999")))
					RecLock("SZ4", .F.)
				Else
					RecLock("SZ4", .T.)
				Endif
	
				SZ4->Z4_FILIAL  := cFil
				SZ4->Z4_NUMSV   := cNum
				SZ4->Z4_ITEM    := "999"
				SZ4->Z4_PRODUTO := aDadosVei[nI][2]
				SZ4->Z4_DESCRI  := aDadosVei[nI][3]
				SZ4->Z4_FORNECE := aDadosVei[nI][4]
				SZ4->Z4_LOJA    := aDadosVei[nI][5]
				SZ4->Z4_NOME    := aDadosVei[nI][6]
				SZ4->Z4_RETIRA  := aDadosVei[nI][7]
				SZ4->Z4_HORARET := aDadosVei[nI][8]
				SZ4->Z4_DEVOLU  := aDadosVei[nI][9]
				SZ4->Z4_HORADEV := aDadosVei[nI][10]
				SZ4->Z4_CONFIRM := aDadosVei[nI][11]
				SZ4->Z4_VALOR   := aDadosVei[nI][12]
				SZ4->Z4_STATUS  := "A"
				SZ4->Z4_TIPOCOT := "T"
				SZ4->(MsUnlock())
			Endif
		Next nI
	Endif
	
	DbSelectArea("SZ1")
	SZ1->(DbSetOrder(1))
	SZ1->(DbSeek(cFil + cNum))
	
	If (cTipo == "U")
		If (Aviso("Confirma็ใo", "Deseja informar um valor de adiantamento?", {"Sim", "Nใo"}, 1) == 1)
			FICDVADI(SZ1->Z1_FILIAL, SZ1->Z1_NUM)
		Endif
	Endif
	
	RecLock("SZ1", .F.)
	SZ1->Z1_STATUS := Iif(cTipo == "U", "S", "U")
	SZ1->(MsUnlock())
	
	DbSelectArea("SZ1")
	SZ1->(DbSetOrder(1))
	SZ1->(DbSeek(cFil + cNum))
	
	If (cTipo == "U")
		cEmail := AllTrim(UsrRetMail(Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_XSUPVIA")))
		cNome := AllTrim(UsrRetName(Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_XSUPVIA")))
		cBody := "Prezado(a) " + cNome + "," + CRLF + CRLF
		cBody += "Informamos sua Solicita็ใo de Viagem nบ '" + cNum + "' estแ disponํvel para aprova็ใo final."
		ACSendMail(, , , , cEmail, "SV " + cNum + "", cBody)
	Else
		cEmail := Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_EMAIL")
		cNome := Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_NOME")
		cBody := "Prezado(a) " + cNome + "," + CRLF + CRLF
		cBody += "Informamos sua Solicita็ใo de Viagem nบ '" + cNum + "' estแ disponํvel para anแlise."
		ACSendMail(, , , , cEmail, "SV " + cNum + "", cBody)
	Endif
	
	Aviso("Confirma็ใo", "Informa็๕es atualizadas com sucesso.", {"Ok"}, 1)
Endif

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  12/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FICDVADI(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea())}
Local lRet := .T.
Local nAdianta := 0
Local cJustif := SZ1->Z1_JUSTIFI
Local cObs := SZ1->Z1_OBS
Local oDlg
Local oEnchoice
Local nOpc := 4
Local aButtons := {}

Define MsDialog oDlg Title "Adiantamento em Reais" From 0, 0 To 200, 400 Pixel

@ 000, 010 Say "Adiantamento: " Of oDlg Pixel
@ 010, 010 MsGet oAdianta Var nAdianta Size 80, 10 Picture "@E 999,999,999.99" Of oDlg Pixel

@ 025, 010 Say "Justificativa: " Of oDlg Pixel
@ 035, 010 Get oJustif Var cJustif Memo Size 180, 20 Of oDlg Pixel

@ 055, 010 Say "Obs: " Of oDlg Pixel
@ 065, 010 Get oObs Var cObs Memo Size 180, 20 Of oDlg Pixel

Activate MsDialog oDlg Center On Init (EnchoiceBar(oDlg, {|| lRet := FICDVADC(1, cFil, cNum, nAdianta, cJustif), Iif(lRet, oDlg:End(), )}, {|| lRet := FICDVADC(2, cFil, cNum, nAdianta, cJustif), Iif(lRet, oDlg:End(), )}, , @aButtons))

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณMicrosiga           บ Data ณ  13/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FICDVADC(nOpc, cFil, cNum, nAdianta, cJustif)
Local lRet := .F.
Local nTotal := 0

If (nOpc == 1)
	If (Aviso("Confirma็ใo", "Confirma este valor de adiantamento?", {"Sim", "Nใo"}, 1) == 1)
		nTotal += nAdianta
		
		DbSelectArea("SZ2")
		SZ2->(DbSetOrder(1))
		If (SZ2->(DbSeek(cFil + cNum)))
			While ((SZ2->(!Eof())) .And. (cFil == SZ2->(Z2_FILIAL)) .And. (cNum == SZ2->(Z2_NUMSV)))
				If (SZ2->Z2_STATUS == "A")
					nTotal += SZ2->Z2_VALOR
				Endif
			
				SZ2->(DbSkip())
			Enddo
		Endif
		
		DbSelectArea("SZ3")
		SZ3->(DbSetOrder(1))
		If (SZ3->(DbSeek(cFil + cNum)))
			While ((SZ3->(!Eof())) .And. (cFil == SZ3->(Z3_FILIAL)) .And. (cNum == SZ3->(Z3_NUMSV)))
				If (SZ3->Z3_STATUS == "A")
					nTotal += SZ3->Z3_VALOR
				Endif
			
				SZ3->(DbSkip())
			Enddo
		Endif
		
		DbSelectArea("SZ4")
		SZ4->(DbSetOrder(1))
		If (SZ4->(DbSeek(cFil + cNum)))
			While ((SZ4->(!Eof())) .And. (cFil == SZ4->(Z4_FILIAL)) .And. (cNum == SZ4->(Z4_NUMSV)))
				If (SZ4->Z4_STATUS == "A")
					nTotal += SZ4->Z4_VALOR
				Endif
			
				SZ4->(DbSkip())
			Enddo
		Endif
		
		DbSelectArea("SZ1")
		SZ1->(DbSetOrder(1))
		If (SZ1->(DbSeek(cFil + cNum)))
			RecLock("SZ1", .F.)
			SZ1->Z1_ADIANTA := nAdianta
			SZ1->Z1_TOTAL   := nTotal
			SZ1->Z1_JUSTIFI := cJustif
			SZ1->(MsUnlock())
		Endif
		
		lRet := .T.
	Endif
Elseif (nOpc == 2)
	If (Aviso("Confirma็ใo", "Deseja sair sem informar adiantamento?", {"Sim", "Nใo"}, 1) == 1)
		DbSelectArea("SZ2")
		SZ2->(DbSetOrder(1))
		If (SZ2->(DbSeek(cFil + cNum)))
			While ((SZ2->(!Eof())) .And. (cFil == SZ2->(Z2_FILIAL)) .And. (cNum == SZ2->(Z2_NUMSV)))
				If (SZ2->Z2_STATUS == "A")
					nTotal += SZ2->Z2_VALOR
				Endif
			
				SZ2->(DbSkip())
			Enddo
		Endif
		
		DbSelectArea("SZ3")
		SZ3->(DbSetOrder(1))
		If (SZ3->(DbSeek(cFil + cNum)))
			While ((SZ3->(!Eof())) .And. (cFil == SZ3->(Z3_FILIAL)) .And. (cNum == SZ3->(Z3_NUMSV)))
				If (SZ3->Z3_STATUS == "A")
					nTotal += SZ3->Z3_VALOR
				Endif
			
				SZ3->(DbSkip())
			Enddo
		Endif
		
		DbSelectArea("SZ4")
		SZ4->(DbSetOrder(1))
		If (SZ4->(DbSeek(cFil + cNum)))
			While ((SZ4->(!Eof())) .And. (cFil == SZ4->(Z4_FILIAL)) .And. (cNum == SZ4->(Z4_NUMSV)))
				If (SZ4->Z4_STATUS == "A")
					nTotal += SZ4->Z4_VALOR
				Endif
			
				SZ4->(DbSkip())
			Enddo
		Endif
		
		DbSelectArea("SZ1")
		SZ1->(DbSetOrder(1))
		If (SZ1->(DbSeek(cFil + cNum)))
			RecLock("SZ1", .F.)
			SZ1->Z1_ADIANTA := 0
			SZ1->Z1_TOTAL   := nTotal
			SZ1->Z1_JUSTIFI := cJustif
			SZ1->(MsUnlock())
		Endif
		
		lRet := .T.
	Endif
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function retCotPass(nOpc, cFil, cNum, cTipo)
Local aArea := {}
Local lRet := .T.
Local aDados := {}
Local cQuery := ""
Local cTab := ""

If (nOpc == "1")
	cQuery := "SELECT" + CRLF
	cQuery += "Z2_ITEM," + CRLF
	cQuery += "Z2_PRODUTO," + CRLF
	cQuery += "Z2_TRECHO," + CRLF
	cQuery += "Z2_DATA," + CRLF
	cQuery += "Z2_HORA," + CRLF
	cQuery += "Z2_DATACH," + CRLF
	cQuery += "Z2_HORACH," + CRLF
	cQuery += "Z2_CLASSE," + CRLF
	cQuery += "Z2_TICKET," + CRLF
	cQuery += "Z2_VOO," + CRLF
	cQuery += "Z2_COMPANH," + CRLF
	cQuery += "Z2_LOCALIZ," + CRLF
	cQuery += "Z2_FORNECE," + CRLF
	cQuery += "Z2_LOJA," + CRLF
	cQuery += "Z2_NOME," + CRLF
	cQuery += "Z2_VALOR" + CRLF
	cQuery += "FROM " + RetSQLName("SZ2") + "" + CRLF
	cQuery += "WHERE Z2_FILIAL = '" + cFil + "'" + CRLF
	cQuery += "AND Z2_NUMSV = '" + cNum + "'" + CRLF
	cQuery += "AND Z2_STATUS = 'A'" + CRLF
	cQuery += "AND Z2_ITEM NOT IN ('999')" + CRLF
	cQuery += "AND D_E_L_E_T_ = ''"
Else
	If (cTipo $ "C")
		cQuery := "SELECT" + CRLF
		cQuery += "'001' AS Z2_ITEM," + CRLF
		cQuery += "'" + Space(TamSX3("Z2_PRODUTO")[1]) + "' AS Z2_PRODUTO," + CRLF
		cQuery += "'" + Space(TamSX3("Z2_TRECHO")[1]) + "' AS  Z2_TRECHO," + CRLF
		cQuery += "'" + Space(TamSX3("Z2_DATA")[1]) + "' AS Z2_DATA," + CRLF
		cQuery += "'" + Space(TamSX3("Z2_HORA")[1]) + "' AS Z2_HORA," + CRLF
		cQuery += "'" + Space(TamSX3("Z2_DATACH")[1]) + "' AS Z2_DATACH," + CRLF
		cQuery += "'" + Space(TamSX3("Z2_HORACH")[1]) + "' AS Z2_HORACH," + CRLF
		cQuery += "'" + Space(TamSX3("Z2_CLASSE")[1]) + "' AS Z2_CLASSE," + CRLF
		cQuery += "'" + Space(TamSX3("Z2_TICKET")[1]) + "' AS Z2_TICKET," + CRLF
		cQuery += "'" + Space(TamSX3("Z2_VOO")[1]) + "' AS Z2_VOO," + CRLF
		cQuery += "'" + Space(TamSX3("Z2_COMPANH")[1]) + "' AS Z2_COMPANH," + CRLF
		cQuery += "'" + Space(TamSX3("Z2_LOCALIZ")[1]) + "' AS Z2_LOCALIZ," + CRLF
		cQuery += "'" + Space(TamSX3("Z2_FORNECE")[1]) + "' AS Z2_FORNECE," + CRLF
		cQuery += "'" + Space(TamSX3("Z2_LOJA")[1]) + "' AS Z2_LOJA," + CRLF
		cQuery += "'" + Space(TamSX3("Z2_NOME")[1]) + "' AS Z2_NOME," + CRLF
		cQuery += "SUM(Z2_VALOR) Z2_VALOR," + CRLF
		cQuery += "COUNT(*) AS Z2_REGS" + CRLF
		cQuery += "FROM " + RetSQLName("SZ2") + "" + CRLF
		cQuery += "WHERE Z2_FILIAL = '" + cFil + "'" + CRLF
		cQuery += "AND Z2_NUMSV = '" + cNum + "'" + CRLF
		cQuery += "AND Z2_STATUS = 'A'" + CRLF
		cQuery += "AND Z2_ITEM NOT IN ('999')" + CRLF
		cQuery += "AND D_E_L_E_T_ = ''"
	Else
		cQuery := "SELECT" + CRLF
		cQuery += "'001' AS Z2_ITEM," + CRLF
		cQuery += "Z2_PRODUTO," + CRLF
		cQuery += "Z2_TRECHO," + CRLF
		cQuery += "Z2_DATA," + CRLF
		cQuery += "Z2_HORA," + CRLF
		cQuery += "Z2_DATACH," + CRLF
		cQuery += "Z2_HORACH," + CRLF
		cQuery += "Z2_CLASSE," + CRLF
		cQuery += "Z2_TICKET," + CRLF
		cQuery += "Z2_VOO," + CRLF
		cQuery += "Z2_COMPANH," + CRLF
		cQuery += "Z2_LOCALIZ," + CRLF
		cQuery += "Z2_FORNECE," + CRLF
		cQuery += "Z2_LOJA," + CRLF
		cQuery += "Z2_NOME," + CRLF
		cQuery += "Z2_VALOR," + CRLF
		cQuery += "COUNT(*) AS Z2_REGS" + CRLF
		cQuery += "FROM " + RetSQLName("SZ2") + "" + CRLF
		cQuery += "WHERE Z2_FILIAL = '" + cFil + "'" + CRLF
		cQuery += "AND Z2_NUMSV = '" + cNum + "'" + CRLF
		cQuery += "AND Z2_STATUS = 'A'" + CRLF
		cQuery += "AND Z2_ITEM IN ('999')" + CRLF
		cQuery += "AND D_E_L_E_T_ = ''" + CRLF
		cQuery += "GROUP BY Z2_ITEM, Z2_PRODUTO, Z2_TRECHO, Z2_DATA, Z2_HORA, Z2_DATACH, Z2_HORACH, Z2_CLASSE, Z2_TICKET, Z2_VOO, Z2_COMPANH," + CRLF
		cQuery += "Z2_LOCALIZ, Z2_FORNECE, Z2_LOJA, Z2_NOME, Z2_VALOR"
	Endif
Endif

cQuery := ChangeQuery(cQuery)

cTab := GetNextAlias()

TcQUERY cQuery NEW ALIAS ((cTab))

DbSelectArea((cTab))
(cTab)->(DbGoTop())

While ((cTab)->(!Eof()))
	If (nOpc == "2")
		If ((cTab)->(Z2_REGS) == 0)
			lRet := .F.
		Endif
	Endif
	
	If (lRet)
		aAdd(aDados, {(cTab)->(Z2_ITEM), (cTab)->(Z2_PRODUTO), (cTab)->(Z2_TRECHO), SToD((cTab)->(Z2_DATA)), (cTab)->(Z2_HORA), ;
					SToD((cTab)->(Z2_DATACH)), (cTab)->(Z2_HORACH), ;
					(cTab)->(Z2_CLASSE), (cTab)->(Z2_TICKET), (cTab)->(Z2_VOO), (cTab)->(Z2_COMPANH), (cTab)->(Z2_LOCALIZ), ;
					(cTab)->(Z2_FORNECE), (cTab)->(Z2_LOJA), (cTab)->(Z2_NOME), (cTab)->(Z2_VALOR), .F.})
	Endif

	(cTab)->(DbSkip())
Enddo

(cTab)->(DbCloseArea())

aEval(aArea, {|x| RestArea(x)})
Return(aDados)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function retCotHot(nOpc, cFil, cNum, cTipo)
Local aArea := {}
Local lRet := .T.
Local aDados := {}
Local cQuery := ""
Local cTab := ""

If (nOpc == "1")
	cQuery := "SELECT" + CRLF
	cQuery += "Z3_ITEM," + CRLF
	cQuery += "Z3_PRODUTO," + CRLF
	cQuery += "Z3_DESCRI," + CRLF
	cQuery += "Z3_FORNECE," + CRLF
	cQuery += "Z3_LOJA," + CRLF
	cQuery += "Z3_NOME," + CRLF
	cQuery += "Z3_DIARIAS," + CRLF
	cQuery += "Z3_CHECKIN," + CRLF
	cQuery += "Z3_CHECKOU," + CRLF
	cQuery += "CONVERT(VARCHAR(4000), CONVERT(VARBINARY(4000), Z3_OBS)) AS Z3_OBS," + CRLF
	cQuery += "Z3_CONFIRM," + CRLF
	cQuery += "Z3_VALOR" + CRLF
	cQuery += "FROM " + RetSQLName("SZ3") + "" + CRLF
	cQuery += "WHERE Z3_FILIAL = '" + cFil + "'" + CRLF
	cQuery += "AND Z3_NUMSV = '" + cNum + "'" + CRLF
	cQuery += "AND Z3_STATUS = 'A'" + CRLF
	cQuery += "AND Z3_ITEM NOT IN ('999')" + CRLF
	cQuery += "AND D_E_L_E_T_ = ''"
Else
	If (cTipo $ "C")
		cQuery := "SELECT" + CRLF
		cQuery += "'001' AS Z3_ITEM," + CRLF
		cQuery += "'" + Space(TamSX3("Z3_PRODUTO")[1]) + "' AS Z3_PRODUTO," + CRLF
		cQuery += "'" + Space(TamSX3("Z3_DESCRI")[1]) + "' AS Z3_DESCRI," + CRLF
		cQuery += "'" + Space(TamSX3("Z3_FORNECE")[1]) + "' AS Z3_FORNECE," + CRLF
		cQuery += "'" + Space(TamSX3("Z3_LOJA")[1]) + "' AS Z3_LOJA," + CRLF
		cQuery += "'" + Space(TamSX3("Z3_NOME")[1]) + "' AS Z3_NOME," + CRLF
		cQuery += "'" + Space(TamSX3("Z3_DIARIAS")[1]) + "' AS Z3_DIARIAS," + CRLF
		cQuery += "'" + Space(TamSX3("Z3_CHECKIN")[1]) + "' AS Z3_CHECKIN," + CRLF
		cQuery += "'" + Space(TamSX3("Z3_CHECKOU")[1]) + "' AS Z3_CHECKOU," + CRLF
		cQuery += "'" + Space(TamSX3("Z3_OBS")[1]) + "' AS Z3_OBS," + CRLF
		cQuery += "'" + Space(TamSX3("Z3_CONFIRM")[1]) + "' AS Z3_CONFIRM," + CRLF
		cQuery += "SUM(Z3_VALOR) AS Z3_VALOR," + CRLF
		cQuery += "COUNT(*) AS Z3_REGS" + CRLF
		cQuery += "FROM " + RetSQLName("SZ3") + "" + CRLF
		cQuery += "WHERE Z3_FILIAL = '" + cFil + "'" + CRLF
		cQuery += "AND Z3_NUMSV = '" + cNum + "'" + CRLF
		cQuery += "AND Z3_STATUS = 'A'" + CRLF
		cQuery += "AND Z3_ITEM NOT IN ('999')" + CRLF
		cQuery += "AND D_E_L_E_T_ = ''"
	Else
		cQuery := "SELECT" + CRLF
		cQuery += "'001' AS Z3_ITEM," + CRLF
		cQuery += "Z3_PRODUTO," + CRLF
		cQuery += "Z3_DESCRI," + CRLF
		cQuery += "Z3_FORNECE," + CRLF
		cQuery += "Z3_LOJA," + CRLF
		cQuery += "Z3_NOME," + CRLF
		cQuery += "Z3_DIARIAS," + CRLF
		cQuery += "Z3_CHECKIN," + CRLF
		cQuery += "Z3_CHECKOU," + CRLF
		cQuery += "CONVERT(VARCHAR(4000), CONVERT(VARBINARY(4000), Z3_OBS)) AS Z3_OBS," + CRLF
		cQuery += "Z3_CONFIRM," + CRLF
		cQuery += "Z3_VALOR," + CRLF
		cQuery += "COUNT(*) AS Z3_REGS" + CRLF
		cQuery += "FROM " + RetSQLName("SZ3") + "" + CRLF
		cQuery += "WHERE Z3_FILIAL = '" + cFil + "'" + CRLF
		cQuery += "AND Z3_NUMSV = '" + cNum + "'" + CRLF
		cQuery += "AND Z3_STATUS = 'A'" + CRLF
		cQuery += "AND Z3_ITEM IN ('999')" + CRLF
		cQuery += "AND D_E_L_E_T_ = ''" + CRLF
		cQuery += "GROUP BY Z3_ITEM, Z3_PRODUTO, Z3_DESCRI, Z3_FORNECE, Z3_LOJA," + CRLF
		cQuery += "Z3_NOME, Z3_DIARIAS, Z3_CHECKIN, Z3_CHECKOU, CONVERT(VARCHAR(4000), CONVERT(VARBINARY(4000), Z3_OBS)), Z3_CONFIRM, Z3_VALOR"
	Endif
Endif

cQuery := ChangeQuery(cQuery)

cTab := GetNextAlias()

TcQUERY cQuery NEW ALIAS ((cTab))

DbSelectArea((cTab))
(cTab)->(DbGoTop())

While ((cTab)->(!Eof()))
	If (nOpc == "2")
		If ((cTab)->(Z3_REGS) == 0)
			lRet := .F.
		Endif
	Endif
	
	If (lRet)
		aAdd(aDados, {(cTab)->(Z3_ITEM), (cTab)->(Z3_PRODUTO), (cTab)->(Z3_DESCRI), (cTab)->(Z3_FORNECE), (cTab)->(Z3_LOJA), ;
					(cTab)->(Z3_NOME), (cTab)->(Z3_DIARIAS), SToD((cTab)->(Z3_CHECKIN)), SToD((cTab)->(Z3_CHECKOU)), (cTab)->(Z3_OBS), ;
					(cTab)->(Z3_CONFIRM), (cTab)->(Z3_VALOR), .F.})
	Endif

	(cTab)->(DbSkip())
Enddo

(cTab)->(DbCloseArea())

aEval(aArea, {|x| RestArea(x)})
Return(aDados)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function retCotVei(nOpc, cFil, cNum, cTipo)
Local aArea := {}
Local lRet := .T.
Local aDados := {}
Local cQuery := ""
Local cTab := ""

If (nOpc == "1")
	cQuery := "SELECT" + CRLF
	cQuery += "Z4_ITEM," + CRLF
	cQuery += "Z4_PRODUTO," + CRLF
	cQuery += "Z4_DESCRI," + CRLF
	cQuery += "Z4_FORNECE," + CRLF
	cQuery += "Z4_LOJA," + CRLF
	cQuery += "Z4_NOME," + CRLF
	cQuery += "Z4_RETIRA," + CRLF
	cQuery += "Z4_HORARET," + CRLF
	cQuery += "Z4_DEVOLU," + CRLF
	cQuery += "Z4_HORADEV," + CRLF
	cQuery += "Z4_CONFIRM," + CRLF
	cQuery += "Z4_VALOR" + CRLF
	cQuery += "FROM " + RetSQLName("SZ4") + "" + CRLF
	cQuery += "WHERE Z4_FILIAL = '" + cFil + "'" + CRLF
	cQuery += "AND Z4_NUMSV = '" + cNum + "'" + CRLF
	cQuery += "AND Z4_STATUS = 'A'" + CRLF
	cQuery += "AND Z4_ITEM NOT IN ('999')" + CRLF
	cQuery += "AND D_E_L_E_T_ = ''"
Else
	If (cTipo $ "C")
		cQuery := "SELECT" + CRLF
		cQuery += "'001' AS Z4_ITEM," + CRLF
		cQuery += "'" + Space(TamSX3("Z4_PRODUTO")[1]) + "' AS Z4_PRODUTO," + CRLF
		cQuery += "'" + Space(TamSX3("Z4_DESCRI")[1]) + "' AS Z4_DESCRI," + CRLF
		cQuery += "'" + Space(TamSX3("Z4_FORNECE")[1]) + "' AS Z4_FORNECE," + CRLF
		cQuery += "'" + Space(TamSX3("Z4_LOJA")[1]) + "' AS Z4_LOJA," + CRLF
		cQuery += "'" + Space(TamSX3("Z4_NOME")[1]) + "' AS Z4_NOME," + CRLF
		cQuery += "'" + Space(TamSX3("Z4_RETIRA")[1]) + "' AS Z4_RETIRA," + CRLF
		cQuery += "'" + Space(TamSX3("Z4_RETIRA")[1]) + "' AS Z4_HORARET," + CRLF
		cQuery += "'" + Space(TamSX3("Z4_DEVOLU")[1]) + "' AS Z4_DEVOLU," + CRLF
		cQuery += "'" + Space(TamSX3("Z4_DEVOLU")[1]) + "' AS Z4_HORADEV," + CRLF
		cQuery += "'" + Space(TamSX3("Z4_CONFIRM")[1]) + "' AS Z4_CONFIRM," + CRLF
		cQuery += "SUM(Z4_VALOR) AS Z4_VALOR," + CRLF
		cQuery += "COUNT(*) AS Z4_REGS" + CRLF
		cQuery += "FROM " + RetSQLName("SZ4") + "" + CRLF
		cQuery += "WHERE Z4_FILIAL = '" + cFil + "'" + CRLF
		cQuery += "AND Z4_NUMSV = '" + cNum + "'" + CRLF
		cQuery += "AND Z4_STATUS = 'A'" + CRLF
		cQuery += "AND Z4_ITEM NOT IN ('999')" + CRLF
		cQuery += "AND D_E_L_E_T_ = ''"
	Else
		cQuery := "SELECT" + CRLF
		cQuery += "'001' AS Z4_ITEM," + CRLF
		cQuery += "Z4_PRODUTO," + CRLF
		cQuery += "Z4_DESCRI," + CRLF
		cQuery += "Z4_FORNECE," + CRLF
		cQuery += "Z4_LOJA," + CRLF
		cQuery += "Z4_NOME," + CRLF
		cQuery += "Z4_RETIRA," + CRLF
		cQuery += "Z4_HORARET," + CRLF
		cQuery += "Z4_DEVOLU," + CRLF
		cQuery += "Z4_HORADEV," + CRLF
		cQuery += "Z4_CONFIRM," + CRLF
		cQuery += "Z4_VALOR," + CRLF
		cQuery += "COUNT(*) AS Z4_REGS" + CRLF
		cQuery += "FROM " + RetSQLName("SZ4") + "" + CRLF
		cQuery += "WHERE Z4_FILIAL = '" + cFil + "'" + CRLF
		cQuery += "AND Z4_NUMSV = '" + cNum + "'" + CRLF
		cQuery += "AND Z4_STATUS = 'A'" + CRLF
		cQuery += "AND Z4_ITEM IN ('999')" + CRLF
		cQuery += "AND D_E_L_E_T_ = ''" + CRLF
		cQuery += "GROUP BY Z4_ITEM, Z4_PRODUTO, Z4_DESCRI, Z4_FORNECE, Z4_LOJA," + CRLF
		cQuery += "Z4_NOME, Z4_RETIRA, Z4_HORARET, Z4_DEVOLU, Z4_HORADEV, Z4_CONFIRM, Z4_VALOR"
	Endif
Endif

cQuery := ChangeQuery(cQuery)

cTab := GetNextAlias()

TcQUERY cQuery NEW ALIAS ((cTab))

DbSelectArea((cTab))
(cTab)->(DbGoTop())

While ((cTab)->(!Eof()))
	If (nOpc == "2")
		If ((cTab)->(Z4_REGS) == 0)
			lRet := .F.
		Endif
	Endif
	
	If (lRet)
		aAdd(aDados, {(cTab)->(Z4_ITEM), (cTab)->(Z4_PRODUTO), (cTab)->(Z4_DESCRI), (cTab)->(Z4_FORNECE), (cTab)->(Z4_LOJA), ;
					(cTab)->(Z4_NOME), SToD((cTab)->(Z4_RETIRA)), (cTab)->(Z4_HORARET), SToD((cTab)->(Z4_DEVOLU)), (cTab)->(Z4_HORADEV), ;
					(cTab)->(Z4_CONFIRM), (cTab)->(Z4_VALOR), .F.})
	Endif

	(cTab)->(DbSkip())
Enddo

(cTab)->(DbCloseArea())

aEval(aArea, {|x| RestArea(x)})
Return(aDados)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICDVINC(nOpc)
Local lRet := .T.
Local oDlg
Local lHab := .T.
Local oNum
Local cNum := ""
Local oData
Local dData := dDataBase
Local oTotal
Local nTotal := 0
Local oAdianta
Local nAdianta := 0
Local oCodSol
Local cCodSol := __cUserId
Local oSolicit
Local cSolicit := cUserName
Local oCodViaj
Local cCodViaj := Space(TamSX3("Z1_CODVIAJ")[1])
Local oLoja
Local cLoja := Space(TamSX3("Z1_LOJAVIA")[1])
Local oViajante
Local cViajante := Space(TamSX3("Z1_NOMVIAJ")[1])
Local oObs
Local cObs := Space(TamSX3("Z1_OBS")[1])
Local oGrupo
Local cGrupo := Space(TamSX3("Z1_GRPAPRV")[1])
Local oTipo
Local oItem
Local cItem := Space(TamSX3("Z1_ITEMCTA")[1])
Local oConta
Local cConta := Space(TamSX3("Z1_CONTA")[1])
Local oCentro
Local cCentro := Space(TamSX3("Z1_CCUSTO")[1])
Local aTipo := {"1=Nacional", "2=Internacional"}
Local aFolder := {"Passagem", "Hotel", "Veํculo", "Seguro Viagem"}
Local aSize := MsAdvSize()
Local aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 3, 3}
Local aObjects := {{100,040,.T.,.T.}, {100,120,.T.,.T.}}
Local aPosObj := MsObjSize(aInfo, aObjects)
Local aHeadPass := {}
Local aHeadSeg := {}
Local aHeadHot := {}
Local aHeadVei := {}
Local cNoCpos := "Z2_NUMSV;Z3_NUMSV;Z4_NUMSV;Z5_NUMSV;Z2_STATUS;Z3_STATUS;Z4_STATUS;Z5_STATUS;Z2_TIPOCOT;Z3_TIPOCOT;Z4_TIPOCOT"
Local aColsPass := {}
Local aColsHot := {}
Local aColsVei := {}
Local aAux := {}
Local nAux := 0
Local aButtons := {}
Local lOk := .F.

Private oFolder
Private cTipo := Space(TamSX3("Z1_TIPO")[1])
Private oDadosPass
Private oDadosHot
Private oDadosVei
Private oDadosSeg
Private aColsSeg := {}
Private cAliasTrb  := GetNextAlias()

RegToMemory("SZ1", Iif(nOpc == 3, .T., .F.))

xRateio(M->Z1_FILIAL, M->Z1_NUM, nOpc)

aAdd(aButtons, {"FILTRO", {|| FICDVRAT(nOpc, M->Z1_NUM)}, "Rateio"})

If (nOpc != 3)
	aAdd(aButtons, {"Filtro", {|| MsDocument("SZ1", SZ1->(Recno()), 3)}, "Conhecimento"})
Endif

If (nOpc == 4)
	If !(SZ1->Z1_STATUS $ "E")
		Aviso("Aviso", "Esta SV nใo pode ser alterada, somente permitida a visualiza็ใo.", {"Ok"}, 1)
		Return(.F.)
	Endif
Elseif (nOpc == 6)
//	cSuperior := Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_XSUPVIA")
	cSuperior := SZ1->Z1_APROV
	
	If (cSuperior != __cUserId)
		Aviso("Aviso", "Usuแrio nใo pode realizar aprova็ใo desta SV.", {"Ok"}, 1)
		Return(.F.)
	Endif
	
	If (SZ1->Z1_STATUS != "A")
		If (SZ1->Z1_STATUS $ "E")
			Aviso("Aviso", "Esta SV estแ Em Elabora็ใo.", {"Ok"}, 1)
		Elseif (SZ1->Z1_STATUS $ "CR")
			Aviso("Aviso", "Esta SV jแ foi Aprovada/Rejeitada.", {"Ok"}, 1)
		Elseif (SZ1->Z1_STATUS $ "S")
			Aviso("Aviso", "Esta SV estแ em Aprova็ใo Final.", {"Ok"}, 1)
		Endif
		
		Return(.F.)
	Endif
	
	aAdd(aButtons, {"FILTRO", {|| RejeiTot(SZ1->Z1_FILIAL, SZ1->Z1_NUM), oDlg:End()}, "Rejeitar"})
Endif

//ฺฤฤฤฤฤฤฤฤฤฟ
//ณPassagensณ
//ภฤฤฤฤฤฤฤฤฤู

SX3->(DbSetOrder(1))
SX3->(DbSeek("SZ2"))
While ((SX3->(!Eof())) .And. (SX3->X3_ARQUIVO == "SZ2"))
	If ((X3USO(SX3->X3_USADO)) .And. (cNivel >= SX3->X3_NIVEL) .And. !(AllTrim(SX3->X3_CAMPO) $ cNoCpos))
		aAdd(aHeadPass,	{TRIM(SX3->X3_TITULO)	,;
						SX3->X3_CAMPO			,;
						SX3->X3_PICTURE			,;
						SX3->X3_TAMANHO			,;
						SX3->X3_DECIMAL			,;
						SX3->X3_VALID			,;
						SX3->X3_USADO			,;
						SX3->X3_TIPO			,;
						SX3->X3_F3				,;
						SX3->X3_CONTEXT			,;
						SX3->X3_CBOX			,;
						SX3->X3_RELACAO			,;
						SX3->X3_WHEN			,;
						SX3->X3_VISUAL			,;
						SX3->X3_VLDUSER			,;
						SX3->X3_PICTVAR			,;
						SX3->X3_OBRIGAT			})
	Endif
	
	SX3->(DbSkip())
Enddo

//ฺฤฤฤฤฤฤฟ
//ณHot้isณ
//ภฤฤฤฤฤฤู

SX3->(DbSetOrder(1))
SX3->(DbSeek("SZ3"))
While ((SX3->(!Eof())) .And. (SX3->X3_ARQUIVO == "SZ3"))
	If ((X3USO(SX3->X3_USADO)) .And. (cNivel >= SX3->X3_NIVEL) .And. !(AllTrim(SX3->X3_CAMPO) $ cNoCpos))
		aAdd(aHeadHot,	{TRIM(SX3->X3_TITULO)	,;
						SX3->X3_CAMPO			,;
						SX3->X3_PICTURE			,;
						SX3->X3_TAMANHO			,;
						SX3->X3_DECIMAL			,;
						SX3->X3_VALID			,;
						SX3->X3_USADO			,;
						SX3->X3_TIPO			,;
						SX3->X3_F3				,;
						SX3->X3_CONTEXT			,;
						SX3->X3_CBOX			,;
						SX3->X3_RELACAO			,;
						SX3->X3_WHEN			,;
						SX3->X3_VISUAL			,;
						SX3->X3_VLDUSER			,;
						SX3->X3_PICTVAR			,;
						SX3->X3_OBRIGAT			})
	Endif
	
	SX3->(DbSkip())
Enddo

//ฺฤฤฤฤฤฤฤฤฟ
//ณVeํculosณ
//ภฤฤฤฤฤฤฤฤู

SX3->(DbSetOrder(1))
SX3->(DbSeek("SZ4"))
While ((SX3->(!Eof())) .And. (SX3->X3_ARQUIVO == "SZ4"))
	If ((X3USO(SX3->X3_USADO)) .And. (cNivel >= SX3->X3_NIVEL) .And. !(AllTrim(SX3->X3_CAMPO) $ cNoCpos))
		aAdd(aHeadVei,	{TRIM(SX3->X3_TITULO)	,;
						SX3->X3_CAMPO			,;
						SX3->X3_PICTURE			,;
						SX3->X3_TAMANHO			,;
						SX3->X3_DECIMAL			,;
						SX3->X3_VALID			,;
						SX3->X3_USADO			,;
						SX3->X3_TIPO			,;
						SX3->X3_F3				,;
						SX3->X3_CONTEXT			,;
						SX3->X3_CBOX			,;
						SX3->X3_RELACAO			,;
						SX3->X3_WHEN			,;
						SX3->X3_VISUAL			,;
						SX3->X3_VLDUSER			,;
						SX3->X3_PICTVAR			,;
						SX3->X3_OBRIGAT			})
	Endif
	
	SX3->(DbSkip())
Enddo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSeguro Viagemณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู

SX3->(DbSetOrder(1))
SX3->(DbSeek("SZ5"))
While ((SX3->(!Eof())) .And. (SX3->X3_ARQUIVO == "SZ5"))
	If ((X3USO(SX3->X3_USADO)) .And. (cNivel >= SX3->X3_NIVEL) .And. !(AllTrim(SX3->X3_CAMPO) $ cNoCpos))
		aAdd(aHeadSeg,	{TRIM(SX3->X3_TITULO)	,;
						SX3->X3_CAMPO			,;
						SX3->X3_PICTURE			,;
						SX3->X3_TAMANHO			,;
						SX3->X3_DECIMAL			,;
						SX3->X3_VALID			,;
						SX3->X3_USADO			,;
						SX3->X3_TIPO			,;
						SX3->X3_F3				,;
						SX3->X3_CONTEXT			,;
						SX3->X3_CBOX			,;
						SX3->X3_RELACAO			,;
						SX3->X3_WHEN			,;
						SX3->X3_VISUAL			,;
						SX3->X3_VLDUSER			,;
						SX3->X3_PICTVAR			,;
						SX3->X3_OBRIGAT			})
	Endif
	
	SX3->(DbSkip())
Enddo

//ฺฤฤฤฤฤฤฤฤฤฟ
//ณPassagensณ
//ภฤฤฤฤฤฤฤฤฤู

aAux := {}
For nAux := 1 To Len(aHeadPass)
	SX3->(DbSetOrder(2))
	SX3->(DbSeek(aHeadPass[nAux, 2]))
	If (AllTrim(aHeadPass[nAux, 2]) == "Z2_ITEM")
		aAdd(aAux, "001")
	Else
		If (SX3->X3_TIPO == "C")
			aAdd(aAux, Space(TamSX3(aHeadPass[nAux, 2])[1]))
		Elseif (SX3->X3_TIPO == "N")
			aAdd(aAux, 0)
		Elseif (SX3->X3_TIPO == "D")
			aAdd(aAux, dDataBase)
		Endif
	Endif
Next nAux
aAdd(aAux, .F.)
aAdd(aColsPass, aAux)

//ฺฤฤฤฤฤฤฟ
//ณHot้isณ
//ภฤฤฤฤฤฤู

aAux := {}
For nAux := 1 To Len(aHeadHot)
	SX3->(DbSetOrder(2))
	SX3->(DbSeek(aHeadHot[nAux, 2]))
	If (AllTrim(aHeadHot[nAux, 2]) == "Z3_ITEM")
		aAdd(aAux, "001")
	Else
		If (SX3->X3_TIPO == "C")
			aAdd(aAux, Space(TamSX3(aHeadHot[nAux, 2])[1]))
		Elseif (SX3->X3_TIPO == "N")
			aAdd(aAux, 0)
		Elseif (SX3->X3_TIPO == "D")
			aAdd(aAux, dDataBase)
		Elseif (SX3->X3_TIPO == "M")
			aAdd(aAux, Space(TamSX3(aHeadHot[nAux, 2])[1]))
		Endif
	Endif
Next nAux
aAdd(aAux, .F.)
aAdd(aColsHot, aAux)

//ฺฤฤฤฤฤฤฤฤฟ
//ณVeํculosณ
//ภฤฤฤฤฤฤฤฤู

aAux := {}
For nAux := 1 To Len(aHeadVei)
	SX3->(DbSetOrder(2))
	SX3->(DbSeek(aHeadVei[nAux, 2]))
	If (AllTrim(aHeadVei[nAux, 2]) == "Z4_ITEM")
		aAdd(aAux, "001")
	Else
		If (SX3->X3_TIPO == "C")
			aAdd(aAux, Space(TamSX3(aHeadVei[nAux, 2])[1]))
		Elseif (SX3->X3_TIPO == "N")
			aAdd(aAux, 0)
		Elseif (SX3->X3_TIPO == "D")
			aAdd(aAux, dDataBase)
		Endif
	Endif
Next nAux
aAdd(aAux, .F.)
aAdd(aColsVei, aAux)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSeguro Viagemณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู

aAux := {}
For nAux := 1 To Len(aHeadSeg)
	SX3->(DbSetOrder(2))
	SX3->(DbSeek(aHeadSeg[nAux, 2]))
	If (AllTrim(aHeadSeg[nAux, 2]) == "Z5_ITEM")
		aAdd(aAux, "001")
	Else
		If (SX3->X3_TIPO == "C")
			aAdd(aAux, Space(TamSX3(aHeadSeg[nAux, 2])[1]))
		Elseif (SX3->X3_TIPO == "N")
			aAdd(aAux, 0)
		Elseif (SX3->X3_TIPO == "D")
			aAdd(aAux, dDataBase)
		Endif
	Endif
Next nAux
aAdd(aAux, .F.)
aAdd(aColsSeg, aAux)

If (cValToChar(nOpc) $ "246")
	aColsPass := retPass(SZ1->Z1_FILIAL, SZ1->Z1_NUM)
	
	aColsHot := retHot(SZ1->Z1_FILIAL, SZ1->Z1_NUM)
	
	aColsVei := retVei(SZ1->Z1_FILIAL, SZ1->Z1_NUM)
	
	aColsSeg := retSeg(SZ1->Z1_FILIAL, SZ1->Z1_NUM)
Endif

Define MsDialog oDlg Title "Solicita็ใo de Viagens" From 3, 0 To 500, 960 Pixel

oEnchoice := MsmGet():New("SZ1", , nOpc, , , , {}, {1, 1, 105, 480}, Nil, 3, , , , , , .T., , , , , , , ,.T.)

oFolder		:= TFolder():New(105, 1, aFolder, {}, oDlg, 1, , , .T., .F., aPosObj[2,4]-75, aPosObj[2,3], )

oDadosPass := MsNewGetDados():New(0, 0, 120, 478, Iif(nOpc == 6, GD_DELETE, GD_INSERT + GD_UPDATE + GD_DELETE), ;
								"U_FICDVLIN(1)", "AllwaysTrue()", "+Z2_ITEM", , , 999, "AllwaysTrue()", , , oFolder:aDialogs[1], aHeadPass, aColsPass)
oDadosPass:oBrowse:bGotFocus := {|| Fd_Entra(1)}
oDadosPass:oBrowse:bLostFocus := {|| Fd_Sai(1)}
oDadosPass:oBrowse:Default()
oDadosPass:oBrowse:Refresh()
If (nOpc == 2)
	oDadosPass:Disable()
Endif
oFolder:aDialogs[1]:Refresh()

oDadosHot := MsNewGetDados():New(0, 0, 120, 478, Iif(nOpc == 6, GD_DELETE, GD_INSERT + GD_UPDATE + GD_DELETE), ;
								"U_FICDVLIN(2)", "AllwaysTrue()", "+Z3_ITEM", , , 999, "AllwaysTrue()", , , oFolder:aDialogs[2], aHeadHot, aColsHot)
oDadosHot:oBrowse:bGotFocus := {|| Fd_Entra(2)}
oDadosHot:oBrowse:bLostFocus := {|| Fd_Sai(2)}
oDadosHot:oBrowse:Default()
oDadosHot:oBrowse:Refresh()
If (nOpc == 2)
	oDadosHot:Disable()
Endif
oFolder:aDialogs[2]:Refresh()

oDadosVei := MsNewGetDados():New(0, 0, 120, 478, Iif(nOpc == 6, GD_DELETE, GD_INSERT + GD_UPDATE + GD_DELETE), ;
								"U_FICDVLIN(3)", "AllwaysTrue()", "+Z4_ITEM", , , 999, "AllwaysTrue()", , , oFolder:aDialogs[3], aHeadVei, aColsVei)
oDadosVei:oBrowse:bGotFocus := {|| Fd_Entra(3)}
oDadosVei:oBrowse:bLostFocus := {|| Fd_Sai(3)}
oDadosVei:oBrowse:Default()
oDadosVei:oBrowse:Refresh()
If (nOpc == 2)
	oDadosVei:Disable()
Endif
oFolder:aDialogs[3]:Refresh()

oDadosSeg := MsNewGetDados():New(0, 0, 120, 478, Iif(nOpc == 6, GD_DELETE, GD_INSERT + GD_UPDATE + GD_DELETE), ;
								"U_FICDVLIN(4)", "AllwaysTrue()", "+Z5_ITEM", , , 999, "AllwaysTrue()", , "U_FICDVSEG()", oFolder:aDialogs[4], aHeadSeg, aColsSeg)
oDadosSeg:oBrowse:bGotFocus := {|| Fd_Entra(4)}
oDadosSeg:oBrowse:bLostFocus := {|| Fd_Sai(4)}
oDadosSeg:oBrowse:Default()
oDadosSeg:oBrowse:Refresh()
If (nOpc == 2)
	oDadosSeg:Disable()
Endif
oFolder:aDialogs[4]:Refresh()

Activate MsDialog oDlg Center On Init (EnchoiceBar(oDlg, {|| MsgRun("Gravando informa็๕es, aguarde...", "Solicita็๕es de Viagens", {|| ConfirmSX8(), CursorWait(), U_FICDVGRV(nOpc, cNum, dData, nTotal, nAdianta, cCodSol, cSolicit, cCodViaj, cLoja, cViajante, cObs, cGrupo, cTipo, cItem, cConta, cCentro, oDadosPass:aCols, oDadosHot:aCols, oDadosVei:aCols, oDadosSeg:aCols), CursorArrow(), oDlg:End()})}, {||oDlg:End()}, , @aButtons))

fRateio()

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  13/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xRateio(cFil, cNum, nOpc)
Local lRet         := .T.
Local aEstrut      := {{"Z0_ITEM", "C", 3 , 0}, ;
					{"Z0_ITEMCTA", "C", 9 , 0}, ;
					{"Z0_CONTA"  , "C", 20, 0}, ;
					{"Z0_CCUSTO" , "C", 9 , 0}, ;
					{"Z0_PERC"   , "N", 6 , 2}, ;
					{"Z0_DEL"    , "L", 1 , 0}}
Local cChave       := "Z0_ITEM+Z0_ITEMCTA+Z0_CONTA+Z0_CCUSTO"

Private oArqRateio := CriaTrab(aEstrut, .T.)

DbUseArea(.T., , oArqRateio, cAliasTrb, .F., .F.)

IndRegua(cAliasTrb, oArqRateio, cChave, , , "Selecionando Registros...")
DbSelectArea(cAliasTrb)
DbSetIndex(oArqRateio+OrdBagExt())
DbSetOrder(1)

If !(nOpc == 3)
	DbSelectArea("SZ0")
	SZ0->(DbSetOrder(1))
	If (SZ0->(DbSeek(cFil + cNum)))
		While ((SZ0->(!Eof())) .And. (cFil == SZ0->Z0_FILIAL) .And. (cNum == SZ0->Z0_NUMSV))
			RecLock((cAliasTrb), .T.)
			(cAliasTrb)->(Z0_ITEM) := SZ0->Z0_ITEM
			(cAliasTrb)->(Z0_ITEMCTA) := SZ0->Z0_ITEMCTA
			(cAliasTrb)->(Z0_CONTA) := SZ0->Z0_CONTA
			(cAliasTrb)->(Z0_CCUSTO) := SZ0->Z0_CCUSTO
			(cAliasTrb)->(Z0_PERC) := SZ0->Z0_PERC
			(cAliasTrb)->(MsUnlock())

			SZ0->(DbSkip())
		Enddo
	Endif
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  14/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fRateio()
Local lRet := .T.

If (Select((cAliasTrb)) > 0)
	DbCloseArea((cAliasTrb))
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  13/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FICDVRAT(nOpc, cNum)
Local aArea     := {GetArea()}
Local lRet      := .T.
Local aButtons  := {}
Local aHeader   := {}
Local aCols     := {}
Local cNoCpos   := "Z0_NUMSV;Z0_CODCONT;Z0_CONTLIB"

Private oRateio

Default nOpc := 3

SX3->(DbSetOrder(1))
SX3->(DbSeek("SZ0"))
While ((SX3->(!Eof())) .And. (SX3->X3_ARQUIVO == "SZ0"))
	If ((X3USO(SX3->X3_USADO)) .And. (cNivel >= SX3->X3_NIVEL) .And. !(AllTrim(SX3->X3_CAMPO) $ cNoCpos))
		aAdd(aHeader,	{TRIM(SX3->X3_TITULO)	,;
						SX3->X3_CAMPO			,;
						SX3->X3_PICTURE			,;
						SX3->X3_TAMANHO			,;
						SX3->X3_DECIMAL			,;
						SX3->X3_VALID			,;
						SX3->X3_USADO			,;
						SX3->X3_TIPO			,;
						SX3->X3_F3				,;
						SX3->X3_CONTEXT			,;
						SX3->X3_CBOX			,;
						SX3->X3_RELACAO			,;
						SX3->X3_WHEN			,;
						SX3->X3_VISUAL			,;
						SX3->X3_VLDUSER			,;
						SX3->X3_PICTVAR			,;
						SX3->X3_OBRIGAT			})
	Endif
	
	SX3->(DbSkip())
Enddo

DbSelectArea((cAliasTrb))
(cAliasTrb)->(DbGoTop())

While ((cAliasTrb)->(!Eof()))
	aAdd(aCols, {(cAliasTrb)->(Z0_ITEM), (cAliasTrb)->(Z0_ITEMCTA), (cAliasTrb)->(Z0_CONTA), (cAliasTrb)->(Z0_CCUSTO), (cAliasTrb)->(Z0_PERC), (cAliasTrb)->(Z0_DEL)})

	(cAliasTrb)->(DbSkip())
Enddo

If ((Len(aCols) == 0) .And. (nOpc == 3))
	aAdd(aCols, {"001", M->Z1_ITEMCTA, M->Z1_CONTA, M->Z1_CCUSTO, 100, .F.})
Endif

Define MsDialog oDlg Title "Rateio de Viagens" From 0, 0 To 300, 600 Pixel

oRateio := MsNewGetDados():New(0, 0, 140, 302, GD_INSERT + GD_UPDATE + GD_DELETE, "U_FICDVLIN(5)", "AllwaysTrue()", ;
							"+Z0_ITEM", , , 999, "AllwaysTrue()", , , oDlg, aHeader, aCols)
If !((nOpc == 3) .Or. (nOpc == 4))
	oRateio:Disable()
Endif

//Activate MsDialog oDlg Center On Init (EnchoiceBar(oDlg, {|| Iif(nOpc != 2, FICDVRTC(cNum, oRateio:aCols, 1), )}, {|| FICDVRTC(, , 2)}, , @aButtons))
//Activate MsDialog oDlg Center On Init (EnchoiceBar(oDlg, {|| Iif(nOpc != 2, FICDVRTC(cNum, oRateio:aCols), ), oDlg:End()}, {|| oDlg:End()}, , @aButtons))
Activate MsDialog oDlg Center On Init (EnchoiceBar(oDlg, {|| Iif(nOpc != 2, FICDVRTC(cNum, oRateio:aCols, 1, @oDlg), FICDVRTC(, , 2, @oDlg))}, {|| FICDVRTC(, , 2, @oDlg)}, , @aButtons))

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  13/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FICDVRTC(cNum, oRateio, nOpc, oDlg)
Local aArea := {GetArea()}
Local lRet := .T.
Local nI := 0

Default cNum := ""
Default oRateio := {}
Default nOpc := 2

If (nOpc != 2)
	lRet := U_FICDVTOK(oRateio)
	
	If (lRet)
		DbSelectArea((cAliasTrb))
		(cAliasTrb)->(DbSetOrder(1))
		
		For nI := 1 To Len(oRateio)
			If ((cAliasTrb)->(DbSeek(oRateio[nI][1])))
				If !(oRateio[nI][6])
					RecLock((cAliasTrb), .F.)
					(cAliasTrb)->Z0_ITEM    := oRateio[nI][1]
					(cAliasTrb)->Z0_ITEMCTA := oRateio[nI][2]
					(cAliasTrb)->Z0_CONTA   := oRateio[nI][3]
					(cAliasTrb)->Z0_CCUSTO  := oRateio[nI][4]
					(cAliasTrb)->Z0_PERC    := oRateio[nI][5]
					(cAliasTrb)->Z0_DEL     := .F.
					(cAliasTrb)->(MsUnlock())
				Else
					RecLock((cAliasTrb), .F.)
					(cAliasTrb)->Z0_DEL     := .T.
					(cAliasTrb)->(MsUnlock())
				Endif
			Else
				If !(oRateio[nI][6])
					RecLock((cAliasTrb), .T.)
					(cAliasTrb)->Z0_ITEM    := oRateio[nI][1]
					(cAliasTrb)->Z0_ITEMCTA := oRateio[nI][2]
					(cAliasTrb)->Z0_CONTA   := oRateio[nI][3]
					(cAliasTrb)->Z0_CCUSTO  := oRateio[nI][4]
					(cAliasTrb)->Z0_PERC    := oRateio[nI][5]
					(cAliasTrb)->Z0_DEL     := .F.
					(cAliasTrb)->(MsUnlock())
				Endif
			Endif
		Next nI
	Endif
Endif

If (lRet)
	oDlg:End()
Endif

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*Static Function FICDVRTC(cNum, oRateio)
Local aArea := {GetArea()}
Local lRet := .T.
Local nI := 0

//lRet := U_FICDVTOK(oRateio)

//If (lRet)
	DbSelectArea((cAliasTrb))
	(cAliasTrb)->(DbSetOrder(1))
	
	For nI := 1 To Len(oRateio)
		If ((cAliasTrb)->(DbSeek(oRateio[nI][1])))
			If !(oRateio[nI][6])
				RecLock((cAliasTrb), .F.)
				(cAliasTrb)->Z0_ITEM    := oRateio[nI][1]
				(cAliasTrb)->Z0_ITEMCTA := oRateio[nI][2]
				(cAliasTrb)->Z0_CONTA   := oRateio[nI][3]
				(cAliasTrb)->Z0_CCUSTO  := oRateio[nI][4]
				(cAliasTrb)->Z0_PERC    := oRateio[nI][5]
				(cAliasTrb)->Z0_DEL     := .F.
				(cAliasTrb)->(MsUnlock())
			Else
				RecLock((cAliasTrb), .F.)
				(cAliasTrb)->Z0_DEL     := .T.
				(cAliasTrb)->(MsUnlock())
			Endif
		Else
			If !(oRateio[nI][6])
				RecLock((cAliasTrb), .T.)
				(cAliasTrb)->Z0_ITEM    := oRateio[nI][1]
				(cAliasTrb)->Z0_ITEMCTA := oRateio[nI][2]
				(cAliasTrb)->Z0_CONTA   := oRateio[nI][3]
				(cAliasTrb)->Z0_CCUSTO  := oRateio[nI][4]
				(cAliasTrb)->Z0_PERC    := oRateio[nI][5]
				(cAliasTrb)->Z0_DEL     := .F.
				(cAliasTrb)->(MsUnlock())
			Endif
		Endif
	Next nI
//Endif

aEval(aArea, {|x| RestArea(x)})
Return(lRet)*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  11/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICDVSEG()
Local lRet := .T.

If (oDadosSeg:oBrowse:nAt == 1)
	Aviso("Aviso", "Impossํvel excluir o Seguro Viagem do 1บ Viajante.", {"Ok"}, 1)
	lRet := .F.
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  11/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RejeiTot(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea()), SZ2->(GetArea()), SZ3->(GetArea()), SZ4->(GetArea()), SZ5->(GetArea()), SZ6->(GetArea())}
Local lRet := .T.

If (Aviso("Confirma็ใo", "Deseja realmente rejeitar totalmente esta Solicita็ใo de Viagens?", {"Sim", "Nใo"}, 1) == 1)
	DbSelectArea("SZ1")
	SZ1->(DbSetOrder(1))
	SZ1->(DbSeek(cFil + cNum))
	
	RecLock("SZ1", .F.)
	SZ1->Z1_STATUS := "R"
	SZ1->(MsUnlock())

	//ฺฤฤฤฤฤฤฤฤฤฟ
	//ณPassagensณ
	//ภฤฤฤฤฤฤฤฤฤู
	DbSelectArea("SZ2")
	SZ2->(DbSetOrder(1))
	SZ2->(DbSeek(cFil + cNum))
	
	While ((SZ2->(!Eof())) .And. (SZ2->Z2_FILIAL == cFil) .And. (SZ2->Z2_NUMSV == cNum))
		RecLock("SZ2", .F.)
		SZ2->Z2_STATUS := "R"
		SZ2->(MsUnlock())
		
		SZ2->(DbSkip())
	Enddo
	
	//ฺฤฤฤฤฤฤฟ
	//ณHot้isณ
	//ภฤฤฤฤฤฤู
	DbSelectArea("SZ3")
	SZ3->(DbSetOrder(1))
	SZ3->(DbSeek(cFil + cNum))
	
	While ((SZ3->(!Eof())) .And. (SZ3->Z3_FILIAL == cFil) .And. (SZ3->Z3_NUMSV == cNum))
		RecLock("SZ3", .F.)
		SZ3->Z3_STATUS := "R"
		SZ3->(MsUnlock())
		
		SZ3->(DbSkip())
	Enddo
	
	//ฺฤฤฤฤฤฤฤฤฟ
	//ณVeํculosณ
	//ภฤฤฤฤฤฤฤฤู
	DbSelectArea("SZ4")
	SZ4->(DbSetOrder(1))
	SZ4->(DbSeek(cFil + cNum))
	
	While ((SZ4->(!Eof())) .And. (SZ4->Z4_FILIAL == cFil) .And. (SZ4->Z4_NUMSV == cNum))
		RecLock("SZ4", .F.)
		SZ4->Z4_STATUS := "R"
		SZ4->(MsUnlock())
		
		SZ4->(DbSkip())
	Enddo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSeguro Viagemณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectArea("SZ5")
	SZ5->(DbSetOrder(1))
	SZ5->(DbSeek(cFil + cNum))
	
	While ((SZ5->(!Eof())) .And. (SZ5->Z5_FILIAL == cFil) .And. (SZ5->Z5_NUMSV == cNum))
		RecLock("SZ5", .F.)
		SZ5->Z5_STATUS := "R"
		SZ5->(MsUnlock())
		
		SZ5->(DbSkip())
	Enddo
Endif

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICDVLEG()
Local lRet := .T.
Local aArea := GetArea()

BrwLegenda(cCadastro, "Legenda", aCores)

RestArea(aArea)
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerGrp(cCentro, cGrupo)
Local aArea := {GetArea(), CTT->(GetArea())}

DbSelectArea("CTT")
CTT->(DbSetOrder(1))

If (CTT->(DbSeek(xFilial("CTT") + cCentro)))
	cGrupo := CTT->(CTT_XAPROV)
Endif

aEval(aArea, {|x| RestArea(x)})
Return(cGrupo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Fd_Entra(nE)
Local lRet := .T.
oFolder:SetOption(nE)
oFolder:Refresh()
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Fd_Sai(nE)
Local lRet := .T.
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICDVE01()
Local cFiltro := Iif(Iif(IsInCallStack("U_FICDVCOT"), SZ1->Z1_TIPO, M->Z1_TIPO) == "1", "B1_GRUPO == '" + GetMv("MV_XGRPNAC") + "'", "B1_GRUPO == '" + GetMv("MV_XGRPINT") + "'")
Return(cFiltro)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  05/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICDVVIA(cViajante, cCod, cLoja)
Local lRet := .T.
Local aArea := {GetArea()}

aColsSeg[1][2] := "1"
aColsSeg[1][3] := cViajante
aColsSeg[1][4] := Transform(Posicione("SA2", 1, xFilial("SA2") + cCod + cLoja, "A2_PFISICA"), PesqPict("SZ5", "Z5_RG"))
aColsSeg[1][5] := Transform(Posicione("SA2", 1, xFilial("SA2") + cCod + cLoja, "A2_CGC"), PesqPict("SZ5", "Z5_CPF"))
aColsSeg[1][6] := Posicione("SA2", 1, xFilial("SA2") + cCod + cLoja, "A2_XDTNASC")

//Transform(Posicione("SA2", 1, xFilial("SA2") + cCod + cLoja, "A2_XDTNASC"), PesqPict("SZ5", "Z5_DTNASC"))

oDadosSeg:aCols := aColsSeg
oDadosSeg:Refresh()

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  05/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICDVGRV(nOpc, cNum, dData, nTotal, nAdianta, cCodSol, cSolicit, cCodViaj, cLoja, cViajante, cObs, cGrupo, cTipo, cItem, cConta, cCentro, aDadosPass, aDadosHot, aDadosVei, aDadosSeg)
Local aArea     := {GetArea(), SZ1->(GetArea()), SZ2->(GetArea()), SZ3->(GetArea()), SZ4->(GetArea()), SZ5->(GetArea())}
Local lRet      := .T.
Local nI        := 0
Local lOpc      := .T.
Local nTotal    := 0
Local lAprv     := .F.
Local cEmCompr  := AllTrim(GetMv("FI_EMCOMPR"))
Local cBody     := ""

If (nOpc == 2)
	Return(lRet)
Endif

If (nOpc == 3)
	DbSelectArea((cAliasTrb))
	(cAliasTrb)->(DbSetOrder(1))
	(cAliasTrb)->(DbGoTop())
	
	If ((cAliasTrb)->(Eof()))
		RecLock((cAliasTrb), .T.)
		(cAliasTrb)->Z0_ITEM    := "001"
		(cAliasTrb)->Z0_ITEMCTA := M->Z1_ITEMCTA
		(cAliasTrb)->Z0_CONTA   := M->Z1_CONTA
		(cAliasTrb)->Z0_CCUSTO  := M->Z1_CCUSTO
		(cAliasTrb)->Z0_PERC    := 100
		(cAliasTrb)->Z0_DEL     := .F.
		(cAliasTrb)->(MsUnlock())
	Endif
	
	DbSelectArea((cAliasTrb))
	(cAliasTrb)->(DbSetOrder(1))
	(cAliasTrb)->(DbGoTop())
	
	While ((cAliasTrb)->(!Eof()))
		RecLock("SZ0", .T.)
		SZ0->Z0_FILIAL  := xFilial("SZ0")
		SZ0->Z0_NUMSV   := M->Z1_NUM
		SZ0->Z0_ITEM    := (cAliasTrb)->(Z0_ITEM)
		SZ0->Z0_ITEMCTA := (cAliasTrb)->(Z0_ITEMCTA)
		SZ0->Z0_CONTA   := (cAliasTrb)->(Z0_CONTA)
		SZ0->Z0_CCUSTO  := (cAliasTrb)->(Z0_CCUSTO)
		SZ0->Z0_PERC    := (cAliasTrb)->(Z0_PERC)
		SZ0->(MsUnlock())
		
		(cAliasTrb)->(DbSkip())
	Enddo
Elseif (nOpc == 4)
	DbSelectArea((cAliasTrb))
	(cAliasTrb)->(DbSetOrder(1))
	(cAliasTrb)->(DbGoTop())
	
	While ((cAliasTrb)->(!Eof()))
		DbSelectArea("SZ0")
		SZ0->(DbSetOrder(1))

		If (SZ0->(DbSeek(xFilial("SZ0") + M->Z1_NUM + (cAliasTrb)->(Z0_ITEM))))
				If !((cAliasTrb)->(Z0_DEL))
					RecLock("SZ0", .F.)
					SZ0->Z0_FILIAL  := xFilial("SZ0")
					SZ0->Z0_NUMSV   := M->Z1_NUM
					SZ0->Z0_ITEM    := (cAliasTrb)->(Z0_ITEM)
					SZ0->Z0_ITEMCTA := (cAliasTrb)->(Z0_ITEMCTA)
					SZ0->Z0_CONTA   := (cAliasTrb)->(Z0_CONTA)
					SZ0->Z0_CCUSTO  := (cAliasTrb)->(Z0_CCUSTO)
					SZ0->Z0_PERC    := (cAliasTrb)->(Z0_PERC)
					SZ0->(MsUnlock())
				Else
					RecLock("SZ0", .F.)
					SZ0->(DbDelete())
					SZ0->(MsUnlock())
				Endif
		Else
			If !((cAliasTrb)->(Z0_DEL))
				RecLock("SZ0", .T.)
				SZ0->Z0_FILIAL  := xFilial("SZ0")
				SZ0->Z0_NUMSV   := M->Z1_NUM
				SZ0->Z0_ITEM    := (cAliasTrb)->(Z0_ITEM)
				SZ0->Z0_ITEMCTA := (cAliasTrb)->(Z0_ITEMCTA)
				SZ0->Z0_CONTA   := (cAliasTrb)->(Z0_CONTA)
				SZ0->Z0_CCUSTO  := (cAliasTrb)->(Z0_CCUSTO)
				SZ0->Z0_PERC    := (cAliasTrb)->(Z0_PERC)
				SZ0->(MsUnlock())				
			Endif
		Endif
		
		(cAliasTrb)->(DbSkip())
	Enddo
Endif

DbSelectArea("SZ1")
SZ1->(DbSetOrder(1))

lOpc := .T.

If (DbSeek(xFilial("SZ1") + M->Z1_NUM))
	lOpc := .F.
Endif

RecLock("SZ1", lOpc)
SZ1->Z1_FILIAL  := xFilial("SZ1")
SZ1->Z1_NUM     := M->Z1_NUM
SZ1->Z1_DATA    := M->Z1_DATA
SZ1->Z1_DTFIM   := M->Z1_DTFIM
SZ1->Z1_TOTAL   := M->Z1_TOTAL
SZ1->Z1_ADIANTA := M->Z1_ADIANTA
SZ1->Z1_SOLICIT := M->Z1_SOLICIT
SZ1->Z1_NOMSOL  := M->Z1_NOMSOL
SZ1->Z1_CODVIAJ := M->Z1_CODVIAJ
SZ1->Z1_LOJAVIA := M->Z1_LOJAVIA
SZ1->Z1_NOMVIAJ := M->Z1_NOMVIAJ
SZ1->Z1_OBS     := M->Z1_OBS
SZ1->Z1_JUSTIFI := M->Z1_JUSTIFI
SZ1->Z1_GRPAPRV := M->Z1_GRPAPRV
SZ1->Z1_TIPO    := M->Z1_TIPO
SZ1->Z1_ITEMCTA := M->Z1_ITEMCTA
SZ1->Z1_CONTA   := M->Z1_CONTA
SZ1->Z1_CCUSTO  := M->Z1_CCUSTO
SZ1->Z1_TPVIAJA := M->Z1_TPVIAJA
SZ1->Z1_APROV   := M->Z1_APROV
SZ1->Z1_NOMAPR  := M->Z1_NOMAPR
If (nOpc != 6)
	SZ1->Z1_STATUS  := "E"
Endif
SZ1->(MsUnlock())

nTotal += M->Z1_ADIANTA

For nI := 1 To Len(aDadosPass)
	If (nOpc == 6)
		If !(Empty(aDadosPass[nI, 2]))
			If (aDadosPass[nI, 17])
				DbSelectArea("SZ2")
				SZ2->(DbSetOrder(1))
				
				lOpc := .T.
				
				If (DbSeek(xFilial("SZ2") + M->Z1_NUM + aDadosPass[nI, 1]))
					lOpc := .F.
				Endif
				
				RecLock("SZ2", lOpc)
				SZ2->Z2_STATUS  := "R"
				SZ2->(MsUnlock())
			
				nTotal -= aDadosPass[nI, 16]
			Else
				DbSelectArea("SZ2")
				SZ2->(DbSetOrder(1))
				
				lOpc := .T.
				
				If (DbSeek(xFilial("SZ2") + M->Z1_NUM + aDadosPass[nI, 1]))
					lOpc := .F.
				Endif
				
				RecLock("SZ2", lOpc)
				SZ2->Z2_STATUS  := "A"
				SZ2->(MsUnlock())
			
				nTotal += aDadosPass[nI, 16]
				
				lAprv := .T.
			Endif
		Endif
	Else
		If !(Empty(aDadosPass[nI, 2]))
			DbSelectArea("SZ2")
			SZ2->(DbSetOrder(1))
			
			lOpc := .T.
			
			If (DbSeek(xFilial("SZ2") + M->Z1_NUM + aDadosPass[nI, 1]))
				lOpc := .F.
			Endif
			
			RecLock("SZ2", lOpc)
			SZ2->Z2_FILIAL  := xFilial("SZ2")
			SZ2->Z2_ITEM    := aDadosPass[nI, 1]
			SZ2->Z2_PRODUTO := aDadosPass[nI, 2]
			SZ2->Z2_TRECHO  := aDadosPass[nI, 3]
			SZ2->Z2_DATA    := aDadosPass[nI, 4]
			SZ2->Z2_HORA    := aDadosPass[nI, 5]
			SZ2->Z2_DATACH  := aDadosPass[nI, 6]
			SZ2->Z2_HORACH  := aDadosPass[nI, 7]
			SZ2->Z2_CLASSE  := aDadosPass[nI, 8]
			SZ2->Z2_TICKET  := aDadosPass[nI, 9]
			SZ2->Z2_VOO     := aDadosPass[nI, 10]
			SZ2->Z2_COMPANH := aDadosPass[nI, 11]
			SZ2->Z2_LOCALIZ := aDadosPass[nI, 12]
			SZ2->Z2_FORNECE := aDadosPass[nI, 13]
			SZ2->Z2_LOJA    := aDadosPass[nI, 14]
			SZ2->Z2_NOME    := aDadosPass[nI, 15]
			SZ2->Z2_VALOR   := aDadosPass[nI, 16]
			SZ2->Z2_NUMSV   := M->Z1_NUM
			SZ2->(MsUnlock())
			
			If (aDadosPass[nI, 17])
				RecLock("SZ2", .F.)
				SZ2->(DbDelete())
				SZ2->(MsUnlock())
				
				nTotal -= aDadosPass[nI, 16]
			Else
				nTotal += aDadosPass[nI, 16]
			Endif
		Endif
	Endif
Next nI

For nI := 1 To Len(aDadosHot)
	If (nOpc == 6)
		If !(Empty(aDadosHot[nI, 2]))
			If (aDadosHot[nI, 13])
				DbSelectArea("SZ3")
				SZ3->(DbSetOrder(1))
				
				lOpc := .T.
				
				If (DbSeek(xFilial("SZ3") + M->Z1_NUM + aDadosHot[nI, 1]))
					lOpc := .F.
				Endif
			
				RecLock("SZ3", lOpc)
				SZ3->Z3_STATUS  := "R"
				SZ3->(MsUnlock())
				
				nTotal -= aDadosHot[nI, 12]
			Else
				DbSelectArea("SZ3")
				SZ3->(DbSetOrder(1))
				
				lOpc := .T.
				
				If (DbSeek(xFilial("SZ3") + M->Z1_NUM + aDadosHot[nI, 1]))
					lOpc := .F.
				Endif
			
				RecLock("SZ3", lOpc)
				SZ3->Z3_STATUS  := "A"
				SZ3->(MsUnlock())
				
				nTotal += aDadosHot[nI, 12]
				
				lAprv := .T.
			Endif
		Endif
	Else
		If !(Empty(aDadosHot[nI, 2]))
			DbSelectArea("SZ3")
			SZ3->(DbSetOrder(1))
			
			lOpc := .T.
			
			If (DbSeek(xFilial("SZ3") + M->Z1_NUM + aDadosHot[nI, 1]))
				lOpc := .F.
			Endif
		
			RecLock("SZ3", lOpc)
			SZ3->Z3_FILIAL  := xFilial("SZ3")
			SZ3->Z3_ITEM    := aDadosHot[nI, 1]
			SZ3->Z3_PRODUTO := aDadosHot[nI, 2]
			SZ3->Z3_DESCRI  := aDadosHot[nI, 3]
			SZ3->Z3_FORNECE := aDadosHot[nI, 4]
			SZ3->Z3_LOJA    := aDadosHot[nI, 5]
			SZ3->Z3_NOME    := aDadosHot[nI, 6]
			SZ3->Z3_DIARIAS := aDadosHot[nI, 7]
			SZ3->Z3_CHECKIN := aDadosHot[nI, 8]
			SZ3->Z3_CHECKOU := aDadosHot[nI, 9]
			SZ3->Z3_OBS     := aDadosHot[nI, 10]
			SZ3->Z3_CONFIRM := aDadosHot[nI, 11]
			SZ3->Z3_VALOR   := aDadosHot[nI, 12]
			SZ3->Z3_NUMSV   := M->Z1_NUM
			SZ3->(MsUnlock())
			
			nTotal += aDadosHot[nI, 12]
			
			If (aDadosHot[nI, 13])
				RecLock("SZ3", .F.)
				SZ3->(DbDelete())
				SZ3->(MsUnlock())
				
				nTotal -= aDadosHot[nI, 12]
			Endif
		Endif
	Endif
Next nI

For nI := 1 To Len(aDadosVei)
	If (nOpc == 6)
		If !(Empty(aDadosVei[nI, 2]))
			If (aDadosVei[nI, 13])
				DbSelectArea("SZ4")
				SZ4->(DbSetOrder(1))
				
				lOpc := .T.
				
				If (DbSeek(xFilial("SZ4") + M->Z1_NUM + aDadosVei[nI, 1]))
					lOpc := .F.
				Endif
				
				RecLock("SZ4", lOpc)
				SZ4->Z4_STATUS := "R"
				SZ4->(MsUnlock())
				
				nTotal -= aDadosVei[nI, 12]
			Else
				DbSelectArea("SZ4")
				SZ4->(DbSetOrder(1))
				
				lOpc := .T.
				
				If (DbSeek(xFilial("SZ4") + M->Z1_NUM + aDadosVei[nI, 1]))
					lOpc := .F.
				Endif
				
				RecLock("SZ4", lOpc)
				SZ4->Z4_STATUS := "A"
				SZ4->(MsUnlock())
				
				nTotal += aDadosVei[nI, 12]
				
				lAprv := .T.
			Endif
		Endif
	Else
		If !(Empty(aDadosVei[nI, 2]))
			DbSelectArea("SZ4")
			SZ4->(DbSetOrder(1))
			
			lOpc := .T.
			
			If (DbSeek(xFilial("SZ4") + M->Z1_NUM + aDadosVei[nI, 1]))
				lOpc := .F.
			Endif
			
			RecLock("SZ4", lOpc)
			SZ4->Z4_FILIAL  := xFilial("SZ4")
			SZ4->Z4_ITEM    := aDadosVei[nI, 1]
			SZ4->Z4_PRODUTO := aDadosVei[nI, 2]
			SZ4->Z4_DESCRI  := aDadosVei[nI, 3]
			SZ4->Z4_FORNECE := aDadosVei[nI, 4]
			SZ4->Z4_LOJA    := aDadosVei[nI, 5]
			SZ4->Z4_NOME    := aDadosVei[nI, 6]
			SZ4->Z4_RETIRA  := aDadosVei[nI, 7]
			SZ4->Z4_HORARET := aDadosVei[nI, 8]
			SZ4->Z4_DEVOLU  := aDadosVei[nI, 9]
			SZ4->Z4_HORADEV := aDadosVei[nI, 10]
			SZ4->Z4_CONFIRM := aDadosVei[nI, 11]
			SZ4->Z4_VALOR   := aDadosVei[nI, 12]
			SZ4->Z4_NUMSV   := M->Z1_NUM
			SZ4->(MsUnlock())
			
			nTotal += aDadosVei[nI, 12]
			
			If (aDadosVei[nI, 13])
				RecLock("SZ4", .F.)
				SZ4->(DbDelete())
				SZ4->(MsUnlock())
				
				nTotal -= aDadosVei[nI, 12]
			Endif
		Endif
	Endif
Next nI

For nI := 1 To Len(aDadosSeg)
	If (nOpc == 6)
		If (aDadosSeg[nI, 7])
			DbSelectArea("SZ5")
			SZ5->(DbSetOrder(1))
			
			lOpc := .T.
			
			If (DbSeek(xFilial("SZ5") + M->Z1_NUM + aDadosSeg[nI, 1]))
				lOpc := .F.
			Endif
			
			RecLock("SZ5", lOpc)
			SZ5->Z5_STATUS  := "R"
			SZ5->(MsUnlock())
		Else
			DbSelectArea("SZ5")
			SZ5->(DbSetOrder(1))
			
			lOpc := .T.
			
			If (DbSeek(xFilial("SZ5") + M->Z1_NUM + aDadosSeg[nI, 1]))
				lOpc := .F.
			Endif
			
			RecLock("SZ5", lOpc)
			SZ5->Z5_STATUS  := "A"
			SZ5->(MsUnlock())
			
			lAprv := .T.
		Endif
	Else
		DbSelectArea("SZ5")
		SZ5->(DbSetOrder(1))
		
		lOpc := .T.
		
		If (DbSeek(xFilial("SZ5") + M->Z1_NUM + aDadosSeg[nI, 1]))
			lOpc := .F.
		Endif
		
		RecLock("SZ5", lOpc)
		SZ5->Z5_FILIAL  := xFilial("SZ5")
		SZ5->Z5_ITEM    := aDadosSeg[nI, 1]
		SZ5->Z5_TIPO    := aDadosSeg[nI, 2]
		SZ5->Z5_NOME    := aDadosSeg[nI, 3]
		SZ5->Z5_RG      := aDadosSeg[nI, 4]
		SZ5->Z5_CPF     := aDadosSeg[nI, 5]
		SZ5->Z5_DTNASC  := aDadosSeg[nI, 6]
		SZ5->Z5_NUMSV   := M->Z1_NUM
		SZ5->(MsUnlock())
		
		If (aDadosSeg[nI, 7])
			RecLock("SZ5", .F.)
			SZ5->(DbDelete())
			SZ5->(MsUnlock())
		Endif
	Endif
Next nI

DbSelectArea("SZ1")
SZ1->(DbSetOrder(1))

lOpc := .T.

If (DbSeek(xFilial("SZ1") + M->Z1_NUM))
	lOpc := .F.
Endif

RecLock("SZ1", lOpc)
SZ1->Z1_TOTAL := nTotal
If (nOpc == 6)
	If (lAprv)
		SZ1->Z1_STATUS := "C"
	Else
		SZ1->Z1_STATUS := "R"
	Endif
Endif
SZ1->(MsUnlock())

If (lAprv)
	cBody := "Prezado(a) Comprador(a)," + CRLF + CRLF
	cBody += "Informamos que existe a Solicita็ใo de Viagem nบ '" + M->Z1_NUM + "' para sua cota็ใo."
	ACSendMail(, , , , cEmCompr, "SV " + M->Z1_NUM + "", cBody)
			
	Aviso("Aviso", "Aprova็ใo realizada com sucesso.", {"Ok"}, 1)
Endif

If (nOpc != 6)
	Aviso("Confirma็ใo", "Dados gravados com sucesso.", {"Ok"}, 1)
Endif

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  05/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function retCab(cFil, cNumero)
Local aArea := {GetArea()}
Local lRet := .T.
Local aDados := {}
Local cQuery := ""
Local cTab := ""

cQuery := "SELECT" + CRLF
cQuery += "Z1_NUM," + CRLF
cQuery += "Z1_DATA," + CRLF
cQuery += "Z1_TOTAL," + CRLF
cQuery += "Z1_ADIANTA," + CRLF
cQuery += "Z1_SOLICIT," + CRLF
cQuery += "Z1_NOMSOL," + CRLF
cQuery += "Z1_CODVIAJ," + CRLF
cQuery += "Z1_LOJAVIA," + CRLF
cQuery += "Z1_NOMVIAJ," + CRLF
cQuery += "Z1_GRPAPRV," + CRLF
cQuery += "Z1_TIPO," + CRLF
cQuery += "Z1_ITEMCTA," + CRLF
cQuery += "Z1_CONTA," + CRLF
cQuery += "Z1_CCUSTO" + CRLF
cQuery += "FROM " + RetSQLName("SZ1") + "" + CRLF
cQuery += "WHERE Z1_FILIAL = '" + cFil + "'" + CRLF
cQuery += "AND Z1_NUM = '" + cNumero + "'" + CRLF
cQuery += "AND D_E_L_E_T_ = ''"

cQuery := ChangeQuery(cQuery)

cTab := GetNextAlias()

TcQUERY cQuery NEW ALIAS ((cTab))

DbSelectArea((cTab))
(cTab)->(DbGoTop())

While ((cTab)->(!Eof()))
	aAdd(aDados, {(cTab)->(Z1_NUM), SToD((cTab)->(Z1_DATA)), (cTab)->(Z1_TOTAL), (cTab)->(Z1_ADIANTA), (cTab)->(Z1_SOLICIT), ;
					(cTab)->(Z1_NOMSOL), (cTab)->(Z1_CODVIAJ), (cTab)->(Z1_LOJAVIA), (cTab)->(Z1_NOMVIAJ), (cTab)->(Z1_GRPAPRV), ;
					(cTab)->(Z1_TIPO), (cTab)->(Z1_ITEMCTA), (cTab)->(Z1_CONTA), (cTab)->(Z1_CCUSTO)})
	
	(cTab)->(DbSkip())
Enddo

(cTab)->(DbCloseArea())

aEval(aArea, {|x| RestArea(x)})
Return(aDados)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  05/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function retPass(cFil, cNumero)
Local aArea := {GetArea()}
Local lRet := .T.
Local aDados := {}
Local cQuery := ""
Local cTab := ""

cQuery := "SELECT" + CRLF
cQuery += "Z2_ITEM," + CRLF
cQuery += "Z2_PRODUTO," + CRLF
cQuery += "Z2_TRECHO," + CRLF
cQuery += "Z2_DATA," + CRLF
cQuery += "Z2_HORA," + CRLF
cQuery += "Z2_DATACH," + CRLF
cQuery += "Z2_HORACH," + CRLF
cQuery += "Z2_CLASSE," + CRLF
cQuery += "Z2_TICKET," + CRLF
cQuery += "Z2_VOO," + CRLF
cQuery += "Z2_COMPANH," + CRLF
cQuery += "Z2_LOCALIZ," + CRLF
cQuery += "Z2_FORNECE," + CRLF
cQuery += "Z2_LOJA," + CRLF
cQuery += "Z2_NOME," + CRLF
cQuery += "Z2_VALOR," + CRLF
cQuery += "Z2_STATUS" + CRLF
cQuery += "FROM " + RetSQLName("SZ2") + "" + CRLF
cQuery += "WHERE Z2_FILIAL = '" + cFil + "'" + CRLF
cQuery += "AND Z2_NUMSV = '" + cNumero + "'" + CRLF
cQuery += "AND Z2_ITEM NOT IN ('999')" + CRLF
cQuery += "AND D_E_L_E_T_ = ''"

cQuery := ChangeQuery(cQuery)

cTab := GetNextAlias()

TcQuery cQuery NEW ALIAS ((cTab))

DbSelectArea((cTab))
(cTab)->(DbGoTop())

aDados := {}

While ((cTab)->(!Eof()))
	aAdd(aDados, {(cTab)->(Z2_ITEM), (cTab)->(Z2_PRODUTO), (cTab)->(Z2_TRECHO), SToD((cTab)->(Z2_DATA)), (cTab)->(Z2_HORA), ;
				SToD((cTab)->(Z2_DATACH)), (cTab)->(Z2_HORACH), ;
				(cTab)->(Z2_CLASSE), (cTab)->(Z2_TICKET), (cTab)->(Z2_VOO), (cTab)->(Z2_COMPANH), (cTab)->(Z2_LOCALIZ), ;
				(cTab)->(Z2_FORNECE), (cTab)->(Z2_LOJA), (cTab)->(Z2_NOME), (cTab)->(Z2_VALOR), ;
				Iif((Empty((cTab)->(Z2_STATUS))) .Or. ((cTab)->(Z2_STATUS) == "A"), .F., .T.) })

	(cTab)->(DbSkip())
Enddo

(cTab)->(DbCloseArea())

aEval(aArea, {|x| RestArea(x)})
Return(aDados)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  05/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function retHot(cFil, cNumero)
Local aArea := {GetArea()}
Local lRet := .T.
Local aDados := {}
Local cQuery := ""
Local cTab := ""

cQuery := "SELECT" + CRLF
cQuery += "Z3_ITEM," + CRLF
cQuery += "Z3_PRODUTO," + CRLF
cQuery += "Z3_DESCRI," + CRLF
cQuery += "Z3_FORNECE," + CRLF
cQuery += "Z3_LOJA," + CRLF
cQuery += "Z3_NOME," + CRLF
cQuery += "Z3_DIARIAS," + CRLF
cQuery += "Z3_CHECKIN," + CRLF
cQuery += "Z3_CHECKOU," + CRLF
cQuery += "CONVERT(VARCHAR(4000), CONVERT(VARBINARY(4000), Z3_OBS)) AS Z3_OBS," + CRLF
cQuery += "Z3_CONFIRM," + CRLF
cQuery += "Z3_VALOR," + CRLF
cQuery += "Z3_STATUS" + CRLF
cQuery += "FROM " + RetSQLName("SZ3") + "" + CRLF
cQuery += "WHERE Z3_FILIAL = '" + cFil + "'" + CRLF
cQuery += "AND Z3_NUMSV = '" + cNumero + "'" + CRLF
cQuery += "AND Z3_ITEM NOT IN ('999')" + CRLF
cQuery += "AND D_E_L_E_T_ = ''"

cQuery := ChangeQuery(cQuery)

cTab := GetNextAlias()

TcQuery cQuery NEW ALIAS ((cTab))

DbSelectArea((cTab))
(cTab)->(DbGoTop())

aDados := {}

While ((cTab)->(!Eof()))
	aAdd(aDados, {(cTab)->(Z3_ITEM), (cTab)->(Z3_PRODUTO), (cTab)->(Z3_DESCRI), (cTab)->(Z3_FORNECE), (cTab)->(Z3_LOJA), ;
				(cTab)->(Z3_NOME), (cTab)->(Z3_DIARIAS), SToD((cTab)->(Z3_CHECKIN)), SToD((cTab)->(Z3_CHECKOU)), (cTab)->(Z3_OBS), ;
				(cTab)->(Z3_CONFIRM), (cTab)->(Z3_VALOR), Iif((Empty((cTab)->(Z3_STATUS))) .Or. ((cTab)->(Z3_STATUS) == "A"), .F., .T.) })

	(cTab)->(DbSkip())
Enddo

(cTab)->(DbCloseArea())

aEval(aArea, {|x| RestArea(x)})
Return(aDados)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  05/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function retVei(cFil, cNumero)
Local aArea := {GetArea()}
Local lRet := .T.
Local aDados := {}
Local cQuery := ""
Local cTab := ""

cQuery := "SELECT" + CRLF
cQuery += "Z4_ITEM," + CRLF
cQuery += "Z4_PRODUTO," + CRLF
cQuery += "Z4_DESCRI," + CRLF
cQuery += "Z4_FORNECE," + CRLF
cQuery += "Z4_LOJA," + CRLF
cQuery += "Z4_NOME," + CRLF
cQuery += "Z4_RETIRA," + CRLF
cQuery += "Z4_HORARET," + CRLF
cQuery += "Z4_DEVOLU," + CRLF
cQuery += "Z4_HORADEV," + CRLF
cQuery += "Z4_CONFIRM," + CRLF
cQuery += "Z4_VALOR," + CRLF
cQuery += "Z4_STATUS" + CRLF
cQuery += "FROM " + RetSQLName("SZ4") + "" + CRLF
cQuery += "WHERE Z4_FILIAL = '" + cFil + "'" + CRLF
cQuery += "AND Z4_NUMSV = '" + cNumero + "'" + CRLF
cQuery += "AND Z4_ITEM NOT IN ('999')" + CRLF
cQuery += "AND D_E_L_E_T_ = ''"

cQuery := ChangeQuery(cQuery)

cTab := GetNextAlias()

TcQuery cQuery NEW ALIAS ((cTab))

DbSelectArea((cTab))
(cTab)->(DbGoTop())

aDados := {}

While ((cTab)->(!Eof()))
	aAdd(aDados, {(cTab)->(Z4_ITEM), (cTab)->(Z4_PRODUTO), (cTab)->(Z4_DESCRI), (cTab)->(Z4_FORNECE), (cTab)->(Z4_LOJA), ;
				(cTab)->(Z4_NOME), SToD((cTab)->(Z4_RETIRA)), (cTab)->(Z4_HORARET), SToD((cTab)->(Z4_DEVOLU)), (cTab)->(Z4_HORADEV), ;
				(cTab)->(Z4_CONFIRM), (cTab)->(Z4_VALOR), Iif((Empty((cTab)->(Z4_STATUS))) .Or. ((cTab)->(Z4_STATUS) == "A"), .F., .T.)})

	(cTab)->(DbSkip())
Enddo

(cTab)->(DbCloseArea())

aEval(aArea, {|x| RestArea(x)})
Return(aDados)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  05/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function retSeg(cFil, cNumero)
Local aArea := {GetArea()}
Local lRet := .T.
Local aDados := {}
Local cQuery := ""
Local cTab := ""

cQuery := "SELECT" + CRLF
cQuery += "Z5_ITEM," + CRLF
cQuery += "Z5_TIPO," + CRLF
cQuery += "Z5_NOME," + CRLF
cQuery += "Z5_RG," + CRLF
cQuery += "Z5_CPF," + CRLF
cQuery += "Z5_DTNASC," + CRLF
cQuery += "Z5_STATUS" + CRLF
cQuery += "FROM " + RetSQLName("SZ5") + "" + CRLF
cQuery += "WHERE Z5_FILIAL = '" + cFil + "'" + CRLF
cQuery += "AND Z5_NUMSV = '" + cNumero + "'" + CRLF
cQuery += "AND D_E_L_E_T_ = ''"

cQuery := ChangeQuery(cQuery)

cTab := GetNextAlias()

TcQuery cQuery NEW ALIAS ((cTab))

DbSelectArea((cTab))
(cTab)->(DbGoTop())

aDados := {}

While ((cTab)->(!Eof()))
	aAdd(aDados, {(cTab)->(Z5_ITEM), (cTab)->(Z5_TIPO), (cTab)->(Z5_NOME), (cTab)->(Z5_RG), (cTab)->(Z5_CPF), ;
				SToD((cTab)->(Z5_DTNASC)), Iif((Empty((cTab)->(Z5_STATUS))) .Or. ((cTab)->(Z5_STATUS) == "A"), .F., .T.)})

	(cTab)->(DbSkip())
Enddo

(cTab)->(DbCloseArea())

aEval(aArea, {|x| RestArea(x)})
Return(aDados)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  05/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICDVAPR(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea()), SZ2->(GetArea()), SZ3->(GetArea()), SZ4->(GetArea()), SZ5->(GetArea())}
Local lRet := .T.

If !(SZ1->Z1_SOLICIT $ __cUserId)
	Aviso("Aviso", "Este usuแrio nใo possui permissใo para Enviar para Compras.", {"Ok"}, 1)
	lRet := .F.
Endif

If (lRet)
	If !(SZ1->Z1_STATUS $ "E")
		Aviso("Aviso", "Esta SV nใo estแ disponํvel para Enviar para Compras.", {"Ok"}, 1)
		lRet := .F.
	Endif
	
	If (lRet)
		If (Aviso("Confirma็ใo", "Deseja Enviar para Compras?", {"Sim", "Nใo"}, 1) == 1)
			DbSelectArea("SZ1")
			SZ1->(DbSetOrder(1))
			If (SZ1->(DbSeek(cFil + cNum)))
				RecLock("SZ1", .F.)
				SZ1->Z1_STATUS := "C"
				SZ1->(MsUnlock())
				
				DbSelectArea("SZ2")
				SZ2->(DbSetOrder(1))
				If (SZ2->(DbSeek(cFil + cNum)))
					While ((SZ2->(!Eof())) .And. (cFil == SZ2->Z2_FILIAL) .And. (cNum == SZ2->Z2_NUMSV))
						RecLock("SZ2", .F.)
						SZ2->Z2_STATUS := "A"
						SZ2->(MsUnlock())
					
						SZ2->(DbSkip())
					Enddo
				Endif
				
				DbSelectArea("SZ3")
				SZ3->(DbSetOrder(1))
				If (SZ3->(DbSeek(cFil + cNum)))
					While ((SZ3->(!Eof())) .And. (cFil == SZ3->Z3_FILIAL) .And. (cNum == SZ3->Z3_NUMSV))
						RecLock("SZ3", .F.)
						SZ3->Z3_STATUS := "A"
						SZ3->(MsUnlock())
					
						SZ3->(DbSkip())
					Enddo
				Endif
				
				DbSelectArea("SZ4")
				SZ4->(DbSetOrder(1))
				If (SZ4->(DbSeek(cFil + cNum)))
					While ((SZ4->(!Eof())) .And. (cFil == SZ4->Z4_FILIAL) .And. (cNum == SZ4->Z4_NUMSV))
						RecLock("SZ4", .F.)
						SZ4->Z4_STATUS := "A"
						SZ4->(MsUnlock())
					
						SZ4->(DbSkip())
					Enddo
				Endif
			Endif
		Endif
	Endif
Endif

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*User Function FICDVAPR(cFil, cNum, nOpc)
Local aArea := {GetArea(), SZ1->(GetArea()), SA2->(GetArea())}
Local lRet := .T.
Local cSuperior := ""
Local cEmail := ""
Local cBody := ""

If !(SZ1->Z1_SOLICIT $ __cUserId)
	Aviso("Aviso", "Este usuแrio nใo possui permissใo para Enviar para Aprova็ใo.", {"Ok"}, 1)
	lRet := .F.
Endif

If (lRet)
	If (nOpc == 1)
		DbSelectArea("SZ1")
		SZ1->(DbSetOrder(1))
		SZ1->(DbSeek(cFil + cNum))
		
		If !(SZ1->Z1_STATUS $ "E")
			Aviso("Aviso", "Somente SV Em Elabora็ใo pode ser enviada aprova็ใo.", {"Ok"}, 1)
			lRet := .F.
		Endif
		
		If (lRet)
			cSuperior := Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_XSUPVIA")
			
			If (Empty(cSuperior))
				Aviso("Aviso", "Este usuแrio nใo possui aprovador.", {"Ok"}, 1)
				lRet := .F.
			Endif
			
			If (lRet)
				If (Aviso("Confirma็ใo", "Deseja enviar para aprova็ใo?", {"Sim", "Nใo"}, 1) == 1)
					cEmail := AllTrim(UsrRetMail(cSuperior))
					cBody := "Prezado(a) " + UsrRetName(cSuperior) + "," + CRLF + CRLF
					cBody += "Informamos que existe a Solicita็ใo de Viagem nบ '" + cNum + "' para sua aprova็ใo."
					ACSendMail(, , , , cEmail, "SV " + cNum + "", cBody)
					
					DbSelectArea("SZ1")
					SZ1->(DbSetOrder(1))
					SZ1->(DbSeek(cFil + cNum))
					
					RecLock("SZ1", .F.)
					SZ1->Z1_STATUS := "A"
					SZ1->(MsUnlock())
					
					Aviso("Confirma็ใo", "SV enviada para aprova็ใo.", {"Ok"}, 1)
				Endif
			Endif
		Endif
	Endif
Endif

aEval(aArea, {|x| RestArea(x)})
Return(lRet)*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณMicrosiga           บ Data ณ  05/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICDVCAN(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea()), SE2->(GetArea()), SC7->(GetArea())}
Local lRet := .T.
Local cQuery := ""
Local cTab := ""
Local aSE2 := {}
Local aCab := {}
Local aLinha := {}
Local aItens := {}
Local cTab2 := ""

Private lMsErroAuto := .F.
     
If !(SZ1->Z1_SOLICIT $ __cUserId)
	Aviso("Aviso", "Este usuแrio nใo possui permissใo para Cancelar.", {"Ok"}, 1)
	lRet := .F.
Endif
     
If (lRet)
	If (SZ1->Z1_STATUS == "W")
		Aviso("Aviso", "Solicita็ใo de Viagem jแ encerrada.", {"Ok"}, 1)
		lRet := .F.
	Endif
Endif

If (lRet)
	If (Aviso("Confirma็ใo", "Confirma cancelamento?", {"Sim", "Nใo"}, 1) == 1)
		BEGIN TRANSACTION
	
		cQuery := "SELECT" + CRLF
		cQuery += "E2_PREFIXO," + CRLF
		cQuery += "E2_NUM," + CRLF
		cQuery += "E2_TIPO," + CRLF
		cQuery += "E2_NATUREZ," + CRLF
		cQuery += "E2_FORNECE," + CRLF
		cQuery += "E2_LOJA," + CRLF
		cQuery += "E2_EMISSAO," + CRLF
		cQuery += "E2_VENCTO," + CRLF
		cQuery += "E2_VENCREA," + CRLF
		cQuery += "E2_VALOR," + CRLF
		cQuery += "E2_XNUMSV," + CRLF
		cQuery += "E2_ORIGEM" + CRLF
		cQuery += "FROM " + RetSQLName("SE2") + "" + CRLF
		cQuery += "WHERE E2_FILIAL = '" + cFil + "'" + CRLF
		cQuery += "AND E2_XNUMSV = '" + cNum + "'" + CRLF
		cQuery += "AND D_E_L_E_T_ = ''"
		
		cQuery := ChangeQuery(cQuery)
		
		cTab := GetNextAlias()
		
		TcQUERY cQuery NEW ALIAS ((cTab))
		
		DbSelectArea((cTab))
		(cTab)->(DbGoTop())
	
		While ((cTab)->(!Eof()))
			If (lRet)
				aSE2 := {{"E2_FILIAL", cFil                      , Nil},; 
						{"E2_PREFIXO", (cTab)->(E2_PREFIXO)      , Nil},; 
						{"E2_NUM"    , cNum                       , Nil},; 
						{"E2_TIPO"   , (cTab)->(E2_TIPO)         , Nil},; 
						{"E2_NATUREZ", (cTab)->(E2_NATUREZ)      , Nil},; 
						{"E2_FORNECE", (cTab)->(E2_FORNECE)      , Nil},; 
						{"E2_LOJA"   , (cTab)->(E2_LOJA)         , Nil},; 
						{"E2_EMISSAO", (cTab)->(E2_EMISSAO)      , Nil},; 
						{"E2_VENCTO" , STod((cTab)->(E2_VENCTO)) , Nil},; 
						{"E2_VENCREA", STod((cTab)->(E2_VENCREA)), Nil},; 
						{"E2_VALOR"  , (cTab)->(E2_VALOR)        , Nil},; 
						{"E2_XNUMSV" , (cTab)->(E2_XNUMSV)       , Nil},; 
						{"E2_ORIGEM" , (cTab)->(E2_ORIGEM)       , Nil}}
			
				MsExecAuto({|x,y,z| FINA050(x,y,z)}, aSE2, , 5)
						
				If (lMsErroAuto)
					DisarmTransaction()
					MostraErro()
					lRet := .F.
				Endif
			Endif
		
			(cTab)->(DbSkip())
		Enddo
		
		(cTab)->(DbCloseArea())
		
		If (lRet)
			cQuery := "SELECT DISTINCT" + CRLF
			cQuery += "C7_FILIAL," + CRLF
			cQuery += "C7_NUM," + CRLF
			cQuery += "C7_EMISSAO," + CRLF
			cQuery += "C7_FORNECE," + CRLF
			cQuery += "C7_LOJA," + CRLF
			cQuery += "C7_COND," + CRLF
			cQuery += "C7_CONTATO," + CRLF
			cQuery += "C7_FILENT" + CRLF
			cQuery += "FROM " + RetSQLName("SC7") + "" + CRLF
			cQuery += "WHERE C7_FILIAL = '" + cFil + "'" + CRLF
			cQuery += "AND C7_XNUMSV = '" + cNum + "'" + CRLF
			cQuery += "AND D_E_L_E_T_ = ''"
			
			cQuery := ChangeQuery(cQuery)
			
			cTab := GetNextAlias()
			
			TcQUERY cQuery NEW ALIAS ((cTab))
			
			DbSelectArea((cTab))
			(cTab)->(DbGoTop())
			
			aItens := {}
			
			While ((cTab)->(!Eof()))
				If (lRet)
					aCab := {{"C7_FILIAL", (cTab)->(C7_FILIAL), Nil},;
								{"C7_NUM", (cTab)->(C7_NUM), Nil},;
								{"C7_EMISSAO", (cTab)->(C7_EMISSAO), Nil},;
								{"C7_FORNECE", (cTab)->(C7_FORNECE), Nil},;
								{"C7_LOJA", (cTab)->(C7_LOJA), Nil},;
								{"C7_COND", (cTab)->(C7_COND), Nil},;
								{"C7_CONTATO", (cTab)->(C7_CONTATO), Nil},;
								{"C7_FILENT", (cTab)->(C7_FILENT), Nil}}
					
					cQuery := "SELECT" + CRLF
					cQuery += "C7_ITEM," + CRLF
					cQuery += "C7_PRODUTO," + CRLF
					cQuery += "C7_QUANT," + CRLF
					cQuery += "C7_PRECO," + CRLF
					cQuery += "C7_TOTAL," + CRLF
					cQuery += "C7_ITEMCTA," + CRLF
					cQuery += "C7_CONTA," + CRLF
					cQuery += "C7_CC," + CRLF
					cQuery += "C7_ORIGEM," + CRLF
					cQuery += "C7_XNUMSV" + CRLF
					cQuery += "FROM " + RetSQLName("SC7") + "" + CRLF
					cQuery += "WHERE C7_FILIAL = '" + cFil + "'" + CRLF
					cQuery += "AND C7_FORNECE = '" + (cTab)->(C7_FORNECE) + "'" + CRLF
					cQuery += "AND C7_LOJA = '" + (cTab)->(C7_LOJA) + "'" + CRLF
					cQuery += "AND C7_XNUMSV = '" + cNum + "'" + CRLF
					cQuery += "AND D_E_L_E_T_ = ''"
					
					cQuery := ChangeQuery(cQuery)
					
					cTab2 := GetNextAlias()
					
					TcQUERY cQuery NEW ALIAS ((cTab2))
					
					DbSelectArea((cTab2))
					(cTab2)->(DbGoTop())
					
					While ((cTab2)->(!Eof()))
						cQuery += "C7_ITEM," + CRLF
						cQuery += "C7_PRODUTO," + CRLF
						cQuery += "C7_QUANT," + CRLF
						cQuery += "C7_PRECO," + CRLF
						cQuery += "C7_TOTAL," + CRLF
						cQuery += "C7_ITEMCTA," + CRLF
						cQuery += "C7_CONTA," + CRLF
						cQuery += "C7_CC," + CRLF
						cQuery += "C7_ORIGEM," + CRLF
						cQuery += "C7_XNUMSV" + CRLF
						
						aLinha := {{"C7_ITEM"    , (cTab2)->(C7_ITEM)   , Nil},;
									{"C7_PRODUTO", (cTab2)->(C7_PRODUTO), Nil},;
									{"C7_QUANT"  , (cTab2)->(C7_QUANT)  , Nil},;
									{"C7_PRECO"  , (cTab2)->(C7_PRECO)  , Nil},;
									{"C7_TOTAL"  , (cTab2)->(C7_TOTAL)  , Nil},;
									{"C7_ITEMCTA", (cTab2)->(C7_ITEMCTA), Nil},;
									{"C7_CONTA"  , (cTab2)->(C7_CONTA)  , Nil},;
									{"C7_CC"     , (cTab2)->(C7_CC)     , Nil},;
									{"C7_ORIGEM" , (cTab2)->(C7_ORIGEM) , Nil},;
									{"C7_XNUMSV" , (cTab2)->(C7_XNUMSV) , Nil}}
									
						aAdd(aItens, aLinha)
						
						(cTab2)->(DbSkip())
					Enddo
					
					(cTab2)->(DbCloseArea())
					
					MsExecAuto({|v,x,y,z| MATA120(v,x,y,z)}, 1, aCab, aItens, 5)
					
					If (lMsErroAuto)
						DisarmTransaction()
						MostraErro()
						lRet := .F.
					Endif
				Endif
				
				(cTab)->(DbSkip())
			Enddo
			
			(cTab)->(DbCloseArea())
		Endif
		
		If (lRet)
			PcoIniLan("900002")
			DbSelectArea("SZ0")
			SZ0->(DbSetOrder(1))
			If (SZ0->(DbSeek(cFil + cNum)))
				While ((SZ0->(!Eof())) .And. (cFil == SZ0->Z0_FILIAL) .And. (cNum == SZ0->Z0_NUMSV))
					DbSelectArea("SZ1")
					SZ1->(DbSetOrder(1))
					SZ1->(DbSeek(cFil + cNum))
			
					PcoDetLan("900002", "01", "FICDVA01", .T.)
			
					SZ0->(DbSkip())
				Enddo
			Endif
			PcoFinLan("900002")
	
			DbSelectArea("SZ1")
			SZ1->(DbSetOrder(1))
			SZ1->(DbSeek(cFil + cNum))
	
			RecLock("SZ1", .F.)
			SZ1->Z1_STATUS := "W"
			SZ1->(MsUnlock())
		EndIf
				
		END TRANSACTION
	Endif
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณMicrosiga           บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICDVLIN(nOpc)
Local lRet := .T.
Local nI := 0
Local nRateio := 0

If (nOpc == 1)
	If (Empty(oDadosPass:aCols[oDadosPass:oBrowse:nAt, 2]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Produto.", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oDadosPass:aCols[oDadosPass:oBrowse:nAt, 3]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Trecho.", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oDadosPass:aCols[oDadosPass:oBrowse:nAt, 4]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Data de Partida.", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oDadosPass:aCols[oDadosPass:oBrowse:nAt, 5]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Hora de Partida.", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oDadosPass:aCols[oDadosPass:oBrowse:nAt, 6]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Data de Chegada.", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oDadosPass:aCols[oDadosPass:oBrowse:nAt, 7]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Hora de Chegada.", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oDadosPass:aCols[oDadosPass:oBrowse:nAt, 8]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Classe.", {"Ok"}, 1)
		lRet := .F.
	Else
		If ((oDadosPass:aCols[oDadosPass:oBrowse:nAt, 4] < M->Z1_DATA) .Or. (oDadosPass:aCols[oDadosPass:oBrowse:nAt, 4] > M->Z1_DTFIM))
			Aviso("Perํodo da Viagem", "Por favor, selecione uma Data de Partida que esteja dentro do perํodo desta Solicita็ใo de Viagem.", {"Ok"}, 1)
			lRet := .F.
		Elseif ((oDadosPass:aCols[oDadosPass:oBrowse:nAt, 6] < M->Z1_DATA) .Or. (oDadosPass:aCols[oDadosPass:oBrowse:nAt, 6] > M->Z1_DTFIM))
			Aviso("Perํodo da Viagem", "Por favor, selecione uma Data de Chegada que esteja dentro do perํodo desta Solicita็ใo de Viagem.", {"Ok"}, 1)
			lRet := .F.
		Endif
	Endif
Elseif (nOpc == 2)
	If (Empty(oDadosHot:aCols[oDadosHot:oBrowse:nAt, 2]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Produto.", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oDadosHot:aCols[oDadosHot:oBrowse:nAt, 7]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Tipo Diแrias.", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oDadosHot:aCols[oDadosHot:oBrowse:nAt, 8]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Check In.", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oDadosHot:aCols[oDadosHot:oBrowse:nAt, 9]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Check Out.", {"Ok"}, 1)
		lRet := .F.
	Else
		If ((oDadosHot:aCols[oDadosHot:oBrowse:nAt, 8] < M->Z1_DATA) .Or. (oDadosHot:aCols[oDadosHot:oBrowse:nAt, 8] > M->Z1_DTFIM))
			Aviso("Perํodo da Viagem", "Por favor, selecione uma data de Check In que esteja dentro do perํodo desta Solicita็ใo de Viagem.", {"Ok"}, 1)
			lRet := .F.
		Elseif ((oDadosHot:aCols[oDadosHot:oBrowse:nAt, 9] < M->Z1_DATA) .Or. (oDadosHot:aCols[oDadosHot:oBrowse:nAt, 9] > M->Z1_DTFIM))
			Aviso("Perํodo da Viagem", "Por favor, selecione uma data de Check Out que esteja dentro do perํodo desta Solicita็ใo de Viagem.", {"Ok"}, 1)
			lRet := .F.
		Endif
	Endif
Elseif (nOpc == 3)
	If (Empty(oDadosVei:aCols[oDadosVei:oBrowse:nAt, 2]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Produto.", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oDadosVei:aCols[oDadosVei:oBrowse:nAt, 7]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Dt. Retirada", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oDadosVei:aCols[oDadosVei:oBrowse:nAt, 8]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Hr. Retirada", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oDadosVei:aCols[oDadosVei:oBrowse:nAt, 9]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Dt. Devolu็ใo", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oDadosVei:aCols[oDadosVei:oBrowse:nAt, 10]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Hr. Devolu็ใo", {"Ok"}, 1)
		lRet := .F.
	Else
		If ((oDadosVei:aCols[oDadosVei:oBrowse:nAt, 7] < M->Z1_DATA) .Or. (oDadosVei:aCols[oDadosVei:oBrowse:nAt, 7] > M->Z1_DTFIM))
			Aviso("Perํodo da Viagem", "Por favor, selecione uma data de Retirada que esteja dentro do perํodo desta Solicita็ใo de Viagem.", {"Ok"}, 1)
			lRet := .F.
		Elseif ((oDadosVei:aCols[oDadosVei:oBrowse:nAt, 9] < M->Z1_DATA) .Or. (oDadosVei:aCols[oDadosVei:oBrowse:nAt, 9] > M->Z1_DTFIM))
			Aviso("Perํodo da Viagem", "Por favor, selecione uma data de Devolu็ใo que esteja dentro do perํodo desta Solicita็ใo de Viagem.", {"Ok"}, 1)
			lRet := .F.
		Endif
	Endif
Elseif (nOpc == 4)
	If (Empty(oDadosSeg:aCols[oDadosSeg:oBrowse:nAt, 2]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Tipo.", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oDadosSeg:aCols[oDadosSeg:oBrowse:nAt, 3]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Nome.", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oDadosSeg:aCols[oDadosSeg:oBrowse:nAt, 4]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo RG.", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oDadosSeg:aCols[oDadosSeg:oBrowse:nAt, 5]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo CPF.", {"Ok"}, 1)
		lRet := .F.
	Endif
Elseif (nOpc == 5)
	If (Empty(oRateio:aCols[oRateio:oBrowse:nAt][2]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Item Contแbil.", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oRateio:aCols[oRateio:oBrowse:nAt][3]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Conta Contแbil.", {"Ok"}, 1)
		lRet := .F.
	Elseif (Empty(oRateio:aCols[oRateio:oBrowse:nAt][4]))
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo Centro de Custo.", {"Ok"}, 1)
		lRet := .F.
	Elseif (oRateio:aCols[oRateio:oBrowse:nAt][5] == 0)
		Aviso("Campo obrigat๓rio", "Por favor, preencha o campo % Rateio.", {"Ok"}, 1)
		lRet := .F.
	Else
		For nI := 1 To Len(oRateio:aCols)
			If (oRateio:oBrowse:nAt != nI)
				If ((oRateio:aCols[oRateio:oBrowse:nAt][2] == oRateio:aCols[nI][2]) .And. ;
					(oRateio:aCols[oRateio:oBrowse:nAt][3] == oRateio:aCols[nI][3]) .And. ;
					(oRateio:aCols[oRateio:oBrowse:nAt][4] == oRateio:aCols[nI][4]) .And. ;
					!(oRateio:aCols[oRateio:oBrowse:nAt][6]) .And. !(oRateio:aCols[nI][6]))
					Aviso("Campo obrigat๓rio", "Por favor, selecione outro Item Contแbil, Conta Contแbil e/ou Centro de Custo. Este rateio jแ existe.", {"Ok"}, 1)
					lRet := .F.
				Endif
			Endif
		Next nI
		
		For nI := 1 To Len(oRateio:aCols)
			If !(oRateio:aCols[nI][6])
				nRateio += oRateio:aCols[nI][5]
			Endif
		Next nI
		
		If (nRateio > 100)
			Aviso("% Excedido", "Por favor, verifique os % digitados. % excedido.", {"Ok"}, 1)
			lRet := .F.
		Endif
	Endif
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  07/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICDVPRS(nOpc)
Local lRet := .T.
Local oDlg
Local aFolder := {"Presta็ใo de Contas"}
Local aSize := MsAdvSize()
Local aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 3, 3}
Local aObjects := {{100,040,.T.,.T.}, {100,120,.T.,.T.}}
Local aPosObj := MsObjSize(aInfo, aObjects)
Local aHeadPres := {}
Local cNoCpos := "Z6_NUMSV"
Local aColsPres := {}
Local aAux := {}
Local nAux := 0
Local aButtons := {}
Local lOk := .F.
Local aAltPres := {}
Local cSuperior := ""

Private oFolder
Private oDadosPres

aAdd(aButtons, {"Filtro", {|| MsDocument("SZ1", SZ1->(Recno()), 3)}, "Conhecimento"})

If (nOpc == 3)
	If !(SZ1->Z1_SOLICIT $ __cUserId)
		Aviso("Aviso", "Este usuแrio nใo possui permissใo para Incluir Presta็ใo de Contas.", {"Ok"}, 1)
		lRet := .F.
	Endif
	
	If (lRet)
		If !(SZ1->Z1_STATUS $ "F")
			Aviso("Aviso", "Presta็ใo de Contas somente disponํvel para SV que possuem status de Finalizada/ Ag. Presta็ใo.", {"Ok"}, 1)
			lRet := .F.
		Endif
	Endif
Elseif (nOpc == 2)
//	cSuperior := Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_XSUPVIA")
	cSuperior := SZ1->Z1_APROV
		
	If !(AllTrim(cSuperior) $ __cUserId)
		Aviso("Aviso", "Este usuแrio nใo possui permissใo para Aprovar Presta็ใo de Contas.", {"Ok"}, 1)
		lRet := .F.
	Endif
	
	If (lRet)
		If !(SZ1->Z1_STATUS $ "X")
			Aviso("Aviso", "Presta็ใo de Contas somente disponํvel para SV que foram enviadas para aprova็ใo.", {"Ok"}, 1)
			lRet := .F.
		Endif
		
		If (lRet)
			aAdd(aButtons, {"FILTRO", {|| RejeiPres(SZ1->Z1_FILIAL, SZ1->Z1_NUM), oDlg:End()}, "Rejeitar"})
		Endif
	Endif
Endif


If (lRet)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPresta็ใo de Contasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("SZ6"))
	While ((SX3->(!Eof())) .And. (SX3->X3_ARQUIVO == "SZ6"))
		If ((X3USO(SX3->X3_USADO)) .And. (cNivel >= SX3->X3_NIVEL) .And. !(AllTrim(SX3->X3_CAMPO) $ cNoCpos))
			aAdd(aHeadPres,	{TRIM(SX3->X3_TITULO)	,;
							SX3->X3_CAMPO			,;
							SX3->X3_PICTURE			,;
							SX3->X3_TAMANHO			,;
							SX3->X3_DECIMAL			,;
							SX3->X3_VALID			,;
							SX3->X3_USADO			,;
							SX3->X3_TIPO			,;
							SX3->X3_F3				,;
							SX3->X3_CONTEXT			,;
							SX3->X3_CBOX			,;
							SX3->X3_RELACAO			,;
							SX3->X3_WHEN			,;
							SX3->X3_VISUAL			,;
							SX3->X3_VLDUSER			,;
							SX3->X3_PICTVAR			,;
							SX3->X3_OBRIGAT			})
		Endif
		
		SX3->(DbSkip())
	Enddo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPresta็ใo de Contasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	aColsPres := retPres(SZ1->Z1_FILIAL, SZ1->Z1_NUM)
	
	If (Len(aColsPres) == 0)
		aAux := {}
		For nAux := 1 To Len(aHeadPres)
			SX3->(DbSetOrder(2))
			SX3->(DbSeek(aHeadPres[nAux, 2]))
			If (AllTrim(aHeadPres[nAux, 2]) == "Z6_ITEM")
				aAdd(aAux, "001")
			Else
				If (SX3->X3_TIPO == "C")
					aAdd(aAux, Space(TamSX3(aHeadPres[nAux, 2])[1]))
				Elseif (SX3->X3_TIPO == "N")
					aAdd(aAux, 0)
				Elseif (SX3->X3_TIPO == "D")
					aAdd(aAux, dDataBase)
				Endif
			Endif
		Next nAux
		aAdd(aAux, .F.)
		aAdd(aColsPres, aAux)
	Endif
	
	Define MsDialog oDlg Title "Presta็ใo de Contas" From 3, 0 To 500, 960 Pixel

	RegToMemory("SZ1", .F.)
	
	oEnchoice := MsmGet():New("SZ1", , 2, , , , {}, {1, 1, 105, 480}, Nil, 3, , , , , , .T., , , , , , , ,.T.)
	
	oFolder		:= TFolder():New(105, 1, aFolder, {}, oDlg, 1, , , .T., .F., aPosObj[2,4]-75, aPosObj[2,3], )
	
	aAdd(aAltPres, "Z6_TIPO")
	aAdd(aAltPres, "Z6_DESCRI")
	aAdd(aAltPres, "Z6_VALOR")
	aAdd(aAltPres, "Z6_DATA")

	oDadosPres := MsNewGetDados():New(0, 0, 120, 478, GD_INSERT + GD_UPDATE + GD_DELETE, ;
									"AllwaysTrue()", "AllwaysTrue()", "+Z6_ITEM", aAltPres, , 999, "AllwaysTrue()", , , oFolder:aDialogs[1], aHeadPres, aColsPres)
	oDadosPres:oBrowse:bGotFocus := {|| Fd_Entra(1)}
	oDadosPres:oBrowse:bLostFocus := {|| Fd_Sai(1)}
	oDadosPres:oBrowse:Default()
	oDadosPres:oBrowse:Refresh()
	If (nOpc == 2)
		oDadosPres:Disable()
	Endif
	oFolder:aDialogs[1]:Refresh()
	
	Activate MsDialog oDlg Center On Init (EnchoiceBar(oDlg, {|| MsgRun("Gravando informa็๕es, aguarde...", "Solicita็๕es de Viagens", {|| CursorWait(), Iif(nOpc == 3, FICDVGRP(SZ1->Z1_FILIAL, SZ1->Z1_NUM, oDadosPres:aCols), AprovPres(SZ1->Z1_FILIAL, SZ1->Z1_NUM)), CursorArrow(), oDlg:End()})}, {||oDlg:End()}, , @aButtons))
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  11/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FtMsRel()
Local aEntidade := {}

aAdd(aEntidade, {"SZ1", {"Z1_NUM"}, {|| SZ1->Z1_NUM}})

Return(aEntidade)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  07/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FICDVGRP(cFil, cNum, aPrestacao)
Local aArea := {GetArea(), SZ1->(GetArea()), SZ6->(GetArea())}
Local lRet := .T.
Local nI := 0

For nI := 1 To Len(aPrestacao)
	DbSelectArea("SZ6")
	SZ6->(DbSetOrder(1))

	If (SZ6->(DbSeek(cFil + cNum + aPrestacao[nI][1])))
		RecLock("SZ6", .F.)
		If (aPrestacao[nI][6])
			SZ6->(DbDelete())
		Else
			SZ6->Z6_TIPO   := aPrestacao[nI][2]
			SZ6->Z6_DESCRI := aPrestacao[nI][3]
			SZ6->Z6_VALOR  := aPrestacao[nI][4]
			SZ6->Z6_DATA   := aPrestacao[nI][5]
		Endif
		SZ6->(MsUnlock())
	Else
		If !(aPrestacao[nI][6])
			If !(Empty(aPrestacao[nI][2]))
				RecLock("SZ6", .T.)
				SZ6->Z6_FILIAL := cFil
				SZ6->Z6_NUMSV  := cNum
				SZ6->Z6_ITEM   := aPrestacao[nI][1]
				SZ6->Z6_TIPO   := aPrestacao[nI][2]
				SZ6->Z6_DESCRI := aPrestacao[nI][3]
				SZ6->Z6_VALOR  := aPrestacao[nI][4]
				SZ6->Z6_DATA   := aPrestacao[nI][5]
				SZ6->(MsUnlock())
			Endif
		Endif
	Endif
Next nI

If (Aviso("Aviso", "Deseja deixar esta Presta็ใo em Aberto?", {"Sim", "Nใo"}, 1) == 2)
	DbSelectArea("SZ1")
	SZ1->(DbSetOrder(1))
	SZ1->(DbSeek(cFil + cNum))
	
	RecLock("SZ1", .F.)
	SZ1->Z1_STATUS := "X"
	SZ1->(MsUnlock())
Endif

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  07/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function retPres(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea()), SZ6->(GetArea())}
Local lRet := .T.
Local aDados := {}
Local cQuery := ""
Local cTab := ""

cQuery := "SELECT" + CRLF
cQuery += "Z6_ITEM," + CRLF
cQuery += "Z6_TIPO," + CRLF
cQuery += "Z6_DESCRI," + CRLF
cQuery += "Z6_VALOR," + CRLF
cQuery += "Z6_DATA" + CRLF
cQuery += "FROM " + RetSQLName("SZ6") + "" + CRLF
cQuery += "WHERE Z6_FILIAL = '" + cFil + "'" + CRLF
cQuery += "AND Z6_NUMSV = '" + cNum + "'" + CRLF
cQuery += "AND D_E_L_E_T_ = ''"

cQuery := ChangeQuery(cQuery)

cTab := GetNextAlias()

TcQUERY cQuery NEW ALIAS ((cTab))

DbSelectArea((cTab))
(cTab)->(DbGoTop())

While ((cTab)->(!Eof()))
	aAdd(aDados, {(cTab)->(Z6_ITEM), (cTab)->(Z6_TIPO), (cTab)->(Z6_DESCRI), (cTab)->(Z6_VALOR), SToD((cTab)->(Z6_DATA)), .F.})

	(cTab)->(DbSkip())
Enddo

(cTab)->(DbCloseArea())

aEval(aArea, {|x| RestArea(x)})
Return(aDados)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  07/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RejeiPres(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea())}
Local lRet := .T.
Local cEmail := ""
Local cNome := ""
Local cBody := ""

DbSelectArea("SZ1")
SZ1->(DbSetOrder(1))
If (SZ1->(DbSeek(cFil + cNum)))
	RecLock("SZ1", .F.)
	SZ1->Z1_STATUS := "F"
	SZ1->(MsUnlock())
	
	cEmail := Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_EMAIL")
	cNome := Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_NOME")
	cBody := "Prezado(a) " + cNome + "," + CRLF + CRLF
	cBody += "Informamos que a Presta็ใo de Contas de sua Solicita็ใo de Viagem nบ '" + cNum + "' foi rejeitada." + CRLF
	cBody += "Por favor, revise atrav้s da rotina de Solicita็ใo de Viagens."
	ACSendMail(, , , , cEmail, "SV " + cNum + "", cBody)
Endif

Aviso("Aviso", "Solicita็ใo rejeitada com sucesso.", {"Ok"}, 1)

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  07/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AprovPres(cFil, cNum)
Local aArea := {GetArea(), SZ1->(GetArea()), SZ6->(GetArea())}
Local lRet := .T.
Local cEmail := ""
Local cNome := ""
Local cBody := ""
Local cEmCompr  := AllTrim(GetMv("FI_EMCOMPR"))
Local nAdianta := 0
Local nDevolu := 0
Local nGasto := 0
Local nTotal := 0
Local cTpVg := SZ1->Z1_TIPO

Private lMsErroAuto := .F.

BEGIN TRANSACTION

DbSelectArea("SZ1")
SZ1->(DbSetOrder(1))
If (SZ1->(DbSeek(cFil + cNum)))
	nAdianta := SZ1->Z1_ADIANTA
	
	RecLock("SZ1", .F.)
	SZ1->Z1_STATUS := "Z"
	SZ1->(MsUnlock())
	
	DbSelectArea("SZ6")
	SZ6->(DbGoTop())
	SZ6->(DbSetOrder(1))
	If (SZ6->(DbSeek(cFil + cNum)))
		While ((SZ6->(!Eof())) .And. (SZ6->Z6_FILIAL == cFil) .And. (SZ6->Z6_NUMSV == cNum))
			If (SZ6->Z6_TIPO == "1")
				nGasto += SZ6->Z6_VALOR
			Elseif (SZ6->Z6_TIPO == "2")
				nDevolu += SZ6->Z6_VALOR
			Endif
		
			SZ6->(DbSkip())
		Enddo
	Endif
	
	nTotal := (nGasto - nAdianta) + nDevolu
	
	DbSelectArea("SZ1")
	SZ1->(DbSetOrder(1))
	SZ1->(DbSeek(cFil + cNum))
	
	If (nTotal > 0)
		aSE2 := {{"E2_FILIAL", xFilial("SE2"), Nil},;
				{"E2_PREFIXO", "PCV", Nil},;
				{"E2_NUM", SZ1->Z1_NUM, Nil},;
				{"E2_TIPO", GetMv("FI_TIPVIA"), Nil},;
				{"E2_NATUREZ", Iif(cTpVg == "1", GetMv("FI_NATVNAC"), GetMv("FI_NATVINT")), Nil},;
				{"E2_FORNECE", SZ1->Z1_CODVIAJ, Nil},;
				{"E2_LOJA", SZ1->Z1_LOJAVIA, Nil},;
				{"E2_EMISSAO", dDataBase, Nil},;
				{"E2_CONTAD", SZ1->Z1_CONTA, Nil},;
				{"E2_CCD", SZ1->Z1_CCUSTO, Nil},;
				{"E2_ITEMD", SZ1->Z1_ITEMCTA, Nil},;
				{"E2_VENCTO", dDataBase, Nil},;
				{"E2_VENCREA", dDataBase, Nil},;
				{"E2_VALOR", nTotal, Nil},;
				{"E2_XNUMSV", SZ1->Z1_NUM, Nil},;
				{"E2_ORIGEM", "FICDV01", Nil}}
				
		MsExecAuto({|x,y,z| FINA050(x,y,z)}, aSE2, , 3)
		
		If (lMsErroAuto)
			DisarmTransaction()
			MostraErro()
			lRet := .F.
		Endif
	Elseif (nTotal < 0)
		nTotal := nTotal * (-1)
		
		aSE2 := {{"E2_FILIAL", xFilial("SE2"), Nil},;
				{"E2_PREFIXO", GetMv("FI_PFXVIA"), Nil},;
				{"E2_NUM", SZ1->Z1_NUM, Nil},;
				{"E2_TIPO", "NDF", Nil},;
				{"E2_NATUREZ", Iif(cTpVg == "1", GetMv("FI_NATVNAC"), GetMv("FI_NATVINT")), Nil},;
				{"E2_FORNECE", SZ1->Z1_CODVIAJ, Nil},;
				{"E2_LOJA", SZ1->Z1_LOJAVIA, Nil},;
				{"E2_EMISSAO", dDataBase, Nil},;
				{"E2_CONTAD", SZ1->Z1_CONTA, Nil},;
				{"E2_CCD", SZ1->Z1_CCUSTO, Nil},;
				{"E2_ITEMD", SZ1->Z1_ITEMCTA, Nil},;
				{"E2_VENCTO", dDataBase, Nil},;
				{"E2_VENCREA", dDataBase, Nil},;
				{"E2_VALOR", nTotal, Nil},;
				{"E2_XNUMSV", SZ1->Z1_NUM, Nil},;
				{"E2_ORIGEM", "FICDV01", Nil}}
				
		MsExecAuto({|x,y,z| FINA050(x,y,z)}, aSE2, , 3)
		
		If (lMsErroAuto)
			DisarmTransaction()
			MostraErro()
			lRet := .F.
		Endif
	Endif
	
	If (lRet)
		cEmail := Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_EMAIL")
		cNome := Posicione("SA2", 1, xFilial("SA2") + SZ1->Z1_CODVIAJ + SZ1->Z1_LOJAVIA, "A2_NOME")
		cBody := "Prezado(a) " + cNome + "," + CRLF + CRLF
		cBody += "Informamos que a Presta็ใo de Contas de sua Solicita็ใo de Viagem nบ '" + cNum + "' foi aprovada." + CRLF
		ACSendMail(, , , , cEmail, "SV " + cNum + "", cBody)
		
		Aviso("Aviso", "Solicita็ใo aprovada com sucesso.", {"Ok"}, 1)
	Endif
Endif

END TRANSACTION

aEval(aArea, {|x| RestArea(x)})
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  28/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FICDVTOK(aColsRat)
Local lRet := .T.
Local nI := 0
Local nTotal := 0

For nI := 1 To Len(aColsRat)
	If !(aColsRat[nI, 6])
		nTotal += aColsRat[nI, 5]
	Endif
Next nI

If (nTotal != 100)
	Aviso("Aviso", "Rateio invแlido." + CRLF + "Por favor, confira o % Total de Rateio.", {"Ok"}, 1)
	lRet := .F.
Endif
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFICDVA01  บAutor  ณFelipe Alves        บ Data ณ  28/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FICDVCOK(aPass, aHot, aVei)
Local lRet := .T.
Local nI := 0

Default aPass := {}
Default aHot := {}
Default aVei := {}

For nI := 1 To Len(aPass)
	If !(Empty(aPass[nI][1]))
		If ((Empty(aPass[nI][13])) .Or. (Empty(aPass[nI][13])) .Or. (aPass[nI][16] == 0))
			lRet := .F.
		Endif
	Endif
Next nI

For nI := 1 To Len(aHot)
	If !(Empty(aHot[nI][1]))
		If ((Empty(aHot[nI][4])) .Or. (Empty(aHot[nI][5])) .Or. (aHot[nI][12] == 0))
			lRet := .F.
		Endif
	Endif
Next nI

For nI := 1 To Len(aVei)
	If !(Empty(aVei[nI][1]))
		If ((Empty(aVei[nI][4])) .Or. (Empty(aVei[nI][5])) .Or. (aVei[nI][12] == 0))
			lRet := .F.
		Endif
	Endif
Next nI

If !(lRet)
	Aviso("Aviso", "Por favor, informe o(s) Fornecedor(es) e Valor(es).", {"Ok"}, 1)
Endif
Return(lRet)