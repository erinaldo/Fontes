#INCLUDE "PROTHEUS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCOME15
Gera Contrato na analise de cota็ใo
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CCOME15(nOpc,cContr, aDadosCot, aDadosCompl)
Local aArea  		:= GetArea()
Local cQuery   	:= ''
Local nItem     	:= 0
Local nVlTtCNA  	:= 0
Local nVlTtCN9  	:= 0
Local aParam    	:= {}
Local nX			:= 0
Local nY 			:= 0
Local nZ		  	:= 0 
Local cFornec   	:= ""
Local cTpCto    	:= GETMV("FS_GCTCOT")
Local aContrGer 	:= {}
Local cMensagem 	:= ""
Local cContrato 	:= ""
Local aCTBEnt   	:= If(FindFunction("CTBEntArr"),CTBEntArr(),{})
Local cFilAtual 	:= "", cFilSC8 := "" 
local aCotXCtr	:= {}
Local nPosCont	:= 0
Private aRet    	:= {}

//Abertura das Tabelas de Contrato
ChkFile("CN9")
ChkFile("CNA")
ChkFile("CNB")
ChkFile("CNN")

//Exibe Tela de Parametros
If !GeraGCTParam(@aRet)
	Return .F.
End If

//Separa Ganhadores por Contrato
aDadosContr := SeparaGanhador(aDadosCot, aDadosCompl)

Begin Transaction

//Contratos a serem gerados (1 por fornecedor vencedor)
For nX := 1 to Len(aDadosContr)

	cContrato := GetSXENum("CN9","CN9_NUMERO")
	While CN9->(dbSeek(xFilial("CN9")+cContrato))
		CN9->(ConfirmSX8())
		cContrato := GetSXENum("CN9","CN9_NUMERO")
	EndDo
	
	//Reserva o numero da planilha
	cPlanilha := GetSxENum("CNA","CNA_NUMERO")
	cPlanilha := StrZero( 1, Len(cPlanilha))	
	
	nItem := 1
	
	//Itens Contrato
	For nY := 1 to Len(aDadosContr[nX])
		
		//Se o item for o vencedor
		If !Empty( aDadosContr[nX][nY][1] )
			
			DbSelectArea("SC8")
			SC8->( DbSetOrder(1) )
			
			//Busca cotacao
			If SC8->( DbSeek( xFilial("SC8")+cContr+aDadosContr[nX][nY][2]+aDadosContr[nX][nY][3]+;
				aDadosContr[nX][nY][13] ) ) //C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO

				//============================================================
				//Gera contrato na filial de origem				
				//============================================================                        
                //Este processo ้ disparado pelo usuario uma vez para cada linha da SC8! Enfim, nao hแ co,mo executแ-lo uma ๚nica vez para todos os registros da SC8
				cFilAtual := cFilAnt
				cFilAnt   := SC8->C8_FILENT				
								
				cFilAnt   := cFilAtual

				//serแ utilizada ao final do procedimento
				cFilSC8 := SC8->C8_FILENT				
				//==============================================================
								
				cNumOld := SC8->C8_NUM
				cFornec := SC8->C8_FORNECE
				cLoja   := SC8->C8_LOJA
				cDtIni  := SC8->C8_EMISSAO
				cCondPg := SC8->C8_COND
				
				SC1->(dbSetOrder(1))
				SC1->(dbSeek(xFilial("SC1")+SC8->C8_NUMSC+SC8->C8_ITEMSC))
				//atualiza o Flag da SC para "integra็ใo com o GCT"
				If Empty(SC1->C1_FLAGGCT)
					RecLock("SC1",.F.)
					SC1->C1_FLAGGCT := "1"
					MsUnlock("SC1")
				Endif
				
				RecLock("SC8",.F.)
				SC8->C8_XGCT := cContrato //Numero aditivo contrato
				SC8->(MsUnLock())
				
				//Grava CNB - Itens Contrato
				DbSelectArea("CNB")
				RecLock("CNB", .T.)    
				
				CNB->CNB_FILIAL := SC8->C8_FILENT
				
				If CNB->(FieldPos("CNB_FILORI")) > 0
				    CNB->CNB_FILORI := SC8->C8_FILIAL 
				EndIf

				CNB_NUMERO := cPlanilha
				CNB_ITEM   := StrZero(nItem, 3)
				CNB_PRODUT := SC8->C8_PRODUTO
				CNB_DESCRI := Posicione("SB1",1,xFilial("SB1")+SC8->C8_PRODUTO,"SB1->B1_DESC")
				CNB_UM     := SC8->C8_UM
				CNB_QUANT  := SC8->C8_QUANT
				CNB_VLUNIT := SC8->C8_PRECO
				CNB_VLTOT  := SC8->C8_TOTAL  
				CNB_VLFUTU := SC8->C8_TOTAL
				CNB_CONTRA := cContrato
				CNB_DTCAD  := aRet[1]
				CNB_SLDMED := SC8->C8_QUANT
				CNB_SLDREC := SC8->C8_QUANT
				CNB_CONTA  := SC1->C1_CONTA
				CNB_CC     := SC1->C1_CC
				CNB_ITEMCT := SC1->C1_ITEMCTA
				CNB_CLVL   := SC1->C1_CLVL
				
				AADD(aCotXCtr,{SC8->(C8_NUM,C8_PRODUTO),cContrato})
				
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(XFilial("SB1")+SC8->C8_PRODUTO))
				
				For nZ := 1 To Len(aCTBEnt)
					If CNB->(FieldPos("CNB_EC"+aCTBEnt[nZ]+"CR")) > 0
						If SC1->(FieldPos("C1_EC"+aCTBEnt[nZ]+"CR")) > 0
							&("CNB_EC"+aCTBEnt[nZ]+"DB") := SC1->&("C1_EC"+aCTBEnt[nZ]+"DB")
							&("CNB_EC"+aCTBEnt[nZ]+"CR") := SC1->&("C1_EC"+aCTBEnt[nZ]+"CR")
						Else
							&("CNB_EC"+aCTBEnt[nZ]+"DB") := SB1->&("B1_EC"+aCTBEnt[nZ]+"DB")
							&("CNB_EC"+aCTBEnt[nZ]+"CR") := SB1->&("B1_EC"+aCTBEnt[nZ]+"CR")
						EndIf
					EndIf
				Next nZ
				
				CNB->(MsUnlock())
				nItem++    
				nVlTtCNA += SC8->C8_TOTAL				         
				
				// Estorno de Movimentos de SC
				_cLanctoCT := Alltrim(GetNewPar("SI_PCOCTSC","900051"))

				IF PcoExistLc(_cLanctoCT,"01","1")
					SZW->(dbSetOrder(1))
					IF SZW->(MsSeek(xFilial("SZW")+SC1->(C1_NUM+C1_ITEM)))
						
						_cFilBkp := cFilAnt
						While SZW->(!Eof()) .and. SZW->(ZW_FILIAL+ZW_NUMSC+ZW_ITEMSC) == XFilial("SZW")+SC1->(C1_NUM+C1_ITEM)
							// Altera empresa
							cFilAnt := SZW->ZW_CODEMP
							
							_NPERCEMP := SZW->ZW_PERC
							                              
							// Inclusใo dos Movimentos do Contrato
							PcoIniLan(_cLanctoCT)
							PcoDetLan(_cLanctoCT,'01','MATA110')
							PcoFinLan(_cLanctoCT)
							
							// Restaura filial
							cFilAnt := _cFilBkp
							
							SZW->(dbSkip())
						Enddo
					ELSE		
						// Inclusใo dos Movimentos do Contrato
						PcoIniLan(_cLanctoCT)
						PcoDetLan(_cLanctoCT,'01','MATA110')
						PcoFinLan(_cLanctoCT)
					ENDIF
					
					_NPERCEMP := 0
					
				ENDIF    
				
			End If
			
		End If
		
	Next
	
	//Grava CNA - Planilha Contrato
	RecLock("CNA", .T.)
	CNA->CNA_FILIAL := SC8->C8_FILENT
	CNA->CNA_CONTRA := cContrato
	CNA->CNA_NUMERO := cPlanilha
	CNA->CNA_FORNEC := cFornec
	CNA->CNA_LJFORN := cLoja
	CNA->CNA_DTINI  := aRet[1]
	CNA->CNA_VLTOT  := nVlTtCNA
	CNA->CNA_SALDO  := nVlTtCNA
	CNA->(MsUnLock())
	
	nVlTtCN9 += nVlTtCNA
	nVlTtCNA :=	0
	
	//Grava CNN - Usuario x Contrato
	RecLock("CNN", .T.)
	CNN->CNN_FILIAL := SC8->C8_FILENT
	CNN->CNN_CONTRA := cContrato
	CNN->CNN_USRCOD := aRet[2]
	CNN->CNN_TRACOD := "001"
	CNN->CNN_GRPCOD := ""
	CNN->(MsUnLock())
	
	//Grava CNC - Fornecedor x Contrato
	RecLock("CNC", .T.)
	CNC->CNC_FILIAL := SC8->C8_FILENT
	CNC->CNC_NUMERO := cContrato
	CNC->CNC_CODIGO := cFornec
	CNC->CNC_LOJA   := cLoja
	CNC->(MsUnLock())
	
	//Grava CN9 - Cabe็alho Contrato
	RecLock("CN9", .T.)    
	CN9->CN9_FILIAL 	:= SC8->C8_FILENT     
	
	If CN9->(FieldPos("CN9_FILORI")) > 0
    	CN9->CN9_FILORI := SC8->C8_FILIAL
	EndIf	

	CN9->CN9_NUMERO 		:= cContrato
	CN9->CN9_VLINI  		:= nVlTtCN9
	CN9->CN9_VLATU  		:= nVlTtCN9
	CN9->CN9_SALDO		:= nVlTtCN9
	CN9->CN9_SITUAC		:= "02" // EM ELABORACAO
	CN9->CN9_DTINIC 		:= aRet[1]
	CN9->CN9_CONDPG		:= cCondPg
	CN9->CN9_TPCTO		:= aRet[3]
	CN9->CN9_MOEDA		:= 1                
	CN9->CN9_XCOT       	:= cNumOld      
	CN9->(MsUnlock())

	//==================================================
	//Tratamento de controle de numera็ใo na filial de origem
	cFilAtual := cFilAnt
	cFilAnt   := cFilSC8	

	CN9->(ConfirmSX8())
	CNA->(ConfirmSX8())

	cFilAnt := cFilAtual                                
	//==================================================
	
	aAdd( aContrGer , {cContrato, cFornec + "/" + cLoja} )
	
Next nX

End Transaction
//Atualizo os dados da Cota็ใo para que as nใo seja possivel analisar os perdedores novamente
//Para isso eu preencho os campos C8_NUMPED e C8_ITEMPED com "XXXX" assim como ้ feito no Padrใo
For nX := 1 to Len(aDadosCot)
	For nY := 1 to Len(aDadosCot[nX])
		dbSelectArea("SC8")
		SC8->(dbsetorder(1)) //C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_ITEMGRD                                                                                             
	
		If SC8->(dbSeek(xFilial("SC8")+cContr+aDadosCot[nX][nY][2]+aDadosCot[nX][nY][3]+aDadosCot[nX][nY][13]))
			RecLock("SC8",.F.)
			SC8->C8_NUMPED  := Repl("X",Len(SC8->C8_NUMPED))
			SC8->C8_ITEMPED := Repl("X",Len(SC8->C8_ITEMPED))
			
			IF (nPosCont:= ASCAN(aCotXCtr,{|x| x[1]==SC8->(C8_NUM,C8_PRODUTO) })) > 0
				SC8->C8_XGCT :=  aCotXCtr[nPosCont][2]
			Endif
			
			MsUnlock("SC8")
		Endif
			
	Next nY
Next nX

For nX := 1 to Len(aContrGer)
	cMensagem += "Contrato n๚mero: " + aContrGer[nX][1] + " gerado com sucesso para o fornecedor: " + aContrGer[nX][2] + "." + CHR(13)+CHR(10)
	if !Empty(cFilSC8)	
		cMensagem +=  "Vide Filial: '" + cFilSC8 + "' !"
	EndIF
Next

If !Empty(aContrGer)
	Aviso( "Gera็ใo de Contrato", cMensagem, {"Ok"} )
EndIf

RestArea(aArea)
Return (.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSeparaGanhadorบAutor  ณMicrosiga       บ Data ณ  10/26/11   บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SeparaGanhador(aDadosCot, aDadosCompl)
Local aGanhadores 	:= {}
Local aFornecID 	:= {}
Local aFornec		:= {}
Local nX, nY		:= 0

//Verifica ganhadores
For nX := 1 to Len(aDadosCot)
	
	For nY := 1 to Len(aDadosCot[nX])
		
		If !Empty( aDadosCot[nX][nY][1] )
			aAdd( aDadosCot[nX][nY], aDadosCompl[nX][nY][10][2] )
			aAdd( aGanhadores, aDadosCot[nX][nY] )
			
		End If
	Next
	
Next

//Separa Ganhadores por Fornecedor
For nX := 1 to Len(aGanhadores)
	
	nPosFor := aScan( aFornecID, aGanhadores[nX][2] )
	
	If nPosFor = 0
		
		aAdd(  aFornec, {} 								)
		aAdd(  aFornec[Len(aFornec)], aGanhadores[nX]  )
		aAdd( aFornecID, aGanhadores[nX][2] 			)
		
	Else
		
		aAdd( aFornec[nPosFor], aGanhadores[nX] )
		aAdd( aFornecID, aGanhadores[nX][2]     )
		
	End If
	
Next

Return aFornec

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraGCTParam บAutor  ณMicrosiga        บ Data ณ  08/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exibe tela de parametros para geracao de contrato          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraGCTParam(aRet)
Local aParam := {}
Local lRet   := .F.

//Array com o retorno do parambox
AAdd(aRet,dDatabase)   							// Data da Assinatura
AAdd(aRet,Space(15))   	 						// Usuario
AAdd(aRet,Space(TamSX3("CN9_TPCTO")[1]))   	// Tipo Contrato

//Array com a configuracao do parambox
AAdd(aParam,{1,"Data Assinatura"	,aRet[1],"@D"	,"",""   ,"",50,.T.})
AAdd(aParam,{1,"Usuario"				,aRet[2],""	,"UsrExist(MV_PAR02)","USR","",60,.T.})
AAdd(aParam,{1,"Tipo de Contrato"	,aRet[3],""	,"ExistCpo('CN1')","CN1","",60,.T.})

//Define titulo, indicando o item
cTit1:= "Dados para gera็ใo do contrato"

//Chamada da funcao parambox()
lRet := ParamBox(aParam,cTit1,@aRet,{||.T.},,.T.,80,3,,,,.F.)

Return lRet
