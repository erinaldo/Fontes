#INCLUDE "CNTA120.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"

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

//Transacoes
#DEFINE DEF_TRAINC "021"//Inclusao de Medicoes
#DEFINE DEF_TRAEDT "022"//Edicao de Medicoes
#DEFINE DEF_TRAEXC "023"//Exclusao de Medicoes
#DEFINE DEF_TRAENC "024"//Encerramento de Medicoes
#DEFINE DEF_TRAEST "025"//Estorno de Medicoes

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CSUA420  ³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Manutencao de Medicoes                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CSUA420()                                                  ³±±
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
User Function CSUA420(xAutoCab,xAutoItens,nOpcAuto,cRotina) 

Local aCores :=  {	{ "Empty(CND->CND_DTFIM)", "BR_VERMELHO"	},;     //"Em aberto"	
   				    	{ "!Empty(CND->CND_DTFIM)", "BR_VERDE"	   }}	    //"Encerrada"

Local cRoda   := ""
Local nx
Local nLinPos
Local nScan   := 0

Local xRet    := NIL

Private lAuto := (valType(xAutoCab) == "A" .And. valType(xAutoItens) == "A")
Private aAutoCab  := xAutoCab
Private aAutoItens:= xAutoItens
Private cCadastro := STR0001//"Manutenção das Medições" 
Private cPlani
Private aRotina := MenuDef()


CS420AjSX7()
CS420AjSXB()
CS420AjSX3()

If !lAuto
	
	If ValType( cRotina ) == "C"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz tratamento para chamada por outra rotina             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty( nScan := AScan( aRotina, { |x| Upper( x[2] ) == Upper( cRotina ) .And. x[4] == nOpcAuto } ) )
			cRoda := cRotina + "( 'CND', CND->( Recno() ), " + Str(nScan,2) + ")"
			xRet  := Eval( { || &( cRoda ) } )
		EndIf
	Else
		mBrowse(6,1,22,75,"CND",,,,,,aCores)
	EndIf
	
Else
	For nx:=1 to len(aAutoItens)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica campo LINPOS dos itens da rotina automatica ³
		//³pois a inclusao de medicao implica em alterar o acols³
		//³gerado com base na estrutura da planilha             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nLinPos:=aScan(aAutoItens[nx],{|x| AllTrim(x[1])=="LINPOS"}))>0
			aAutoItens[nx,nLinPos,3] := aAutoItens[nx,aScan(aAutoItens[nx],{|x| AllTrim(x[1])=="CNE_ITEM"}),2]
		Else
			aadd(aAutoItens[nx],{"LINPOS","CNE_ITEM",aAutoItens[nx,aScan(aAutoItens[nx],{|x| AllTrim(x[1])=="CNE_ITEM"}),2]})
		EndIf
	Next
	DEFAULT nOpcAuto := 3
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa rotina automatica               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MBrowseAuto(nOpcAuto,Aclone(aAutoCab),"CND")
EndIf

Return( xRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420Manut³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica situacao da medicao antes de alterar/excluir      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS420Manut(cExp01,nExp02,nExp03)                           ³±±
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
User Function CS420Manut(cAlias,nReg,nOpc)
Local lContinua := .T.
Local aValidGet := {}
Local nPosNum

If lAuto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o numero da medicao foi fornecido      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (nPosNum:=aScan(aAutoCab,{|x| x[1]=="CND_NUMMED"})) > 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida numero da medicao                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AADD(aValidGet,{"cNumMed" ,aAutoCab[nPosNum,2],"CS420NumAuto(cNumMed,.F.)",.T.})
		
		If (lContinua := MsVldGAuto(aValidGet))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona na medicao                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("CND")
			dbSetOrder(4)
			dbSeek(xFilial("CND")+aAutoCab[nPosNum,2])
			nReg:=CND->(RECNO())
		EndIf
	else
		lContinua:=.F.
	EndIf
EndIf

dbSelectArea("CND")
dbSetOrder(1)
dbGoTo(nReg)

If lContinua
	lContinua := CN240VldUsr(CND->CND_CONTRA,If(aRotina[nOpc,4]==4,DEF_TRAEDT,DEF_TRAEXC),.T.)
EndIf

If lContinua
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona valor previsao a estrutura da planilha    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(CND->CND_DTFIM)
		u_CS430Manut(cAlias,nReg,nOpc,,CND->CND_CONTRA,CND->CND_REVISA)
	Else
		Help( " ", 1, "CNTA120_03" )//"Medição ja encerrada"
	EndIf
EndIf

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420Leg    ³ Autor ³ Fabio Alves Silva     ³ Data ³26.12.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina de legenda da Medicao                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS420Legenda(nExp01,nExp02)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CNTA120                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS420Leg()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com as cores que representam a situacao de cada Medicao na mBrowse.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aLegenda := {	{"BR_VERMELHO", OemtoAnsi(STR0040)	},; // Em aberto
						   {"BR_VERDE"   , OemtoAnsi(STR0041)	}} // Encerrada
					
BrwLegenda(cCadastro, OemtoAnsi(STR0042), aLegenda)//"Legendas"

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420Inc  ³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Inclui Medicao - Exibe tela para selecao de contrato,      ³±±
±±³          ³ competencia e planilha                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CNTA120Inc(cExp01,nExp02,nExp03)                           ³±±
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
User Function CS420Inc(cAlias,nReg,nOpc)
Local oDlg
Local oGet01
Local aCampos  := {}
Local aStruCNA := CNA->(dbStruct())
Local cArqCNA  := ""
Local oOk  := LoadBitmap( GetResources(), "LBTIK" )
Local oNo  := LoadBitmap( GetResources(), "LBNO" )
Local nOpca:=0
Local lRet:=.T.
Local aValidGet := {}
Local nPos
Local lFisico := .F.
Local aRet    := {}
Local aNewFld :=  {}
Local aCS420cpo := {}
Local nx      := 0
Local aTitle  := { "",RetTitle("CNA_NUMERO"),RetTitle("CNA_DTINI"),RetTitle("CNA_VLTOT"),RetTitle("CNA_DTFIM"),RetTitle("CNA_FORNEC"),RetTitle("CNA_LJFORN"),RetTitle("CNA_CRONOG"),RetTitle("CNF_VLPREV")}
Local cLine   := ""

Private cNumMed
Private oBrowse
Private oCbx
Private cContra := Space(TamSX3("CN9_NUMERO")[1])
Private cRevisa := Space(TamSX3("CN9_REVISA")[1])
Private cCompet := Space(TamSX3("CNF_COMPET")[1])
Private lMedeve := .F.//medicao Eventual
Private lFixo   := .T.//Contrato Fixo     
Private cPlan
Private oBtOk
Private oBtCan
Private oTxt
Private bContVar := {||(cPlan:=CS420PLAN("CNA",0,3,/*xFiller*/,/*lReali*/,/*lReadq*/,/*aPlani*/,/*aPlIt*/,CN9->CN9_NUMERO,@cPlani,/*dInicio*/,/*dTermino*/),if(!Empty(cPlan),(oDlg:End(),nOpca:=1),)) }
Private bContFix := {||(if(Empty(cPlan),Help( " ", 1, "CNTA120_01" ),(oDlg:End(),nOpca:=1))) }

If !lAuto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona valor previsao a estrutura da planilha    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(aStruCNA,{"CNF_VLPREV","N",TamSX3("CNF_VLPREV")[1],TamSX3("CNF_VLPREV")[2]})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria arquivo temporario                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqCNA := CriaTrab(aStruCNA)
	dbUseArea(.T.,,cArqCNA,"TRBCNA",.F.,.F.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Configura campos exibidos na inclusao de medicoes  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos := {"",TRBCNA->CNA_NUMERO,TRBCNA->CNA_DTINI,TRBCNA->CNA_VLTOT,TRBCNA->CNA_DTFIM,TRBCNA->CNA_FORNEC,TRBCNA->CNA_LJFORN,TRBCNA->CNA_CRONOG,TRBCNA->CNF_VLPREV}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria Dialog para selecao de planilha               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg TITLE cCadastro From 74,7 TO 400,606 PIXEL
	
	@ 10,04   SAY OemToansi(RetTitle("CN9_NUMERO")) SIZE 73, 8 OF oDlg PIXEL
	@ 09,37   MSGET oGet01 VAR cContra PICTURE PesqPict("CN9","CN9_NUMERO") F3 "CN9001" SIZE 60,9 VALID CS420VlCon() OF oDlg PIXEL
	
	@ 10,104  SAY OemToansi(RetTitle("CNF_COMPET")) SIZE 73, 8 OF oDlg PIXEL
	@ 09,137 ComboBox oCbx Var cCompet ON CHANGE CS420Compet() SIZE 50,9 OF oDlg PIXEL
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Configura cLine de acordo com array aNewFld   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLine := "{If((cPlan==TRBCNA->CNA_NUMERO),oOk,oNo),TRBCNA->CNA_NUMERO,TRBCNA->CNA_DTINI,Transform(TRBCNA->CNA_VLTOT,PesqPict('CNA','CNA_VLTOT')),TRBCNA->CNA_DTFIM,TRBCNA->CNA_FORNEC,TRBCNA->CNA_LJFORN,TRBCNA->CNA_CRONOG,Transform(TRBCNA->CNF_VLPREV,PesqPict('CNF','CNF_VLPREV')),"
	
	If ExistBlock("CS420CPO")
		aCS420cpo := ExecBlock("CS420CPO",.F.,.F.)
		If ValType(aCS420cpo) == "A"
			aNewFld := aCS420cpo
		EndIf
	EndIf
	
	If len(aNewFld) > 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Varre os campos especificos ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nx:=1 to len(aNewFld)
			dbSelectArea("SX3")
			dbSetOrder(2)
			
			If dbSeek(aNewFld[nx])//Pesquisa estrutura do campo
				Do case
					Case SX3->X3_TIPO == "N"//Monta cLine para campos numericos
						cLine += "Transform(TRBCNA->"+aNewFld[nx]+",PesqPict('CNA','"+aNewFld[nx]+"')),"
					Otherwise
						cLine += "TRBCNA->"+aNewFld[nx]+","
				EndCase
				
				aAdd(aTitle,RetTitle(aNewFld[nx]))
				aAdd(aCampos,TRBCNA->(&(aNewFld[nx])))
			EndIf
		Next
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Finaliza construcao do cLine ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cLine := substr(cLine,1,len(cLine)-1)+"}"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Configura browse    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBrowse := TWBrowse():New( 30, 4,__DlgWidth(oDlg)-8,__DlgHeight(oDlg)-58, {|| {aCampos} },aTitle,{030,090},oDlg,,,,,,,,,,,,,"TRBCNA", .T. )
	oBrowse:bLine := &( "{ || " + cLine + " }" )
	oBrowse:bLDblClick := {|| If(!Empty(TRBCNA->CNA_NUMERO),(cPlan := TRBCNA->CNA_NUMERO, oBrowse:Refresh()),) }
	
	@ 30, 04 SAY oTxt PROMPT "Este contrato é do tipo variável, tecle OK para prosseguir e criar uma nova planilha para está medição." SIZE 300, 20 of oDlg PIXEL
	
	oTxt:lWordWrap := .T.
	oTxt:lActive  := .F.
	oTxt:lVisible  := .F.
	oTxt:Refresh()
	
	DEFINE SBUTTON oBtOK  FROM 150, 240 When .T. TYPE 1 ACTION (if(Empty(cPlan),Help( " ", 1, "CNTA120_01" ),(oDlg:End(),nOpca:=1))) ENABLE OF oDlg//"Selecione uma planilha"
	DEFINE SBUTTON oBtCan FROM 150, 270 When .T. TYPE 2 ACTION (oDlg:End(),nOpca:=2 ,if(CN9->CN9_CTRT = '2',,)) ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Apaga arquivo temporario                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TRBCNA->(dbCloseArea())
	FErase(cArqCNA + ".DBF")
	FErase(cArqCNA + OrdBagExt() )
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o cabecalho contem os campos CND_CONTRA,³
	//³CND_REVISA,CND_COMPET,CND_NUMERO essenciais para a  ³
	//³criacao da medicao                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (nPos := aScan(aAutoCab,{|x| x[1]=="CND_CONTRA"})) > 0
		cContra := aAutoCab[nPos,2]
	Else
		lRet := .F.
	EndIf
	If lRet .And. ((nPos := aScan(aAutoCab,{|x| x[1]=="CND_REVISA"})) > 0)
		cRevisa := aAutoCab[nPos,2]
	Else
		lRet := .F.
	EndIf
	If lRet .And. ((nPos := aScan(aAutoCab,{|x| x[1]=="CND_COMPET"})) > 0)
		cCompet := aAutoCab[nPos,2]
	Else
		lRet := .F.
	EndIf
	If lRet .And. ((nPos := aScan(aAutoCab,{|x| x[1]=="CND_NUMERO"})) > 0)
		cPlan   := aAutoCab[nPos,2]
	Else
		lRet := .F.
	EndIf
	
	If lRet
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida os campos do cabecalho da medicao            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AADD(aValidGet,{"cContra" ,aAutoCab[aScan(aAutoCab,{|x| x[1]=="CND_CONTRA"}),2],"CheckSX3('CND_CONTRA',cContra)",.T.})
		AADD(aValidGet,{"cRevisa" ,aAutoCab[aScan(aAutoCab,{|x| x[1]=="CND_REVISA"}),2],"CheckSX3('CND_REVISA',cRevisa) .And. CS420CtrAuto(cContra,cRevisa)",.T.})
		AADD(aValidGet,{"cPlan"   ,aAutoCab[aScan(aAutoCab,{|x| x[1]=="CND_NUMERO"}),2],"CheckSX3('CND_NUMERO',cPlan)",.T.})
		AADD(aValidGet,{"cCompet" ,aAutoCab[aScan(aAutoCab,{|x| x[1]=="CND_COMPET"}),2],"CheckSX3('CND_COMPET',cCompet) .And. CS420VldCpt()",.T.})
		
		If (nPosNum := aScan(aAutoCab,{|x| x[1]=="CND_NUMMED"})) > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Valida campo CND_NUMMED quando fornecido atraves    ³
			//³da rotina automatica                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cNumMed := aAutoCab[nPosNum,2]
			AADD(aValidGet,{"cNumMed" ,aAutoCab[nPosNum,2],"CS420NumAuto(cNumMed,.T.)",.T.})
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³PE para permitir alterar a validacao da rotina automatica ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("CS420AutVl")
			aRet := ExecBlock("CS420AutVl",.F.,.F.,{aValidGet})
			
			If valtype(aRet) == "A"
				aValidGet := aRet
			EndIf
		EndIf
		
		lRet := MsVldGAuto(aValidGet)
	EndIf
EndIf

If nOpca == 1 .OR. (lAuto .And. lRet)
	dbSelectArea("CN9")
	dbSetOrder(1)
	dbSeek(xFilial("CN9")+cContra+cRevisa)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o contrato possui cronograma fisico     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lFisico := ((CN1->(FieldPos("CN1_CROFIS")) > 0) .And. Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_CROFIS") == "1")

	//Rotina de manutencao de medicoes
	If u_CS430Manut(cAlias,nReg,nOpc,,cContra,cRevisa,cCompet,cPlan,lMedeve,lFisico,lFixo)
		If (__lSX8)
			ConfirmSX8()
		EndIf
		EvalTrigger()
		msUnlockAll()
	else
		C120ESTPLA()
	EndIf
Else
	If (__lSX8)
		RollBackSX8()
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420NumAuto³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida numero da medicao na execucao da rotina automatica    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS420NumAuto(cExp01,lExp02)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Numero da Medicao                                   ³±±
±±³          ³ lExp02 - Indica se e inclusao                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS420NumAuto(cNumMed,lInc)
Local lRet
Local aArea := GetArea()

dbSelectArea("CND")
dbSetOrder(4)
dbSeek(xFilial("CND")+cNumMed)

lRet := If(lInc,!(Found()),Found())

RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420CtrAuto³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida contrato+revisao durante a execucao da rotina         ³±±
±±³          ³ automatica                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS420CtrAuto(cExp01,cExp02)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Codigo do Contrato                                  ³±±
±±³          ³ cExp02 - Codigo da revisao                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS420CtrAuto(cContra,cRevisa)
Local lRet := .T.

dbSelectArea("CN9")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no contrato                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRet := dbSeek(xFilial("CN9")+cContra+cRevisa)

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica a situacao do contrato                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet := (CN9->CN9_SITUAC == DEF_SVIGE)
	
	If lRet
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica o acesso do usuario                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRet := CN240VldUsr(cContra,DEF_TRAINC,.T.)
	EndIf
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420VlCon³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida contrato e preenche competencias                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS420VlCon()                                               ³±±
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
Static Function CS420VlCon()
Local cFilCod
Local nMes
Local nAno
Local nMesF
Local nAnoF
Local aCompets := {	}
Local lRet    := .T.
Local lTaskForce := SupergetMv("ES_TASKFOR",,.T.)
lRet := ExistCpo("CN9", cContra ) .And. CN240VldUsr(cContra,DEF_TRAINC,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona na revisao atual do contrato            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(CN9->CN9_REVATU)
	lRet := CN9->( dbSeek( xFilial("CN9")+cContra+CN9->CN9_REVATU ) )
EndIf

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se o contrato esta em vigencia              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AllTrim(CN9->CN9_SITUAC) != DEF_SVIGE
		lRet := .F.
		Help( " ", 1, "CNTA120_02" )//"Apenas contratos em vigência podem ser medidos"
	ElseIf CN9->CN9_DTINIC > dDataBase .Or. CN9->CN9_DTFIM < dDataBase
		lRet := .F.
		Help( " ", 1, "CNTA120_07" )//Contrato fora do periodo de vigencia
	Else
		cPlan := ""
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Limpa arquivo temporario                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("TRBCNA")
		If RecCount() > 0
			Zap
			oBrowse:Refresh()
		Endif
		
		cRevisa := if((!Empty(CN9->CN9_REVATU) .And. CN9->CN9_SITUAC != DEF_SVIGE),CN9->CN9_REVATU,CN9->CN9_REVISA)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica Medicao eventual                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CN1")
		dbSetOrder(1)
		If dbSeek(xFilial("CN1")+CN9->CN9_TPCTO)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica Medicao eventual                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 			lMedeve := (CN1->CN1_MEDEVE == "1")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica Contrato Fixo            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			If (CN1->(FieldPos("CN1_CTRFIX")) > 0)
				lFixo := Empty(CN1->CN1_CTRFIX) .Or. CN1->CN1_CTRFIX = "1"
			EndIf	
		EndIf
		
		lFixo := CN9->CN9_CTRT = '1' // Contrato do tipo fixo CSU
		
		if lTaskForce
			nMes := Month(CN9->CN9_DTCAD)
			nAno := Year(CN9->CN9_DTCAD)
		else
			nMes := Month(CN9->CN9_DTINIC)
			nAno := Year(CN9->CN9_DTINIC)
		endif
		nMesF:= Month(CN9->CN9_DTFIM)
		nAnoF:= Year(CN9->CN9_DTFIM)
		
		If !lMedeve .And. lFixo
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Quando o contrato nao tiver medicao eventual       ³
			//³seleciona competencias de acordo com os cronogramas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("CNF")
			cFilCod := xFilial("CNF")
			dbSetOrder(2)
			dbSeek(cFilCod+cContra+cRevisa)
			while CNF->CNF_FILIAL = cFilCod .And. CNF->CNF_CONTRA = cContra .And. CNF->CNF_REVISA = cRevisa
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Exclui parcelas pagas e verifica competencia       ³
				//³contra database                                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				if CNF->CNF_SALDO>0 .And. (nAno < Val(Subs(CNF->CNF_COMPET,4,4)) .OR. (nAno = Val(Subs(CNF->CNF_COMPET,4,4)) .And. nMes <= Val(Subs(CNF->CNF_COMPET,1,2)))) .And. aScan(aCompets,CNF->CNF_COMPET) == 0
					aAdd(aCompets,CNF->CNF_COMPET)
				EndIf
				dbSkip()
			EndDo
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Quando o contrato tiver medicao eventual seleciona ³
			//³competencias de acordo com a vigencia do mesmo     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While nMes <= nMesF .Or. nAno < nAnoF
				If nMes > 12
					nMes := 1
					nAno++
				EndIf
				aAdd(aCompets,strzero(nMes,2)+"/"+str(nAno,4))
				nMes++
			EndDo
		EndIf
		//Ordena por data
		oCbx:aItems := ASort(aCompets,,,{|x,y|  CTOD("01/"+x) < CTOD("01/"+y)  })
	EndIf
EndIf

If lRet
	if CN9->CN9_CTRT = '2' // Contrato Variavel não tem planilha
		
		oBrowse:lActive  := .F.
		oBrowse:lVisible  := .F.
		oBrowse:Refresh()
		oBtOk:bAction := bContVar
		
		oTxt:lActive  := .T.
		oTxt:lVisible  := .T.
		oTxt:Refresh()
		
	else
		
		oTxt:lActive  := .F.
		oTxt:lVisible  := .F.
		oTxt:Refresh()
		
		oBrowse:lActive  := .T.
		oBrowse:lVisible  := .T.
		oBrowse:Refresh()
		oBtOk:bAction := bContFix
		
		CS420Compet() // Montar a Lista de Planilhas
		
	endif
	
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420Compet³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida Competencia e carrega planilhas de acordo com a      ³±±
±±³          ³ competencia selecionada                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS420Compet()                                               ³±±
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
Static Function CS420Compet()
Local lRet := .T.
Local cQuery := ""

cPlan := ""

CursorWait()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtra contrato                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CN9")
dbSetOrder(1)
dbSeek(xFilial("CN9")+cContra+cRevisa)

If !lMedeve
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Filtra planilhas de acordo com os cronogramas      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "Select CNA.CNA_NUMERO,CNA.CNA_DTINI,CNA.CNA_VLTOT,CNA.CNA_DTFIM,CNA.CNA_FORNEC,CNA.CNA_LJFORN,CNA.CNA_CRONOG,(CNF.CNF_SALDO) as CNF_VLPREV"
	cQuery += "from " + RetSQLName("CNA") + " CNA ," + RetSQLName("CNF") + " CNF ," + RetSQLName("CN9") + " CN9 "
	cQuery += "where CNA.CNA_FILIAL = '"+ xFilial("CNA") +"' AND CNF.CNF_FILIAL = '"+ xFilial("CNF") +"' AND "
	cQuery += "CN9.CN9_FILIAL = '"+ xFilial("CN9") +"' AND CNA.CNA_CONTRA = CNF.CNF_CONTRA AND CNA.CNA_REVISA = CNF.CNF_REVISA AND "
	cQuery += "CNF.CNF_NUMERO = CNA.CNA_CRONOG AND CNF.CNF_COMPET = '"+ cCompet +"' AND "
	cQuery += "CNA.CNA_CONTRA = CN9.CN9_NUMERO and CNA.CNA_REVISA = CN9.CN9_REVISA AND "
	cQuery += "CNA.CNA_CONTRA = '" + cContra + "' and "
	cQuery += "CNA.CNA_REVISA = '" + cRevisa + "' and "
	cQuery += "CNF.CNF_SALDO > 0 and "//Filtra parcelas nao medidas
	cQuery += "(select count(*) from " + RetSQLName("CND") + " CND where CND.CND_FILIAL = '"+ xFilial("CND") +"' AND CND.CND_CONTRA =  '"+ cContra +"' and "
	cQuery += "CND.CND_REVISA = '"+ cRevisa +"' and CND.CND_NUMERO = CNA.CNA_NUMERO and CND.CND_DTFIM = '' and CND.D_E_L_E_T_ = '') = 0 and "//Filtra planilhas sem medicoes em aberto
	cQuery += "CNA.D_E_L_E_T_ = '' and CNF.D_E_L_E_T_ = '' and CN9.D_E_L_E_T_ = ''"
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Filtra planilhas                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "select CNA.CNA_NUMERO,CNA.CNA_DTINI,CNA.CNA_VLTOT,CNA.CNA_DTFIM,CNA.CNA_FORNEC,CNA.CNA_LJFORN,CNA.CNA_CRONOG "
	cQuery += "from " + RetSQLName("CNA") + " CNA ," + RetSQLName("CN9") + " CN9 "
	cQuery += "where CNA.CNA_FILIAL = '"+ xFilial("CNA") +"' AND CN9.CN9_FILIAL = '"+ xFilial("CNB") +"' AND CNA.CNA_CONTRA = CN9.CN9_NUMERO AND CNA.CNA_REVISA = CN9.CN9_REVISA AND "
	cQuery += "CNA.CNA_CONTRA = '" + cContra + "' and "
	cQuery += "CNA.CNA_REVISA = '" + cRevisa + "' and "
	cQuery += "(select count(*) from " + RetSQLName("CND") + " CND where CND.CND_FILIAL = '"+ xFilial("CND") +"' AND CND.CND_CONTRA =  '"+ cContra +"' and "
	cQuery += "CND.CND_REVISA = '"+ cRevisa +"' and CND.CND_NUMERO = CNA.CNA_NUMERO and CND.CND_DTFIM = '' and CND.D_E_L_E_T_ = '') = 0 and "//Filtra planilhas sem medicoes em aberto
	cQuery += "CNA.D_E_L_E_T_ = '' and CN9.D_E_L_E_T_ = ''"
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), "TRB", .F., .T. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Configura estrutura                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TCSetField("TRB","CNA_DTINI","D")
TCSetField("TRB","CNA_DTFIM","D")
TCSetField("TRB","CNA_VLTOT","N",TamSX3("CNA_VLTOT")[1],TamSX3("CNA_VLTOT")[2])
TCSetField("TRB","CNF_VLPREV","N",TamSX3("CNF_VLPREV")[1],TamSX3("CNF_VLPREV")[2])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Limpa arquivo temporario           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRBCNA")
If RecCount() > 0
	Zap
Endif

If TRB->(Eof()) .and. CN9->CN9_CTRT = '1' // Incluido em 25/06/07 por Alexandre Circenis Validar so para contratos fixos
	Aviso("CNTA120",OemToAnsi(STR0034),{"OK"})//"Não existe planilha disponível no contrato e competência selecionados. Verifique o saldo e a existência de medições em aberto para o contrato"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Copia planilhas filtradas para arquivo temporario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While TRB->(!Eof())
	RecLock("TRBCNA",.T.)
	TRBCNA->CNA_NUMERO := TRB->CNA_NUMERO
	TRBCNA->CNA_DTINI  := TRB->CNA_DTINI
	TRBCNA->CNA_VLTOT  := TRB->CNA_VLTOT
	TRBCNA->CNA_DTFIM  := TRB->CNA_DTFIM
	TRBCNA->CNA_FORNEC := TRB->CNA_FORNEC
	TRBCNA->CNA_LJFORN := TRB->CNA_LJFORN
	TRBCNA->CNA_CRONOG := TRB->CNA_CRONOG
	If !lMedeve
		TRBCNA->CNF_VLPREV := TRB->CNF_VLPREV
	else
		TRBCNA->CNF_VLPREV := 0
	EndIf
	MsUnlock()
	TRB->(dbSkip())
EndDo

TRB->(dbCloseArea())

TRBCNA->(dbGoTop())

CursorArrow()

oBrowse:Refresh()
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420VldCpt ³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida competencia durante a execucao da rotina automatica   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS420VldCpt(cExp01,cExp02)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS420VldCpt()
Local lRet := .T.
Local cQuery := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtra contrato                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CN9")
dbSetOrder(1)
dbSeek(xFilial("CN9")+cContra+cRevisa)

lMedeve := (Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_MEDEVE") == "1")

If !lMedeve
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Filtra planilhas de acordo com os cronogramas      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "select COUNT(*) QTD from " + RetSQLName("CNA") + " CNA ," + RetSQLName("CNF") + " CNF "
	cQuery += "where CNA.CNA_FILIAL = '"+ xFilial("CNA") +"' AND CNF.CNF_FILIAL = '"+ xFilial("CNF") +"' AND "
	cQuery += "CNA.CNA_CONTRA = CNF.CNF_CONTRA AND CNA.CNA_REVISA = CNF.CNF_REVISA AND "
	cQuery += "CNF.CNF_NUMERO = CNA.CNA_CRONOG AND CNF.CNF_COMPET = '"+ cCompet +"' AND "
	cQuery += "CNA.CNA_CONTRA = '" + cContra + "' and "
	cQuery += "CNA.CNA_REVISA = '" + cRevisa + "' and "
	cQuery += "CNA.CNA_NUMERO = '" + cPlan   + "' and "
	cQuery += "CNF.CNF_SALDO > 0 and "//Filtra parcelas nao medidas
	cQuery += "(select count(*) from " + RetSQLName("CND") + " CND where CND.CND_FILIAL = '"+ xFilial("CND") +"' AND CND.CND_CONTRA =  '"+ cContra +"' and "
	cQuery += "CND.CND_REVISA = '"+ cRevisa +"' and CND.CND_NUMERO = CNA.CNA_NUMERO and CND.CND_DTFIM = '' and CND.D_E_L_E_T_ = '') = 0 and "//Filtra planilhas sem medicoes em aberto
	cQuery += "CNA.D_E_L_E_T_ = '' and CNF.D_E_L_E_T_ = ''"
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Filtra planilhas                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "select COUNT(*) QTD from " + RetSQLName("CNA") + " CNA "
	cQuery += "where CNA.CNA_FILIAL = '"+ xFilial("CNA") +"' AND "
	cQuery += "CNA.CNA_CONTRA = '" + cContra + "' and "
	cQuery += "CNA.CNA_REVISA = '" + cRevisa + "' and "
	cQuery += "CNA.CNA_NUMERO = '" + cPlan + "' and "
	cQuery += "CNA.D_E_L_E_T_ = ''"
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), "TRB", .F., .T. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica o acesso do usuario                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRet := (TRB->QTD > 0)

TRB->(dbCloseArea())

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420RetTip³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Retorna descricao do tipo de planilha                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS420RetTip()                                               ³±±
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
Static Function CS420RetTip()
Local cTipPlan
Local cRet := ""

If !INCLUI
	cTipPlan := Posicione( "CNA", 1, xFilial("CNA") + CND->CND_CONTRA + CND->CND_REVISA + CND->CND_NUMERO,"CNA_TIPPLA")
	cRet     := Posicione( "CNL", 1, xFilial("CNL") + cTipPlan, "CNL_DESCRI" )
EndIf

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420MedEnc³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Encerra medicao, valida cronograma, medicoes zeradas        ³±±
±±³          ³ e saldo do contrato e planilhas                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³  CS420MedEnc(nExp01)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³  nExp01 - Registro atual                                    ³±±
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
Static Function CS420MedEnc(nReg)
Local lRet := .T.
Local lMedeve
Local cFilCod
Local cCronog
Local cParcel
Local nMedLmt := 0//Limite de medicao do contrato
Local lFscLmt := .F.
Local cNumSC7 := ""
Local cFilCNS
Local lFisico := .F.
Local cAlias  := ""
Local lFixo   := .T.
Local lValor  := .T.
Local lPeSld  := ExistBlock("CS420ENSLD")

// Variveis para a customizacao da CSU
Local nMedLmtInf := 0 //Limite inferior de medicao do contrato
Local nTot    := 0
Local cMedEv  := "1"
//Estabelece passos
ProcRegua(5)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona na medicao                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CND")
dbgoto(nReg)

lRet := CN240VldUsr(CND->CND_CONTRA,DEF_TRAENC,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada para validar o encerramento da   ³
//³medicao                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CS420VENC")
	lRet := ExecBlock("CS420VENC")
EndIf

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se a medicao ja se encontra encerrada    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(CND->CND_DTFIM)
		lRet := .F.
		Help( " ", 1, "CNTA120_03" )//"Medição já encerrada"
	Else
		dbSelectArea("CN9")
		dbSetOrder(1)
		If dbSeek(xFilial("CN9")+CND->CND_CONTRA+CND->CND_REVISA)
			CN1->(dbSetOrder(1))
			CN1->(dbSeek(xFilial("CN1")+CN9->CN9_TPCTO))
			lMedeve := (CN1->CN1_MEDEVE == "1")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se campo CN1_LMTMED ja existir valida a medicao   ³
			//³de acordo com o valor informado, caso contrario   ³
			//³valida apenas contra o saldo do cronograma        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If CN1->(FieldPos("CN1_LMTMED")) > 0
				nMedLmt := CN1->CN1_LMTMED
			EndIf
			
			If CN1->(FieldPos("CN1_REDVAR")) > 0
				nMedLmtInf := CN1->CN1_REDVAR
			EndIf
			
			If CN1->(FieldPos("CN1_TPLMT")) > 0
				lFscLmt := (CN1->CN1_TPLMT == "2")
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se o contrato é fixo  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			If CN1->(FieldPos("CN1_CTRFIX")) > 0 .And. CN1->(FieldPos("CN1_VLRPRV")) > 0
				lFixo  := (Empty(CN1->CN1_CTRFIX) .OR. (CN1->CN1_CTRFIX == "1"))
				lValor := (Empty(CN1->CN1_VLRPRV) .OR. (CN1->CN1_VLRPRV == "1"))
			EndIf
			// Contrato Fixo definido para CSU
			lFixo := CN9->CN9_CTRT = '1' // Contrato do tipo fixo CSU
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se o contrato possui cronograma fisico   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lFisico := (!lMedeve .And. (CN1->(FieldPos("CN1_CROFIS")) > 0) .And. (CN1->CN1_CROFIS == "1"))
		EndIf
		
		If lFixo
			cCronog := Posicione("CNA",1,xFilial("CNA")+CND->CND_CONTRA+CND->CND_REVISA+CND->CND_NUMERO,"CNA_CRONOG")
			If !lMedeve
				IncProc( STR0013 )//"Validando Cronograma X Planilhas"
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Quando nao for medicao eventual valida           ³
				//³valor previsto do cronograma com valor realizado ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("CNF")
				dbSetOrder(2)
				If dbSeek(xFilial("CNF")+CND->CND_CONTRA+CND->CND_REVISA+cCronog+CND->CND_COMPET)
					cParcel := CNF->CNF_PARCEL
					If !lFscLmt
		
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Soma o limite de medicao ao saldo da parcela      ³
					//³Subtrai o limite inferiror de medicao do saldo da parcela³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If((CNF->CNF_SALDO+((CNF->CNF_VLPREV*nMedLmt)/100)) < CND->CND_VLTOT) .or. ((CNF->CNF_SALDO-((CNF->CNF_VLPREV*nMedLmtInf)/100)) > CND->CND_VLTOT)
							Aviso("CNTA120",STR0011+CRLF+STR0012,{"OK"})//"Valor total de medição não previsto no cronograma."+CRLF+"O mesmo deve ser reestruturado."
							lRet := .F.
						EndIf
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Valida a quantidade medida contra a quantidade    ³
						//³prevista no cronograma                            ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cQuery := "SELECT CNE.CNE_ITEM,CNE.CNE_QUANT,CNS.CNS_PRVQTD FROM "+RetSQLName("CNE")+" CNE, "+RetSQLName("CNS")+" CNS, "+RetSQLName("CNF")+" CNF WHERE "
						cQuery += "CNE.CNE_FILIAL = '"+xFilial("CNE")+"' AND "
						cQuery += "CNS.CNS_FILIAL = '"+xFilial("CNS")+"' AND "
						cQuery += "CNF.CNF_FILIAL = '"+xFilial("CNF")+"' AND "
						cQuery += "CNE.CNE_NUMMED = '"+CND->CND_NUMMED+"' AND "
						cQuery += "CNF.CNF_COMPET = '"+CND->CND_COMPET+"' AND "
						cQuery += "CNS.CNS_CONTRA = CNE.CNE_CONTRA AND "
						cQuery += "CNS.CNS_REVISA = CNE.CNE_REVISA AND "
						cQuery += "CNS.CNS_PLANI  = CNE.CNE_NUMERO AND "
						cQuery += "CNS.CNS_ITEM   = CNE.CNE_ITEM AND "
						cQuery += "CNS.CNS_CONTRA = CNF.CNF_CONTRA AND "
						cQuery += "CNS.CNS_REVISA = CNF.CNF_REVISA AND "
						cQuery += "CNS.CNS_CRONOG = CNF.CNF_NUMERO AND "
						cQuery += "CNS.CNS_PARCEL = CNF.CNF_PARCEL AND "
						cQuery += "CNS.D_E_L_E_T_ = ' ' AND "
						cQuery += "CNE.D_E_L_E_T_ = ' ' AND "
						cQuery += "CNF.D_E_L_E_T_ = ' '"
						
						cAlias := GetNextAlias()
						cQuery := ChangeQuery( cQuery )
						dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAlias, .F., .T. )
						
						nMedLmt += 100
					nMedLmtInf := 100-nMedLmtInf
						
						While !(cAlias)->(Eof())
							If ((cAlias)->CNS_PRVQTD = 0 .And. (cAlias)->CNE_QUANT > 0) .OR. ((((cAlias)->CNE_QUANT*100)/(cAlias)->CNS_PRVQTD) > nMedLmt)
								Aviso("CNTA120",OemToAnsi(STR0035)+(cAlias)->CNE_ITEM+OemToAnsi(STR0036),{"OK"})//"Não é possível encerrar a medição.O item "##" ultrapassou o limite de medição do cronograma físico"
								lRet := .F.						
								Exit
							EndIf
							(cAlias)->(dbSkip())
						EndDo
						
						(cAlias)->(dbCloseArea())
					EndIf
				EndIf
			EndIf
		Else
			If lValor .And. CN9->CN9_SALDO < CND->CND_VLTOT
				Aviso("CNTA120",STR0046,{"OK"})//"Não foi possível encerrar a medição. O saldo do contrato nao equivale ao valor da medicao."
				lRet := .F.
			EndIf
		EndIf		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se houveram itens medidos quando a      ³
		//³medicao nao for zerada                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If(CND->CND_ZERO == "2" .And. CND->CND_VLTOT = 0)
			Help( " ", 1, "CNTA120_04")// "Não existem itens medidos no registro atual"
			lRet := .F.
		EndIf
	EndIf
	
	If lRet
		IncProc( STR0015 )//"Atualizando Medicao e Itens"
		Begin Transaction
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gera pedido de compra                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If CND->CND_ZERO == "2"
			IncProc( STR0017 )//"Gerando Pedido de Compras"
			lRet := CS420GravC7(CND->CND_NUMMED,,@cNumSC7)
		EndIf
		
		If lRet
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza data fim da medicao                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RecLock("CND",.F.)
			CND->CND_DTFIM := dDataBase
			MsUnlock()
			
			dbSelectArea("CNE")
			dbSetOrder(1)
			cFilCod := xFilial()
			dbSeek(cFilCod+CND->CND_CONTRA+CND->CND_REVISA+CND->CND_NUMERO+CND->CND_NUMMED)
			
			If lFixo
				If lFisico
					cFilCNS := xFilial("CNS")
				EndIf
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza itens da planilha                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				While CNE->CNE_FILIAL = cFilCod .And. CNE->CNE_CONTRA = CND->CND_CONTRA .And. CNE->CNE_REVISA = CND->CND_REVISA .And.;
					CNE->CNE_NUMERO = CND->CND_NUMERO .And. CNE->CNE_NUMMED = CND->CND_NUMMED
					dbSelectArea("CNB")
					dbSetOrder(1)
					If dbSeek(cFilCod+CNE->CNE_CONTRA+CNE->CNE_REVISA+CNE->CNE_NUMERO+CNE->CNE_ITEM)
					nTot += CNB->CNB_VLTOT-CNB->CNB_VLDESC
						RecLock("CNB",.F.)
						CNB->CNB_QTDMED += CNE->CNE_QUANT
						CNB->CNB_SLDMED -= CNE->CNE_QUANT
						MsUnlock()
					EndIf
					
					If lFisico
						dbSelectArea("CNS")
						dbSetOrder(1)
						If dbSeek(cFilCNS+CND->CND_CONTRA+CND->CND_REVISA+cCronog+cParcel+CNB->CNB_ITEM)
							RecLock("CNS",.F.)
							CNS->CNS_RLZQTD += CNE->CNE_QUANT
							CNS->CNS_SLDQTD -= CNE->CNE_QUANT
							MsUnlock()
						EndIf
					EndIf
					
					dbSelectArea("CNE")
					dbSkip()
				EndDo
				
				IncProc( STR0016 )//"Atualizando Saldos"
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza saldo da planilha                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("CNA")
				If dbSeek(xFilial("CNA")+CND->CND_CONTRA+CND->CND_REVISA+CND->CND_NUMERO)
					If !lPeSld//Nao atualiza saldo quando o ponto de entrada CS420SLDCTR estiver ativo
						RecLock("CNA",.F.)
						CNA->CNA_SALDO -= CND->CND_VLTOT
						MsUnlock()
					EndIf
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza saldo do contrato                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSetorder(1)
			If dbSeek(xFilial("CN9")+CND->CND_CONTRA+CND->CND_REVISA)
				DbSelectArea("CN1")
				DbSetOrder(1)
				If DbSeek(xFilial("CN1")+CN9->CN9_TPCTO)
					cMedEv := CN1->CN1_MEDEVE
				EndIf
				If (CN9->CN9_CTRT == "2")
					if !(cMedEv == "1")  //Se nao for Medica Eventual e Variavel 09/04/07
						RecLock("CN9",.F.)
						CN9->CN9_SALDO -= CND->CND_VLTOT
						MsUnlock()
					else   //Medica Eventual - Variavel
						RecLock("CN9",.F.)
						CN9->CN9_SALDO += nTot + CNA->CNA_REAJS
						MsUnlock()
					endif
				EndIf
			EndIf
			
			If !lMedeve .And. lFixo
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza saldo do cronograma quando nao houver  ³
				//³ medicao eventual                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("CNF")
				dbSetorder(2)
				If dbSeek(xFilial("CNF")+CND->CND_CONTRA+CND->CND_REVISA+cCronog+CND->CND_COMPET)
					If !lPeSld//Nao atualiza saldo quando o ponto de entrada CS420SLDCTR estiver ativo
						RecLock("CNF")
						CNF->CNF_VLREAL += CND->CND_VLTOT
						CNF->CNF_SALDO  -= CND->CND_VLTOT
						CNF->CNF_DTREAL := dDataBase
						MsUnlock()
						
						If (GetNewPar( "MV_CNPROVI" , "S" ) == "S")
					  		IncProc( STR0021 )//"Processando títulos provisórios"
						
							u_CS400ETit(CND->CND_CONTRA,CND->CND_REVISA,cCronog,CNF->CNF_PARCEL)
							If CNF->CNF_SALDO > 0
								u_CS400CTit(CND->CND_CONTRA,CND->CND_REVISA,cCronog,CNF->CNF_PARCEL,CNF->CNF_SALDO)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			
			If lPeSld//Chama ponto de entrada para atualizacao do saldo
				ExecBlock("CS420ENSLD",.f.,.f.,{lMedeve,lFisico,cCronog,lFixo,lValor})
			EndIf
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa ponto de entrada para encerramento da medicao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("CS420ENCMD")
			ExecBlock("CS420ENCMD")
		EndIf
		
		End Transaction
      
		If !lAuto
			If lRet		
				Aviso("CNTA120",OemToAnsi(STR0026)+cNumSC7,{"OK"})//"Gerado pedido de compra número "
			Else
				Aviso("CNTA120",OemToAnsi(STR0027)+" "+OemToAnsi(STR0028),{"OK"})//"O pedido de compra não pode ser gerado."##"Para mais informações consulte o log gerado no diretório \SYSTEM do sistema"
			EndIf
		EndIf
	EndIf
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420Ence ³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Encerra medicao                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS420Ence(cExp01,nExp02,nExp03)                            ³±±
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
Static Function CS420Ence(cAlias,nReg,nOpc)
Local lContinua := .T.
Local aValidGet := {}
Local nPosNum

If !lAuto
	lContinua := (Aviso("CNTA100",OemtoAnsi(STR0024),{STR0022,STR0023}) == 1)//"Confirma encerramento da medição?"##"Sim"##"Não"
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o numero da medicao foi fornecido      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (nPosNum:=aScan(aAutoCab,{|x| x[1]=="CND_NUMMED"})) > 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida numero da medicao                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AADD(aValidGet,{"cNumMed" ,aAutoCab[nPosNum,2],"CS420NumAuto(cNumMed,.F.)",.T.})
		
		If (lContinua := MsVldGAuto(aValidGet))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona na medicao                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("CND")
			dbSetOrder(4)
			dbSeek(xFilial("CND")+aAutoCab[nPosNum,2])
			nReg:=CND->(RECNO())
		EndIf
	else
		lContinua:=.F.
	EndIf
EndIf

If lContinua
	//Chama rotina de encerramento por meio de processo
	Processa( {|| CS420MedEnc(nReg) } )
	
	If CNL->(FieldPos("CNL_LMTAVS")) > 0
		dbSelectArea("CNA")
		dbSetOrder(1)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica alerta de saldo das planilhas            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If dbSeek(xFilial("CNA")+CND->CND_CONTRA+CND->CND_REVISA+CND->CND_NUMERO)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula percentual do saldo da planilha           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cPrcSld := (CNA->CNA_SALDO*100)/CNA->CNA_VLTOT
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Seleciona tipo de planilha                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("CNL")
			dbSetOrder(1)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a planilha alcancou o limite percentual³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If dbSeek(xFilial("CNL")+CNA->CNA_TIPPLA) .And. cPrcSld <= CNL->CNL_LMTAVS
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Emite alerta de saldo do contrato ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MEnviaMail("040",{CND->CND_NUMERO,CND->CND_CONTRA,CND->CND_REVISA,CNA->CNA_VLTOT,CNA->CNA_SALDO})
			EndIf
		EndIf
	EndIf
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420Estor³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Estorna medicao                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS420Estor(cExp01,nExp02,nExp03)                           ³±±
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
Static Function CS420Estor(cAlias,nReg,nOpc)
Local lContinua := .T.
Local aValidGet := {}
Local nPosNum

If !lAuto
	lContinua := (Aviso("CNTA100",OemtoAnsi(STR0025),{STR0022,STR0023}) == 1)//"Confirma estorno da medição?"##"Sim"##"Não"
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o numero da medicao foi fornecido      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (nPosNum:=aScan(aAutoCab,{|x| x[1]=="CND_NUMMED"})) > 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida numero da medicao                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AADD(aValidGet,{"cNumMed" ,aAutoCab[nPosNum,2],"CS420NumAuto(cNumMed,.F.)",.T.})
		
		If (lContinua := MsVldGAuto(aValidGet))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posiciona na medicao                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("CND")
			dbSetOrder(4)
			dbSeek(xFilial("CND")+aAutoCab[nPosNum,2])
			nReg:=CND->(RECNO())
		EndIf
	else
		lContinua:=.F.
	EndIf
EndIf

If lContinua
	//Chama rotina de estorno por meio de processo
	Processa( {|| CS420MedEst(nReg) } )
EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420GravC7³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gera pedido de compra por rotina automatica                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CS420GravC7(cExp01,cExp02)                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cExp01 - Numero da medicao                                  ³±±
±±³          ³ cExp02 - Codigo da nova revisao,usado na aprovacao CNTA150  ³±±
±±³          ³          pois o CND traz o codigo da revisao original       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS420GravC7(cNumMed,cNRevisa,cNumSC7)
Local aArea       := GetArea()
Local aAreaCND    := CND->(GetArea())
Local aRet        :={}
Local aCab 	      :={}
Local aItem	      :={}
Local cFilCod     := xFilial("CNE")
Local cQuery      := ""
Local cAliasQry   := ""
Local cAliasCNR   := ""
Local cAliasCNQ   := ""
Local aStrCNE     := CNE->(dbStruct())
Local nDesc       := 0
Local nDecrUn     := 0
Local nX
Local nRateio
Local nPosCpo
Local nTotMedic   := 0
Local nQuantArred := 0
Local nPrecoCalc  := 0
Local nPrecoArred := 0
Local nValorOri   := 0
Local nValorArred := 0
Local nValTot     := 0
Local nValQuant   := 0
Local nDifValor   := 0
Local nMult       := 0
Local nBoni       := 0
Local nTotDescPed := 0
Local nDescMed    := 0
Local lDesc
//Verifica se a retencao e realizada no documento de entrada
Local lGCTRet     := (GetNewPar( "MV_CNRETNF", "N" ) == "S") .And. ( SE2->( FieldPos("E2_RETCNTR") ) > 0 )

Local lRet := .T.

Default cNumSC7      := ""

Private lMsErroAuto	:= .F.

dbSelectArea("CND")
dbSetOrder(4)
//Posiciona medicao
If dbSeek(xFilial("CND")+cNumMed)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Apura o valor total da medicao sem considerar descontos                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cAliasQry := GetNextAlias()
	
	cQuery := "SELECT SUM(CNE_VLTOT) VLTOT, SUM(CNE_VLDESC) VLDESC FROM " + RetSqlName( "CNE" ) + " "
	cQuery += "WHERE "
	cQuery += "CNE_FILIAL='" + xFilial( "CNE" ) + "' AND "
	cQuery += "CNE_NUMMED='" + cNumMed + "' AND "
	cQuery += "D_E_L_E_T_=' '"
	
	cQuery := ChangeQuery( cQuery )
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAliasQry, .F., .T. )
	
	nTotMedic   := ( cAliasQry )->VLTOT
	nTotDescPed := ( cAliasQry )->VLDESC
	
	( cAliasQry )->( dbCloseArea() )
	
	dbSelectArea( "CNE" )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o recurso de multa / bonificacao esta disponivel para a medicao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty( CN4->( FieldPos( "CN4_VLDALT" ) ) )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Obtem o valor de multa e/ou bonificacao da medicao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		dbSelectArea("CNR")
			
		cAliasCNR := GetNextAlias()
				
		cQuery := "SELECT SUM( CNR.CNR_VALOR ) AS VALOR, CNR.CNR_TIPO FROM " + RetSqlName("CNR" ) + " CNR "
		cQuery += "WHERE "
		cQuery += "CNR.CNR_FILIAL = '"+xFilial("CNR")+"' AND "
		cQuery += "CNR.CNR_NUMMED = '" + cNumMed + "' AND "
		cQuery += "CNR.D_E_L_E_T_ = ' ' "
		If CNR->( FieldPos("CNR_FLGPED") ) > 0
			cQuery += "AND CNR.CNR_FLGPED = '1' "
		EndIf
		cQuery += "GROUP BY CNR.CNR_TIPO"
		
		cQuery := ChangeQuery( cQuery )
		
		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasCNR, .F., .T. )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Acerta o campo numerico                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		TcSetField( cAliasCNR, "VALOR", "N", 18, 2 )
		
		While !( cAliasCNR )->( Eof() )
					
			If ( cAliasCNR )->CNR_TIPO == "1"
				nMult := ( cAliasCNR )->VALOR
			ElseIf ( cAliasCNR )->CNR_TIPO == "2"
				nBoni := ( cAliasCNR )->VALOR
			EndIf
			
			( cAliasCNR )->( dbSkip() )
			
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha a area de trabalho                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		( cAliasCNR )->( dbCloseArea() )
		dbSelectArea( "CNR" )
		
	EndIf
	
	If AliasInDic("CNQ") .And. (CND->(FieldPos("CND_DESCME")) > 0) .And. CND->CND_DESCME > 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Obtem o valor dos descontos de contrato ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CNQ")
		
		cAliasCNQ := GetNextAlias()
				
		cQuery := "SELECT SUM( CNQ.CNQ_VALOR ) AS VALOR FROM " + RetSqlName("CNQ" ) + " CNQ, "+ RetSQLName("CNP") +" CNP "
		cQuery += "WHERE "
		cQuery += "CNQ.CNQ_FILIAL = '"+ xFilial("CNQ") +"' AND "
		cQuery += "CNP.CNP_FILIAL = '"+ xFilial("CNP") +"' AND "
		cQuery += "CNQ.CNQ_TPDESC = CNP.CNP_CODIGO AND "
		cQuery += "CNQ.CNQ_NUMMED = '" + cNumMed + "' AND "
		cQuery += "CNQ.D_E_L_E_T_ = ' ' AND CNP.D_E_L_E_T_=' ' "
		If	CNP->( FieldPos("CNP_FLGPED") ) > 0
			cQuery += "AND CNP.CNP_FLGPED = '1'""
		EndIf
		
		cQuery := ChangeQuery( cQuery )
		
		dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasCNQ, .F., .T. )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Acerta o campo numerico                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		TcSetField( cAliasCNQ, "VALOR", "N", 18, 2 )
		
		nDescMed := If((!( cAliasCNQ )->(Eof())),( cAliasCNQ )->VALOR,0)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha a area de trabalho                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		( cAliasCNQ )->( dbCloseArea() )
		dbSelectArea( "CNQ" )
	EndIf
	
	If cNRevisa == Nil
		cNRevisa := CND->CND_REVISA
	EndIf
	
	dbSelectArea("CN9")
	dbSetOrder(1)
	dbSeek(xFilial("CN9")+CND->CND_CONTRA+cNRevisa)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra itens da medicao e da planilha           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "Select distinct CNE.*,CNE.R_E_C_N_O_ as RECNO from "+ RetSQLName("CNE") +" CNE "
	cQuery += "where CNE.CNE_FILIAL = '"+ xFilial("CNE") +"' AND "
	cQuery += "CNE.CNE_NUMMED = '"+ CND->CND_NUMMED +"' AND "
	cQuery += "CNE.D_E_L_E_T_ <> '*'"
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCNE",.F.,.F.)
	
	For nx:=1 to len(aStrCNE)
		if TRBCNE->(FieldPos(aStrCNE[nx,1])) > 0 .And. aStrCNE[nx,2] <> "C"
			TCSetField( "TRBCNE", aStrCNE[nx,1], aStrCNE[nx,2], aStrCNE[nx,3], aStrCNE[nx,4] )
		endif
	Next
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Soma desconto de pedidos, descontos, multas, bonificacoes e Caucoes retidas  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nDesc := (nDescMed + nMult - nBoni + nTotDescPed) + If(((CND->(FieldPos("CND_RETCAC")))>0) .And. !lGCTRet,CND->CND_RETCAC,0)
	
	nRateio := ( nDesc *100 ) / nTotMedic
	lDesc   := !Empty( nDesc )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera numero do pedido de compra                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNumSC7 := Criavar("C7_NUM",.T.)
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera pedido de compra                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCab:={	{"C7_NUM",cNumSC7,NIL},;						// Numero do Pedido
				{"C7_EMISSAO",dDataBase,NIL},;					// Data de Emissao
				{"C7_FORNECE",CND->CND_FORNEC,NIL},;		    // Fornecedor
				{"C7_LOJA",CND->CND_LJFORN,NIL},;             	// Loja do Fornecedor
				{"C7_CONTATO",CriaVar("C7_CONTATO",.F.),NIL},;	// Contato
				{"C7_COND",CN9->CN9_CONDPG,NIL},;             	// Condicao de Pagamento
				{"C7_FILENT",CriaVar("C7_FILENT",.F.),NIL},;  	// Filial de Entrega
				{"C7_FRETE",CriaVar("C7_FRETE",.F.),NIL},;    	//Frete
				{"C7_DESPESA",CriaVar("C7_DESPESA",.F.),NIL},;	//Despesa
				{"C7_SEGURO",CriaVar("C7_SEGURO",.F.),NIL},;  	//Seguro
				{"C7_MSG",CriaVar("C7_MSG",.F.),NIL},;        	//Mensagem
				{"C7_REAJUST",CriaVar("C7_REAJUST",.F.),NIL}}	//Reajuste	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Informa moeda do contrato           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty( CND->( FieldPos( "CND_MOEDA" ) ) )
		aAdd(aCab,{"C7_MOEDA",CND->CND_MOEDA,NIL})//Moeda
		aAdd(aCab,{"C7_TXMOEDA",If(CN9->CN9_MOEDA!=CND->CND_MOEDA,xMoeda(1,CN9->CN9_MOEDA,CND->CND_MOEDA,dDataBase,TamSx3("C7_TXMOEDA")[2]),xMoeda(1,CN9->CN9_MOEDA,1,CTOD("25/05/07"),TamSx3("C7_TXMOEDA")[2])),NIL})// Taxa de Conversao
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera itens do pedido de compra                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nDifPreco := 0
	nDifValor := 0
		
	while !TRBCNE->(Eof())
		If TRBCNE->CNE_VLTOT > 0
	
			SB1->( dbSetOrder( 1 ) )
			dbSelectArea("SB1")
			If MSSeek(xFilial("SB1")+TRBCNE->CNE_PRODUT)
				
				nQuantArred := Round( TRBCNE->CNE_QUANT, TamSX3("C7_QUANT")[2] )
				
				nDecrUn     := (TRBCNE->CNE_VLUNIT * nRateio)/100
				nPrecoCalc  := TRBCNE->CNE_VLUNIT - nDecrUn
				nPrecoArred := Round( TRBCNE->CNE_VLUNIT - nDecrUn, TamSX3("C7_PRECO")[2] )
					
				nValorOri   := nPrecoCalc * TRBCNE->CNE_QUANT
				nValorArred := Round( nPrecoArred * nQuantArred, TamSX3("C7_TOTAL")[2] )
				
				nDifValor   += ( nValorArred - nValorOri )
				
				aAdd(aItem,{{"C7_ITEM",TRBCNE->CNE_ITEM,NIL},;                 //Item
				{"C7_PRODUTO",TRBCNE->CNE_PRODUT,NIL},;                        //Produto
				{"C7_QUANT", nQuantArred,NIL},;                           //Quantidade
				{"C7_QTDSOL",nQuantArred,NIL},;                          //Quantidade solicitada
				{"C7_UM",SB1->B1_UM,NIL},;                                     //Unidade de Medida
				{"C7_QTSEGUM",ConvUm(SB1->B1_COD,TRBCNE->CNE_QUANT,0,2),NIL},;//Segunda unidade de medida
				{"C7_PRECO", nPrecoArred,NIL},;                  //Preco unitario
				{"C7_TOTAL", nValorArred,NIL},;                   //Valor total
				{"C7_DESC", 0,Nil},;                            //Desconto
				{"C7_IPI",CriaVar("C7_IPI",.F.),NIL},;                         //IPI
				{"C7_REAJUST",CriaVar("C7_REAJUST",.F.),NIL},;                 //Reajuste
				{"C7_FRETE",CriaVar("C7_FRETE",.F.),NIL},;                     //Frete
				{"C7_DATPRF",TRBCNE->CNE_DTENT,NIL},;                          //Data de entrega
				{"C7_LOCAL",SB1->B1_LOCPAD,NIL},;                              //Local
				{"C7_MSG",CriaVar("C7_MSG",.F.),NIL},;                         //Mensagem
				{"C7_TPFRETE",CriaVar("C7_TPFRETE",.F.),NIL},;                 //Tipo de frete
				{"C7_OBS",CriaVar("C7_OBS",.F.),NIL},;                         //Observacao
				{"C7_CONTA",SB1->B1_CONTA,NIL},;                               //Conta do produto
				{"C7_CC",SB1->B1_CC,NIL},;                                     //Centro de custo
				{"C7_DESCRI",SB1->B1_DESC,NIL},;                               //Descricao
				{"C7_SEQMRP",CriaVar("C7_SEQMRP",.F.),Nil},;                   //Sequencia MRP
				{"C7_TES",SB1->B1_TE,Nil},;                                    //Sequencia MRP
				{"C7_TPOP","F",NIL}})                                          //Tipo de OP
			EndIf
			TRBCNE->(dbskip())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Transfere a diferenca dos arredondamentos       ³
			//³ quando houver                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If TRBCNE->(Eof()) .And. !Empty( nDifValor )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ajusta o valor total do ultimo item             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nPosCpo := aScan(aItem[len(aItem)],{|x| x[1] == "C7_TOTAL"})
				If nPosCpo > 0
					
					aItem[len(aItem),nPosCpo,2] -= nDifValor
					
					nValTot := aItem[len(aItem),nPosCpo,2]
					
				EndIf
				
				nValQuant := aItem[ Len( aItem ), aScan(aItem[len(aItem)],{|x| x[1] == "C7_QUANT"} ), 2 ]
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ajusta o valor unitario do ultimo item          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nPosCpo := aScan(aItem[len(aItem)],{|x| x[1] == "C7_PRECO"})
				If nPosCpo > 0
					aItem[len(aItem),nPosCpo,2] := nValTot / nValQuant
				EndIf
			EndIf
		Else
			TRBCNE->(dbskip())
		EndIf	
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama ponto de entrada para tratamento de campos³
	//³ especificos na geracao do pedido de compra      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	If ExistBlock("CS420PED")
		aRet := ExecBlock("CS420PED",.f.,.f.,{aCab,aItem})
		aCab := aRet[1]
		aItem:= aRet[2]
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa rotina automatica para geracao do       ³
	//³ pedido de compra                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MSExecAuto({|v,x,y,z,w| MATA120(v,x,y,z,w)},1,aCab,aItem,3,.F.)
		
	lRet := !lMsErroAuto

	If lRet
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Seleciona pedido de compra criado               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "Select SC7.R_E_C_N_O_ as RECNO,SC7.C7_ITEM from "+ RetSQLName("SC7") +" SC7 where "
		cQuery += "SC7.C7_FILIAL = '"+ xFilial("SC7") +"' AND "
		cQuery += "SC7.C7_NUM = '"+ cNumSC7 +"' AND "
		cQuery += "SC7.D_E_L_E_T_ = ''"
		
		cQuery := ChangeQuery(cQuery)
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSC7",.F.,.F.)
		
		dbSelectArea("SC7")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche campos especificos do SIGAGCT          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !TRBSC7->(Eof())
			dbGoTo(TRBSC7->RECNO)
			RecLock("SC7",.F.)
			SC7->C7_CONTRA  := CND->CND_CONTRA
			SC7->C7_CONTREV := cNRevisa
			SC7->C7_PLANILH := CND->CND_NUMERO
			SC7->C7_MEDICAO := CND->CND_NUMMED
			SC7->C7_ITEMED  := TRBSC7->C7_ITEM
			MsUnlock()
			TRBSC7->(dbSkip())
		EndDo
		TRBSC7->(dbCloseArea())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o campo CNE_PEDIDO dos itens da medicao³
		//³ com o codigo do pedido gerado                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("CNE")
		TRBCNE->(dbGoTop())
		While !TRBCNE->(Eof())
			dbGoto(TRBCNE->RECNO)
			RecLock("CNE",.F.)
			CNE->CNE_PEDIDO := cNumSC7
			MsUnlock()
			TRBCNE->(dbSkip())
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o recurso de multa / bonificacao esta disponivel para a medicao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty( CN4->( FieldPos( "CN4_VLDALT" ) ) )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Obtem o valor de multa e/ou bonificacao da medicao ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			cAliasCNR := GetNextAlias()
			
			cQuery := "SELECT CNR_VALOR, CNR_DESCRI, CNR_TIPO FROM " + RetSqlName("CNR" ) + " "
			cQuery += "WHERE "
			cQuery += "CNR_NUMMED='" + cNumMed + "' AND "
			cQuery += "D_E_L_E_T_=' '"
			
			cQuery := ChangeQuery( cQuery )
			
			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasCNR, .F., .T. )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Acerta o campo numerico                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			TcSetField( cAliasCNR, "CNR_VALOR", "N", 18, 2 )
			
			aMultas := {}
			
			While !( cAliasCNR )->( Eof() )
				AAdd( aMultas, { ( cAliasCNR )->CNR_VALOR,( cAliasCNR )->CNR_DESCRI,( cAliasCNR )->CNR_TIPO } )
				( cAliasCNR )->( dbSkip() )
			EndDo
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Fecha a area de trabalho                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			( cAliasCNR )->( dbCloseArea() )
			dbSelectArea( "CNR" )
			
			If !Empty( CNG->( "CNG_NUMMED" ) )// Verifica o campo CNG_NUMMED para armaz. historico
				CS420HistMul( 1, aMultas, CND->CND_CONTRA, CND->CND_NUMMED )
			EndIf
			
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava retencao da caucao                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
		If CND->( FieldPos("CND_RETCAC")) > 0 .And. !Empty(CND->CND_RETCAC)
			CS420CaucRet(CND->CND_CONTRA,CND->CND_NUMMED,1,CND->CND_RETCAC)
		EndIf
	EndIf
	TRBCNE->(dbCloseArea())
EndIf

// Restaura area original
RestArea(aAreaCND)
RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420CaucRet³ Autor ³ Marcelo Custodio      ³ Data ³20.09.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Grava o valor retido da caucao com base no valor da medicao  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³  CS420CaucRet(cExp01,cExp02,nExp03,nExp04)                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³  cExp01 - Codigo do contrato                                ³±±
±±³          ³  cExp02 - Codigo do medicao                                 ³±±
±±³          ³  nExp03 - (1-Incluir,2-Excluir)                             ³±±
±±³          ³  nExp04 - Valor retido                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CS420CaucRet(cContra,cMedicao,nOpc,nVlRet)
Local cQuery
Local cAliasCNT

If nOpc==1//Inclusao
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava retencao da caucao                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CNT")
	RecLock("CNT",.T.)
	CNT->CNT_FILIAL := xFilial("CNT")
	CNT->CNT_CONTRA := cContra
	CNT->CNT_NUMMED := cMedicao
	CNT->CNT_VLRET  := nVlRet
	CNT->CNT_DTMED  := dDataBase
	CNT->CNT_FORNEC := CND->CND_FORNEC
	CNT->CNT_LJFORN := CND->CND_LJFORN
	MsUnlock()
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona retencao da medicao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT CNT.R_E_C_N_O_ AS RECNO FROM "+RetSQLName("CNT")+" CNT WHERE "
	cQuery += "CNT.CNT_FILIAL = '"+xFilial("CNT")+"' AND "
	cQuery += "CNT.CNT_CONTRA = '"+cContra+"' AND "
	cQuery += "CNT.CNT_NUMMED = '"+cMedicao+"' AND "
	cQuery += "CNT.D_E_L_E_T_ = ' '"
	
	cAliasCNT := GetNextAlias()

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCNT,.F.,.T.)

	dbSelectArea("CNT")
	While !(cAliasCNT)->(Eof())
		CNT->( dbGoTo( (cAliasCNT)->RECNO ) )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui retencao        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RecLock("CNT",.F.)
		CNT->( dbDelete() )
		CNT->( MsUnlock() )
		(cAliasCNT)->(dbSkip())
	EndDo
	
	(cAliasCNT)->(dbCloseArea())
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420MedEst³ Autor ³ Marcelo Custodio      ³ Data ³09.02.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Estorna medicao, valida pedido de compra, medicoes zeradas  ³±±
±±³          ³ e saldo do contrato, planilhas e cronogramas                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³  CS420MedEst(nExp01)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³  nExp01 - Registro atual                                    ³±±
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
Static Function CS420MedEst(nReg)
Local cQuery   := ""
Local nRecSC7  := 0
Local cNumSC7  := ""
Local lMedeve  := .F.
Local cCronog  := ""
Local cFilCod  := ""
Local lContinua:= .T.
Local lEstPed  := .F.
Local lFisico  := .F.
Local cParcel
Local cAliasCNT
Local lFixo    := .T.
Local lValor   := .T.
Local lPeSld   := ExistBlock("CS420ESSLD")

PRIVATE lMsErroAuto := .F.

dbSelectArea("CND")
dbGoTo(nReg)

//Estabelece passos
ProcRegua(5)

lContinua := CN240VldUsr(CND->CND_CONTRA,DEF_TRAEST,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada para validar o estorno da   ³
//³medicao                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CS420VEST")
	lContinua := ExecBlock("CS420VEST")
EndIf

If lContinua
	If !Empty(CND->CND_DTFIM)
		If CND->( FieldPos("CND_RETCAC") ) > 0 .And. !Empty(CND->CND_RETCAC)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe retencao para a medicao e se ³
			//³ a mesma se encontra baixada                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery := "SELECT COUNT(*) AS RETQTD FROM "+RetSQLName("CNT")+" CNT WHERE "
			cQuery += "CNT.CNT_FILIAL = '"+xFilial("CNT")+"' AND "
			cQuery += "CNT.CNT_CONTRA = '"+CND->CND_CONTRA+"' AND "
			cQuery += "CNT.CNT_NUMMED = '"+CND->CND_NUMMED+"' AND "
			cQuery += "CNT.CNT_VLBX > 0 AND "
			cQuery += "D_E_L_E_T_ = ' '"
			
			cAliasCNT := GetNextAlias()
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCNT,.F.,.T.)
			
			lContinua := ((cAliasCNT)->RETQTD == 0)
			
			(cAliasCNT)->(dbCloseArea())
			
			If !lContinua
				Help( " ", 1, "CNTA120_05")//"A medição não pode ser estornada, pois o valor de retenção da caução já foi baixado"
			EndIf
		EndIf
		
		If lContinua
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Seleciona pedido gerado                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery := "Select SC7.C7_NUM,SC7.C7_QUJE,SC7.R_E_C_N_O_ as RECNO from "+ RetSQLName("SC7") +" SC7 where "
			cQuery += "SC7.C7_FILIAL  = '"+xFilial("SC7")+"' AND "
			cQuery += "SC7.C7_MEDICAO = '"+CND->CND_NUMMED+"' AND "
			cQuery += "SC7.C7_CONTRA  = '"+CND->CND_CONTRA+"' AND "
			cQuery += "SC7.C7_CONTREV = '"+CND->CND_REVISA+"' AND "
			cQuery += "SC7.D_E_L_E_T_ = ' '"
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SC7TMP",.F.,.T.)
			
			cNumSC7 := SC7TMP->C7_NUM
			
			IncProc( STR0020 )//"Verificando pedido de compras"
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se houve quantidade atendida           ³
			//³ para o pedido gerado                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While !SC7TMP->(Eof()) .And. SC7TMP->C7_QUJE == 0
				nRecSC7 := SC7TMP->RECNO
				SC7TMP->(dbSkip())
			EndDo
			
			If SC7TMP->(Eof())
				Begin Transaction
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se a medicao e zerada                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If CND->CND_ZERO == "2"
					IncProc( STR0020 )//"Verificando pedido de compras"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Exclui pedido de compras                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					MSExecAuto({|v,x,y,z,w| MATA120(v,x,y,z,w)},1,{{"C7_NUM",cNumSC7,NIL}},{},5,.F.)
					lEstPed := !lMsErroAuto
				EndIf
				
				If lEstPed
					CN9->(DbSetOrder(1))
					If CN9->(DbSeek(xFilial("CN9")+CND->CND_CONTRA+CND->CND_REVISA))
						
						CN1->(dbSetOrder(1))
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica se o contrato é fixo  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
						If CN1->(FieldPos("CN1_CTRFIX")) > 0 .And. CN1->(FieldPos("CN1_VLRPRV")) > 0 .And. CN1->(DbSeek(xFilial("CN1")+CN9->CN9_TPCTO))
							lFixo  := (Empty(CN1->CN1_CTRFIX) .OR. (CN1->CN1_CTRFIX == "1"))
							lValor := (Empty(CN1->CN1_VLRPRV) .OR. (CN1->CN1_VLRPRV == "1"))
						EndIf
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza data fim da medicao                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					RecLock("CND",.F.)
					CND->CND_DTFIM := CTOD("")
					MsUnlock()
					
					dbSelectArea("CNE")
					dbSetOrder(1)
					cFilCod := xFilial("CNE")
					dbSeek(cFilCod+CND->CND_CONTRA+CND->CND_REVISA+CND->CND_NUMERO+CND->CND_NUMMED)
					
					IncProc( STR0015 )//"Atualizando Medição e Itens"
					
					If lFixo
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza saldo da planilha                      ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("CNA")
						dbSetOrder(1)
						If dbSeek(xFilial("CNA")+CND->CND_CONTRA+CND->CND_REVISA+CND->CND_NUMERO)
							If !lPeSld//Nao atualiza saldo quando o ponto de entrada CS420SLDCTR estiver ativo	
								RecLock("CNA",.F.)
								CNA->CNA_SALDO += CND->CND_VLTOT
								MsUnlock()
							EndIf
							If !Empty(CNA->CNA_CRONOG)
								cCronog := CNA->CNA_CRONOG
							EndIf
						EndIf
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza saldo do contrato                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("CN9")
					dbSetorder(1)
					If dbSeek(xFilial("CN9")+CND->CND_CONTRA+CND->CND_REVISA)
						If !lPeSld//Nao atualiza saldo quando o ponto de entrada CS420SLDCTR estiver ativo
							RecLock("CN9",.F.)
							if CN9->CN9_CTRT = '1' // Incluido em 27/06/07 - Circenis FS
								CN9->CN9_SALDO += CND->CND_VLTOT
							else
								CN9->CN9_SALDO -= CND->CND_VLTOT
								If Empty(CN9->CN9_REVISA)//Se contrato original atualiza valor inicial
									CN9->CN9_VLINI -= CND->CND_VLTOT
								EndIf
							endif
							MsUnlock()
						EndIf
						lMedeve := (Posicione("CN1",1,xFilial("CN1")+CN9->CN9_TPCTO,"CN1_MEDEVE") == "1")
						lFisico := (!lMedeve .And. (CN1->(FieldPos("CN1_CROFIS")) > 0) .And. (CN1->CN1_CROFIS == "1"))
					EndIf
					
					If lFisico
						cFilCNS := xFilial("CNS")
					EndIf
					
					If !lMedeve
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza saldo do cronograma quando nao houver  ³
						//³ medicao eventual                                ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("CNF")
						dbSetorder(2)
						
						If dbSeek(xFilial("CNF")+CND->CND_CONTRA+CND->CND_REVISA+cCronog+CND->CND_COMPET)
							cParcel := CNF->CNF_PARCEL
							
							If !lPeSld//Nao atualiza saldo quando o ponto de entrada CS420SLDCTR estiver ativo
								RecLock("CNF")
								CNF->CNF_VLREAL -= CND->CND_VLTOT
								CNF->CNF_SALDO  += CND->CND_VLTOT
								If CNF->CNF_VLREAL == 0
									CNF->CNF_DTREAL := CTOD("")
								EndIf
								MsUnlock()
								
								If (GetNewPar( "MV_CNPROVI" , "S" ) == "S")
									IncProc( STR0021 )//"Processando títulos provisórios"
									
									u_CS400ETit(CND->CND_CONTRA,CND->CND_REVISA,cCronog,CNF->CNF_PARCEL)
									If CNF->CNF_SALDO > 0
										u_CS400CTit(CND->CND_CONTRA,CND->CND_REVISA,cCronog,CNF->CNF_PARCEL,CNF->CNF_SALDO)
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza itens da planilha                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					While !CNE->(Eof()) .And. CNE->CNE_FILIAL == cFilCod .And. CNE->CNE_CONTRA == CND->CND_CONTRA .And. CNE->CNE_REVISA == CND->CND_REVISA .And.;
						CNE->CNE_NUMERO == CND->CND_NUMERO .And. CNE->CNE_NUMMED == CND->CND_NUMMED
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Limpa o pedido do item de medicao               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						RecLock("CNE")
						CNE->CNE_PEDIDO := ""
						MsUnlock()
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza saldo dos itens da planilha            ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("CNB")
						dbSetOrder(1)
						If dbSeek(cFilCod+CNE->CNE_CONTRA+CNE->CNE_REVISA+CNE->CNE_NUMERO+CNE->CNE_ITEM)
							RecLock("CNB",.F.)
							CNB->CNB_QTDMED -= CNE->CNE_QUANT
							CNB->CNB_SLDMED += CNE->CNE_QUANT
							MsUnlock()
						EndIf
						
						If lFisico
							dbSelectArea("CNS")
							dbSetOrder(1)
							If dbSeek(cFilCNS+CND->CND_CONTRA+CND->CND_REVISA+cCronog+cParcel+CNE->CNE_ITEM)
								RecLock("CNS",.F.)
								CNS->CNS_RLZQTD -= CNE->CNE_QUANT
								CNS->CNS_SLDQTD += CNE->CNE_QUANT
								MsUnlock()
							EndIf
						EndIf
						
						dbSelectArea("CNE")
						dbSkip()
					EndDo
					
					IncProc( STR0016 )//"Atualizando Saldos"
					
					If lPeSld//Chama ponto de entrada para atualizacao do saldo
						ExecBlock("CS420ESSLD",.f.,.f.,{lMedeve,lFisico,cCronog,lFixo,lValor})
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Estorna o historico de multas / bonificacoes do contrato ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty( CNG->( "CNG_NUMMED" ) )// Verifica o campo CNG_NUMMED para estor. historico
						CS420HistMul( 2, NIL, CND->CND_CONTRA, CND->CND_NUMMED )
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Executa ponto de entrada para estorno da medicao ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ExistBlock("CS420ESTMD")
						ExecBlock("CS420ESTMD")
					EndIf
					
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Estorna o valor retido da caucao ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If CND->( FieldPos("CND_RETCAC")) > 0 .And. !Empty(CND->CND_RETCAC)
					CS420CaucRet(CND->CND_CONTRA,CND->CND_NUMMED,2,CND->CND_RETCAC)
				EndIf
				End Transaction
				
				If !lAuto
					If !lEstPed
						Aviso("CNTA120",OemToAnsi(STR0031)+cNumSC7+OemToAnsi(STR0032),{"OK"})//"O pedido "##" não pode ser estornado"
					Else
						Aviso("CNTA120",OemToAnsi(STR0033),{"OK"})//"Medição/entrega estornada com sucesso"
					EndIf
				EndIf
			Else
				Help( " ", 1, "CNTA120_05")//Ja atendida
			EndIf
			
			SC7TMP->(dbCloseArea())
		EndIf
	Else
		Help( " ", 1, "CNTA120_06")//Nao encerrada
	EndIf
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420AjSX7 ³ Autor ³ Marcelo Custodio      ³ Data ³06.04.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Corrige ordem dos gatilhos dos itens de medicao (CNE)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³  CS420AjSX7()                                               ³±±
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
Static Function CS420AjSX7()
Local nRegD//Registro da ordem 002
Local nRegT//Registro da ordem 003

SX7->(dbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa ordem 002 e valida conteudo atual      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX7->(dbSeek("CNE_PERC  002")) .And. AllTrim(SX7->X7_CDOMIN) == "CNE_VLDESC"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Armazena registro da ordem 002              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nRegD := SX7->(RecNo())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pesquisa ordem 003 e armazena registro      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SX7->(dbSeek("CNE_PERC  003"))
	nRegT := SX7->(RecNo())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a troca da ordem de execucao        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SX7->(dbGoTo(nRegD))
	RecLock("SX7",.F.)
	SX7->X7_SEQUENC := "003"
	MsUnlock()
	
	SX7->(dbGoTo(nRegT))
	RecLock("SX7",.F.)
	SX7->X7_SEQUENC := "002"
	MsUnlock()
EndIf

Return Nil

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CS420HistMul³ Autor ³ Sergio Silveira     ³ Data ³04/08/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Efetua a manutencao do historico das multas nas medicoes    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A103HistMul( ExpN1,ExpA2,ExpC3,ExpC4,ExpC5,ExpC6)           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 -> Tipo : 1 - Inclusao / 2 - Exclusao                 ³±±
±±³          ³ ExpA2 -> Array de multas                                    ³±±
±±³          ³ ExpC3 -> Documento                                          ³±±
±±³          ³ ExpC4 -> Serie                                              ³±±
±±³          ³ ExpC5 -> Fornecedor                                         ³±±
±±³          ³ ExpC6 -> Loja                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CS420HistMul( nTipo, aMultas, cContra, cNumMed )

Local cHora     := ""
Local cAliasQry := ""
Local cQuery    := ""

Local nLoop     := 0

If nTipo == 1
	
	cHora := Time()
	
	For nLoop := 1 to Len( aMultas )
		
		RecLock( "CNG", .T. )
		
		CNG->CNG_FILIAL  := xFilial( "CNG" )
		CNG->CNG_CONTRA  := cContra
		CNG->CNG_DATA    := dDataBase
		CNG->CNG_HORA    := cHora
		CNG->CNG_VALOR   := aMultas[ nLoop, 1 ]
		CNG->CNG_DESCRI  := aMultas[ nLoop, 2 ]
		CNG->CNG_TIPO    := aMultas[ nLoop, 3 ]
		CNG->CNG_NUMMED  := cNumMed
		
		CNG->( MsUnlock() )
		
	Next nLoop
	
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui o historico desta NF no contrato                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cAliasQry := GetNextAlias()
	
	cQuery := "SELECT R_E_C_N_O_ CNGRECNO FROM " + RetSqlName( "CNG" ) + " "
	cQuery += "WHERE "
	cQuery += "CNG_NUMMED='"  + cNumMed + "' AND "
	cQuery += "D_E_L_E_T_=' '"
	
	cQuery := ChangeQuery( cQuery )
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAliasQry, .F., .T. )
	
	While !( cAliasQry )->( Eof() )
		
		CNG->( dbGoto( ( cAliasQry )->CNGRECNO ) )
		
		RecLock( "CNG", .F. )
		
		CNG->( dbDelete())
		CNG->( MsUnlock())
		
		( cAliasQry )->( dbSkip() )
		
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui a area de trabalho da query                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	( cAliasQry )->( dbCloseArea() )
	
EndIf

Return( .t. )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CS420Impr ºAutor  ³Fabio Alves         º Data ³  28/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua a impressao da medicao dentro da rotina             º±±
±±º          ³ Medicoes/Entregas.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CNTA120                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CS420Impr()
Private cTitRel := OemToAnsi(STR0037) //Medicoes
Private lEnd	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros para imprimir a medicao dentro da rotina medicoes/entregas. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mv_par01 := CND->CND_NUMMED
mv_par02 := CND->CND_NUMMED
mv_par03 := Space(TamSx3("CN9_NUMERO")[1])
mv_par04 := Replicate("Z",TamSx3("CN9_NUMERO")[1])
mv_par05 := CTOD("01/01/06")
mv_par06 := CTOD("31/12/49")
mv_par07 := Space(TamSx3("CN9_SITUAC")[1])
mv_par08 := Replicate("Z",TamSx3("CN9_SITUAC")[1])
mv_par09 := Space(TamSx3("A2_COD")[1])
mv_par10 := Replicate("Z",TamSx3("A2_COD")[1])
mv_par11 := Space(TamSx3("CN9_TPCTO")[1])
mv_par12 := 1
mv_par13 := 1
mv_par14 := 1


RptStatus({|lEnd| CNR030Imp(@lEnd)})

Return          

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
PRIVATE aRotina	:= 	{ 	{ STR0002, "AxPesqui"  	, 0, 1, 0, .F.},;	//"Pesquisar"
									{ STR0003, "u_CS430Manut()"	, 0, 2, 0, nil},;	//"Visualizar"
									{ STR0004, "u_CS420Inc"   , 0, 3, 0, nil},;	//"Incluir"
									{ STR0005, "u_CS420Manut()" , 0, 4, 0, nil},;	//"Alterar"
									{ STR0006, "u_CS420Manut()"	, 0, 5, 0, nil},;	//"Excluir"
									{ STR0007, "u_CS420Ence"	, 0, 6, 0, nil},;	//"Encerrar"
									{ STR0018, "u_CS420Estor"	, 0, 7, 0, nil},; 	//"Estornar" 
									{ STR0042, "u_CS420Leg"	, 0, 8, 0, .F.},; 	//"Legendas"
									{ STR0038, "u_CS420Impr"	, 0, 9, 0, nil}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada utilizado para inserir novas opcoes no array aRotina  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("CTA120MNU")
	ExecBlock("CTA120MNU",.F.,.F.)
EndIf
Return(aRotina)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CS420AjSXB³ Autor ³ Marcelo Custodio   ³ Data ³29/05/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Corrige filtro da consulta padra CN9001                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CS420AjSXB()

dbSelectArea("SXB")
dbSetOrder(1)

If dbSeek("CN9001601") .And. AllTrim(SXB->XB_CONTEM) = "u_CS400FilCont()"
	RecLock("SXB",.F.)
	SXB->XB_CONTEM := "CN9->CN9_SITUAC = '05'"
	MsUnlock()
EndIF

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CS420AjSX3³ Autor ³ Marcelo Custodio   ³ Data ³07/01/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Configura os campos de fornecedor como obrigatorios     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CS420AjSX3()

dbSelectArea("SX3")
dbSetOrder(2)

If dbSeek("CND_FORNEC") .And. SX3->X3_RESERV != "‡€"
	RecLock("SX3",.F.)
	SX3->X3_RESERV := "‡€"
	MsUnlock()
EndIf

If dbSeek("CND_LJFORN") .And. SX3->X3_RESERV != "‡€"
	RecLock("SX3",.F.)
	SX3->X3_RESERV := "‡€"
	MsUnlock()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CS420Plan  ³ Autor ³ Alexandre Circenis ³ Data ³ 16/01/2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Permite a Inclusao de Planilha numa contrato do Tipo Valor ³±±
±±³          ³ Variavel                                                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Retorna o numero da Planilha incluida                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados         ³±±
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
*/
Static Function CS420PLAN(cAlias,nReg,nOpc,xFiller,lReali,lReadq,aPlani,aPlIt,cContra,cPlani,dInicio,dTermino)
//Function CN200Manut(cAlias,nReg,nOpc,xFiller,lReali,lReadq,aPlani,aPlIt,cContra,cPlani,dInicio,dTermino)
Local aArea     := GetArea()
Local l200SCC := ExistBlock("CTA200SCC")
Local l200PLN   := ExistBlock("CTA200PLN")
Local nA        := 0
Local nPosCampo := 0
Local oDlg
Local oGetDados
Local aCpoEnch  := {}
Local nOpca     := 0
Local lRet      := .T.
Local aButtons  := {}
Local cFilCod
Local nTotCronog
Local nPos
Local nPlan
Local nx
Local cRotina := FunName()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de variaveis de tela    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aHeader     := {}
Local aCols       := {}
Local nUsado      := 0
Local aSize     := MsAdvSize(,.F.,430)
Local aObjects  := {}
Local aPosObj   := {}
Local aRetPE    := {}

//Variaveis usadas pela consulta especifica
PRIVATE lContrEd  := (aPlani != Nil)
PRIVATE lBxCNT    := .F.
PRIVATE dCN9FIM   := dTermino

Private aTela[0][0]
Private aGets[0]

default lReali := .F.
Default lReadq := .F.

SaveInter() // Salva variaveis publicas

SetFunName( "CNTA100" )

cPlani := NIL

if nOpc != 3 .And. nOpc != 2 .And. !lContrEd
	lRet := CN240VldUsr(CNA->CNA_CONTRA,If(nOpc==4,DEF_TRAEDT,DEF_TRAEXC),.T.)
	
	If lRet
		dbSelectArea("CN9")
		dbSetOrder(1)
		dbSeek(xFilial("CN9")+CNA->CNA_CONTRA+CNA->CNA_REVISA)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o contrato aceita exclusao/inclusao ³
		//³ de planilhas                                    ³
		//³  - 2 - Elaboracao                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//		if AllTrim(CN9->CN9_SITUAC) != DEF_SELAB .AND. AllTrim(CN9->CN9_SITUAC) != DEF_SEMIT .AND. AllTrim(CN9->CN9_SITUAC) != DEF_SAPRO
		//			Help(" ",1,"CNTA200SIT") //"Situação de contrato inválida para exc/inc de planilhas"
		//			lRet := .F.
		//		EndIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a planilha possui cronograma e se   ³
		//³ o mesmo possui medicoes                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet .And. !Empty(CNA->CNA_CRONOG)
			dbSelectArea("CNF")
			dbSetOrder(1)
			
			cFilCod := xFilial("CNF")
			If dbSeek(cFilCod+CNA->CNA_CRONOG)
				While CNF->CNF_FILIAL == cFilCod .And. CNF->CNF_NUMERO == CNA->CNA_CRONOG
					If !Empty(CNF->CNF_DTREAL)
						Help(" ",1,"CNTA200SEL") //"A planilha selecionada não pode ser alterada/excluída pois possui medições já efetuadas"
						lRet := .F.
						Exit
					EndIf
					dbSkip()
				EndDo
			EndIf
		EndIf
	EndIf
EndIF

If nOpc == 2 .And. Empty(aPlani)
	lRet := CN240VldUsr(CNA->CNA_CONTRA,DEF_TRAVIS,.T.)
EndIf

If lRet
	dbSelectArea("SX3")
	MsSeek("CNA")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona os campos do cabecalho das planilhas     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof() .And. SX3->X3_ARQUIVO == "CNA"
		
		If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_CAMPO != "CNA_FILIAL" .And. SX3->X3_CAMPO != "CNA_ESPEL" .And. SX3->X3_CAMPO != "CNA_CRONOG" .And. SX3->X3_CAMPO != "CNA_DTMXMD"
			Aadd(aCpoEnch, SX3->X3_CAMPO )
		EndIF
		
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	RegToMemory("CNA",(nOpc == 3))
	If lContrEd
		nPlan := aScan(aPlani,{|x| x[CNA->(FieldPos("CNA_NUMERO"))] == cPlani})
		If nPlan > 0
			For na:=1 to len(aCpoEnch)
				nPos := CNA->(FieldPos(aCpoEnch[na]))
				If nPos > 0
					M->&(aCpoEnch[na]) := aPlani[nPlan,nPos]
				EndIf
			Next
		EndIf
	EndIf
	
	M->CNA_CONTRA := cContra
	CS420ATUCP()// autalizar os campos.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Devolve o tamanho da tela atualmente no micro do usuario.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aSizeAut := MsAdvSize()
	
	Aadd(aObjects, { 100,  70, .T., .T. } )
	Aadd(aObjects, { 100, 100, .T., .T. } )
	
	aInfo   := { aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3 }
	aPosObj := MsObjSize(aInfo, aObjects)
	
	aHeader := u_CS600GerHd(nOpc,lReadq,lReali,lContrEd)
	nUsado  := len(aHeader)
	
	/* So será utilizada para inclusao nao ha sentido em ter
	If nOpc != 3
	If !lContrEd
	cFilCod := xFilial("CNB")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o aCols.                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("CNB")
	dbSetOrder(1)
	MsSeek(cFilCod + CNA->CNA_CONTRA + CNA->CNA_REVISA + CNA->CNA_NUMERO)
	
	While CNB->CNB_FILIAL == cFilCod .And. CNB->CNB_CONTRA == CNA->CNA_CONTRA .And.;
	CNB->CNB_REVISA == CNA->CNA_REVISA .And. CNB->CNB_NUMERO == CNA->CNA_NUMERO  .And. !Eof()
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
	
	dbSelectArea("CNB")
	dbSkip()
	EndDo
	ElseIf nPlan > 0
	aCols := aPlIt[nPlan]
	EndIf
	EndIf
	*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de Entrada para manipulacao do aHeader e do Acols ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l200PLN
		aRetPE := ExecBlock("CTA200PLN",.F.,.F.,{nOpc,aClone(aHeader),aClone(aCols)})
		If Valtype(aRetPE) == "A"
			If ValType(aRetPE[1]) == "A"
            	aHeader := aRetPE[1]
            Endif
   			If ValType(aRetPE[2]) == "A"
            	aCols := aRetPE[2]
            Endif
        Endif    
	Endif 
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de Entrada para tratamento do campo centro de custo na solicitacao compras.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If l200SCC
		aFields :=	ExecBlock ("CTA200SCC",.F.,.F.)
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona botoes para importacao de SC                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpc == 3 .Or. nOpc == 4
		aadd(aButtons,{"SOLICITA",{|| if(u_CS600CabOk(aCpoEnch,@oDlg),u_CS600SC(oGetDados),) },OemToAnsi(STR0008),OemToAnsi(STR0010)})	      //"Solicitacoes"
		aadd(aButtons,{"PEDIDO2",{|| if(u_CS600CabOk(aCpoEnch,@oDlg),u_CS600SCIt(oGetDados),) },OemToAnsi(STR0009),OemToAnsi(STR0011)})//"Solicitacoes por item"
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Botao para exportar dados para EXCEL                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If FindFunction("RemoteType") .And. RemoteType() == 1
		aAdd(aButtons   , {PmsBExcel()[1],{|| DlgToExcel({ {"ENCHOICE",STR0036,aGets,aTela},{"GETDADOS",OemToAnsi(STR0037),aHeader,aCols}})},PmsBExcel()[2],PmsBExcel()[3]})
	EndIf
	
	If aRotina[ nOpc, 4 ] == 2
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Botao do Tracker                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aButtons, { "ORDEM", { || u_CS600Track( aCols, aHeader ) }, STR0038, STR0039 } ) // "System Tracker", "Tracker"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Botao do banco de conhecimento                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aButtons, { "BPMSDOC", { || u_CS600Conhec() }, STR0041, STR0042 } ) // "Banco de conhecimento", "Conhecim."
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche campos usados no cadastro atraves da rotina de ³
	//³ contratos                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cContra != Nil
		M->CNA_CONTRA := cContra
	EndIf
	If cPlani != Nil
		M->CNA_NUMERO := cPlani
	EndIf
	If !Empty(dInicio)
		M->CNA_DTINI := dInicio
	EndIf
	If !Empty(dTermino)
		M->CNA_DTFIM := dTermino
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa lancamento do SIGAPCO   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lContrEd
		PcoIniLan("000354")
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dialog.                                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	
	EnChoice( cAlias, nReg, nOpc,,,,aCpoEnch, aPosObj[1], , , , , , , , .T.)
	oGetDados:=MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],IIF(nOpc!=3 .And. nOpc!=4,0,GD_UPDATE+GD_INSERT+GD_DELETE),'u_CS600LinOk()','u_CS600TudOk()','+CNB_ITEM',,,,,,,oDlg,aHeader,aCols)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida o cabecalho antes do preenchimento dos itens                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGetDados:oBrowse:bGotFocus	:= {||u_CS600CabOk(aCpoEnch,@oDlg) }
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| If(u_CS600CabOk(aCpoEnch,@oDlg) .And. u_CS600TudOk(oGetDados),(nOpca:=1,oDlg:End()),nOpca:=0)},{||(nOpca:=2,oDlg:End())},,aButtons)
	
	If (nOpca == 1 .And. nOpc != 2)
		If !lContrEd
			Begin Transaction
			u_CS600Grv(nOpc,oGetDados)
			End Transaction
		Else
			u_CS600AGrv(nOpc,aPlani,aPlIt,oGetDados)
		EndIf
		
		If nOpc == 4 .And. !Empty(CNA->CNA_CRONOG)
			dbSelectArea("CNF")
			dbSetOrder(2)
			cFilCod := xFilial("CNF")
			If dbSeek(cFilCod+CNA->CNA_CONTRA+CNA->CNA_REVISA+CNA->CNA_CRONOG)
				nTotCronog := 0
				//Soma total do cronograma
				While CNF->CNF_FILIAL == cFilCod .And. CNF->CNF_NUMERO == CNA->CNA_CRONOG
					nTotCronog += CNF->CNF_VLPREV
					dbSkip()
				EndDo
				If nTotCronog != CNA->CNA_VLTOT
					If MsgYesNo(STR0035)//"O cronograma deve ser atualizado de acordo com a planilha. Selecione 'Sim' para regerar as parcelas e 'Nao' para alterá-las manualmente"
						u_CS410Manut("CNF",RecNo(),4,,CNA->CNA_CONTRA,CNA->CNA_REVISA,.T.,.T.)
					Else
						u_CS410Manut("CNF",RecNo(),4,,CNA->CNA_CONTRA,CNA->CNA_REVISA,.T.,.F.)
					EndIf
				EndIf
			EndIf
		EndIf
		
	EndIf
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza lancamento do SIGAPCO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lContrEd
		PcoFinLan("000354")  
		PcoFreeBlq("000354")
	EndIf
		
	
EndIF
RestArea(aArea)

If cPlani != Nil
	cPlani := M->CNA_NUMERO
EndIf

SetFunName( cRotina )
RestInter() // Restaura variaveis publicas

Return M->CNA_NUMERO


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CS420ATUCPºAutor  ³Alexandre Circenis  º Data ³  26/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualizacao dos campos da Tela da Planilha                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CS420ATUCP()

Local aArea     := GetArea()
Local lRet      := .F.
Local cContrato := M->CNA_CONTRA
Local cRevisa   := M->CNA_REVISA

dbSelectArea("CN9")
dbSetOrder(1)

If Empty(cRevisa)
	dbSeek(xFilial("CN9")+cContrato)
	//Seleciona revisao mais recente se houver
	If !Empty(CN9->CN9_REVATU)
		M->CNA_REVISA := cRevisa := CN9->CN9_REVATU
	EndIf
	
endif

If dbSeek(xFilial("CN9")+cContrato+cRevisa)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o contrato aceita planilha          ³
	//³ Situacoes que aceitam a inclusao de planilha    ³
	//³  - 2 - Elaboracao                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(CN9->CN9_REVATU)
		//Quando altera o numero do contrato limpa o fornecedor
		If ALTERA .And. M->CNA_CONTRA != CNA->CNA_CONTRA
			M->CNA_FORNEC := Space(TamSX3("CNA_FORNEC")[1])
			M->CNA_LOJA	  := Space(TamSX3("CNA_LOJA")[1])
		Endif
		
		//Retorna numero na sequencia do contrato para a planilha
		M->CNA_NUMERO := u_CS600PlaNum(cContrato,cRevisa)
		//Retorna data inicial do contrato, ou a data atual
		M->CNA_DTINI  := If((CN9->CN9_DTINIC > dDataBase),CN9->CN9_DTINIC,dDataBase)
		//Retorna data final do contrato, ou a data atual
		M->CNA_DTFIM  := If((CN9->CN9_DTFIM > dDataBase),CN9->CN9_DTFIM,dDataBase)
		
		dbSelectArea("CNC")
		dbSetOrder(1)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Seleciona primeiro fornecedor relacionado       ³
		//³ ao contrato                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If dbSeek(xFilial("CNC")+M->CNA_CONTRA)
			M->CNA_FORNEC := CNC->CNC_CODIGO
			M->CNA_LJFORN := CNC->CNC_LOJA
		Else
			M->CNA_FORNEC := Space(TamSX3("CNA_FORNEC")[1])
			M->CNA_LJFORN := Space(TamSX3("CNA_LJFORN")[1])
		Endif
		lRet := .T.
	EndIf
Else
	//Limpa revisao quando o contrato nao for encontrado
	M->CNA_REVISA := Space(TamSX3("CNA_REVISA")[1])
Endif
RestArea(aArea)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C120ESTPLAºAutor  ³Alexandre Circenis  º Data ³  06/25/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Estorna Planilha                                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static FUNCTION C120ESTPLA(cAlias,nReg,nOpc,xFiller,lReali,lReadq,aPlani,aPlIt,cContra,cPlani,dInicio,dTermino)

//Function CN200Manut(cAlias,nReg,nOpc,xFiller,lReali,lReadq,aPlani,aPlIt,cContra,cPlani,dInicio,dTermino)
Local aArea     := GetArea()
Local cFilCod
Local nTotCronog

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao de variaveis de tela    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Variaveis usadas pela consulta especifica
PRIVATE lContrEd  := (aPlani != Nil)
PRIVATE lBxCNT    := .F.

Default lReali := .F.
Default lReadq := .F.

dbSelectArea("CN9")
dbSetOrder(1)
dbSeek(xFilial("CN9")+CNA->CNA_CONTRA+CNA->CNA_REVISA)

if CN9->CN9_CTRT = '1' // Contrato do tipo Fixo não pode ter planilha deletada
	RestArea(aArea)
	Return
endif

If !lContrEd
	Begin Transaction
	DelPlanilh()
	End Transaction
Else
	DelPlanilh()
EndIf

If nOpc == 4 .And. !Empty(CNA->CNA_CRONOG)
	dbSelectArea("CNF")
	dbSetOrder(2)
	cFilCod := xFilial("CNF")
	If dbSeek(cFilCod+CNA->CNA_CONTRA+CNA->CNA_REVISA+CNA->CNA_CRONOG)
		nTotCronog := 0
		//Soma total do cronograma
		While CNF->CNF_FILIAL == cFilCod .And. CNF->CNF_NUMERO == CNA->CNA_CRONOG
			nTotCronog += CNF->CNF_VLPREV
			dbSkip()
		EndDo
		If nTotCronog != CNA->CNA_VLTOT
			If MsgYesNo(STR0035)//"O cronograma deve ser atualizado de acordo com a planilha. Selecione 'Sim' para regerar as parcelas e 'Nao' para alterá-las manualmente"
				u_CS410Manut("CNF",RecNo(),4,,CNA->CNA_CONTRA,CNA->CNA_REVISA,.T.,.T.)
			Else
				u_CS410Manut("CNF",RecNo(),4,,CNA->CNA_CONTRA,CNA->CNA_REVISA,.T.,.F.)
			EndIf
		EndIf
	EndIf
Endif
RestArea(aArea)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DelPlanilhºAutor  ³Alexandre Circenis  º Data ³  06/25/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Deleta a Planilha ao Cancelar a Medição                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function DelPlanilh()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga os itens da planilha                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CNB")
dbSetOrder(1)
cFilCod := xFilial("CNB")
If dbSeek(cFilCod+CNA->CNA_CONTRA+CNA->CNA_REVISA+CNA->CNA_NUMERO)
	While !Eof() .And. CNB->CNB_FILIAL = cFilCod .And. CNB->CNB_CONTRA == CNA->CNA_CONTRA .And. CNB->CNB_REVISA == CNA->CNA_REVISA .And. CNB->CNB_NUMERO == CNA->CNA_NUMERO
		If !Empty(CNB->CNB_ITEMSC)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Retira quantidade atendida da solicitacao de compra³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SC1")
			dbSetOrder(1)
			If dbSeek(cFilCod+CNB->CNB_NUMSC+CNB->CNB_ITEMSC)
				RecLock("SC1")
				SC1->C1_QUJE-=If(CNB->CNB_QUANT>CNB->CNB_QTDSOL,CNB->CNB_QTDSOL,CNB->CNB_QUANT)
				//-- Desbloqueia Solicitacao de Compras
				If SC1->C1_QUJE <= 0
					SC1->C1_FLAGGCT := ""
				EndIf
				MsUnlock()
			EndIf
		EndIf
		
		RecLock("CNB", .F.)
		dbDelete()
		MsUnLock()
		dbSelectArea("CNB")
		dbSkip()
	EndDo
EndIf

If !Empty(CNA->CNA_CRONOG)
	dbSelectArea("CNF")
	dbSetOrder(2)
	cFilCod := xFilial("CNF")
	dbSeek(cFilCod+CNA->CNA_CONTRA+CNA->CNA_REVISA+CNA->CNA_CRONOG)
	
	//Apaga cronograma referente a planilha
	While !CNF->(Eof()) .And. CNF->CNF_FILIAL == cFilCod .And. CNF->CNF_CONTRA == CNA->CNA_CONTRA .And. CNF->CNF_REVISA == CNA->CNA_REVISA .And. CNF->CNF_NUMERO == CNA->CNA_CRONOG
		RecLock("CNF",.F.)
		dbDelete()
		MsUnlock()
		CNF->(dbSkip())
	EndDo
EndIf

//Atualiza valor inicial,atual e saldo do contrato
//dbSelectArea("CN9")
//If dbSeek(xFilial("CN9")+CNA->CNA_CONTRA+CNA->CNA_REVISA)
//	RecLock("CN9",.F.)
//	CN9->CN9_VLINI -= CNA->CNA_VLTOT
//	CN9->CN9_VLATU -= CNA->CNA_VLTOT
//	CN9->CN9_SALDO -= CNA->CNA_VLTOT
//	MsUnlock()
//EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exclui a amarracao com os conhecimentos                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsDocument( "CNA", CNA->( RecNo() ), 2, , 3 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga cabecalho da planilha                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("CNA")
RecLock("CNA", .F.)
dbDelete()
MsUnLock()

//If cPlani != Nil
//	cPlani := M->CNA_NUMERO
//endif

Return
