#INCLUDE "CNTA130.ch"                       
#INCLUDE "FIVEWIN.CH"       
#INCLUDE "Protheus.ch"
                
//Situacoes de contrato
#DEFINE DEF_SCANC "01" //Cancelado
#DEFINE DEF_SELAB "02" //Em Elaboracao
#DEFINE DEF_SEMIT "03" //Emitido
#DEFINE DEF_SAPRO "04" //Em Aprovacao
#DEFINE DEF_SVIGE "05" //Vigente
#DEFINE DEF_SPARA "06" //Paralisado
#DEFINE DEF_SSPAR "07" //Sol Fina.
#DEFINE DEF_SFINA "08" //Finalizado
#DEFINE DEF_SREVS "09" //Revisao
#DEFINE DEF_SREVD "10" //Revisado

#DEFINE DEF_TRAVIS "035" //Visualizacao de Medicoes

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS430Manut³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Manutencao de Medicoes                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS430Manut()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CS430Manut(cAlias,nReg,nOpc,xParam,cContra,cRevisa,cCompet,cPlan,lMedeve,lFisico)
Local odlg
Local aInfo
Local cFilCod
Local nA
Local nPosCampo
Local nPosItem
Local nPosProd
Local nPosDescr
Local nPosVlUn
Local nPosPerc    
Local nPosQMed
Local nPosQSol
Local nPosQtd  
Local nPosPDesc
Local nPosDesc         
Local nPosVlT
Local nPosNum
Local nPosItm 
Local nTotMultas := 0 
Local nTotBoni   := 0  
Local nOpca
Local nx
Local nUsado     := 0
Local aCpoEnch  := {} 
Local aNCpo     := {"CND_VLTOT","CND_VLPREV","CND_DTINIC","CND_VLMEAC","CND_VLSALD","CND_DATAIN","CND_DATAFI","CND_VLCONT","CND_VLADIT","CND_VLREAJ","CND_VLGER","CND_MEDRET","CND_RETIFI","CND_FLREAJ","CND_DESCME","CND_RETCAC"}
Local aNalter   := {"CNE_PRODUT","CNE_VLUNIT","CNE_PDESC"}
Local aAlter    := {}
Local cCadastro := STR0007//"Medição"
Local aCond     := {}            
Local lRet      := .F.
Local nSaveSX8  := GetSX8Len()
Local aButtons  := {} 
Local aDescs    := {}
Local aHeadDcs  := {}
Local nPercCNF  := 0 //Percentual da parcela em relacao ao total da planilha
Local nTotDesc  := 0
Local nTotPrev  := 0
Local lSugVal   := ((GetNewPar("MV_CNSUGME","1")=="1") .OR. lFisico)//Informa se sugere ou nao as quantidade da medicao
Local lContinua := .T.
Local lFlgPed   := CNR->( FieldPos("CNR_FLGPED") ) > 0
Local cFilCNP   := xFilial("CNP")

Local oGetDesc
Local oGetPrev
Local oGetMultas 
Local oGetBoni

Local lPreench               
Local cAliasCNR := "" 

Local aMultParc := {}
Local aMultas   := {} 

Local lMultaBoni:= !Empty( CN4->( FieldPos( "CN4_VLDALT" ) ) ) 

Local lCaucRet := .F.

If aRotina[nOpc,4] == 2
	lContinua := CN240VldUsr(CND->CND_CONTRA,DEF_TRAVIS,.T.)
EndIf

If lContinua
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa lancamento do PCO  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoIniLan("000355")

	PRIVATE aCols     := {}
	PRIVATE aHeader   := {}
	PRIVATE lFixo     := .T.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa rotina de ajuste do SXB                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CS430AjSXB()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa rotina de ajuste do SX3                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CS430AjSX3()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica tipo do contrato                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If lFisico == Nil
		dbSelectArea("CN9")
		dbSetOrder(1)
		If dbSeek(xFilial("CN9")+If(cContra!=NIL,cContra+cRevisa,CND->CND_CONTRA+CND->CND_REVISA))
			lFisico := ((CN1->(FieldPos("CN1_CROFIS")) > 0) .And. Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_CROFIS") == "1")
		Else
			lFisico := .F.
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o contrato possui planilha      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ        
	If CN1->( FieldPos("CN1_CTRFIX") ) > 0
		dbSelectArea("CN9")
		dbSetOrder(1)
		If dbSeek(xFilial("CN9")+If(cContra!=NIL,cContra+cRevisa,CND->CND_CONTRA+CND->CND_REVISA))
			dbSelectArea("CN1")
			dbSetOrder(1)
			If dbSeek(xFilial("CN1")+CN9->CN9_TPCTO)
				lFixo := Empty(CN1->CN1_CTRFIX) .Or. (CN1->CN1_CTRFIX == "1") .Or. (CN9->CN9_CTRT = "1")
			EndIf
		EndIf
	else
		dbSelectArea("CN9")
		dbSetOrder(1)
		If dbSeek(xFilial("CN9")+If(cContra!=NIL,cContra+cRevisa,CND->CND_CONTRA+CND->CND_REVISA))
			lFixo :=(CN9->CN9_CTRT = "1")
		endif	
	EndIf
    if !Empty(cPlan)
    	lFixo := .T.
    endif
	dbSelectArea("SX3")
	MsSeek("CND")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona os campos do cabecalho da medicao        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof() .And. SX3->X3_ARQUIVO == "CND"
		
		If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_CAMPO != "CND_FILIAL" .And. aScan(aNCpo,{|x| x == AllTrim(SX3->X3_CAMPO)}) == 0
			Aadd(aCpoEnch, SX3->X3_CAMPO )
		EndIF
	
		If	( SX3->X3_CONTEXT == "V"  .Or. nOpc == 3 )
			If SX3->X3_CAMPO == "CND_NUMMED" .And. lAuto .And. (nPosNum := aScan(aAutoCab,{|x| x[1]=="CND_NUMMED"})) > 0
				M->CND_NUMMED := aAutoCab[nPosNum,2]
			Else
				M->&(SX3->X3_CAMPO) := CriaVar(SX3->X3_CAMPO)
			EndIf
		Else
			M->&(SX3->X3_CAMPO) := CND->(FieldGet(FieldPos(SX3->X3_CAMPO)))
		EndIf
		
		dbSelectArea("SX3")
		dbSkip()
	EndDo         
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao de variaveis Privates.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aTela[0][0]
	Private aGets[0]
	Private aSize     := MsAdvSize(,.F.,430)
	Private aObjects  := {}
	Private aPosObj   := {}
	
	//Campos excluidos na mostagem do aHeader
	Private aCpoNH    := {"CNE_FILIAL","CNE_TIPO","CNE_DTANIV","CNE_CONTRA","CNE_REVISA","CNE_NUMERO","CNE_NUMMED","CNE_ITSOMA","CNE_QTRETI","CNE_PEDIDO"}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche moeda da medicao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty( CND->( FieldPos( "CND_MOEDA" ) ) )
		M->CND_MOEDA := If(!Empty(CN9->CN9_MOEDA),CN9->CN9_MOEDA,1)
	EndIF
	
	If !lFixo
		aAdd(aCpoNH,"CNE_QTDSOL")
		aAdd(aCpoNH,"CNE_QTAMED")
		aAdd(aCpoNH,"CNE_PERC")
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Devolve o tamanho da tela atualmente no micro do usuario.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aSizeAut := MsAdvSize()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Total da medicao             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private M->CND_VLTOT := 0
	Private oGetTot
	Private oGetCauc
	Private nCaucRet     := Nil
	Private nCaucVlr     := Nil
	Private nTotMedDsc   := 0//Valor total dos descontos aplicados na medicao
	Private nTotMedMlt   := 0//Valor total das multas aplicadas na medicao
	Private nTotMedBnf   := 0//Valor total das bonificaoes aplicadas na medicao
	Private nTotMed  := 0
	
	AAdd( aObjects, { 0,    60, .T., .F. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 0,    50, .T., .F. } )
	
	aInfo   := { aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3 }
	aPosObj := MsObjSize(aInfo, aObjects)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera o aHeader para os campos da GetDados. ³
	//³ Excluindo campos da aCpoNH                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("CNE")
	While !EOF() .And. (SX3->X3_ARQUIVO == "CNE")
		If X3Uso(X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. Ascan(aCpoNH,{|x| x == alltrim(SX3->X3_CAMPO)}) == 0
			nUsado++
	
			Aadd(aHeader, { alltrim( X3Titulo() ),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_F3,;
			SX3->X3_CONTEXT } )

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impede alteracao dos campos no array aNAlter     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			If SX3->X3_VISUAL == "A" .And. aScan(aNAlter,AllTrim(SX3->X3_CAMPO)) == 0
				aAdd(aAlter,SX3->X3_CAMPO)
			EndIf
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a caucao de retencao esta disponivel ³
	//³ para contrato e para o ambiente                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If (lCaucRet := (CND->(FieldPos("CND_RETCAC")) > 0 .And. CN9->CN9_TPCAUC == "2"))
		nCaucRet := CN9->CN9_MINCAU	
	EndIf
	
	if nOpc == 3//Inclusao
		M->CND_CONTRA := cContra
		M->CND_REVISA := cRevisa
		M->CND_COMPET := cCompet
		If lFixo
			M->CND_NUMERO := cPlan
		EndIf
	   
		If lFixo
			dbSelectArea("CNA")
			dbSetOrder(1)
			cFilCod := xFilial()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Seleciona planilha                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			if dbSeek(cFilCod+cContra+cRevisa+cPlan)
				M->CND_FORNEC := CNA->CNA_FORNEC
				M->CND_LJFORN := CNA->CNA_LJFORN
				M->CND_TIPPLA := CNA->CNA_TIPPLA 
				M->CND_DESCTP := Posicione("CNL",1,xFilial("CNL")+M->CND_TIPPLA,"CNL_DESCRI")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Quando o contrato nao estiver configurado para     ³
				//³ medicao eventual, seleciona o valor previsto do    ³
				//³ cronograma                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !lMedeve
					dbSelectArea("CNF")
					dbSetOrder(2)
				 	If dbSeek(xFilial("CNF")+cContra+cRevisa+CNA->CNA_CRONOG+cCompet)
						nTotPrev := CNF->CNF_SALDO
						If lSugVal
							nPercCNF := (CNF->CNF_SALDO*100)/CNA->CNA_VLTOT//Calcula percentual da parcela
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf

		dbSelectArea("CN9")
		dbSetOrder(1)
		cFilCod := xFilial()
		if dbSeek(cFilial+cContra+cRevisa)
			M->CND_CONDPG := CN9->CN9_CONDPG 
			M->CND_DESCCP := Posicione("SE4",1,xFilial("SE4")+M->CND_CONDPG,"E4_DESCRI")
			M->CND_VLCONT := CN9->CN9_VLATU
			M->CND_VLADIT := CN9->CN9_VLADIT
			M->CND_VLREAJ := CN9->CN9_VLREAJ
			
			If !lMedeve
				M->CND_DTVENC := CNF->CNF_DTVENC
			else
				aCond := Condicao(0,M->CND_CONDPG,,dDataBase)
				If len(aCond) > 0
					M->CND_DTVENC := aCond[1][1]
				Else
					M->CND_DTVENC := dDataBase
				EndIf
			EndIf
		EndIf

	   If lFixo
			nPosItem := aScan(aHeader,{|x| x[2] == "CNE_ITEM  "})
			nPosProd := aScan(aHeader,{|x| x[2] == "CNE_PRODUT"})
			nPosDescr:= aScan(aHeader,{|x| x[2] == "CNE_DESCRI"})
			nPosVlUn := aScan(aHeader,{|x| x[2] == "CNE_VLUNIT"})
			nPosPerc := aScan(aHeader,{|x| x[2] == "CNE_PERC  "})
			nPosQMed := aScan(aHeader,{|x| x[2] == "CNE_QTAMED"})
			nPosQSol := aScan(aHeader,{|x| x[2] == "CNE_QTDSOL"})
			nPosQtd  := aScan(aHeader,{|x| x[2] == "CNE_QUANT "})      
			nPosPDesc:= aScan(aHeader,{|x| x[2] == "CNE_PDESC "})
			nPosDesc := aScan(aHeader,{|x| x[2] == "CNE_VLDESC"})
			nPosVlT  := aScan(aHeader,{|x| x[2] == "CNE_VLTOT "})
			nPosDEnt := aScan(aHeader,{|x| x[2] == "CNE_DTENT "})
		
			cFilCod := xFilial("CNB")
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta o aCols.                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("CNB")
			dbSetOrder(1)
			MsSeek(cFilCod + cContra + cRevisa + cPlan)
			
			While CNB->CNB_FILIAL == cFilCod .And. CNB->CNB_CONTRA == cContra .And. CNB->CNB_REVISA == cRevisa .And. CNB->CNB_NUMERO == cPlan
				if CNB->CNB_SLDMED > 0
					Aadd(aCols, Array(nUsado + 1))
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Inicializa campos da getdados                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For nA:=1 to len(aHeader)
						aCols[len(aCols),nA] := CriaVar(aHeader[nA,2])
					Next
			
					aCols[len(aCols),nPosItem] := CNB->CNB_ITEM
					aCols[len(aCols),nPosProd] := CNB->CNB_PRODUT
					aCols[len(aCols),nPosDescr]:= CNB->CNB_DESCRI
					aCols[len(aCols),nPosVlUn] := CNB->CNB_VLUNIT
					aCols[len(aCols),nPosQSol] := CNB->CNB_QUANT
					aCols[len(aCols),nPosQMed] := CNB->CNB_SLDMED
					aCols[len(aCols),nPosPDesc]:= CNB->CNB_DESC
		
					If lMedeve .OR. !lSugVal
						aCols[len(aCols),nPosQtd] := 0.00
						aCols[len(aCols),nPosVlT] := 0.00
						aCols[len(aCols),nPosPerc]:= 0.00
						aCols[len(aCols),nPosDesc]:= 0.00
					Else
						If !lFisico      
							aCols[len(aCols),nPosQtd] := (CNB->CNB_QUANT*nPercCNF)/100
							If CNB->CNB_SLDMED < aCols[len(aCols),nPosQtd]
								aCols[len(aCols),nPosQtd] := CNB->CNB_SLDMED
							EndIf
						Else
							dbSelectArea("CNS")
							dbSetOrder(1)
							
							If dbSeek(xFilial("CNS")+cContra+cRevisa+CNF->CNF_NUMERO+CNF->CNF_PARCEL+CNB->CNB_ITEM)
								aCols[len(aCols),nPosQtd] := CNS->CNS_SLDQTD
								If CNB->CNB_SLDMED < aCols[len(aCols),nPosQtd]
									aCols[len(aCols),nPosQtd] := CNB->CNB_SLDMED
								EndIf							
							EndIf
						EndIF			
						aCols[len(aCols),nPosVlT] := aCols[len(aCols),nPosQtd]*CNB->CNB_VLUNIT
						aCols[len(aCols),nPosPerc]:= (aCols[len(aCols),nPosQtd]*100)/CNB->CNB_QUANT			
						
						aCols[len(aCols),nPosDesc]:= (aCols[len(aCols),nPosVlT]*CNB->CNB_DESC)/100
						M->CND_VLTOT += aCols[len(aCols),nPosVlT]-aCols[len(aCols),nPosDesc]				
					EndIf
		
					aCols[len(aCols),nPosDEnt] := dDataBase
					                       
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atribui .F. p/ a coluna que determina se a linha do aCols esta deletada.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aCols[Len(aCols)][nUsado + 1] := .F.
				EndIf			
				dbSelectArea("CNB")
				dbSkip()
			EndDo
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada executado na inclusao da medicao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("CS430Inc")
			ExecBlock("CS430Inc",.f.,.f.) 
		EndIf
	   
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula valor da retencao                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   If lCaucRet
		   nCaucVlr:=((M->CND_VLTOT*nCaucRet)/100)
		EndIf
	Else//Alteracao,Visualizacao,Exclusao
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta o aCols.                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CNE")
		dbSetOrder(1)
		cFilCod := xFilial("CNE")          
		dbSeek(xFilial("CNE")+CND->CND_CONTRA+CND->CND_REVISA+CND->CND_NUMERO+CND->CND_NUMMED)
					
		while CNE->CNE_FILIAL = cFilCod .And. CNE->CNE_CONTRA = CND->CND_CONTRA .And. CNE->CNE_REVISA = CND->CND_REVISA .And.	CNE->CNE_NUMERO = CND->CND_NUMERO .And. CNE->CNE_NUMMED = CND->CND_NUMMED .And. !Eof()
			Aadd(aCols, Array(nUsado + 1))
			
			For nA := 1 To Len(aHeader)
				If aHeader[nA][10] <> "V"
					nPosCampo := FieldPos(aHeader[nA][2])
					
					If !Empty(nPosCampo)
						aCols[Len(aCols)][nA] := FieldGet(nPosCampo)
					EndIf
				Else
					aCols[Len(aCols)][nA] := CriaVar(aHeader[nA][2])
				EndIf
			Next nA
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atribui .F. p/ a coluna que determina se a linha do aCols esta deletada.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aCols[Len(aCols)][nUsado + 1] := .F.
			
			dbSelectArea("CNE")
			dbSkip()
		EndDo
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega valor total do desconto    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		nTotDesc     :=CND->CND_DESCME
		nTotPrev     :=CND->CND_VLPREV                    
		M->CND_VLTOT :=CND->CND_VLTOT

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega valor de retencao                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If CND->( FieldPos("CND_RETCAC") ) > 0 .And. !Empty(CND->CND_RETCAC)
			nCaucVlr:=CND->CND_RETCAC
		EndIf
	            
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o recurso de multa / bonificacao esta disponivel para a medicao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMultaBoni 
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega o array de multas / bonificacoes ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			
			cAliasCNR := GetNextAlias() 
			
			cQuery := "SELECT * FROM " + RetSqlName( "CNR" ) + " " 
			cQuery += "WHERE " 
			cQuery += "CNR_FILIAL='" + xFilial( "CNR" ) + "' AND " 
			cQuery += "CNR_NUMMED='" + CND->CND_NUMMED  + "' AND " 
			cQuery += "D_E_L_E_T_=' ' " 
			
			cQuery := ChangeQuery( cQuery ) 
			
			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasCNR, .F., .T. ) 
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Acerta o campo numerico                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			TcSetField( cAliasCNR, "CNR_VALOR", "N", 14, 2 ) 
			
			While !( cAliasCNR )->( Eof() ) 
			
				aMultParc := If(lFlgPed,Array( 5 ),Array( 4 ))
			
				aMultParc[ 1 ] := ( cAliasCNR )->CNR_TIPO   
				aMultParc[ 2 ] := ( cAliasCNR )->CNR_DESCRI 
				aMultParc[ 3 ] := ( cAliasCNR )->CNR_VALOR  
				aMultParc[ 4 ] := ( cAliasCNR )->CNR_MODO   
				If lFlgPed
					aMultParc[ 5 ] := ( cAliasCNR )->CNR_FLGPED
				EndIf
			
				AAdd( aMultas, aMultParc )	
				
				If ( cAliasCNR )->CNR_TIPO == "1"   
					nTotMultas += ( cAliasCNR )->CNR_VALOR
					//Soma as multas que interferem pedido
					If  ( cAliasCNR )->CNR_FLGPED == "1"
						nTotMedMlt += ( cAliasCNR )->CNR_VALOR
					EndIf
				ElseIf ( cAliasCNR )->CNR_TIPO == "2"
					nTotBoni   += ( cAliasCNR )->CNR_VALOR  						   			
					//Soma as bonificacoes que interferem pedido
					If  ( cAliasCNR )->CNR_FLGPED == "1" 
						nTotMedBnf += ( cAliasCNR )->CNR_VALOR
					EndIf
				EndIf 
			
				( cAliasCNR )->( dbSkip() ) 		
			
			EndDo 	
			
			( cAliasCNR )->( dbCloseArea() ) 
			dbSelectArea( "CNR" )		
			
		EndIf
		
		//Carrega Descontos
		CS430PrcDesc(nOpc,aHeadDcs,aDescs)
		//Encontra posicoes
		nPosVlDesc:=aScan(aHeadDcs,{|x| x[2] == "CNQ_VALOR "})
		nPosTpDesc:=aScan(aHeadDcs,{|x| x[2] == "CNQ_TPDESC"})
		
		dbSelectArea("CNP")
		For nx:=1 to len(aDescs)
			//Soma os valores apenas dos descontos que afetam o pedido
			If dbSeek(cFilCNP+aDescs[nx,nPosTpDesc]) .And. CNP->CNP_FLGPED == "1"
				nTotMedDsc += aDescs[nx,nPosVlDesc]
			EndIf
		Next 			
		
	EndIf
	
	
	If lAuto
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Executa rotina automatica para os itens quando ³
		//³o usuario informar os itens, caso contrario    ³
		//³aceita o valor sugerido pela medicao se o      ³
		//³parametro MV_CNSUGME estiver ativo             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If len(aAutoItens) > 0
			If MsGetDAuto(aAutoItens,,{|| u_CS430TudOk()},aAutoCab,aRotina[nOpc][4])
			 	nOpca := 1
			Else
				nOpca := 0
			EndIf
		Else
			nOpca := 1
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Botao do Tracker                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aRotina[ nOpc, 4 ] == 2 
			aAdd(aButtons, { "ORDEM", { || u_CS430Track(aHeader,aCols) }, STR0012, STR0011 } ) //"System Tracker", "Tracker"
		EndIf
		
		Aadd(aButtons,{ "BUDGET",{|| CS430Desc(nOpc,@nTotDesc,aDescs,aHeadDcs),oGetDesc:Refresh(),CS430TotMed(5)},OemToAnsi(STR0014),OemtoAnsi(STR0013)})//"Cronogramas"

		If lFisico
			Aadd(aButtons,{ "BPMSRELAA",{|| (If(u_CS410VisFis(M->CND_CONTRA,M->CND_REVISA,M->CND_NUMERO,M->CND_COMPET,oGetDados,(aRotina[ nOpc, 4 ] == 2)),(M->CND_VLTOT:=nTotPrev,CS430TotMed(5)),))},OemToAnsi("Fisico"),OemtoAnsi("Fisico")})
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Botao das multas / bonificacoes                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMultaBoni 
			AAdd( aButtons,{ "CHECK", {|| CS430Multas( aMultas, oGetDados:aCols, oGetDados:aHeader, aRotina[ nOpc, 4 ], @nTotMultas, @nTotBoni, M->CND_CONTRA, M->CND_REVISA ) , CS430TotMed(5) }, STR0021, STR0022 } ) // "Seleciona Multas / Bonificacoes", "Multas"
		EndIf
		   
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Dialog.                                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
		
		EnChoice( cAlias, nReg, nOpc,,,,aCpoEnch, aPosObj[1], , , , , , , , .T.)
		
		If lFixo
			oGetDados:=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],IIF(nOpc!=3 .And. nOpc!=4,0,GD_UPDATE),,"u_CS430TudOk",,aAlter,,len(aCols),,,,oDlg,aHeader,aCols)
		Else
			oGetDados:=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],IIF(nOpc!=3 .And. nOpc!=4,0,GD_INSERT+GD_UPDATE+GD_DELETE),,"u_CS430TudOk",'+CNE_ITEM',,,,,,{ |x| CS430TotMed(5)},oDlg,aHeader,aCols)
		EndIf

		oFolder := TFolder():New(aPosObj[3,1],aPosObj[3,2],{OemToAnsi(STR0015)},,oDlg,,,,.T., .F.,aPosObj[3,4]-aPosObj[3,2],aPosObj[3,3]-aPosObj[3,1],)
		
		@ 003,003 Say OemToAnsi(STR0018) Of oFolder:aDialogs[1] PIXEL //Total da medicao
		@ 002,037 MsGet oGetTot Var M->CND_VLTOT Picture PesqPict("CND","CND_VLTOT") PIXEL When .F. Size 50,5 Of oFolder:aDialogs[1]

		@ 003,095 Say OemToAnsi(STR0019) Of oFolder:aDialogs[1] PIXEL //Valor previsto
		@ 002,129 MsGet oGetPrev Var nTotPrev Picture PesqPict("CND","CND_VLTOT") PIXEL When .F. Size 50,5 Of oFolder:aDialogs[1]
		
		@ 003,187 Say OemToAnsi(STR0013) Of oFolder:aDialogs[1] PIXEL //Total do desconto
		@ 002,231 MsGet oGetDesc Var nTotDesc Picture PesqPict("CND","CND_VLTOT") PIXEL When .F. Size 50,5 Of oFolder:aDialogs[1]
		
		If lMultaBoni
			@ 019,095 Say OemToAnsi(STR0054) Of oFolder:aDialogs[1] PIXEL //Multas 
			@ 018,129 MsGet oGetMultas Var nTotMultas Picture PesqPict("CND","CND_VLTOT") PIXEL When .F. Size 50,5 Of oFolder:aDialogs[1]
		
			@ 019,187 Say OemToAnsi(STR0055) Of oFolder:aDialogs[1] PIXEL //Bonificacoes 
			@ 018,231 MsGet oGetBoni Var nTotBoni Picture PesqPict("CND","CND_VLTOT") PIXEL When .F. Size 50,5 Of oFolder:aDialogs[1]
		EndIf 		

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valor retido da caucao                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If lCaucRet
			@ 019,003 Say OemToAnsi(STR0063) Of oFolder:aDialogs[1] PIXEL//"Ret. Caução"
			@ 018,037 MsGet oGetCauc Var nCaucVlr Picture PesqPict("CND","CND_RETCAC") PIXEL When .F. Size 50,5 Of oFolder:aDialogs[1]
		EndIf

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| If(Obrigatorio(aGets,aTela) .And. oGetDados:TudoOk() .And. u_CSVldMed(cContra,cRevisa,cPlan,cCompet,lMedeve,nTotDesc,aMultas),{nOpca:=1,oDlg:End()},nOpca:=0)},{||(nOpca:=2,oDlg:End())},,aButtons)
	EndIf
	
	If nOpca == 1
		CS430Grv(nOpc,lMedeve,cCompet,nSaveSX8,aDescs,aHeadDcs,nTotDesc,nTotPrev,aMultas)
		lRet := .T.
	Else
	   While ( GetSX8Len() > nSaveSX8 )
		   RollBackSX8()
		EndDo
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza lancamentos do PCO  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoFinLan("000355")  
	PcoFreeBlq("000355",,,,,(nOpc == 4 .And. nOpca!=1))	
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS430Desc ³ Autor ³ Marcelo Custodio      ³ Data ³20.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina de manutencao dos descontos                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS430Desc(nExp01,nExp02,aExp03,aExp04)                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³  nExp01 - Opcao Atual                                      ³±±
±±³          ³  nExp02 - Total do desconto                                ³±±
±±³          ³  lExp03 - Descontos aplicados - acols                      ³±±
±±³          ³  cExp04 - Cabecalho da getdados de desconto                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS430Desc(nOpc,nTotDesc,aDescs,aHeadDcs)
Local aNcpo   := {"CNQ_NUMMED","CNQ_CONTRA"}
Local cFilCNP := xFilial("CNP")
Local nUsado  := len(aHeadDcs)
Local nOpca   := 2
Local oGetDados
Local nx
Local nPosVl
Local cQuery
Local cCampo
Local aStrucCNQ
Local nPosTp

If len(aHeadDcs) == 0
	CS430PrcDesc(nOpc,aHeadDcs,aDescs)
EndIf

DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0061) From 165,115 TO 450,600 PIXEL//"Descontos"

@ 07,05 GROUP oGrp To __DlgHeight(oDlg)-30,__DlgWidth(oDlg)-5 Label OemToAnsi(STR0062) Of oDlg PIXEL//"Descontos Aplicados"

oGetDadDe:=MsNewGetDados():New(15,10,__DlgHeight(oDlg)-35,__DlgWidth(oDlg)-10,IIF(nOpc==2,0,GD_UPDATE+GD_INSERT+GD_DELETE),"u_CS430VldDes(oGetDadDe)",,,,,,,,,oDlg,aHeadDcs,aDescs)

DEFINE SBUTTON FROM __DlgHeight(oDlg)-25, __DlgWidth(oDlg)-60 TYPE 1 ACTION (If((CS430VldDes(oGetDadDe)),(nOpca:=1,oDlg:End()),)) ENABLE OF oDlg PIXEL
DEFINE SBUTTON FROM __DlgHeight(oDlg)-25, __DlgWidth(oDlg)-30 TYPE 2 ACTION (nOpca:=2,oDlg:End()) ENABLE OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca==1
	nUsado := len(aHeadDcs)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza descontos                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aDescs:=oGetDadDe:aCols
	nPosVl:=aScan(aHeadDcs,{|x| x[2] == "CNQ_VALOR "})
	nPosTp:=aScan(aHeadDcs,{|x| x[2] == "CNQ_TPDESC"})
	nTotDesc:=0
	nTotMedDsc:=0
	
	dbSelectArea("CNP")
	dbSetOrder(1)
	
	For nx:=1 to len(aDescs)
		If !aDescs[nx,nUsado+1]
			nTotDesc+=aDescs[nx,nPosVl]
			
			//Soma os valores apenas dos descontos que afetam o pedido
			If dbSeek(cFilCNP+aDescs[nx,nPosTp]) .And. CNP->CNP_FLGPED == "1"
				nTotMedDsc += aDescs[nx,nPosVl]
			EndIf
		EndIf
	Next
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS430PrcDesc³ Autor ³ Marcelo Custodio      ³ Data ³20.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Preenche aCols e aHeader para o controle de descontos        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS430PrcDesc(nExp1,aExp2,aExp3)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³  nExp01 - Opcao Atual                                        ³±±
±±³          ³  aExp02 - aHeader - Descontos                                ³±±
±±³          ³  aExp03 - aCols - Descontos                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS430PrcDesc(nOpc,aHeadDcs,aDescs)
Local nUsado := 0
Local aNcpo  := {"CNQ_NUMMED","CNQ_CONTRA"}
Local cQuery := ""
Local nX
Local nPosTp

aHeadDcs := {}
aDescs   := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeadDcs na primeira execucao         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("CNQ")
While !EOF() .And. (SX3->X3_ARQUIVO == "CNQ")
	If X3Uso(X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. Ascan(aNcpo,{|x| x == alltrim(SX3->X3_CAMPO)}) == 0
		nUsado++

		Aadd(aHeadDcs, { alltrim( X3Titulo() ),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_F3,;
		SX3->X3_CONTEXT } )
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo

If nOpc != 3
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega descontos na edicao                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT CNQ.R_E_C_N_O_ AS RECNO FROM "+ RetSQLName("CNQ") +" CNQ "
	cQuery += "WHERE CNQ.CNQ_FILIAL = '"+ xFilial("CNQ") +"' AND "
	cQuery += "CNQ.CNQ_NUMMED = '"+ CND->CND_NUMMED +"' AND "
	cQuery += "CNQ.D_E_L_E_T_ = '' "
	cQuery += "ORDER BY CNQ.CNQ_TPDESC"
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea( .t., "TOPCONN", TcGenQry( ,,cQuery ), "TRBCNQ", .f., .t. )
		
	While !TRBCNQ->(Eof())        
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no registro     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CNQ->(dbGoTo(TRBCNQ->RECNO))

		aAdd(aDescs,Array(nUsado+1))
		For nx:= 1 To nUsado
			cCampo := Alltrim(aHeadDcs[nx,2])
			If ( aHeadDcs[nx,10] != "V" )
				aDescs[Len(aDescs),nx] := CNQ->&(aHeadDcs[nx,2])
			Else
				aDescs[Len(aDescs),nx] := CriaVar(aHeadDcs[nx,2])
			EndIf
		Next nx
		aDescs[Len(aDescs),nUsado+1] := .F.

		TRBCNQ->(dbSkip())
	EndDo
	TRBCNQ->(dbCloseArea())
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega item vazio                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If len(aDescs) == 0	
	aAdd(aDescs,Array(nUsado+1))
	For nX := 1 To nUsado
		aDescs[1, nX] := CriaVar(aHeadDcs[nX, 2])
	Next nX
	aDescs[1,nUsado+1] := .F.
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS430Grv  ³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Grava Medicao                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS430Grv(nExp01,lExp03,cExp04,cExp04)                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³  nExp01 - Opcao Atual                                      ³±±
±±³          ³  lExp02 - Medicao Eventual                                 ³±±
±±³          ³  cExp03 - Competencia                                      ³±±
±±³          ³  cExp04 - ncSX8                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS430Grv(nOpc,lMedeve,cCompet,nSaveSX8,aDescs,aHeadDcs,nTotDesc,nTotPrev,aMultas)
Local nCntFor
Local nCntFor2
Local nX
Local nA
Local cFilCod                                                              
Local cCronog
Local nUsado
Local cQuery    := ""
Local nPosIt    := aScan(aHeader,{|x| x[2] == "CNE_ITEM  "})  
Local nLoop     := 0 
Local lMultaBoni:= !Empty( CN4->( FieldPos( "CN4_VLDALT" ) ) ) 
Local lFlgPed   := (CNR->( FieldPos("CNR_FLGPED") )) > 0

If !lAuto
	aCols := oGetDados:aCols
Endif

If ExistBlock("MD130GRV")
	ExecBlock("MD130GRV",.F.,.F.,{nOpc})
EndIf

Do Case
	Case nOpc == 3 //Inclusao
		Begin Transaction
		dbSelectArea("CND")
		cFilCod := xFilial("CND")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava cabecalho da medicao                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Reclock("CND",.T.)
		For nCntFor := 1 To FCount()
			If (FieldName(nCntFor)!="CND_FILIAL")
				If (FieldName(nCntFor)!="CND_RETCAC" )
					FieldPut(nCntFor,M->&(FieldName(nCntFor)))
				EndIf
			Else
				CND->CND_FILIAL := cFilCod
			EndIf
		Next nCntFor                
		CND->CND_VLPREV:= nTotPrev
		CND->CND_VLTOT := M->CND_VLTOT
		CND->CND_DESCME:= nTotDesc
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche o valor retido na medicao             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If CND->( FieldPos("CND_RETCAC") ) > 0
			CND->CND_RETCAC:= If(nCaucVlr!=Nil,nCaucVlr,0)
		EndIf
		MsUnlock()                           
		
		CND->(FKCommit())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa lancamento do PCO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PcoDetLan("000355","01","CNTA120")
		       
		dbSelectArea("CNE")
		nUsado := Len(aHeader)        
		cFilCod := xFilial("CNE")
		                              
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava itens da medicao                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nCntFor := 1 To Len(aCols)
			If ( !aCols[nCntFor][nUsado+1] )
				dbSelectArea("CNE")
				Reclock("CNE",.T.)
				For nCntFor2 := 1 To nUsado
					If ( aHeader[nCntFor2][10] != "V" )
						FieldPut(FieldPos(aHeader[nCntFor2][2]),aCols[nCntFor][nCntFor2])
					EndIf
				Next nCntFor2
				CNE->CNE_FILIAL := cFilCod
				CNE->CNE_NUMERO := CND->CND_NUMERO
				CNE->CNE_NUMMED := CND->CND_NUMMED
				CNE->CNE_REVISA := CND->CND_REVISA
				CNE->CNE_CONTRA := CND->CND_CONTRA
				MsUnlock()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Executa lancamento do PCO ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PcoDetLan("000355","02","CNTA120")
			EndIf
		Next

		CS430GrvDesc(aDescs,aHeadDcs,nOpc)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Efetua a gravacao das multas / bonificacoes associadas ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lMultaBoni
					 
			For nLoop := 1 to Len( aMultas ) 
			
				RecLock( "CNR", .T. )
				
				CNR->CNR_FILIAL := xFilial( "CNR" ) 
				CNR->CNR_NUMMED := CND->CND_NUMMED 
				CNR->CNR_TIPO   := aMultas[ nLoop, 1 ]
				CNR->CNR_DESCRI := aMultas[ nLoop, 2 ]   
				CNR->CNR_VALOR  := aMultas[ nLoop, 3 ] 
				CNR->CNR_MODO   := aMultas[ nLoop, 4 ] 
				If lFlgPed
					CNR->CNR_FLGPED := aMultas[ nLoop, 5 ]
				EndIf
			
				CNR->( MsUnlock() ) 		
			
			Next nLoop 		
		EndIf
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra itens gravados no banco                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
      While ( GetSX8Len() > nSaveSX8 )
		   ConfirmSX8()
		EndDo
		
		End Transaction
	Case nOpc == 4 //Alteracao
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra itens gravados no banco                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "Select CNE.CNE_ITEM,CNE.R_E_C_N_O_ as RECNO from "+ RetSQLName("CNE") +" CNE "
		cQuery += "where CNE.CNE_FILIAL = '"+ xFilial("CNE") +"' And "
		cQuery += "CNE.CNE_NUMMED = '"+ CND->CND_NUMMED +"' And "
		cQuery += "CNE.D_E_L_E_T_ = ''"
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea( .t., "TOPCONN", TcGenQry( ,,cQuery ), "TRBCNE", .f., .t. )
		
		cFilCod := xFilial("CND")
		dbSelectArea("CND")
		dbSetorder(4)
		dbSeek(cFilCod+CND->CND_NUMMED)
		
		Begin Transaction                 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Altera cabecalho                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Reclock("CND",.F.)
		For nCntFor := 1 To FCount()
			If (FieldName(nCntFor)!="CND_FILIAL")
				If (FieldName(nCntFor)!="CND_RETCAC" )
					FieldPut(nCntFor,M->&(FieldName(nCntFor)))
				EndIf
			Else
				CND->CND_FILIAL := cFilCod
			EndIf
		Next nCntFor                
		CND->CND_VLPREV:= nTotPrev
		CND->CND_VLTOT := M->CND_VLTOT
		CND->CND_DESCME:= nTotDesc
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche o valor retido na medicao             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If CND->( FieldPos("CND_RETCAC") ) > 0
			CND->CND_RETCAC:= If(nCaucVlr!=Nil,nCaucVlr,0)
		EndIf
		MsUnlock()                           

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa lancamento do PCO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PcoDetLan("000355","01","CNTA120")
		       
		dbSelectArea("CNE")
		nUsado := Len(aHeader)        
		cFilCod := xFilial("CNE")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Altera itens                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		While !TRBCNE->(Eof())
			dbSelectArea("CNE")
			CNE->( dbGoTo(TRBCNE->RECNO) )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclui lancamento do PCO  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PcoDetLan("000355","02","CNTA120",.T.)
			
			RecLock("CNE",.F.)
			dbDelete()
			MsUnlock()
			
			TRBCNE->(dbSkip())
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava itens da medicao                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nCntFor := 1 To Len(aCols)
			If ( !aCols[nCntFor][nUsado+1] )
				dbSelectArea("CNE")
				Reclock("CNE",.T.)
				For nCntFor2 := 1 To nUsado
					If ( aHeader[nCntFor2][10] != "V" )
						FieldPut(FieldPos(aHeader[nCntFor2][2]),aCols[nCntFor][nCntFor2])
					EndIf
				Next nCntFor2
				CNE->CNE_FILIAL := cFilCod
				CNE->CNE_NUMERO := CND->CND_NUMERO
				CNE->CNE_NUMMED := CND->CND_NUMMED
				CNE->CNE_REVISA := CND->CND_REVISA
				CNE->CNE_CONTRA := CND->CND_CONTRA
				MsUnlock()
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Executa lancamento do PCO ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PcoDetLan("000355","02","CNTA120")
			EndIf
		Next
		
		CS430GrvDesc(aDescs,aHeadDcs,nOpc)
		
		If lMultaBoni
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Filtra multas / bonificacoes                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			cAliasCNR := GetNextAlias()  
			
			cQuery := "SELECT CNR.R_E_C_N_O_ RECNO FROM "+ RetSQLName("CNR") +" CNR "
			cQuery += "WHERE CNR.CNR_FILIAL = '"+ xFilial("CNR") +"' AND "
			cQuery += "CNR.CNR_NUMMED = '"+ CND->CND_NUMMED +"' AND "
			cQuery += "CNR.D_E_L_E_T_ = ''"
			
			cQuery := ChangeQuery(cQuery)
			
			dbUseArea( .t., "TOPCONN", TcGenQry( ,,cQuery ), cAliasCNR, .f., .t. )
						
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclui multas / bonificacoes                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	
			While !( cAliasCNR )->(Eof())
				CNR->( dbGoto( ( cAliasCNR )->RECNO ) )
				RecLock("CNR", .F.)
				CNR->( dbDelete() )
				CNR->( MsUnlock() )
				( cAliasCNR )->(dbSkip())
			EndDo         
			
			CNR->( FKCommit() ) 
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Efetua a gravacao das multas / bonificacoes associadas ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			 
			For nLoop := 1 to Len( aMultas ) 
			
				RecLock( "CNR", .T. )
				
				CNR->CNR_FILIAL := xFilial( "CNR" ) 
				CNR->CNR_NUMMED := CND->CND_NUMMED 
				CNR->CNR_TIPO   := aMultas[ nLoop, 1 ]
				CNR->CNR_DESCRI := aMultas[ nLoop, 2 ]   
				CNR->CNR_VALOR  := aMultas[ nLoop, 3 ] 
				CNR->CNR_MODO   := aMultas[ nLoop, 4 ] 
				If lFlgPed
					CNR->CNR_FLGPED := aMultas[ nLoop, 5 ]
				EndIf
			
				CNR->( MsUnlock() ) 		
			
			Next nLoop 		
			
		EndIf 	
			
		End Transaction
		
		TRBCNE->(dbCloseArea())//Fecha arquivo de trabalho
		
	Case nOpc == 5 //Exclusao
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra itens gravados no banco                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "Select CNE.CNE_ITEM,CNE.R_E_C_N_O_ as RECNO from "+ RetSQLName("CNE") +" CNE "
		cQuery += "where CNE.CNE_FILIAL = '"+ xFilial("CNE") +"' And "
		cQuery += "CNE.CNE_NUMMED = '"+ CND->CND_NUMMED +"' And "
		cQuery += "CNE.D_E_L_E_T_ = ''"
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea( .t., "TOPCONN", TcGenQry( ,,cQuery ), "TRBCNE", .f., .t. )
                              
		dbSelectArea("CNQ")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra descontos                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "Select CNQ.R_E_C_N_O_ as RECNO from "+ RetSQLName("CNQ") +" CNQ "
		cQuery += "where CNQ.CNQ_FILIAL = '"+ xFilial("CNQ") +"' And "
		cQuery += "CNQ.CNQ_NUMMED = '"+ CND->CND_NUMMED +"' And "
		cQuery += "CNQ.D_E_L_E_T_ = ''"
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea( .t., "TOPCONN", TcGenQry( ,,cQuery ), "TRBCNQ", .f., .t. )
					
		Begin Transaction                 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui descontos                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		dbSelectArea("CNQ")
		While !TRBCNQ->(Eof())
			dbGoto(TRBCNQ->RECNO)
			RecLock("CNQ", .F.)
			dbDelete()
			MsUnlock()
			TRBCNQ->(dbSkip())
		EndDo
      
		If lMultaBoni

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Filtra multas / bonificacoes                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			cAliasCNR := GetNextAlias()  
			
			cQuery := "SELECT CNR.R_E_C_N_O_ RECNO FROM "+ RetSQLName("CNR") +" CNR "
			cQuery += "WHERE CNR.CNR_FILIAL = '"+ xFilial("CNR") +"' AND "
			cQuery += "CNR.CNR_NUMMED = '"+ CND->CND_NUMMED +"' AND "
			cQuery += "CNR.D_E_L_E_T_ = ''"
			
			cQuery := ChangeQuery(cQuery)
			
			dbUseArea( .t., "TOPCONN", TcGenQry( ,,cQuery ), cAliasCNR, .f., .t. )
						
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclui multas / bonificacoes                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	
			While !( cAliasCNR )->(Eof())
				CNR->( dbGoto( ( cAliasCNR )->RECNO ) )
				RecLock("CNR", .F.)
				CNR->( dbDelete() )
				CNR->( MsUnlock() )
				( cAliasCNR )->(dbSkip())
			EndDo         
			
			CNR->( FkCommit() ) 
			
		EndIf 	
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui itens                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		dbSelectArea("CNE")
		While !TRBCNE->(Eof())
			dbGoto(TRBCNE->RECNO)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Executa lancamento do PCO ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PcoDetLan("000355","02","CNTA120",.T.)

			RecLock("CNE", .F.)
			dbDelete()
			MsUnlock()
			
			TRBCNE->(dbSkip())
		EndDo
      
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa lancamento do PCO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PcoDetLan("000355","01","CNTA120",.T.)   
		
		RecLock("CND", .F.)
		dbDelete()
		MsUnLock()
	
		End Transaction

		//Finaliza arquivos de trabalho		
		TRBCNE->(dbCloseArea())
		TRBCNQ->(dbCloseArea())
End Case

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS430TotMed³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Atualiza total da medicao                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS430TotMed(nExp01)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Informa campo atual do usuario 1 - quantidade      ³±±
±±³          ³                                         2 - percentual      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS430TotMed(nField)
Local nPosVu:= aScan(aHeader,{|x| x[2] == "CNE_VLUNIT"})
Local nPosDc:= aScan(aHeader,{|x| x[2] == "CNE_PDESC "})
Local nPosQt:= aScan(aHeader,{|x| x[2] == "CNE_QUANT "})
Local nPosQl:= aScan(aHeader,{|x| x[2] == "CNE_QTDSOL"})
Local nx    := 0
Local ny    := If(lAuto,n,oGetDados:nAt)

If !lAuto
	aCols := oGetDados:aCols
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Soma valor alterado          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
M->CND_VLTOT := 0

For nX:=1 to len(aCols)
	If !aCols[nx,len(aHeader)+1]
		If nx==ny
			Do Case
				Case nField == 1//Campo quantidade
					M->CND_VLTOT+=M->CNE_QUANT*(aCols[nx,nPosVu]-((aCols[nx,nPosVu]*aCols[nx,nPosDc])/100))
				Case nField == 2//Campo percentual
					M->CND_VLTOT+=((M->CNE_PERC*aCols[nx,nPosQl])/100)*(aCols[nx,nPosVu]-((aCols[nx,nPosVu]*aCols[nx,nPosDc])/100))	
				Case nField == 3//Campo vlunit
					M->CND_VLTOT+=aCols[nx,nPosQt]*(M->CNE_VLUNIT-((M->CNE_VLUNIT*aCols[nx,nPosDc])/100))
				Case nField == 4//Desconto
					M->CND_VLTOT+=aCols[nx,nPosQt]*(aCols[nx,nPosVu]-((aCols[nx,nPosVu]*M->CNE_PDESC)/100))
				Case nField == 5//Excluido
					M->CND_VLTOT+=aCols[nx,nPosQt]*(aCols[nx,nPosVu]-((aCols[nx,nPosVu]*aCols[nx,nPosDc])/100))
			End Case
		Else
			M->CND_VLTOT+=aCols[nx,nPosQt]*(aCols[nx,nPosVu]-((aCols[nx,nPosVu]*aCols[nx,nPosDc])/100))
		EndIf
	EndIf
Next

If nCaucVlr != Nil
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza valor da caucao     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nCaucVlr:=(((M->CND_VLTOT-nTotMedDsc-nTotMedMlt+nTotMedBnf)*nCaucRet)/100)
	If !lAuto
		oGetCauc:Refresh()
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Altera componente visual     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lAuto
	oGetTot:Refresh()
EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS430TudOk³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida Getdados                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS430TudOk()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CS430TudOk()
Local nX
Local lRet    := .T.                                                
Local uRet    := NIL
Local nPosQt  := aScan(aHeader,{|x| x[2] == "CNE_QUANT "})
Local nPosIt  := aScan(aHeader,{|x| x[2] == "CNE_ITEM  "})
Local nPosProd:= aScan(aHeader,{|x| x[2] == "CNE_PRODUT"})
Local lZerad  := (M->CND_ZERO == "1")
Local lVldPrd := ( GetNewPar("MV_CNVLAMR","N") == "S" )
Local cFilSA5 := xFilial("SA5")
Local cFilSB1 := xFilial("SB1")
Local cFilSAD := xFilial("SAD")

If !lAuto
	aCols := oGetDados:aCols
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida itens de acordo com a opcao zerada da medicao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := 1 to len(aCols)
	If (lZerad .And. aCols[nX][nPosQt]>0)
		Aviso("CNTA130",STR0010+aCols[nX][nPosIt],{"OK"})//"Quantidade inválida no item "
		lRet := .F.
		Exit
	EndIf

	If lRet .And. lVldPrd
		dbSelectArea("SA5")
		dbSetOrder(1)
		dbGoTop()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida amarração Fornecedor X Produto ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
		lProdFr := dbSeek(cFilSA5+M->CND_FORNEC+M->CND_LJFORN+aCols[nX][nPosProd])
		If !lProdFr
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(cFilSB1+aCols[nX][nPosProd])
				dbSelectArea("SAD")                            	
				dbSetOrder(1)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Valida amarração Fornecedor X Grupo de Produto ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lProdFr := dbSeek(cFilSAD+M->CND_FORNEC+M->CND_LJFORN+SB1->B1_GRUPO)
			EndIf
		EndIf
		
		If !lProdFr
			Aviso(STR0044,STR0074+AllTrim(aCols[nX][nPosIt])+STR0075,{ "OK" },2)//"O produto informado no item "###" não está amarrado ao fornecedor informado. Verifique a amarração produto X fornecedor."
			lRet := .F.
			Exit
		EndIf
	EndIf
	
	If lRet
		n := nX
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valida lancamento do PCO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If !(lRet := PcoVldLan('000355','02','CNTA120',/*lUsaLote*/,/*lDeleta*/, .F./*lVldLinGrade*/))
			Exit
		EndIf
	EndIf
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida lancamento do PCO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	lRet := PcoVldLan('000355','01','CNTA120',/*lUsaLote*/,/*lDeleta*/, .F./*lVldLinGrade*/)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa ponto de entrada para validacao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. ExistBlock("CS430TOK")
	uRet := ExecBlock("CS430TOK",.F.,.F.)
	
	If valtype(uRet) == "L"
		lRet := uRet
	EndIf
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CSVldMed   ³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Manutencao de Medicoes                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CSVldMed(cExp01,cExp02,cExp03,lExp04,nExp05)                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Codigo do Contrato                                 ³±±
±±³          ³ cExp02 - Codigo da Revisao                                  ³±±
±±³          ³ cExp03 - Competencia                                        ³±±
±±³          ³ lExp04 - Medicao Eventual                                   ³±±
±±³          ³ nExp05 - Valor total de desconto                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CSVldMed(cContra,cRevisa,cPlan,cCompet,lMedeve,nTotDesc,aMultas)
Local nTotMultas := 0 
Local lRet       := .T.
Local lZerMed    := (M->CND_ZERO == "1")//Medicao Zerada
Local nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Obtem o valor de multa das medicoes           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTotMultas := 0
AEval( aMultas, { |x| nTotMultas += ( x[3] * If( x[1] == "1", 1, -1 ) ) } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida total do desconto                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If M->CND_VLTOT < ( nTotDesc + nTotMultas )
	lRet := .F.
	
	Aviso( STR0051, STR0052, { STR0053 }, 2 ) // "Atencao","O valor resultante de descontos nao pode ultrapassar o total de medicoes !","Ok" 
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida se a medicao possui itens preenchidos    ³
//³ quando for zerada                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lZerMed .And. M->CND_VLTOT > 0
	lRet := .F.
	MsgAlert(STR0008)//"Medição zerada!"
EndIf

Return lRet
        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CSVldQtd   ³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida quantidade informada na medicao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CSVldQtd()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jose Carlos |27/06/08³      ³Mudanca no nome da funcao (CN130VLDQTD())  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CSVldQtd()
Local nPosQSol := aScan(aHeader,{|x| x[2] == "CNE_QTDSOL"})
Local nPosQMed := aScan(aHeader,{|x| x[2] == "CNE_QTAMED"})
Local lRet := .T.
Local nx   := If(lAuto,n,oGetDados:nAt)

if M->CND_ZERO == "1"         
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a quantidade e igual a zero quando a³
	//³ medicao for zerada                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet := (M->CNE_QUANT == 0)
else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a quantidade e menor que o saldo    ³
	//³ disponivel                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If nPosQMed > 0
		lRet := (M->CNE_QUANT <= aCols[nx,nPosQMed])
	EndIf
EndIf

If lRet
	CS430TotMed(1)
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CSVlPerc    ³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida percentual informado nas medicoes                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CSVlPerc()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jose Carlos |27/06/08³      ³Mudanca no nome da funcao (CN130VLDPERC())  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CSVlPerc()
Local lRet := .T.
Local nPosQSol := aScan(aHeader,{|x| x[2] == "CNE_QTDSOL"})
Local nPosQMed := aScan(aHeader,{|x| x[2] == "CNE_QTAMED"})
Local nx := If(lAuto,n,oGetDados:nAt)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula percentual disponivel                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nPercMed := (aCols[nx,nPosQSol]-aCols[nx,nPosQMed])*100/aCols[nx,nPosQSol]
	
if M->CND_ZERO == "1" 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quando a medicao for zerada o percentual deve   ³
	//³ ser igual a zero                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet := (M->CNE_PERC == 0)
else
	lRet := (M->CNE_PERC <= (100-nPercMed))
EndIf

If lRet
	CS430TotMed(2)
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CSVldtEnt    ³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida data de entrada informada nas medicoes                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CSVldtEnt()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jose Carlos |27/06/08³      ³Mudanca no nome da funcao (CN130VLDDTENT())  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CSVldtEnt()
Local lRet := .T.

lRet := (M->CNE_DTENT >= dDataBase)

Return lRet        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CS430Track³ Autor ³ Sergio Silveira       ³ Data ³22/03/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faz o tratamento da chamada do System Tracker              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                  

Static Function CS430Track(aHeader,aCols)
Local aEnt     := {}
Local cKey     := M->CND_NUMMED 
Local nPosItem := GDFieldPos( "CNE_ITEM", aHeader )
Local nLoop    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Percorre o acols                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 To Len( aCols )
	AAdd( aEnt, { "CNE", cKey + aCols[ nLoop, nPosItem ] } )
Next nLoop

MaTrkShow( aEnt )

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CS430GrvDesc³ Autor ³ Marcelo Custodio      ³ Data ³06/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa a gravacao dos descontos informados na revisao       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
Static Function CS430GrvDesc(aDescs,aHeadDcs,nOpc)
Local nx
Local ny
Local cFilCod:=xFilial("CNQ")
Local nPosTpD:=aScan(aHeadDcs,{|x| x[2]=="CNQ_TPDESC"})
Local nUsado := len(aHeadDcs)

dbSelectArea("CNQ")
dbSetOrder(1)

For nx:=1 to len(aDescs)
	If !aDescs[nx,nUsado+1]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe desconto                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOpc!=3 .And. dbSeek(cFilCod+M->CND_NUMMED+aDescs[nx,nPosTpD])
			RecLock("CNQ",.F.)
		Else
			RecLock("CNQ",.T.)
		EndIf
		
		For ny:=1 to nUsado
			If ( aHeadDcs[ny][10] != "V" )
				FieldPut(FieldPos(aHeadDcs[ny,2]),aDescs[nx,ny])
			EndIf
		Next
		CNQ->CNQ_CONTRA := M->CND_CONTRA
		CNQ->CNQ_NUMMED := M->CND_NUMMED
		CNQ->CNQ_FILIAL := cFilCod
		msUnlock()
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Apaga desconto                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOpc!=3 .And. dbSeek(cFilCod+M->CND_NUMMED+aDescs[nx,nPosTpD])
			RecLock("CNQ",.F.)
			dbDelete()
			MsUnlock()
		EndIf
	EndIf
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CS430VldDes ³ Autor ³ Marcelo Custodio      ³ Data ³06/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de validacao dos descontos                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
Static Function CS430VldDes(oGetDadDe)
Local lRet   :=.T.
Local aColDE :=oGetDadDe:aCols
Local aHeaDE :=oGetDadDe:aHeader
Local nPosDc :=aScan(aHeaDE,{|x| x[2]=="CNQ_TPDESC"})
Local nPosVl :=aScan(aHeaDE,{|x| x[2]=="CNQ_VALOR "})
Local nPos   :=oGetDadDe:nAt
Local lEmpty
Local nI
Local lRepetido                        

if !Empty(aColDE[nPos,nPosDc])
	If !aColDE[nPos][len(aHeaDE) + 1]
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Varre descontos                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		For nI:= 1 To Len( aColDE )
			If ( nI != nPos ) .and. !aColDE[nI][len(aHeaDE) + 1]
				If aColDE[nI,nPosDc] == aColDE[nPos,nPosDc]
					lRepetido := .T.
					Exit
				Endif
			Endif
			If Empty(aColDE[nI,nPosVl])
				lEmpty:=.T.
				Exit
			EndIf
		Next nI
		
		If lRepetido
			lRet:=.F.
			Help(" ",1,"JAGRAVADO")
		End
		If lEmpty
			lRet:=.F.
			Aviso("CNTA130",STR0016,{"OK"})
		EndIf
	Endif
EndIf

Return lRet    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³CS430AjSXB  ³ Autor ³ Marcelo Custodio      ³ Data ³21/07/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida registros do SXB duplicados em refente a tabela CNP   ³±±
±±³          ³ Os itens são duplicados quando o compatibilizador GCTUPD02   ³±±
±±³          ³ era executado mais de uma vez - BOPS 103680                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   
Static Function CS430AjSXB()
Local cReg:=""

dbSelectArea("SXB")
dbSetOrder(1)
dbSeek("CNP")
        
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Varre consulta padrao CNP                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !SXB->(Eof()) .And. SXB->XB_ALIAS == "CNP   "
	If cReg==(SXB->XB_ALIAS+SXB->XB_TIPO+SXB->XB_SEQ+SXB->XB_COLUNA)
		RecLock("SXB",.F.)
		dbDelete()
		MsUnlock()
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Armazena item para validacao                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cReg:=(SXB->XB_ALIAS+SXB->XB_TIPO+SXB->XB_SEQ+SXB->XB_COLUNA)
	EndIf
	SXB->(dbSkip())
EndDo

Return NIL                                      

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CS430Multas³ Autor ³ Sergio Silveira      ³ Data ³11/04/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Selecao e aplicacao de multas do modulo SIGAGCT              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³A103Multas( ExpD1, ExpC2, ExpC3, ExpA4 )                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpD1 -> Data de emissao                                    ³±±
±±³          ³ ExpC2 -> Codigo do fornecedor                               ³±±
±±³          ³ ExpC3 -> Loja do fornecedor                                 ³±±
±±³          ³ ExpA4 -> Array de multas do documento de entrada            ³±±
±±³          ³ ExpN5 -> Total de multas                                    ³±±
±±³          ³ ExpN6 -> Total de bonificacoes                              ³±±
±±³          ³ ExpC7 -> Numero do contrato                                 ³±±
±±³          ³ ExpC8 -> Revisao do contrato                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CS430Multas( aMultas, aCols, aHeader, nOpc, nTotMultas, nTotBoni, cContrato, cRevisao )
Local aArea      := GetArea()                                   
Local aListBox   := {}
Local aMedicoes  := {}
Local cQuery     := ""
Local cAliasQry  := "" 
Local cMulManual := "" 
Local nOpca      := 0 
Local nLoop      := 0 
Local lProcessa  := .F.
Local lAltera    := ( nOpc == 3 .or. nOpc == 4 )
Local lMultaBoni := .F.  
Local lPermMulta := .F.
Local lFlgPed    := CNR->( FieldPos("CNR_FLGPED") ) > 0
Local lCS430Vld  := 	ExistBlock("CS430VLDMT")
Local lRet
Local oOk        := LoadBitmap( GetResources(), "LBOK" )
Local oNOk       := LoadBitmap( GetResources(), "LBNO" )
Local oDlgMult  
Local oList           
Local oBold 
Local oBmp        
Local oBut1
Local oBut2   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o tipo de contrato permite multas ou bonificacoes na medicao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CN9->( dbSetOrder( 1 ) ) 
If CN9->( MsSeek( xFilial( "CN9" ) + cContrato + cRevisao ) ) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o tipo do contrato                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CN1->( dbSetOrder( 1 ) ) 
	If CN1->( MsSeek( xFilial( "CN1" ) + CN9->CN9_TPCTO ) ) 
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se permite durante a medicao                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 	
		lMultaBoni := ( CN1->CN1_TPMULT == "2" )
		cMulManual := ( CN1->CN1_MULMAN )
		
	EndIf 

EndIf 

If lMultaBoni 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o array de medicoes. Retira a ultima coluna do acols             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nLoop := 1 to Len( aCols ) 
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a linha esta excluida                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !ATail( aCols[ nLoop ] ) 	
		
			aLinhaACols := AClone( aCols[ nLoop ] )
			ASize( aLinhaACols, Len( aLinhaACols ) - 1 ) 		
			AAdd( aMedicoes, aLinhaACols ) 
			
		EndIf 	
		
	Next nLoop
	
	If Empty( aMultas ) .And. lAltera 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processa as multas                                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CS430ProcMul( aMedicoes, @aListBox, aHeader )
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega as multas do array                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lFlgPed
			AEval( aMultas, { |x| AAdd( aListBox,  { .T., x[1], x[2], x[3], x[4], x[5]  } ) } )   
		Else
			AEval( aMultas, { |x| AAdd( aListBox,  { .T., x[1], x[2], x[3], x[4]  } ) } )   
		EndIf
	EndIf 	
		
	If Empty( aListBox ) 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se estiver vazio, preenche uma linha em branco                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lFlgPed
			AAdd( aListBox, { .F., "", "", 0, "", "" } )
		Else
			AAdd( aListBox, { .F., "", "", 0, "" } )
		EndIf
	EndIf 	
	
	DEFINE MSDIALOG oDlgMult TITLE STR0050 FROM 0,0 TO 400, 700 OF oMainWnd PIXEL // "Selecao de multas / bonificacoes"
	
	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	
	@  0, -25 BITMAP oBmp RESNAME "PROJETOAP" oF oDlgMult SIZE 55, 1000 NOBORDER WHEN .F. PIXEL
	
	@ 03, 40 SAY STR0050 FONT oBold PIXEL // "Selecao de multas / bonificacoes" 
	
	@ 14, 30 TO 16 ,400 LABEL '' OF oDlgMult PIXEL                                                              
	
	If lAltera 
	
		@ 24, 223 BUTTON STR0023 SIZE 35,11 ACTION CS430RepMult( oList, @aListBox, aMedicoes , aHeader ) OF oDlgMult PIXEL // "Reprocessar"
		@ 24, 265 BUTTON STR0024 SIZE 35,11 ACTION CS430AltMul(  oList, @aListBox, cMulManual ) OF oDlgMult PIXEL // "Alterar"    
		@ 24, 307 BUTTON STR0025 SIZE 35,11 ACTION CS430AdMult(  oList, @aListBox, cMulManual ) OF oDlgMult PIXEL // "Adicionar"  
		
	EndIf 	
	
	If lFlgPed	
		oList := TWBrowse():New( If( lAltera, 43, 30 ), 40, 303, If( lAltera, 125, 138 ),,{ "", STR0026, STR0027, STR0028, STR0029, STR0073 },,oDlgMult,,,,,,,,,,,,.F.,,.T.,,.F.,,,) // "Tipo", "Descricao", "Valor", "Insercao", "Interf. Ped."
	Else
		oList := TWBrowse():New( If( lAltera, 43, 30 ), 40, 303, If( lAltera, 125, 138 ),,{ "", STR0026, STR0027, STR0028, STR0029, STR0073 },,oDlgMult,,,,,,,,,,,,.F.,,.T.,,.F.,,,) // "Tipo", "Descricao", "Valor", "Insercao"
	EndIf
	
	oList:SetArray(aListBox)
	If	lFlgPed
		oList:bLine := { || { If( aListBox[oList:nAT,1], oOk, oNOK ), If( aListBox[oList:nAt,2] == "1", STR0030, STR0031 ), aListBox[oList:nAT,3], Transform( aListBox[oList:nAT,4],"@E 999,999,999.99" ), If( aListBox[oList:nAT,5] == "1",STR0032,If( aListBox[oList:nAT,5] == "2", STR0033 ,"" ) ),If( aListBox[oList:nAT,6] == "1", OemToAnsi(STR0048) , OemToAnsi(STR0049) ) } } // "Multa","Bonificacao","Automatica","Manual"
	Else
		oList:bLine := { || { If( aListBox[oList:nAT,1], oOk, oNOK ), If( aListBox[oList:nAt,2] == "1", STR0030, STR0031 ), aListBox[oList:nAT,3], Transform( aListBox[oList:nAT,4],"@E 999,999,999.99" ), If( aListBox[oList:nAT,5] == "1",STR0032,If( aListBox[oList:nAT,5] == "2", STR0033 ,"" ) ) } } // "Multa","Bonificacao","Automatica","Manual"
	EndIf
	
	If lAltera 
		oList:bLDblClick := { || aListBox[oList:nAt,1] := If( Empty( aListBox[ oList:nAt,3 ]), aListBox[oList:nAt,1],!aListBox[oList:nAt,1] ) } 
	EndIf 	
	                                                                                        
	DEFINE SBUTTON oBut2 FROM 178, If( lAltera, 280, 312 ) TYPE 1 ACTION ( nOpca := 1, If(!lCS430Vld,oDlgMult:End(),(lRet:=ExecBlock("CS430VLDMT",.F.,.F.),If((valtype(lRet)=="L" .And. lRet),oDlgMult:End(),nOpca := 0))) )  ENABLE of oDlgMult		 
	
	If lAltera 
		DEFINE SBUTTON oBut3 FROM 178, 312 TYPE 2 ACTION ( nOpca := 0, oDlgMult:End() )  ENABLE of oDlgMult
	EndIf 	
	
	ACTIVATE MSDIALOG oDlgMult CENTERED  
		
	
	If nOpca == 1 
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega as multas no array aMultas                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		aMultas    := {} 
		
		nTotMultas := 0 
		nTotBoni   := 0
		nTotMedMlt := 0
		nTotMedBnf := 0
	 	
		For nLoop := 1 to Len( aListBox ) 
		
			If aListBox[ nLoop, 1 ] 
				If lFlgPed
					AAdd( aMultas, { aListBox[nLoop,2],aListBox[nLoop,3], aListBox[nLoop,4], aListBox[nLoop,5], aListBox[nLoop,6] } )
				Else
					AAdd( aMultas, { aListBox[nLoop,2],aListBox[nLoop,3], aListBox[nLoop,4], aListBox[nLoop,5] } )
				EndIf
				
				If aListBox[ nLoop, 2 ] == "1" 
					nTotMultas += aListBox[ nLoop, 4 ]
               //Soma as multas que interferem pedido
					If  aListBox[ nLoop, 6 ] == "1"
						nTotMedMlt += aListBox[ nLoop, 4 ]
					EndIf
				ElseIf aListBox[ nLoop, 2 ] == "2" 			
					nTotBoni   += aListBox[ nLoop, 4 ] 					
					//Soma as bonificacoes que interferem pedido
					If  aListBox[ nLoop, 6 ] == "1" 
						nTotMedBnf += aListBox[ nLoop, 4 ]
					EndIf
				EndIf 	
				
			EndIf 
	
		Next nLoop      
	
	EndIf 
	
Else 
                                  
	If !lMultaBoni
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Restaura a integridade dos dados de entrada                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aviso( STR0056, STR0060, { STR0058 }, 2 ) // "Atencao!", "O tipo de contrato desta medicao nao permite o apontamento de multas ou bonificacoes neste momento !", { "Ok" }
	EndIf 		
		
EndIf 	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade dos dados de entrada                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RestArea( aArea ) 
		
Return( .T. ) 


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CS430AdMult³ Autor ³ Sergio Silveira      ³ Data ³11/04/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Inclusao de multa avulsa - SIGAGCT                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 -> Objeto listbox                                     ³±±
±±³          ³ ExpA2 -> Array da listbox ( alimentado por referencia )     ³±±
±±³          ³ ExpC3 -> Configuracao de acesso para multas manuais         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CS430AdMult( oList, aListBox, cMulManual )
Local cDescri   := Space( 50 ) 
Local cContrato := "" 
Local cTipo     := ""
Local lFlgPed  := (CNR->( FieldPos("CNR_FLGPED") ) > 0)
Local cPedFlag  := "1"
Local aPedFlag  := {OemToAnsi(STR0048),OemToAnsi(STR0049)}//"Sim"##"Não"
Local nValor    := 0   
Local nOpca     := 0 
Local oBut1 
Local oBut2 
Local oBmp
Local oBold 
Local oDlgMult 
Local oTipo 
Local oPedFlag
Local oContrato      

If cMulManual <> "1" 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a permissao de acesso para manipulacao manual                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case 
	Case cMulManual == "2" 
		aTipos := { STR0034 } // "Multa"
	Case cMulManual == "3" 
		aTipos := { STR0035 } // "Bonificacao"	
	Case cMulManual == "4" 
		aTipos := { STR0034, STR0035 } // "Multa", "Bonificacao"
	EndCase 	
	
	DEFINE MSDIALOG oDlgMult TITLE STR0036 FROM 0,0 TO 280, 550 OF oMainWnd PIXEL // "Inclusao de multas / bonificacoes"

	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	
	@  0, -25 BITMAP oBmp RESNAME "PROJETOAP" oF oDlgMult SIZE 55, 1000 NOBORDER WHEN .F. PIXEL
	
	@ 03, 40 SAY STR0037 FONT oBold PIXEL // "Inclusao de multas / bonificacoes avulsas"
	
	@ 14, 30 TO 16 ,400 LABEL '' OF oDlgMult   PIXEL
	
	@  30, 40 SAY STR0038 OF oDlgMult PIXEL // "Descricao"
	@  40, 40 GET cDescri SIZE 200, 11 VALID NaoVazio( cDescri ) PICTURE "@!" OF oDlgMult PIXEL 
	
	@  60, 40 SAY STR0039 OF oDlgMult PIXEL // "Valor"
	@  70, 40 GET nValor SIZE 70, 11   VALID NaoVazio( nValor ) .And. Positivo( nValor ) PICTURE "@E 999,999,999.99" OF oDlgMult PIXEL
	
	@  90, 40 SAY STR0040 OF oDlgMult PIXEL // "Tipo"
	@ 100, 40 MSCOMBOBOX oTipo VAR cTipo ITEMS aTipos SIZE 100, 36 OF oDlgMult PIXEL 

	If lFlgPed
		@  90,145 SAY OemToAnsi(STR0073) OF oDlgMult PIXEL // "Afeta Pedido"
		@ 100,145 MSCOMBOBOX oPedFlag VAR cPedFlag ITEMS aPedFlag SIZE 50, 36 OF oDlgMult PIXEL 
	EndIf
	                                                                                        
	DEFINE SBUTTON oBut1 FROM 120, 207 TYPE 1 ACTION ( If( u_CSVldMult( cDescri,nValor ),( nOpca := 1, cTipo := Str(oTipo:nAt,1), If(lFlgPed,cPedFlag := Str(oPedFlag:nAt,1),) , oDlgMult:End()), ) )  ENABLE of oDlgMult
	DEFINE SBUTTON oBut2 FROM 120, 239 TYPE 2 ACTION ( nOpca := 0, oDlgMult:End() )  ENABLE of oDlgMult
	
	ACTIVATE MSDIALOG oDlgMult CENTERED  
	
	If nOpca == 1    
	
		Do Case 
		Case cMulManual == "2" 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ So permite multa                                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cTipo := "1" 	
		Case cMulManual == "3" 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ So permite bonificacao                                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cTipo := "2" 	
		EndCase 	
	
		If Len( aListBox ) == 1 .And. Empty( aListBox[ 1, 2 ] )    
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se tiver uma linha em branco, apaga                                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aListBox := {} 
		EndIf
		
		If lFlgPed
			AAdd( aListBox, { .T., cTipo, cDescri, nValor, "2", cPedFlag } ) 
		Else
			AAdd( aListBox, { .T., cTipo, cDescri, nValor, "2" } ) 
		EndIf
		
		bLine := oList:bLine
		oList:SetArray(aListBox)
		oList:bLine := bLine 
		
	EndIf 
	
Else 
	Aviso( STR0056, STR0059, { STR0058 }, 2 ) // "Atencao!", "A configuracao deste contrato nao permite a manipulacao manual de multas !", { "Ok" 
EndIf 	
	
Return( .T. )          

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CS430AltMul³ Autor ³ Sergio Silveira      ³ Data ³05/05/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Alterecao de multa - SIGAGCT                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 -> Objeto listbox                                     ³±±
±±³          ³ ExpA2 -> Array da listbox ( alimentado por referencia )     ³±±
±±³          ³ ExpC3 -> Configuracao de acesso para multas manuais         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CS430AltMul( oList, aListBox, cMulManual )
Local cDescri   := Space( 50 ) 
Local cContrato := ""
Local cTipo     := aListBox[ oList:nAt, 2 ]  
Local lFlgPed   := CNR->( FieldPos("CNR_FLGPED") ) > 0
Local aPedFlag  := {OemToAnsi(STR0048),OemToAnsi(STR0049)}//"Sim"##"Não"
Local cPedFlag  := ""
Local oPedFlag
Local nValor    := 0   
Local nOpca     := 0 
Local oBut1 
Local oBut2 
Local oBmp
Local oBold 
Local oDlgMult
Local oContrato 

If ( cMulManual == "4" ) .Or. ( cMulManual == "2" .And. cTipo == "1" ) .Or. ( cMulManual == "3" .And. cTipo == "2" ) 
   
	If !( Len( aListBox ) == 1 .And. Empty( aListBox[ 1, 2 ] ) )    
	   
		cDescri   := aListBox[ oList:nAt, 3 ]    
		nValor    := aListBox[ oList:nAt, 4 ]
	
		DEFINE MSDIALOG oDlgMult TITLE STR0041 FROM 0,0 TO 240, 550 OF oMainWnd PIXEL // "Alteracao de multas / bonificacoes"
		
		DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
		
		@  0, -25 BITMAP oBmp RESNAME "PROJETOAP" oF oDlgMult SIZE 55, 1000 NOBORDER WHEN .F. PIXEL
		
		@ 03, 40 SAY STR0041 FONT oBold PIXEL // "Alteracao de multas / bonificacoes"
		
		@ 14, 30 TO 16 ,400 LABEL '' OF oDlgMult   PIXEL
	
		@  30, 40 SAY STR0042 OF oDlgMult PIXEL // "Descricao"  
		@  40, 40 GET cDescri SIZE 200, 11 VALID NaoVazio( cDescri ) PICTURE "@!" OF oDlgMult PIXEL 
		
		@  60, 40 SAY STR0043 OF oDlgMult PIXEL // "Valor"
		@  70, 40 GET nValor SIZE 70, 11   VALID NaoVazio( nValor ) .And. Positivo( nValor ) PICTURE "@E 999,999,999.99" OF oDlgMult PIXEL

		If lFlgPed
			@ 60,145 SAY OemToAnsi(STR0073) OF oDlgMult PIXEL // "Afeta Pedido"
			@ 70,145 MSCOMBOBOX oPedFlag VAR cPedFlag ITEMS aPedFlag SIZE 50, 36 OF oDlgMult PIXEL 
			
			oPedFlag:nAt := Val(aListBox[ oList:nAt, 6 ])
		EndIf
		                                                                                        
		DEFINE SBUTTON oBut1 FROM 100, 207 TYPE 1 ACTION ( If( u_CSVldMult( cDescri,nValor ),( nOpca := 1, If(lFlgPed,cPedFlag := Str(oPedFlag:nAt,1),), oDlgMult:End()), ) )  ENABLE of oDlgMult
		DEFINE SBUTTON oBut2 FROM 100, 239 TYPE 2 ACTION ( nOpca := 0, oDlgMult:End() )  ENABLE of oDlgMult
		
		ACTIVATE MSDIALOG oDlgMult CENTERED  
		
		If nOpca == 1    
			                                    
			aListBox[ oList:nAt, 3 ] := cDescri 
			aListBox[ oList:nAt, 4 ] := nValor  		
			If lFlgPed
				aListBox[ oList:nAt, 6 ] := cPedFlag
			EndIf
			
			bLine := oList:bLine
			oList:SetArray(aListBox)
			oList:bLine := bLine 
			
		EndIf 
		
	Else 
	
		Aviso( STR0044, STR0045, { STR0046 } ) // "Atencao", "Este item nao pode ser alterado !", "Ok"
		
	EndIf 	
	
Else
	Aviso( STR0056, STR0057, { STR0058 }, 2 ) // "Atencao!", "O contrato vinculado a esta medicao nao permite a manipulacao deste movimento !", "Ok"
EndIf 	
		
Return( .T. )          


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CSVldMult   ³ Autor ³ Sergio Silveira     ³ Data ³11/04/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Validacao dos campos de descricao e valor - Inclusao de multa³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpL1 :=  CSVldMult( ExpC2, ExpN3 )                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC2 -> Descricao da multa                                 ³±±
±±³          ³ ExpN3 -> Valor da multa                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ ExpL1 -> Validacao                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSVldMult( cDescri, nValor, aListBox, nItem, nAcao ) 
Local uRet

lRet := !Empty( cDescri ) 

If lRet
	lRet := !Empty( nValor ) 
EndIf                        
                 
If !lRet 
	Help( " ", 1, "NVAZIO" ) 
EndIf

If lRet .And. ExistBlock("CS430MTINC")
	uRet := ExecBlock("CS430MTINC",.F.,.F.,{cDescri,nValor,aListBox,nItem,nAcao})
	
	If valtype(uRet) == "L"
		lRet := uRet
	EndIf
EndIf

Return( lRet ) 
   
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CS430RepMult³ Autor ³ Sergio Silveira     ³ Data ³11/04/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 -> Objeto listbox                                     ³±±
±±³          ³ ExpA2 -> Array de multas do listbox                         ³±±
±±³          ³ ExpA3 -> Array de medicoes                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Efetua o reprocessamento de multas das medicoes              ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CS430RepMult( oList, aListBox, aMedicoes, aHeader ) 
Local bLine := { || .T. } 

If Aviso( STR0044, STR0047, { STR0048, STR0049 }, 2 ) == 1 // "Atencao !", "Os dados informados serao sobrepostos. Confirma o reprocessamento das multas / bonificacoes desta medicao ?", "Sim","Nao" 
				
	aListBox := {} 						
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua o reprocessamento                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CS430ProcMul( aMedicoes, @aListBox, aHeader )
	
   If Empty( aListBox ) 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se estiver vazio, preenche uma linha em branco                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(CNR->( FieldPos("CNR_FLGPED") ))
			AAdd( aListBox, { .F., "", "", 0, "" } )
		Else
			AAdd( aListBox, { .F., "", "", 0, "", "" } )
		EndIf
	EndIf 	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Reinicializa o listBox                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	bLine := oList:bLine
	oList:SetArray(aListBox)
	oList:bLine := bLine 

EndIf 

Return( Nil ) 

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CS430ProcMul³ Autor ³ Sergio Silveira     ³ Data ³11/04/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Efetua o processamento de multas                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A103ProcMul( ExpA1, ExpA2 )                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 -> Array contendo as medicoes                         ³±±
±±³          ³ ExpA2 -> Array do listbox de multas a ser preenchido        ³±±
±±³          ³          ( passado por referencia )                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CS430ProcMul( aMedicoes, aListBox, aHeader )    
Local cCronog    := "" 
Local cAliasQry  := ""
Local cQuery     := "" 
Local lFormula   := .F.  
Local lFlgPed    := CNR->( FieldPos("CNR_FLGPED") ) > 0
Local nLoop      := 0 
Local nLoop2     := 0 
Local nValor     := 0 
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Percorre os itens das medicoes                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nLoop := 1 to Len( aMedicoes ) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no contrato                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	CN9->( dbSetOrder( 1 ) ) 
	CN9->( MsSeek( xFilial( "CN9" ) + M->CND_CONTRA + M->CND_REVISA ) ) 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as variaveis de memoria dos itens das medicoes                    ³
	//³ as variaveis vao ser utilizadas na interpretacao das multas            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nLoop2 := 1 To Len( aHeader ) 
		M->&( aHeader[nLoop2, 2 ] ) := aMedicoes[ nLoop, nLoop2 ]  
	Next nLoop2 	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o cabecalho da planilha                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CNA->( dbSetOrder( 1 ) ) 	                         
	CNA->( MsSeek( xFilial( "CNA" ) + M->CND_CONTRA + M->CND_REVISA + M->CND_NUMERO ) ) 
	
   cCronog := CNA->CNA_CRONOG  
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no cronograma / competencia                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CNF->( dbSetOrder( 2 ) ) 	                         
	CNF->( MsSeek( xFilial( "CNF" ) + M->CND_CONTRA + M->CND_REVISA + cCronog + M->CND_COMPET ) ) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Percorre as multas / bonificacoes deste contrato                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cAliasQry := GetNextAlias() 
	
	cQuery := ""                                                       
	
	cQuery += "SELECT CN4_CODIGO,CN4_DESCRI,CN4_VLDALT,CN4_VLRALT,CN4_VALID,CN4_FORMUL,CN4_TIPO,CNH_NUMERO"
	If lFlgPed
		cQuery += ",CN4_FLGPED"
	EndIf
	cQuery += " FROM " + RetSqlName( "CNH" ) + " CNH," 
	cQuery += RetSqlName( "CN4" ) + " CN4 "
	cQuery += "WHERE "		
	cQuery += "CNH_FILIAL='" + xFilial( "CNH" )   + "' AND "
	cQuery += "CNH_NUMERO='" + M->CND_CONTRA      + "' AND "
	cQuery += "CNH.D_E_L_E_T_=' ' AND "		 
	cQuery += "CNH_CODIGO=CN4_CODIGO AND " 		
	cQuery += "CN4_FILIAL='" + xFilial( "CN4" )   + "' AND "
	cQuery += "CN4.D_E_L_E_T_=' ' "
	cQuery += "ORDER BY CNH_NUMERO,CN4_CODIGO" 		
	
	cQuery := ChangeQuery( cQuery ) 
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. ) 
	
	While !( cAliasQry )->( Eof() ) 

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Avalia a aplicacao da multa                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If Empty( ( cAliasQry )->CN4_VLDALT ) 
			lFormula := Formula(( cAliasQry )->CN4_VALID )  
		Else 			
			lFormula := &( ( cAliasQry )->CN4_VLDALT )			
		EndIf 			

		If lFormula			
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Obtem o valor da multa                                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty( ( cAliasQry )->CN4_VLRALT ) 
				nValor := Formula( ( cAliasQry )->CN4_FORMUL ) 
			Else 			
				nValor := &( ( cAliasQry )->CN4_VLRALT )			
			EndIf
         
			If lFlgPed
				AAdd( aListBox, { .F., ( cAliasQRY )->CN4_TIPO, ( cAliasQRY )->CN4_DESCRI, nValor, "1", ( cAliasQRY )->CN4_FLGPED } ) 
			Else
				AAdd( aListBox, { .F., ( cAliasQRY )->CN4_TIPO, ( cAliasQRY )->CN4_DESCRI, nValor, "1" } ) 
			EndIf
			
		EndIf 
	
		( cAliasQry )->( dbSkip() ) 

	EndDo 	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha a area de trabalho da query                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	( cAliasQRY )->( dbCloseArea() ) 	

	dbSelectArea( "CN4" ) 

Next nLoop 
   
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CS430RetDcr ³ Autor ³ Sergio Silveira     ³ Data ³27/04/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna descricao do produto                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS430RetDcr()                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS430RetDcr()
Local cRet := ""

If !INCLUI
	If lFixo
		cRet := Posicione("CNB",1,xFilial("CNB")+CNE->CNE_CONTRA+CNE->CNE_REVISA+CNE->CNE_NUMERO+CNE->CNE_ITEM,"CNB_DESCRI")
	Else
		cRet := Posicione("SB1",1,xFilial("SB1")+CNE->CNE_PRODUT,"B1_DESC")
	EndIf
EndIf

Return cRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CS430AjSX3  ³ Autor ³ Marcelo Custodio    ³ Data ³08/10/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Corrige inicializador do campo de descricao do tipo de      ³±±
±±³          ³ desconto                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS430AjSX3()                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS430AjSX3()
Local aArea := GetArea()

dbSelectArea("SX3")
dbSetOrder(2)

If dbSeek("CNQ_DESCRI") .And. AllTrim(SX3->X3_RELACAO) != "If(!INCLUI,Posicione('CNP',1,xFilial('CNP')+CNQ->CNQ_TPDESC,'CNP_DESCRI'),'')"
	RecLock("SX3",.F.)
	SX3->X3_RELACAO := "If(!INCLUI,Posicione('CNP',1,xFilial('CNP')+CNQ->CNQ_TPDESC,'CNP_DESCRI'),'')"
	MsUnlock()
EndIf

RestArea(aArea)
Return
