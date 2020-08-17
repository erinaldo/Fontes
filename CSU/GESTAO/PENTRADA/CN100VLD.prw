#Include "Protheus.Ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN100VLD  ºAutor  ³ALINE CATARINA      º Data ³  11/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualizacao do Valor Inicial, Valor Atual e Saldo do        º±±
±±º          ³Contrato, de acordo com o tipo e pagamento especificado     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Customizacao no Gestao de Contratos                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CN100VLD()
	Local aArea	     := GetArea()
	//Armazena o Valor Total das Planilhas
	Local nTotPlan   := 0
	//Armazena o Total de Reajuste das Planilhas
	Local nReajsPl   := 0
	//Armazena o Total de Reajuste das Planilhas
	Local nTotReal   := 0
	//Linha posicionada
	Local nLin	     := 0
	//Posicao do campo CNA_VLTOT da planilha
	Local nPosVLTOT  := aScan(aHeader3,{ |x| UPPER(AllTrim(x[2])) == "CNA_VLTOT"})   
	//Posicao do campo CNA_REAJS da planilha
	Local nPosREAJPL := aScan(aHeader3,{ |x| UPPER(AllTrim(x[2])) == "CNA_REAJS"}) 
	//Posicao do campo CNF_VLREAL do cronograma
	Local nPosVLREAL := aScan(aHeader4,{ |x| UPPER(AllTrim(x[2])) == "CNF_VLREAL"}) 
	  
	
	DbSelectArea("CN1")
	DbSetOrder(1)       
	If DbSeek(xFilial("CN1")+M->CN9_TPCTO) 
		If Len(aCols3) > 0
			For nLin := 1 To Len(aCols3)
				nTotPlan += aCols3[nLin, nPosVLTOT] 
				nReajsPl += aCols3[nLin, nPosREAJPL] 
			Next nLin
		Endif

		If Len(aCols4) > 0
			For nLin := 1 To Len(aCols4)
				nTotReal += aCols4[nLin, nPosVLREAL] 
			Next nLin
		Endif
		
		If CN1->CN1_MEDEVE == "1" //Medicao Eventual
	   		If M->CN9_CTRT == "1" //Contrato Fixo		
				M->CN9_VLINI := nTotPlan - nReajsPl
				M->CN9_VLATU := nTotPlan 
				M->CN9_SALDO := nTotPlan - IIf(ValType(M->CN9_VLRPAG) == "C", 0, M->CN9_VLRPAG) 
				M->CN9_REAJS := nReajsPl
			ElseIf M->CN9_CTRT == "2" //Contrato Variavel
				If ValType(M->CN9_VLRPAG) == "N"
					M->CN9_VLINI := M->CN9_VLRPAG
					If ValType(M->CN9_REAJS) == "N"
						M->CN9_VLATU := M->CN9_VLRPAG + M->CN9_REAJS
						M->CN9_SALDO := M->CN9_VLRPAG + M->CN9_REAJS
					ElseIf ValType(M->CN9_REAJS) == "C"
						M->CN9_VLATU := M->CN9_VLRPAG					
						M->CN9_SALDO := M->CN9_VLRPAG
					EndIf
				ElseIf ValType(M->CN9_VLRPAG) == "C"
					M->CN9_VLINI := 0
					If ValType(M->CN9_REAJS) == "N"
						M->CN9_VLATU := M->CN9_REAJS
						M->CN9_SALDO := M->CN9_REAJS
					ElseIf ValType(M->CN9_REAJS) == "C"
						M->CN9_VLATU := 0
						M->CN9_SALDO := 0
					EndIf
				EndIf
			EndIf
		Else 
			M->CN9_VLINI := nTotPlan - nReajsPl    
			M->CN9_VLATU := nTotPlan
			M->CN9_SALDO := nTotPlan - nTotReal
			M->CN9_REAJS := nReajsPl
		EndIf

	EndIf
	
	M->CN9_XSDEST := M->CN9_XVLEST		//Melhoria solicitada, Valor estimado e saldo estimado - Carlos 11/06
	             
	RestArea(aArea)
Return .T.