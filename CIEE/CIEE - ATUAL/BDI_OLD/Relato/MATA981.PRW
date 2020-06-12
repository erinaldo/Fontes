#INCLUDE "Mata981.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOLE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATA981  ³ Autor ³ Nereu Humberto Junior ³ Data ³23/10/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Programa de Geracao e Impressao de Carta de Correcao c/WORD ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function MATA981()

If !Pergunte("MTA981",.T.)
    Return
Endif

If !File(AllTrim(mv_par03)+AllTrim(mv_par02))
	Help(" ",1,"A9810001") //"Arquivo de Modelo nao encontrado !!"
	Return
Endif

PRIVATE cWord:= OLE_CreateLink()
PRIVATE cPath    := AllTrim(mv_par03)
PRIVATE cArquivo := cPath+Alltrim(mv_par02)

If (cWord < "0")
	Help(" ",1,"A9810004") //"MS-WORD nao encontrado nessa maquina !!"
	Return
Endif

OLE_SetProperty(cWord, oleWdVisible  ,.F. )

PRIVATE nTipoNF := mv_par01

PRIVATE aRotina := { { STR0001, "AxPesqui"  , 0 , 1},; //"Pesquisar"
	{ STR0002,   "AxVisual"  , 0 , 2},; //"Visualizar"
	{ STR0003,   "A981Impri" , 0 , 3},; //"Manual"
	{ STR0004,   "A981Impri" , 0 , 4}} //"Automatica"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes  ³                                    
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := OemToAnsi(STR0005) //"Carta de Correcao"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par01 == 01
	mBrowse( 6, 1,22,75,"SF2")
Else
	mBrowse( 6, 1,22,75,"SF1")
Endif	

OLE_CloseLink(cWord) //fecha o Link com o Word

Return Nil

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A981Impri ³ Autor ³ Nereu Humberto Junior ³ Data ³23/10/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de Geracao e Impressao de Carta de Correcao         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA181                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function A981Impri(cAlias,nReg,nOpcx)

Local aIrrCC   := {}
Local nRet     := 0
Local nAuxI    := 0
Local nI       := 0
Local cMunEmp  := IIF(!Empty(SM0->M0_CIDENT),AllTrim(SM0->M0_CIDENT),Space(20))
Local nDia     := Day(dDataBase)
Local cMes     := MesExtenso(Month(dDataBase))
Local nAno     := Year(dDataBase)
Local cNomeEmp := IIF(!Empty(SM0->M0_NOMECOM),AllTrim(SM0->M0_NOMECOM),Space(40))
Local cEndEmp  := IIF(!Empty(SM0->M0_ENDENT),AllTrim(SM0->M0_ENDENT),Space(30))
Local cEstEmp  := IIF(!Empty(SM0->M0_ESTENT),SM0->M0_ESTENT,Space(02))
Local cCNPJ    := TransForm(SM0->M0_CGC,"@R 99.999.999/9999-99")
Local cPropri  := Space(01)
Local cTercei  := Space(01)
Local cNota    := Space(06)
Local cSerie   := Space(03)
Local dDtNota  := CtoD(Space(08))
Local cNomeDest:= Space(40)
Local cEndDest := Space(40)
Local cMunDest := Space(15)
Local cEstDest := Space(02)

If nOpcx == 3 //Manual    

	cNota    := IIF(nTipoNF==01,SF2->F2_DOC,SF1->F1_DOC)    
	cSerie   := IIF(nTipoNF==01,SF2->F2_SERIE,SF1->F1_SERIE)    
	dDtNota  := IIF(nTipoNF==01,SF2->F2_EMISSAO,SF1->F1_EMISSAO)
	
	If nTipoNF == 1
	    If SF2->F2_TIPO $ "DB"
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
		Else	
		    dbSelectArea("SA1")
		    dbSetOrder(1)
		    MsSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
		Endif
		cNomeDest:= AllTrim(IIF(SF2->F2_TIPO$"DB",SA2->A2_NOME,SA1->A1_NOME))
		cEndDest := AllTrim(IIF(SF2->F2_TIPO$"DB",SA2->A2_END,SA1->A1_END))
		cMunDest := AllTrim(IIF(SF2->F2_TIPO$"DB",SA2->A2_MUN,SA1->A1_MUN))
		cEstDest := AllTrim(IIF(SF2->F2_TIPO$"DB",SA2->A2_EST,SA1->A1_EST))
		cPropri := "X"
	Else
		If SF1->F1_TIPO $ "DB"
			dbSelectArea("SA1")
			dbSetOrder(1)
			MsSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
		Else
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)	
		Endif	
		cNomeDest:= AllTrim(IIF(SF1->F1_TIPO$"DB",SA1->A1_NOME,SA2->A2_NOME))
		cEndDest := AllTrim(IIF(SF1->F1_TIPO$"DB",SA1->A1_END,SA2->A2_END))
		cMunDest := AllTrim(IIF(SF1->F1_TIPO$"DB",SA1->A1_MUN,SA2->A2_MUN))
		cEstDest := AllTrim(IIF(SF1->F1_TIPO$"DB",SA1->A1_EST,SA2->A2_EST))
		cPropri  := IIF(SF1->F1_FORMUL=="S","X",cPropri)
		cTercei  := IIF(SF1->F1_FORMUL=="S",cTercei,"X")
	Endif
Endif	

nRet:= A981TabIrr(@aIrrCC)

If nRet <> 0 
		
	If (cWord >= "0")
		OLE_CloseLink(cWord) //fecha o Link com o Word
		cWord:= OLE_CreateLink()
		OLE_NewFile( cWord,cArquivo)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Funcao que faz o Word aparecer na Area de Transferencia do Windows,     ³
		//³sendo que para habilitar/desabilitar e so colocar .T. ou .F.            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOpcx == 3 //Manual
			OLE_SetProperty(cWord, oleWdVisible  ,.T. )
			OLE_SetProperty(cWord, oleWdPrintBack,.T. )
		Else 
			OLE_SetProperty(cWord, oleWdVisible  ,.F. ) 
			OLE_SetProperty(cWord, oleWdPrintBack,.F. ) 
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ -Funcao que atualiza as variaveis do Word. - Cabecalho da Carta ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		OLE_SetDocumentVar(cWord, "c_MunEmp"  , cMunEmp  )
		OLE_SetDocumentVar(cWord, "n_Dia"     , nDia     )
		OLE_SetDocumentVar(cWord, "c_Mes"     , cMes     )
		OLE_SetDocumentVar(cWord, "n_Ano"     , nAno     )
		OLE_SetDocumentVar(cWord, "c_CNPJ"    , cCNPJ    )
		OLE_SetDocumentVar(cWord, "c_NomeEmp" , cNomeEmp )
		OLE_SetDocumentVar(cWord, "c_EndEmp"  , cEndEmp  )
		OLE_SetDocumentVar(cWord, "c_MunEmp"  , cMunEmp  )
		OLE_SetDocumentVar(cWord, "c_EstEmp"  , cEstEmp  )
   		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ -Funcao que atualiza as variaveis do Word. - Irregularidades/Retificacoes ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nI:= 1 To Len(aIrrCC)
			OLE_SetDocumentVar(cWord, "c_Irr"+StrZero(nI,2)  , aIrrCC[nI][1] )
			OLE_SetDocumentVar(cWord, "c_DesI"+StrZero(nI,2) , aIrrCC[nI][2] )
			If !Empty(aIrrCC[nI][3]) .And. nAuxI <= 5
				nAuxI ++
				OLE_SetDocumentVar(cWord, "c_Ret"+StrZero(nAuxI,2)  , aIrrCC[nI][1] )
				OLE_SetDocumentVar(cWord, "c_DesR"+StrZero(nAuxI,2) , aIrrCC[nI][3] )
			Endif
		Next
		If nAuxI < 5
			nAuxI := IIF(nAuxI==0,1,nAuxI+1)
			For nI:= nAuxI To 5
				OLE_SetDocumentVar(cWord, "c_Ret"+StrZero(nI,2)  , Space(02) )
				OLE_SetDocumentVar(cWord, "c_DesR"+StrZero(nI,2) , Space(80) )
	        Next
        Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ -Funcao que atualiza as variaveis do Word. - Dados Nota Fiscal  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If nOpcx == 3 //Manual
			OLE_SetDocumentVar(cWord, "c_Nota"    , cNota    )
			OLE_SetDocumentVar(cWord, "c_Serie"   , cSerie   )
			OLE_SetDocumentVar(cWord, "d_DtNota"  , dDtNota  )
			OLE_SetDocumentVar(cWord, "c_Propri"  , cPropri  )
			OLE_SetDocumentVar(cWord, "c_Tercei"  , cTercei  )
			OLE_SetDocumentVar(cWord, "c_NomeDest", cNomeDest)
			OLE_SetDocumentVar(cWord, "c_EndDest" , cEndDest )
			OLE_SetDocumentVar(cWord, "c_MunDest" , cMunDest )
			OLE_SetDocumentVar(cWord, "c_EstDest" , cEstDest )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³-Funcao que atualiza os campos da memoria para o Documento, utilizada logo apos a  ³
			//³funcao OLE_SetDocumentVar().														  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			OLE_UpdateFields(cWord)
		Else		
			A981Filtra(nTipoNF)
	    Endif
	Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A981TabIrr³ Autor ³Nereu Humberto Junior  ³ Data ³29/10/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Monta a tabela com as irregularidades a serem consideradas  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array com as irregularidades                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A981TabIrr(aIrrCC)
         
Local nOpcA  := 0
Local nMaxRet:= 0
Local cCodIrr:= "" 
Local cDesIrr:= ""
Local oDlg
Local oQual
Local oBmp
Local oBold 
Local cCadastro := STR0006 //"Tabela de Irregularidades"

dbSelectArea("SX5")
dbSetOrder(1)
MsSeek(xFilial("SX5")+"CC")

While !Eof() .And. SX5->X5_FILIAL == xFilial("SX5") .And. SX5->X5_TABELA == "CC" 
	AADD( aIrrCC,{AllTrim(SX5->X5_CHAVE),SX5->X5_DESCRI,Space(80)})
	dbSkip()
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem da janela de exibicao                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aIrrCC) > 0 
	
	DEFINE MSDIALOG oDlg TITLE CCADASTRO FROM 0,0 TO 290,550 OF oMainWnd	PIXEL 

	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
	
	@ 14, 10 TO 16 ,272 LABEL '' OF oDlg PIXEL
	@ 03, 10 SAY STR0007 FONT oBold PIXEL //"Digite as Retificações a serem consideradas : "
	
	@ 020,010 LISTBOX oQual VAR cVarQ ;
	FIELDS HEADER OemToAnsi(STR0008),OemToAnsi(STR0009), OemToAnsi(STR0010) ; //"Código"  "Especificação"   "Retificação"
	SIZE 260,100 ; 
	ON DBLCLICK (If(A981Ret(@aIrrCC,oQual:nAt,oQual,@nMaxRet),oQual:Refresh(),oDlg:End())) NOSCROLL PIXEL
		
	oQual:SetArray(aIrrCC)
	oQual:bLine := { || {aIrrCC[oQual:nAT,1],aIrrCC[oQual:nAT,2],aIrrCC[oQual:nAT,3]}}

	DEFINE SBUTTON FROM 127,210 TYPE 1 ACTION (nOpcA := oQual:nAt,oDlg:End()) ENABLE OF oDlg PIXEL

	DEFINE SBUTTON FROM 127,243 TYPE 2 ACTION (oDlg:End()) ENABLE OF oDlg		
	
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	Help(" ",1,"A9810003") //Tabela de Irregularidas nao encontrada
Endif


Return(nOpcA)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ A981Ret  ³ Autor ³Nereu Humberto Junior  ³ Data ³29.10.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Permite a digitacao das retificacoes das irregularidades    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array com as irregularidades                         ³±±
±±³          ³ExpN2: Item do Array                                        ³±±
±±³          ³ExpO3: Objeto                                               ³±±
±±³          ³ExpN4: Numero de Retificacoes Digitadas                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A981Ret(aIrrCC,nItem,oQual,nMaxRet)
                
Local aDim      := {} 
Local bValidRet := { || .T. } 
Local cRetifica := aIrrCC[nItem][3]
Local lValid    := .F. 
Local nCol      := 3 
Local nRow      := oQual:nAt
Local oOwner    := oQual:oWnd 
Local oDlg      
Local oGet1                      
Local oRect           
Local oBtn 

oRect := tRect():New(0,0,0,0)    // obtem as coordenadas da celula (lugar onde
oQual:GetCellRect(nCol,,oRect)    // a janela de edicao deve ficar)
aDim  := {oRect:nTop,oRect:nLeft,oRect:nBottom,oRect:nRight}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria uma janela invisivel para permitir a edicao do campo sobre o browse ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg OF oOwner  FROM 0, 0 TO 0, 0 STYLE nOR( WS_VISIBLE, WS_POPUP ) PIXEL

@ 0,0 MSGET oGet1 VAR cRetifica SIZE 0,0 OF oDlg FONT oOwner:oFont PIXEL HASBUTTON 
			
oGet1:Move(-2,-2, (aDim[ 4 ] - aDim[ 2 ]) + 4, aDim[ 3 ] - aDim[ 1 ] + 4 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Botao criado para receber o foco - nao retirar                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 BUTTON oBtn PROMPT "X" SIZE 0,0 OF oDlg
oBtn:bGotFocus := {|| oDlg:nLastKey := VK_RETURN, If( lValid := ( Eval( bValidRet, cRetifica ) ), oDlg:End(0), oGet1:SetFocus() ) }

ACTIVATE MSDIALOG oDlg ON INIT oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a listbox                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oQual:nAt := nRow
SetFocus(oQual:hWnd)
oQual:Refresh()
   
If !Empty(cRetifica) .And. Empty(aIrrCC[nItem][3])
	nMaxRet ++
	If nMaxRet > 5
		cRetifica := Space(80)
		nMaxRet --
        Help(" ",1,"A9810002") //"Permitido apenas 5 irregularidades !!!"
	Endif
ElseIf nMaxRet > 0 .And. Empty(cRetifica) .And. !Empty(aIrrCC[nItem][3])
	nMaxRet --
Endif

If lValid 
	aIrrCC[nItem][3] := cRetifica
EndIf 	

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A981Filtra³ Autor ³Nereu Humberto Junior  ³ Data ³29.10.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Permite a digitacao das retificacoes das irregularidades    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: Tipo de Nota Fiscal a ser Filtrada                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A981Filtra(nTipo)

Local cAliasQry := IIF(nTipo==1,"SF2","SF1")
Local aStruQry  := {}
Local cKey      := ""  
Local cPropri   := Space(01)
Local cTercei   := Space(01)
Local cNota     := Space(06)
Local cSerie    := Space(03)
Local dDtNota   := CtoD(Space(08))
Local cNomeDest := Space(40)
Local cEndDest  := Space(40)
Local cMunDest  := Space(15)
Local cEstDest  := Space(02)
#IFDEF TOP
	Local cQuery    := ""
	Local nX        := 0
#ENDIF
#IFNDEF TOP
	Local cCondicao := ""
#ENDIF	
If !Pergunte("MT981A",.T.)
    Return
Endif

If nTipo == 1
	dbSelectArea("SF2")
	dbSetOrder(1)
	aStruQry  := SF2->(dbStruct())
	cKey := SF2->(IndexKey())
Else
	dbSelectArea("SF1")
	dbSetOrder(1)
	aStruQry  := SF1->(dbStruct())
	cKey := SF1->(IndexKey())
Endif	

#IFDEF TOP
	cAliasQry := "A981Alias"
    If nTipo == 01
		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("SF2")+" "
		cQuery += "WHERE F2_FILIAL='"+xFilial("SF2")+"' AND "
		cQuery += "F2_DOC>='"+mv_par01+"' AND "
		cQuery += "F2_DOC<='"+mv_par02+"' AND "	
		cQuery += "F2_SERIE>='"+mv_par03+"' AND "
		cQuery += "F2_SERIE<='"+mv_par04+"' AND "	
		cQuery += "F2_CLIENTE>='"+mv_par05+"' AND "
		cQuery += "F2_CLIENTE<='"+mv_par06+"' AND "	
		cQuery += "F2_LOJA>='"+mv_par07+"' AND "
		cQuery += "F2_LOJA<='"+mv_par08+"' AND "	
		cQuery += "F2_EMISSAO>='"+Dtos(mv_par09)+"' AND "
		cQuery += "F2_EMISSAO<='"+Dtos(mv_par10)+"' AND "	
		cQuery += "D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY "+SqlOrder(SF2->(IndexKey()))
	Else
		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("SF1")+" "
		cQuery += "WHERE F1_FILIAL='"+xFilial("SF1")+"' AND "
		cQuery += "F1_DOC>='"+mv_par01+"' AND "
		cQuery += "F1_DOC<='"+mv_par02+"' AND "	
		cQuery += "F1_SERIE>='"+mv_par03+"' AND "
		cQuery += "F1_SERIE<='"+mv_par04+"' AND "	
		cQuery += "F1_FORNECE>='"+mv_par05+"' AND "
		cQuery += "F1_FORNECE<='"+mv_par06+"' AND "	
		cQuery += "F1_LOJA>='"+mv_par07+"' AND "
		cQuery += "F1_LOJA<='"+mv_par08+"' AND "	
		cQuery += "F1_EMISSAO>='"+Dtos(mv_par09)+"' AND "
		cQuery += "F1_EMISSAO<='"+Dtos(mv_par10)+"' AND "	
		cQuery += "D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY "+SqlOrder(SF1->(IndexKey()))
	Endif	

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)

	For nX := 1 To len(aStruQry)
		If aStruQry[nX][2] <> "C" .And. FieldPos(aStruQry[nX][1])<>0
			TcSetField(cAliasQry,aStruQry[nX][1],aStruQry[nX][2],aStruQry[nX][3],aStruQry[nX][4])
		EndIf
	Next nX
	dbSelectArea(cAliasQry)	
#ELSE 
    cIndex    := CriaTrab(NIL,.F.)
    If nTipo == 01
	    cCondicao := 'F2_FILIAL=="'+xFilial("SF2")+'".And.'
		cCondicao += 'F2_DOC>="'+mv_par01+'".And.F2_DOC<="'+mv_par02+'".And.'	   	
		cCondicao += 'F2_SERIE>="'+mv_par03+'".And.F2_SERIE<="'+mv_par04+'".And.'	   	
		cCondicao += 'F2_CLIENTE>="'+mv_par05+'".And.F2_CLIENTE<="'+mv_par06+'".And.'	   	
		cCondicao += 'F2_LOJA>="'+mv_par07+'".And.F2_LOJA<="'+mv_par08+'".And.'	   	
		cCondicao += 'DTOS(F2_EMISSAO)>="'+DTOS(mv_par09)+'".And.DTOS(F2_EMISSAO)<="'+DTOS(mv_par10)+'" '
    Else
        cCondicao := 'F1_FILIAL=="'+xFilial("SF1")+'".And.'
		cCondicao += 'F1_DOC>="'+mv_par01+'".And.F1_DOC<="'+mv_par02+'".And.'	   	
		cCondicao += 'F1_SERIE>="'+mv_par03+'".And.F1_SERIE<="'+mv_par04+'".And.'	   	
		cCondicao += 'F1_FORNECE>="'+mv_par05+'".And.F1_FORNECE<="'+mv_par06+'".And.'	   	
		cCondicao += 'F1_LOJA>="'+mv_par07+'".And.F1_LOJA<="'+mv_par08+'".And.'	   	
		cCondicao += 'DTOS(F1_EMISSAO)>="'+DTOS(mv_par09)+'".And.DTOS(F1_EMISSAO)<="'+DTOS(mv_par10)+'" '
    Endif
	
	IndRegua(cAliasQry,cIndex,cKey,,cCondicao)
	
	nIndex := IIF(nTipo==1,RetIndex("SF2"),RetIndex("SF1"))
	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF
    dbSetOrder(nIndex+1)

    dbSelectArea(cAliasQry)
    ProcRegua(LastRec())
    dbGoTop()
#ENDIF

dbSelectArea(cAliasQry)

While !Eof()
	
	IncProc()
	
	cNota    := IIF(nTipo==01,(cAliasQry)->F2_DOC,(cAliasQry)->F1_DOC)    
	cSerie   := IIF(nTipo==01,(cAliasQry)->F2_SERIE,(cAliasQry)->F1_SERIE)    
	dDtNota  := IIF(nTipo==01,(cAliasQry)->F2_EMISSAO,(cAliasQry)->F1_EMISSAO)
	
	If nTipo == 1
	    If (cAliasQry)->F2_TIPO $ "DB"
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+(cAliasQry)->F2_CLIENTE+(cAliasQry)->F2_LOJA)
		Else	
		    dbSelectArea("SA1")
		    dbSetOrder(1)
		    MsSeek(xFilial("SA1")+(cAliasQry)->F2_CLIENTE+(cAliasQry)->F2_LOJA)
		Endif
		cNomeDest:= AllTrim(IIF((cAliasQry)->F2_TIPO$"DB",SA2->A2_NOME,SA1->A1_NOME))
		cEndDest := AllTrim(IIF((cAliasQry)->F2_TIPO$"DB",SA2->A2_END,SA1->A1_END))
		cMunDest := AllTrim(IIF((cAliasQry)->F2_TIPO$"DB",SA2->A2_MUN,SA1->A1_MUN))
		cEstDest := AllTrim(IIF((cAliasQry)->F2_TIPO$"DB",SA2->A2_EST,SA1->A1_EST))
		cPropri := "X"
	Else
		If (cAliasQry)->F1_TIPO $ "DB"
			dbSelectArea("SA1")
			dbSetOrder(1)
			MsSeek(xFilial("SA1")+(cAliasQry)->F1_FORNECE+(cAliasQry)->F1_LOJA)
		Else
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(xFilial("SA2")+(cAliasQry)->F1_FORNECE+(cAliasQry)->F1_LOJA)	
		Endif	
		cNomeDest:= AllTrim(IIF((cAliasQry)->F1_TIPO$"DB",SA1->A1_NOME,SA2->A2_NOME))
		cEndDest := AllTrim(IIF((cAliasQry)->F1_TIPO$"DB",SA1->A1_END,SA2->A2_END))
		cMunDest := AllTrim(IIF((cAliasQry)->F1_TIPO$"DB",SA1->A1_MUN,SA2->A2_MUN))
		cEstDest := AllTrim(IIF((cAliasQry)->F1_TIPO$"DB",SA1->A1_EST,SA2->A2_EST))
		cPropri  := IIF((cAliasQry)->F1_FORMUL=="S","X",cPropri)
		cTercei  := IIF((cAliasQry)->F1_FORMUL=="S",cTercei,"X")
	Endif
	OLE_SetDocumentVar(cWord, "c_Nota"    , cNota    )
	OLE_SetDocumentVar(cWord, "c_Serie"   , cSerie   )
	OLE_SetDocumentVar(cWord, "d_DtNota"  , dDtNota  )
	OLE_SetDocumentVar(cWord, "c_Propri"  , cPropri  )
	OLE_SetDocumentVar(cWord, "c_Tercei"  , cTercei  )
	OLE_SetDocumentVar(cWord, "c_NomeDest", cNomeDest)
	OLE_SetDocumentVar(cWord, "c_EndDest" , cEndDest )
	OLE_SetDocumentVar(cWord, "c_MunDest" , cMunDest )
	OLE_SetDocumentVar(cWord, "c_EstDest" , cEstDest )

	OLE_UpdateFields(cWord)      
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³-Funcao que imprime o Documento corrente podendo ser especificado o numero de copias,  ³
	//³podedo tambem imprimir com um intervalo especificado nos parametros "nPagInicial" ate  ³
	//³"nPagFinal" retirando o parametro "ALL".												  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	OLE_PrintFile(cWord,"ALL",,,)
	
	dbSelectArea(cAliasQry)
	dbSkip()
EndDo
		
#IFDEF TOP
	dbSelectArea(cAliasQry)
	dbCloseArea()
#Else
  	If nTipo == 1
  		dbSelectArea("SF2")
		dbClearFilter()
		RetIndex("SF2")
	Else
  		dbSelectArea("SF1")
		dbClearFilter()
		RetIndex("SF1")
	Endif
	Ferase(cIndex+OrdBagExt())
	dbSetOrder(1)
	dbGoTop()
	MsSeek(xFilial())
#EndIf

Return