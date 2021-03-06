#INCLUDE "CTBC660.ch"
#INCLUDE "Protheus.ch"

#define ALIASDOC	1
#define DATADOC		2
#define NRODOC		3
#define MOEDOC 		4
#define VLRDOC 		5
#define NODIA 		6

STATIC cRetF3Mark := Space(150) 

//altera玢o feita no changeset:74459 
/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘蹸ONFE苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � CTBC660   � Autor 矲ernando Radu Muscalu � Data � 29/08/11 潮�
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 砅rograma para auditoria da contabilidade. Ele demonstrara   潮�
北�          硈e o que foi gerado pelos modulos existe na contabilidade,  潮�
北�          砤ssim como se o que ha na contabilidade tambem possui seu   潮�
北�          砫ocumento correlativo no modulo.						      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   � CTBC660()                                                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros�                                                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   砃il		                                                  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACTB                                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/

//Customiza玢o realizada para exibir auditoria cont醔il sem o uso do Controle Correlativo
//Calandrine Maximiliano
//08_04_2018
User Function UCTBC660()

Local cRetSegOfi	:= ""
Local nOpc 			:= 0

Local aCfgDoc		:= {}
Local aButtons		:= {}                                                          
Local aSays			:= {}
Local aModSel		:= {}

Local bParam		:= {|| aModSel := Ctbc66Param() }
Local bBtnOk		:= {||	Iif(aModSel[4] == "1", aCtbc66Fil := AdmGetFil(), aCtbc66Fil := {cFilAnt} ),;
                            Iif(Empty(aCtbc66Fil),Help(" ",1,"CTBC660",,STR0068,1,0),;  //## "N鉶 foi selecionada nenhuma filial."		
                            (aCfgDoc 	:= CtbCQCLoad(aModSel[1]),;
							CtbC66GenInf(aModSel,aCfgDoc,aResultSet),;
							CtbC66Scr(aModSel[1],aResultSet)) ) }

//Local aResultSet	:= {}	//Veja a documentacao destes array no final do arquivo

Private aResultSet	:= {}	//Veja a documentacao destes array no final do arquivo

Private aCtbc66Moe 	:= CtbC66GMoe()
Private aCtbc66Fil	:= {} 
Private cSelecOrd   := "1"
Private cGetFilDoc  := Space(30)
Private cOnlyAlias  := Space(150)
Private cExceAlias  := Space(150)
Private oOnlyAlias  := Nil
Private oExceAlias  := Nil
Private nSeqUnique  := 0
Private aCabMod		:= {}
Private aCabCtb		:= {}//cabecalho do browse dos dados da contabilidade
Private aTipoMod	:= {}
Private aTipoCtb	:= {}
Private lCheckBo1   := .T.
Private lCheckBo2   := .T.
Private lCheckBo3   := .T.
Private lCheckBo4   := .T.

//MsAguarde({|| CriaCTL()},"Aguarde...","Aguarde...Carregando estruturas (CTL).")
//Alterar CVA e CTL para modo totalmente compartilhado
//CVA o pr髉rio sistema recria
//CTL � populada pela fun玢o acima

//Ignora Controle Correlativo 
/*
cRetSegOfi := GetMv("MV_SEGOFI")

If Empty(cRetSegOfi) .or. alltrim(cRetSegOfi) == "0"
	Help(" ",1,"CTBC660_NODIA",,STR0033,1,0)	 //##"O uso do controle diario (n鷐ero correlativo) est� desabilitado."
	Return()
Endif
*/
	
aAdd(aButtons,{5,.t.,bParam})
aAdd(aButtons,{1,.t.,{|| nOpc := 1, oDlg:End() } })
aAdd(aButtons,{2,.t.,{|| oDlg:End() } })

aAdd(aSays,STR0001)	//## "Programa com o objetivo de demonstrar um comparativo entre"
aAdd(aSays,STR0002)	//## "documentos dos m骴ulos do sistema e a contabilidade."
aAdd(aSays,"")
aAdd(aSays,STR0003) //## "Para tal, em par鈓etros, selecione um ou mais m骴ulos."
aAdd(aSays,STR0004) //## "O per韔do definido ser� considerado para os lan鏰mentos cont醔eis."

FormBatch(STR0005,aSays,aButtons) //## "Relat髍io de Auditoria"

If nOpc == 1
	If !Empty(aModSel)
		If len(aModSel[1]) > 0
			Eval(bBtnOk)
		Else
			Help(" ",1,"CTBC660",,STR0006,1,0)	//#"N鉶 foi selecionado nenhum m骴ulo."
		Endif	
	Else
		Help(" ",1,"CTBC660",,STR0007,1,0)	//#"N鉶 houve parametriza玢o definida."			
	Endif	
Endif	


Return()   

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    矯tbc66Param� Autor 矲ernando Radu Muscalu � Data � 29/08/11 潮�
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o 砊ela de parametrizacao da auditoria. Definicao do periodo   潮�
北�          砫e movimentacoes e de quais modulos se vai auditar.		  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   矯tbc66Param()                                               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros�                                                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   矨rray	- Tipo: A 	                                          潮�
北�          �	Array[1] - Tipo: A => Array com os modulos selecionados	  潮�
北�          �	Array[2] - Tipo: D => data de inicio do periodo     	  潮�
北�          �	de contabilizacao								     	  潮�
北�          �	Array[3] - Tipo: D => data do final do periodo     	  	  潮�
北�          �	de contabilizacao								     	  潮�
北�          �	Array[4] - Tipo: C => Seleciona Filiais?         	  	  潮�
北�          �		"1" = Sim									     	  潮� 
北�          �		"2" = Nao									     	  潮� 
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACTB                                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�

*/
Static Function Ctbc66Param()

Local oDlg
Local oScrLayer		:= fwLayer():New()
Local oPnlDlg		
Local oGrpDlg
Local oGetDI
Local oGetDF
Local oListMod
Local oSelecFil
Local oSelecOrd
Local oSelecMvt
local oCheck

Local aSizeDlg		:= FwGetDialogsize(oMainWnd)
Local aListMod		:= CtbC660LoadMod()
Local aSelected		:= {}
Local aSelecFil		:= {"1="+STR0008,"2="+STR0009}				//Sim###N鉶

Local aSelecMvt		:= {"1="+STR0057,"2="+STR0056,"3="+STR0058}	//N鉶 Conferidos###Conferidos###Todos
Local nHeight		:= aSizeDlg[3] * 0.80
Local nWidth        := aSizeDlg[4] * 0.80
Local nOpc			:= 0

Local cSelecFil		:= "2"
Local cSelecMvt		:= "3"

Local dDataI		:= FirstDay(dDataBase)
Local dDataF		:= LastDay(dDataBase)

Local lCheckNDiv		:=.F.

Local bBtnOk		:= {|| 	Iif( ChkModActive(aListMod), nOpc := 1, nil ),; 
							Iif(nOpc == 1, oDlg:End(),nil) }
Local bBtnCancel	:= {|| oDlg:End()}							
Local bEnchBar		:= {|| EnchoiceBar(oDlg,bBtnOk,bBtnCancel) }

Local oGetFilDoc

Local aSelecOrd   	:= {"1="+STR0008,"2="+STR0009}				//Sim###N鉶

DEFINE MSDIALOG oDlg FROM 0,0 TO nHeight, nWidth TITLE STR0005 PIXEL STYLE DS_MODALFRAME of oMainWnd //## "Relat髍io de Auditoria"

	oScrLayer:init(oDlg,.F.)
	
	oScrLayer:addLine("Linha",100,.t.)
	oScrLayer:addCollumn("Coluna",100,.t.,"Linha")	
	oScrLayer:addWindow("Coluna","Janela",STR0010,100,.f.,.t.,{||},"Linha")	 //## "Parametriza玢o"
    
    oPnlDlg := oScrLayer:getWinPanel("Coluna","Janela","Linha")
	oPnlDlg:FreeChildren()

	nWidth *= 0.488
	nHeight*= 0.12
	
	oGrpDlg := tGroup():New(0,0,nHeight,nWidth,STR0011,oPnlDlg,,,.T.)	//##"Per韔do de Verfica玢o"
	
	@ 15,005 Say STR0012 PIXEL OF oPnlDlg //## "Data Inicial"
	@ 15,045 MsGet oGetDI Var dDataI Size 40,008 PIXEL OF oPnlDlg

	@ 30,005 Say STR0013 PIXEL OF oPnlDlg //## "Data Final"
	@ 30,045 MsGet oGetDF Var dDataF Size 40,008 PIXEL OF oPnlDlg	
	
	@ 15,110 Say STR0014 PIXEL OF oPnlDlg //## "Seleciona Filiais"
	@ 15,160 ComboBox oSelecFil Var cSelecFil Items aSelecFil Size 50,008 PIXEL OF oPnlDlg
	
	@ 30,110 Say "Ordena Doc." PIXEL OF oPnlDlg
	@ 30,160 ComboBox oSelecOrd Var cSelecOrd Items aSelecOrd Size 50,008 PIXEL OF oPnlDlg
	                               
	@ 15,235 Say STR0034 PIXEL OF oPnlDlg //## "Documento j� conferido
	@ 15,305 ComboBox oSelecMvt Var cSelecMvt Items aSelecMvt Size 60,008 PIXEL OF oPnlDlg
		
	@ 30,235 Say "Filtra Documento" PIXEL OF oPnlDlg
	@ 30,305 MsGet oGetFilDoc Var cGetFilDoc PICTURE "@!" Size 60,008 PIXEL OF oPnlDlg	
		
	@ 15,385 Say "Somente Tabelas" PIXEL OF oPnlDlg
	@ 15,435 MsGet oOnlyAlias Var cOnlyAlias F3 "CTLAUD" PICTURE "@!" Size 80,008 PIXEL OF oPnlDlg	
		
	@ 30,385 Say "Exceto Tabelas" PIXEL OF oPnlDlg
	@ 30,435 MsGet oExceAlias Var cExceAlias F3 "CTLAUD" PICTURE "@!" Size 80,008 PIXEL OF oPnlDlg	
		
	@ 45,005 CHECKBOX oCheckNDiv VAR lCheckNDiv Size 100,009 PROMPT STR0060 When (.T.) On Change() Of oPnlDlg //adicionado filtro para n鉶 divergentes //##"Seleciona n鉶 divergentes?"
	
	oGrpDlg2 := tGroup():New(nHeight + 5,0,nHeight+147,nWidth,STR0015,oPnlDlg,,,.T.) //## "M骴ulos"
	                                                        //"Nro Modulo","Descricao","Desc. Extendida"
	                                                        
	@ nHeight + 15,002 ListBox oListMod Fields  HEADER " ",STR0016,STR0017,STR0018 Size nWidth-2,nHeight * 2.30 Pixel Of oPnlDlg ON  dblClick( aListMod[oListMod:nAt][1] := !aListMod[oListMod:nAt][1] , oListMod:Refresh())

	oListMod:lShowHint := .T.
		    
	oListMod:SetArray(aListMod)
		
	oListMod:bLine := {|| {;
							Iif(aListMod[oListMod:nAT,01], LoadBitmap(GetResources(),"CHECKED") , LoadBitmap(GetResources(), "UNCHECKED") ),;
							aListMod[oListMod:nAT,02],;
							aListMod[oListMod:nAT,03],;
							aListMod[oListMod:nAT,04]}}
    
	oListMod:bHeaderClick := {|| Ctbc66ChkAll(aListMod,oListMod)}	   	
oDlg:Activate(,,,.T.,,,bEnchBar)

If nOpc == 1
	aEval(aListMod,{|x| Iif(x[1], aAdd(aSelected,{strzero(x[2],2),x[4]}),nil) })	
Endif

Return({aSelected,dDataI,dDataF,cSelecFil,cSelecMvt,lCheckNDiv})

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲un噮o    矯tbc66ChkAll� Autor 矲ernando Radu Muscalu � Data � 29/08/11 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri噮o 矼arcacao e desmarcacao dos modulos 					       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe   矯tbc66ChkAll(aListMod,oListMod)                              潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros砤ListMod	- Tipo: A => Lista dos modulos                     潮�
北�          硂ListMod	- Tipo: O => Objeto ListBox 	                   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砃il			 	                                           潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北� Uso      � SIGACTB                                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌

*/
Static Function Ctbc66ChkAll(aListMod,oListMod)

Local nI		:= 0
Local nQtdOn	:= 0

aEval(aListMod,{|x| If(x[1],nQtdOn++,nil) })

For nI := 1 to len(aListMod)
	
	If aListMod[nI,1] .and. nQtdOn == len(aListMod) 
		aListMod[nI,1] := .f.	
	Else
		aListMod[nI,1] := .t.
	Endif
	
Next nI

oListMod:Refresh()

Return()

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲un噮o    矯hkModActive� Autor 矲ernando Radu Muscalu � Data � 29/08/11 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri噮o 砎alida se ha pelo menos UM modulo selecionado			       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe   矯hkModActive(aListMod)		                               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros砤ListMod	- Tipo: A => Lista dos modulos                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砽Ret	- Tipo: L => .t., validado                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北� Uso      � SIGACTB                                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
Static Function ChkModActive(aListMod)

Local nI	:= 0

Local lRet	:= .f.

For nI := 1 to len(aListMod) 
	If aListMod[nI,1]
		lRet := .t.
		Exit
	Endif	
Next nI

If !lRet
	Help(" ",1,"ChkModActive",,STR0006,1,0)	//#"N鉶 foi selecionado nenhum m骴ulo."
Endif

Return(lRet)


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲un噮o    矯tbC660LoadMod� Autor 矲ernando Radu Muscalu � Data � 29/08/11 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri噮o 矼onta a lista de modulos que integram com a contabilidade	     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe   矯tbC660LoadMod()				                                 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros�        	                                                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砤Ret	- Tipo: A => Lista dos modulos                           潮�
北�          �	aRet[n,1]- Tipo: L => Se possui selecao ou nao, .t., possui  潮�
北�          �	aRet[n,2]- Tipo: N => nro do modulo						     潮�
北�          �	aRet[n,3]- Tipo: C => Descricao curta do modulo			     潮�
北�          �	aRet[n,5]- Tipo: C => Descricao extendida do modulo	 	     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北� Uso      � SIGACTB                                                       潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
Static function CtbC660LoadMod() 

Local cQry 		:= "SELECT DISTINCT CVA_MODULO FROM " + RetSQlName("CVA") + " WHERE D_E_L_E_T_ = ' ' ORDER BY CVA_MODULO "

Local aModulo	:= RetModName()
Local aRet		:= {}

Local nPos		:= 0

cQry := ChangeQuery(cQry)

If Select("TRBCVA") > 0
	TRBCVA->(DbCloseArea())  
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry), "TRBCVA", .T., .F.)

While TRBCVA->(!eof())      

	If ( nPos :=  aScan(aModulo,{|x| x[1] == Val(TRBCVA->CVA_MODULO) }) ) > 0
		aAdd(aRet, {.f.,aModulo[nPos,1],aModulo[nPos,2],aModulo[nPos,3]} )
	Endif

	TRBCVA->(DbSkip())
EndDo

/*
If ( nPos :=  aScan(aModulo,{|x| alltrim(x[2]) == "SIGACTB" }) ) > 0
	aAdd(aRet, {.f.,aModulo[nPos,1],aModulo[nPos,2],aModulo[nPos,3]} )
Endif
*/

TRBCVA->(DbCloseArea())

Return(aRet)

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲un噮o    矯tbC66GenInf  � Autor 矲ernando Radu Muscalu � Data � 29/08/11 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri噮o 矯arrega em memoria as informacoes necessarias para  o relatorio潮�
北�          砫e auditoria.													 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe   矯tbC66GenInf(aParams,aCfgDoc,aResult)                          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros砤Params	- tipo: A => Parametros deifinidos pelo usuario      潮�
北�          砤CfgDoc	- tipo: A => Configuracao do arquivo do modulo       潮�
北�          砤Result	- tipo: A => Array com os dados dos comparativos     潮�
北�          砿odulo X contabilidade									     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砤Ret	- Tipo: A => Lista dos modulos                           潮�
北�          �	aRet[n,1]- Tipo: L => Se possui selecao ou nao, .t., possui  潮�
北�          �	aRet[n,2]- Tipo: N => nro do modulo						     潮�
北�          �	aRet[n,3]- Tipo: C => Descricao curta do modulo			     潮�
北�          �	aRet[n,5]- Tipo: C => Descricao extendida do modulo	 	     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北� Uso      � SIGACTB                                                       潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
Static Function CtbC66GenInf(aParams,aCfgDoc,aResult)

Local nP		:= 0
Local nI		:= 0
Local nX		:= 0

Local aSelected 	:= aClone(aParams[1])
                                                        
Local cDtIni		:= dtos(aParams[2])		//Data Inicial
Local cDtfim		:= dtos(aParams[3])     //Data Final
Local cSelecMvt   := aParams[5]           //Movimentos
local lCheckNDiv	:= aParams[6]			//Mostra n鉶 divergentes
Local cNameFil		:= ""

QryTabMod(aSelected)

For nI := 1 to len(aCtbc66Fil)
	
    cNameFil := Alltrim(SM0->(GetAdvFVal("SM0","M0_FILIAL",cEmpAnt+aCtbc66Fil[nI],1,"")))
	
	aAdd(aResult,{aCtbc66Fil[nI]+"|"+cNameFil,Nil})	
	
	aResult[nI,2]  := {}
	
	For nX := 1 to len(aSelected)
		aAdd(aResult[nI,2],{aSelected[nX,1]+"|"+aSelected[nX,2],nil,nil})	
	Next nX	
	
	
	If Select("TRBCTL") > 0
    
		TRBCTL->(DbGoTop())      
	    
		While TRBCTL->(!Eof())  
			nP := aScan(aCfgDoc,{|x| alltrim(x[ALIASDOC]) == Alltrim(TRBCTL->CTL_ALIAS) })
 		    
			If nP > 0      
            	//MsgRun(OemToAnsi(STR0001),OemToAnsi(STR0002),{|| CtbTabelas() }) // "Carregando as configura珲es do M骴ulo Contabilidade Gerencial" ## "Aguarde"
				MsgRun(STR0019 + Alltrim(aCtbc66Fil[nI]) + STR0020 + Alltrim(TRBCTL->CVA_MODULO),STR0021, {|| FillInfMod(TRBCTL->CTL_ALIAS,cDtIni,cDtfim,aCfgDoc[nP],aResult[nI,2],TRBCTL->CVA_MODULO,aCtbc66Fil[nI],cSelecMvt,lCheckNDiv) } ) //##"Extraindo dados Filial "#" m骴ulo "#"Aguarde..."				  				  				
			Endif              
            
			TRBCTL->(Dbskip())  
		EndDo
	  
	Endif

	If aScan(aSelected,{|x| alltrim(x[1]) == "34"}) > 0
		MsgRun(STR0022 + alltrim(aCtbc66Fil[nI]),STR0021, {|| FillInfCtb(cDtIni,cDtfim,aResult[nI,2],aCtbc66Fil[nI],cSelecMvt) } )//##"Extraindo dados da contabilidade, filial "
	Endif
	
	Ctbc66FillBlank(aResult[nI,2])
	
Next nI


TRBCTL->(DbCloseArea())

Return()

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪目北
北矲un噮o    砆ryTabMod	    � Autor 矲ernando Radu Muscalu � Data � 29/08/11 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪拇北
北矰escri噮o 矼onta arquivo temporario com as tabelas utilizadas nos LPs     潮�
北�          砫os modulos selecionados										 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe   砆ryTabMod(aSelected)					                         潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros砤Selected	- tipo: A => Lista dos modulos selecionados	         潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砃il															 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北� Uso      � SIGACTB                                                       潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
Static Function QryTabMod(aSelected)

Local cQry 			:= ""
Local cRetMod   	:= GetClauseInArray(aSelected)

cQry := "SELECT " + chr(13) + chr(10)
cQry += "	DISTINCT CTL_ALIAS, " + chr(13) + chr(10)
cQry += "	CVA_MODULO " + chr(13) + chr(10)
cQry += "FROM " + chr(13) + chr(10)
cQry += "	" + RetSQLName("CVA") + " CVA " + chr(13) + chr(10)
cQry += "INNER JOIN " + chr(13) + chr(10)
cQry += "	" + RetSQLName("CTL") + " CTL " + chr(13) + chr(10)
cQry += "ON " + chr(13) + chr(10)
cQry += "	CTL.D_E_L_E_T_ = ' '  " + chr(13) + chr(10)
cQry += "	AND " + chr(13) + chr(10)
cQry += "	CTL_FILIAL = CVA_FILIAL " + chr(13) + chr(10)
cQry += "	AND " + chr(13) + chr(10)
cQry += "	CTL_LP = CVA_CODIGO	 " + chr(13) + chr(10)
cQry += "WHERE " + chr(13) + chr(10)
cQry += "	CVA.D_E_L_E_T_ = ' ' " + chr(13) + chr(10)
cQry += "	AND " + chr(13) + chr(10)
cQry += "	CVA_MODULO " + cRetMod + chr(13) + chr(10)
cQry += "ORDER BY " + chr(13) + chr(10)
cQry += "	CVA_MODULO, " + chr(13) + chr(10)
cQry += "	CTL_ALIAS "

cQry := ChangeQuery(cQry)

If Select("TRBCTL") > 0
	TRBCTL->(DbCloseArea())  
Endif                                                     	

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry), "TRBCTL", .T., .F.)

Return()


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噮o    矲illInfMod	� Autor 矲ernando Radu Muscalu � Data � 29/08/11  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噮o 矴era massa de dados em memoria de acordo com o modulo e tabela. 潮�
北�          矱sta massa de dado corresponde tanto do lancamento quanto do    潮�
北�          砫ocumento gerador (lado do modulo)							  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   矲illInfMod(cAlias,cDtIni,cDtfim,aConfig,aResult,cMod,cFilSelect)潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros砪Alias	- Tipo: C => Alias da tabela a ser analisada          潮�
北�          砪DtIni	- Tipo: C => Data inicial do periodo			      潮�
北�          砪DtFim	- Tipo: C => Data final do periodo				      潮�
北�          砤Config	- Tipo: A => Campos utilizados pela Tabela		      潮�
北�          砤Result	- Tipo: A => Array com os dados comparativo Modulo X  潮�
北�          砪Mod		- Tipo: C => Codigo do Modulo						  潮�
北�          砪FilSelect- Tipo: C => Filiais selecionadas					  潮�        
北�          砪SelecMvt - Tipo: C => Filtrar movimentos.					  潮�  
北�          砽CheckNDiv - Tipo: L => Filtrar n鉶 Divergente.				  潮�             
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   砃il									                          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACTB                                                        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function FillInfMod(cAlias,cDtIni,cDtfim,aConfig,aResult,cMod,cFilSelect,cSelecMvt,lCheckNDiv)
Local cQry			:= ""
Local cSelectEnt	:= "" 
Local cMoeMod		:= ""
Local cBmpLeg		:= ""
Local cIdFil		:= GetFieldFil(cAlias)
Local cDataDoc		:= ""
Local cNroDoc		:= Alltrim(StrTran(aConfig[NRODOC],"+",","+space(1) ) ) + ", "
Local cMoeDoc		:= ""
Local cVlrDoc		:= ""
Local cNodia		:= ""
Local aDataMod	:= {}
Local aDataCtb	:= {}
Local aDataCV3	:= {}
Local aVlrMCtb	:= {}
Local aEntities := Ctbc66RetEnt()                        
Local nP		:= 0
Local nI		:= 0
Local nX		:= 0
Local nQtdEnt	:= len(aEntities[1])
Local lCond1
Local lCond2
Local lCond3
Local lCond4

If (!Empty(cOnlyAlias).And. !cAlias $ cOnlyAlias) .Or. (!Empty(cExceAlias) .And. cAlias $ cExceAlias) 
	Return
EndIf

cFilSelect:=xfilial(TRBCTL->CTL_ALIAS,cFilSelect)

For nI := 1 to nQtdEnt
	cSelectEnt += alltrim(aEntities[1][nI,1])+ ", " + alltrim(aEntities[2][nI,1]) + ", " 
Next nI

If "NO_" $ Upper(aConfig[DATADOC])
	cDataDoc := "	' ' " + aConfig[DATADOC] + ", "
Else
	cDataDoc := "	" + aConfig[DATADOC] + ", "
Endif	        

If "NO_" $ Upper(cNroDoc)
	cNroDoc := "	' ' " + cNroDoc 
Else
	cNroDoc := "	" + cNroDoc 
Endif

If "NO_" $ Upper(aConfig[MOEDOC])
	cMoeDoc := "	'01' " + aConfig[MOEDOC]+ ", "
Else
	cMoeDoc := "	" + aConfig[MOEDOC]+ ", "
Endif

If "NO_" $ Upper(aConfig[VLRDOC])
	cVlrDoc := "	0 " + aConfig[VLRDOC]+ ", "
Else	
	cVlrDoc := "	" + aConfig[VLRDOC]+ ", "
Endif

If "NO_" $ Upper(aConfig[NODIA])	
	cNodia := "	' ' " + aConfig[NODIA]+ ", "
Else	
	cNodia := "		" + aConfig[NODIA]+ ", "
Endif

cQry := "SELECT "
cQry += cIdFil + ", "
cQry += cDataDoc
cQry += cNroDoc
cQry += cMoeDoc
//cQry += cVlrDoc
cQry += "CV3_VLR01 " + aConfig[VLRDOC] + ","
cQry += cNodia
cQry += "	" + cAlias + ".D_E_L_E_T_ DELETADO, "
cQry += "	CT2.R_E_C_N_O_ CT2_RECNO,  "
cQry += "	CT2_FILIAL,  "
cQry += "	CT2_DATA,  "
cQry += "	CT2_TPSALD,  "
cQry += "	CT2_LOTE,  "
cQry += "	CT2_SBLOTE, "
cQry += "	CT2_DOC, "
cQry += "	CT2_SEQLAN,  "
cQry += "	CT2_LINHA,  "
cQry += "	CT2_MOEDLC, "
cQry += "	CT2_LP,  "
cQry += "	CT2_NODIA,  "
cQry += "	CT2_DEBITO,  "
cQry += "	CT2_CREDIT,  "
cQry += "	CT2_CCD,  "
cQry += "	CT2_CCC,  "
cQry += "	CT2_ITEMD,  "
cQry += "	CT2_ITEMC,  "
cQry += "	CT2_CLVLDB,  "
cQry += "	CT2_CLVLCR,  "
cQry += cSelectEnt 
cQry += "	CT2_VALOR,  "
cQry += "	CT2_SEQUEN, "
cQry += "	CT2_DC, "
cQry += "	CT2_CONFST, "
cQry += "	CT2.D_E_L_E_T_ CT2_DELET  "
cQry += "FROM " + RetSQlName("CT2") + " CT2 "
cQry += "INNER JOIN " + RetSqlName("CV3") + " CV3 ON CV3_FILIAL = '" + cFilSelect + "'"  
cQry += " AND CV3_RECDES = CAST(CT2.R_E_C_N_O_ AS CHAR(17))" 
cQry += " AND CV3.D_E_L_E_T_ = ' ' " 

cQry += "INNER JOIN " + RetSqlName(cAlias) + " " + cAlias + " ON " + cIdFil + " = '" + cFilSelect + "'"
cQry += " AND CV3_RECORI = CAST(" + cAlias + ".R_E_C_N_O_ AS CHAR(17))" 
cQry += " AND " + cAlias + ".D_E_L_E_T_= ' '" 

//Ignora t韙ulos com origem espec韋icas
If cAlias == "SE1"
	cQry += " AND E1_ORIGEM NOT LIKE 'MATA%' 
EndIf

//Ignora t韙ulos com origem espec韋icas
If cAlias == "SE2"
	cQry += " AND E2_ORIGEM NOT LIKE 'MATA%' 
EndIf
	
cQry += "INNER JOIN  " + RetSQLName("CTL") + " CTL ON CTL_FILIAL = '" + xFilial("CTL") + "'"
cQry += " AND CTL_LP = CT2_LP AND CTL_ALIAS = '"+cAlias+"' AND CTL.D_E_L_E_T_ = ' ' " 

cQry += "INNER JOIN " + RetSqlName("CVA") + " CVA ON CVA_FILIAL = '" + xFilial("CVA") + "'" 
cQry += " AND CVA_MODULO = '"+cMod+"' AND CVA_CODIGO = CT2_LP AND CVA.D_E_L_E_T_ = ' ' " 
	
cQry += "WHERE CT2_FILIAL = '" + cFilSelect + "' " 
cQry += "	AND CT2_DC <> '4' " 
cQry += "	AND CT2_MOEDLC = '01' " 
cQry += "	AND CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"'	 " 
cQry += "	AND CT2_CONFST IN (' ','1','2') " 
cQry += "	AND CT2.D_E_L_E_T_ = ' ' " 

If !Empty(cGetFilDoc)
	cCampos := StrTran(AllTrim(cNroDoc),",","||")
	cCampos := SubStr(cCampos,1,Len(cCampos)-2)	
	cQry += " AND " + cCampos + " LIKE '%" + AllTrim(cGetFilDoc) + "%'" 
EndIf

cQry += "UNION " 

//Monta o lado do M骴ulo que n鉶 tem refer阯cia na Contabilidade
cQry += "SELECT "
cQry += cIdFil + ", " 
cQry += cDataDoc
cQry += cNroDoc
cQry += cMoeDoc
cQry += cVlrDoc
cQry += cNodia
cQry += "	" + cAlias + ".D_E_L_E_T_ DELETADO, "  
cQry += "	CT2.R_E_C_N_O_ CT2_RECNO,  "
cQry += "	CT2_FILIAL,  "
cQry += "	CT2_DATA,  "
cQry += "	CT2_TPSALD,  "
cQry += "	CT2_LOTE,  "
cQry += "	CT2_SBLOTE, "
cQry += "	CT2_DOC, "
cQry += "	CT2_SEQLAN,  "
cQry += "	CT2_LINHA,  "
cQry += "	CT2_MOEDLC, "
cQry += "	CT2_LP,  "
cQry += "	CT2_NODIA,  "
cQry += "	CT2_DEBITO,  "
cQry += "	CT2_CREDIT,  "
cQry += "	CT2_CCD,  "
cQry += "	CT2_CCC,  "
cQry += "	CT2_ITEMD,  "
cQry += "	CT2_ITEMC,  "
cQry += "	CT2_CLVLDB,  "
cQry += "	CT2_CLVLCR,  "
cQry += cSelectEnt 
cQry += "	CT2_VALOR,  "
cQry += "	CT2_SEQUEN, "
cQry += "	CT2_DC, "
cQry += "	CT2_CONFST, "
cQry += "	CT2.D_E_L_E_T_ CT2_DELET  "
cQry += "FROM " + RetSqlName(cAlias) + " " + cAlias 

cQry += " LEFT JOIN " + RetSQlName("CT2") + " CT2 ON 1=2 "
cQry += " WHERE " + cIdFil + " = '" + cFilSelect + "' " 

//Filtrar por data no arquivo Origem, ex: F1_EMISSAO, F2_EMISSAO
If ! "NO_DATA" $ cDataDoc
	cDataDoc := StrTran(cDataDoc,",","")
	cQry += " AND "
    cQry += cDataDoc + " BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' " 
EndIf
cQry += " AND " + cAlias + ".D_E_L_E_T_ = ' ' "

//Ignora t韙ulos com origem espec韋icas
If cAlias == "SE1"
	cQry += " AND E1_ORIGEM NOT LIKE 'MATA%' 
EndIf

//Ignora t韙ulos com origem espec韋icas
If cAlias == "SE2"
	cQry += " AND E2_ORIGEM NOT LIKE 'MATA%' 
EndIf

cQry += " AND NOT EXISTS(SELECT * 
cQry += " FROM " + RetSQlName("CV3") + " CV3 "

cQry += " INNER JOIN " + RetSqlName("CT2") + " CT2 ON CV3_FILIAL = '" + cFilSelect + "'" 	
cQry += " AND CAST(CT2.R_E_C_N_O_ AS CHAR(17)) = CV3_RECDES"
cQry += " AND CT2.D_E_L_E_T_ = ' '"

cQry += " INNER JOIN  " + RetSQLName("CTL") + " CTL ON CTL_FILIAL = '" + xFilial("CTL") + "'"
cQry += "   AND CTL_LP = CT2_LP AND	 CTL_ALIAS = '"+cAlias+"' AND CTL.D_E_L_E_T_ = ' ' "

cQry += " INNER JOIN " + RetSqlName("CVA") + " CVA ON CVA_FILIAL = '" + xFilial("CVA") + "'"
cQry += "  AND CVA_MODULO = '"+cMod+"' AND CVA_CODIGO = CT2_LP AND CVA.D_E_L_E_T_ = ' '"
	
cQry += " WHERE CV3_FILIAL = '" + cFilSelect + "' " 
cQry += " AND CV3_RECORI = CAST(" + cAlias+ ".R_E_C_N_O_ AS CHAR(17))"      
cQry += " AND CV3_TABORI = '" + cAlias + "' "
cQry += " AND CV3.D_E_L_E_T_ = ' ') " 

If !Empty(cGetFilDoc)
	cCampos := StrTran(AllTrim(cNroDoc),",","||")
	cCampos := SubStr(cCampos,1,Len(cCampos)-2)	
	cQry += " AND " + cCampos + " LIKE '%" + AllTrim(cGetFilDoc) + "%'" 
EndIf

cQry += "ORDER BY "

If cSelecOrd == "1" //Ordena pelo Documento
	cCampos  := AllTrim(cNroDoc)
	cCampos  := SubStr(cCampos,1,Len(cCampos)-1)	
	nCampos  := Len(StrToKarr(cCampos, ",")) 
	cOrderBy := ""
	
	For nX := 1 To nCampos
		cOrderBy += Iif(!Empty(cOrderBy),",","") + cValToChar(nX+2)	
	Next nX
	cQry += cOrderBy
Else
	cQry += "	CT2_FILIAL,  "
	cQry += "	CT2_DATA,  "
	cQry += "	CT2_LOTE,  "
	cQry += "	CT2_SBLOTE,  "
	cQry += "	CT2_DOC,  "
	cQry += "	CT2_LINHA,  "
	cQry += "	CT2_SEQLAN  "
EndIf

//cQry := ChangeQuery(cQry)

If Select("TRBCTB") > 0
	TRBCTB->(DbCloseArea())  
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry), "TRBCTB", .T., .F.)
TcSetField( "TRBCTB", aConfig[VLRDOC], "N", TamSx3("CT2_VALOR")[1], TamSx3("CT2_VALOR")[2] )
   
TRBCTB->(DbGotop())

If TRBCTB->(!eof())
	While TRBCTB->(!eof())
		nSeqUnique++
		
		aDataCV3 := Ctbc66CV3(TRBCTB->CT2_DATA,TRBCTB->CT2_SEQUEN,TRBCTB->CT2_SEQLAN,cFilSelect,TRBCTB->CT2_RECNO)
		nStatus := Ctbc66GRsc(,,"TRBCTB",2,aDataCV3,aConfig,@cBmpLeg)
		// monta condi珲es apartir do Filtro
		lcond1:= (cSelecMvt == "2" 	.AND. nStatus == 3)
		lcond2:= (cSelecMvt == "1" 	.AND. (nStatus == 1 .OR. nStatus == 2))
		lcond3:= (cSelecMvt == "3"	.AND. nStatus != 0)
		lcond4:= (lCheckNDiv	.AND. nStatus == 0)
			
		If !Empty(TRBCTB->&(aConfig[NRODOC])) .OR. !Empty(TRBCTB->&(aConfig[DATADOC])) .OR. !Empty(TRBCTB->&(aConfig[VLRDOC]))

			if lCond1 .OR. lCond2 .OR. lCond3 .OR. lCond4

				aAdd(aDataMod,cBmpLeg) // reservado para a legenda
				aAdd(aDataMod,TRBCTB->&(cIdFil))
				aAdd(aDataMod,cAlias)
				aAdd(aDataMod,stod(TRBCTB->&(aConfig[DATADOC])))	//data
				aAdd(aDataMod,TRBCTB->&(aConfig[NRODOC]))		//Documento

				If Valtype(TRBCTB->&(aConfig[MOEDOC])) == "N"
					cMoeMod := Alltrim(str(TRBCTB->&(aConfig[MOEDOC])))
				Else
					cMoeMod := Alltrim(TRBCTB->&(aConfig[MOEDOC]))
				Endif

				aAdd(aDataMod,cMoeMod)							//Moeda
				aAdd(aDataMod,TRBCTB->&(aConfig[VLRDOC]))	    //Vrl Doc				
				aAdd(aDataMod,TRBCTB->&(aConfig[NODIA]))		//Correlativo
				aAdd(aDataMod,aDataCV3[1])						//CV3_DEBITO
				aAdd(aDataMod,aDataCV3[2])						//CV3_CREDIT
				aAdd(aDataMod,aDataCV3[3])						//CV3_CCD
				aAdd(aDataMod,aDataCV3[4])						//CV3_CCC
				aAdd(aDataMod,aDataCV3[5])						//CV3_ITEMD
				aAdd(aDataMod,aDataCV3[6])						//CV3_ITEMC
				aAdd(aDataMod,aDataCV3[7])						//CV3_CLVLDB
				aAdd(aDataMod,aDataCV3[8])						//CV3_CLVLCR

				For nI := 1 to len(aDataCV3[9])
					aAdd(aDataMod,aDataCV3[9,nI])
				Next nI

				aAdd(aDataMod,nStatus)							//Adiciona codigo do status SEMPRE ao final do array, pois o relatorio lera o status dessa posicao
			else
				aDataMod := Array(16+(nQtdEnt*2))
				aFill(aDataMod,"")
				aDataMod[1] := LoadBitmap(GetResources(),"BR_VERMELHO")
				aDataMod[7] := 0
				aAdd(aDataMod,nStatus)							//Adiciona codigo do status SEMPRE ao final do array, pois o relatorio lera o status dessa posicao				
			endif
			//aAdd(aDataMod,nSeqUnique)
		Else
			aDataMod := Array(16+(nQtdEnt*2))
			aFill(aDataMod,"")
			aDataMod[1] := LoadBitmap(GetResources(),"BR_VERMELHO")
			aDataMod[7] := 0
			aAdd(aDataMod,nStatus)							//Adiciona codigo do status SEMPRE ao final do array, pois o relatorio lera o status dessa posicao			
		Endif

		If !Empty(TRBCTB->CT2_LOTE)
			aVlrMCtb    := Array(1) //GetValMCT2(TRBCTB->CT2_NODIA,TRBCTB->CT2_SEQLAN,cFilSelect)
			//aVlrMCtb := GetValMCT2(TRBCTB->CT2_RECNO,TRBCTB->CT2_SEQLAN,cFilSelect)
			aVlrMCtb[1] := TRBCTB->CT2_VALOR
			
			aAdd(aDataCtb,TRBCTB->CT2_FILIAL)
			aAdd(aDataCtb,stod(TRBCTB->CT2_DATA))
			aAdd(aDataCtb,TRBCTB->CT2_TPSALD)
			aAdd(aDataCtb,TRBCTB->CT2_LOTE)
			aAdd(aDataCtb,TRBCTB->CT2_SBLOTE)
			aAdd(aDataCtb,TRBCTB->CT2_DOC)
			aAdd(aDataCtb,TRBCTB->CT2_LINHA)
			aAdd(aDataCtb,TRBCTB->CT2_LP)
			aAdd(aDataCtb,TRBCTB->CT2_SEQLAN)
			aAdd(aDataCtb,TRBCTB->CT2_NODIA)
			aAdd(aDataCtb,TRBCTB->CT2_DEBITO)
			aAdd(aDataCtb,TRBCTB->CT2_CREDIT)
			aAdd(aDataCtb,TRBCTB->CT2_CCD)
			aAdd(aDataCtb,TRBCTB->CT2_CCC)
			aAdd(aDataCtb,TRBCTB->CT2_ITEMD)
			aAdd(aDataCtb,TRBCTB->CT2_ITEMC)
			aAdd(aDataCtb,TRBCTB->CT2_CLVLDB)
			aAdd(aDataCtb,TRBCTB->CT2_CLVLCR)

			For nI := 1 to nQtdEnt
				aAdd(aDataCtb,TRBCTB->&(aEntities[1][nI,1]))
				aAdd(aDataCtb,TRBCTB->&(aEntities[2][nI,1]))
			Next nI

			aEval(aVlrMCtb,{|x| aAdd(aDataCtb,x)})

			aAdd(aDataCtb,TRBCTB->CT2_DC)
			
			//Adicionados
			aAdd(aDataCtb,TRBCTB->CT2_RECNO)
			aAdd(aDataCtb,TRBCTB->&(aConfig[NRODOC]))		//Documento para Ordena玢o			
			//aAdd(aDataCtb,nSeqUnique)
		Else
			aDataCtb := Array(20+(nQtdEnt*2)) //+len(aCtbc66Moe)) //Pego somente uma moeda
			aFill(aDataCtb,"")
			For nI := 20+(nQtdEnt*2) to len(aDataCtb)-1
				aDataCtb[nI] := 0
			Next nI
			aAdd(aDataCtb,0)
			aAdd(aDataCtb,TRBCTB->&(aConfig[NRODOC]))		//Documento para Ordena玢o
			//aAdd(aDataCtb,nSeqUnique)			
		Endif
		

		nP := aScan(aResult,{|x| AllTrim(cMod) $ alltrim(x[1]) })

		If nP > 0
			If aResult[nP,2] == nil
				aResult[nP,2] := {}
			Endif

			If aResult[nP,3] == nil
				aResult[nP,3] := {}
			Endif
			if lCond1 .OR. lCond2 .OR. lCond3 .OR. lCond4
				aAdd(aResult[nP,2],aClone(aDataMod))
				aAdd(aResult[nP,3],aClone(aDataCtb))
			EndIf
			aDataMod := {}
			aDataCtb := {}
		Endif
		TRBCTB->(DbSkip())

	EndDo
Endif


If Select("TRBCTB") > 0
	TRBCTB->(DbCloseArea())  
Endif

Return()


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噮o    矲illInfCtb	� Autor 矲ernando Radu Muscalu � Data � 29/08/11  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噮o 矴era massa de dados em memoria de acordo com os lancamentos     潮�
北�          砪ontabeis manuais.								              潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   矲illInfCtb(cDtIni,cDtfim,aResult,cFilSelect)					  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros砪DtIni	- Tipo: C => Data inicial do periodo			      潮�
北�          砪DtFim	- Tipo: C => Data final do periodo				      潮�
北�          砤Result	- Tipo: A => Array com os dados comparativo Modulo X  潮�
北�          矯ontabilidade													  潮�
北�          砪FilSelect- Tipo: C => Filiais selecionadas					  潮�
北�          砪SelecMvt - Tipo: C => seleciona movimentos					  	 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   砃il									                          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACTB                                                        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function FillInfCtb(cDtIni,cDtfim,aResult,cFilSelect,cSelecMvt)

Local cQry			:= ""
Local cSelectEnt    := ""

Local aDataCtb		:= {}
Local aVlrMCtb		:= {}
Local aEntities 	:= Ctbc66RetEnt()

Local nP			:= 0
Local nI			:= 0
Local nQtdEnt		:= len(aEntities[1])

cFilSelect:=xfilial("CT2",cFilSelect)

For nI := 1 to nQtdEnt
	cSelectEnt += alltrim(aEntities[1][nI,1])+ ", " + alltrim(aEntities[2][nI,1]) + ", " 
Next nI

cQry := "SELECT " + chr(13) + chr(10)        
cQry += "	CT2_FILIAL,   " + chr(13) + chr(10)
cQry += "	CT2_DATA,   " + chr(13) + chr(10)
cQry += "	CT2_TPSALD,   " + chr(13) + chr(10)
cQry += "	CT2_LOTE,   " + chr(13) + chr(10)
cQry += "	CT2_SBLOTE,  " + chr(13) + chr(10)
cQry += "	CT2_DOC,  " + chr(13) + chr(10)
cQry += "	CT2_SEQLAN,   " + chr(13) + chr(10)
cQry += "	CT2_LINHA,   " + chr(13) + chr(10)
cQry += "	CT2_MOEDLC,  " + chr(13) + chr(10)
cQry += "	CT2_LP,   " + chr(13) + chr(10)
cQry += "	CT2_NODIA,   " + chr(13) + chr(10)
cQry += "	CT2_DEBITO,   " + chr(13) + chr(10)
cQry += "	CT2_CREDIT,   " + chr(13) + chr(10)
cQry += "	CT2_CCD,   " + chr(13) + chr(10)
cQry += "	CT2_CCC,   " + chr(13) + chr(10)
cQry += "	CT2_ITEMD,   " + chr(13) + chr(10)
cQry += "	CT2_ITEMC,   " + chr(13) + chr(10)
cQry += "	CT2_CLVLDB,   " + chr(13) + chr(10)
cQry += cSelectEnt + chr(13) + chr(10)
cQry += "	CT2_CLVLCR,   " + chr(13) + chr(10)
cQry += "	CT2_VALOR,   " + chr(13) + chr(10)
cQry += "	CT2_SEQUEN,  " + chr(13) + chr(10)
cQry += "	CT2_DC " + chr(13) + chr(10)
cQry += "FROM " + chr(13) + chr(10)
cQry += "	" + RetSQLName("CT2") + " CT2 " + chr(13) + chr(10)
cQry += "WHERE " + chr(13) + chr(10)
cQry += "	CT2_FILIAL = '" + cFilSelect + "' " + chr(13) + chr(10)
cQry += "	AND " + chr(13) + chr(10)
cQry += "	CT2.D_E_L_E_T_ = ' ' " + chr(13) + chr(10)
cQry += "	AND " + chr(13) + chr(10)
cQry += "	CT2_DATA BETWEEN '"+cDtIni+"' AND '"+cDtFim+"' " + chr(13) + chr(10)
cQry += "	AND " + chr(13) + chr(10)
cQry += "	CT2_DC <> '4' " + chr(13) + chr(10)
cQry += "	AND " + chr(13) + chr(10)
cQry += "	CT2_LP < '500' " + chr(13) + chr(10)
cQry += "	AND " + chr(13) + chr(10)
cQry += "	CT2_MOEDLC = '01' " + chr(13) + chr(10)                  

cQry += "	AND " + chr(13) + chr(10)
cQry += "	CT2_CONFST IN (' ','1','2') " + chr(13) + chr(10)

cQry += "ORDER BY " + chr(13) + chr(10)
cQry += "	CT2_DATA,  " + chr(13) + chr(10)
cQry += "	CT2_LOTE, " + chr(13) + chr(10)
cQry += "	CT2_SBLOTE, " + chr(13) + chr(10)
cQry += "	CT2_DOC, " + chr(13) + chr(10)
cQry += "	CT2_LINHA, " + chr(13) + chr(10)
cQry += "	CT2_SEQLAN "

cQry := ChangeQuery(cQry)

If Select("TRBCTB") > 0
	TRBCTB->(DbCloseArea())  
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry), "TRBCTB", .T., .F.)
   
TRBCTB->(DbGotop())

If TRBCTB->(!eof())
	While TRBCTB->(!eof())
				
		aVlrMCtb    := Array(1) //GetValMCT2(TRBCTB->CT2_NODIA,TRBCTB->CT2_SEQLAN,cFilSelect)
		aVlrMCtb[1] := TRBCTB->CT2_VALOR

		aAdd(aDataCtb,TRBCTB->CT2_FILIAL)
		aAdd(aDataCtb,stod(TRBCTB->CT2_DATA))
	    aAdd(aDataCtb,TRBCTB->CT2_TPSALD)
	    aAdd(aDataCtb,TRBCTB->CT2_LOTE)
	    aAdd(aDataCtb,TRBCTB->CT2_SBLOTE)
	    aAdd(aDataCtb,TRBCTB->CT2_DOC)
	    aAdd(aDataCtb,TRBCTB->CT2_LINHA)
	    aAdd(aDataCtb,TRBCTB->CT2_LP)
	    aAdd(aDataCtb,TRBCTB->CT2_SEQLAN)
	    aAdd(aDataCtb,TRBCTB->CT2_NODIA)
	    aAdd(aDataCtb,TRBCTB->CT2_DEBITO)
	    aAdd(aDataCtb,TRBCTB->CT2_CREDIT)
	    aAdd(aDataCtb,TRBCTB->CT2_CCD)
	    aAdd(aDataCtb,TRBCTB->CT2_CCC)
	    aAdd(aDataCtb,TRBCTB->CT2_ITEMD)
	    aAdd(aDataCtb,TRBCTB->CT2_ITEMC)
	    aAdd(aDataCtb,TRBCTB->CT2_CLVLDB)
	    aAdd(aDataCtb,TRBCTB->CT2_CLVLCR)	

	    For nI := 1 to nQtdEnt
	    	aAdd(aDataCtb,TRBCTB->&(aEntities[1][nI,1]))
	    	aAdd(aDataCtb,TRBCTB->&(aEntities[2][nI,1]))
	    Next nI 	
	    
	    aEval(aVlrMCtb,{|x| aAdd(aDataCtb,x)})
	    
	    aAdd(aDataCtb,TRBCTB->CT2_DC)

		TRBCTB->(Dbskip())
		
		nP := aScan(aResult,{|x| "34" $ alltrim(x[1]) })

		If nP > 0
			
			If aResult[nP,3] == nil
				aResult[nP,3] := {}
			Endif	
			
	 		aAdd(aResult[nP,3],aClone(aDataCtb)	)
	 		
	 		aDataCtb := {}
		Endif	
    EndDo
    
Endif                    

If Select("TRBCTB") > 0
	TRBCTB->(DbCloseArea())  
Endif

Return()


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噮o    矯tbC66Scr  	� Autor 矲ernando Radu Muscalu � Data � 29/08/11  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噮o 矼ontagem da interface da quadratura contabil				      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   矯tbC66Scr(aSelected,aResultSet)								  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros砤Selected	- Tipo: A => Modulos selecionados				      潮�
北�          砤ResultSet- Tipo: A => Array com os dados comparativo Modulo X  潮�
北�          矯ontabilidade													  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   砃il									                          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACTB                                                        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function CtbC66Scr(aSelected,aResultSet)

Local oDlg
	
Local oBrwMod 
Local oBrwCtb

Local aSizeDlg		:= FwGetDialogsize(oMainWnd)
Local aButtons		:= {}

Local aFolderFil	:= {}
Local aScrLayer	 	:= {}



Local nHeight		:= aSizeDlg[3]
Local nWidth    	:= aSizeDlg[4]
Local nI			:= 0
Local nX            := 0

Local bBtnOk		:= {|| 	oDlg:End() }
Local bBtnCanc		:= {|| 	oDlg:End() }
Local bEnchBar		:= {||	EnchoiceBar(oDlg,bBtnOk,bBtnCanc,,aButtons) }

//Local oFolderFil
//Local aFModulos		:= {}
//Local aBrwMod		:= {}
//Local aBrwCtb		:= {}

Private oFolderFil
Private aFModulos		:= {}
Private aBrwMod		:= {}
Private aBrwCtb		:= {}

Private oGetLocali := Nil
Private cGetLocali := Space(50)
Private oRadLocali := Nil
Private nRadLocali := 1

Private oGetFiltra := Nil
Private cGetFiltra := Space(50)
Private oRadFiltra := Nil
Private nRadFiltra := 1

Private cContaDMod := ""
Private cContaCMod := ""

Private cContaDCtb := ""
Private cContaCCtb := ""

Private oSayDebMod := Nil
Private oSayCreMod := Nil
Private oSayDebCtb := Nil
Private oSayCreCtb := Nil

aEval(aCtbc66Fil,{|x| aAdd(aFolderFil,x+"-"+ Alltrim(SM0->(GetAdvFVal("SM0","M0_FILIAL",cEmpAnt+x,1,"")))   )})

aAdd(aButtons,{"EDITAR"           ,{|| CT660Conf(oFolderFil,aFModulos,aBrwMod,aBrwCtb,aResultSet)},STR0045})			//"Conferir"
aAdd(aButtons,{"EDITAR"			  ,{|| CT660Reve(oFolderFil,aFModulos,aBrwMod,aBrwCtb,aResultSet)},STR0046})			//"Reverter"
aAdd(aButtons,{"VISUAL"			  ,{|| CT660Dive(oFolderFil,aFModulos,aBrwMod,aBrwCtb,aResultSet)},STR0047})			//"Divergencias"
//aAdd(aButtons,{"TOTVSPRINTER_LOGO",{|| CTBR660A(aResultSet)}   ,STR0023})		//"Imprimir"
aAdd(aButtons,{"S4WB011N"         ,{|| CTBC66Leg()}           ,STR0024})		//"Legenda"
//aAdd(aButtons,{"Localizar"        ,{|| Localizar()},"Localizar (F4)"})
aAdd(aButtons,{"Filtrar"          ,{|| Filtrar()},"Filtrar (F4)"})

Set Key VK_F4 To Filtrar()

DEFINE MSDIALOG oDlg FROM 0,0 TO nHeight-20, nWidth-30 TITLE STR0005 PIXEL STYLE DS_MODALFRAME of oMainWnd //## "Relat髍io de Auditoria"
    
    oFolderFil := TFolder():New(031,0,aFolderFil,aFolderFil,oDlg,,,,.T.,,nWidth/2-15,(nHeight/2)-60) //20)
    oFolderFil:bChange := {|| ChangeCT1()}
	aFModulos := CtbC66FMod(oFolderFil,aSelected)
    aScrLayer := CtbC66Layer(aFModulos)
	                                
	@ (nHeight/2)-27, 010 SAY oSayDebMod PROMPT "D閎ito   " + cContaDMod SIZE 220, 010 OF oDlg COLORS 255, 16777215 PIXEL
	@ (nHeight/2)-17, 010 SAY oSayCreMod PROMPT "Cr閐ito  " + cContaCMod SIZE 220, 010 OF oDlg COLORS 16711680, 16777215 PIXEL
	
	@ (nHeight/2)-27, nWidth/4 SAY oSayDebCtb PROMPT "D閎ito   " + cContaDCtb SIZE 220, 010 OF oDlg COLORS 255, 16777215 PIXEL
	@ (nHeight/2)-17, nWidth/4 SAY oSayCreCtb PROMPT "Cr閐ito  " + cContaCCtb SIZE 220, 010 OF oDlg COLORS 16711680, 16777215 PIXEL	
		                    	                                                      
	CtbC66Load(aScrLayer,oFolderFil,aFModulos,aBrwMod,aBrwCtb,aResultSet)
	
oDlg:Activate(,,,.T.,,,bEnchBar)

Return()

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噮o    矯tbC66FMod  	� Autor 矲ernando Radu Muscalu � Data � 29/08/11  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噮o 矼ontagem das abas dos modulos selecionados.					  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   矯tbC66FMod(oFolderFil,aSelected)								  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros硂FolderFil- Tipo: O => Objeto da Folder das Filiais 			  潮�
北�          砤Selected	- Tipo: A => Modulos selecionados				      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   砤RetMod	- Tipo: A => Array com os objetos tFolder dos         潮�
北�          砿odulos de acordo com as filiais						          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACTB                                                        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function CtbC66FMod(oFolderFil,aSelected)

Local aRetMod	:= array(len(oFolderFil:aDialogs))
Local aFolder	:= {}
Local aSizeDlg	:= {}

Local nI		:= 0
Local nWidth	:= 0
Local nHeight	:= 0

//Montagem dos Folders de acordo com os modulo selecionados
For nI := 1 to len(aSelected)
	aAdd(aFolder,alltrim(aSelected[nI,1])+"-"+alltrim(aSelected[nI,2]))
Next nI

For nI := 1 to len(aRetMod)

	aSizeDlg := FwGetDialogsize(oFolderFil:aDialogs[nI])

	nHeight		:= aSizeDlg[3]-52
	nWidth    	:= aSizeDlg[4]
	
	aRetMod[nI] := TFolder():New(0,0,aFolder,aFolder,oFolderFil:aDialogs[nI],,,,.T.,,nWidth/2-15,nHeight/2-55)
	aRetMod[nI]:bChange := {|| ChangeCT1()}	
		
Next nI

Return(aRetMod)

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噮o    矯tbC66Layer  	� Autor 矲ernando Radu Muscalu � Data � 29/08/11  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噮o 矼ontagem das layers.											  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   矯tbC66Layer(aFModulos)										  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros砤FModulos	- Tipo: A => Array com os objetos tfolders dos Modulos潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   砤Layers	- Tipo: A => Array com os objetos das layers	      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACTB                                                        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function CtbC66Layer(aFModulos)

Local cSufix	:= ""

Local nI		:= 0
Local nX		:= 0

Local aAuxLay	:= {}
Local aLayers	:= {}

For nI := 1 to len(aFModulos)
	
	aAuxLay := array(len(aFModulos[nI]:aDialogs))	
	
	For nX := 1 to len(aAuxLay)
		
		aAuxLay[nX] := fwLayer():New()

		aAuxLay[nX]:init(aFModulos[nI]:aDialogs[nX],.F.)	
			
		aAuxLay[nX]:addLine("Linha"+cSufix,100,.t.)           
		
		aAuxLay[nX]:addCollumn("ColMod"+cSufix,50,.t.,"Linha"+cSufix)
		aAuxLay[nX]:addCollumn("ColCtb"+cSufix,50,.t.,"Linha"+cSufix)
			
		aAuxLay[nX]:addWindow("ColMod"+cSufix,"WinMod"+cSufix,aFModulos[nI]:aDialogs[nX]:cCaption,100,.f.,.t.,{||},"Linha"+cSufix)
		aAuxLay[nX]:addWindow("ColCtb"+cSufix,"WinCtb"+cSufix,"34-"+STR0025 ,100,.f.,.t.,{||},"Linha"+cSufix)//##"Contabilidad de Gestion"			
	Next nX
	
	aAdd(aLayers,aClone(aAuxLay))
	aAuxLay := {}		
Next nI

Return(aLayers)               


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪目北
北矲un噮o    矯tbC66Load  	� Autor 矲ernando Radu Muscalu � Data � 29/08/11   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪拇北
北矰escri噮o 矼ontagem das abas dos modulos selecionados.					   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe   矯tbC66Load(aScrLayer,oFolderFil,aFModulos,aBrwMod,aBrwCtb,	   潮�
北�          砤ResultSet)													   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros砤ScrLayer	- Tipo: A => Array com os objetos das layers		   潮�
北�          硂FolderFil- Tipo: O => Objeto da Folder das Filiais 			   潮�
北�          砤FModulos	- Tipo: A => Array com os objetos tfolders dos Modulos 潮�
北�          砤BrwMod	- Tipo: A => Array com os objetos twBrowses dos Modulos潮�
北�          砤BrwCtb	- Tipo: A => Array com os objetos twBrowses do CTB	   潮�
北�          砤ResultSet- Tipo: A => Array com os dados comparativo Modulo X   潮�
北�          矯ontabilidade													   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砃il													           潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北� Uso      � SIGACTB                                                         潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
Static Function CtbC66Load(aScrLayer,oFolderFil,aFModulos,aBrwMod,aBrwCtb,aResultSet)

Local oPnlMod 
Local oPnlCtb

Local nI			:= 0
Local nX			:= 0
Local nZ			:= 0

Local cSufix		:= ""
Local cLineMod		:= ""
Local cLineCtb		:= ""

Local aHeadMod		:= CTBC66GetHBrw(1)//cabecalho do browse dos dados do Modulo
Local aHeadCtb		:= CTBC66GetHBrw(2)//cabecalho do browse dos dados da contabilidade
//Local aCabMod		:= {}
//Local aCabCtb		:= {}//cabecalho do browse dos dados da contabilidade
Local aSizeMod		:= {}
Local aSizeCtb		:= {}
//Local aTipoMod		:= {}
//Local aTipoCtb		:= {}
Local aAuxBrwMod	:= {}
Local aAuxBrwCtb	:= {}

aBrwMod	:= Array(len(oFolderFil:aDialogs),len(aFModulos[1]:aDialogs))
aBrwCtb	:= Array(len(oFolderFil:aDialogs),len(aFModulos[1]:aDialogs))

aEval(aHeadMod,{|x| aAdd(aCabMod,x[1]),aAdd(aSizeMod,x[2]),aAdd(aTipoMod,x[3]) })
aEval(aHeadCtb,{|x| aAdd(aCabCtb,x[1]),aAdd(aSizeCtb,x[2]),aAdd(aTipoCtb,x[3]) })

For nI := 1 to len(oFolderFil:aDialogs)
    
	For nX := 1 to len(aFModulos[nI]:aDialogs)
		
			For nZ := 1 to len(aCabMod)
				If aTipoMod[nZ] == "N"
					cLineMod += "Transform(aResultSet["+str(nI)+",2,"+str(nX)+",2][aBrwMod["+str(nI)+","+str(nX)+"]:nAt,"+alltrim(str(nZ))+"],PesqPict('CT2','CT2_VALOR'))," 
				Else	
					cLineMod += "aResultSet["+str(nI)+",2,"+str(nX)+",2][aBrwMod["+str(nI)+","+str(nX)+"]:nAt,"+alltrim(str(nZ))+"]," 
				Endif	
			Next nX			
			cLineMod := Substr(cLineMod,1,len(cLineMod)-1)

			For nZ := 1 to len(aCabCtb)	
				If aTipoCtb[nZ] == "N"
					cLineCtb += "Transform(aResultSet["+str(nI)+",2,"+str(nX)+",3][aBrwCtb["+str(nI)+","+str(nX)+"]:nAt,"+alltrim(str(nZ))+"],PesqPict('CT2','CT2_VALOR')),"
				Else 
					cLineCtb += "aResultSet["+str(nI)+",2,"+str(nX)+",3][aBrwCtb["+str(nI)+","+str(nX)+"]:nAt,"+alltrim(str(nz))+"],"	
				Endif	
			Next nZ                                        			
			cLineCtb := Substr(cLineCtb,1,len(cLineCtb)-1)	
			
			oPnlMod	:= aScrLayer[nI,nX]:getWinPanel("ColMod"+cSufix,"WinMod"+cSufix,"Linha"+cSufix)
			oPnlCtb	:= aScrLayer[nI,nX]:getWinPanel("ColCtb"+cSufix,"WinCtb"+cSufix,"Linha"+cSufix) 
			
			If aBrwMod[nI,nX] == nil
				aBrwMod[nI,nX] := TWBrowse():New(0,0,0,0,,aCabMod,aSizeMod,oPnlMod,,,,,,,,,,,,.F.,,.T.,,.F.,,, )
				aBrwMod[nI,nX]:nFreeze := 1
			endif
			
			If aBrwCtb[nI,nX] == nil
				aBrwCtb[nI,nX] := TWBrowse():New(0,0,0,0,,aCabCtb,aSizeCtb,oPnlCtb,,,,,,,,,,,,.F.,,.T.,,.F.,,, )
			Endif
			if !empty(aResultSet[nI,2,nX,2])
				aBrwMod[nI,nX]:Align := CONTROL_ALIGN_ALLCLIENT
				aBrwCtb[nI,nX]:Align := CONTROL_ALIGN_ALLCLIENT							
				
				aBrwMod[nI,nX]:bChange := &("{|| aBrwCtb["+str(nI)+","+str(nX)+"]:GoPosition(aBrwMod["+str(nI)+","+str(nX)+"]:nAt),ChangeCT1()}")
				aBrwCtb[nI,nX]:bChange := &("{|| aBrwMod["+str(nI)+","+str(nX)+"]:GoPosition(aBrwCtb["+str(nI)+","+str(nX)+"]:nAt),ChangeCT1()}")
								
				//aBrwMod[nI,nX]:bLDblClick := {||  CTC660ConfLanc() }
				
				If cSelecOrd == "1" //Ordena pelo Documento
					aSort(aResultSet[nI,2,nX,2],,,{|x,y| x[5] > y[5]})
					aSort(aResultSet[nI,2,nX,3],,,{|x,y| x[22] > y[22]})
				EndIf				
				aBrwMod[nI,nX]:SetArray(aResultSet[nI,2,nX,2])				
								
				aBrwCtb[nI,nX]:bLDblClick := {||  Rastrear()}				
				aBrwCtb[nI,nX]:SetArray(aResultSet[nI,2,nX,3])
			
				aBrwMod[nI,nX]:bLine := &("{|| {" + cLineMod + "}}")
				aBrwCtb[nI,nX]:bLine := &("{|| {" + cLineCtb + "}}")
		        
				aBrwMod[nI,nX]:nClrBackFocus := 0
				aBrwCtb[nI,nX]:nClrBackFocus := 0
		                                         
				aBrwMod[nI,nX]:nClrForeFocus := 0
				aBrwCtb[nI,nX]:nClrForeFocus := 0
		
				aBrwMod[nI,nX]:Refresh()
				aBrwCtb[nI,nX]:Refresh()
			endif 	
		

		cLineMod := ""
		cLineCtb := ""
		
	Next nX
	
Next nI

Return()

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪目北
北矲un噮o    矴etClauseInArray� Autor 矲ernando Radu Muscalu � Data � 29/08/11   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪拇北
北矰escri噮o 矴era String da clausula IN de um select de query a partir de um 	 潮�
北�          砤rray bidimensional											 	 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe   矴etClauseInArray(aArray,nInd)									     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros砤Array- Tipo: A => dados a serem convertidos 			             潮�
北�          硁Ind	- Tipo: N => Coluna de aArray utilizada na geracao da string 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砪Ret	- Tipo: C => String com a clausula IN			             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北� Uso      � SIGACTB                                                           潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
Static function GetClauseInArray(aArray,nInd)

Local nI 	:= 0

Local cRet	:= ""

Default nInd	:= 1

If Len(aArray) == 1
	cRet := " = "
	cRet += "'" + Alltrim(aArray[1,nInd]) + "'"
Else
	cRet := " IN("
	
	For nI := 1 to len(aArray)
		cRet += "'" + Alltrim(aArray[nI,nInd]) + "',"
	Next nI
	
	cRet := Substr(cRet,1,len(cRet)-1) + ")"
Endif              

Return(cRet) 


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪目北
北矲un噮o    矯TBOrdSIXByChave� Autor 矲ernando Radu Muscalu � Data � 29/08/11   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪拇北
北矰escri噮o 矨traves da chave, busca-se a ordem do indice					 	 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe   矯TBOrdSIXByChave(cAlias,cChave)								     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros砪Alias- Tipo: C => Alias do arquivo								 潮�
北�          砪Cahve- Tipo: C => Chave a ser buscada no SIX						 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   硁Ordem- Tipo: N => Ordem da chave no SIX				             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北� Uso      � SIGACTB                                                           潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
Static Function CTBOrdSIXByChave(cAlias,cChave)

Local nOrdem	:= 0
Local aAreaSIX	:= SIX->(GetArea())

SIX->(DbSetOrder(1))

SIX->(DbSeek(cAlias))

While !SIX->(Eof()) .and. Alltrim(SIX->INDICE) == Alltrim(cAlias)
	If Alltrim(cChave) $ Alltrim(SIX->CHAVE)
		If !IsAlpha(SIX->ORDEM)
			nOrdem := Val(SIX->ORDEM)
		Else                         
			nOrdem := Asc(UPPER(SIX->ORDEM))-55
		Endif	
		Exit
	Endif	
	SIX->(DbSkip())
EndDo

RestArea(aAreaSIX)
Return(nOrdem)


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪目北
北矲un噮o    矯tbcQCLoad	  � Autor 矲ernando Radu Muscalu � Data � 29/08/11   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪拇北
北矰escri噮o 矯arrega os campos necessario para gerar informacoes das tabelas do 潮�
北�          砿odulo gerador dos lancamentos								 	 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe   矯tbcQCLoad(aSelected)											     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros砤Selected- Tipo: A => Modulos selecionados 			             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砤Ret	- Tipo: A => Campos que devem ser utilizados pelas tabelas   潮�
北�          砫o modulo gerador													 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北� Uso      � SIGACTB                                                           潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
Static Function CtbcQCLoad(aSelected)

Local aRet		:= {}
Local aAux		:= {}
Local aAreaSx3	:= SX3->(GetArea())
Local aNrDoc	:= {}

Local cQry		:= ""
Local cRetMod	:= GetClauseInArray(aSelected)
Local cConteudo	:= ""
Local cCampo	:= ""
Local cAuxCont	:= ""

Local lExistX3	:= .f.

Local nI		:= 0
Local nX		:= 0
Local nZ		:= 0
Local nPos		:= 0

cQry := "SELECT " + chr(13) + chr(10)
cQry += "	DISTINCT CTL_ALIAS, " + chr(13) + chr(10)
cQry += "	CTL_QCDATA, " + chr(13) + chr(10)
cQry += "	CTL_QCDOC, " + chr(13) + chr(10)
cQry += "	CTL_QCMOED, " + chr(13) + chr(10)
cQry += "	CTL_QCVLRD, " + chr(13) + chr(10)
cQry += "	CTL_QCCORR " + chr(13) + chr(10)
cQry += "FROM " + chr(13) + chr(10)
cQry += "	" + RetSQLName("CTL") + " CTL " + chr(13) + chr(10)
cQry += "INNER JOIN " + chr(13) + chr(10)
cQry += "	" + RetSQLName("CVA") + " CVA " + chr(13) + chr(10)
cQry += "ON " + chr(13) + chr(10)
cQry += "	CVA_FILIAL = CTL_FILIAL " + chr(13) + chr(10)
cQry += "	AND " + chr(13) + chr(10)
cQry += "	CVA_CODIGO = CTL_LP " + chr(13) + chr(10)
cQry += "	AND " + chr(13) + chr(10)
cQry += "	CVA_MODULO " + cRetMod
cQry += "	AND	 " + chr(13) + chr(10)
cQry += "	CVA.D_E_L_E_T_ = ' ' " + chr(13) + chr(10)
cQry += "WHERE " + chr(13) + chr(10)
cQry += "	CTL.D_E_L_E_T_ = ' ' " + chr(13) + chr(10)

//Adicionado, pois agora os relacionamentos ser鉶 realizados pelos RECNOS de Origem e Destino
cQry += "	AND CTL_QCDATA <> '' " + chr(13) + chr(10)
cQry += "	AND CTL_QCVLRD <> '' " + chr(13) + chr(10)

cQry += "ORDER BY " + chr(13) + chr(10)
cQry += "	CTL_ALIAS  "

cQry := ChangeQuery(cQry)

If Select("TRBCTL") > 0
	TRBCTL->(DbCloseArea())  
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry), "TRBCTL", .T., .F.)

While TRBCTL->(!Eof())

  	lExistX3 := .f.
  	
	For nI := 1 to TRBCTL->(FCount())
		
		cConteudo	:= TRBCTL->(FieldGet(nI))
		cCampo		:= Alltrim(TRBCTL->(FieldName(nI)))
		
		SX3->(DbSetOrder(2))//campo
		
		If Alltrim(cCampo) == "CTL_QCDOC"
			aNrDoc := Separa(cConteudo,"+")
			
			If Len(aNrDoc) > 0
				For nX := 1 to Len(aNrDoc)
				    
					If ( nPos := AT("(",aNrDoc[nX]) ) > 0 
						cConteudo := ""
						For nZ := nPos to len(aNrDoc[nX])
							If Substr(aNrDoc[nX],nZ,1) $ "(*)"
								Loop
							Endif
							
							cAuxCont += Substr(aNrDoc[nX],nZ,1)
							
						Next nZ
						
						aNrDoc[nX] 	:= cAuxCont
							
					Endif
				
					If !("FILIAL" $ aNrDoc[nX])
						lExistX3 := SX3->(DbSeek(aNrDoc[nX]))										
					Endif
				Next nX
			   
				If lExistX3 .and. !Empty(cAuxCont)
					For nX := 1 to len(aNrDoc)	
						cConteudo += aNrDoc[nX]+ "+"
					Next nX	
					cAuxCont	:= ""
					cConteudo 	:= Substr(cConteudo,1,Rat("+",cConteudo)-1)
				Endif
					
			Else	
				lExistX3 := SX3->(DbSeek(cConteudo))
			Endif	
		Else
			lExistX3 := SX3->(DbSeek(cConteudo))
		Endif
		
		If (!Empty(cConteudo) .and. lExistX3 ) .or. cCampo == "CTL_ALIAS"
			aAdd(aAux,cConteudo)
		Else
			Do Case
			Case cCampo == "CTL_QCDATA"	
				aAdd(aAux,"NO_DATA")
			Case cCampo == "CTL_QCDOC"
				aAdd(aAux,"NO_DOC")
			Case cCampo == "CTL_QCMOED"
				aAdd(aAux,"NO_MOEDA")
			Case cCampo == "CTL_QCVLRD"
				aAdd(aAux,"NO_VALOR")
			Case cCampo == "CTL_QCCORR"				
				aAdd(aAux,"NO_NODIA")			
			EndCase	
		Endif
	Next nI
    
	aAdd(aRet,aAux)
	aAux := {}	
	//aAdd(aRet,{TRBCTL->CTL_ALIAS,TRBCTL->CTL_QCDATA,TRBCTL->CTL_QCDOC,TRBCTL->CTL_QCMOED,TRBCTL->CTL_QCVLRD,TRBCTL->CTL_QCCORR})
	TRBCTL->(DbSkip())
EndDo

TRBCTL->(DbCloseArea())

RestArea(aAreaSX3)

Return(aRet)


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噮o    矯TBC66GetHBrw	� Autor 矲ernando Radu Muscalu � Data � 29/08/11  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噮o 矴era as colunas dos objetos tWBrowse referentes ao modulo e a   潮�
北�          砪ontabilidade													  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   矯TBC66GetHBrw(nCabTipo)										  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros硁CabTipo	- Tipo: N => Tipo de cabecalho a ser montado          潮�
北�          �				1 = Modulo									      潮�
北�          �				2 = Contabilidade				      			  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   砤RetCab	- Tipo: A => Dados para a formacao das colunas dos    潮�
北�          硂bjetos twBrowse											      潮�
北�          �	aRetCab[n,1] - Tipo: C => Titulo da coluna				      潮�
北�          �	aRetCab[n,2] - Tipo: N => Tamanho da coluna				      潮�
北�          �	aRetCab[n,3] - Tipo: C => Tipo de dado da coluna		      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACTB                                                        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function CTBC66GetHBrw(nCabTipo)

Local aRetCab		:= {}
Local aTitulo		:= {}
Local aAux			:= {} 
Local aEntidades	:= Ctbc66RetEnt()

Local nI		:= 0

If nCabTipo == 1     

	aAux := {	" ",;      
	            "CT2_FILIAL",;
				STR0026,; 	//##"Arquivo"
				STR0027,;	//## "Data"
				STR0028,;	//##"Documento"
				"CT2_MOEDLC",;
				STR0029,;	//##"Valor Doc."
				"CT2_NODIA",;
				"CT2_DEBITO",;
				"CT2_CREDIT",;
				"CT2_CCD",;
				"CT2_CCC",;
				"CT2_ITEMD",;
				"CT2_ITEMC",;
				"CT2_CLVLDB",;
				"CT2_CLVLCR"}

	For nI := 1 to len(aEntidades[1])
		aAdd(aAux,aEntidades[1,nI,1])
		aAdd(aAux,aEntidades[2,nI,1])
	Next nI
Else	   
	aAux := {	"CT2_FILIAL",;
				"CT2_DATA",;
				"CT2_TPSALD",;
				"CT2_LOTE",;
				"CT2_SBLOTE",;
				"CT2_DOC",;
				"CT2_LINHA",;
				"CT2_LP",;
				"CT2_SEQLAN",;
				"CT2_NODIA",;
				"CT2_DEBITO",;
				"CT2_CREDIT",;
				"CT2_CCD",;
				"CT2_CCC",;
				"CT2_ITEMD",;
				"CT2_ITEMC",;
				"CT2_CLVLDB",;
				"CT2_CLVLCR"}

	For nI := 1 to len(aEntidades[1])
		aAdd(aAux,aEntidades[1,nI,1])
		aAdd(aAux,aEntidades[2,nI,1])
	Next nI
	
	aEval(aCtbc66Moe,{|x| aAdd(aAux,alltrim(x[3])) })

Endif

For nI := 1 to len(aAux)
	If nCabTipo == 1
		If nI == 7
			aTitulo := Ctbc66GCpoTit("CT2",aAux[nI],"N")	
		Else
			aTitulo := Ctbc66GCpoTit("CT2",aAux[nI])		
		Endif	
	Else
		If nI > 18+len(aEntidades[1])*2
			aTitulo := Ctbc66GCpoTit("CT2",aAux[nI],"N")	
		Else
			aTitulo := Ctbc66GCpoTit("CT2",aAux[nI])	
		Endif
	EndIf	
	aAdd(aRetCab,{aTitulo[1],aTitulo[2],aTitulo[3]})
Next nI    


Return(aRetCab)


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噮o    矯tbc66GCpoTit	� Autor 矲ernando Radu Muscalu � Data � 29/08/11  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噮o 矴era as informacoes necessarias para a criacao das colunas      潮�
北�          砫os objetos tWBrowse referentes ao modulo e a contabilidade	  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   矯tbc66GCpoTit(cAlias,cField,cTipoDef)							  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros砪Alias	- Tipo: C => Alias do arquivo 				          潮�
北�          砪Field	- Tipo: C => Campo									  潮�
北�          砪TipoDef	- Tipo: C => tipo de dado que coluna ira assumir	  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   砤Ret	- Tipo: A => Informacoes das colunas				      潮�
北�          �	aRet[1] - Tipo: C => Titulo da coluna		   			      潮�
北�          �	aRet[2] - Tipo: N => Tamanho da coluna					      潮�
北�          �	aRet[3] - Tipo: C => Tipo de dado da coluna		    		  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACTB                                                        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/ 
Static Function Ctbc66GCpoTit(cAlias,cField,cTipoDef)

Local aRet			:= {}
Local aAreaSX3		:= SX3->(GetArea())

Local cTitulo		:= ""
Local cTipo			:= ""

Local nConst		:= 2.5
Local nVal			:= 0

Default cTipoDef	:= "C"

SX3->(DbSetOrder(2))//campo

If "_" $ cField .and. SX3->(DbSeek(cField))
	cTitulo := (cAlias)->(RetTitle(cField))	
	nVal 	:= ( TamSx3(cField)[1]*nConst )+( len(cTitulo)*nConst )
	cTipo 	:= Alltrim(SX3->X3_TIPO)
Else
	cTitulo := cField
	nVal	:= 40 + (len(cTitulo)*nConst)	
	cTipo	:= cTipoDef 
Endif

aRet := {cTitulo,nVal,cTipo}

RestArea(aAreaSX3)
Return(aRet)

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噮o    矯tbC66GMoe	� Autor 矲ernando Radu Muscalu � Data � 29/08/11  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噮o 砇etorna as moedas cadastradas que nao estao bloqueadas 	      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   矯tbC66GMoe()													  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros�      	                              				          	 	 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   砤Ret	- Tipo: A => Moedas do cadastradas na tab. CTO		    潮�
北�          �	aRet[n,1] - Tipo: C => Titulo da coluna		   			    潮�
北�          �	aRet[n,2] - Tipo: N => Tamanho da coluna				      	 潮�
北�          �	aRet[n,3] - Tipo: C => Tipo de dado da coluna	    		  	 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACTB                                                        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function CtbC66GMoe()

Local cFilCTO	:= xFilial("CTO")

Local aRet 		:= {}
Local aAreaCTO  := CTO->(GetArea())

CTO->(dbsetorder(1)) 

If Empty(cFilCTO)
	CTO->(dbGotop())
Else
	CTO->(DbSeek(cFilCTO))
Endif

While CTO->(!Eof()) .and. xFilial("CTO") == CTO->CTO_FILIAL
	If Alltrim(CTO->CTO_BLOQ) == "2" .And. CTO->CTO_MOEDA == "01"
		aAdd(aRet,{CTO->CTO_MOEDA,CTO->CTO_SIMB,"Valor"})
	Endif	              
	CTO->(DbSkip())
EndDo

Restarea(aAreaCTO)
Return(aRet)


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噮o    矴etValMCT2	� Autor 矲ernando Radu Muscalu � Data � 29/08/11  	 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噮o 砇etorna os valores dos lancamentos contabeis nas n moedas que   	 潮�
北�          砯oram lancadas.												  	 	 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   矴etValMCT2(cNodia,cSeqLan,cFilPesq)							  	 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros砪Nodia	- Tipo: C => Nro diario, conhecido como correlativo   	 潮�
北�          砪SeqLan	- Tipo: C => Sequencia do lancamento contabil		  	 潮�
北�          砪FilPesq	- Tipo: C => Filial									  	 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   砤Ret	- Tipo: A => Valores nas Moedas dos Lancamentos Contabeis潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACTB                                                        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function GetValMCT2(nRecnoCT2,cSeqLan,cFilPesq)
Local aRet
Local aAreaCT2	:= CT2->(GetArea())
Local aExist	:= {}
Local nP		:= 0

If nRecnoCT2 > 0
    
	CT2->(DbGoTo(nRecnoCT2))
	    
	aRet := Array(len(aCtbc66Moe))
	   aFill(aRet,0)
	                                   
	nP := aScan(aCtbc66Moe,{|x| alltrim(x[1]) == Alltrim(CT2->CT2_MOEDLC) })
	If nP > 0
		If aScan(aExist,CT2->CT2_MOEDLC) == 0
			aRet[nP] := CT2->CT2_VALOR
			aAdd(aExist,CT2->CT2_MOEDLC)
		Endif
	Endif	
Endif

Restarea(aAreaCT2)

Return(aRet)



/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噮o    矴etFieldFil	� Autor 矲ernando Radu Muscalu � Data � 29/08/11  	 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噮o 砇etorna o nome do campo filial do alias passado				  		 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   矴etFieldFil(cAlias)											  		 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros砪Alias	- Tipo: C => Alias do arquivo 						  		 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   砪Ret	- Tipo: C => Nome do campo Filial do dicionario SX3		 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACTB                                                        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function GetFieldFil(cAlias)

Local cRet		:= ""
Local aAreaSx3	:= SX3->(GetArea())

SX3->(DbSetOrder(1))//adicionado por Caio Quiqueto

If SX3->(DbSeek(cAlias))
	While SX3->(!Eof()) .AND. Alltrim(SX3->X3_ARQUIVO) == Alltrim(cAlias) 
		If "FILIAL" $ SX3->X3_CAMPO 
			cRet := Alltrim(SX3->X3_CAMPO)
			Exit 
		Endif	
		SX3->(DBSKIP())
	EndDo
Endif

RestArea(aAreaSx3)
Return(cRet)


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪勘�
北矲un噮o    矯tbc66CV3		� Autor 矲ernando Radu Muscalu � Data � 29/08/11  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪幢�
北矰escri噮o 砇etorna os dados do arquivo CV3 pois estes irao compor as       	 潮�
北�          砳nformacoes do lado do modulo, quando ha lancamento contabil    潮�
北�          硃ara um determinado registro do modulo						  		 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   矯tbc66CV3(cData,cSequen,cLPSeq,cFilPesq)						  	 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros砪Data		- Tipo: C => data do lancamento 					  	 潮�
北�          砪Sequen	- Tipo: C => sequencia do lancamento				  	 潮�
北�          砪LPSeq	- Tipo: C => Sequencia do LP						  		 潮�
北�          砪FilPesq	- Tipo: C => Filial			 						  	 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   砤Ret	- Tipo: A => Dados de CV3								  	 潮�
北�          �	aRet[1]	- Tipo: C => Conta Debito							 潮�
北�          �	aRet[2]	- Tipo: C => Conta Credito							 潮�
北�          �	aRet[3]	- Tipo: C => Centro de Custo Debito				 潮�
北�          �	aRet[4]	- Tipo: C => Centro de Custo Credito				 潮�
北�          �	aRet[5]	- Tipo: C => Item de Conta Debito					 潮�
北�          �	aRet[6]	- Tipo: C => Item de Conta Credito					 潮�
北�          �	aRet[7]	- Tipo: C => Classe de Valor Debito				 潮�
北�          �	aRet[8]	- Tipo: C => Classe de Valor Credito				 潮�
北�          �	aRet[9]	- Tipo: C => Array com as demais entidades		 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACTB                                                        潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function Ctbc66CV3(cData,cSequen,cLPSeq,cFilPesq,nRecno)

Local aAreaCV3		:= CV3->(GetArea()) 
Local aRet			:= {}
Local aEnt			:= Ctbc66RetEnt("CV3")

Local nI			:= 0
Local nQtdEnt		:= 0

Default cFilPesq	:= xFilial("CV3")

aRet 	:= Array(9)
aFill(aRet,"")
aRet[9]	:= {}          
nQtdEnt := len(aEnt[1])

If !Empty(nRecno)

	CV3->(DbSetOrder(2))
	
	If CV3->(DbSeek(cFilPesq + padr(AllTrim(STR(nRecno)),tamSX3("CV3_RECDES")[1])))
		aRet[1] := CV3->CV3_DEBITO
   		aRet[2] := CV3->CV3_CREDIT
   		aRet[3] := CV3->CV3_CCD
    	aRet[4] := CV3->CV3_CCC
		aRet[5] := CV3->CV3_ITEMD
		aRet[6] := CV3->CV3_ITEMC
		aRet[7] := CV3->CV3_CLVLDB
		aRet[8] := CV3->CV3_CLVLCR
		For nI := 1 to nQtdEnt
			aAdd(aRet[9],CV3->&(aEnt[1,nI,1]))		
			aAdd(aRet[9],CV3->&(aEnt[2,nI,1]))	
		Next nI
	Endif
Endif    				

If len(aRet[9]) == 0
	aRet[9]	 := Array(nQtdEnt*2)
	aFill(aRet[9],"")	
Endif

Restarea(aAreaCV3) 

Return(aRet)


/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噮o    矯tbc66FillBlank� Autor 矲ernando Radu Muscalu � Data � 29/08/11  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北矰escri噮o 矨diciona valores em branco no array master aResultSet caso nao   潮�
北�          砲aja nenhum valor preenchido.									   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe   矯tbc66FillBlank(aResult)	     								   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros砤Result - Tipo: A => Array com os dados comparativo Modulo X     潮�
北�          矯ontabilidade													   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砃il							    							   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北� Uso      � SIGACTB                                                         潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/
Static Function Ctbc66FillBlank(aResult)
Local nI		:= 0
Local aAux		:= {}
Local nQtdEnt   := Len(Ctbc66RetEnt()[1])*2

For nI := 1 to len(aResult)
	If aResult[nI,2] == nil
	
		aResult[nI,2] := {}
	
		aAux := Array(16+nQtdEnt)
		
		aFill(aAux,"")          
		
		aAux[1] := LoadBitmap(GetResources(),"BR_VERMELHO")
		
		Aadd(aAux,-1)		//Adiciona codigo do status SEMPRE ao final do array, pois o relatorio lera o status dessa posicao
		
		aAdd(aResult[nI,2],aAux)
		aAux := {}
	Endif
	If aResult[nI,3] == nil    
	
		aResult[nI,3] := {}
	
		aAux := Array(20+nQtdEnt+len(aCtbc66Moe))
		aFill(aAux,"")     
		
		aResult[nI,2,len(aResult[nI,2]),1] := LoadBitmap(GetResources(),"BR_VERDE")
		
		Aadd(aAux,-1)		//Adiciona codigo do status SEMPRE ao final do array, pois o relatorio lera o status dessa posicao
		
		aAdd(aResult[nI,3],aAux)
		aAux := {}
	Endif
Next nI

Return()

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪哪勘�
北矲un噮o    矯tbc66RetEnt	 � Autor 矲ernando Radu Muscalu � Data � 29/08/11   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪哪幢�
北矰escri噮o 砇etorna os campos e suas descricoes das outras entidades		    潮�
北�          砪ontabeis alem das quatro fixas							 	    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   矯tbc66RetEnt(cAlias)		     								    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros砪Alias - Tipo: C => Alias do arquivo						        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   矨rray - Entidades contabeis alem das 4 fixas					    潮�
北�          �	Array[1] - Tipo: A => Entidades de Debito					    潮�
北�          �		Array[1,n,1] - Tipo: C => Campo para o Alias passado        潮�
北�          �		Array[1,n,2] - Tipo: C => Nome do campo para o Alias passado潮�
北�          �	Array[2] - Tipo: A => Entidades de Credito					    潮�
北�          �		Array[2,n,1] - Tipo: C => Campo para o Alias passado        潮�
北�          �		Array[2,n,2] - Tipo: C => Nome do campo para o Alias passado潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACTB                                                         	潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function Ctbc66RetEnt(cAlias)

Local aRetDb	:= {}
Local aRetCr	:= {}
Local aAreaSX3 	:= SX3->(GetArea())

Local nQtdEnt	:= 0
Local nI		:= 0

Local cCompl	:= ""

Default cAlias	:= "CT2"

nQtdEnt := CtbQtdEntd()

SX3->(DbSetOrder(1))

If SX3->( DbSeek(cAlias) ) 
	cCompl := Substr(SX3->X3_CAMPO,1,At("_",SX3->X3_CAMPO,1))		
Endif

If !Empty(cCompl) .And. .F. //For鏰 somente as Entidades Padr鮡s
	For nI := 5 to nQtdEnt
		
		aAdd(aRetDB,{cCompl+"EC"+STRZERO(nI,2)+"DB",(cAlias)->(RetTitle(cCompl+"EC"+STRZERO(nI,2)+"DB"))} )
		aAdd(aRetCR,{cCompl+"EC"+STRZERO(nI,2)+"CR",(cAlias)->(RetTitle(cCompl+"EC"+STRZERO(nI,2)+"CR"))} )
		
	Next nI
Endif


RestArea(aAreaSX3)

Return({aRetDb,aRetCr})

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪哪勘�
北矲un噮o    矯tbc66GRsc	 � Autor 矲ernando Radu Muscalu � Data � 29/08/11   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪哪幢�
北矰escri噮o 砯uncao responsavel pela definicao do semafaro para os registros   潮�
北�          硄ue compoe a browse do modulo								 	    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   矯tbc66GRsc(aArrayMod,aArrayCtb,cAlias,nTipo,aDataCV3,aCfgFields)  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros砤ArrayMod - Tipo: A => Array com os dados do Modulo    	        潮�
北�          砤ArrayCtb - Tipo: A => Array com os dados da Contabilidade        潮�
北�          砪Alias 	- Tipo: C => Alias do arquivo do modulo				    潮�
北�          硁Tipo 	- Tipo: N => Tipo de Validacao a ser usada			    潮�
北�          �      	  1 = Validacao diretamente no browse     			    潮�
北�          �      	  2 = Validacao na composicao dos dados do array master 	潮�
北�			   砪Bmp - Tipo: O => Objeto com a cor										潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   硁Status - Tipo: N => status da conta								潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACTB                                                         	潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function Ctbc66GRsc(aArrayMod,aArrayCtb,cAlias,nTipo,aDataCV3,aCfgFields,cBmp) 			
Local nStatus		:= 0
Local aCabecMod 	:= CTBC66GetHBrw(1)
Local aEntities 	:= Ctbc66RetEnt()
Local nI			:= 0
Local nEnt			:= 0
Local nX 			:= 0
Local nPos			:= 0
Local lDone			:= .f.

Default nTipo		:= 1
Default aDataCV3	:= {}
Default aArrayMod	:= {}
Default aArrayCtb	:= {}

cBmp		:= LoadBitmap(GetResources(),"BR_VERDE")

If nTipo == 1
    nX 		:= 11
    nEnt	:= Len(aEntities[1]) * 2
	For nI := 1 to len(aCabecMod)
		
		If nI == 3
			If ( Empty(aArrayMod[nI]) .and. !Empty(aArrayCtb[2]) ) .or. ( !Empty(aArrayMod[nI]) .and. Empty(aArrayCtb[2]) ) 		
				cBmp := LoadBitmap(GetResources(),"BR_VERMELHO")	
				nStatus:=1		
				Exit
			Endif
		ElseIf nI == 7
			If ( !Empty(aArrayMod[nI]) .or. !Empty(aArrayCtb[20+nEnt]) ) .and. aArrayMod[nI] <> aArrayCtb[20+nEnt]
				cBmp := LoadBitmap(GetResources(),"BR_AMARELO")
				nStatus:=2
				Exit
			Endif	
		ElseIf nI >= 9 
			If (!Empty(aArrayMod[nI]) .or. !Empty(aArrayCtb[nX]) ) .and. aArrayMod[nI] <> aArrayCtb[nX]
				cBmp := LoadBitmap(GetResources(),"BR_AMARELO")
				nStatus:=2
			Endif
			nX++
		Endif
	Next nI
Else   
	
	nEnt	:= Len(aEntities[1])

	If ( Empty( (cAlias)->&(aCfgFields[NRODOC]) ) .AND. !Empty((cAlias)->CT2_DATA) ) .OR. ( !Empty((cAlias)->&(aCfgFields[NRODOC])) .AND. Empty((cAlias)->CT2_DATA ) )
		cBmp := LoadBitmap(GetResources(),"BR_VERMELHO")
		nStatus:=1			
		lDone := .t.	
	Endif

	If !lDone	
		
		//nPos := (cAlias)->(FieldPos(aCfgFields[NODIA])) 
		
        //谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
        //� Problemas encontrados no modulo SIGAATF; somente SN3 esta, atualmente, sendo rastreado em CV3 �
        //� **  Nao conformidade a ser resolvida: SN3->N3_NODIA nao esta sendo gravado ! *** 02/01/2013   �
        //滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
        //If ( Empty((cAlias)->(FieldGet(nPos) )) .and. !Empty((cAlias)->CT2_NODIA) ) .OR. ( !Empty((cAlias)->(FieldGet(nPos))) .and. Empty((cAlias)->CT2_NODIA) )
		  //	cBmp := LoadBitmap(GetResources(),"BR_VERMELHO")	
		   	//nStatus:=1		
		  	//lDone := .t.
		//Endif
		
		If !lDone
			If (!Empty((cAlias)->DELETADO) .or. !Empty((cAlias)->CT2_DELET) ) .and. (cAlias)->DELETADO <> (cAlias)->CT2_DELET
				cBmp := LoadBitmap(GetResources(),"BR_VERMELHO")
				nStatus:=1
				lDone := .t.			
			Endif                       
			
			If !lDone
				If (cAlias)->CT2_CONFST == "1"
					cBmp    := LoadBitmap(GetResources(),"BR_PRETO")
					nStatus := 3
					lDone   := .T.
				Else
					//Verifica se o Valor do documento e diferente da contabilidade
					nPos := (cAlias)->(FieldPos(aCfgFields[VLRDOC]))
					If ( !Empty((cAlias)->(FieldGet(nPos))) .or. !Empty( (cAlias)->CT2_VALOR ) ) .and. (cAlias)->(FieldGet(nPos)) <> (cAlias)->CT2_VALOR
						If (cAlias)->CT2_CONFST == "1"
							cBmp := LoadBitmap(GetResources(),"BR_PRETO")
							nStatus:=3
							Else	
							cBmp := LoadBitmap(GetResources(),"BR_AMARELO")
							nStatus:=2
						EndIf	
						lDone := .t.			
					Endif
				EndIf	                    
				
				If !lDone 
					//Verifica se ha divergencias entre as quantidades
					aPosEntCT2 := {	(cAlias)->(FieldPos("CT2_DEBITO")),;
									(cAlias)->(FieldPos("CT2_CREDIT")),;
									(cAlias)->(FieldPos("CT2_CCD")),;
									(cAlias)->(FieldPos("CT2_CCC")),; 
									(cAlias)->(FieldPos("CT2_ITEMD")),;
									(cAlias)->(FieldPos("CT2_ITEMC")),;
									(cAlias)->(FieldPos("CT2_CLVLDB")),;
									(cAlias)->(FieldPos("CT2_CLVLCR")),;
									} 
									
					
					For nI := 1 to nEnt
						aAdd(aPosEntCt2,(cAlias)->(FieldPos(aEntities[1,nI,1])))	
						aAdd(aPosEntCt2,(cAlias)->(FieldPos(aEntities[2,nI,1])))	
					Next nI	
					
					For nI := 1 to len(aDataCV3)
						
						If Valtype(aDataCV3[nI]) <> "A"
							cEntCT2 := (cAlias)->(FieldGet(aPosEntCt2[nI]))
							
							If ( !Empty(aDataCV3[nI]) .or. !Empty(cEntCT2) ) .and. aDataCV3[nI] <> cEntCT2
								cBmp := LoadBitmap(GetResources(),"BR_AMARELO")
								nStatus:=2			
								lDone := .t.	
							Endif
						Endif
						
						If !lDone
							If Valtype(aDataCV3[nI]) == "A"	 
								For nX := 1 to len(aDataCV3[nI])           
									cEntCT2 := (cAlias)->(FieldGet(aPosEntCt2[nI+nX]))
									If ( !Empty(aDataCV3[nI,nX]) .or. !Empty(cEntCT2) ) .and. aDataCV3[nI,nX] <> cEntCT2
										cBmp := LoadBitmap(GetResources(),"BR_AMARELO")
										nStatus:=2			
										lDone := .t.	
										Exit
									Endif
								Next nX
							Endif 
						Endif   
						
						If lDone
							Exit
						Endif
					Next nI
					
				Endif
				
			Endif
			
	    Endif
		
	Endif

Endif

Return(nStatus)

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪哪勘�
北矲un噮o    矯TBC66leg		 � Autor 矲ernando Radu Muscalu � Data � 29/08/11   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪哪幢�
北矰escri噮o 矼ontagem da tela de legenda									    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   矯TBC66leg()														潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros�																	潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   砃il																潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � SIGACTB                                                         	潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
Static Function CTBC66leg()

Local aCores := {	{"BR_VERMELHO"	,STR0030	},;		//## "Documentos desbalanceados."
				 	{"BR_AMARELO"   ,STR0031	},;		//## "Doc. dados divergentes"
				 	{"BR_VERDE"		,STR0032	},;		//## "Documentos corretos."
				 	{"BR_PRETO"     ,STR0059    }	}   //## "Documentos conferidos."

BrwLegenda(STR0005,STR0024,aCores)  //##"Relat髍io de Auditoria"#"Legenda"

Return()

/*
Mapa de aResultSet

aResultSet
	aResultSet[n] - array, refere-se a aba das Dialogs das Filiais
		aResultSet[n,1] - Filial Codigo + Descicao 
		aResultSet[n,2] - array, refere-se a aba dos Modulos selecionados 
			aResultSet[n,2,x] - array dos modulos
				aResultSet[n,2,x,1] - nro do modulo
				aResultSet[n,2,x,2] - array com as informacoes do modulo
					aResultSet[n,2,x,2,z] 		- array indicando a Linha 
						aResultSet[n,2,x,2,z,1] 		- Bitmap da cor
						aResultSet[n,2,x,2,z,2] 		- Filial
						aResultSet[n,2,x,2,z,3] 		- CV3_TABORI
						aResultSet[n,2,x,2,z,4] 		- Data (Pegar na CTL)
						aResultSet[n,2,x,2,z,5] 		- Documento (Pegar na CTL)
						aResultSet[n,2,x,2,z,6] 		- Moeda (Pegar na CTL)
						aResultSet[n,2,x,2,z,7] 		- Vlr Doc (Pegar na CTL)
						aResultSet[n,2,x,2,z,8] 		- Correlativo
						aResultSet[n,2,x,2,z,9] 		- CV3_DEBITO
						aResultSet[n,2,x,2,z,10] 		- CV3_CREDIT
						aResultSet[n,2,x,2,z,11] 		- CV3_CCD
						aResultSet[n,2,x,2,z,12]		- CV3_CCC
						aResultSet[n,2,x,2,z,13]	 	- CV3_ITEMD
						aResultSet[n,2,x,2,z,14]	 	- CV3_ITEMC
						aResultSet[n,2,x,2,z,15] 		- CV3_CLVLDB
						aResultSet[n,2,x,2,z,16] 		- CV3_CLVLCR
						aResultSet[n,2,x,2,z,17] 		- Status// adicionado por Caio Quiqueto
						aResultSet[n,3,x,2,z,18...n]	- Entidades Contabeis
				aResultSet[n,2,x,3] - array Contabilidade
					aResultSet[n,2,x,3,z] 		- array indicando a Linha 
						aResultSet[n,2,x,3,z,1] 		- CT2_FILIAL
						aResultSet[n,2,x,3,z,2] 		- CT2_DATA
						aResultSet[n,2,x,3,z,3] 		- CT2_TPSALD
						aResultSet[n,2,x,3,z,4] 		- CT2_LOTE
						aResultSet[n,2,x,3,z,5] 		- CT2_SBLOTE
						aResultSet[n,2,x,3,z,6] 		- CT2_DOC
						aResultSet[n,2,x,3,z,7] 		- CT2_LINHA
						aResultSet[n,2,x,3,z,8] 		- CT2_SEQLAN
						aResultSet[n,2,x,3,z,9] 		- CT2_LP
						aResultSet[n,2,x,3,z,10] 		- CT2_NODIA
						aResultSet[n,2,x,3,z,11] 		- CT2_DEBITO
						aResultSet[n,2,x,3,z,12] 		- CT2_CREDIT
						aResultSet[n,2,x,3,z,13] 		- CT2_CCD
						aResultSet[n,2,x,3,z,14] 		- CT2_CCC
						aResultSet[n,2,x,3,z,15] 		- CT2_ITEMD
						aResultSet[n,2,x,3,z,16] 		- CT2_ITEMC
						aResultSet[n,2,x,3,z,17] 		- CT2_CLVLDB
						aResultSet[n,2,x,3,z,18] 		- CT2_CLVLCR
						aResultSet[n,2,x,3,z,20...n]	- Entidades Contabeis
						aResultSet[n,2,x,3,z,n+1...n+y]- valor nas Moedas
						aResultSet[n,2,x,3,z,n+y+1]	- CT2_DC	 	

*/                  

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪哪勘�
北矲un噮o    � CTC660Conf()	 � Autor � Jose Lucas           � Data � 31/10/11   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪哪幢�
北矰escri噮o � Conferir lan鏰mentos e gravar marca de conferencia.			    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   � CTC660Conf(ExpO1,ExpO2,ExpA1,ExpA2,ExpA3)						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� ExpO1 := oFolderFil - Folder com as filiais ativas).				潮�    
北�          � ExpO2 := aFModulos - Folder com as configura珲es modulos).		潮�
北�          � ExpA1 := aBrwMod - Objeto correspondente ao browse do m骴ulo sel-潮�
北�          � ecionado. Exemplo: Compras, Faturamento, Financeiro, etc...		潮�
北�          � ExpA2 := aBrwCtb - Objeto correspondente ao browse do m骴ulo CTB.潮�
北�          � ExpA3 := Array aResultSet.										潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � Nil																潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � CTC660 - Quadratura                                             	潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/                                
Static Function Ct660Conf(oFolderFil,aFModulos,aBrwMod,aBrwCtb,aResultSet) 
Local nI := 0 //Elemento correspondente ao folder da filial corrente.
Local nX := 0 //Elemento correspondente ao subfolder do modulo corrente.
Local nC := 0      
Local nPosLinha := 0
Local lConfere  := .F.
Local lConferir := .F.
Local lReverter := .F.
local cMod:=0 //codigo do modulo
Local oConferir
Local oObs 
Local cObs      := CriaVar("CT2_OBSCNF")              
Local lGravaCT2 := .F.
Local aSizeDlg	:= FWGetDialogSize(oMainWnd)
Local oDlg		:= Nil
Local nHeight	:= aSizeDlg[3] * 0.50
Local nWidth    := aSizeDlg[4] * 0.60
Local bUpdate	:= {|| If(lConferir .and. !Empty(cObs),(Ct660GrvCT2(oFolderFil,aFModulos,aBrwMod,aBrwCtb,aResultSet,nPosLinha,cObs,.T.,.F.),oDlg:End()),.F.)}
Local bEndWin	:= {|| oDlg:End()}							
Local bEnchBar	:= {|| EnchoiceBar(oDlg,bUpdate,bEndWin) }
  
nI := oFolderFil:nOption				//Elemento correspondente ao folder da filial corrente.
If nI > 0
	nX := aFModulos[nI]:nOption			//Elemento correspondente ao subfolder do modulo corrente.
EndIf
If ( nI > 0 .and. nX > 0 )
	cMod:=aFModulos[nI]:aDialogs[nX]:cCaption
	if !("34" $ cMod)
		nPosLinha := aBrwMod[nI][nX]:nAt	//Posi玢o da linha do lan鏰mento posicionado.
		If nPosLinha > 0      
			If aBrwMod[nI][nX]:aArray[nPosLinha][1]:cName $ "BR_AMARELO|BR_VERDE" 
				lConfere := .T.
			Else	
				If "BR_PRETO" $ aBrwMod[nI][nX]:aArray[nPosLinha][1]:cName
					lConfere := .F. 
					Help(" ",1,"CTBC660_DOCCONF",,STR0034,1,0)	 //"Documento ja conferido."
				ElseIf ! "BR_AMARELO" $ aBrwMod[nI][nX]:aArray[nPosLinha][1]:cName
					lConfere := .F.
					Help(" ",1,"CTBC660_NOCONF",,STR0035,1,0)	 //"Documento n鉶 permite conferecia."
				EndIf
			EndIf		
			
			If lConfere                                                                    
			
				DEFINE MSDIALOG oDlg FROM 0,0 TO nHeight, nWidth TITLE STR0036 PIXEL STYLE DS_MODALFRAME of oMainWnd  //###Conferencia do Documento
			
				@ 031,010  CHECKBOX oConferir VAR lConferir PROMPT STR0037 PIXEL OF oDlg SIZE 80,9 MESSAGE STR0038;	  //###"Se estiver marcado, modificar� o status e gravar� o lan鏰mento contabil como conferido."
					   	 			ON CLICK lGravaCT2 := .T.
		
				@ 044,011  SAY OemToAnsi(STR0039)	PIXEL OF oDlg SIZE 50,9			// "Observa玢o"
				@ 051,010  MSGET oObs	VAR cObs Picture "@!" 	VALID Ct660Obs(cObs)  PIXEL OF oDlg SIZE 150,10
	
				oDlg:Activate(,,,.T.,,,bEnchBar)
	        EndIf
	    EndIf
	Else
		lConfere := .F.
		Help(" ",1,"CTBC660_NOCONF",,STR0035,1,0)	 //"Documento n鉶 permite conferecia."
	Endif
EndIf
Return

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪哪勘�
北矲un噮o    � CTC660Reve()	 � Autor � Jose Lucas           � Data � 31/10/11   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪哪幢�
北矰escri噮o � Reverter a confirma玢o do lan鏰mento selecionado.			    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   � CTC660Reve(ExpO1,ExpO2,ExpA1,ExpA2,ExpA3)						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� ExpO1 := oFolderFil - Folder com as filiais ativas).				潮�    
北�          � ExpO2 := aFModulos - Folder com as configura珲es modulos).		潮�
北�          � ExpA1 := aBrwMod - Objeto correspondente ao browse do m骴ulo sel-潮�
北�          � ecionado. Exemplo: Compras, Faturamento, Financeiro, etc...		潮�
北�          � ExpA2 := aBrwCtb - Objeto correspondente ao browse do m骴ulo CTB.潮�
北�          � ExpA3 := Array aResultSet.										潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � Nil																潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � CTC660 - Quadratura                                             	潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/                                
Static Function CT660Reve(oFolderFil,aFModulos,aBrwMod,aBrwCtb,aResultSet) 
Local nI := 0 
Local nX := 0 
Local nC := 0      
Local nPosLinha := 0
Local lConfere  := .F.
Local lConferir := .F.
Local lReverter := .T.
Local oConferir
Local oObs 
Local cObs      := CriaVar("CT2_OBSCNF")              
Local lGravaCT2 := .F.
Local aSizeDlg	:= FWGetDialogSize(oMainWnd)
Local nHeight	:= aSizeDlg[3] * 0.50
Local nWidth    := aSizeDlg[4] * 0.60
Local oDlg		:= Nil
Local bUpdate	:= {|| If(lConferir .and. lReverter,(Ct660GrvCT2(oFolderFil,aFModulos,aBrwMod,aBrwCtb,aResultSet,nPosLinha,cObs,.F.,lReverter),oDlg:End()),.F.)}
Local bEndWin	:= {|| oDlg:End()}							
Local bEnchBar	:= {|| EnchoiceBar(oDlg,bUpdate,bEndWin) }
  
nI := oFolderFil:nOption				//Elemento correspondente ao folder da filial corrente.
If nI > 0
	nX := aFModulos[nI]:nOption			//Elemento correspondente ao subfolder do modulo corrente.
EndIf
If ( nI > 0 .and. nX > 0 )
	cMod:=aFModulos[nI]:aDialogs[nX]:cCaption
	if !("34" $ cMod)
		nPosLinha := aBrwMod[nI][nX]:nAt	//Posi玢o da linha do lan鏰mento posicionado.
		If nPosLinha > 0      
			If "BR_PRETO" $ aBrwMod[nI][nX]:aArray[nPosLinha][1]:cName
				lConfere  := .T.
				dDataLan  := aBrwCtb[nI][nX]:aArray[nPosLinha][2]
				cLoteLan  := aBrwCtb[nI][nX]:aArray[nPosLinha][4]
				cSBLote   := aBrwCtb[nI][nX]:aArray[nPosLinha][5]
				cDocLanc  := aBrwCtb[nI][nX]:aArray[nPosLinha][6]
				cLinha    := aBrwCtb[nI][nX]:aArray[nPosLinha][7]
				cTipSaldo := aBrwCtb[nI][nX]:aArray[nPosLinha][3]
				CT2->(dbSetOrder(1))
				CT2->(dbSeek(xFilial("CT2")+DTOS(dDataLan)+cLoteLan+cSBLote+cDocLanc+cLinha+cTipSaldo))
	            cObs := CT2->CT2_OBSCNF
			Else
				lConfere := .F.
				Help(" ",1,"CTBC660_NOREV",,STR0040,1,0)	 //"Revers鉶 s� � poss韛el nos documentos confirmados."
			EndIf		
			
			If lConfere                                                                    
			
				DEFINE MSDIALOG oDlg FROM 0,0 TO nHeight, nWidth TITLE STR0041 PIXEL STYLE DS_MODALFRAME of oMainWnd  	//"Revers鉶 do Documento"
	
				@ 031,010  CHECKBOX oConferir VAR lConferir PROMPT STR0042 PIXEL OF oDlg SIZE 80,9 MESSAGE STR0043;		//"Reverter Documento"###"Se estiver marcado, reverter� o status estornando a conferencia do documento contabil."
					   	 			ON CLICK lGravaCT2 := .T.
		
				@ 044,011  SAY OemToAnsi(STR0039)	PIXEL OF oDlg SIZE 50,9			// "Observa玢o"
				@ 051,010  MSGET oObs	VAR cObs Picture "@!" 	WHEN .F.            	PIXEL OF oDlg SIZE 150,10
	
				oDlg:Activate(,,,.T.,,,bEnchBar)
	        EndIf
	    EndIf
	Endif
EndIf
Return

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪哪勘�
北矲un噮o    � Ct660GrvCT2()	 � Autor � Jose Lucas       � Data � 04/11/11   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪哪幢�
北矰escri噮o � Gravar dados de conferencia ou revers鉶 de lan鏰mento na tabela  潮�
北�          � de lan鏰mentos contabeis na tabela CT2.                          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   � C660GrvCT2(ExpO1,ExpO2,ExpA1,ExpA2,ExpA3, ExpN1, ExpL1, ExpL2)	潮�
北�          � Linha,lConferir,lReverter)										潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� ExpO1 := oFolderFil - Folder com as filiais ativas).				潮�    
北�          � ExpO2 := aFModulos - Folder com as configura珲es modulos).		潮�
北�          � ExpA1 := aBrwMod - Objeto correspondente ao browse do m骴ulo sel-潮�
北�          � ecionado. Exemplo: Compras, Faturamento, Financeiro, etc...		潮�
北�          � ExpA2 := aBrwCtb - Objeto correspondente ao browse do m骴ulo CTB.潮�
北�          � ExpA3 := Array aResultSet.										潮�
北�          � ExpN1 := Numero da linha do elemento selecionado.				潮�
北�          � ExpL1 := Variavel de controle lConferir.							潮�
北�          � ExpL2 := Variavel de controle lReverter.							潮�   
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � Nil																潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � CTC660 - Quadratura Contabil.                                   	潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/  
Static Function Ct660GrvCT2(oFolderFil,aFModulos,aBrwMod,aBrwCtb,aResultSet,nPosLinha,cObs,lConferir,lReverter) 
Local aArea := GetArea()
Local nI := 0 
Local nX := 0 
Local dDataLan  := CTOD("")
Local cLoteLan  := ""
Local cSBLote   := ""
Local cDocLanc  := ""
Local cLinha    := ""
Local cTipSaldo := ""

nI := oFolderFil:nOption			//Elemento correspondente ao folder da filial corrente.
If nI > 0
	nX := aFModulos[nI]:nOption		//Elemento correspondente ao subfolder do modulo corrente.
EndIf
If ( nI > 0 .and. nX > 0 ) .and. nPosLinha > 0                
	cFilCT2   := aBrwCtb[nI][nX]:aArray[nPosLinha][1] 
	dDataLan  := aBrwCtb[nI][nX]:aArray[nPosLinha][2]
	cLoteLan  := aBrwCtb[nI][nX]:aArray[nPosLinha][4]
	cSBLote   := aBrwCtb[nI][nX]:aArray[nPosLinha][5]
	cDocLanc  := aBrwCtb[nI][nX]:aArray[nPosLinha][6]
	cLinha    := aBrwCtb[nI][nX]:aArray[nPosLinha][7]
	cTipSaldo := aBrwCtb[nI][nX]:aArray[nPosLinha][3]
	CT2->(dbSetOrder(1)) //CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC
	//Alert("xFilial: " + xFilial("CT2") + " cFilCT2: " + cFilCT2)
	If CT2->(dbSeek(xFilial("CT2")+DTOS(dDataLan)+cLoteLan+cSBLote+cDocLanc+cLinha+cTipSaldo)) 
		If lConferir
			aBrwMod[nI][nX]:aArray[nPosLinha][1]:cName := "BR_PRETO"	//Conferido
			RecLock('CT2',.F.)
			Replace CT2_CONFST	With "1"
			Replace CT2_OBSCNF	With cObs
			Replace CT2_USRCNF	With cUserName
			Replace CT2_DTCONF	With MSDate()
			Replace CT2_HRCONF	With Time()
			MsUnLock()			
		EndIf
		If lReverter
			aBrwMod[nI][nX]:aArray[nPosLinha][1]:cName := "BR_AMARELO"	//Revertido
			RecLock('CT2',.F.)
			Replace CT2_CONFST	With " "
			Replace CT2_OBSCNF	With " "
			Replace CT2_USRCNF	With " "
			Replace CT2_DTCONF	With CTOD("")
			Replace CT2_HRCONF	With " "
			MsUnLock()
		EndIf				
	EndIf		
Endif
RestArea(aArea)
Return  

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪哪勘�
北矲un噮o    � Ct660Obs()		 � Autor � Jose Lucas       � Data � 04/11/11   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪哪幢�
北矰escri噮o � Validar a caixa de edi玢o do campo Observa玢o.          		    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   � ExpL := Ct660Obs(ExpC)											潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� ExpC := cObs - Texto digitado.									潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � ExpL := Retorno logico True ou False.							潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � CTC660 - Quadratura Contabil.                                   	潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/  
Static Function Ct660Obs(cObs)   
Local lTrue  := .T.
Local lFalse := .F.
If Empty(cObs)
	Help(" ",1,"CTBC660_OBSMSG",,STR0044,1,0)	 //"Informe o texto para o campo observa玢o."
EndIf	
Return If(Empty(cObs),lFalse,lTrue)

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪哪勘�
北矲un噮o    � CTC660Dive()	 � Autor � Jose Lucas           � Data � 31/10/11   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪哪幢�
北矰escri噮o � Exibir divergencias do documento selecionado.   				    潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   � CTC660Dive(ExpO1,ExpO2,ExpA1,ExpA2,ExpA3)						潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� ExpO1 := oFolderFil - Folder com as filiais ativas).				潮�    
北�          � ExpO2 := aFModulos - Folder com as configura珲es modulos).		潮�
北�          � ExpA1 := aBrwMod - Objeto correspondente ao browse do m骴ulo sel-潮�
北�          � ecionado. Exemplo: Compras, Faturamento, Financeiro, etc...		潮�
北�          � ExpA2 := aBrwCtb - Objeto correspondente ao browse do m骴ulo CTB.潮�
北�          � ExpA3 := Array aResultSet.										潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � Nil																潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � CTC660 - Quadratura                                             	潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/                                
Static Function CT660Dive(oFolderFil,aFModulos,aBrwMod,aBrwCtb,aResultSet) 
Local nI := 0 
Local nX := 0 
Local nC := 0      
Local nPosLinha    := 0
Local lDivergencia := .F.           
Local lGravaCT2 := .F.
Local aSizeDlg	:= FWGetDialogSize(oMainWnd)
Local nHeight	:= aSizeDlg[3] * 0.50
Local nWidth    := aSizeDlg[4] * 0.60
Local oDlg		:= Nil
Local oListBox
Local aListBox  := {}            
Local aEntidades:= Ctbc66RetEnt()
Local cModulo   := ""
Local bUpdate	:= {|| If(lGravaCT2,(Ct660GrvCT2(oFolderFil,aFModulos,aBrwMod,aBrwCtb,aResultSet,nPosLinha,cObs,.F.,lReverter),oDlg:End()),.F.)}
Local bEndWin	:= {|| oDlg:End()}
Local bEnchBar	:= {|| EnchoiceBar(oDlg,bUpdate,bEndWin) }
  
nI := oFolderFil:nOption				//Elemento correspondente ao folder da filial corrente.
If nI > 0
	nX := aFModulos[nI]:nOption			//Elemento correspondente ao subfolder do modulo corrente.
EndIf
If ( nI > 0 .and. nX > 0)      
	cModulo := aFModulos[nI]:aPrompts[nX]//alterado pois precisa pegar o modulo
	if (cModulo != "34") // inserido o !=34 pois no modulo de contabilidade n鉶 existe compara玢o
		nPosLinha := aBrwMod[nI][nX]:nAt	//Posi玢o da linha do lan鏰mento posicionado.
		If nPosLinha > 0      
			If "BR_AMARELO" $ aBrwMod[nI][nX]:aArray[nPosLinha][1]:cName
				lDivergencia := .T.
				//Divergencias
				
				If aBrwMod[nI][nX]:aArray[nPosLinha][4] <> aBrwCtb[nI][nX]:aArray[nPosLinha][2]	//Data do Lan鏰mento
					AADD(aListBox,{STR0048,Transform(aBrwMod[nI][nX]:aArray[nPosLinha][4],"@D"),Transform(aBrwCtb[nI][nX]:aArray[nPosLinha][2],"@D")})	//"Data do documento"
				EndIf
				
				If aBrwMod[nI][nX]:aArray[nPosLinha][7] <> aBrwCtb[nI][nX]:aArray[nPosLinha][19]	//Valor do Documento
					AADD(aListBox,{STR0049,Transform(aBrwMod[nI][nX]:aArray[nPosLinha][7],"@E 999,999,999.99"),Transform(aBrwCtb[nI][nX]:aArray[nPosLinha][19],"@E 999,999,999.99")})
				EndIf
				                               
				//If aBrwMod[nI][nX]:aArray[nPosLinha][8] <> aBrwCtb[nI][nX]:aArray[nPosLinha][10]	//Numero do Diario
					//AADD(aListBox,{STR0050,aBrwMod[nI][nX]:aArray[nPosLinha][8],aBrwCtb[nI][nX]:aArray[nPosLinha][10]})
				//EndIf
				
				If aBrwMod[nI][nX]:aArray[nPosLinha][9] <> aBrwCtb[nI][nX]:aArray[nPosLinha][11]	//Conta Contabil Debito
					AADD(aListBox,{STR0051,aBrwMod[nI][nX]:aArray[nPosLinha][9],aBrwCtb[nI][nX]:aArray[nPosLinha][11]})
				EndIf
				
				If aBrwMod[nI][nX]:aArray[nPosLinha][10] <> aBrwCtb[nI][nX]:aArray[nPosLinha][12]	//Conta Contabil Credito
					AADD(aListBox,{STR0067,aBrwMod[nI][nX]:aArray[nPosLinha][10],aBrwCtb[nI][nX]:aArray[nPosLinha][12]})
				EndIf
				
				If aBrwMod[nI][nX]:aArray[nPosLinha][11] <> aBrwCtb[nI][nX]:aArray[nPosLinha][13]	//Centro custo Debito
					AADD(aListBox,{STR0061,aBrwMod[nI][nX]:aArray[nPosLinha][11],aBrwCtb[nI][nX]:aArray[nPosLinha][13]})
				EndIf
				
				If aBrwMod[nI][nX]:aArray[nPosLinha][12] <> aBrwCtb[nI][nX]:aArray[nPosLinha][14]	//Centro custo credito
					AADD(aListBox,{STR0062,aBrwMod[nI][nX]:aArray[nPosLinha][12],aBrwCtb[nI][nX]:aArray[nPosLinha][14]})
				EndIf
				
				If aBrwMod[nI][nX]:aArray[nPosLinha][13] <> aBrwCtb[nI][nX]:aArray[nPosLinha][15]	//Item debito
					AADD(aListBox,{STR0063,aBrwMod[nI][nX]:aArray[nPosLinha][13],aBrwCtb[nI][nX]:aArray[nPosLinha][15]})
				EndIf
				
				If aBrwMod[nI][nX]:aArray[nPosLinha][14] <> aBrwCtb[nI][nX]:aArray[nPosLinha][16]	//item credito
					AADD(aListBox,{STR0064,aBrwMod[nI][nX]:aArray[nPosLinha][14],aBrwCtb[nI][nX]:aArray[nPosLinha][16]})
				EndIf
				
				If aBrwMod[nI][nX]:aArray[nPosLinha][15] <> aBrwCtb[nI][nX]:aArray[nPosLinha][17]	//cl valor debito
					AADD(aListBox,{STR0065,aBrwMod[nI][nX]:aArray[nPosLinha][15],aBrwCtb[nI][nX]:aArray[nPosLinha][17]})
				EndIf
				
				If aBrwMod[nI][nX]:aArray[nPosLinha][16] <> aBrwCtb[nI][nX]:aArray[nPosLinha][18]	//Cl valor credito
					AADD(aListBox,{STR0066,aBrwMod[nI][nX]:aArray[nPosLinha][16],aBrwCtb[nI][nX]:aArray[nPosLinha][18]})
				EndIf
				
				
			EndIf			
			If lDivergencia                                                                    
			
				DEFINE MSDIALOG oDlg FROM 0,0 TO nHeight, nWidth TITLE "Divergencias" PIXEL STYLE DS_MODALFRAME of oMainWnd  //###Conferencia do Documento
			
				nHeight	:= aSizeDlg[3] * 0.40
				nWidth  := aSizeDlg[4] * 0.50
		
				@ 010, 010 LISTBOX oListBox Fields HEADER "Referencia",cModulo,"34-Contabilidade Gerencial"; //"Referencia"###"Modulo"###"Contabilidade"
							SIZE 355, 110 PIXEL
				oListBox:SetArray( aListBox )
				oListBox:bLine := { || { aListBox[ oListBox:nAT,1 ],aListBox[ oListBox:nAT,2 ],aListBox[ oListBox:nAT,3 ]} }
				oListBox:Align := CONTROL_ALIGN_ALLCLIENT
	
				oDlg:Activate(,,,.T.,,,bEnchBar)
	        EndIf
	    EndIf
    EndIf      
EndIf
Return

Static Function Filtrar()
Local nI         := 0
Local nX         := 0
Local nY         := 0
Local nZ         := 0  
Local oFont01    := TFont():New("Arial",,020,,.F.,,,,,.F.,.F.)
Local oFont02    := TFont():New("Arial",,019,,.T.,,,,,.F.,.F.)
Local oDlgFil    := Nil
Local oPanelFil  := Nil 
Local lFiltra    := .F.
Local aDadosMod  := {}
Local aDadosCtb  := {}
Local cLineMod   := ""
Local cLineCtb   := ""
Local aEmpty     := {}
Local oCheckBo1  := Nil
Local oCheckBo2  := Nil
Local oCheckBo3  := Nil
Local oCheckBo4  := Nil
Local cColor     := ""

Set Key VK_F4 To

oDlgFil := FWDialogModal():New()	
oDlgFil:SetBackground(.F.)    
oDlgFil:SetTitle("Filtrar")	
oDlgFil:SetEscClose(.T.)                       
oDlgFil:SetSize(110,150) //085		
oDlgFil:EnableFormBar(.T.)
oDlgFil:CreateDialog()        	
oPanelFil := oDlgFil:GetPanelMain()
oDlgFil:CreateFormBar()       

@ 002, 002 MSGET oGetFiltra VAR cGetFiltra PICTURE "@!" SIZE 145, 013 OF oPanelFil COLORS 0, 16777215 FONT oFont01 PIXEL

@ 019, 002 CHECKBOX oCheckBo1 VAR lCheckBo1 PROMPT "     Documentos desbalanceados" SIZE 090, 007 OF oPanelFil COLORS 0, 16777215 PIXEL
@ 019, 010 BITMAP oCheckBo1 RESOURCE "BR_VERMELHO" PIXEL OF oPanelFil SIZE 064, 025 NOBORDER PIXEL

@ 031, 002 CHECKBOX oCheckBo2 VAR lCheckBo2 PROMPT "     Doc. dados divergentes" SIZE 090, 007 OF oPanelFil COLORS 0, 16777215 PIXEL
@ 031, 010 BITMAP oCheckBo2 RESOURCE "BR_AMARELO" PIXEL OF oPanelFil SIZE 064, 025 NOBORDER PIXEL

@ 043, 002 CHECKBOX oCheckBo3 VAR lCheckBo3 PROMPT "     Documentos corretos" SIZE 090, 007 OF oPanelFil COLORS 0, 16777215 PIXEL
@ 043, 010 BITMAP oCheckBo3 RESOURCE "BR_VERDE" PIXEL OF oPanelFil SIZE 064, 025 NOBORDER PIXEL

@ 055, 002 CHECKBOX oCheckBo4 VAR lCheckBo4 PROMPT "     Documentos conferidos" SIZE 090, 007 OF oPanelFil COLORS 0, 16777215 PIXEL
@ 055, 010 BITMAP oCheckBo4 RESOURCE "BR_PRETO" PIXEL OF oPanelFil SIZE 064, 025 NOBORDER PIXEL

oDlgFil:AddButton("Filtrar",{|| (lFiltra := .T., oDlgFil:Deactivate())},"Filtrar",,.T.,.F.,.T.,)			 
oDlgFil:AddButton("Cancelar",{|| oDlgFil:Deactivate()},"Cancelar",,.T.,.F.,.T.,)

oDlgFil:SetInitBlock({|| oGetFiltra:SetFocus()})
oDlgFil:Activate()

If lFiltra 
	nI := oFolderFil:nOption //Elemento correspondente ao folder da filial corrente.
	If nI > 0
		nX := aFModulos[nI]:nOption	//Elemento correspondente ao subfolder do modulo corrente.
	EndIf

	If nI > 0 .And. nX > 0
		For nY := 1 To Len(aResultSet[nI][2][nX][2]) //Len(aBrwMod[nI][nX]:aArray)
			If AllTrim(cGetFiltra) $ AllTrim(aResultSet[nI][2][nX][2][nY][5]) .Or. Empty(cGetFiltra)
				cColor := AllTrim(ClassDataArr(aResultSet[nI][2][nX][2][nY][1],.F.)[1][2])
				
				If (lCheckBo1 .And. cColor ==  "BR_VERMELHO") .Or.; //Documentos desbalanceados
				   (lCheckBo2 .And. cColor ==  "BR_AMARELO")  .Or.; //Doc. dados divergentes
				   (lCheckBo3 .And. cColor ==  "BR_VERDE")    .Or.; //Documentos corretos
				   (lCheckBo4 .And. cColor ==  "BR_PRETO")          //Documentos conferidos
				   
				   Aadd(aDadosMod, aResultSet[nI][2][nX][2][nY]) 					 
				   Aadd(aDadosCtb, aResultSet[nI][2][nX][3][nY]) 					 					
				
				EndIf
			EndIf	
		Next nY	
					
		//Filtra lado do M骴ulo
		If Len(aDadosMod) = 0			
			Aadd(aEmpty, {"Vazio",Nil,Nil})						
			Ctbc66FillBlank(@aEmpty)
			aDadosMod := aClone(aEmpty[1][2])				
			aDadosCtb := aClone(aEmpty[1][3])
		EndIf
		If .T.
			aBrwMod[nI,nX]:SetArray(aDadosMod)						
			For nZ := 1 to Len(aCabMod)	
				If aTipoMod[nZ] == "N"
					cLineMod += "Transform(aDadosMod[aBrwMod[" + cValToChar(nI) + "," + cValToChar(nX) + "]:nAT," + cValToChar(nZ) + "],'" + PesqPict('CT2','CT2_VALOR') + "'),"
				Else 
					cLineMod += "aDadosMod[aBrwMod[" + cValToChar(nI) + "," + cValToChar(nX) + "]:nAT,"+cValToChar(nZ)+"],"	
				Endif					
			Next nZ		                                        		
			cLineMod := Substr(cLineMod,1,len(cLineMod)-1)					
			aBrwMod[nI,nX]:bLine := &("{|| {" + cLineMod + "}}")
			
			//Filtra lado Cont醔il
			aBrwCtb[nI,nX]:SetArray(aDadosCtb)					
			For nZ := 1 to len(aCabCtb)	
				If aTipoCtb[nZ] == "N"
					cLineCtb += "Transform(aDadosCtb[aBrwCtb[" + cValToChar(nI) + "," + cValToChar(nX) + "]:nAT," + cValToChar(nZ) + "],'" + PesqPict('CT2','CT2_VALOR') + "'),"
					Else
					cLineCtb += "aDadosCtb[aBrwCtb[" + cValToChar(nI) + "," + cValToChar(nX) + "]:nAT,"+cValToChar(nZ)+"],"	
				Endif					
			Next nZ                                       			
			cLineCtb := Substr(cLineCtb,1,len(cLineCtb)-1)					
			aBrwCtb[nI,nX]:bLine := &("{|| {" + cLineCtb + "}}")		
		EndIf
		aBrwMod[nI,nX]:Refresh()
		aBrwMod[nI,nX]:GoTop()		
			
		aBrwCtb[nI,nX]:Refresh()
		aBrwCtb[nI,nX]:GoTop()
			
		//Imprime descri玢o da Conta
		ChangeCT1()				
	EndIf
EndIf

Set Key VK_F4 To Filtrar()				  
Return Nil


//Static Function Localizar(oFolderFil,aFModulos,aBrwMod,aBrwCtb,aResultSet)
/*
Static Function Localizar()
Local nI        := 0
Local nX        := 0
Local oFont01   := TFont():New("Arial",,020,,.F.,,,,,.F.,.F.)
Local oFont02   := TFont():New("Arial",,019,,.T.,,,,,.F.,.F.)
Local oDlgLoc   := Nil
Local oPanelLoc := Nil 
Local lAchou    := .F.
Local lLocaliza := .F.

oDlgLoc := FWDialogModal():New()	
oDlgLoc:SetBackground(.F.)           //.T. -> Escurece o fundo da janela
oDlgLoc:SetTitle("Localizar")	
oDlgLoc:SetEscClose(.T.)             //Permite fechar a tela com o ESC                 
oDlgLoc:SetSize(085,150)		
oDlgLoc:EnableFormBar(.T.)
oDlgLoc:CreateDialog()               //Cria a janela (cria os paineis)	
oPanelLoc := oDlgLoc:GetPanelMain()
oDlgLoc:CreateFormBar()              //Cria barra de bot鮡s

@ 002, 002 MSGET oGetLocali VAR cGetLocali PICTURE "@!" SIZE 145, 013 OF oPanelLoc COLORS 0, 16777215 FONT oFont01 PIXEL
@ 019, 002 RADIO oRadLocali VAR nRadLocali ITEMS "Desde o Inicio","A partir do registro posicionado" SIZE 145, 018 OF oPanelLoc COLOR 0, 16777215 PIXEL

oDlgLoc:AddButton("Localizar",{|| (lLocaliza := .T., oDlgLoc:Deactivate())},"Localizar",,.T.,.F.,.T.,)			 
oDlgLoc:AddButton("Cancelar",{|| oDlgLoc:Deactivate()},"Cancelar",,.T.,.F.,.T.,)

oDlgLoc:SetInitBlock({|| oGetLocali:SetFocus()})
oDlgLoc:Activate()

If lLocaliza .And. !Empty(cGetLocali)
	nI := oFolderFil:nOption //Elemento correspondente ao folder da filial corrente.
	If nI > 0
		nX := aFModulos[nI]:nOption	//Elemento correspondente ao subfolder do modulo corrente.
	EndIf

	If nI > 0 .And. nX > 0
		If nRadLocali = 2
			nInicio := aBrwMod[nI][nX]:nAt+1	//Posi玢o da linha do lan鏰mento posicionado
		Else
			nInicio := 1
		EndIf
	
		For nY := nInicio To Len(aBrwMod[nI][nX]:aArray)
			If AllTrim(cGetLocali) $ AllTrim(Upper(aBrwMod[nI][nX]:aArray[nY][5]))
				aBrwMod[nI][nX]:GoPosition(nY)
				aBrwMod[nI][nX]:Refresh()
				lAchou := .T.
				Exit
			EndIf	
		Next nY
			
		//aBrwCtb[nI][nX]:SetFilter(cCpoFil, &cTopFun, &cBotFun)
		//aBrwCtb[nI][nX]:Refresh()
	EndIf
EndIf				    

Return Nil
*/

Static Function ChangeCT1()
Local aAreaCT1  := CT1->(GetArea())
Local nPosLinha := 0
Local nX        := 0
Local nI        := oFolderFil:nOption
Local cModulo   := ""

cContaDMod := ""
cContaCMod := ""
cContaDCtb := ""
cContaCCtb := ""

If nI > 0
	nX := aFModulos[nI]:nOption
EndIf

If nI > 0 .And. nX > 0
	cModulo := aFModulos[nI]:aPrompts[nX]
	If (cModulo != "34") // inserido o !=34 pois no modulo de contabilidade n鉶 existe compara玢o
		nPosLinha := aBrwMod[nI][nX]:nAt
	
		If nPosLinha > 0
			//Lado M骴ulo
			If !Empty(aBrwMod[nI][nX]:aArray[nPosLinha][9])
				cContaDMod := Posicione("CT1",1,xFilial("CT1")+aBrwMod[nI][nX]:aArray[nPosLinha][9],"CT1_DESC01")
			EndIf
			
			If !Empty(aBrwMod[nI][nX]:aArray[nPosLinha][10])
				cContaCMod := Posicione("CT1",1,xFilial("CT1")+aBrwMod[nI][nX]:aArray[nPosLinha][10],"CT1_DESC01")
			EndIf
		
			//Lado Cont醔il
			If !Empty(aBrwCtb[nI][nX]:aArray[nPosLinha][11])
				cContaDCtb := Posicione("CT1",1,xFilial("CT1")+aBrwCtb[nI][nX]:aArray[nPosLinha][11],"CT1_DESC01")
			EndIf
			
			If !Empty(aBrwCtb[nI][nX]:aArray[nPosLinha][12])
				cContaCCtb := Posicione("CT1",1,xFilial("CT1")+aBrwCtb[nI][nX]:aArray[nPosLinha][12],"CT1_DESC01")
			EndIf								
		EndIf				
	EndIf					
EndIf
		
oSayDebMod:Refresh()
oSayCreMod:Refresh()
oSayDebCtb:Refresh()
oSayCreCtb:Refresh()

RestArea(aAreaCT1)
Return Nil

Static Function Rastrear()
Local aAreaCT2    := CT2->(GetArea()) 
Local nPosLinha   := 0
Local nX          := 0
Local nI          := oFolderFil:nOption
Private cCadastro := "Rastrear Lan鏰mentos Cont醔eis"
Private aRotina := {}   

AAdd(aRotina, {"OK",  "Alert('OK')", 0 , 2, 0, Nil})

If nI > 0
	nX := aFModulos[nI]:nOption
EndIf

If nI > 0 .And. nX > 0
	nPosLinha := aBrwCtb[nI][nX]:nAt
	
	If nPosLinha > 0		
		If Len(aBrwCtb[nI][nX]:aArray[nPosLinha]) > 20 .And.;
			ValType(aBrwCtb[nI][nX]:aArray[nPosLinha][21]) == "N" .And.;
			aBrwCtb[nI][nX]:aArray[nPosLinha][21] > 0
			 
			CT2->(dbGoTo(aBrwCtb[nI][nX]:aArray[nPosLinha][21]))
			CtbC010Rot("CT2",CT2->(Recno()),2,Nil)			
		EndIf
	EndIf
EndIf

RestArea(aAreaCT2)
Return Nil

/*
Static Function CTBC010ROT( cAlias, nReg, nOpc, nRecDes)
Local lRet		:= .T.
Local cSequenc	:= CT2->CT2_SEQUEN
Local dDtCV3	:= CT2->CT2_DTCV3
Local lDel		:= Set(_SET_DELETED) 
Local nRecno  := 0
Local aArea   := CT2->(GetArea())
Local aAreaCT2:= {} 
Local cTabOri := cAlias
Local nRecOri := nReg
DEFAULT nRecDes := 0

lRet := Ctc010Val(cSequenc,dDtCV3)
RestArea(aArea)
If lRet	
	// Se for um lan鏰mento aglutinado, exibe todos os lan鏰mentos aglutinados para que o 
	// usu醨io escolha qual quer rastrear.
	If Ct2->CT2_AGLUT == "1"
		CtbAglut(cSequenc,dDtCV3,cTabOri,nRecOri)
	ElseIf CT2->CT2_AGLUT == "2"				// Lancamento nao Aglutinado
		CtbRastrear()			
	ElseIf CT2->CT2_AGLUT == "3"				// Lancamento importado
		Help(" ",1,"CTB010IMP")
	EndIf
EndIf
RestArea(aArea)
Set(_SET_DELETED, lDel)
RestInter()
Return nil
*/

User Function F3TabCTL()
Local lRet       := .F.
Local lExceto    := AllTrim(ReadVar()) == "CEXCEALIAS"
Local oDlgCTL    := Nil
Local oPanelCTL  := Nil
Local oTempTable := Nil
Local aFields    := {}
Local aFields2   := {}
Local bOk		 := {||((lRet := .T., oMrkBrowse:Deactivate(), oPanelCTL:End()))}
Local cFilSel    := "!Empty(TMP->OK)"

//Inicia Vari醰el
cRetF3Mark := Space(150)

Aadd(aFields, {"OK",    "C", 02, 0})
Aadd(aFields, {"ALIAS", "C", 03, 0})
Aadd(aFields, {"NOME",  "C", 40, 0})

Aadd(aFields2, {"Alias", "ALIAS", "C", 03, 0, "@!"})
Aadd(aFields2, {"Nome",  "NOME",  "C", 40, 0, "@!"})

//Cria o objeto da Tabela Temporaria
oTempTable := FWTemporaryTable():New("TMP")

//Input dos campos na Tabela Tempor醨ia
oTemptable:SetFields(aFields)

//Criacao da Tabela no Banco de Dados
oTempTable:Create()

//Criacao da Query que ir� alimentar a Tabela Tempor醨ia
cQuery := "SELECT DISTINCT CTL_ALIAS
cQuery += " FROM " + RetSqlName("CTL") 
cQuery += " WHERE CTL_FILIAL = '" + xFilial("CTL") + "'
cQuery += " AND D_E_L_E_T_ = ' '"
cQuery += " ORDER BY CTL_ALIAS
     
//Cria uma Tabela Termpor醨ia para Query
MPSysOpenQuery(cQuery, "QRY")
 
While !QRY->(Eof())
	RecLock("TMP", .T.)
    TMP->OK    := Iif(lExceto,Iif(QRY->CTL_ALIAS $ AllTrim(cExceAlias), "XX","  "),Iif(QRY->CTL_ALIAS $ AllTrim(cOnlyAlias), "XX","  "))    
    TMP->ALIAS := QRY->CTL_ALIAS 
    TMP->NOME  := Posicione("SX2",1,QRY->CTL_ALIAS,"X2_NOME")
    MsUnLock("TMP")
    
    QRY->(dbSkip())    
EndDo
QRY->(dbCloseArea())

oDlgCTL := FWDialogModal():New()	
oDlgCTL:SetBackground(.F.)          
oDlgCTL:SetTitle(Iif(lExceto, "Exceto Tabelas","Somente Tabelas"))	
oDlgCTL:SetEscClose(.T.)                             
oDlgCTL:SetSize(250,350)		
oDlgCTL:EnableFormBar(.T.)
oDlgCTL:CreateDialog()              	
oPanelCTL := oDlgCTL:GetPanelMain()
oDlgCTL:CreateFormBar()

oDlgCTL:AddButton("Confirmar",{|| (lRet := .T.,oDlgCTL:DeActivate())},"Confirmar",,.T.,.F.,.T.,)			 
oDlgCTL:AddButton("Cancelar",{|| oDlgCTL:DeActivate()},"Cancelar",,.T.,.F.,.T.,)

oMrkBrowse := FWMarkBrowse():New()	
oMrkBrowse:SetOwner(oPanelCTL)		
oMrkBrowse:SetFieldMark("OK")			
oMrkBrowse:SetAlias("TMP")
oMrkBrowse:SetTemporary(.T.)
oMrkBrowse:SetMenuDef("")
//oMrkBrowse:AddButton("Confirmar",bOk,,2)
oMrkBrowse:SetIgnoreARotina(.T.)
oMrkBrowse:SetMark("XX","TMP","OK")
oMrkBrowse:bAllMark := {|| .F.}
oMrkBrowse:DisableReport()
oMrkBrowse:SetFields(aFields2)
oMrkBrowse:DisableFilter()
oMrkBrowse:DisableLocate()
oMrkBrowse:DisableSeek()
oMrkBrowse:DisableReport()
oMrkBrowse:Activate()             	
oDlgCTL:Activate()

If lRet
	dbSelectArea("TMP")
	TMP->(DbSetfilter({|| &cFilSel}, cFilSel))
	TMP->(dbGoTop())
	If !TMP->(Eof())
		While !TMP->(Eof())			
			cRetF3Mark += Iif(!Empty(cRetF3Mark), ";", "") + TMP->ALIAS
			TMP->(dbSkip())		
		EndDo 						
	EndIf
	cRetF3Mark := PadR(AllTrim(cRetF3Mark),150," ")	
	
	If lExceto
		cExceAlias := cRetF3Mark
		oExceAlias:Refresh()
	Else
		cOnlyAlias := cRetF3Mark
		oOnlyAlias:Refresh()
	EndIf
EndIf

//Exclui a Tabela Termpor醨ia do Bando de Dados
oTempTable:Delete()

Return lRet

User Function RetF3Mark()
Return cRetF3Mark



Static Function ChangeCTB()
Local nPosLinha := 0
Local nX        := 0
Local nZ        := 0
Local nY        := 0
Local nI        := oFolderFil:nOption
Local cModulo   := ""
Local nUnique   := {}
Local aCtb      := {}
Local cLineCtb  := ""

If nI > 0
	nX := aFModulos[nI]:nOption
EndIf

If nI > 0 .And. nX > 0
	cModulo := aFModulos[nI]:aPrompts[nX]
	If (cModulo != "34") // inserido o !=34 pois no modulo de contabilidade n鉶 existe compara玢o
		nPosLinha := aBrwMod[nI][nX]:nAt
	
		If nPosLinha > 0
			//Lado M骴ulo
			nUnique := aBrwMod[nI][nX]:aArray[nPosLinha][18]
			
			For nY := 1 To Len(aResultSet[nI][2][nX][3])
				If aResultSet[nI][2][nX][3][nY][22] = nUnique
					Aadd(aCtb, aResultSet[nI][2][nX][3][nY]) 					 
					aBrwCtb[nI,nX]:SetArray(aCtb)
					
					For nZ := 1 to len(aCabCtb)	
						If aTipoCtb[nZ] == "N"
							cLineCtb += "Transform(aCtb[1," + cValToChar(nZ) + "],'" + PesqPict('CT2','CT2_VALOR') + "'),"
						Else 
							cLineCtb += "aCtb[1,"+cValToChar(nZ)+"],"	
						Endif							
					Next nZ                                        
			
					cLineCtb := Substr(cLineCtb,1,len(cLineCtb)-1)					
					aBrwCtb[nI,nX]:bLine := &("{|| {" + cLineCtb + "}}")
					
					aBrwCtb[nI,nX]:Refresh()
					Exit
				EndIf						
			Next nX
			
			
											
		EndIf				
	EndIf					
EndIf
		
Return Nil