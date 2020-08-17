#INCLUDE "CNTA110.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "ApWizard.CH"

//Situacoes de contrato
#DEFINE DEF_SCANC "01"//Cancelado
#DEFINE DEF_SELAB "02"//Em Elaboracao
#DEFINE DEF_SEMIT "03"//Emitido
#DEFINE DEF_SAPRO "04"//Em Aprovacao
#DEFINE DEF_SVIGE "05"//Vigente
#DEFINE DEF_SPARA "06"//Paralisado
#DEFINE DEF_SSPAR "07"//Sol Fina.
#DEFINE DEF_SFINA "08"//Finalizado
#DEFINE DEF_SREVS "09"//Revisao
#DEFINE DEF_SREVD "10"//Revisado

//Transações
#DEFINE DEF_TRAINC "011"//Inclusao de cronogramas
#DEFINE DEF_TRAEDT "012"//Edicao de cronogramas
#DEFINE DEF_TRAEXC "013"//Exclusao de cronogramas
#DEFINE DEF_TRAVIS "033"//Visualizacao de cronogramas

//Tipos de Revisao
#DEFINE DEF_REALI "3" //Realinhamento

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CSUA410  ³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Manutencao de Cronogramas                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CSUA410()                                                  ³±±
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
User Function CSUA410()
Private cCadastro := OemToAnsi(STR0001) //Manutencao de Cronogramas
PRIVATE aRotina := MenuDef()
mBrowse(6,1,22,75,"CNF")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CNTA110Fin³ Autor ³ Marcelo Custodio      ³ Data ³24.01.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida saida do wizard                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNTA110Fin(lExp01)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lExp01 - Atualizacao de planilha                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CNTA110Fin(lAtuPlan)
Local lRet

If MsgYesNo(OemToAnsi(STR0067))//"Deseja cancelar o assistente de cronograma?"
	lRet := .T.
	if lAtuPlan
		MsgAlert(OemToAnsi(STR0068))//"O contrato não poderá se tornar 'Vigente' enquanto o cronograma referente à planilha não for alterado"
	EndIf
EndIf
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS410Manut³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Manutencao de Cronogramas                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS410Manut(cExp01,nExp02,nExp03,aExp04,cExp05,cExo06)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Alias do arquivo                                  ³±±
±±³          ³ nExp02 - Registro atual                                    ³±±
±±³          ³ nExp03 - Opcao atual                                       ³±±
±±³          ³ nExp04 - Array com os campos                               ³±±
±±³          ³ nExp05 - Contrato selecionado na rotina CNTA100            ³±±
±±³          ³ nExp06 - Revisao do contrato selecionado na rotina CNTA100 ³±±
±±³          ³ lExp07 - Atualizacao de planilha                           ³±±
±±³          ³ lExp08 - Regera cronograma em atualizacao de planilha      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CS410Manut(cAlias,nReg,nOpcX,aCpos,cContra,cRevisa,lAtuPlan,lPlanReg)
Local aPlanilha := {}
Local cCompete  := strzero(Month(dDataBase),2)+"/"+strzero(Year(dDataBase),4)
Local dPrevista := dDataBase
Local nParcelas := 0
Local cCond     := ""
Local cCronog   := ""
Local lDist     := .F.
Local lArrasto  := .F.
Local nSaldCont := 0
Local nSaldPlan := 0
Local cFilCod   := ""
Local cQuery    := ""
Local aArea     := GetArea()
Local lRet      := .T.
Local oOk       := LoadBitmap( GetResources(), "LBTIK" )
Local oNo       := LoadBitmap( GetResources(), "LBNO" )
Local cCampos   := "CNF_FILIAL|CNF_NUMERO|CNF_CONTRA|CNF_MAXPAR|CNF_REVISA|CNF_PERANT"// Campos excluidos da GetDados
Local aTela[0][0]
Local aGets[0]
Local oFont
Local oFnt
Local lContinua := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do painel de contratos                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aStruCN9  := CN9->(dbStruct())
Local cArqCN9   := ""
Local oBrowse//Contratos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do painel de planilhas                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aStruCNA  := CNA->(dbStruct())
Local cArqCNA   := ""
Local oBrowse2//Planilhas

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do painel de cronogramas                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aStruCNF  := CNF->(dbStruct())
Local cArqCNF   := ""
Local oBrowse3//Cronogramas

Local oSaldCont
Local oSaldPlan

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do painel de parcelas                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oDist//Redistribui
Local oArrasto//Arrasto

Local oBtnFsc

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do cronograma fisico                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aColsParc := {}
Local aHeadParc := {}
                      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variavel para armazenar o valor pago do contrato    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nVlrPago := 0


DEFAULT cContra := Space(TamSX3("CN9_NUMERO")[1])
DEFAULT cRevisa := Space(TamSX3("CN9_REVISA")[1])
DEFAULT lAtuPlan:=.F.
DEFAULT lPlanReg:=.F.

If nOpcX != 3
	lContinua := CN240VldUsr(If(lAtuPlan,CNA->CNA_CONTRA,CNF->CNF_CONTRA),If(nOpcX==4,DEF_TRAEDT,If(nOpcX==5,DEF_TRAEXC,DEF_TRAVIS)),.T.)
EndIf

If lContinua

	Private nTotPlan  := 0
	Private nTotCronog:= 0
	Private oTotCronog
	Private oSaldDist//Saldo a ser distribuido
	Private oGetDados//Parcelas
	Private aItVl     := {}//Valores dos itens, usado pelo cronograma fisico
	Private aHeader   := {}
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	If dbSeek("CNF", .F.)
		While !Eof() .And. SX3->X3_ARQUIVO=="CNF"
			If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL) .And. !(AllTrim(SX3->X3_CAMPO) $ cCampos)
				AAdd(aHeader,{AllTrim(X3Titulo()),;
				AllTrim(SX3->X3_CAMPO),;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_F3,;
				SX3->X3_CONTEXT})
			EndIf
			dbSkip()
		EndDo
	EndIf
	
	//Carrega variaveis de controle quando o wizard
	//for chamado pela edicao de planilhas
	If lAtuPlan
		cContra   := CNA->CNA_CONTRA
		cRevisa   := CNA->CNA_REVISA
		cCronog   := CNA->CNA_CRONOG
		aAdd(aPlanilha,{CNA->(Recno()),CNA->CNA_NUMERO})
		
		dbSelectArea("CNF")
		dbSetOrder(2)
		
		//Filtra primeira parcela do cronograma
		cQuery := "Select CNF.R_E_C_N_O_ as RECNO,CNF.CNF_COMPET,CNF.CNF_PRUMED,CNF.CNF_MAXPAR from "+ RetSQLName("CNF") +" CNF "
		cQuery += "where CNF.CNF_FILIAL = '"+ xFilial("CNF") +"' AND "
		cQuery += "CNF.CNF_CONTRA = '"+ cContra +"' AND "
		cQuery += "CNF.CNF_REVISA = '"+ cRevisa +"' AND "
		cQuery += "CNF.CNF_NUMERO = '"+ cCronog +"' AND "
		cQuery += "CNF.CNF_PARCEL = '"+ StrZero(1,TamSX3("CNF_PARCEL")[1]) +"' AND "
		cQuery += "CNF.D_E_L_E_T_ <> '*'"
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCNF",.F.,.T.)
		
		TCSetField("TRBCNF","CNF_PRUMED","D",08,0)
		
		If !TRBCNF->(Eof())
			cCompete  := TRBCNF->CNF_COMPET
			dPrevista := TRBCNF->CNF_PRUMED
			nParcelas := TRBCNF->CNF_MAXPAR
			CNF->(dbGoTo(TRBCNF->RECNO))
		EndIf
		
		TRBCNF->(dbCloseArea())
		
		dbSelectArea("CN9")
		dbSetOrder(1)
		if dbSeek(xFilial("CN9")+CNA->CNA_CONTRA+CNA->CNA_REVISA)
			cCond := CN9->CN9_CONDPG
		EndIf
	EndIf
	
	If nOpcX == 3//Inclusao
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria arquivo temporario para os contratos            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cArqCN9 := CriaTrab(aStruCN9)
		dbUseArea(.T.,,cArqCN9,"TRBCN9",.F.,.F.)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria arquivo temporario para as planilhas            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cArqCNA := CriaTrab(aStruCNA)
		dbUseArea(.T.,,cArqCNA,"TRBCNA",.F.,.F.)
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega informacoes do cronograma se nao for inclusao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cContra := CNF->CNF_CONTRA
		cRevisa := CNF->CNF_REVISA
		cCronog := CNF->CNF_NUMERO
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria arquivo temporario para os cronogramas          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cArqCNF := CriaTrab(aStruCNF)
		dbUseArea(.T.,,cArqCNF,"TRBCNF",.F.,.F.)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega saldo do contrato                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CN9")
		dbSetOrder(1)
		If dbSeek(xFilial("CN9")+cContra+cRevisa)
			nSaldCont := CN9->CN9_SALDO
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Permite exclusao de cronograma quando nas seguintes situacoes de contrato: ³
		//³ - Elaboracao                                                              ³
		//³ - Emitido                                                                 ³
		//³ - Aprovacao                                                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOpcX == 5 .And. AllTrim(CN9->CN9_SITUAC) != DEF_SELAB .And. AllTrim(CN9->CN9_SITUAC) != DEF_SEMIT .And. AllTrim(CN9->CN9_SITUAC) != DEF_SAPRO//Exclusao
			Help(" ",1,"CNTA110EXC") //"A situação atual do contrato não permite a exclusão do cronograma"
			lRet := .F.
		ElseIf nOpcX == 5 .And. !Empty(CN9->CN9_REVATU)
			Help(" ",1,"CNTA110ATU") //"O cronograma não pode ser alterado/excluído pois o contrato possui uma revisão pendente"
			lRet := .F.
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Permite alteracao de cronograma quando nas seguintes situacoes de contrato:³
		//³ - Elaboracao                                                              ³
		//³ - Emitido                                                                 ³
		//³ - Aprovacao                                                               ³
		//³ - Vigente                                                                 ³
		//³ - Revisao                                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOpcX == 4 .And. AllTrim(CN9->CN9_SITUAC) != DEF_SELAB .And. AllTrim(CN9->CN9_SITUAC) != DEF_SEMIT .And. AllTrim(CN9->CN9_SITUAC) != DEF_SAPRO .And. AllTrim(CN9->CN9_SITUAC) != DEF_SVIGE .And. AllTrim(CN9->CN9_SITUAC) != DEF_SREVS//Alteracao
			Help(" ",1,"CNTA110ALT") //"A situação atual do contrato não permite a alteração de cronograma"
			lRet := .F.
		ElseIf nOpcX == 4 .And. !Empty(CN9->CN9_REVATU)
			Help(" ",1,"CNTA110ATU") //"O cronograma não pode ser alterado/excluído pois o contrato possui uma revisão pendente"
			lRet := .F.
		EndIf
	EndIF
	
	If lRet
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao de Fontes e Cores                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DEFINE FONT oFont NAME "Verdana" SIZE 6,-11 BOLD
		DEFINE FONT oFnt  NAME "Arial" SIZE 6,-11 BOLD
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Wizard - Sequencia                 	                ³
		//³                                    	                ³
		//³ Inclusao                             	            ³
		//³ Painel 1 - Apresentacao             	            ³
		//³ Painel 2 - Contrato                	                ³
		//³ Painel 3 - Planilha                	                ³
		//³ Painel 5 - Configuracao            	                ³
		//³ Painel 6 - Parcelas                	                ³
		//³                                    	                ³
		//³ Edicao                             	                ³
		//³ Painel 1 - Apresentacao            	                ³
		//³ Painel 4 - Cronograma              	                ³
		//³ Painel 6 - Parcelas                	                ³
		//³                                    	                ³
		//³ Visualizacao                       	                ³
		//³ Painel 1 - Apresentacao            	                ³
		//³ Painel 6 - Parcelas                	                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Painel 1 - Tela inicial do Wizard 		            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DEFINE WIZARD oWizard;
		TITLE OemToAnsi(STR0009); //"Assistente - Cronograma Financeiro"
		HEADER OemToAnsi(STR0010);//"Manutencao de Cronograma Financeiro"
		TEXT OemToAnsi(STR0011)+CRLF+CRLF+OemToAnsi(STR0012);//"Assistente responsável pela configuração dos Cronogramas Financeiro"##"Clique em avancar e inicie o processo"
		PANEL NEXT {|| CS410VlPn1(nOpcX,cContra,cRevisa,cCronog,@nSaldPlan,lAtuPlan,lPlanReg,aColsParc,aHeadParc,aItVl,oBtnFsc) };
		FINISH {|| CNTA110Fin(lAtuPlan) }
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Painel 2 - Contratos              		            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CREATE PANEL oWizard;
		HEADER OemToAnsi(STR0013);//"Contratos"
		MESSAGE OemToAnsi(STR0014);//"Selecione o contrato"
		PANEL BACK {|| CS410BckPnl(nOpcX,@cContra,@cCond,@cCronog,@aPlanilha,lAtuPlan,lPlanReg) };
		NEXT {|| CS410VlPn2(cContra,cRevisa,@cCompete,@dPrevista,aColsParc,aHeadParc,oBtnFsc)};
		FINISH {|| CNTA110Fin(lAtuPlan) }
		
		If(!Empty(cArqCN9))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Configura browse com arquivo temporario CN9         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oBrowse	  := TWBrowse():New( 000, 000, __DlgWidth(oWizard:oMPanel[2]), __DlgHeight(oWizard:oMPanel[2])-15,,;
			{ "",RetTitle("CN9_NUMERO"),RetTitle("CN9_REVISA"),RetTitle("CN9_DTINIC"),RetTitle("CN9_DTFIM"),RetTitle("CN9_CONDPG"),RetTitle("CN9_SITUAC"),RetTitle("CN9_SALDO") },;
			{ 030,090,030,030,030,030,030,030 }, oWizard:oMPanel[2],,,,,,,,,,,,,"TRBCN9", .T. )
			oBrowse:bLine := {|| { If((cContra==TRBCN9->CN9_NUMERO),oOk,oNo),TRBCN9->CN9_NUMERO,TRBCN9->CN9_REVISA,TRBCN9->CN9_DTINIC,TRBCN9->CN9_DTFIM,TRBCN9->CN9_CONDPG,TRBCN9->CN9_SITUAC,Transform(TRBCN9->CN9_SALDO,PesqPict("CN9","CN9_SALDO"))}}
			oBrowse:bLDblClick := {|| CS410MkContra(@cContra,@cRevisa,@cCond,@nSaldCont), oBrowse:Refresh() }
		EndIf
		
		DEFINE SBUTTON FROM 123,000 TYPE 15 ACTION CS410Visual("CN9",oBrowse:NROWPOS) ENABLE OF oWizard:oMPanel[2]
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Painel 3 - Planilhas              		            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CREATE  PANEL oWizard;
		HEADER OemToAnsi(STR0015);//"Planilhas"
		MESSAGE OemToAnsi(STR0016);//"Selecione a(s) planilha(s) referente(s) ao contrato"
		PANEL BACK {|| CS410BckPnl(nOpcX,@cContra,@cCond,@cCronog,@aPlanilha,lAtuPlan,lPlanReg) };
		NEXT {|| CS410VlPn3(aPlanilha) };
		FINISH {|| CNTA110Fin(lAtuPlan) }
		
		If(!Empty(cArqCN9))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Configura browse com arquivo temporario CNA         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oBrowse2	  := TWBrowse():New( 000, 000, __DlgWidth(oWizard:oMPanel[3]), __DlgHeight(oWizard:oMPanel[3])-15,,;
			{ "",RetTitle("CNA_NUMERO"),RetTitle("CNA_CONTRA"),RetTitle("CNA_REVISA"),RetTitle("CNA_TIPPLA"),RetTitle("CNA_FORNEC"),RetTitle("CNA_LJFORN"),RetTitle("CNA_VLTOT") }, ;
			{ 030,060,090,030,030,040,030,050 }, oWizard:oMPanel[3], , , ,,,,,,,,,,"TRBCNA", .T. )
			oBrowse2:bLine := {|| { If((Ascan(aPlanilha,{|x| x[2]==TRBCNA->CNA_NUMERO}) > 0),oOk,oNo), TRBCNA->CNA_NUMERO,TRBCNA->CNA_CONTRA,TRBCNA->CNA_REVISA,TRBCNA->CNA_TIPPLA,TRBCNA->CNA_FORNEC,TRBCNA->CNA_LJFORN,Transform(TRBCNA->CNA_VLTOT,PesqPict("CNA","CNA_VLTOT")) } }
			oBrowse2:bLDblClick := {|| CS410MkPlani(@aPlanilha,@nSaldPlan), oBrowse2:Refresh() }
		EndIf
		
		DEFINE SBUTTON FROM 123,000 TYPE 15 ACTION CS410Visual("CNA",oBrowse2:NROWPOS) ENABLE OF oWizard:oMPanel[3]
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Painel 4 - Cronogramas            		            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CREATE  PANEL oWizard;
		HEADER OemToAnsi(STR0017);//"Cronogramas - Alteraão"
		MESSAGE OemToAnsi(STR0018);//"Selecione o cronograma e informe os dados de alteração do cronograma"
		PANEL BACK {|| CS410BckPnl(nOpcX,@cContra,@cCond,@cCronog,@aPlanilha,lAtuPlan,lPlanReg) };
		NEXT {|| CS410VlPn4(cCronog,lArrasto,lDist,@nSaldPlan,cCond,lAtuPlan,lPlanReg,nOpcX,aColsParc,aHeadParc,aItVl,oBtnFsc) };
		FINISH {|| CNTA110Fin(lAtuPlan) }
		
		If(!Empty(cArqCNF))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Configura browse com arquivo temporario CNF         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oBrowse3 := TWBrowse():New( 000, 000, __DlgWidth(oWizard:oMPanel[4]), __DlgHeight(oWizard:oMPanel[4])-10,,;
			{ "",RetTitle("CNF_CONTRA"),RetTitle("CNF_REVISA"),RetTitle("CNF_NUMERO"),RetTitle("CNF_COMPET"),RetTitle("CNF_SALDO") }, ;
			{ 050,050,050,050,050 }, oWizard:oMPanel[4], , , ,,,,,,,,,,"TRBCNF", .T. )
			oBrowse3:bLine := {|| { If((cCronog==TRBCNF->CNF_NUMERO),oOk,oNo), TRBCNF->CNF_CONTRA,TRBCNF->CNF_REVISA,TRBCNF->CNF_NUMERO,TRBCNF->CNF_COMPET,Transform(TRBCNF->CNF_SALDO,PesqPict("CNF","CNF_SALDO")) } }
			oBrowse3:bLDblClick := {|| cCronog:=TRBCNF->CNF_NUMERO, oBrowse3:Refresh() }
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Painel 5 - Configuracao do cronograma               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CREATE  PANEL oWizard;
		HEADER OemToAnsi(STR0022);//"Configuração do Cronograma"
		MESSAGE OemToAnsi(STR0023);//"Informe os dados para montar o cronograma"
		PANEL BACK {|| CS410BckPnl(nOpcX,@cContra,@cCond,@cCronog,@aPlanilha,lAtuPlan,lPlanReg) };
		NEXT {|| CS410VlPn5(cCompete,dPrevista,nParcelas,cCond,aPlanilha,cContra,cRevisa,lAtuPlan,lPlanReg,nOpcX,aColsParc,aHeadParc,aItVl) };
		FINISH {|| CNTA110Fin(lAtuPlan) }
		
		@ 010,010 To 100,275 Of oWizard:oMPanel[5] PIXEL
		
		@ 020,015 Say STR0024 Of oWizard:oMPanel[5] PIXEL//"Competência de Início:"
		@ 020,120 MsGet cCompete Valid CS410Compet(@cCompete) PICTURE "99/9999" When .T. Size 30,8 Of oWizard:oMPanel[5] PIXEL
		
		@ 040,015 Say STR0025 Of oWizard:oMPanel[5] PIXEL//"Data prevista da primeira medição:"
		@ 040,120 MsGet dPrevista When .T. PICTURE "@D" Size 50,8 Of oWizard:oMPanel[5] PIXEL
		
		@ 060,015 Say STR0026 Of oWizard:oMPanel[5] PIXEL//"Nº de Parcelas:"
		@ 060,120 MsGet nParcelas Picture "999" When .T. Size 20,8 Of oWizard:oMPanel[5] PIXEL
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Painel 6 - Configuracao do cronograma               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CREATE  PANEL oWizard;
		HEADER OemToAnsi(STR0027);//"Finalizacao"
		MESSAGE OemToAnsi(STR0028);//"Parcelas e confirmacao do cronograma"
		PANEL BACK {|| CS410BckPnl(nOpcX,@cContra,@cCond,@cCronog,@aPlanilha,lAtuPlan,lPlanReg) };
		FINISH {|| CS410Grava(aPlanilha,cContra,cRevisa,cCronog,lAtuPlan,lPlanReg,nOpcX,aColsParc,aHeadParc,aItVl) }
		
		@ 005,005 GROUP oGroup To 020,090 Label STR0029 Of oWizard:oMPanel[6] PIXEL//"Montante das Planilhas "
		oGroup:SetFont(oFnt)
		@ 010,040 Say nTotPlan Picture PesqPict("CNA","CNA_VLTOT") Of oWizard:oMPanel[6] PIXEL
		
		@ 005,100 GROUP oGroup To 020,190 Label STR0030 Of oWizard:oMPanel[6] PIXEL//"Montante do Cronograma "
		oGroup:SetFont(oFnt)
		@ 010,140 Say oTotCronog Var nTotCronog Size 50,8 Picture PesqPict("CNF","CNF_VLPREV") Of oWizard:oMPanel[6] PIXEL
		
		@ 005,200 GROUP oGroup To 020,285 Label STR0031 Of oWizard:oMPanel[6] PIXEL//"Saldo a Distribuir "
		oGroup:SetFont(oFnt)
		@ 010,240 Say oSaldDist Var nTotPlan-nTotCronog Size 50,8 Picture PesqPict("CNA","CNA_VLTOT") Of oWizard:oMPanel[6] PIXEL
		
		@ 102,005 GROUP oGroup To 117,090 Label STR0046 Of oWizard:oMPanel[6] PIXEL//"Saldo do Contrato"
		oGroup:SetFont(oFnt)
		@ 107,040 Say oSaldCont Var nSaldCont Size 50,8 Picture PesqPict("CN9","CN9_VLATU") Of oWizard:oMPanel[6] PIXEL
		
		@ 120,005 GROUP oGroup To 135,090 Label STR0047 Of oWizard:oMPanel[6] PIXEL//"Saldo das Planilhas"
		oGroup:SetFont(oFnt)
		@ 125,040 Say oSaldPlan Var nSaldPlan Size 50,8 Picture PesqPict("CN9","CN9_VLATU") Of oWizard:oMPanel[6] PIXEL

		@ 102 ,256 BUTTON oBtnFsc Prompt OemToAnsi(STR0076) SIZE 29 ,13 ACTION (If(len(aHeadParc) > 0,(CS410Fisico(nOpcX,oGetDados:aCols,oGetDados:nAt,aColsParc,aHeadParc,aItVl),CS410AtuVal(),oGetDados:oBrowse:Refresh()),Aviso("CNTA110",OemToAnsi(STR0075),{"OK"}))) OF oWizard:oMPanel[6] PIXEL//Fisico
				
		ACTIVATE WIZARD oWizard CENTERED
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apaga arquivos temporario                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpcX == 3
		TRBCN9->(dbCloseArea())
		FErase(cArqCN9 + ".DBF")
		FErase(cArqCN9 + OrdBagExt() )
		
		TRBCNA->(dbCloseArea())
		FErase(cArqCNA + ".DBF")
		FErase(cArqCNA + OrdBagExt() )
	Else
		TRBCNF->(dbCloseArea())
		FErase(cArqCNF + ".DBF")
		FErase(cArqCNF + OrdBagExt() )
	EndIF

Else
	lRet := .F.
EndIf
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS410BckPnl³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina responsavel pelo controle do wizard                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS410BckPnl(cExp01,cExp02,cExp03,cExp04,aExp05)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Estado atual                                       ³±±
±±³          ³ cExp02 - Codigo do contrato - referencia                    ³±±
±±³          ³ cExp03 - Codigo da condicao de pagamento - referencia       ³±±
±±³          ³ cExp04 - Numero do cronograma - referencia                  ³±±
±±³          ³ aExp05 - Array com as planilhas selecionas                  ³±±
±±³          ³          aExp02[x][1] - Numero do registro na CNA           ³±±
±±³          ³          aExp02[x][2] - Codigo da planilha                  ³±±
±±³          ³ lExp06 - Atualizacao de planilha                            ³±±
±±³          ³ lExp07 - Regera parcelas ao atualizar planilha              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA110                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410BckPnl(nOpc,cContra,cCond,cCronog,aPlanilha,lAtuPlan,lPlanReg)
Local lRet := .T.
Local nPnAtu := oWizard:NPanel//Painel Atual
Local lRegera := (lAtuPlan .And. lPlanReg)

If nOpc == 3//Inclusao
	if(nPnAtu == 5)
		oWizard:NPanel := 4
	ElseIf(nPnAtu == 2 .And. !lAtuPlan)
		cContra := Space(TamSX3("CN9_NUMERO")[1])
		cCond   := Space(TamSX3("CN9_CONDPG")[1])
	ElseIf(nPnAtu == 3 .And. !lAtuPlan)
		aplanilha := {}
	EndIF
ElseIf nOpc == 2//Visualizacao
	If(nPnAtu == 6)
		oWizard:NPanel := 2
	EndIf
Else
	If(nPnAtu == 6 .And. !lRegera)
		oWizard:NPanel := 5
	ElseIf(nPnAtu == 6 .And. lRegera)
		oWizard:NPanel := 6
	ElseIf(nPnAtu == 4)
		oWizard:NPanel := 2
		If !lAtuPlan
			cCronog := Space(TamSX3("CNF_NUMERO")[1])
		EndIf
	EndIf
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS410MkContra³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Realiza a marcacao do contrato selecionado                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS410MkContra(cExp01,cExp02,cExp03,nExp04)                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Codigo do contrato - referencia                      ³±±
±±³          ³ cExp02 - Codigo da revisao - referencia                       ³±±
±±³          ³ cExp03 - Codigo da condicao de pagamento - referencia         ³±±
±±³          ³ nExp04 - Saldo do contrato - referencia                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA110                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410MkContra(cContra,cRevisa,cCond,nSaldCont)
cContra   :=TRBCN9->CN9_NUMERO
cRevisa   :=TRBCN9->CN9_REVISA
cCond     :=TRBCN9->CN9_CONDPG
nSaldCont :=TRBCN9->CN9_SALDO
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS410MkPlani³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Adiciona/Exclui planilha selecionada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS410MkPlani(aExp01,nExp02)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Array de armazenagem das planilhas                  ³±±
±±³          ³          aExp02[x][1] - Numero do registro na CNA            ³±±
±±³          ³          aExp02[x][2] - Codigo da planilha                   ³±±
±±³          ³ nExp02 - Saldo das planilhas                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA110                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410MkPlani(aPlanilha,nSaldPlan)
Local cPlani := TRBCNA->CNA_NUMERO
Local nTot   := TRBCNA->CNA_VLTOT
Local nRec   := TRBCNA->(Recno())
Local nPos   := Ascan(aPlanilha,{|x| x[2]==cPlani})


//Alteracao para limitar selecao de apenas 1 planilha
//por cronograma
If nPos > 0
	aDel(aPlanilha,nPos)
	aSize(aPlanilha,Len(aPlanilha)-1)
Else
	If len(aPlanilha) > 0
		aDel(aPlanilha,1)
		aSize(aPlanilha,Len(aPlanilha)-1)
	EndIf
	Aadd(aPlanilha,{nRec,cPlani})
EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS410Visual ³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica rotina e exibe registro selecionado                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS410Visual(cExp01,nExp02)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Alias do arquivo                                    ³±±
±±³          ³ nExp02 - Posicao do browse                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA110                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410Visual(cAlias,nAt)

Local aArea   := GetArea()
Local lAntInc := INCLUI
INCLUI := .F.

If cAlias == "CN9" // -- Visualiza Contrato
	TRBCN9->(dbGoTo(nAt))
	dbSelectArea("CN9")
	dbSetOrder(1)
	dbSeek(xFilial("CN9")+TRBCN9->CN9_NUMERO+TRBCN9->CN9_REVISA)
	u_CS400Manut("CN9",CN9->(RecNo()),2)//Chama rotina do CNTA100
ElseIf cAlias == "CNA" // -- Visualiza Planilha
	TRBCNA->(dbGoTo(nAt))
	dbSelectArea("CNA")
	dbSetOrder(1)
	dbSeek(xFilial("CNA")+TRBCNA->CNA_CONTRA+TRBCNA->CNA_REVISA+TRBCNA->CNA_NUMERO)
	u_CS600Manut("CNA",CNA->(RecNo()),2)//Chama rotina do CNTA200
EndIf

INCLUI := lAntInc
RestArea(aArea)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS410VlPn1  ³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Carrega o painel de selecao de contrato/cronograma           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS410VlPn1(nExp01,cExp02,cExp03,cExp04,nExp05,nExp06,nExp07,  ³±±
±±³          ³           aExp08,aExp09,aExp10,oExp11)                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Opcao atual                                         ³±±
±±³          ³ cExp02 - Codigo do contrato                                  ³±±
±±³          ³ cExp03 - Codigo da revisao                                   ³±±
±±³          ³ cExp04 - Numero do cronograma                                ³±±
±±³          ³ nExp05 - Saldo das planilhas - referencia                    ³±±
±±³          ³ lExp06 - Atualiza planilha                                   ³±±
±±³          ³ lExp07 - Regera cronograma ao atualizar planilha             ³±±
±±³          ³ aExp08 - Array contendo os itens do cronograma fisico        ³±±
±±³          ³ aExp09 - Array contento o cabecalho do cronograma fisico     ³±±
±±³          ³ aExp10 - Array contendo os valores e quantidades dos itens   ³±±
±±³          ³          do cronograma ficiso (planilha)                     ³±±
±±³          ³ oExp11 - Botao de manutencao do cronograma fisico            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410VlPn1(nOpc,cContra,cRevisa,cCronog,nSaldPlan,lAtuPlan,lPlanReg,aColsParc,aHeadParc,aItVl,oBtnFsc)
Local cQuery    := ""
Local aArea     := GetArea()
Local lRet      := .T.
Default cContra := ""
Default cRevisa := ""

If nOpc == 3//Inclusao
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra contratos com planilhas sem cronograma       ³
	//³ e que nao possuam medicao eventual                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT DISTINCT CN9.CN9_FILIAL,CN9.CN9_NUMERO,CN9.CN9_REVISA,CN9.CN9_DTINIC,CN9.CN9_DTFIM,CN9.CN9_CONDPG,CN9.CN9_SITUAC,CN9.CN9_SALDO "
	cQuery += "FROM " + RetSqlName("CN9") + " CN9 ," + RetSqlName("CNA") + " CNA ," + RetSqlName("CN1") + " CN1 "
	cQuery += "where CN9.CN9_FILIAL =  '" + xFilial("CN9") + "' AND CNA.CNA_FILIAL = '"+ xFilial("CNA") +"' AND CN1.CN1_FILIAL = '"+ xFilial("CN1") +"' AND "
	cQuery += "CN9.CN9_NUMERO = CNA.CNA_CONTRA AND CN9.CN9_REVISA = CNA.CNA_REVISA AND CN9.CN9_TPCTO = CN1.CN1_CODIGO AND "
	If !Empty(cContra)
		cQuery += "CN9.CN9_NUMERO = '" + cContra + "' AND CN9.CN9_REVISA = '" + cRevisa + "' AND "
	EndIf
	cQuery += "CN9.CN9_SITUAC in ('"+ DEF_SELAB +"','"+ DEF_SEMIT +"','"+ DEF_SAPRO +"') AND "
	cQuery += "CN9.CN9_REVATU = ' ' AND "
	cQuery += "CNA.CNA_CRONOG = ' ' AND "
	cQuery += "CN1.CN1_MEDEVE = '2' AND "//Fitra contratos sem medicao e
	cQuery += "CN9.D_E_L_E_T_ = ' ' AND CNA.D_E_L_E_T_ = ' ' AND CN1.D_E_L_E_T_ = ' '"

	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.F.,.T.)
	
	//Configura campos especificos
	TCSetField("TRB","CN9_DTINIC","D",08,0)
	TCSetField("TRB","CN9_DTFIM" ,"D",08,0)
	TCSetField("TRB","CN9_SALDO" ,"N",TamSX3("CN9_SALDO")[1],TamSX3("CN9_SALDO")[1])
	
	dbSelectArea("TRB")
	dbGoTop()
	
	If !Eof()
		
		dbSelectArea("TRBCN9")
		If RecCount() > 0
			Zap
		Endif
		
		dbSelectArea("TRB")
		While !Eof()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Adiciona registros filtrados ao arquivo temporario  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RecLock("TRBCN9",.T.)
			TRBCN9->CN9_NUMERO := TRB->CN9_NUMERO
			TRBCN9->CN9_REVISA := TRB->CN9_REVISA
			TRBCN9->CN9_DTINIC := TRB->CN9_DTINIC
			TRBCN9->CN9_DTFIM  := TRB->CN9_DTFIM
			TRBCN9->CN9_CONDPG := TRB->CN9_CONDPG
			TRBCN9->CN9_SITUAC := TRB->CN9_SITUAC
			TRBCN9->CN9_SALDO  := TRB->CN9_SALDO
			MsUnlock()
			dbSelectArea("TRB")
			dbSkip()
		Enddo
		
		TRBCN9->(dbGoTop())
		
	Else
		Aviso(OemToAnsi(STR0033),OemToAnsi(STR0032),{"Ok"}) //"Não há contratos com planilhas em aberto"##"Atenção"
		lRet := .F.
	Endif
	
	TRB->(dbCloseArea())
	
ElseIf nOpc == 2 .Or. nOpc == 5//Visualizacao
	//-- Zerar o Saldo da variavel nSaldPlan para nao acumular o saldo 
	//-- toda vez que o usuario clicar no botao "<< Voltar"
	nSaldPlan := 0 
	CS410VisCro(cCronog,@nSaldPlan,nOpc,cContra,cRevisa,aColsParc,aHeadParc,aItVl,oBtnFsc)
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra os cronogramas do contrato - Visualizacao/Edicao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT CNF.CNF_FILIAL,CNF.CNF_NUMERO,CNF.CNF_CONTRA,CNF.CNF_REVISA,Min(CNF.CNF_COMPET) as CNF_COMPET,Sum(CNF.CNF_SALDO) as CNF_SALDO "
	cQuery += "FROM " + RetSqlName("CNF") + " CNF "
	cQuery += "where CNF.CNF_FILIAL =  '" + xFilial("CNF") + "' AND "
	cQuery += "CNF.CNF_CONTRA = '" + cContra + "' AND CNF.CNF_REVISA = '" + cRevisa + "' AND "
	If lAtuPlan
		cQuery += "CNF.CNF_NUMERO = '" + cCronog + "' AND "
	EndIf
	cQuery += "CNF.D_E_L_E_T_ = ' ' "
	cQuery += "GROUP BY CNF.CNF_FILIAL,CNF.CNF_NUMERO,CNF.CNF_CONTRA,CNF.CNF_REVISA"
	cQuery := ChangeQuery(cQuery)
	
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.F.,.T.)
	
	TCSetField("TRB","CNF_SALDO","N",TamSX3("CNF_SALDO")[1],TamSX3("CNF_SALDO")[2])
	
	dbSelectArea("TRB")
	dbGoTop()
	
	If !Eof()
		
		dbSelectArea("TRBCNF")
		If RecCount() > 0
			Zap
		Endif
		
		dbSelectArea("TRB")
		While !Eof()
			RecLock("TRBCNF",.T.)
			TRBCNF->CNF_NUMERO := TRB->CNF_NUMERO
			TRBCNF->CNF_CONTRA := TRB->CNF_CONTRA
			TRBCNF->CNF_REVISA := TRB->CNF_REVISA
			TRBCNF->CNF_COMPET := TRB->CNF_COMPET
			TRBCNF->CNF_SALDO  := TRB->CNF_SALDO
			MsUnlock()
			dbSelectArea("TRB")
			dbSkip()
		Enddo
		
		TRBCNF->(dbGoTop())
		
	Else
		Aviso(OemToAnsi(STR0033),OemToAnsi(STR0034),{"Ok"}) //"Não há cronogramas para o contrato."##"Atenção"
		lRet := .F.
	Endif
	
	TRB->(dbCloseArea())
	//Segue para o painel de cronogramas
	oWizard:NPanel:=3
EndIf

RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS410VlPn2  ³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Verifica a selecao do contrato e segue para o painel de       ³±±
±±³          ³selecao de planilhas                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS410VlPn2(cExp01,cExp02,cExp03,cExp04,aExp05,aExp06,oExp07)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Codigo do contrato                                  ³±±
±±³          ³ cExp02 - Revisao do contrato                                 ³±±
±±³          ³ cExp03 - Competencia de inicio - referencia                  ³±±
±±³          ³ cExp04 - Data prevista primeira med. - referencia            ³±±
±±³          ³ aExp05 - Array contendo os itens do cronograma fisico        ³±±
±±³          ³ aExp06 - Array contento o cabecalho do cronograma fisico     ³±±
±±³          ³ oExp07 - Botao de manutencao do cronograma fisico            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410VlPn2(cContra,cRevisa,cCompete,dPrevista,aColsParc,aHeadParc,oBtnFsc)

Local lRet   := .T.
Local cQuery := ""
Local aArea  := GetArea()
Local lFisico:= .F.

If !Empty(cContra)

	lRet := CN240VldUsr(cContra,DEF_TRAINC,.T.)
	
	If lRet
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona no contrato        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CN9")
		dbSetOrder(1)
		dbSeek(xFilial("CN9")+cContra+cRevisa)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o contrato possui controle fisico³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lFisico := ((CN1->(FieldPos("CN1_CROFIS")) > 0) .And. Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_CROFIS") == "1")
		
		If lFisico
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Monta estrutura do cronograma fisico         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aColsParc := {}
			CS410MtFsc(aHeadParc)
			
			oBtnFsc:lVisibleControl := .T.
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Retira botao "Fisico" da tela                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oBtnFsc:lVisibleControl := .F.
		EndIf
		oBtnFsc:Refresh()
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Filtra as planilhas de acordo com o Contrato escolhido.        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "SELECT CNA.CNA_CONTRA,CNA.CNA_REVISA,CNA.CNA_NUMERO,CNA.CNA_TIPPLA,CNA.CNA_FORNEC,CNA.CNA_LJFORN,CNA.CNA_VLTOT,CNA.CNA_DTINI "
		cQuery += "FROM " + RetSqlName("CNA") + " CNA "
		cQuery += "WHERE CNA.CNA_FILIAL =  '" + xFilial("CNA") + "' AND "
		cQuery += "CNA.CNA_CONTRA = '" + cContra + "' AND CNA.CNA_REVISA = '" + cRevisa + "' AND "
		cQuery += "CNA.CNA_CRONOG = ' ' AND "
		cQuery += "CNA.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY " + SqlOrder(CNA->(IndexKey(1)))
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.F.,.T.)
		
		TCSetField("TRB","CNA_VLTOT","N",18,2)
		
		dbSelectArea("TRB")
		dbGoTop()
		
		If !Eof()
			
			dbSelectArea("TRBCNA")
			If RecCount() > 0
				Zap
			Endif
			
			dbSelectArea("TRB")
			dPrevista := TRB->CNA_DTINI
			While !Eof()
				If RecLock("TRBCNA",.T.)
					TRBCNA->CNA_NUMERO := TRB->CNA_NUMERO
					TRBCNA->CNA_CONTRA := TRB->CNA_CONTRA
					TRBCNA->CNA_REVISA := TRB->CNA_REVISA
					TRBCNA->CNA_TIPPLA := TRB->CNA_TIPPLA
					TRBCNA->CNA_FORNEC := TRB->CNA_FORNEC
					TRBCNA->CNA_LJFORN := TRB->CNA_LJFORN
					TRBCNA->CNA_VLTOT  := TRB->CNA_VLTOT
					MsUnlock()
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Armazena menor data de inicio entre as planilhas selecionadas  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If TRB->CNA_DTINI < dPrevista
					dPrevista := TRB->CNA_DTINI
				EndIf
				
				dbSelectArea("TRB")
				dbSkip()
			Enddo
			
			TRBCNA->(dbGoTop())
			
			//Converte para data
			dPrevista := CTOD(SUBS(dPrevista,7,2)+"/"+SUBS(dPrevista,5,2)+"/"+SUBS(dPrevista,1,4))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Armazena menor competencia de inicio entre as planilhas selecionadas  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cCompete := strzero(Month(dPrevista),2)+"/"+str(Year(dPrevista),4)
			
		Else
			Aviso(OemToAnsi(STR0033),OemToAnsi(STR0035),{"Ok"}) //"Não há planilhas para o contrato."##"Atenção"
			lRet := .F.
		Endif
		
		TRB->(dbCloseArea())
	EndIf	
Else
	Aviso(OemToAnsi(STR0033),OemToAnsi(STR0036),{"Ok"}) //"Selecione um contrato para continuar"##"Atenção"
	lRet := .F.
Endif

RestArea(aArea)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS410VlPn3  ³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Verifica a selecao das planilhas e segue para o painel de     ³±±
±±³          ³configuracao das parcelas                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS410VlPn3(aExp01)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Array de armazenagem das planilhas                  ³±±
±±³          ³          aExp02[x][1] - Numero do registro na CNA            ³±±
±±³          ³          aExp02[x][2] - Codigo da planilha                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410VlPn3(aPlanilha)
Local lRet := .T.

If len(aPlanilha) = 0
	Help(" ",1,"CNTA110MEN") //"Selecione ao menos uma planilha"
	lRet := .F.
Endif

If lRet
	oWizard:NPanel:=4
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS410VlPn4  ³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Verifica a selecao dos cronogramas, realiza as alteracoes     ³±±
±±³          ³das parcelas quando solicitado e segue para o painel de       ³±±
±±³          ³planilhas                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS410VlPn4(cExp01,lExp02,lExp03,nExp04,cExp05,lExp06,lExp07,  ³±±
±±³          ³            nExp08,aExp09,aExp10,aExp11,oExp12)               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Codigo do cronograma                                ³±±
±±³          ³ lExp02 - Arrasto                                             ³±±
±±³          ³ lExp03 - Distribuicao                                        ³±±
±±³          ³ nExp04 - Saldo das planilhas - referencia                    ³±±
±±³          ³ cExp05 - Cond de Pagamento do contrato                       ³±±
±±³          ³ lExp06 - Atualizacao de Planilha                             ³±±
±±³          ³ lExp07 - Regera parcelas do cronograma da planilha           ³±±
±±³          ³ nExp08 - Opcao Atual                                         ³±±
±±³          ³ aExp09 - Array contendo os itens do cronograma fisico        ³±±
±±³          ³ aExp10 - Array contento o cabecalho do cronograma fisico     ³±±
±±³          ³ aExp11 - Array contendo os valores e quantidades dos itens   ³±±
±±³          ³          do cronograma ficiso (planilha)                     ³±±
±±³          ³ oExp12 - Botao de manutencao do cronograma fisico            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410VlPn4(cCronog,lArrasto,lDist,nSaldPlan,cCond,lAtuPlan,lPlanReg,nOpc,aColsParc,aHeadParc,aItVl,oBtnFsc)
Local lRet      := .T.
Local aParcela  := {}
Local aAreaAnt	:= GetArea()
Local nSaldo    := 0
Local nSaldoMed := 0
Local nParnMed  := ""
Local nNovParc  := 0
Local nTotnMed  := 0
Local nTotMed   := 0
Local cQuery    := ""
Local lFisico   := .F.
Local cContra
Local cRevisa
Local nX
Local aStrucCNF := CNF->(dbStruct())
Local cPlan

nTotCronog := nTotPlan := 0

If Empty(cCronog)
	Help(" ",1,"CNTA110CTR") //"Selecione um contrato"
	lRet := .F.
EndIF

If lRet
	
	//Atualizacao de planilha e geração automática das parcelas
	If lAtuPlan .And. lPlanReg
		nTotPlan := CNA->CNA_VLTOT
		nSaldPlan:= CNA->CNA_SALDO
		
		//Avanca para o painel de configuracao de cronograma
		oWizard:NPanel:=4
	Else
		
		nTotPlan := 0
		
		cContra := CNF->CNF_CONTRA
		cRevisa := CNF->CNF_REVISA

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Seleciona a planilha                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		dbSelectArea("CNA")
		dbSetOrder(2)
		dbSeek(xFilial("CNA")+cCronog)

		cPlan := CNA->CNA_NUMERO

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Seleciona o contrato                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
		dbSelectArea("CN9")
		dbSetOrder(1)
		dbSeek(xFilial("CN9")+cContra+cRevisa)
		                      
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o contrato mantem controle fisico³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		lFisico := ((CN1->(FieldPos("CN1_CROFIS")) > 0) .And. Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_CROFIS") == "1")
		
		If lFisico
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Monta estrutura para rotina de cronograma fisico   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			aColsParc := {}
			aItVl     := {}
			If len(aHeadParc) == 0
				CS410MtFsc(aHeadParc)
			EndIf
			oBtnFsc:lVisibleControl := .T.
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Retira botao "Fisico" da tela                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oBtnFsc:lVisibleControl := .F.
		EndIf
		oBtnFsc:Refresh()
				          
		cQuery := "Select sum(CNA.CNA_VLTOT) as CNA_VLTOT,sum(CNA.CNA_SALDO) as CNA_SALDO from "+ RetSQLName("CNA") +" CNA "
		cQuery += "where CNA.CNA_FILIAL = '"+ xFilial("CNA") +"' AND "
		cQuery += "CNA.CNA_CONTRA = '"+ CNF->CNF_CONTRA +"' AND "
		cQuery += "CNA.CNA_REVISA = '"+ CNF->CNF_REVISA +"' AND "
		cQuery += "CNA.CNA_CRONOG = '"+ cCronog +"' AND "
		cQuery += "CNA.D_E_L_E_T_ = ''"

		cQuery := ChangeQuery(cQuery)	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CNASUM",.F.,.T.)
		TCSetField( "CNASUM", "CNA_VLTOT", "N", TamSX3("CNA_VLTOT")[1], TamSX3("CNA_VLTOT")[2] )
		TCSetField( "CNASUM", "CNA_SALDO", "N", TamSX3("CNA_SALDO")[1], TamSX3("CNA_SALDO")[2] )
		
		nTotPlan := CNASUM->CNA_VLTOT
		nSaldo   := CNASUM->CNA_SALDO
		CNASUM->( dbCloseArea() )
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Seleciona cronograma                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "Select CNF.* from "+ RetSQLName("CNF") +" CNF "
		cQuery += "where CNF.CNF_FILIAL = '"+ xFilial("CNF") +"' AND "
		cQuery += "CNF.CNF_CONTRA = '"+ cContra +"' AND "
		cQuery += "CNF.CNF_REVISA = '"+ cRevisa +"' AND "
		cQuery += "CNF.CNF_NUMERO = '"+ cCronog +"' AND "
		cQuery += "CNF.D_E_L_E_T_ <> '*' "
		cQuery += "ORDER BY CNF.CNF_PARCEL"
		
		cQuery := ChangeQuery(cQuery)	
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CNFTMP",.F.,.T.)
			
		For nx:=1 to len(aStrucCNF)
			if CNFTMP->(FieldPos(aStrucCNF[nx,1])) > 0 .And. aStrucCNF[nx,2] <> "C"
				TCSetField( "CNFTMP", aStrucCNF[nx,1], aStrucCNF[nx,2], aStrucCNF[nx,3], aStrucCNF[nx,4] )
			endif
		Next
		
		While !CNFTMP->(Eof())
			aAdd(aParcela,Array(len(aHeader)+1))
			For nx:=1 to len(aHeader)
				aParcela[len(aParcela),nx] := CNFTMP->&(aHeader[nx,2])
			Next
			aParcela[len(aParcela),len(aHeader)+1] := .F.
			
			nTotCronog += CNFTMP->CNF_VLPREV//Soma total do cronograma
			nVlrPago   += CNFTMP->CNF_VLREAL

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se a parcela foi medida                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(CNFTMP->CNF_DTREAL)
				nSaldoMed += CNFTMP->CNF_SALDO//Soma saldo medido
				nTotMed   += Round(CNFTMP->CNF_VLPREV,TamSX3("CNF_VLPREV")[2])//Soma montante medido
			Else
				nTotnMed++//Incrementa parcelas nao medidas
				If Empty(nParnMed)
					nParnMed := CNFTMP->CNF_PARCEL//Primeira parceça nao medida
				EndIf
			EndIf
			dbSkip()
		EndDo

		CNFTMP->(dbCloseArea())
		
		If lFisico
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Monta cronograma fisico         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			CS410LdFsc(aColsParc,aHeadParc,aItVl,cContra,cRevisa,cCronog,cPlan)
		EndIf
		
		nSaldPlan  := nSaldo
			
		IF lRet
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula arrasto com ou sem distribuicao              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lArrasto
				If nSaldoMed == 0
					Help(" ",1,"CNTA110SLD") //"Não existe saldo em aberto para o cronograma"
					lRet := .F.
				ElseIf nTotnMed == 0
					Help(" ",1,"CNTA110ABT") //"Não existem parcelas em aberto para o cronograma"  
					lRet := .F.
				EndIf
				If lRet
					If lDist
						nNovParc := nSaldoMed / nTotnMed//Divide o saldo nao medido pelas parcelas em aberto
						
						For nX := 1 to len(aParcela)
							
							If !Empty(aParcela[nx,8])
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Retira o saldo restante das parcelas medidas         ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								aParcela[nX,3] -= aParcela[nX,5]
								nTotMed		   -= Round(aParcela[nX,5],TamSX3("CNF_VLPREV")[2])
								aParcela[nX,5] := 0
							Else
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Incrementa o valor nas parcelas nao medidas          ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								aParcela[nX,5] += nNovParc
								aParcela[nX,3] += nNovParc
								nTotMed		   += Round(aParcela[nX,3],TamSX3("CNF_VLPREV")[2])
							EndIf
						Next
					Else
						For nX := 1 to len(aParcela)
							If !Empty(aParcela[nx,8])
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Retira o saldo restante das parcelas medidas         ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								aParcela[nX,3] -= aParcela[nX,5]
								nTotMed		   -= Round(aParcela[nX,5],TamSX3("CNF_VLPREV")[2])
								aParcela[nX,5] := 0
							ElseIf aParcela[nx,1] == nParnMed
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Incrementa o valor na primeira parcela nao medida    ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								aParcela[nx,5] += nSaldoMed
								aParcela[nx,3] += nSaldoMed
								nTotMed	     	+= Round(aParcela[nX,3],TamSX3("CNF_VLPREV")[2])
							Else
								nTotMed	     	+= Round(aParcela[nX,3],TamSX3("CNF_VLPREV")[2])
							EndIf
						Next
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica se houve diferenca entre o valor do         ³
					//³cronograma e o valor arrastado                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nTotCronog > nTotMed
						aParcela[len(aParcela),3] += (nTotCronog - nTotMed)
						aParcela[len(aParcela),5] += (nTotCronog - nTotMed)
					Elseif nTotCronog < nTotMed
						aParcela[len(aParcela),3] -= (nTotMed - nTotCronog)
						aParcela[len(aParcela),5] -= (nTotMed - nTotCronog)
					EndIf
				EndIf
			EndIf
			
			IF lRet
				//Exibe get dados das parcelas
				CS410GetParc(aParcela,nOpc,aColsParc,aHeadParc,aItVl,lFisico)
				//Avanca para o painel das parcelas
				oWizard:NPanel:=5
			EndIf
		EndIf
	EndIF
EndIf
RestArea(aAreaAnt)
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS410VisCro ³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Exibe as parcelas do cronograma                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS410VisCro(cExp01,nExp02,nExp03,nExp04,nExp05,aExp06,aExp07, ³±±
±±³          ³            aExp08,oExp09)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Codigo do cronograma                                ³±±
±±³          ³ nExp02 - Saldo das Planilhas - referencia                    ³±±
±±³          ³ nExp03 - Opcao atual                                         ³±±
±±³          ³ cExp04 - Codigo do Contrato                                  ³±±
±±³          ³ cExp05 - Revisao do contrato                                 ³±±
±±³          ³ aExp06 - Array contendo os itens do cronograma fisico        ³±±
±±³          ³ aExp07 - Array contento o cabecalho do cronograma fisico     ³±±
±±³          ³ aExp08 - Array contendo os valores e quantidades dos itens   ³±±
±±³          ³          do cronograma ficiso (planilha)                     ³±±
±±³          ³ oExp09 - Botao de manutencao do cronograma fisico            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410VisCro(cCronog,nSaldPlan,nOpc,cContra,cRevisa,aColsParc,aHeadParc,aItVl,oBtnFsc)
Local aParcela  := {}
Local aStrucCNF := CNF->(dbStruct())
Local cQuery    := ""
Local nx        := 0
Local lFisico   := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no contrato           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CN9")
dbSetOrder(1)
dbSeek(xFilial("CN9")+cContra+cRevisa)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o contrato possui controle fisico ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
lFisico := ((CN1->(FieldPos("CN1_CROFIS")) > 0) .And. Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_CROFIS") == "1")

If lFisico
	oBtnFsc:lVisibleControl := .T.
Else
	oBtnFsc:lVisibleControl := .F.
EndIf
oBtnFsc:Refresh()

nTotCronog := nTotPlan := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula total das planilhas                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                  
cQuery := "Select CNA.CNA_VLTOT from "+ RetSQLName("CNA") +" CNA "
cQuery += "where CNA.CNA_FILIAL = '"+ xFilial("CNA") +"' AND "
cQuery += "CNA.CNA_CONTRA = '"+ cContra +"' AND "
cQuery += "CNA.CNA_REVISA = '"+ cRevisa +"' AND "
cQuery += "CNA.CNA_CRONOG = '"+ cCronog +"' AND "
cQuery += "CNA.D_E_L_E_T_ <> '*'"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "CNATMP", .F., .F. )

If !CNATMP->(Eof())
	nTotPlan := CNATMP->CNA_VLTOT
EndIf

CNATMP->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seleciona o cronograma                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "Select CNF.* from "+ RetSQLName("CNF") +" CNF "
cQuery += "where CNF.CNF_FILIAL = '"+ xFilial("CNF") +"' AND "
cQuery += "CNF.CNF_CONTRA = '"+ cContra +"' AND "
cQuery += "CNF.CNF_REVISA = '"+ cRevisa +"' AND "
cQuery += "CNF.CNF_NUMERO = '"+ cCronog +"' AND "
cQuery += "CNF.D_E_L_E_T_ <> '*' "
cQuery += "ORDER BY CNF.CNF_PARCEL"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "CNFTMP", .F., .F. )

For nx:=1 to len(aStrucCNF)
	if CNFTMP->(FieldPos(aStrucCNF[nx,1])) > 0 .And. aStrucCNF[nx,2] <> "C"
		TCSetField( "CNFTMP", aStrucCNF[nx,1], aStrucCNF[nx,2], aStrucCNF[nx,3], aStrucCNF[nx,4] )
	endif
Next

While !CNFTMP->(Eof())
	aAdd(aParcela,Array(len(aHeader)+1))
	For nx:=1 to len(aHeader)
		aParcela[len(aParcela),nx] := CNFTMP->&(aHeader[nx,2])
	Next
	aParcela[len(aParcela),len(aHeader)+1] := .F.

	nTotCronog+= CNFTMP->CNF_VLPREV
	nSaldPlan += CNFTMP->CNF_SALDO
	CNFTMP->(dbSkip())
EndDo                

CNFTMP->(dbCloseArea())

If lFisico 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta estrutura do cronograma fisico         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aColsParc := {}
	aItVl     := {}
	If len(aHeadParc) == 0
		CS410MtFsc(aHeadParc)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona na planilha                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CNA")
	dbSetOrder(2)
	dbSeek(xFilial("CNA")+CNF->CNF_NUMERO)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega cronograma fisico                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CS410LdFsc(aColsParc,aHeadParc,aItVl,cContra,cRevisa,CNF->CNF_NUMERO,CNA->CNA_NUMERO)
EndIf

//Exibe get dados com as parcelas
CS410GetParc(aParcela,nOpc,aColsParc,aHeadParc,aItVl,lFisico)

//Exibe painel 6 - Parcelas
oWizard:NPanel:=5

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS410VlPn5  ³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Valida o painel de configuracao das parcelas                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS410VlPn5(cExp01,dExp02,nExp03,cExp04,aExp05,nExp06,nExp07   ³±±
±±³          ³           ,cExp08,cExp09,nExp10,aExp11,aExp12,aExp13)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Competencia                                         ³±±
±±³          ³ nExp02 - Data prevista da primeira medicao                   ³±±
±±³          ³ nExp03 - Quantidade de parcelas                              ³±±
±±³          ³ nExp04 - Condicao de pagamento                               ³±±
±±³          ³ nExp05 - Planilhas                                           ³±±
±±³          ³ cExp06 - Codigo do contrato                                  ³±±
±±³          ³ cExp07 - Revisao do contrato                                 ³±±
±±³          ³ lExp08 - Atualizacao de Planilha                             ³±±
±±³          ³ lExp09 - Regera parcelas ao atualizar planilha               ³±±
±±³          ³ nExp10 - Opcao atual                                         ³±±
±±³          ³ aExp11 - Array contendo os itens do cronograma fisico        ³±±
±±³          ³ aExp12 - Array contento o cabecalho do cronograma fisico     ³±±
±±³          ³ aExp13 - Array contendo os valores e quantidades dos itens   ³±±
±±³          ³          do cronograma fisico (planilha)                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410VlPn5(cCompete,dPrevista,nParcelas,cCond,aPlanilha,cContra,cRevisa,lAtuPlan,lPlanReg,nOpc,aColsParc,aHeadParc,aItVl)
Local lRet := .T.
Local dComp := CTOD("01/"+cCompete)
Local nX := 0
Local nY := 0
Local aParcela := {}
Local nVlParcela := 0
Local nMes, nAno, nAvanco
Local dFimCrono := dPrevista
Local cParcel   := StrZero(0,TamSx3("CNF_PARCEL")[1])//Controla a ordem das parcelas
Local nPerc     := 0
Local nPosCpo   := 0
Local lFisico   := .F.
Local cQuery    := ""
Local cAlias    := ""
Local lFirst    := .F.
Local nCont     := 0
Local nPosSld   := 0
Local nPosItm   := 0
Local nPosQtd   := 0
Local nPosRlz   := 0
Local nPosTot   := 0
Local nPosPrd   := 0
Local nPosDcr   := 0
Local nRest     := 0
Local nParc     := 0
Local lReali    := .F.
Local aRest     := {}
Local nPosVlPrv := aScan(aHeader,{|x| AllTrim(x[2]) == "CNF_VLPREV"})
Local nPosSaldo := aScan(aHeader,{|x| AllTrim(x[2]) == "CNF_SALDO"})

nTotCronog := nTotPlan := 0

If Empty(cCond)//Valida contrato sem condicao
	Help(" ",1,"CNTA110CON") //"O contrato não possui condição de pagamento configurada"
	lRet := .F.
Elseif Empty(cCompete) .OR. Empty(dPrevista) .OR. Empty(nParcelas)
	Help(" ",1,"CNTA110CAM") //"Preencha todos os campos"
	lRet := .F.
Elseif dprevista < dComp//Compara data da primeira medicao com a competencia
	Help(" ",1,"CNTA110PRE") //"A data de previsão deve ser maior que a competência de início"
	lRet := .F.
EndIF

nMes := VAL(SUBS(cCompete,1,2))
nAno := VAL(SUBS(cCompete,4,4))

CN9->(dbSetOrder(1))
CN9->(dbSeek(xFilial("CN9")+cContra+cRevisa))

If nAno < Year(CN9->CN9_DTINIC) .Or. (nAno = Year(CN9->CN9_DTINIC) .And. nMes < Month(CN9->CN9_DTINIC))
	Help(" ",1,"CNTA110CPT") //"Competência de início inválida"
	lRet := .F.
ElseIf nAno > Year(CN9->CN9_DTFIM) .Or. (nAno = Year(CN9->CN9_DTFIM) .And. nMes > Month(CN9->CN9_DTFIM))
	Help(" ",1,"CNTA110CPT") //"Competência de início inválida"
	lRet := .F.
ElseIf dPrevista < CN9->CN9_DTINIC .Or. dPrevista > CN9->CN9_DTFIM
	Help(" ",1,"CNTA110DAT") //"Data da primeira medição inválida"
	lRet := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula data final do cronograma             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx:=1 to nParcelas-1
	nAvanco  := Day(LastDay(dFimCrono))
	dFimCrono+= nAvanco
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica data final do cronograma contra     ³
//³data final do contrato                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If dFimCrono > CN9->CN9_DTFIM
	Help(" ",1,"CNTA110ULT") //"A quantidade de parcelas é inválida pois ultrapassou a data final do contrato"
	lRet := .F.
EndIf


If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o contrato possui controle fisico³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lFisico := ((CN1->(FieldPos("CN1_CROFIS")) > 0) .And. Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_CROFIS") == "1")
	
	If CN9->CN9_SITUAC == DEF_SREVS
		dbSelectArea("CN0")
		dbSetOrder(1)
		dbSeek(xFilial("CN0")+CN9->CN9_TIPREV)
		lReali  := (CN0->CN0_TIPO == DEF_REALI)
	EndIf

	If lFisico
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta estrutura do cronograma fisico       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aColsParc := {}
		aItVl     := {}
		If len(aHeadParc) == 0
			CS410MtFsc(aHeadParc)
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calcula o total das planilhas                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lAtuPlan
		For nX := 1 to len(aPlanilha)
			TRBCNA->(dbgoto(aPlanilha[nX][1]))
			nTotPlan +=	TRBCNA->CNA_VLTOT
		Next
	Else
		nTotPlan := CNA->CNA_VLTOT
	EndIf
	
	nTotCronog := nTotPlan
	
	nVlParcela := nTotPlan/nParcelas//Valor das parcelas
	
	If lRet
		If lFisico
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Seleciona itens da planilha       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery := "SELECT CNB.CNB_ITEM,CNB.CNB_QUANT,CNB.CNB_VLUNIT,CNB.CNB_DESC,CNB.CNB_PRODUT,CNB.CNB_DESCRI,CNB.CNB_REALI FROM "+RetSQLName("CNB")+" CNB WHERE "
			cQuery += "CNB.CNB_FILIAL = '"+xFilial("CNB")+"' AND "
			cQuery += "CNB.CNB_CONTRA = '"+CN9->CN9_NUMERO+"' AND "
			cQuery += "CNB.CNB_REVISA = '"+CN9->CN9_REVISA+"' AND "
			cQuery += "CNB.CNB_NUMERO = '"+If(lAtuPlan,CNA->CNA_NUMERO,TRBCNA->CNA_NUMERO)+"' AND "
			cQuery += "CNB.D_E_L_E_T_ = ' ' ORDER BY CNB.CNB_ITEM"
			
			cAlias := GetNextAlias()
			
			cQuery := ChangeQuery( cQuery )
			dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )
			
			TCSetField(cAlias,"CNB_QUANT"  ,"N",TamSX3("CNB_QUANT")[1],TamSX3("CNB_QUANT")[2])
			TCSetField(cAlias,"CNB_VLUNIT" ,"N",TamSX3("CNB_VLTOT")[1],TamSX3("CNB_VLTOT")[2])
			TCSetField(cAlias,"CNB_DESC"   ,"N",TamSX3("CNB_DESC")[1] ,TamSX3("CNB_DESC")[2])
			TCSetField(cAlias,"CNB_REALI"  ,"N",TamSX3("CNB_REALI")[1],TamSX3("CNB_REALI")[2])
					
			(cAlias)->(dbGoTop())

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula posicao dos campos do cronograma fisico³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPosSld := aScan(aHeadParc,{|x| AllTrim(x[2])=="CNS_SLDQTD"})
			nPosItm := aScan(aHeadParc,{|x| AllTrim(x[2])=="CNS_ITEM"})
			nPosQtd := aScan(aHeadParc,{|x| AllTrim(x[2])=="CNS_PRVQTD"})
			nPosRlz := aScan(aHeadParc,{|x| AllTrim(x[2])=="CNS_RLZQTD"})
			nPosTot := aScan(aHeadParc,{|x| AllTrim(x[2])=="CNS_TOTQTD"})
			nPosPrd := aScan(aHeadParc,{|x| AllTrim(x[2])=="CNS_PRODUT"})
			nPosDcr := aScan(aHeadParc,{|x| AllTrim(x[2])=="CNS_DESCRI"})
		EndIf

		For nX := 1 to nParcelas
			cParcel := Soma1(cParcel)
			
			if !lFisico
				nParc := Round(nVlParcela,TamSx3("CNF_VLPREV")[2])
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Calcula valor restante do arrendondamento³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nRest += nVlParcela-nParc
			EndIf
			
			aAdd(aParcela,Array(len(aHeader)+1))
			For nY:=1 to len(aHeader)
				Do Case
					Case aHeader[nY,2] == "CNF_PARCEL"
						aParcela[len(aParcela),nY] := cParcel
					Case aHeader[nY,2] == "CNF_COMPET"
						aParcela[len(aParcela),nY] := 	strzero(Month(dPrevista),2)+"/"+str(Year(dPrevista),4)
					Case aHeader[nY,2] == "CNF_VLPREV" .And. !lFisico
						aParcela[len(aParcela),nY] := nParc
					Case aHeader[nY,2] == "CNF_VLREAL"
						aParcela[len(aParcela),nY] := 0
					Case aHeader[nY,2] == "CNF_SALDO" .And. !lFisico
						aParcela[len(aParcela),nY] := nParc
					Case aHeader[nY,2] == "CNF_DTVENC"
						aParcela[len(aParcela),nY] := dPrevista
					Case aHeader[nY,2] == "CNF_PRUMED"
						aParcela[len(aParcela),nY] := dPrevista
					Case aHeader[nY,2] == "CNF_TXMOED"
						aParcela[len(aParcela),nY] := RecMoeda(dPrevista,CN9->CN9_MOEDA)
					OtherWise
						aParcela[len(aParcela),nY] := CriaVar(aHeader[nY,2])
				End Case
			Next
			aParcela[len(aParcela),len(aHeader)+1] := .F.

			nMes     := Month(dPrevista)
			nAno     := Year(dPrevista)
			nAvanco  := Day(LastDay(dPrevista))//Calcula dias para o proximo mes
			dPrevista:= dPrevista+nAvanco

			If lFisico
				lFirst := (len(aItVl) == 0)
			
				(cAlias)->(dbGoTop())
				nCont := 0

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Reinicializa valor da parcela    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nParc := 0
				
				While !(cAlias)->(Eof())
					nCont++
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Inclui item no cronograma fisico ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If len(aColsParc) < nx
						aAdd(aColsParc,{})
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Inclui item no array de controle ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lFirst
						If !lReali
							aAdd(aItVl,{(cAlias)->CNB_VLUNIT-(((cAlias)->CNB_VLUNIT*(cAlias)->CNB_DESC)/100),(cAlias)->CNB_QUANT,0})
						Else
							aAdd(aItVl,{(cAlias)->CNB_REALI-(((cAlias)->CNB_REALI*(cAlias)->CNB_DESC)/100),(cAlias)->CNB_QUANT,0})
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Armazena quantidade no array de controle para arredondamento ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aAdd(aRest,(cAlias)->CNB_QUANT)
					EndIf
					aAdd(aColsParc[nx],Array(len(aHeadParc)+1))

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Inicializa os campos do item     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For nPosCpo:=1 to len(aHeadParc)
						If aHeadParc[nPosCpo,10] != "V"
							aColsParc[nx,len(aColsParc[nx]),nPosCpo] := CriaVar(aHeadParc[nPosCpo,2])
						EndIf
					Next
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Preenche o campo Item            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nPosItm>0
						aColsParc[nx,len(aColsParc[nx]),nPosItm]:=(cAlias)->CNB_ITEM
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Preenche o campo de quantidade prevista ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nPosQtd>0
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Divide a quantidade pelo total de parcelas ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nQtd := Round(((cAlias)->CNB_QUANT)/nParcelas,TamSX3("CNS_PRVQTD")[2])
						aColsParc[nx,len(aColsParc[nx]),nPosQtd]:=nQtd
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Preenche o saldo ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If nPosSld>0
							aColsParc[nx,len(aColsParc[nx]),nPosSld]:=nQtd
						EndIf
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Preenche quantidade realizada           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nPosRlz>0
						aColsParc[nx,len(aColsParc[nx]),nPosRlz]:=0
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Preenche quantidade total               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nPosTot>0
						aColsParc[nx,len(aColsParc[nx]),nPosTot]:=(cAlias)->CNB_QUANT
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Preenche codigo do produto para visualizacao³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nPosPrd>0
						aColsParc[nx,len(aColsParc[nx]),nPosPrd]:=(cAlias)->CNB_PRODUT
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Preenche descricao do produto para visualizacao³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nPosDcr>0
						aColsParc[nx,len(aColsParc[nx]),nPosDcr]:=(cAlias)->CNB_DESCRI
					EndIf
				
					aColsParc[nx,len(aColsParc[nx]),len(aHeadParc)+1] := .F.
					
					(cAlias)->(dbSkip())
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Atualiza valor da parcela de acordo com o cronograma fisico ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nParc += aItVl[nCont,1]*nQtd
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica se existe quantidade restante devido a divisao ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aRest[nCont] -= nQtd
				EndDo			

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza valor da parcela  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nPosSaldo > 0
			  		aParcela[len(aParcela),nPosSaldo] := nParc
			 	EndIf
			 	If nPosVlPrv > 0
					aParcela[len(aParcela),nPosVlPrv] := nParc
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza resto da parcela  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nRest += nVlParcela-nParc
				
			EndIf
		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Fecha alias quando tiver controle fisico ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lFisico
			(cAlias)->(dbCloseArea())
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza valor restante do arredondamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lFisico
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica as quantidades restantes dos itens do cronograma fisico ³ 
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nx:=1 to len(aRest)
			If nPosQtd > 0
				aColsParc[len(aParcela),nx,nPosQtd] += aRest[nx]
				If nPosSld>0
					aColsParc[len(aParcela),nx,nPosSld] += aRest[nx]
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adiciona valor restante na ultima parcela³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			If nPosVlPrv > 0
				aParcela[len(aParcela)][nPosVlPrv] += aRest[nx]*aItVl[nx,1]
			EndIf
			If nPosSaldo > 0
				aParcela[len(aParcela)][nPosSaldo] += aRest[nx]*aItVl[nx,1]
			EndIf
		Next
	ElseIf nRest != 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Adiciona valor restante na ultima parcela³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nPosVlPrv > 0
			aParcela[len(aParcela)][nPosVlPrv] += nRest
		EndIf
		
		If nPosSaldo > 0
			aParcela[len(aParcela)][nPosSaldo] += nRest
		EndIf
	EndIf
	
	//Exibe a getdados das parcelas
	CS410GetParc(aParcela,nOpc,aColsParc,aHeadParc,aItVl,lFisico)
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS410GetParc³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Monta o getdados do painel 6 com as parcelas do cronograma    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS410GetParc(aExp01,nExp02,nExp03,nExp04,lExp05)              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Array com os valores das parcelas                   ³±±
±±³          ³          aExp01[x][1] - Numero da Parcela                    ³±±
±±³          ³          aExp01[x][2] - Competencia                          ³±±
±±³          ³          aExp01[x][3] - Valor Previsto                       ³±±
±±³          ³          aExp01[x][4] - Valor Real                           ³±±
±±³          ³          aExp01[x][5] - Saldo                                ³±±
±±³          ³          aExp01[x][6] - Vencimento                           ³±±
±±³          ³          aExp01[x][7] - Previsao de Medicao                  ³±±
±±³          ³          aExp01[x][8] - Data real de Medicao                 ³±±
±±³          ³ nExp02 - Opcao atual                                         ³±±
±±³          ³ nExp03 - Montante do cronograma - Referencia                 ³±±
±±³          ³ nExp04 - Montante das planilhas                              ³±±
±±³          ³ lExp05 - Informa se o contrato mantem controle fisico        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410GetParc(aParcela,nOpc,aColsParc,aHeadParc,aItVl,lFisico)
Local nX
Local aCpo     := {}
Local aNCpo    := {}
Local aCols    := {}
Local oOk      := LoadBitmap( GetResources(), "LBTIK" )
Local nPosVlPrv:= 0

If oGetDados == NIL
	If lFisico// Campos que nao poderao ser alterados na GetDados
		aNCpo := {"CNF_VLPREV"}
	EndIf

	dbSelectArea("SX3")
	dbSetOrder(1)
	SX3->( dbSeek("CNF") )
	
	While SX3->X3_ARQUIVO == "CNF"
		If SX3->X3_VISUAL == "A" .And. (aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim(SX3->X3_CAMPO)}) > 0) .And. (aScan(aNCpo,AllTrim(SX3->X3_CAMPO)) == 0)
			aAdd(aCpo,AllTrim(SX3->X3_CAMPO))
		EndIf
		
		SX3->( dbSkip() )
	EndDo
	
	aCols   := aParcela
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta GetDados                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetDados := MsNewGetDados():New(025,005,100,285,IIF(nOpc!=3 .And. nOpc!=4,0,GD_UPDATE),,,,aCpo,,,,,,oWizard:oMPanel[6],aHeader,aCols)
Else
	oGetDados:aCols := aParcela
EndIf

If lFisico
	nPosVlPrv := aScan(oGetDados:aHeader,{|x| x[2] == "CNF_VLPREV"})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Altera o evento do duplo clique para chamar a rotina ³
	//³do cronograma fisico                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetDados:oBrowse:bLDblClick := {|| If(oGetDados:oBrowse:COLPOS==nPosVlPrv,(CS410Fisico(nOpc,oGetDados:aCols,oGetDados:nAt,aColsParc,aHeadParc,aItVl),CS410AtuVal(),oGetDados:oBrowse:Refresh()),oGetDados:EDITCELL()) }
EndIf

oGetDados:nMax:=Len(oGetDados:aCols)
oGetDados:oBrowse:Refresh()
oGetDados:Refresh()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza saldo disponivel           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSaldDist:cTitle  := Transform(nTotPlan-nTotCronog,PesqPict("CNF","CNF_VLPREV"))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS410MtFsc  ³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Monta o aHeader do cronograma fisico com base no arquivo CNS  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS410MtFsc(aExp01)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Array para montagem do cabecalho                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA110                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410MtFsc(aHeadParc,lVisu)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campos nao exibidos                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cCampos := "CNS_FILIAL|CNS_CONTRA|CNS_REVISA|CNS_CRONOG|CNS_PARCEL|CNS_PLANI"

Default lVisu := .F.

If lVisu
	cCampos += "|CNS_DISTSL"
EndIf

dbSelectArea("SX3")
dbSetOrder(1)

If dbSeek("CNS")
	While !Eof() .And. SX3->X3_ARQUIVO=="CNS"
		If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL) .And. !(AllTrim(SX3->X3_CAMPO) $ cCampos)
			AAdd(aHeadParc,{AllTrim(X3Titulo()),;
			AllTrim(SX3->X3_CAMPO),;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_F3,;
			SX3->X3_CONTEXT})
		EndIf
		dbSkip()
	EndDo
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS410Fisico ³ Autor ³ Marcelo Custodio      ³ Data ³16.08.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Rotina responsavel pelo cronograma fisico de cada parcela     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS410Fisico(nExp01,aExp02,nExp03,aExp04,aExp05,aExp06)        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Opcao atual                                         ³±±
±±³          ³ aExp02 - Array com as parcelas financeiras do cronograma     ³±±
±±³          ³ nExp03 - Parcela atual                                       ³±±
±±³          ³ aExp04 - Array contendo os itens do cronograma fisico        ³±±
±±³          ³ aExp05 - Array contento o cabecalho do cronograma fisico     ³±±
±±³          ³ aExp06 - Array contendo os valores e quantidades dos itens   ³±±
±±³          ³          do cronograma ficiso (planilha)                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA110                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410Fisico(nOpc,aCols,nAt,aColsParc,aHeadParc,aItVl)
Local oDlg
Local ogetFsc
Local nOpca  := 2  
Local aCpo   := {"CNS_PRVQTD"}
Local nx     := 0
Local nPosQtd:=aScan(aHeadParc,{|x| AllTrim(x[2])=="CNS_PRVQTD"})
Local nPosSld:=aScan(aHeadParc,{|x| AllTrim(x[2])=="CNS_DISTSL"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura do aColsParc                                               ³
//³-aColsParc[1]       - aCols do cronograma fisico da parcela 01       ³
//³--aColsParc[1,1]    - primeiro item da parcela 01                    ³
//³---aColsParc[1,1,1] - primeiro campo do primeiro item da parcela 01  ³
//³-aColsParc[2]       - aCols do cronograma fisico da parcela 02       ³
//³--aColsParc[2,1]    - primeiro item da parcela 02                    ³
//³---aColsParc[2,1,1] - primeiro campo do primeiro item da parcela 02  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura do aItVl                                           ³
//³-aItVl[1]    - Primeiro item da planilha                     ³
//³--aItVl[1,1] - Valor do item na planilha                     ³
//³--aItVl[1,2] - Quantidade total na planilha                  ³
//³--aItVl[1,3] - Quantidade a distribuir no cronograma fisico  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PRIVATE oTotFsc
PRIVATE nTotFsc:=0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula total da parcela            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx:=1 to len(aColsParc[nat])
	aColsParc[nat,nx,nPosSld] := aItVl[nx,3]
	nTotFsc += aColsParc[nat,nx,nPosQtd]*aItVl[nx,1]
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta Dialog                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0072) FROM 009,000 TO 025,060 OF oMainWnd//"Cronograma Fisico"

@ 002,110 GROUP oGroup To 020,145 Label OemToAnsi(STR0073) Of oDlg PIXEL//"Parcela"
@ 008,130 Say oParc Var aCols[nat,1] Size 040,050 Picture PesqPict("CNF","CNF_PARCEL") Of oDlg PIXEL

@ 002,150 GROUP oGroup To 020,232 Label OemToAnsi(STR0074) Of oDlg PIXEL//"Total"
@ 008,190 Say oTotFsc Var nTotFsc Size 110,008 Picture PesqPict("CNF","CNF_VLPREV") Of oDlg PIXEL

ogetFsc := MsNewGetDados():New(022,005,100,232,IIF(nOpc==2 .OR. nOpc==5,0,GD_UPDATE),,,,aCpo,,,,,,oDlg,aHeadParc,aColsParc[nat])

DEFINE SBUTTON FROM 105, 173 TYPE 1 ACTION (nOpca:=1,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 105, 203 TYPE 2 ACTION (nOpca:=2,oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Zera o valor e o saldo financeiro da parcela³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols[nat,3] := 0
	aCols[nat,5] := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calcula total da parcela e soma no cronograma financeiro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   For nx:=1 to len(ogetFsc:aCols)
   	aItVl[nx,3]  := ogetFsc:aCols[nx,nPosSld]
   	aCols[nat,3] += oGetFsc:aCols[nx,nPosQtd]*aItVl[nx,1]
   Next
   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Preenche o saldo da parcela financeira³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   aCols[nat,5] := aCols[nat,3]

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza array com os itens fisicos   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
	aColsParc[nat] := ogetFsc:aCols
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CSVldVal    ³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Valida alteracao no valor de parcela                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CSVldVal()                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSUA400                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jose Carlos |27/06/08³      ³Mudanca no nome da funcao (CN110VLDVAL())   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSVldVal()
Local lRet 	:= .T.
Local nPos1 := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_VLREAL"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se previsao e menor que realizado    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If &(Readvar()) < oGetDados:aCols[oGetDados:OBROWSE:NAT,nPos1]
	lRet := .F.
	Help(" ",1,"CNTA110REA") //"Valor previsto não deve ser menor que realizado"
	o:bEditCol := { || }//Nao atualiza montante
Else
	o:bEditCol := { || CS410AtuVal()}//Atualiza montante
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS410AtuVal ³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Recalcula montante do cronograma e saldo disponivel           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS410AtuVal()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410AtuVal()
Local nX
Local nPos1 := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_VLPREV"})
Local nPos2 := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_VLREAL"})
Local nPos3 := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_SALDO"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Recalculo do Montante do Cronograma e Saldo a Distribuir    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTotCronog := 0
For nX := 1 To Len(oGetDados:aCols)
	nTotCronog += Round(oGetDados:aCols[nX,nPos1],TamSX3("CNF_VLPREV")[2])
	oGetDados:aCols[nX,nPos3] := oGetDados:aCols[nX,nPos1]-oGetDados:aCols[nX,nPos2]
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Altera componentes do painel                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oTotCronog:cTitle := Transform(nTotCronog,PesqPict("CNF","CNF_VLPREV"))
oSaldDist:cTitle  := Transform(nTotPlan-nTotCronog,PesqPict("CNF","CNF_VLPREV"))

oGetDados:oBrowse:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS410Compet ³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Valida competencia                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS410Compet(nExp01)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Competencia                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410Compet(cCompet)

LOCAL nMes := VAL(SUBS(cCompet,1,2))
LOCAL nAno := VAL(SUBS(cCompet,4,4))

If nAno >= 0 .And. nAno <= 99
	nAno := nAno + 2000
EndIf

IF nMes < 1 .OR. nMes > 12
	RETURN(.F.)
ELSEIF nAno < 1980 .OR. nAno > 2199
	RETURN(.F.)
ENDIF

cCompet := STRZERO(nMes,2)+"/"+STRZERO(nAno,4)

RETURN(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS410Grava  ³ Autor ³ Marcelo Custodio      ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Realiza a gravacao do cronograma                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CS410Grava(nExp01,nExp02,nExp03,nExp04,lExp05,lExp06,nExp07)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nExp01 - Array com as planilhas selecionadas                 ³±±
±±³          ³ nExp02 - Contrato                                            ³±±
±±³          ³ nExp03 - Revisao                                             ³±±
±±³          ³ nExp04 - Cronograma                                          ³±±
±±³          ³ lExp05 - Atualizacao de planilha                             ³±±
±±³          ³ lExp06 - Regera parcelas ao atualizar planilha               ³±±
±±³          ³ nExp07 - Opcao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410Grava(aPlanilha,cContra,cRevisa,cCron,lAtuPlan,lPlanReg,nOpc,aColsParc,aHeadParc,aItVl)
Local lRet    := .T.
Local nX      := 0
Local nY      := 0
Local nPos1   := 0
Local nPos2   := 0
Local nPos3   := 0
Local nPos4   := 0
Local nPos5   := 0
Local nPos6   := 0
Local nPos7   := 0
Local nPos8   := 0
Local nPos9   := 0
Local cFilCod := ""
Local nPosCpo := 0
Local cAlias  :=""
Local nPosIt  :=0
Local lFisico := .F.
Local nPosItm := 0
Local nSaldo  := 0
Local lAtuSld := .F.
     
dbSelectArea("CN9")
dbSetOrder(1)
dbSeek(xFilial("CN9")+cContra+cRevisa)

lFisico := ((CN1->(FieldPos("CN1_CROFIS")) > 0) .And. Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_CROFIS") == "1")

If !lFisico
	If(nTotCronog != nTotPlan)
		Help(" ",1,"CNTA110MON") //"O montante do cronograma deve ser igual ao montante das planilhas"
		lRet := .F.
	EndIf
else
	For nx:=1 to len(aItVl)//Valida o saldo fisico do cronograma
		If aItVl[nx,3] != 0
			nPosItm := aScan(aHeadParc,{|x| AllTrim(x[2]) == "CNS_ITEM"})
			Aviso(OemToAnsi(STR0033),OemToAnsi(STR0077)+aColsParc[1,nx,nPosItm]+OemToAnsi(STR0078),{"Ok"})//"O saldo físico do item "##" não foi distríbuido corretamente entre as parcelas"
			lRet := .F.
			Exit
		EndIf
	Next
EndIF

If nOpc == 3 .OR. nOpc == 4 .OR. nOpc == 5
	nPos1 := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_PARCEL"})
	nPos2 := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_COMPET"})
	nPos3 := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_VLPREV"})
	nPos4 := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_VLREAL"})
	nPos5 := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_SALDO"})
	nPos6 := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_DTVENC"})
	nPos7 := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_PRUMED"})
	nPos8 := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_DTREAL"})
	
	If lRet
		cFilCod := xFilial("CNF")
		dbSelectArea("CNF")
		dbSetOrder(2)
		If nOpc ==3 .OR. (lAtuPlan .And. lPlanReg)//Inclusao ou alteracao de parcela ou alteracao de planilha com geracaod e parcelas
			If nOpc == 3
				cCron := GetSX8Num("CNF","CNF_NUMERO")
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Exclui parcelas caso tenham sido alteradas    ³
			//³para manter controle da numeracao             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (lAtuPlan .And. lPlanReg)
				If AliasInDic("CNS")
					dbSelectArea("CNS")
					dbSetOrder(1)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Seleciona os itens do cronograma fisico       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cQuery := "SELECT CNS.R_E_C_N_O_ as RECNO FROM "+RetSQLName("CNS")+" CNS WHERE "
					cQuery += "CNS.CNS_FILIAL = '"+xFilial("CNS")+"' AND "
					cQuery += "CNS.CNS_CONTRA = '"+cContra+"' AND "
					cQuery += "CNS.CNS_REVISA = '"+cRevisa+"' AND "
					cQuery += "CNS.CNS_CRONOG = '"+cCron+"' AND "
					cQuery += "CNS.D_E_L_E_T_ = ' '"
					
					cAlias := GetNextAlias()
					cQuery := ChangeQuery( cQuery )
					dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Apaga os itens do cronograma fisico           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					While !(cAlias)->(Eof())
					   CNS->(dbGoTo((cAlias)->RECNO))
					   RecLock("CNS",.F.)
					   dbDelete()
					   MsUnlock()
						(cAlias)->(dbSkip())
					EndDo
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Apaga a parcela do cronograma financeiro      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            dbSelectArea("CNF")
				dbSeek(cFilCod+cContra+cRevisa+cCron)
				While !Eof() .And. CNF->CNF_FILIAL == cFilCod .And. CNF->CNF_CONTRA == cContra .And. CNF->CNF_REVISA == cRevisa .And. CNF->CNF_NUMERO == cCron
					RecLock("CNF",.F.)
					dbDelete()
					MsUnLock()
					dbSkip()
				EndDo
			EndIf

			lAtuSld := .T.
			For nx := 1 to len(oGetDados:aCols)
				RecLock("CNF",.T.)
				CNF->CNF_FILIAL := cFilCod
				CNF->CNF_NUMERO := cCron
				CNF->CNF_CONTRA := cContra
				For nY:=1 to len(aHeader)
					CNF->&(aHeader[nY,2]) := oGetDados:aCols[nX,nY]
				Next
				CNF->CNF_MAXPAR := len(oGetDados:aCols)
				CNF->CNF_REVISA := cRevisa
				MsUnLock()
				nSaldo += oGetDados:aCols[nX][nPos4]				
		
				If AliasInDic("CNS") .And. len(aColsParc) > 0
					For nY:=1 to len(aColsParc[nx])
						RecLock("CNS",.T.)
						CNS->CNS_FILIAL := xFilial("CNS")
						CNS->CNS_CONTRA := CNF->CNF_CONTRA
						CNS->CNS_REVISA := CNF->CNF_REVISA
						CNS->CNS_CRONOG := CNF->CNF_NUMERO
						CNS->CNS_PARCEL := CNF->CNF_PARCEL
						CNS->CNS_PLANI  := aPlanilha[1,2]
						For nPosCpo:=1 to len(aHeadParc)
							CNS->&(aHeadParc[nPosCpo,2]) := aColsParc[nX,nY,nPosCpo]
						Next
						MsUnlock()
					Next
				EndIf
			Next
			
		ElseIf nOpc == 4//Alteracao
			nPosIt := aScan(aHeadParc,{|x| AllTrim(x[2])=="CNS_ITEM"})

			lAtuSld := .T.
			For nx := 1 to len(oGetDados:aCols)
				dbSelectArea("CNF")
				If dbSeek(cFilCod+cContra+cRevisa+cCron+oGetDados:aCols[nX][nPos2])
					RecLock("CNF",.F.)
					For nY:=1 to len(aHeader)
						CNF->&(aHeader[nY,2]) := oGetDados:aCols[nX,nY]
					Next
					CNF->CNF_VLPREV := oGetDados:aCols[nX][nPos3]
					CNF->CNF_SALDO  := oGetDados:aCols[nX][nPos5]
					CNF->CNF_DTVENC := oGetDados:aCols[nX][nPos6]
					MsUnLock()
					nSaldo += oGetDados:aCols[nX][nPos4]
					
					If AliasInDic("CNS") .And. len(aColsParc) > 0
						dbSelectArea("CNS")
						dbSetOrder(1)
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Altera itens do cronograma fisico             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						For nY:=1 to len(aColsParc[nx])
							If dbSeek(xFilial("CNS")+cContra+cRevisa+cCron+CNF->CNF_PARCEL+aColsParc[nx,nY,nPosIt])
								RecLock("CNS",.F.)
								For nPosCpo:=1 to len(aHeadParc)
									CNS->&(aHeadParc[nPosCpo,2]) := aColsParc[nX,nY,nPosCpo]
								Next
								MsUnlock()
							EndIf
						Next
					EndIf
				EndIF
			Next
			
			dbSelectArea("CN9")
			dbSetOrder(1)
			If dbSeek(xFilial("CN9")+cContra+cRevisa) .And. AllTrim(CN9->CN9_SITUAC) == DEF_SVIGE .And. (GetNewPar( "MV_CNPROVI" , "S" ) == "S")
				MsAguarde({||u_CS400ETit(cContra,cRevisa,cCron)},STR0070)//Exclui Titulos provisorios
				MsAguarde({||u_CS400CTit(cContra,cRevisa,cCron)},STR0071)//Gera Titulos provisorios
			EndIf
			
		ElseIf nOpc == 5//Exclusao
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Altera cabecalho das planilhas                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("CNA")
			dbSetOrder(2) //CNA_FILIAL+CNA_CRONOG
			While dbSeek(cFilCod+cCron)
				If CNA->CNA_REVISA == cRevisa
					RecLock("CNA",.F.)
					CNA->CNA_CRONOG := Space(TamSX3("CNA_CRONOG")[1])
					MsUnlock()
				EndIf
			EndDo
			
			If AliasInDic("CNS")
				dbSelectArea("CNS")
				dbSetOrder(1)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Seleciona itens do cronograma fisico          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cQuery := "SELECT CNS.R_E_C_N_O_ as RECNO FROM "+RetSQLName("CNS")+" CNS WHERE "
				cQuery += "CNS.CNS_FILIAL = '"+xFilial("CNS")+"' AND "
				cQuery += "CNS.CNS_CONTRA = '"+cContra+"' AND "
				cQuery += "CNS.CNS_REVISA = '"+cRevisa+"' AND "
				cQuery += "CNS.CNS_CRONOG = '"+cCron+"' AND "
				cQuery += "CNS.D_E_L_E_T_ = ' '"
				
				cAlias := GetNextAlias()
				cQuery := ChangeQuery( cQuery )
				dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), cAlias, .F., .F. )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Exclui itens do cronograma fisico             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				While !(cAlias)->(Eof())
				   CNS->(dbGoTo((cAlias)->RECNO))
				   RecLock("CNS",.F.)
				   dbDelete()
				   MsUnlock()
					(cAlias)->(dbSkip())
				EndDo
			EndIf

			dbSelectArea("CNF")
			dbSetOrder(2)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Exclui cronograma                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While dbSeek(cFilCod+cContra+cRevisa+cCron)
				RecLock("CNF",.F.)
				dbDelete()
				MsUnLock()
			EndDo
			lAtuSld := .T.	 
			nSaldo  := 0
			
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o Saldo do Contrato                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAtuSld .And. ( ((nOpc == 3 .Or. nOpc == 4) .And. (nSaldo > 0)) .Or. ( nOpc == 5 )) 
			dbSelectArea("CN9")
			dbSetOrder(1)
			If dbSeek(xFilial("CN9")+cContra+cRevisa)
				RecLock("CN9",.F.)    				
			 	CN9->CN9_SALDO  := (CN9->CN9_SALDO + nVlrPago) - nSaldo
			 	CN9->CN9_VLRPAG := nSaldo
				MsUnLock()
			EndIf	
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza as planilhas com o cronograma        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CNA")
		dbSetorder(1)
		For nX:=1 to Len(aPlanilha)
			If dbSeek(xFilial("CNA")+cContra+cRevisa+aPlanilha[nx][2])
				RecLock("CNA",.F.)
				CNA->CNA_CRONOG := cCron
				MsUnLock()
			EndIf
		Next
		
		If (__lSX8)
			ConfirmSX8()
		EndIf
		EvalTrigger()
		msUnlockAll()
		
		MsgInfo(STR0063)//"Cronograma encerrado com sucesso"
	EndIf
EndIf
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CSVLDFOR    ³ Autor ³ Marcelo Custodio      ³ Data ³16.01.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida linha atual do fornecedor                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Usado no valid do campo DA TABELA SX3                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Funcao alterada de CN100VldLFor para CDVLDFOR                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSVldLFor()
Local lRet := .T.

lRet := ExistCpo("SA2",ogetDad1:aCols[n,aScan(aHeader1,{|x| x[2] == "CNC_CODIGO"})]+M->CNC_LOJA)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CSFsVld     ³ Autor ³ Marcelo Custodio      ³ Data ³16.01.2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Valida quantidade do cronograma fisico                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jose Carlos |27/06/08³      ³Mudanca no nome da funcao (CN110FSVLD())     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSFsVld()
Local lRet     := .F.
Local nPosDist := aScan(aHeader,{|x| AllTrim(x[2])=="CNS_DISTSL"})
Local nPosQtd  := aScan(aHeader,{|x| AllTrim(x[2])=="CNS_PRVQTD"})
Local nPosSld  := aScan(aHeader,{|x| AllTrim(x[2])=="CNS_SLDQTD"})
Local nPosRlz  := aScan(aHeader,{|x| AllTrim(x[2])=="CNS_RLZQTD"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o valor informado < que o saldo - quantidade medida    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//lRet := (M->CNS_PRVQTD <= Round(((aCols[n,nPosDist]+aCols[n,nPosQtd])-aCols[n,nPosRlz]),TamSx3("CNS_PRVQTD")[2]))
lRet := (M->CNS_PRVQTD >= aCols[n,nPosRlz])

If lRet
	nTotFsc -= aCols[n,nPosQtd]*aItVl[n,1]
	nTotFsc += M->CNS_PRVQTD*aItVl[n,1]
	oTotFsc:Refresh()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Soma diferenca no saldo a distribuir   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If M->CNS_PRVQTD > aCols[n,nPosQtd]
		aCols[n,nPosDist] -= (M->CNS_PRVQTD-aCols[n,nPosQtd])
	Else
		aCols[n,nPosDist] += (aCols[n,nPosQtd]-M->CNS_PRVQTD)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza saldo a medir                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols[n,nPosSld] := M->CNS_PRVQTD-aCols[n,nPosRlz]

EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS400LdFsc  ³ Autor ³ Marcelo Custodio      ³ Data ³16.01.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Carrega o cronograma fisico                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aExp01 - Array contendo os itens do cronograma fisico        ³±±
±±³          ³ aExp02 - Array contento o cabecalho do cronograma fisico     ³±±
±±³          ³ aExp03 - Array contendo os valores e quantidades dos itens   ³±±
±±³          ³          do cronograma ficiso (planilha)                     ³±±
±±³          ³ cExp04 - Codigo do contrato                                  ³±±
±±³          ³ cExp05 - Codigo da revisao                                   ³±±
±±³          ³ cExp06 - Codigo do cronograma                                ³±±
±±³          ³ cExp07 - Codigo da planilha                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA110                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS410LdFsc(aColsParc,aHeadParc,aItVl,cContra,cRevisa,cCronog,cPlan)
Local cAliasCNS    := ""
Local cAliasCNB   := ""
Local cParc     := ""
Local nCont     := 0
Local cQuery    := ""
Local nX
Local aStrucCNS := CNS->(dbStruct())
Local aPrdPar   := {}
Local lReali    := .F.

dbSelectArea("CN9")
dbSetORder(1)
dbSeek(xFilial("CN9")+cContra+cRevisa)

If CN9->CN9_SITUAC == DEF_SREVS
	dbSelectArea("CN0")
	dbSetOrder(1)
	dbSeek(xFilial("CN0")+CN9->CN9_TIPREV)
	lReali  := (CN0->CN0_TIPO == DEF_REALI)
EndIf

cAliasCNB := GetNextAlias()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seleciona os itens da planilha         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT CNB.CNB_ITEM,CNB.CNB_VLUNIT,CNB.CNB_REALI,CNB.CNB_DESC,CNB.CNB_QUANT,CNB.CNB_PRODUT,CNB.CNB_DESCRI from "+ RetSQLName("CNB") +" CNB WHERE "
cQuery += "CNB.CNB_FILIAL = '"+xFilial("CNB")+"' AND "
cQuery += "CNB.CNB_CONTRA = '"+cContra+"' AND "
cQuery += "CNB.CNB_REVISA = '"+cRevisa+"' AND "
cQuery += "CNB.CNB_NUMERO = '"+cPlan+"' AND "
cQuery += "CNB.D_E_L_E_T_ = ' ' ORDER BY CNB.CNB_ITEM"
			
cQuery := ChangeQuery(cQuery)	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCNB,.F.,.T.)
	
TCSetField(cAliasCNB,"CNB_VLUNIT" ,"N",TamSX3("CNB_VLTOT")[1],TamSX3("CNB_VLTOT")[2])
TCSetField(cAliasCNB,"CNB_REALI"  ,"N",TamSX3("CNB_REALI")[1],TamSX3("CNB_REALI")[2])
TCSetField(cAliasCNB,"CNB_DESC"   ,"N",TamSX3("CNB_DESC")[1] ,TamSX3("CNB_DESC")[2])
TCSetField(cAliasCNB,"CNB_QUANT"  ,"N",TamSX3("CNB_QUANT")[1],TamSX3("CNB_QUANT")[2])
			
cAliasCNS := GetNextAlias()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seleciona os itens do cronograma fisico³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT CNS.* FROM "+RetSQLName("CNS")+" CNS WHERE "
cQuery += "CNS.CNS_FILIAL = '"+xFilial("CNS")+"' AND "
cQuery += "CNS.CNS_CONTRA = '"+cContra+"' AND "
cQuery += "CNS.CNS_REVISA = '"+cRevisa+"' AND "
cQuery += "CNS.CNS_CRONOG = '"+cCronog+"' AND "
cQuery += "CNS.D_E_L_E_T_ = ' ' ORDER BY CNS.CNS_PARCEL,CNS.CNS_ITEM"

cQuery := ChangeQuery(cQuery)	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCNS,.F.,.T.)			

For nx:=1 to len(aStrucCNS)
	if (cAliasCNS)->(FieldPos(aStrucCNS[nx,1])) > 0 .And. aStrucCNS[nx,2] <> "C"
		TCSetField( cAliasCNS, aStrucCNS[nx,1], aStrucCNS[nx,2], aStrucCNS[nx,3], aStrucCNS[nx,4] )
	endif
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Varre os itens do cronograma fisico    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
While !(cAliasCNS)->(Eof())
	nCont++

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verica se mudou a parcela              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If cParc != (cAliasCNS)->CNS_PARCEL
		aAdd(aColsParc,{})
		nCont := 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Retorna os itens da planilha           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		(cAliasCNB)->(dbGoTop())
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Armazena quantidade prevista no array aPrdPar, ³
	//³para calculo do saldo a distribuir             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aPrdPar) < nCont
		aAdd(aPrdPar,(cAliasCNS)->CNS_PRVQTD)
	Else
		aPrdPar[nCont] += (cAliasCNS)->CNS_PRVQTD
	EndIf

	aAdd(aColsParc[len(aColsParc)],Array(len(aHeadParc)+1))
	For nx:=1 to len(aHeadParc)
		If aHeadParc[nx,10] != "V"
			aColsParc[len(aColsParc),nCont,nx] := (cAliasCNS)->(FieldGet((cAliasCNS)->(FieldPos(aHeadParc[nx,2]))))
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona no item da planilha                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While !(cAliasCNB)->(Eof()) .AND. (cAliasCNB)->CNB_ITEM != (cAliasCNS)->CNS_ITEM
				(cAliasCNB)->(dbSkip())
			EndDo

			Do Case
				Case aHeadParc[nx,2] == "CNS_PRODUT"//Preenche o codigo do produto
					aColsParc[len(aColsParc),nCont,nx] := (cAliasCNB)->CNB_PRODUT
				Case aHeadParc[nx,2] == "CNS_DESCRI"//Preenche a descricao do produto
					aColsParc[len(aColsParc),nCont,nx] := (cAliasCNB)->CNB_DESCRI
				Case aHeadParc[nx,2] == "CNS_TOTQTD"//Preenche a quantidade total
					aColsParc[len(aColsParc),nCont,nx] := (cAliasCNB)->CNB_QUANT
			EndCase
		EndIf
	Next
	aColsParc[len(aColsParc),nCont,len(aHeadParc)+1] := .F.

	cParc := (cAliasCNS)->CNS_PARCEL
	(cAliasCNS)->(dbSkip())
EndDo

(cAliasCNS)->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna no topo dos itens da planilha          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
(cAliasCNB)->(dbGoTop())
nCont:=0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta array aItVl                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !(cAliasCNB)->(Eof())
	nCont++
	If len(aPrdPar) < nCont
		aAdd(aPrdPar,0)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona item com o valor do item, a quantidade total e ³
	//³o saldo a distribuir com base no aPrdPar                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lReali
		aAdd(aItVl,{(cAliasCNB)->CNB_VLUNIT-(((cAliasCNB)->CNB_VLUNIT*(cAliasCNB)->CNB_DESC)/100),(cAliasCNB)->CNB_QUANT,(cAliasCNB)->CNB_QUANT-aPrdPar[nCont]})
	Else
		aAdd(aItVl,{(cAliasCNB)->CNB_REALI-(((cAliasCNB)->CNB_REALI*(cAliasCNB)->CNB_DESC)/100),(cAliasCNB)->CNB_QUANT,(cAliasCNB)->CNB_QUANT-aPrdPar[nCont]})
	EndIf
	(cAliasCNB)->(dbSkip())
EndDo

(cAliasCNB)->(dbCloseArea())
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    |CS410VisFis ³ Autor ³ Marcelo Custodio      ³ Data ³16.01.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Exibe e permite carregar os valores previstos no cronograma  ³±±
±±³          ³ fisico no momento da medicao                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Codigo do contrato                                  ³±±
±±³          ³ cExp02 - Codigo da revisao                                   ³±±
±±³          ³ cExp03 - Codigo da planilha                                  ³±±
±±³          ³ cExp04 - Competencia                                         ³±±
±±³          ³ oExp04 - Objeto getdados da medicao                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA130                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CS410VisFis(cContra,cRevisa,cPlan,cCompet,oGet,lVisu)
Local oDlg
Local ogetFsc
Local lRet      := .F.
Local nx        := 0
Local nPosCNE   := 0
Local nPosCNS   := 0
Local cQuery    := ""
Local aStrucCNS := CNS->(dbStruct())
Local aHeadParc := {}
Local aColsParc := {}
Local cAlias    := ""
Local nOpca     //:= 1

DEFAULT lVisu := .F.

dbSelectArea("CNF")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta estrutura fisica              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CS410MtFsc(aHeadParc,.T.)

cAlias := GetNextAlias()
cQuery := "SELECT CNS.*,CNB.CNB_PRODUT,CNB.CNB_DESCRI,CNB.CNB_QUANT FROM "+RetSQLName("CNS")+" CNS, "+RetSQLName("CNA")+" CNA, "+RetSQLName("CNF")+" CNF , "+RetSQLName("CNB")+" CNB WHERE "
cQuery += "CNS.CNS_FILIAL = '"+xFilial("CNS")+"' AND "
cQuery += "CNA.CNA_FILIAL = '"+xFilial("CNA")+"' AND "
cQuery += "CNB.CNB_FILIAL = '"+xFilial("CNB")+"' AND "
cQuery += "CNF.CNF_FILIAL = '"+xFilial("CNF")+"' AND "
cQuery += "CNS.CNS_CONTRA = '"+cContra+"' AND "
cQuery += "CNS.CNS_CONTRA = CNA.CNA_CONTRA AND "
cQuery += "CNS.CNS_CONTRA = CNB.CNB_CONTRA AND "
cQuery += "CNS.CNS_CONTRA = CNF.CNF_CONTRA AND "
cQuery += "CNS.CNS_REVISA = '"+cRevisa+"' AND "
cQuery += "CNS.CNS_REVISA = CNA.CNA_REVISA AND "
cQuery += "CNS.CNS_REVISA = CNB.CNB_REVISA AND "
cQuery += "CNS.CNS_REVISA = CNF.CNF_REVISA AND "
cQuery += "CNA.CNA_NUMERO = '"+cPlan+"' AND "
cQuery += "CNS.CNS_CRONOG = CNA.CNA_CRONOG AND "
cQuery += "CNS.CNS_CRONOG = CNF.CNF_NUMERO AND "
cQuery += "CNF.CNF_COMPET = '"+cCompet+"' AND "
cQuery += "CNS.CNS_PARCEL = CNF.CNF_PARCEL AND "
cQuery += "CNS.CNS_ITEM   = CNB.CNB_ITEM AND "
cQuery += "CNA.CNA_NUMERO = CNB.CNB_NUMERO AND "
cQuery += "CNS.D_E_L_E_T_ = ' ' AND "
cQuery += "CNA.D_E_L_E_T_ = ' ' AND "
cQuery += "CNB.D_E_L_E_T_ = ' ' AND "
cQuery += "CNF.D_E_L_E_T_ = ' ' ORDER BY CNS.CNS_ITEM"

cQuery := ChangeQuery(cQuery)	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)			

For nx:=1 to len(aStrucCNS)
	if (cAlias)->(FieldPos(aStrucCNS[nx,1])) > 0 .And. aStrucCNS[nx,2] <> "C"
		TCSetField( cAlias, aStrucCNS[nx,1], aStrucCNS[nx,2], aStrucCNS[nx,3], aStrucCNS[nx,4] )
	endif
Next
TCSetField(cAlias,"CNB_QUANT"  ,"N",TamSX3("CNB_QUANT")[1],TamSX3("CNB_QUANT")[2])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenche os itens do cronograma fisico³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                                                          
While !(cAlias)->(Eof())
	aAdd(aColsParc,Array(len(aHeadParc)+1))

	For nx:=1 to len(aHeadParc)
		If aHeadParc[nx,10] != "V"
			aColsParc[len(aColsParc),nx] := (cAlias)->&(aHeadParc[nX,2])
		Else
			Do Case
				Case aHeadParc[nx,2] == "CNS_PRODUT"//Preenche o codigo do produto
					aColsParc[len(aColsParc),nx] := (cAlias)->CNB_PRODUT
				Case aHeadParc[nx,2] == "CNS_DESCRI"//Preenche a descricao do produto
					aColsParc[len(aColsParc),nx] := (cAlias)->CNB_DESCRI
				Case aHeadParc[nx,2] == "CNS_TOTQTD"//Preenche a quantidade total
					aColsParc[len(aColsParc),nx] := (cAlias)->CNB_QUANT
				OtherWise
					aColsParc[len(aColsParc),nx] := CriaVar(aHeadParc[nx,2])
			EndCase
		EndIf
	Next
	
	aColsParc[len(aColsParc),(len(aHeadParc)+1)] := .F.
	(cAlias)->(dbSkip())
EndDo

(cAlias)->(dbCloseArea())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta Dialog                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0072) FROM 009,000 TO 025,060 OF oMainWnd//"Cronograma Fisico"
 
@ 005, 005 SAY OemToAnsi(STR0081) PIXEL // "Cronograma Fisico"

ogetFsc := MsNewGetDados():New(013,005,100,232,0,,,,,,,,,,oDlg,aHeadParc,aColsParc)

DEFINE SBUTTON FROM 105, 203 TYPE 1 ACTION (oDlg:End()) ENABLE OF oDlg 

If !lVisu
	@ 105,172 BUTTON OemToAnsi(STR0079) SIZE 29 ,13  ACTION (nOpca:=1,oDlg:End()) OF oDlg PIXEL//"Carregar"
EndIf
@ 105,203 BUTTON OemToAnsi(STR0080) SIZE 29 ,13  ACTION (nOpca:=2,oDlg:End()) OF oDlg PIXEL//"Fechar"

ACTIVATE MSDIALOG oDlg CENTERED

If nOpca==1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza aCols da medicao           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols := oGet:aCols
	For nx:=1 to len(aColsParc)
		oGet:aCols[nx,aScan(oGet:aHeader,{|x| AllTrim(x[2])=="CNE_QUANT"})] := aColsParc[nx,aScan(aHeadParc,{|x| AllTrim(x[2]) == "CNS_SLDQTD"})]
		RunTrigger(2,nx,,,"CNE_QUANT ")
	Next
	oGet:aCols := aCols
	
	lRet := .T.
EndIf
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Fabio Alves Silva     ³ Data ³18/10/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenuDef()     
PRIVATE aRotina	:= { 	{ OemToAnsi(STR0002), "AxPesqui"  , 0, 1, 0, .F.},;//"Pesquisar"
								{ OemToAnsi(STR0003), "u_CS410Manut()", 0, 2, 0, nil},;//"Visualizar"
								{ OemToAnsi(STR0004), "u_CS410Manut()", 0, 3, 0, nil},;//"Incluir"
								{ OemToAnsi(STR0005), "u_CS410Manut()", 0, 4, 0, nil},;//"Alterar"
								{ OemToAnsi(STR0006), "u_CS410Manut()", 0, 5, 0, nil}} //"Excluir"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada utilizado para inserir novas opcoes no array aRotina  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CTA110MNU")
	ExecBlock("CTA110MNU",.F.,.F.)
EndIf
Return(aRotina)  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CS410VldDt³ Autor ³ Marcelo Custodio      ³ Data ³11/12/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida data prevista                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CS410VldDt()
Local lRet       := .T.
Local nPosDtPrv  := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_PRUMED"})
Local nPosDtVct  := 0
Local nPosCompet := 0
Local nTot       := len(oGetDados:aCols)
Local nAtual     := oGetDados:OBROWSE:NAT
Local dDtPrev    := &(Readvar())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se a previsao ultrapassa a proxima parcela se houver  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nAtual < nTot .And. oGetDados:aCols[nAtual+1,nPosDtPrv] <= dDtPrev
	lRet := .F.
Else
	nPosDtVct  := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_DTVENC"})
	nPosCompet := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_COMPET"})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza data de vencimento e competencia da parcela  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetDados:aCols[nAtual,nPosDtVct]  := dDtPrev
	oGetDados:aCols[nAtual,nPosCompet] := StrZero(Month(dDtPrev),2)+"/"+StrZero(Year(dDtPrev),4)
	oGetDados:oBrowse:Refresh()
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CS410WReal  ºAutor  ³Aline Catarina      º Data ³  03/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida a edicao do campo Valor Realizado e Data Realizado     º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Manutencao no Gestao de Contratos                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/            
User Function CS410WReal() 
    Local lRet	 := .T.  
    Local dDataB := dDataBase
	//Posicao do Campo Competencia
 	Local nPosCOMPET := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_COMPET"})   
    //Linha posicionada na GetDados
    Local nLinGet := oGetDados:nAt            
    //Conteudo do campo CNF_COMPET na GetDados
    Local dComp := CTOD("01/"+oGetDados:aCols[nLinGet][nPosCOMPET])
    
	If AllTrim(Upper(Funname())) = "CNTA110"
		If  ((Month(dComp) >= Month(dDataB)) .AND. (Year(dComp) == Year(dDataB))) .OR.;
			(Year(dComp) > Year(dDataB))
		    lRet := .F.		
	    EndIf 
	EndIf
Return lRet     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CS410AtuSl  ºAutor  ³Aline Catarina      º Data ³  03/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilha a data de realizacao do pagamento, de acordo com o    º±±
±±º          ³valor realizado                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Manutencao no Gestao de Contratos                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/            
User Function CS410AtuSl()
 	//Posicao do Campo Valor Previsto
 	Local nPosVLPREV  := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_VLPREV"})   
 	//Posicao do Campo Valor Realizado
 	Local nPosVLREAL := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_VLREAL"})   
 	//Posicao do Campo Data de Previsao da Medicao
 	Local nPosPRUMED := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_PRUMED"})   
 	//Posicao do Campo Data de Realizacao da Medicao
 	Local nPosDTREAL := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_DTREAL"})   
	//Linha posicionada na GetDados
    Local nLinGet := oGetDados:nAt 
    //Variavel utilizada para calcular o saldo
	Local nSaldo := 0
	
	If AllTrim(Upper(Funname())) = "CNTA110"                                                      
	   	nSaldo := (oGetDados:aCols[nLinGet][nPosVLPREV]) - (oGetDados:aCols[nLinGet][nPosVLREAL])	 
	   	If Empty((oGetDados:aCols[nLinGet][nPosDTREAL])) 
		   	(oGetDados:aCols[nLinGet][nPosDTREAL]) := (oGetDados:aCols[nLinGet][nPosPRUMED])
		ElseIf (oGetDados:aCols[nLinGet][nPosVLREAL] = 0) 
		   	(oGetDados:aCols[nLinGet][nPosDTREAL]) := cToD("")
		EndIf	   	
	EndIf                                
Return nSaldo     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CS410VLDRL  ºAutor  ³Aline Catarina      º Data ³  03/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validacao do valor realizado informado                        º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Manutencao no Gestao de Contratos                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/            
User Function CS410VLDRL()
	Local lRet := .T.   
 	//Posicao do Campo Valor Previsto
 	Local nPosVLPREV  := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_VLPREV"})   
	//Linha posicionada na GetDados
    Local nLinGet := oGetDados:nAt 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se realizado e maior que a previsao  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AllTrim(Upper(Funname())) = "CNTA110"
		If M->CNF_VLREAL > oGetDados:aCols[nLinGet,nPosVLPREV]
			lRet := .F.
			MsgAlert("Valor Realizado não pode ser maior que o previsto")
		EndIf
	EndIf
Return lRet              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CS410VDDTR  ºAutor  ³Aline Catarina      º Data ³  03/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validacao da data de realizacao informada                     º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Manutencao no Gestao de Contratos                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/            
User Function CS410VDDTR()
	Local lRet := .T.   
 	//Posicao do Campo Data Prevista da Medicao
 	Local nPosPRUMED  := aScan(oGetDados:aHeader,{ |x| UPPER(AllTrim(x[2])) == "CNF_PRUMED"})   
	//Linha posicionada na GetDados
    Local nLinGet := oGetDados:nAt 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se realizado e maior que a previsao  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AllTrim(Upper(Funname())) = "CNTA110"
		If M->CNF_DTREAL < oGetDados:aCols[nLinGet,nPosPRUMED]
			lRet := .F.
			MsgAlert("Data de Realização da Medição não pode ser menor que a prevista")
		EndIf
	EndIf
Return lRet   
