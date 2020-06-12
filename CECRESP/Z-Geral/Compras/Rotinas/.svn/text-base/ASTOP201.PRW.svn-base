#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

/*{Protheus.doc} ASTOP201 
Chamado nos PE - MT140TOK - Pré nota de entrada e MT100GRV - Documento de entrada

Valida as informações de dedução do Pedido de Compras originados no RM-TOP

@param	    cTIPO - P = Pré-nota, N = Nota Fiscal
@return		Lógico = Se OK 
@author 	Zema
@since 		18/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/

Static _cNumPdC
Static _nTtlPC7
Static _nVlrRetRM
Static _nVlrDedRM
Static _lExPedid		:= .F.

User Function ASTOP201(cTIPO)
	
	Local lRet		:= .T.
	Local lPulaDED	:= .T.
	Local lPulaRET	:= .T.
	
	Local nX		:= 0
	Local nVlrPC	:= 0			//Valor Total da NF Entrada
	Local nVlrRet	:= 0			//Valor Retenção - SC7
	Local nVlrDed	:= 0            //Valor Dedução  - SC7
	Local nSldRet 	:= 0 			//Saldo Retenção
	Local nSldDed 	:= 0			//Saldo Deducao
	Local nSldVlr   := 0			//Saldo do Pedido
	Local nRetSug	:= 0			//Retenção Sugerida
	Local nDedSug	:= 0            //Dedução  Sugerida
	Local nSldRD    := 0			//Saldo Redução/Dedução
	Local nSldPC    := 0			//Saldo PC
	Local cQuery	:= ""
	Local cTabSF1	:= GetNextAlias()
	Local cTabSC7	:= GetNextAlias()
	Local cTtlSC7	:= GetNextAlias()
	Local nPosDel	:= Len( aHeader ) + 1
	Local nPosPed	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_PEDIDO"})
	Local nPosTtl	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_TOTAL"})
	
	Default cTipo	:= Nil
	
	If _lExPedid
		If	Inclui .Or. Altera
			If 	Len(aCols) > 0
				
				If	!Empty(aCols[1,nPosPed])
					//Variavel com o valor total da nota fiscal de entrada
					For nX := 1 To Len( aCols )
						//-- Não processa registros deletados
						If 	aCols[ nX ][ nPosDel ]
							Loop
						EndIf
						nVlrPC	:= aCols[nX][nPosTtl]
					Next nX
					
					//Valor do Pedido de Compras original
					cQuery	:= " SELECT SUM(C7_TOTAL) AS TTLSC7 " + CRLF
					cQuery	+= " FROM " + RetSQLName("SC7") + " SC7 " + CRLF
					cQuery	+= " WHERE " + CRLF
					cQuery	+= " SC7.C7_FILIAL = '" + xFilial("SC7") + "' AND " + CRLF
					cQuery	+= " SC7.C7_NUM    = '" + aCols[1,nPosPed] + "' AND " + CRLF
					cQuery	+= " SC7.D_E_L_E_T_= '' " + CRLF
					cQuery  := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTtlSC7,.T.,.T.)
					
					//Valor da Retenção e Dedução que já foram movimentados
					cQuery	:= " SELECT SUM(F1_XRETRM) AS RETENCAO, SUM(F1_XDEDRM) AS DEDUCAO, SUM(D1_TOTAL) AS TTLSD1 " + CRLF
					cQuery	+= " FROM " + RetSQLName("SF1") + " SF1 " + CRLF
					cQuery	+= " INNER JOIN " + RetSQLName("SD1") + " SD1 " + CRLF
					cQuery	+= " ON " + CRLF
					cQuery	+= " SF1.F1_FILIAL = SD1.D1_FILIAL And" + CRLF
					cQuery	+= " SF1.F1_DOC = SD1.D1_DOC And" + CRLF
					cQuery	+= " SF1.F1_SERIE = SD1.D1_SERIE And" + CRLF
					cQuery	+= " SF1.F1_FORNECE = SD1.D1_FORNECE And" + CRLF
					cQuery	+= " SF1.F1_LOJA = SD1.D1_LOJA" + CRLF
					cQuery	+= " WHERE " + CRLF
					cQuery	+= " SD1.D1_PEDIDO = '" + aCols[1,nPosPed] + "' AND "  + CRLF
					cQuery	+= " SD1.D_E_L_E_T_ = '' AND "  + CRLF
					cQuery	+= " SF1.D_E_L_E_T_ = '' "  + CRLF
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTabSF1,.T.,.T.)
					
					// Valor da Retenção e/ou Dedução com origem RM
					cQuery	:= " SELECT C7_XRETRM, C7_XDEDRM " + CRLF
					cQuery	+= " FROM " + RetSQLName("SC7") + " SC7 " + CRLF
					cQuery	+= " WHERE " + CRLF
					cQuery	+= " SC7.C7_FILIAL = '" + xFilial("SC7") + "' AND " + CRLF
					cQuery	+= " SC7.C7_NUM    = '" + aCols[1,nPosPed] + "' AND " + CRLF
					cQuery	+= " SC7.D_E_L_E_T_ = '' " + CRLF
					cQuery := ChangeQuery(cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTabSC7,.T.,.T.)
					
					While !(cTabSC7)->(EOF())
						
						If 	!Empty((cTabSC7)->C7_XRETRM) .And. lPulaRET
							nVlrRet	:= 	(cTabSC7)->C7_XRETRM
							lPulaRET := .F.
						Endif
						If 	!Empty((cTabSC7)->C7_XDEDRM) .And. lPulaDED
							nVlrDed	:= 	(cTabSC7)->C7_XDEDRM
							lPulaDED := .F.
						Endif
						
						(cTabSC7)->(DbSkip())
					Enddo
					
					//*******************************************************************
					//Nao existe valor na Retenção e Dedução - Aborta Processo
					IF	nVlrRet == 0 .And. nVlrDed == 0
						Return(.T.)
					EndIf
					
					//*******************************************************************
					//Na pre-notamonta tela pra informar os impostos
					//*******************************************************************
					If	cTipo == 'P'
						lRet := MontaDR()
						IF	!lRet
							Return(.F.)
						EndIf
					EndIf
					
					//*******************************************************************
					//Saldo Retenção, Dedução e Pedido de Compra
					nSldRet := nVlrRet -  (cTabSF1)->RETENCAO
					nSldDed := nVlrDed -  (cTabSF1)->DEDUCAO
					nSldVlr := (cTtlSC7)->TTLSC7 - (cTabSF1)->TTLSD1
					
					//Retenção Sugerida
					nRetSug	:= (nVlrPC / nSldVlr ) * nSldRet
					//Dedução Sugerida
					nDedSug	:= (nVlrPC / nSldVlr ) * nSldDed
					
					//*******************************************************************
					//Não permitir quando valor de retenção/dedução maior saldo de retenção/dedução.
					//Retenção Acatada
					If	nVl_Rrm > 0
						IF	nVl_Rrm > nSldRet
							MsgAlert("O Valor da Retenção não pode ser maior que o saldo de Retenção - "+;
								Alltrim(TRANSFORM(nSldRet, '@E 999,999.99')) + ".")
							Return(.F.)
						EndIf
					Else
						//Retenção Sugerida
						IF	nRetSug > nSldRet
							MsgAlert("O Valor da Retenção não pode ser maior que o saldo de Retenção - "+;
								Alltrim(TRANSFORM(nSldRet, '@E 999,999.99')) + ".")
							Return(.F.)
						EndIf
					Endif
					
					//Dedução Acatada
					If	nVl_Drm > 0
						IF	nVl_Drm > nSldDed
							MsgAlert("O Valor da Dedução não pode ser maior que o saldo de Dedução - "+;
								Alltrim(TRANSFORM(nSldDed, '@E 999,999.99')) + ".")
							Return(.F.)
						EndIf
					Else
						//Dedução Sugerida
						IF	nDedSug > nSldDed
							MsgAlert("O Valor da Dedução não pode ser maior que o saldo de Dedução - "+;
								Alltrim(TRANSFORM(nSldDed, '@E 999,999.99')) + ".")
							Return(.F.)
						EndIf
					Endif
					
					//nSldRet := nVlrRet -  (cTabSF1)->RETENCAO
					//nSldDed := nVlrDed -  (cTabSF1)->DEDUCAO
					//nSldVlr := (cTtlSC7)->TTLSC7 - (cTabSF1)->TTLSD1
					
					//Saldo Retencao+Deducao apos a NF Entrada, nao pode ser maior que saldo PC
					nSldRD := (nSldRet + nSldDed) - (nVl_Rrm+nVl_Drm)
					nSldPC := ((cTtlSC7)->TTLSC7 - ((cTabSF1)->TTLSD1 + nVlrPC))
					IF	nSldPC > 0
						If	nSldRD > nSldPC
							MsgAlert("O Valor da Retenção e Dedução desta nota está muito baixo. A soma dos dois valores deve ser pelo menos " +;
								Alltrim(TRANSFORM(nSldRD - nSldPC, '@E 999,999.99'))+ ".")
							Return(.F.)
						EndIf
					EndIf
					
					//Saldo retencao+deducao maior que saldo PC
					IF	nSldRD > 0 .And. nSldPC = 0
						MsgAlert("Para este documento o Valor da Retenção deve ser igual ao Saldo de Retenção " +;
							Alltrim(TRANSFORM(nSldRet, '@E 999,999.99')) + "." + CRLF +;
							"E o Valor de Dedução deverá ser igual ao Saldo de Dedução "+;
							Alltrim(TRANSFORM(nSldDed, '@E 999,999.99')) + ".")
						
						Return(.F.)
					EndIf
				EndIf
			EndIf
		EndIf
		
		(cTabSF1)->(DbCloseArea())
		(cTabSC7)->(DbCloseArea())
		(cTtlSC7)->(DbCloseArea())
	Endif
	
Return (lRet)

/*{Protheus.doc} MontaDR
Monta tela para os campos costumizados na Pre-Nota
Chamado pela função - F0100201

@author 	Nivia Ferreira
@version 	P11
@since   	01/12/2016
@param
@return
@obs
@project   	MAN00000022127_EF_001
@history
*/

Static Function MontaDR()
	
	Local _nY
	Local oMainPanel	:= Nil
	Local oDlg			:= Nil
	Local lRet			:= .F.
	Local cRDSF1		:= GetNextAlias()
	Local cTabSC7		:= GetNextAlias()
	Local bOk     	:= {||lRet := .T.,oDlg:End()}
	Local bCancel 	:= {||oDlg:End()}
	Local nVlrSD1		:= 0
	Local nPosUn	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_QUANT"})
	Local nPosPed	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_PEDIDO"})
	Local nPosVlUn:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_VUNIT"})
	
	IF TYPE("nVl_Rrm") =="U"
		Public nVl_Rrm	:= 0
		Public nVl_Drm	:= 0
	ENDIF
	
	For _nY := 1 To Len(aCols)
		If aCols[_nY,nPosPed] == _cNumPdC
			nVlrSD1 += aCols[_nY,nPosUn] * aCols[_nY,nPosVlUn]
		Endif
	Next
	
	cQuery	:= " SELECT C7_XRETRM, C7_XDEDRM " + CRLF
	cQuery	+= " FROM " + RetSQLName("SC7") + " SC7 " + CRLF
	cQuery	+= " WHERE " + CRLF
	cQuery	+= " SC7.C7_FILIAL = '" + xFilial("SC7") + "' AND " + CRLF
	cQuery	+= " SC7.C7_NUM    = '" + _cNumPdC + "' AND " + CRLF
	cQuery	+= " SC7.D_E_L_E_T_ = '' " + CRLF
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTabSC7,.T.,.T.)
	
	
	cQuery	:= " SELECT SUM(F1_XRETRM) AS RETENCAO, SUM(F1_XDEDRM) AS DEDUCAO, SUM(D1_TOTAL) AS D1TOTAL " + CRLF
	cQuery	+= " FROM " + RetSQLName("SF1") + " SF1 " + CRLF
	cQuery	+= " INNER JOIN " + RetSQLName("SD1") + " SD1 " + CRLF
	cQuery	+= " ON " + CRLF
	cQuery	+= " SF1.F1_FILIAL = SD1.D1_FILIAL And" + CRLF
	cQuery	+= " SF1.F1_DOC = SD1.D1_DOC And" + CRLF
	cQuery	+= " SF1.F1_SERIE = SD1.D1_SERIE And" + CRLF
	cQuery	+= " SF1.F1_FORNECE = SD1.D1_FORNECE And" + CRLF
	cQuery	+= " SF1.F1_LOJA = SD1.D1_LOJA" + CRLF
	cQuery	+= " WHERE " + CRLF
	cQuery	+= " SD1.D1_PEDIDO = '" + _cNumPdC + "' AND "  + CRLF
	cQuery	+= " SD1.D_E_L_E_T_ = '' AND "  + CRLF
	cQuery	+= " SF1.D_E_L_E_T_ = '' "  + CRLF
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cRDSF1,.T.,.T.)
	
	nVl_Rrm	:= (nVlrSD1 / (_nTtlPC7 - (cRDSF1)->D1TOTAL)) * (_nVlrRetRM - (cRDSF1)->RETENCAO)
	nVl_Drm	:= (nVlrSD1 / (_nTtlPC7 - (cRDSF1)->D1TOTAL)) * (_nVlrDedRm - (cRDSF1)->DEDUCAO)
	
	//nVl_Rrm	:= (cTabSC7)->C7_XRETRM - (cRDSF1)->RETENCAO
	//nVl_Drm	:= (cTabSC7)->C7_XDEDRM - (cRDSF1)->DEDUCAO
	
	(cRDSF1)->(DbCloseArea())
	
	DEFINE MSDIALOG oDlg TITLE "Impostos RM" FROM 0,0 TO 220,400  PIXEL
	
	@ 41 ,020 Say "Retenção RM:" PIXEL of oDLG
	@ 40 ,100 MSGET nVl_Rrm SIZE 55,10  WHEN .F. PIXEL of oMainPanel Picture "@E 999,999.99"
	
	@ 61 ,020 Say "Dedução RM:" PIXEL of oDLG
	@ 60 ,100 MSGET nVl_Drm SIZE 55,10  WHEN .F. PIXEL of oMainPanel Picture "@E 999,999.99"
	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)
	
Return (lRet)

/*{Protheus.doc} F0100202
Monta os campos costumizados na Pre-Nota
Chamado pelo PE - MA103BUT

@author 	Nivia Ferreira
@version 	P11
@since   	10/04/2017
@param
@return
@obs
@project   	MAN00000022127_EF_001
@history
*/

User Function ASTOP202()
	
	Local lWhen		:= .T.
	
	Public nVl_Rrm	:= 0
	Public nVl_Drm	:= 0
	
	If l103Class != Nil
		If l103Class
			nVl_Rrm	:= SF1->F1_XRETRM
			nVl_Drm	:= SF1->F1_XDEDRM
			lWhen	:= .F.
		Endif
	Endif
	//Manipulando o oFolder para
	oFolder:AddItem("Impostos RM", .T.)
	
	@ 06 ,010 SAY 'Retenção RM:'  OF oFolder:aDialogs[Len(oFolder:aDialogs)] PIXEL SIZE 49,09
	@ 05 ,050 MSGET nVl_Rrm SIZE 70,09 PIXEL OF oFolder:aDialogs[Len(oFolder:aDialogs)] Picture "@E 9999999.99" When lWhen
	
	@ 26 ,010 SAY 'Dedução RM:'   OF oFolder:aDialogs[Len(oFolder:aDialogs)] PIXEL SIZE 49,09
	@ 25 ,050 MSGET nVl_Drm SIZE 70,09 PIXEL OF oFolder:aDialogs[Len(oFolder:aDialogs)]  Picture "@E 9999999.99" When lWhen
	
Return()

/*{Protheus.doc} F0100203
Alimenta as variaves da ABA Impostos RM
Chamado pelo PE - MT103VPC
@author 	Francisco Oliveira
@param
@return
@obs
@project   	MAN00000022127_EF_002
@history
*/

User Function ASTOP203()
	
	Local cRDSF1	:= GetNextAlias()
	Local nPosPed	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_PEDIDO"})	
	
	//Private _cNumPdC		:= SC7->C7_NUM
	//Private _nTtlPC7		:= SC7->C7_TOTAL
	//Private _nVlrRetRM	:= SC7->C7_XRETRM
	//Private _nVlrDedRm	:= SC7->C7_XDEDRM

	IF TYPE("nVl_Rrm") =="U"
		Public nVl_Rrm	:= 0
		Public nVl_Drm	:= 0
	ENDIF
	
	// Pega o numero do pedido
	cNumSC7 := aCols[1][nPosPed]
	SC7->(DBSETORDER(1))
    SC7->(DBSEEK(XFILIAL("SC7")+cNumSC7))
	
	_cNumPdC		:= SC7->C7_NUM
	_nTtlPC7		:= SC7->C7_TOTAL
	_nVlrRetRM		:= SC7->C7_XRETRM
	_nVlrDedRm		:= SC7->C7_XDEDRM
	_lExPedid		:= .T.
	
	cQuery	:= " SELECT SUM(F1_XRETRM) AS RETENCAO, SUM(F1_XDEDRM) AS DEDUCAO, SUM(D1_TOTAL) AS D1TOTAL " + CRLF
	cQuery	+= " FROM " + RetSQLName("SF1") + " SF1 " + CRLF
	cQuery	+= " INNER JOIN " + RetSQLName("SD1") + " SD1 " + CRLF
	cQuery	+= " ON " + CRLF
	cQuery	+= " SF1.F1_FILIAL = SD1.D1_FILIAL And" + CRLF
	cQuery	+= " SF1.F1_DOC = SD1.D1_DOC And" + CRLF
	cQuery	+= " SF1.F1_SERIE = SD1.D1_SERIE And" + CRLF
	cQuery	+= " SF1.F1_FORNECE = SD1.D1_FORNECE And" + CRLF
	cQuery	+= " SF1.F1_LOJA = SD1.D1_LOJA" + CRLF
	cQuery	+= " WHERE " + CRLF
	cQuery	+= " SD1.D1_PEDIDO = '" + SC7->C7_NUM + "' AND "  + CRLF
	cQuery	+= " SD1.D_E_L_E_T_ = '' AND "  + CRLF
	cQuery	+= " SF1.D_E_L_E_T_ = '' "  + CRLF
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cRDSF1,.T.,.T.)
	
	nVl_Rrm	:= SC7->C7_XRETRM - (cRDSF1)->RETENCAO
	nVl_Drm	:= SC7->C7_XDEDRM - (cRDSF1)->DEDUCAO
	
	(cRDSF1)->(DbCloseArea())
	
Return

/*{Protheus.doc} F0100204
Grava dados a tabelaSF1
Chamado pelo PE - SF1100I e SF1140I

@author 	Nivia Ferreira
@version 	P11
@since   	12/04/2017
@param
@return
@obs
@project   	MAN00000022127_EF_001
@history
*/

User Function ASTOP204()
	
	Local aArea 	:= GetArea()
	Local aAreaSF1	:= SF1->(GetArea())

	IF TYPE("nVl_Rrm") <> "U"

		If _lExPedid
			RecLock("SF1",.F.)
			SF1->F1_XRETRM	:= nVl_Rrm
			SF1->F1_XDEDRM	:= nVl_Drm
			MsUnlock("SF1")
		Endif
		
	ENDIF
	RestArea( aAreaSF1 )
	RestArea( aArea )
	
Return()

/*{Protheus.doc} F0100205
Grava os valores de dedução e retenção na tabela SF1
Chamado pela função - F0100201

@author 	Francisco Oliveira
@version 	P11
@since   	02/05/2017
@param
@return
@obs
@project   	MAN00000022127_EF_001
@history
*/

User Function ASTOP205()
	
	IF TYPE("nVl_Rrm") <> "U"
	
		If _lExPedid
			SF1->(RecLock("SF1",.F.))
			SF1->F1_XRETRM	:= nVl_Rrm
			SF1->F1_XDEDRM	:= nVl_Drm
			SF1->(MsUnLock())
		Endif
	endif
Return

/*{Protheus.doc} F0100206
Faz o calculo da retenção e dedução quando o usuario entra com nota com quantidade parcial em relação ao pedido de compras
Chamado pela validação dos campos D1_QUANT e D1_VUNIT

@author 	Francisco Oliveira
@version 	P11
@since   	02/05/2017
@param
@return
@obs
@project   	MAN00000022127_EF_001
@history
*/

User Function ASTOP206()
	
	Local nPosUn	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_QUANT"})
	Local nPosPed	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_PEDIDO"})
	Local nPosVlUn:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_VUNIT"})
	Local cFunExe	:= IsIncallStack("MATA140")
	Local cRDSF1	:= GetNextAlias()
	Local nVlrSD1	:= 0
	Local _nY
	
	If _lExPedid .AND. 	TYPE("nVl_Rrm") <> "U"
		
		For _nY := 1 To Len(aCols)
			If aCols[_nY,nPosPed] == _cNumPdC
				nVlrSD1 += aCols[_nY,nPosUn] * aCols[_nY,nPosVlUn]
			Endif
		Next
		
		cQuery	:= " SELECT SUM(F1_XRETRM) AS RETENCAO, SUM(F1_XDEDRM) AS DEDUCAO, SUM(D1_TOTAL) AS D1TOTAL " + CRLF
		cQuery	+= " FROM " + RetSQLName("SF1") + " SF1 " + CRLF
		cQuery	+= " INNER JOIN " + RetSQLName("SD1") + " SD1 " + CRLF
		cQuery	+= " ON " + CRLF
		cQuery	+= " SF1.F1_FILIAL = SD1.D1_FILIAL And" + CRLF
		cQuery	+= " SF1.F1_DOC = SD1.D1_DOC And" + CRLF
		cQuery	+= " SF1.F1_SERIE = SD1.D1_SERIE And" + CRLF
		cQuery	+= " SF1.F1_FORNECE = SD1.D1_FORNECE And" + CRLF
		cQuery	+= " SF1.F1_LOJA = SD1.D1_LOJA" + CRLF
		cQuery	+= " WHERE " + CRLF
		cQuery	+= " SD1.D1_PEDIDO = '" + _cNumPdC + "' AND "  + CRLF
		cQuery	+= " SD1.D_E_L_E_T_ = '' AND "  + CRLF
		cQuery	+= " SF1.D_E_L_E_T_ = '' "  + CRLF
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cRDSF1,.T.,.T.)
		
		//_nTtlPC7		:= SC7->C7_TOTAL
		//_nVlrRetRM	:= SC7->C7_XRETRM
		//_nVlrDedRm	:= SC7->C7_XDEDRM
		
		nVl_Rrm	:= (nVlrSD1 / (_nTtlPC7 - (cRDSF1)->D1TOTAL)) * (_nVlrRetRM - (cRDSF1)->RETENCAO)
		nVl_Drm	:= (nVlrSD1 / (_nTtlPC7 - (cRDSF1)->D1TOTAL)) * (_nVlrDedRm - (cRDSF1)->DEDUCAO)
		
		//(cRDSF1)->(DbCloseArea())
		
		If !cFunExe
			oFolder:Refresh()
		Endif
		
	Endif
	
Return .T.
