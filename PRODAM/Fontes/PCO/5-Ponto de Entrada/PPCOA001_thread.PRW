#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

Static GRID_STEP 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PPCOA001 บ Autor ณ Microsiga          บ Data ณ  30/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Simula็ใo de Or็amento                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PRODAM                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PPCOA001()
Local aArea	:= GetArea()
Local oDlg
Local oGet
Local oDtDe
Local oDtAte
Local oCtade
Local oCtaAte
Local oCcDe
Local oCcAte
Local oCLVLDe
Local oCLVLAte
Local oOperDe
Local oOperAte
Local oItemDe
Local oItemAte
Local oTpSaldo
Local oClasseDe
Local oClasseAte
Local oPercent
Local aObjects
Local aCampo := {}
Local cCampo := ""

PRIVATE aHeaderAK2	:= {}
PRIVATE aColsAK2	:= {}
PRIVATE dDataDe  	:= CriaVar("AKD_DATA")
PRIVATE dDataAte 	:= CriaVar("AKD_DATA")
PRIVATE cCtaDe   	:= Criavar("AKD_CO")
PRIVATE cCtaAte  	:= Replicate("Z",TamSX3("AKD_CO")[1])
PRIVATE cCcDe  		:= Criavar("AKD_CC")
PRIVATE cCcAte 		:= Replicate("Z",TamSX3("AKD_CC")[1])
PRIVATE cItemDe  	:= Criavar("AKD_ITCTB")
PRIVATE cItemAte 	:= Replicate("Z",TamSX3("AKD_ITCTB")[1])
PRIVATE cCLVLDe	    := Criavar("AKD_CLVLR")
PRIVATE cCLVLAte	:= Replicate("Z",TamSX3("AKD_CLVLR")[1])
PRIVATE cOperDe     := Criavar("AKD_OPER")
PRIVATE cOperAte    := Replicate("Z",TamSX3("AKD_OPER")[1])
PRIVATE cTpSaldo	:= Criavar("AKD_TPSALD")
PRIVATE cClasseDe 	:= Criavar("AKD_CLASSE")
PRIVATE cClasseAte 	:= Replicate("Z",TamSX3("AKD_CLASSE")[1])
PRIVATE nPercent	:= 100
Private aPeriodos 	:= PcoRetPer()
Private cPlanOri 	:= AK1->AK1_CODIGO
Private cRevOri 	:= IF(Empty(AK1->AK1_VERREV), AK1->AK1_VERSAO, AK1->AK1_VERREV)
PRIVATE cArquivx := "AK2"

aCampo := {"AK2_CO","AK2_DESCCO","AK2_CC","AK2_DESCCC","AK2_CLASSE","AK2_DESCLA"}
For nCnt:=1 To Len(aCampo)
	MontaaHeader(aCampo[nCnt],@aHeaderAK2)
Next	

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem do aHeader do AK2                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("AK2")
While !EOF() .And. (x3_arquivo =="AK2")
	//( AllTrim(X3_CAMPO) $ "AK2_CO|AK2_DESCCO|AK2_ITCTB|AK2_DESCIT|AK2_CLVLR|AK2_DESCCL|AK2_CC|AK2_DESCCC|AK2_OPER|AK2_CLASSE|AK2_DESCLA")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And. ;
		( AllTrim(X3_CAMPO) $ "AK2_CO|AK2_DESCCO|AK2_CC|AK2_DESCCC|AK2_CLASSE|AK2_DESCLA") .or. (Alltrim(SX3->X3_CAMPO) $ "AK2_DESCCO|AK2_DESCCC") 
		AADD(aHeaderAK2,{ 	TRIM(x3titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		"PCOChk_Acesso(cArquivx, oGet, oGet:nAt)"+If(!Empty(SX3->X3_VALID),".And.("+SX3->X3_VALID+")",""),;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_F3,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX,;
		SX3->X3_RELACAO,;
		"PCOChk_Acesso(cArquivx, oGet, oGet:nAt)"+If(!Empty(SX3->X3_WHEN),".And.("+SX3->X3_WHEN+")","")})
	Endif
	dbSkip()
End
*/

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("AK2_VALOR")
For nX :=1 To Len(aPeriodos)
	AADD(aHeaderAK2,{ aPeriodos[nX],;
	SX3->X3_CAMPO,;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	"PCOChk_Acesso(cArquivx, oGet, oGet:nAt)"+If(!Empty(SX3->X3_VALID),".And.("+SX3->X3_VALID+")",""),;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	"PCOChk_Acesso(cArquivx, oGet, oGet:nAt)"+If(!Empty(SX3->X3_WHEN),".And.("+SX3->X3_WHEN+")","")})
Next

aadd(aColsAK2,Array(Len(aHeaderAK2)+1))
For ny := 1 to Len(aHeaderAK2)
	aColsAK2[1][ny] := CriaVar(aHeaderAK2[ny][2])
Next ny
aColsAK2[1][Len(aHeaderAK2)+1] := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณ Montagem da Tela                                             ณ
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbSelectArea("AKD")

aObjects 	:= {}
aSizeAut	:= MsAdvSize()
Aadd( aObjects, { 100, 100, .T., .T. } )
Aadd( aObjects, { 100, 100, .T., .T. } )
Aadd( aObjects, { 100, 015, .T., .F. } )
aInfo		:= { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
aPosObj	:= MsObjSize( aInfo, aObjects )
aPosGet	:= MsObjGetPos(aSizeAut[ 3 ]-aSizeAut[ 1 ], 315, {{003, 033, 160, 200, 240, 265}} )

oDlg := MSDIALOG():New(aSizeAut[7],000, aSizeAut[6],aSizeAut[5], "Simula็ใo",,,,,,,,,.T.)

oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,115,115,.T.,.T. )
oPanel:Align := CONTROL_ALIGN_TOP

@ C(010),C(005) Say "Perํodo de: "  Size C(060),C(010) COLOR CLR_BLACK PIXEL OF oPanel
@ C(010),C(055) MsGet oDtDe  	   Var dDataDe  Size C(039),C(007) COLOR CLR_BLACK Picture PesqPict("AKD","AKD_DATA") F3 CpoRetF3('AKD_DATA') PIXEL OF oPanel
@ C(010),C(110) Say "Perํodo at้: "  Size C(060),C(010) COLOR CLR_BLACK PIXEL OF oPanel
@ C(010),C(160) MsGet oDtAte  	  Var dDataAte  Size C(039),C(007) COLOR CLR_BLACK Picture PesqPict("AKD","AKD_DATA") F3 CpoRetF3('AKD_DATA')  PIXEL OF oPanel

@ C(020),C(005) Say "Conta or็amentแria de: "  Size C(060),C(010) COLOR CLR_BLACK PIXEL OF oPanel
@ C(020),C(055) MsGet oCtade  	   Var cCtaDe  Size C(039),C(007) COLOR CLR_BLACK Picture PesqPict("AKD","AKD_CO") F3 CpoRetF3('AKD_CO') PIXEL OF oPanel
@ C(020),C(110) Say "Conta or็amentแria at้: "  Size C(060),C(010) COLOR CLR_BLACK PIXEL OF oPanel
@ C(020),C(160) MsGet oCtaAte  	   Var cCtaAte  Size C(039),C(007) COLOR CLR_BLACK Picture PesqPict("AKD","AKD_CO") F3 CpoRetF3('AKD_CO') PIXEL OF oPanel

//@ C(030),C(005) Say "Item contแbil de: "  Size C(060),C(010) COLOR CLR_BLACK PIXEL OF oPanel
//@ C(030),C(055) MsGet oItemdE  	   Var cItemDe  Size C(039),C(007) COLOR CLR_BLACK  Picture PesqPict("AKD","AKD_ITCTB") F3 CpoRetF3('AKD_ITCTB') PIXEL OF oPanel
//@ C(030),C(110) Say "Item contแbil at้: "  Size C(060),C(010) COLOR CLR_BLACK PIXEL OF oPanel
//@ C(030),C(160) MsGet oItemAte  	   Var cItemAte  Size C(039),C(007) COLOR CLR_BLACK Picture PesqPict("AKD","AKD_ITCTB") F3 CpoRetF3('AKD_ITCTB') PIXEL OF oPanel

//@ C(040),C(005) Say "Classe de valor de: "  Size C(060),C(010) COLOR CLR_BLACK PIXEL OF oPanel
//@ C(040),C(055) MsGet oCLVLDe  	   Var cCLVLDe  Size C(039),C(007) COLOR CLR_BLACK Picture PesqPict("AKD","AKD_CLVLR") F3 CpoRetF3('AKD_CLVLR') PIXEL OF oPanel
//@ C(040),C(110) Say "Classe de valor at้: "  Size C(060),C(010) COLOR CLR_BLACK PIXEL OF oPanel
//@ C(040),C(160) MsGet oCLVLAte  	   Var cCLVLAte  Size C(039),C(007) COLOR CLR_BLACK Picture PesqPict("AKD","AKD_CLVLR") F3 CpoRetF3('AKD_CLVLR') PIXEL OF oPanel

@ C(030)/*050*/,C(005) Say "Centro de Custo de: "  Size C(060),C(010) COLOR CLR_BLACK PIXEL OF oPanel
@ C(030),C(055) MsGet oCcDe  	 Var cCcDe  Size C(039),C(007) COLOR CLR_BLACK Picture PesqPict("AKD","AKD_CC") F3 CpoRetF3('AKD_CC') PIXEL OF oPanel
@ C(030),C(110) Say "Centro de Custo at้: "  Size C(060),C(010) COLOR CLR_BLACK PIXEL OF oPanel
@ C(030),C(160) MsGet oCCAte  	 Var cCCAte  Size C(039),C(007) COLOR CLR_BLACK Picture PesqPict("AKD","AKD_CC") F3 CpoRetF3('AKD_CC') PIXEL OF oPanel

//@ C(060),C(005) Say "Opera็ใo de: "  Size C(060),C(010) COLOR CLR_BLACK PIXEL OF oPanel
//@ C(060),C(055) MsGet oOperDe  	 Var cOperDe  Size C(039),C(007) COLOR CLR_BLACK Picture PesqPict("AKD","AKD_OPER") F3 CpoRetF3("AKD_OPER") PIXEL OF oPanel
//@ C(060),C(110) Say "Opera็ใo at้: "  Size C(060),C(010) COLOR CLR_BLACK PIXEL OF oPanel
//@ C(060),C(160) MsGet oOperAte  	 Var cOperAte  Size C(039),C(007) COLOR CLR_BLACK Picture PesqPict("AKD","AKD_OPER") F3 CpoRetF3("AKD_OPER") PIXEL OF oPanel

@ C(040)/*070*/,C(005) Say "Classe: "      Size C(060),C(010) COLOR CLR_BLACK PIXEL OF oPanel
@ C(040),C(055) MsGet oClasseDe  	     Var cClasseDe  Size C(025),C(007) COLOR CLR_BLACK Picture PesqPict("AKD","AKD_CLASSE") F3 CpoRetF3('AKD_CLASSE') Valid IIf(Empty(cClasseDe),(MsgAlert("Informar campo 'Classe'."),.F.),.T.) PIXEL OF oPanel
//@ C(070),C(110) Say "Classe Ate: "      Size C(060),C(010) COLOR CLR_BLACK PIXEL OF oPanel
//@ C(070),C(160) MsGet oClasseAte  	     Var cClasseAte  Size C(025),C(007) COLOR CLR_BLACK Picture PesqPict("AKD","AKD_CLASSE") F3 CpoRetF3('AKD_CLASSE') PIXEL OF oPanel

//@ C(080),C(005) Say "Tipo de Saldo: " Size C(060),C(010) COLOR CLR_BLACK PIXEL OF oPanel
//@ C(080),C(055) MsGet oTpSaldo  	 Var cTpSaldo  Size C(025),C(007) COLOR CLR_BLACK Picture PesqPict("AKD","AKD_TPSALD") F3 CpoRetF3('AKD_TPSALD') Valid CheckSX3('AKD_TPSALD',cTpSaldo) PIXEL OF oPanel
@ C(040)/*080*/,C(110) Say "% Aplica็ใo: "  Size C(060),C(010) COLOR CLR_BLACK PIXEL OF oPanel
@ C(040),C(160) MsGet oPercent  	 Var nPercent  Size C(025),C(007)  COLOR CLR_BLACK Picture "@R 999.99" PIXEL OF oPanel

oRodape := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,30,30,.T.,.T. )
oRodape:Align := CONTROL_ALIGN_BOTTOM

//@ C(008),C(340) BUTTON "Atualizar" SIZE 40,13 ACTION (IIf(Empty(cClasseDe),MsgAlert("Informar campo 'Classe'."),oGet:aCols := OKAtualiz(aColsAK2,aHeaderAK2))) PIXEL OF oRodape
@ C(008),C(340) BUTTON "Atualizar" SIZE 40,13 ACTION ValidEfet(cClasseDe,@oGet,aColsAK2,aHeaderAK2,dDataDe,dDataAte) PIXEL OF oRodape
@ C(008),C(390) BUTTON "Efetivar" SIZE 40,13 ACTION (xEfetiva(aColsAK2,aHeaderAK2)) PIXEL OF oRodape
@ C(008),C(440) BUTTON "Sair" SIZE 40,13 ACTION (oDlg:End()) PIXEL OF oRodape

oGet:= MsNewGetDados():New(aPosObj[2,1]-50,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],0,"AllwaysTrue", "AllwaysTrue","", ,000, 999,,,,, aHeaderAK2, aColsAK2)
oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

oDlg:lCentered := .T.
oDlg:Activate()

RestArea(aArea)

Return


Static Function ValidEfet(cClasseDe,oGet,aColsAK2,aHeaderAK2,dDataDe,dDataAte)

Local lRet := .T.

If Empty(cClasseDe)
	lRet := .F.
	APMsgAlert("Informar campo 'Classe'.")
Endif

// periodo nao pode ser maior que 12 meses
If lRet
	If Year(dDataDe) <> Year(dDataAte)
		If 12-Month(dDataDe)+Month(dDataAte) >= 12
			lRet := .F.
			APMsgAlert("Informar um perํodo menor que 12 meses.")
		Endif
	Endif
Endif			
			
If lRet
	oGet:aCols := OKAtualiz(aColsAK2,aHeaderAK2)
Endif	

Return(lRet)


Static Function MontaaHeader(cCampo,aHeaderAK2)

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek(cCampo)
	AADD(aHeaderAK2,{;
	TRIM(x3titulo()),;
	SX3->X3_CAMPO,;
	SX3->X3_PICTURE,;
	SX3->X3_TAMANHO,;
	SX3->X3_DECIMAL,;
	"PCOChk_Acesso(cArquivx, oGet, oGet:nAt)"+If(!Empty(SX3->X3_VALID),".And.("+SX3->X3_VALID+")",""),;
	SX3->X3_USADO,;
	SX3->X3_TIPO,;
	SX3->X3_F3,;
	SX3->X3_CONTEXT,;
	SX3->X3_CBOX,;
	SX3->X3_RELACAO,;
	"PCOChk_Acesso(cArquivx, oGet, oGet:nAt)"+If(!Empty(SX3->X3_WHEN),".And.("+SX3->X3_WHEN+")","")})
Endif

Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOKAtualiz บ Autor ณ Microsiga          ณ Data  ณ 30/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Saldo Historico - Simulacao                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PRODAM                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function OKAtualiz(aCols,aHeader)
Local oProcess

oProcess := MsNewProcess():New( { | lEnd | aCols := xProcAt(@lEnd,oProcess,aCols,aHeader) }, "Atualizando", "Carregando dados da folha, aguarde...", .F. )
oProcess:Activate()

Return aClone(aCols)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOKAtualiz บ Autor ณ Microsiga          ณ Data  ณ 30/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Saldo Historico - Simulacao                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PRODAM                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function xProcAt(lEnd,oProcess,aCols,aHeader)
Local aArea := GetArea()
Local _cQuery := ""
Local cAliasTRB := GetNextAlias()
Local cAliasTMP := GetNextAlias()
Local aEstrut 	:= {}
Local cArqTMP  	:= ""
Local nPosCo	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "AK2_CO"} )
Local nRegs := 0

//Limpa aCols
aCols := {}
aadd(aCols,Array(Len(aHeader)+1))
For ny := 1 to Len(aHeader)
	aCols[1][ny] := CriaVar(aHeader[ny][2])
Next ny
aCols[1][Len(aHeader)+1] := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Estrutura do arquivo temporario ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aEstrut, { "AK2_CO"		,"C", TamSx3("AK2_CO")[1], 0 } )
aAdd( aEstrut, { "AK2_DESCCO"	,"C", TamSx3("AK5_DESCRI")[1], 0 } )
aAdd( aEstrut, { "AK2_CC"		,"C", TamSx3("AK2_CC")[1], 0 } )
aAdd( aEstrut, { "AK2_DESCCC"	,"C", TamSx3("CTT_DESC01")[1], 0 } )
//aAdd( aEstrut, { "AK2_ITCTB"	,"C", TamSx3("AK2_ITCTB")[1], 0 } )
//aAdd( aEstrut, { "AK2_CLVLR"	,"C", TamSx3("AK2_CLVLR")[1], 0 } )
aAdd( aEstrut, { "AK2_CLASSE"	,"C", TamSx3("AK2_CLASSE")[1], 0 } )
//aAdd( aEstrut, { "AK2_OPER"		,"C", TamSx3("AK2_OPER")[1], 0 } )

// Campos de Acordo com o Periodo
For nX := 1 to Len(aPeriodos)
	aAdd( aEstrut, { "P"+Alltrim(Str(Month(Ctod(Substr(aPeriodos[nX],1,10))))) 	,"N", TamSx3("AK2_VALOR")[1], 2 } )
Next nX

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o arquivo temporario ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cArqTMP := CriaTrab( aEstrut, .T. )
dbUseArea( .T.,,cArqTMP, cAliasTmp, .F., .F. )

//IndRegua( cAliasTmp, cArqTMP, "AK2_CO+AK2_CC+AK2_ITCTB+AK2_CLVLR+AK2_CLASSE+AK2_OPER",,,"Criando Indice, aguarde..." )
IndRegua( cAliasTmp, cArqTMP, "AK2_CO+AK2_CC+AK2_CLASSE",,,"Criando Indice, aguarde..." )
dbClearIndex()
dbSetIndex( cArqTMP + OrdBagExt() )

//Query
//cQuery :=  "SELECT AKD_CO, AKD_CC, AKD_ITCTB, AKD_CLVLR, AKD_CLASSE, AKD_OPER, AKD_DATA, "
//cQuery +=  "CASE WHEN AKD_TIPO = '1' THEN AKD_VALOR1 ELSE AKD_VALOR1*-1 END AKD_VALOR1 "
//cQuery +=  "FROM "+RetSqlName("AKD")
//cQuery +=  " WHERE AKD_FILIAL = '"+xFilial("AKD")+"' AND "
//----//cQuery +=  "AKD_CODPLA = '"+cPlanOri+"' AND AKD_VERSAO = '"+cRevOri+"' AND "
//cQuery +=  "AKD_DATA BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' AND "
//cQuery +=  "AKD_CO BETWEEN '"+cCtaDe+"' AND '"+cCtaAte+"' AND "
//cQuery +=  "AKD_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"' AND "
//cQuery +=  "AKD_ITCTB BETWEEN '"+cItemDe+"' AND '"+cItemAte+"' AND "
//cQuery +=  "AKD_CLVLR BETWEEN '"+cCLVLDe+"' AND '"+cCLVLAte+"' AND "
//cQuery +=  "AKD_OPER BETWEEN '"+cOperDe+"' AND '"+cOperAte+"' AND "
//cQuery +=  "AKD_CLASSE BETWEEN '"+cClasseDe+"' AND '"+cClasseAte+"' AND "
//cQuery +=  "AKD_TPSALD = '"+cTpSaldo+"' AND "
//cQuery +=  "AKD_STATUS = '1' AND "
//cQuery +=  "AKD_TIPO <> '3' AND "
//cQuery +=  "D_E_L_E_T_ = '' "
//cQuery +=  "ORDER BY AKD_CO,AKD_CC,AKD_ITCTB,AKD_CLVLR,AKD_CLASSE,AKD_OPER

//cQuery := " SELECT SUM(RD_VALOR) VALOR, RD_CC CUSTO,RD_DATARQ PERIODO, RV_XCTAORC CONTAO, RV_XGRUPO GRUPORC,RV_XATUALI CORRIGE "
cQuery := " SELECT RD_VALOR VALOR, RD_CC CUSTO,RD_DATARQ PERIODO, RV_XDEBITO CONTAO"
cQuery += " FROM " + RetSqlName ("SRV") + " A "
cQuery += " INNER JOIN " + RetSqlName ("SRD") + " B "
cQuery += " ON RD_FILIAL = '"+xFilial("SRD")+"' "
cQuery += " AND RD_PD = RV_COD "
cQuery += " AND RD_DATARQ BETWEEN '"+Substr(Dtos(dDataDe),1,6)+"' AND '"+Substr(Dtos(dDataAte),1,6)+"' "
cQuery += " AND RV_XDEBITO BETWEEN '"+cCtaDe+"' AND '"+cCtaAte+"' "
cQuery += " AND RD_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"' "
cQuery += " AND B.D_E_L_E_T_ = '' "
//cQuery += " LEFT OUTER JOIN " + RetSqlName ("AK5") + " AK5 "
//cQuery += " ON AK5_FILIAL = '"+xFilial("AK5")+"' "
//cQuery += " AND AK5_CODIGO = RV_XDEBITO "
//cQuery += " AND AK5.D_E_L_E_T_ = '' "
//cQuery += " LEFT OUTER JOIN " + RetSqlName ("CTT") + " CTT "
//cQuery += " ON CTT_FILIAL = '"+xFilial("CTT")+"' "
//cQuery += " AND CTT_CUSTO = RD_CC "
//cQuery += " AND CTT.D_E_L_E_T_ = '' "
cQuery += " WHERE RV_FILIAL = '"+xFilial("SRV")+"' "
cQuery += " AND RV_XDEBITO <> '' AND A.D_E_L_E_T_ = '' "
//cQuery += " GROUP BY RD_CC ,RD_DATARQ , RV_XDEBITO "

cQuery := ChangeQuery(cQuery)

If Select(cAliasTRB) > 0
	dbSelectArea(cAliasTRB)
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTRB,.T.,.T.)

dbEval({|x| nRegs++ },,{|| (cAliasTrb)->(!EOF())})
dbGotop()

oProcess:SetRegua1(nRegs)

If (cAliasTRB)->(!Eof())
	
	DbSelectArea("AK5")
	DbSelectArea("AK6")
	DbSelectArea("CTT")
	DbSelectArea("CTD")
	DbSelectArea("CTH")
	DbSelectArea(cAliasTRB)
	
	While (cAliasTRB)->(!Eof())
		oProcess:IncRegua1()

		dPeriodo := (cAliasTrb)->PERIODO+"01"
		
		//Grava dados Agrupados
		dbSelectArea(cAliasTmp)
		dbSetOrder(1)
		dbGotop(cAliasTmp)
		
		// verifica se existe o periodo na planilha
		IF (cAliasTmp)->(FieldPos("P"+Alltrim(Str(Month(STOD(dPeriodo)))))) == 0
			(cAliasTRB)->(dbSkip())
			Loop
		ENDIF
		
		If dbSeek((cAliasTRB)->(CONTAO+CUSTO))
			RecLock((cAliasTmp),.F.)
			(cAliasTmp)->&("P"+Alltrim(Str(Month(STOD(dPeriodo))))) +=  (((cAliasTrb)->VALOR * nPercent)/100)
			(cAliasTmp)->(MsUnLock())
		Else
			RecLock((cAliasTmp),.T.)
			(cAliasTmp)->AK2_CO 		:= (cAliasTrb)->CONTAO //(cAliasTrb)->AKD_CO
			(cAliasTmp)->AK2_CC		:= (cAliasTrb)->CUSTO //(cAliasTrb)->AKD_CC
			//(cAliasTmp)->AK2_ITCTB 	:= ""//(cAliasTrb)->AKD_ITCTB
			//(cAliasTmp)->AK2_CLVLR 	:= "" //(cAliasTrb)->AKD_CLVLR
			(cAliasTmp)->AK2_CLASSE	:= cClasseDe //(cAliasTrb)->AKD_CLASSE
			//(cAliasTmp)->AK2_OPER 	:= "" //(cAliasTrb)->AKD_OPER
			//For _nI := 1 to len(aPeriodos)
				(cAliasTmp)->&("P"+Alltrim(Str(Month(STOD(dPeriodo))))) :=  (((cAliasTrb)->VALOR * nPercent)/100)
				
				//(cAliasTmp)->&("P"+Subs((cAliasTrb)->PERIODO,5,2)) := (((cAliasTrb)->VALOR * nPercent)/100)
				
				//(cAliasTmp)->&("P"+alltrim(str(val(Subs(aPeriodos[_nI],4,2))))) := (((cAliasTrb)->VALOR * nPercent)/100)
			//Next _nI
			(cAliasTmp)->(MsUnLock())
		Endif
		
		dbSelectArea(cAliasTRB)
		(cAliasTRB)->(dbSkip())
	EndDo
Endif

// Atualiza aCols
dbSelectArea(cAliasTMP)
dbGotop()
nRegs := 0
dbEval({|x| nRegs++ },,{|| (cAliasTmp)->(!EOF())})
oProcess:SetRegua2(nRegs)
dbGotop()

While (cAliasTMP)->(!Eof())
	oProcess:IncRegua2("Carregando dados na tela, aguarde...")
	
	If !Empty(aCols[Len(aCols),nPosCo])
		aadd(aCols,Array(Len(aHeader)+1))
	Endif
	For nX := 1 to Len(aHeader)
		
		Do Case
			Case Alltrim(aHeader[nX,2]) =="AK2_VALOR"
				aCols[Len(aCols),nX]:= (cAliasTmp)->&("P"+Alltrim(Str(Month(Ctod(Substr(aHeader[nX,1],1,10))))))
			Case AllTrim(aHeader[nX,2])=="AK2_DESCLA"
				AK6->(dbSetOrder(1))
				If AK6->(dbSeek(xFilial("AK6")+(cAliasTmp)->AK2_CLASSE))
					aCols[Len(aCols),nX] := AK6->AK6_DESCRI
				EndIf
				
			Case AllTrim(aHeader[nX][2])=="AK2_DESCCO"
				AK5->(dbSetOrder(1))
				If AK5->(dbSeek(xFilial("AK5")+(cAliasTmp)->AK2_CO))
					aCols[Len(aCols),nX] := AK5->AK5_DESCRI
				EndIf
			Case AllTrim(aHeader[nX][2])=="AK2_DESCCC"
				CTT->(dbSetOrder(1))
				If CTT->(dbSeek(xFilial("CTT")+(cAliasTmp)->AK2_CC))
					aCols[Len(aCols),nX] := CTT->CTT_DESC01
				EndIf
			Case AllTrim(aHeader[nX][2])=="AK2_DESCIT"
				CTD->(dbSetOrder(1))
				If CTD->(dbSeek(xFilial("CTD")+(cAliasTmp)->AK2_ITCTB))
					aCols[Len(aCols),nX] := CTD->CTD_DESC01
				EndIf
			Case AllTrim(aHeader[nX][2])=="AK2_DESCCL"
				CTH->(dbSetOrder(1))
				If CTH->(dbSeek(xFilial("CTH")+(cAliasTmp)->AK2_CLVLR))
					aCols[Len(aCols),nX] := CTH->CTH_DESC01
				EndIf
			OtherWise
				aCols[Len(aCols),nX]:=FieldGet(FieldPos(aHeader[nX,2]))
		EndCase
		
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
	Next nX
	
	dbSelectArea(cAliasTMP)
	dbSkip()
EndDo

//Libera Alias e Arquivos Temporarios
If Select(cAliasTRB) > 0
	dbSelectArea(cAliasTRB)
	dbCloseArea()
Endif

If Select(cAliasTmp) != 0
	dbSelectArea(cAliasTmp)
	dbCloseArea()
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
Endif

RestArea(aArea)

Return aCols
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOKAtualiz บ Autor ณ Microsiga          ณ Data  ณ 30/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Saldo Historico - Simulacao                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PRODAM                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function xEfetiva(aCols,aHeader)
Local oWizard
Local cArquivo
Local aAreaAK1 	:= AK1->(GetArea())
Local aAreaAK2 	:= AK2->(GetArea())
Local aAreaAK3 	:= AK3->(GetArea())
Local aAreaAKE 	:= AKE->(GetArea())
Local lRet		:= .F.
Local lParam, lBrowse:=.T., lParam2
Local aParametros := {	{3,"Distribui็ใo"				, 1,{"Normal", "Especํfica"}	,160,,.F.}}
Local aConfig :=  {1}
Local aParam2  := {}
Local aConfig2 := {}
Local oProcess
Local nPosCo	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "AK2_CO"} )

Private lAllPeriod := .T.

If !Empty(aCols[Len(aCols),nPosCo])
	
	oWizard := APWizard():New("Aten็ใo"/*<chTitle>*/,;
	"Este assistente lhe ajudara a distribuir um determinado valor para os periodos da planilha atual."/*<chMsg>*/, "Distribui็ใo de Valores Apurados "/*<cTitle>*/, ;
	"Voc๊ devera escolher a forma de distribui็ใo e ao finalizar o assistente, este valor serแ distribuido conforme os parametros solicitados."+;
	CRLF+CRLF+"Planilha : "+Alltrim(AK1->AK1_CODIGO)+" - "+PadR(AK1->AK1_DESCRI,50),;
	{||.T.}/*<bNext>*/, ;
	{|| .T.}/*<bFinish>*/,;
	/*<.lPanel.>*/, , , /*<.lNoFirst.>*/)
	
	oWizard:NewPanel( "Distribui็ใo"/*<chTitle>*/,;
	"Neste passo voce deverแ informar a forma da distribui็ใo para a planilha or็amentแria."/*<chMsg>*/, ;
	{||.T.}/*<bBack>*/, ;
	{||.T.}/*<bNext>*/, ;
	{||.T.}/*<bFinish>*/,;
	.T./*<.lPanel.>*/,;
	{||Rat1_Par(oWizard,@lParam, aParametros, aConfig)}/*<bExecute>*/ )
	
	oWizard:NewPanel( "Perํodo destino"/*<chTitle>*/,;
	"Neste passo voce deverแ informar o perํodo destino para distribui็ใo."/*<chMsg>*/, ;
	{||.T.}/*<bBack>*/, ;
	{||.T.}/*<bNext>*/, ;
	{||lRet := .T.}/*<bFinish>*/, ;
	.T./*<.lPanel.>*/, ;
	{||Rat2_Par(oWizard, lParam2, aParam2, aPeriodos, aConfig, aConfig2)}/*<bExecute>*/ )
	
	oWizard:Activate( .T./*<.lCenter.>*/,;
	{||.T.}/*<bValid>*/, ;
	{||.T.}/*<bInit>*/, ;
	{||.T.}/*<bWhen>*/ )
	
	If lRet
		oProcess := MsNewProcess():New( { | lEnd | xGrvOrc(@lEnd,oProcess,aCols,aHeader,aConfig[1],aConfig2[1]) }, "Atualizando", "Aguarde, atualizando...", .F. )
		oProcess:Activate()
		
		Aviso("Efetiva็ใo de Importa็ใo.","Processo finalizado.",{"OK"})	
	Endif
	
Else
	MsgStop("Nใo existem itens para realizar a efetiva็ใo.")
	lRet := .F.
Endif

RestArea(aAreaAK1)
RestArea(aAreaAK2)
RestArea(aAreaAK3)
RestArea(aAreaAKE)

Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ xGrvOrc  บ Autor ณ Microsiga          ณ Data  ณ 30/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Saldo Historico - Simulacao                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PRODAM                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function xGrvOrc(lEnd,oProcess,aCols,aHeader,nTipo,nPeriodo)
Local nZ, nX
Local nPosCo	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "AK2_CO"} )
Local nPosCc	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "AK2_CC"} )
//Local nPosItem	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "AK2_ITCTB"} )
//Local nPosOper	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "AK2_OPER"} )
Local nPosClass	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "AK2_CLASSE"})
//Local nPosClvlr	:= Ascan(aHeader, {|e| Alltrim(e[2]) = "AK2_CLVLR"}  )
Local cItem		:=	""
Local cNivel	:= "001"
Local aRecAK3	:={}
Local lAglut 	:= .F.
Local dPerIni 	:= Iif(nTipo == 1,AK1->AK1_INIPER,cTod(Substr(aPeriodos[nPeriodo],1,10)))
Local dPerFim 	:= Iif(nTipo == 1,AK1->AK1_FIMPER,cTod(Substr(aPeriodos[nPeriodo],14,16)))
Local _nMaxReg  := GetMV("MV_PCOLIMI")
Local _nTotReg  := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a gravacao dos lancamentos do SIGAPCO          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

MsgRun('Excluindo Lan็amentos (AKD). Por favor aguarde....',, {|| xPcoA122(AK1->(RecNo()),.F.,nTipo,dPerIni,dPerFim,cCtaDe,cCtaAte,cCcDe,cCcAte,cClasseDe) } )
// Pesquisa e Deleta Orcamento
xDelOrc(nTipo,dPerIni,dPerFim)

//Inicia Gravacao dos Dados Simulados

//PcoIniLan('000252')

For nX := 1 to Len(aCols)
	
	oProcess:IncRegua1()
	oProcess:IncRegua2()
	
	aRecAK3	:={}
	
	For nZ := 1 to Len(aPeriodos)
		
		IF aCols[nX,Ascan(aHeader, {|e| Alltrim(e[1]) = Alltrim(aPeriodos[nZ])})] == 0
			Loop
		ENDIF
		
		dPerIni 	:= Iif(nTipo == 1,CTOD(Substr(aPeriodos[nZ],1,10)),CtoD(Substr(aPeriodos[nPeriodo],1,10)))
		dPerFim 	:= Iif(nTipo == 1,CTOD(Substr(aPeriodos[nZ],14,16)),CtoD(Substr(aPeriodos[nPeriodo],14,16)))
		
		//dbSelectArea("AK2")
		//dbSetOrder(1)
		//dbSeek(xFilial("AK2")+cPlanOri+cRevOri+aCols[nX,nPosCo]+DTOS(dPerIni)+"ZZZZ",.T.)
		//dbSkip(-1)
		
		// inicio
		dbSelectArea("AK2")
		dbSetOrder(5)
		
		IF !MsSeek(xFilial("AK2") + cPlanOri + cRevOri + aCols[nX,nPosCo] )
			cItem  := "0001"
		ELSE
			
			_cIDAnt := ""
			cItem   := ""
			
			While !Eof() .And. AK2->AK2_FILIAL + AK2->AK2_ORCAME + AK2->AK2_VERSAO + AK2->AK2_CO  == xFilial("AK2")+cPlanOri+cRevOri+aCols[nX,nPosCo]
				
				//If AK2->(AK2_CC+AK2_ITCTB+AK2_CLVLR+AK2_CLASSE+AK2_OPER) == aCols[nX,nPosCC]+aCols[nX,nPosITem]+aCols[nX,nPosCLVLR]+aCols[nX,nPosClass]+aCols[nX,nPosOper]
				If AK2->(AK2_CC+AK2_CLASSE) == aCols[nX,nPosCC]+aCols[nX,nPosClass]
					cItem	:=	AK2->AK2_ID
				Endif
				
				_cIDAnt := AK2->AK2_ID
				
				AK2->(dbSkip())
			Enddo
			
			IF Empty(cItem)
				cItem := Soma1(_cIDAnt)
			ELSE
				dbSelectArea("AK2")
				dbSetOrder(1)
				IF dbSeek(xFilial("AK2")+cPlanOri+cRevOri+aCols[nX,nPosCo]+DTOS(dPerIni)+cItem)
					lAglut := .T.
				ENDIF
			ENDIF
			
		ENDIF
		
		/*
		If xFilial("AK2")+cPlanOri+cRevOri+aCols[nX,nPosCo]+DTOS(dPerIni) == AK2_FILIAL+AK2_ORCAME+AK2_VERSAO+AK2_CO+DTOS(AK2_PERIOD)
		//If AK2->(AK2_CC+AK2_ITCTB+AK2_CLVLR+AK2_CLASSE+AK2_OPER) == aCols[nX,nPosCC]+aCols[nX,nPosITem]+aCols[nX,nPosCLVLR]+aCols[nX,nPosClass]+aCols[nX,nPosOper]
		If AK2->(AK2_CC+AK2_ITCTB+AK2_CLVLR+AK2_OPER) == aCols[nX,nPosCC]+aCols[nX,nPosITem]+aCols[nX,nPosCLVLR]+aCols[nX,nPosOper]
		cItem := AK2->AK2_ID
		lAglut := .T.
		Else
		cItem := Soma1(AK2->AK2_ID)
		Endif
		Else
		cItem := "0001"
		EndIf
		*/
		
		If !nTipo == 1
			
			//If AK2->(AK2_CO+AK2_CC+AK2_ITCTB+AK2_CLVLR+AK2_CLASSE+AK2_OPER+DTOS(AK2_PERIOD))==;
			//	aCols[nX,nPosCo]+aCols[nX,nPosCC]+aCols[nX,nPosITem]+aCols[nX,nPosCLVLR]+aCols[nX,nPosClass]+aCols[nX,nPosOper]+DTOS(dPerIni)
			If AK2->(AK2_CO+AK2_CC+AK2_CLASSE+DTOS(AK2_PERIOD))==;
				aCols[nX,nPosCo]+aCols[nX,nPosCC]+aCols[nX,nPosClass]+DTOS(dPerIni)				
				lAglut := .T.
			Else
				lAglut := .F.
			Endif
			
		Endif
		
		If !lAglut
			RecLock("AK2",.T.)
			AK2->AK2_FILIAL := xFilial("AK2")
			AK2->AK2_ORCAME := cPlanOri
			AK2->AK2_VERSAO := cRevOri
			AK2->AK2_MOEDA	:= 1
			AK2->AK2_PERIOD	:= dPerIni
			AK2->AK2_DATAI	:= dPerIni
			AK2->AK2_DATAF	:= dPerFim
			AK2->AK2_ID		:= cItem
			AK2->AK2_CO 	:= aCols[nX,nPosCo]
			AK2->AK2_CC 	:= aCols[nX,nPosCC]
			//AK2->AK2_ITCTB 	:= aCols[nX,nPosItem]
			//AK2->AK2_CLVLR 	:= aCols[nX,nPosClvlr]
			AK2->AK2_CLASSE := aCols[nX,nPosClass]
			//AK2->AK2_OPER 	:= aCols[nX,nPosOper]
			AK2->AK2_VALOR	:= aCols[nX,Ascan(aHeader, {|e| Alltrim(e[1]) = Alltrim(aPeriodos[nZ])})]
			If AK2->(FieldPos("AK2_XPRFOL"))
				AK2->AK2_XPRFOL := "S"
			Endif	
		Else
			RecLock("AK2",.F.)
			AK2->AK2_VALOR	+= aCols[nX,Ascan(aHeader, {|e| Alltrim(e[1]) = Alltrim(aPeriodos[nZ])})]
		Endif
		MsUnlock()
		
		dbSelectArea("AK3")
		dbSetOrder(1)
		
		If !dbSeek(xFilial('AK3')+AK2->AK2_ORCAME+AK2->AK2_VERSAO+AK2->AK2_CO)
			cNivel := "001"
			GravaAK3(AK2->AK2_ORCAME,AK2->AK2_VERSAO,AK2->AK2_CO,aRecAK3,@cNivel)
			
			For nt := Len(aRecAK3) to 1 Step -1
				cNivel := Soma1(cNivel)
				AK3->(dbGoto(aRecAK3[nt]))
				RecLock("AK3",.F.)
				AK3->AK3_NIVEL := cNivel
				MsUnlock()
			Next nt
		EndIf
		
		dbSelectArea("AK2")
		
		//PcoDetLan("000252","01","PCOA100")

		_nTotReg++
		lAglut	:= .F.
		
		IF _nTotReg = _nMaxReg
			_nTotReg := 0
			//PcoFinLan('000252')
			//PcoIniLan('000252')
		ENDIF
		
	Next nX
Next nZ

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a gravacao dos lancamentos do SIGAPCO            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//PcoFinLan('000252')

MsgRun('Atualizando Lan็amentos (AKD). Por favor aguarde....',, {|| xPcoA122(AK1->(RecNo()),.T.,nTipo,dPerIni,dPerFim,cCtaDe,cCtaAte,cCcDe,cCcAte,cClasseDe) } )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ GravaAK3    บAutor ณ Microsiga         บ Data ณ 21/11/11   บฑฑ
ฑฑฬออออออออออุอออออออออออออสออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณInclui as contas orcamentarias ref a tab (AK3)   posicionadoบฑฑ
ฑฑบ          ณutiliza recursividade ao chamar a funcao A200Nivel() para   บฑฑ
ฑฑบ          ณchamar novamente xIncConta para as contas pai     	      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GravaAK3(cOrcame,cVersao,cCO,aRecAK3,cNivel)

Local aArea := GetArea()
dbSelectArea("AK5")
dbSetOrder(1)
If MsSeek(xFilial("AK5")+cCO)
	PmsNewRec("AK3")
	AK3->AK3_FILIAL 	:= xFilial("AK3")
	AK3->AK3_ORCAME		:= cOrcame
	AK3->AK3_VERSAO		:= cVersao
	AK3->AK3_CO			:= cCO
	AK3->AK3_PAI		:= If(Empty(AK5->AK5_COSUP),cOrcame,AK5->AK5_COSUP)
	AK3->AK3_TIPO		:= AK5->AK5_TIPO
	AK3->AK3_DESCRI		:= AK5->AK5_DESCRI
	MsUnlock()
	aAdd(aRecAK3,AK3->(RecNo()))
	dbSelectArea("AK3")
	dbSetOrder(1)
	If !Empty(AK5->AK5_COSUP)
		If !dbSeek(xFilial('AK3')+cOrcame+cVersao+AK5->AK5_COSUP)
			GravaAK3(AK2->AK2_ORCAME,AK2->AK2_VERSAO,AK5->AK5_COSUP,aRecAK3,@cNivel)
		Else
			cNivel := AK3->AK3_NIVEL
		EndIf
	EndIf
EndIf
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ    Rat1_Par บAutor  ณMicrosiga         บ Data ณ 20/07/05   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para escolha da forma do rateio                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Rat1_Par(oWizard, lParam, aParametros, aConfig)

If lParam == NIL
	ParamBox(aParametros ,"Parametros", aConfig,,,.F.,120,3, oWizard:oMPanel[oWizard:nPanel])
	lParam := .T.
Else
	Rest_Par(aConfig)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัอออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ    Rest_ParบAutor  ณMicrosiga          บ Data ณ 30/07/05   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯอออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para restauracao dos conteudos das variaveis MV_PAR  บฑฑ
ฑฑบ          ณna navegacao entre os paineis do assistente de copia        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Rest_Par(aParam)
Local nX
Local cVarMem

For nX := 1 TO Len(aParam)
	cVarMem := "MV_PAR"+AllTrim(STRZERO(nX,2,0))
	&(cVarMem) := aParam[nX]
Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ    Rat2_Par  บAutor  ณMicrosiga         บ Data ณ 20/07/05  บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para parametrizar os percentuais nos periodos        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Rat2_Par(oWizard, lParam2, aParam2 ,aPeriodos, aConfig, aConfig2)

Local nX
Local aAux := {}

aAdd(aAux,Array(Len(aPeriodos)))
aParam2 := {}
aConfig2 := {1}

If aConfig[1] == 2 //Especifico
	For nX := 1 TO Len(aPeriodos)
		aAux[1][nX]:= aPeriodos[nX]
	Next
	aAdd(aParam2,{3,"Perํodo destino",1,aAux[1],100,,.F.})
Else
	aAdd(aParam2,{3,"Perํodo destino",1,{"Todos os perํodos da planilha or็amentแria."},120,,.F.})
EndIf

If lParam2 == NIL
	ParamBox(aParam2 ,"Parametros", aConfig2,,,.F.,120,3, oWizard:oMPanel[oWizard:nPanel])
	lParam2 := .T.
Else
	Rest_Par(aConfig2)
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  xDelOrc บ Autor ณ Microsiga          บ Data ณ  27/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Deleta dados da Pl. Orcamentaria antes da importacao do csvบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PRODAM                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function xDelOrc(nTipo,dPerIni,dPerFim)
Local cAliasDel := GetNextAlias()
Local cQuery := ""

// Deleta AK2
cQuery := "SELECT R_E_C_N_O_ AS NREG FROM "
cQuery += RetSqlName("AK2")+" "
cQuery += " WHERE AK2_FILIAL = '"+xFilial("AK2")+"' AND "
cQuery += " AK2_ORCAME = '"+cPlanOri+"' AND "
cQuery += " AK2_VERSAO = '"+cRevOri+"' AND "
If nTipo == 1
	cQuery +=  "AK2_PERIOD BETWEEN '"+Dtos(FirstDay(dPerIni))+"' AND '"+Dtos(dPerFim)+"' AND " //cQuery +=  "AK2_PERIOD BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' AND "
Else
	cQuery +=  "AK2_PERIOD BETWEEN '"+Dtos(dPerIni)+"' AND '"+Dtos(dPerFim)+"' AND "
Endif
cQuery += " AK2_CO BETWEEN '"+cCtaDe+"' AND '"+cCtaAte+"' AND "
cQuery += " AK2_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"' AND "
//cQuery += " AK2_ITCTB BETWEEN '"+cItemDe+"' AND '"+cItemAte+"'  AND "
//cQuery += " AK2_CLVLR BETWEEN '"+cCLVLDe+"' AND '"+cCLVLAte+"'  AND "
//cQuery += " AK2_OPER BETWEEN '"+cOperDe+"' AND '"+cOperAte+"'  AND "
//cQuery +=  "AK2_CLASSE BETWEEN '"+cClasseDe+"' AND '"+cClasseAte+"' AND "
cQuery += " AK2_CLASSE = '"+cClasseDe+"' AND "
If AK2->(FieldPos("AK2_XPRFOL"))
	cQuery += " AK2_XPRFOL = 'S' AND "
Endif	
cQuery += " D_E_L_E_T_ <> '*' "
cQuery := ChangeQuery(cQuery)

If Select(cAliasDel) > 0
	dbSelectArea(cAliasDel)
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDel,.T.,.F.)

DbSelectArea(cAliasDel)
dbGotop()

If (cAliasDel)->(!Eof())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Inicializa a gravacao dos lancamentos do SIGAPCO          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//PcoIniLan('000252')
	
	While (cAliasDel)->(!Eof())
		
		dbSelectArea("AK2")
		dbGoto((cAliasDel)->NREG)
		
		//PcoDetLan("000252","01","PCOA100",.T.,"00025201")
		Reclock("AK2",.F.,.T.)
		dbDelete()
		Msunlock()
		
		dbSelectArea(cAliasDel)
		dbSkip()
	Enddo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza a gravacao dos lancamentos do SIGAPCO            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//PcoFinLan('000252')
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPcoA122  บAutor  ณMicrosiga           บ Data ณ  02/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Chamada da funcao para controle de Threads na geracao dos  บฑฑ
ฑฑบ          ณ lancamentos da AKD                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xPcoA122(nRecAK1,lInclui,nTipo,dPerIni,dPerFim,cCtaDe,cCtaAte,cCcDe,cCcAte,cClasseDe)

Local nX
Local lRet        	:= .F.
Local cAliasTmp
Local cQuery      	:= ""
Local aRecGrid 		:= {}
Local nThread			:= 10 //SuperGetMv("MV_PCOTHRD",.T.,10)
Local cPlanRev		:= cPlanOri//MV_PAR02
Local cNewVers		:= cRevOri//MV_PAR03

Default nRecAK1 := AK1->( Recno() )

Private aParam:={}

GRID_STEP:= 100//10000

cAliasTmp := GetNextAlias() //Obtem o alias para a tabela temporaria
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuery para obter recnos da tabela AK2 ou AK3 da nova versao    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := " SELECT MIN(R_E_C_N_O_) MINRECNOAK, MAX(R_E_C_N_O_) MAXRECNOAK "
cQuery += " FROM " + RetSqlName( "AK2" )
cQuery += " WHERE "
cQuery += "        AK2_FILIAL ='" + xFilial( "AK2" ) + "' AND " 
cQuery += "        AK2_ORCAME ='" + cPlanRev + "' AND "
cQuery += "        AK2_VERSAO = '"+ cNewVers +"' AND "
If nTipo == 1
	cQuery +=  "AK2_PERIOD BETWEEN '"+Dtos(FirstDay(dPerIni))+"' AND '"+Dtos(dPerFim)+"' AND " //cQuery +=  "AK2_PERIOD BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' AND "
Else
	cQuery +=  "AK2_PERIOD BETWEEN '"+Dtos(dPerIni)+"' AND '"+Dtos(dPerFim)+"' AND "
Endif
cQuery += " AK2_CO BETWEEN '"+cCtaDe+"' AND '"+cCtaAte+"' AND "
cQuery += " AK2_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"' AND "
//cQuery += " AK2_ITCTB BETWEEN '"+cItemDe+"' AND '"+cItemAte+"'  AND "
//cQuery += " AK2_CLVLR BETWEEN '"+cCLVLDe+"' AND '"+cCLVLAte+"'  AND "
//cQuery += " AK2_OPER BETWEEN '"+cOperDe+"' AND '"+cOperAte+"'  AND "
//cQuery +=  "AK2_CLASSE BETWEEN '"+cClasseDe+"' AND '"+cClasseAte+"' AND "
cQuery += " AK2_CLASSE = '"+cClasseDe+"' AND "
cQuery += " D_E_L_E_T_ <> '*' "

cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", Tcgenqry( , , cQuery ), cAliasTmp, .F., .T. )

TcSetField( cAliasTmp, "MINRECNOAK", "N", 12, 0 )
TcSetField( cAliasTmp, "MAXRECNOAK", "N", 12, 0 )

If (cAliasTmp)->(!Eof())

                //DISTRIBUIR EM GRID
                aRecGrid := {}
                For nX := (cAliasTmp)->MINRECNOAK TO (cAliasTmp)->MAXRECNOAK STEP GRID_STEP
                               If nX + GRID_STEP > (cAliasTmp)->MAXRECNOAK
                                               aAdd(aRecGrid, {nx, (cAliasTmp)->MAXRECNOAK } )  //ultimo elemento do array
                               Else
                                               aAdd(aRecGrid, {nx, nX+GRID_STEP-1} )
                               EndIf
                Next

                nThread := Min( Len(aRecGrid), nThread ) //Configura a quantidade de threads pelo menor parametro ou len(arecgrid)

                oGrid := FWIPCWait():New("SI16"+cEmpAnt+StrZero(nRecAK1,9,0),10000)
                oGrid:SetThreads(nThread)
                oGrid:SetEnvironment(cEmpAnt,cFilAnt)
                oGrid:Start("U_SI16IMPLAN")

                lRet := SIA16RevPre(oGrid,aRecGrid,nThread,lInclui,nTipo,dPerIni,dPerFim,cCtaDe,cCtaAte,cCcDe,cCcAte,cClasseDe)

EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSIA16RevPrบAutor  ณMicrosiga           บ Data ณ  02/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao de Start das Threads								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SIA16RevPre(oGrid,aRecGrid,nThread,lInclui,nTipo,dPerIni,dPerFim,cCtaDe,cCtaAte,cCcDe,cCcAte,cClasseDe)
Local nRecIni
Local nRecFim
Local lSimu_ := .F.
Local lRevi_ := .F.
 
Local cPlanRev	:= cPlanOri//MV_PAR02
Local cNewVers	:= cRevOri//MV_PAR03
Local cFilAKE   := xFilial("AKE")
Local lExit     := .F.
Local nKilled
Local nHdl
Local cMsgComp  := ""
Local nX
Local nZ
 
For nX := 1 To Len(aRecGrid)
                nRecIni := aRecGrid[nX,1]
                nRecFim := aRecGrid[nX,2]
                lRet := oGrid:Go("Chamando escrituracao...",{nRecIni,nRecFim,lSimu_,lRevi_,cPlanRev,cNewVers,nX,lInclui,nTipo,dPerIni,dPerFim,cCtaDe,cCtaAte,cCcDe,cCcAte,cClasseDe})  
                If !lRet
                               Exit
                EndIf
 
                Sleep(5000)//Aguarda 5 seg para abertura da thread para nใo concorrer na cria็ใo das procedures.
 
Next
 
Sleep(2500*nThread)//Aguarda todas as threads abrirem para tentar fechar
    
While !lExit
                nKilled := 0
                For nZ := 1 To Len(aRecGrid)
                               nHdl := FOpen("xPCOA16_"+cFilAKE+cPlanRev+cNewVers+StrZero(nZ,10,0), 16) 
                                If nHdl >= 0
                                               cMsgComp += FReadStr(nHdl,100)+CRLF
                                               oGrid:RemoveThread(.T.)
                                               nKilled += 1
                                               FClose(nHdl)
                                               FErase("xPCOA16_"+cFilAKE+cPlanRev+cNewVers+StrZero(nZ,10,0))
                               Else
                                               nHdl := FCreate("xPCOA16_"+cFilAKE+cPlanRev+cNewVers+StrZero(nZ,10,0), 16) 
                                               If nHdl >= 0
                                                               oGrid:RemoveThread(.T.)
                                                               nKilled += 1
                                                               FClose(nHdl)
                                                               FErase("xPCOA16_"+cFilAKE+cPlanRev+cNewVers+StrZero(nZ,10,0))
                                               EndIf
                               Endif
                Next nZ
                
                If nKilled == Len(aRecGrid)
                               Exit
                EndIf
                
                Sleep(3000) //Verifica a cada 3 segundos se as threads finalizaram
                
EndDo
 
PcoAvisoTm(IIf(lRet,"Processo finalizado com sucesso", "Problema no processamento."),cMsgComp, {"Ok"},,,,,5000)
 
oGrid:RemoveThread(.T.)
 
Return lRet        


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSI16IMPLANบAutor  ณMicrosiga           บ Data ณ  02/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcaod de controle de Threads                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SI16IMPLAN(cParm,aParam)

Local nRecIni   := aParam[1]
Local nRecFim   := aParam[2]
Local lSimulac  := aParam[3]
Local lRevisa   := aParam[4]
Local cPlanRev  := aParam[5]
Local cNewVers  := aParam[6]
Local nZ        := aParam[7]
Local cFilAKE   := xFilial("AKE")
Local nHdl 
Local cStart    := ""
Local cEnd      := ""
Local lInclui := aParam[8]
Local nTipo := aParam[9]
Local dPerIni := aParam[10]
Local dPerFim := aParam[11]
Local cCtaDe := aParam[12]
Local cCtaAte := aParam[13]
Local cCcDe := aParam[14]
Local cCcAte := aParam[15]
Local cClasseDe := aParam[16]

nHdl := FCreate("xPCOA16_"+cFilAKE+cPlanRev+cNewVers+StrZero(nZ,10,0), 16) 

If nHdl >= 0
	
	cStart := DTOC(Date())+" "+Time()
	Conout( "xPCOA16 -> "+AllTrim(Str(ThreadID()))+" STARTED ["+cStart+"] " )
	fWrite(nHdl, " STARTED ["+cStart+"]")
	//PROCESSAMENTO
	lRet := Aux_Det_Lan(nRecIni,nRecFim,lSimulac,lRevisa,cPlanRev,cNewVers,lInclui,nTipo,dPerIni,dPerFim,cCtaDe,cCtaAte,cCcDe,cCcAte,cClasseDe)
	//
	cEnd := DTOC(Date())+" "+Time()
	If lRet
		Conout("xPCOA16 -> "+AllTrim(Str(ThreadID()))+" END   ["+cEnd+"]  OK")
		fWrite(nHdl," END ["+cEnd+"] - OK")
	Else
		Conout("xPCOA16 -> "+AllTrim(Str(ThreadID()))+" END   ["+cEnd+"]  FAILED")
		fWrite(nHdl," END ["+cEnd+"] - FAILED")
	EndIf
	FClose(nHdl)
	
EndIf
                
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณAux_Det_Lan บAutor  ณMicrosiga         บ Data ณ  06/14/13   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChama a PcoDetLan para escriturar movimento gerado por      บฑฑ
ฑฑบ          ณIniciar Revisao (distribuido)                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Aux_Det_Lan(nRecIni,nRecFim,lSimulac,lRevisao,cPlanRev,cNewVers,lInclui,nTipo,dPerIni,dPerFim,cCtaDe,cCtaAte,cCcDe,cCcAte,cClasseDe)
Local lRet 		:= .F.
Local cQuery 	:= " "
Local nCtdAK2 	:= 0
Local nLimLin	:= GetMV("MV_PCOLIMI")
Local nLinLote	:= 0
Local nRegs := 0
Local cQAux := ""

//SELECT AK2
cAliasTmp := GetNextAlias() //Obtem o alias para a tabela temporaria

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuery para obter recnos da tabela AK2 ou AK3 da nova versao    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cQuery += " FROM " + RetSqlName( "AK2" )
cQuery += " WHERE "
cQuery += " AK2_FILIAL ='" + xFilial( "AK2" ) + "' " 
cQuery += " AND AK2_ORCAME ='" + cPlanRev + "' "
cQuery += " AND AK2_VERSAO = '"+ cNewVers +"' "
cQuery += " AND R_E_C_N_O_ BETWEEN  "+ Str(nRecIni,12,0) + " AND "+ Str(nRecFim,12,0)
If nTipo == 1
	cQuery +=  "AND AK2_PERIOD BETWEEN '"+Dtos(FirstDay(dPerIni))+"' AND '"+Dtos(dPerFim)+"' "
Else
	cQuery +=  "AND AK2_PERIOD BETWEEN '"+Dtos(dPerIni)+"' AND '"+Dtos(dPerFim)+"' "
Endif
cQuery += " AND AK2_CO BETWEEN '"+cCtaDe+"' AND '"+cCtaAte+"' "
cQuery += " AND AK2_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"' "
cQuery += " AND AK2_CLASSE = '"+cClasseDe+"' "
cQuery += " AND D_E_L_E_T_ = ' ' " 

cQAux := " SELECT COUNT(*) AS NREG "
cQAux += cQuery

cQAux := ChangeQuery(cQAux)

dbUseArea( .T., "TOPCONN", Tcgenqry( , , cQAux ), cAliasTmp, .F., .T. )

nRegs := (cAliasTmp)->NREG

(cAliasTmp)->(dbCloseArea())

cQAux := " SELECT R_E_C_N_O_ RECNOAK "
cQAux += cQuery
cQAux += " ORDER BY R_E_C_N_O_ "

cQAux := ChangeQuery(cQAux)

dbUseArea( .T., "TOPCONN", Tcgenqry( , , cQAux ), cAliasTmp, .F., .T. )

TcSetField( cAliasTmp, "RECNOAK", "N", 12, 0 )
Conout("inicio Recnos de:"+Str(nRecIni,12,0)+" Ate: "+Str(nRecFim,12,0)+" "+time()) 
Conout(cQAux)

PcoIniLan("000252")
While (cAliasTmp)->(!Eof())
	nRecNew := (cAliasTmp)->(RECNOAK)
	AK2->(dbGoto(nRecNew))
	nCtdAK2++
	//PcoDetLan( cProcesso, cItem, cPrograma, lDeleta, cProcDel, cAKDStatus, lAtuSld )
	If lInclui
		PcoDetLan("000252","01","PCOA100",.F.,,"1",.F.)
	Else	
		PcoDetLan("000252","01","PCOA100",.T.,"00025201")
	Endif	
	nLinLote++
	(cAliasTmp)->(dbSkip())
	
	If nLimLin = nLinLote
		PcoFinLan("000252",/*lForceVis*/,/*lProc*/,/*lDelBlq*/,.F.)
		nLinLote:=0
		PcoIniLan("000252")
	Endif
	
EndDo
PcoFinLan("000252",/*lForceVis*/,/*lProc*/,/*lDelBlq*/,.F.)

(cAliasTmp)->(dbCloseArea() )

Conout("Final Recnos de: "+Str(nRecIni,12,0)+"Ate: "+Str(nRecFim,12,0)+" "+time())

//lRet := ( (nRecFim-nRecIni+1) == nCtdAK2 )
lRet := nRegs == nCtdAK2 

Return(lRet)