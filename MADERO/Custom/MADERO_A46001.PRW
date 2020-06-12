#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"

/*/{Protheus.doc} A46001
Rotina de separação para balança
@type function
@author Funaki
@since 15/06/2018
@version 1.0
@return ${return}, ${return_description}
/*/
User Function A46001()

	Local _cProd	:= Space(Tamsx3("B1_COD")[1])
	Local _cProdL	:= Space(Tamsx3("B1_COD")[1])
	Local _cLote	:= Space(Tamsx3("D3_LOTECTL")[1])
	Local _cLoteSd4	:= Space(Tamsx3("D3_LOTECTL")[1])
	Local _lOk		:= .F.
	
	Private _cOP	:= Space(Tamsx3("D3_OP")[1])
	Private cCodOpe	:= CBRetOpe()
	Private	nRegNo	:= 0

	// Validacoes
	If Empty(cCodOpe)
		VTAlert("Operador nao cadastrado","Aviso",.T.,4000,3)
		Return 10 // valor necessario para finalizar o acv170
	EndIf
	
	While .T.
		VTClear()
		
		_cOP := CriaVar("D3_OP",.F.)
		If VTModelo()=="RF"
			@ 0,0 VtSay "Sep. Balanca"
			@ 2,0 VTSay "Informe a Ordem"
			@ 3,0 VTSay "de Producao"
		Else
			@ 0,0 VTSay "Informe a OP"
		EndIf	
		@ IIf(VTModelo()=="RF",4,1),0 VTGet _cOP Pict "@!" F3 "SC2" Valid (fValGet(_cOp) .And. fValOP(_cOP))
		VTRead
		
		If !Empty(_cOP)
			// Faz a leitura dos produtos
			While .t.
				_cProd := Space(Tamsx3("B1_COD")[1])
				_cLote := Space(Tamsx3("D3_LOTECTL")[1])
				_cLoteSd4 := Space(Tamsx3("D3_LOTECTL")[1])
				_lOk := .F.
				
				VTClear()
				nRegNo	:= 0
				If VTModelo()=="RF"
					@ 0,0 VtSay "Sep. Balanca"
					@ 2,0 VTSay "Informe o produto"
				Else
					@ 0,0 VTSay "Informe o produto"
				EndIf	
				@ IIf(VTModelo()=="RF",4,1),0 VTGet _cProd Pict "@!" F3 "SD4ACD" Valid (fValGet(_cProd) .And.  fValPrd(_cOP,_cProd,@_cLoteSd4))
				VTRead
				
				If vtLastKey() == 27
					Exit
				Else
					If !Empty(_cProd)
					
						While .t.
							_cProdL	:= Space(Tamsx3("B1_COD")[1])
							_lOk := .F.
							
							VTClear()
							@ 0,0 VTSay "Sep. Balanca"
							@ 1,0 VTSay "Prod:" + Alltrim(_cProd)
							@ 2,0 VTSay Alltrim(Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_DESC"))
							@ 3,0 VTSay "Leia o produto"
							@ IIf(VTModelo()=="RF",4,1),0 VTGet _cProdL Pict "@!" Valid (fValGet(_cProdL) .And.  fValPrd(_cOP,_cProdL,@_cLoteSd4))
							VTRead
							
							If vtLastKey() == 27
								Exit
							Else
								If !Empty(_cProdL)
									If _cProdL != _cProd
										If VTYesNo("Prd. Lido Diferente do Prd.informado. Confirma?","Atencao",.T.)
											_lOk := .T.
											_cProd := _cProdL
											Exit
										EndIf
									Else
										_lOk := .T.
										Exit
									EndIf
								Endif
							Endif
						Enddo				
					
						If _lOk
					
							// Verifica se o produto controla lote
							If Posicione("SB1",1,xFilial("SB1")+Alltrim(_cProd),"B1_RASTRO") == "L"
								While .t.
									_cLote := Space(Tamsx3("D3_LOTECTL")[1])
									_lOk := .F.
									
									VTClear()
									@ 0,0 VTSay "Sep. Balanca"
									@ 1,0 VTSay "Prod:" + Alltrim(_cProd)
									@ 2,0 VTSay Alltrim(Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_DESC"))
									@ 3,0 VTSay "Informe o lote"
									@ IIf(VTModelo()=="RF",5,1),0 VTGet _cLote Pict "@!" Valid fValLot(_cOP,_cProd,_cLote)
									VTRead
									
									If vtLastKey() == 27
										Exit
									Else
										If !Empty(_cLote)
											_lOk := .T.
											Exit
										Endif
									Endif
								Enddo
							Else
								_lOk := .T.
							Endif
							
							If _lOk
								If VTYesNo("Confirma a separacao?","Sep. Balanca",.T.)
									// Marca o flag de separação para balança
									RecLock("SD4",.F.)
									SD4->D4_XSEPBAL := "S"
									SD4->(MsUnlock("SD4"))
								EndIf
								Loop
							Endif
							
						EndIf	
							
					Endif
				Endif
			Enddo
		Endif
		
		If vtLastKey() == 27
			If VTYesNo("Confirma a saida?","Atencao",.T.)
				Exit
			EndIf
			Loop
		Endif
	Enddo
	
Return

Static Function fValGet(cVar)
	If Empty(cVar)
		VtKeyBoard(chr(23))
		Return .F.
	EndIf
Return .T.

/*/{Protheus.doc} fValOP
Função de validação da OP informada
@type function
@author Funaki
@since 15/06/2018
@version 1.0
@param _pOP, ${STRING}, Número da OP informada no coletor
@return ${.T./.F.}, ${Retorna se a OP é válida ou não}
/*/
Static Function fValOP(_pOP)
	// Verifica se a OP informada existe
	dbSelectArea("SC2")
	SC2->(dbSetOrder(1))
	SC2->(dbGoTop())
	If !SC2->(dbSeek(xFilial("SC2")+Alltrim(_pOP)))
		VtAlert(,"OP nao encontrada",.t.,4000,3)
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	Else
		If !Empty(SC2->C2_DATRF)
			VtAlert(,"OP ja encerrada",.t.,4000,3)
			VtKeyboard(Chr(20))  // zera o get
			Return .F.
		Endif
	Endif
Return(.T.)

/*/{Protheus.doc} fValPrd
Função para validação do produto informado
@type function
@author Funaki
@since 15/06/2018
@version 1.0
@param _pOP, ${STRING}, Número da OP
@param _pProd, ${STRING}, Código do produto lido
@param _pLoteSd4, ${STRING}, Número do lote na SD4
@return ${.T./.F.}, ${Retorna se o produto é válido ou não}
/*/
Static Function fValPrd(_pOP,_pProd,_pLoteSd4)

	// Verifica se o produto está na OP informada
	dbSelectArea("SD4")
	SD4->(dbSetOrder(2))
	SD4->(dbGoTop())
	SD4->(dbSeek(xFilial("SD4")+_pOP+Alltrim(_pProd)))
	
	If !SD4->(Found())
		VtAlert("Produto nao econtrado na OP informada","Prod nao encontrado",.t.,4000,3)
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	Endif
	
Return(.T.)

/*/{Protheus.doc} fValLot
Função de validação do lote informado
@type function
@author Funaki
@since 15/06/2018
@version 1.0
@param _pLote, ${STRING}, Número do lote
@param _pLoteSd4, ${STRING}, Número do lote na SD4
@return ${.T./.F.}, ${Retorna se o lote informado é o mesmo do empenho}
/*/
Static Function fValLot(cOP,cCodPrd,cLote)

	Local cQuery	:= "" 
	Local cAlSD4	:= ""
	Local _nLimTol	:= 0

	cQuery := "	SELECT " + CRLF
	cQuery += "		R_E_C_N_O_ REGNO " + CRLF
	cQuery += "	FROM " + RetSqlName("SD4") + " " + CRLF 
	cQuery += "	WHERE " + CRLF 
	cQuery += "	       D4_FILIAL  = '" + xFilial("SD4") + "' " + CRLF
	cQuery += "	   AND D4_OP      = '" + cOP + "' " + CRLF
	cQuery += "	   AND D4_COD     = '" + cCodPrd + "' " + CRLF
	cQuery += "	   AND D4_LOTECTL = '" + cLote + "' " + CRLF
	cQuery += "	   AND D_E_L_E_T_ = ' ' " + CRLF

	MemoWrite("C:\TEMP\fValLot.SQL",cQuery)

	cQuery := ChangeQuery(cQuery)
	cAlSD4 := MPSysOpenQuery(cQuery)	

	If (cAlSD4)->(Eof())
		VtAlert("Lote do Produto incorreto.","Por favor verifique se este lote pertence a esta OP/Produto.",.t.,4000,3)
		VtKeyboard(Chr(20))  // zera o get
		Return .F.
	EndIf
	
	nRegNo := (cAlSD4)->REGNO
	(cAlSD4)->(dbCloseArea())

	dbSelectArea("SD4")
	SD4->(dbGoTo(nRegNo))
	
	// Se o produto controla lote, verifica se existe na SD4
	If Posicione("SB1",1,xFilial("SB1")+Alltrim(cCodPrd),"B1_RASTRO") == "L"
	
		If Empty(SD4->D4_LOTECTL)
			VtAlert("Ajuste o empenho antes da separacao","Produto sem lote",.t.,4000,3)
			VtKeyboard(Chr(20))  // zera o get
			Return .F.
		Else
		
			// Verifica se o lote ainda possui saldo para pesagem, considerando a tolerância
			_nLimTol := SD4->D4_QTDEORI * (Posicione("SB1",1,xFilial("SB1")+cCodPrd,"B1_XTOOP") / 100)
			
			If ((SD4->D4_QTDEORI + _nLimTol) - U_A10001GP(cOP,cCodPrd,SD4->D4_LOTECTL)) <= 0
				VtAlert("Produto ja separado","Produto separado",.t.,4000,3)
				VtKeyboard(Chr(20))  // zera o get
				Return .F.
			Endif
			
			_pLoteSd4 := SD4->D4_LOTECTL
			
		Endif
		
	Endif	

Return(.T.)








