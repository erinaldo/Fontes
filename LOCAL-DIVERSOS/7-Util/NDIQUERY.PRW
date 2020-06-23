#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "DBTREE.CH"
//#INCLUDE "VKEY.CH"

USER FUNCTION NDIQUERY
Local 	nOpca	:= 0
Local 	cRotina	:= Space(30) 
Private	cLoginX	:= Space(40)
Private cSenhaX	:= Space(40)
Private oDlgPr

DEFINE MSDIALOG oDlgPr TITLE "Informatica - Query Analyzer" FROM 0,0 TO 245,450 PIXEL //STYLE nOR(WS_VISIBLE,WS_POPUP)

DEFINE FONT  oBold  	NAME "Arial" 	SIZE 0, -13 BOLD
DEFINE FONT  oBold2 	NAME "Arial" 	SIZE 0, -12 BOLD
DEFINE FONT  oBold3 	NAME "Arial" 	SIZE 0, -11 BOLD
DEFINE FONT  oBoldC 	NAME "CALIBRI"	SIZE 0, -15 BOLD

@ 000, 000 BITMAP oBmp RESNAME "LOGIN" OF oDlgPr SIZE 50, 126 NOBORDER WHEN .F. PIXEL
@ 006, 060 SAY "Digite seu usuแrio e senha para efetuar o login:" FONT oBoldC COLOR CLR_GRAY OF oDlgPr PIXEL

@ 023, 055 TO 080 ,220 LABEL "" OF oDlgPr  PIXEL

//@ 036, 058 SAY "Usuแrio:"	FONT oBold2 PIXEL
@ 060, 058 SAY "Senha:"		FONT oBold2 PIXEL

//@ 033,085 MSGET cLoginX  OF oDlgPr  SIZE 130,12 FONT oBold3 PIXEL
@ 055,085 MSGET oPas 	VAR cSenhaX PASSWORD OF oDlgPr  SIZE 130,12 FONT oBold3 PIXEL
@ 095, 125 BUTTON "Confirma" SIZE 040,12 PIXEL OF oDlgPr ACTION (nOpca := 1, oDlgPr:End()) 
@ 095, 173 BUTTON "Cancela"  SIZE 040,12 PIXEL OF oDlgPr ACTION (nOpca := 0,oDlgPr:End())

ACTIVATE MSDIALOG oDlgPr CENTER

If	nOpca != 1
	Return()
EndIf   
	    
///-- Somente com senha do TI. 
//If !Alltrim(cSenhaX) == 'PN' + Substr( Time(), 1, 2 ) + Substr( Time(), 4, 2 )
If !Alltrim(cSenhaX) == 'protheus'
	MsgStop("Senha Incorreta","Aten็ใo")
	RpcClearEnv()
	U_NDIQUERY()
	Return()
Endif
//If !RPCSETENV("01", "52" )// MATRIZ
/*If !RPCSETENV("01", "01" )// MATRIZ
	MsgStop("Nใo foi possํvel incializar ambiente!","Aten็ใo")
	RpcClearEnv()
	U_NDIQUERY()
	Return()
Endif
*/
OpenSm0()

//-- variaveis ambiente
Private cCadastro		:= "ERP Corporativo Totvs"
Private	acbrowse 		:= Replicate("x", 50)
Private __cInternet := Nil
Private lMsHelpAuto := .F.

oApp:cModname	:= "NDI - Query Analyzer"
oApp:lMenu 		:= .F.
oApp:cInternet 	:= ""
oApp:cModDesc	:= "NDI - Query Analyzer"
oApp:nModulo 	:= 0
oApp:bMainInit 	:= {|| BeginFlatMode(), u_TIQUERY(), EndFlatMode()}
oApp:RunApp()
RETURN(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNDIQUERY  บAutor  ณLeonardo S. Alvarez บ Data ณ  02/18/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao de arquivo temporario, atraves de filtro pela      บฑฑ
ฑฑบ          ณ query, possibilidade de geracao do arquivo em Excel.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION TIQUERY()
// Variaveis Locais da Funcao
Local oSBtn1
Local aSize    	:= MsAdvSize()
Local nGet1		:= 40
Local aObjects	:= {}
Local aInfo		:= {}
Local aPosObj	:= {}
Local cServer	:= AllTrim(GetSrvProfString("TopServer", ""))
Local cBase		:= AllTrim(GetSrvProfString("TopDataBase", "") + "/" + GetSrvProfString("TopAlias", ""))
Local cPorta	:= AllTrim(GetSrvProfString("TopPort", "7890"))
Local cAdvTop	:= cBase + "@" + cServer + ":" + cPorta
Local cSenhaP	:= ""
Local aConnect	:= {}

// Variaveis Private da Funcao
Private oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL 		:= .F.                        
Private INCLUI 		:= .F.                        
Private ALTERA 		:= .F.                        
Private DELETA 		:= .F.                        
Private cMemo2		:= ""
Private aBtnQRY 	:= Array(7)
Private	lGeraExcel	:= .F.
Private cVQuery		:= ""
Private cTopSrv		:= cAdvTop
Private aTopConns	:= {cAdvTop}
Private aActConns	:= {{cAdvTop,AdvConnection()}}
Private oTopSrv
Private oMemo1	
Private cMemo1		:= ""
Private oGet1
Private nValBuffer	:=  0
Private cPathPlan	:= ""
Private	ALIAS		:= ""
Private oChkChange  
Private lChkChange 	:= .T.
Private oChkRefresh 
Private lChkRefresh	:= .T.
Private cGet2		:= ""

AADD(aObjects, {100,50, .T., .T., .F. } )
AADD(aObjects, {100,50, .T., .T., .F. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects, .T., .F. )

DEFINE MSDIALOG oDlg TITLE "N๚cleo de Desenvolvimento Interno - Query Analyzer" FROM aSize[7], 0 TO aSize[6], aSize[5] OF oMainWnd PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP) //STYLE WS_CAPTION                              

// Cria as Groups do Sistema
@ aPosObj[1,1] + 10, aPosObj[1,2] TO aPosObj[1,3] - 20/*aPosObj[1,3] - 50*/, aPosObj[1,4] LABEL "Sintaxe SQL" PIXEL OF oDlg
@ aPosObj[1,1] + 2, aPosObj[1,4]  - 350 Say "TopServer: " Size C(090), C(008) COLOR CLR_BLUE PIXEL OF oDlg
@ aPosObj[1,1], aPosObj[1,4]  - 320 ComboBox oTopSrv Var cTopSrv Items aTopConns Size C(110),C(009) COLOR CLR_BLACK  PIXEL OF oDlg
@ aPosObj[1,1] + 2, aPosObj[1,4]  - 075 Say "Buffer de Leitura: " Size C(090), C(008) COLOR CLR_BLUE PIXEL OF oDlg
@ aPosObj[1,1], aPosObj[1,4]  - 29 MsGet oGet1 Var nGet1 Size C(025), C(009) COLOR CLR_BLACK PIXEL OF oDlg Picture "999" Valid (nGet1 > 0 .And. nGet1 <= 400)
@ aPosObj[1,1] + 2, aPosObj[1,4]  - 170 Say "Tempo Processamento: " Size C(090), C(008) COLOR CLR_BLUE PIXEL OF oDlg	                                      
@ aPosObj[1,1], aPosObj[1,4]  - 112 MsGet oGet2 Var cGet2 Size C(025), C(009) COLOR CLR_BLACK PIXEL OF oDlg Picture "99:99:99" WHEN .F.
@ aPosObj[1,1] + 1, aPosObj[1,2] CheckBox oChkChange Var lChkChange Prompt "ChangeQuery" Size C(048),C(008) COLOR CLR_BLUE PIXEL OF oDlg
@ aPosObj[1,1] + 1, aPosObj[1,2] + 070 CheckBox oChkRefresh Var lChkRefresh Prompt "Refresh" Size C(048),C(008) COLOR CLR_BLUE PIXEL OF oDlg


oTopSrv:BChange	:= {||TROCACONN(aActConns)}	
oMemo1			:= TMultiget():New(aPosObj[1,1] + 18, aPosObj[1,2] + 2, bSetGet(cMemo1),oDlg, aPosObj[1,4] - 8, aPosObj[1,3] - 055/*aPosObj[1,3] - 87*/,,,,,,.T.)
oMemo1:BKeyDown	:= SetKey(VK_F5, {||EXECQRY(cMemo1, nGet1)})
oMemo1:BChange	:= {||oMemo1:Refresh()}
oMemo1:Refresh()

DEFINE BUTTONBAR oBar SIZE C(20), C(20) 3D TOP OF oDlg
DEFINE BUTTON aBtnQRY[1] RESOURCE "NEXT" 		OF oBar TOOLTIP "Start <F5>"	ACTION EXECQRY(cMemo1, nGet1)
DEFINE BUTTON aBtnQRY[2] RESOURCE "PMSEXCEL"	OF oBar TOOLTIP "Excel" 		ACTION MsgRun("Gerando Excel ..."	, "Aguarde", {||GERAEXCEL()})	
DEFINE BUTTON aBtnQRY[3] RESOURCE "SALVAR" 		OF oBar TOOLTIP "Salvar" 		ACTION MsgRun("Salvando Query ...", "Aguarde", {||QRYSALVAR(cMemo1)})				
DEFINE BUTTON aBtnQRY[4] RESOURCE "OPEN"		OF oBar TOOLTIP "Abrir"  		ACTION MsgRun("Abrindo Query ..."	, "Aguarde", {||cMemo1 := QRYABRIR(cMemo1)})
DEFINE BUTTON aBtnQRY[5] RESOURCE "CADEADO"		OF oBar TOOLTIP "Conectar..."	ACTION QRYTCONN(@aConnect)
DEFINE BUTTON aBtnQRY[6] RESOURCE "PRODUTO"		OF oBar TOOLTIP "Estrutura..."	ACTION MsgRun("Carregando tabelas ..."	, "Aguarde", {|| ESTRUTAB()})
DEFINE BUTTON aBtnQRY[7] RESOURCE "FINAL"		OF oBar TOOLTIP "Sair" 			ACTION QRYEXIT(oDlg, aConnect)
ACTIVATE MSDIALOG oDlg CENTERED
RETURN(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEXECQRY   บAutor  ณLeonardo S. Alvarez บ Data ณ  02/18/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao e execucao da query e geracao do arquivo         บฑฑ
ฑฑบ          ณ temporario.                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NDIQUERY                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION EXECQRY(cTEXTO, nTOTLINHA)
Local cQuery		:= ""
Local nRet			:= 0
Local oMemo2
Local aStru			:= {}
Local nI			:= 0
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local aSize			:= MsAdvSize()
Local cHoraInicio	:= TIME()
Local cElapsed 
Local lAltera		:= GetMV('TDI_LIBPNG',, .F. )

cPathPlan	:= ""
cQuery		:= cTEXTO                

ALIAS := GetNextAlias()

If (Upper(AllTrim(cQuery)) == Upper(AllTrim(cVQuery))) .And. (nValBuffer == nTOTLINHA) .And. !lChkRefresh
	Return .F.
EndIf
	
cVQuery			:= cQuery
nValBuffer	:= nTOTLINHA
/*
If!( lAltera )
	If AT("INSERT", Upper(AllTrim(cQuery))) != 0 .Or. AT("UPDATE", Upper(AllTrim(cQuery))) != 0 .Or.; 
		 AT("DELETE", Upper(AllTrim(cQuery))) != 0
		Aviso("Erro", "Sintaxe Errada, nใo ้ permitido manipular a base de dados", {"OK"})
		Return .F.
	EndIf         
EndIf
*/                  

If AT("INSERT", Upper(AllTrim(cQuery))) != 0 .Or. AT("UPDATE", Upper(AllTrim(cQuery))) != 0 .Or.; 
	 AT("DELETE", Upper(AllTrim(cQuery))) != 0 .Or. AT("CREATE", Upper(AllTrim(cQuery))) != 0 .Or. AT("VIEW", Upper(AllTrim(cQuery))) != 0 .Or.;
	 AT("TRUNCATE", Upper(AllTrim(cQuery))) != 0 .Or. AT("ALTER", Upper(AllTrim(cQuery))) != 0
//	Aviso("Erro", "Sintaxe Errada, nใo ้ permitido manipular a base de dados", {"OK"})
//	Return .F.
	lAtualiza := .T.

EndIf

MsgRun("Verificando Query ...", "Aguarde", {||nRet := TcSqlExec(cQuery)})	
AADD(aObjects, {100,50, .T., .T., .F. } )
AADD(aObjects, {100,50, .T., .T., .F. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3}
aPosObj := MsObjSize( aInfo, aObjects, .T., .F.)

If nRet <> 0
	If ValType(oMemo2) <> "O"		
		@ aPosObj[2,1] - 20, aPosObj[2,2] GET oMemo2 Var cMemo2 MEMO Size aPosObj[2,4] - 3, aPosObj[1,3] + 05 PIXEL READONLY OF oDlg	
	Else
		oMemo2:LControlVisible	:= .T.	
	EndIf
	cMemo2	:= TcSqlError()
	oMemo2:SetFocus()                              
	nRet				:= 0
	lGeraExcel	:= .F.
Else		
	If (Select(ALIAS) > 0)
		(ALIAS)->(DbCloseArea())	
		FErase(ALIAS + GetDBExtension())
		FErase(ALIAS + OrdBagExt())
	EndIf
	
	If lChkChange
		cQuery := ChangeQuery(cQuery)
	EndIf
	
	DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery ), ALIAS, .T., .T.)  	
	DbSelectArea(ALIAS)	
	aStru := DbStruct()	
	
	For	nI	:= 1 To Len(aStru)
		If aStru[nI][2] == "D"
			TcSetField(ALIAS, aStru[nI][1], "D", 8, 0)
		ElseIf aStru[nI][2] ==  "N" .And. aStru[nI][4] > 2
			TcSetField(ALIAS, aStru[nI][1], "N", aStru[nI][3], 2)	  
	  EndIf
		
//		If Len(aStru[nI][1]) > 10 	.And. Upper(AllTrim(aStru[nI][1])) <> "R_E_C_D_E_L_"
//			Aviso("Erro", "Sintaxe Errada, os campos nใo podem ter o nome com tamanho maior que 10", {"OK"})
//			Return .F.			
//		EndIf
		  
	  If Val(aStru[nI][1]) == 1
			Aviso("Erro", "Sintaxe Errada, nomear campo(s)", {"OK"})
			Return .F.							
		EndIf
	Next		
	
	DbSelectArea(ALIAS)
	DbGoTop()
 
	If ValType(oMemo2) == "O"
		oMemo2:LVisibleControl	:= .F.	
	EndIf
	cHoraInicio	:= TIME()
	MsgRun("Gerando Visualiza็ใo ...", "Aguarde", {||lGeraExcel := GETCUSTOMI(nTOTLINHA, ALIAS)})	
	oGet1:SetFocus()
EndIf
cElapsed  := ELAPTIME(cHoraInicio, TIME())
cGet2			:= AllTrim(cElapsed)
RETURN(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPATHARQ   บAutor  ณLeonardo S. Alvarez บ Data ณ  02/18/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que disponibiliza ao usuario a opcao de escolher    บฑฑ
ฑฑบ          ณ o caminho (path) para ser salvo o arquivo em excel         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NDIQUERY                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION PATHARQ(nTipo)
Local cFileOpen := ""
Local cTitAnex 	:= ""
Local cExtAnex  := ""

If nTipo == 1
	cExtAnex	:= "Arquivos em Excel| *.xls"
	cTitAnex := "Salvar Arquivo"
	/*|========================================================================================|
  	|cGetFile(<ExpC1>,<ExpC2>,<ExpN1>,<ExpC3>,<ExpL1>,<ExpN2>)                               |
  	|ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ                               |
  	|<ExpC1> - Expressao de filtro                                                           |
  	|<ExpC2> - Titulo da janela                                                              |
  	|<ExpN1> - Numero de mascara default 1 para *.Exe                                        |
  	|<ExpC3> - Diret๓rio inicial se necessแrio                                               |
  	|<ExpL1> - .F. botใo salvar - .T. botใo abrir                                            |
  	|<ExpN2> - Mascara de bits para escolher as op็๕es de visualiza็ใo do objeto (prconst.ch)|
  	|========================================================================================|*/
	cFileOpen := cGetFile(cExtAnex, cTitAnex, , ,.F.)
ElseIf nTipo == 2
		cExtAnex	:= "Arquivos Query| *.nqy"
		cTitAnex := "Salvar Arquivo"
	/*|========================================================================================|
  	|cGetFile(<ExpC1>,<ExpC2>,<ExpN1>,<ExpC3>,<ExpL1>,<ExpN2>)                               |
  	|ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ                               |
  	|<ExpC1> - Expressao de filtro                                                           |
  	|<ExpC2> - Titulo da janela                                                              |
  	|<ExpN1> - Numero de mascara default 1 para *.Exe                                        |
  	|<ExpC3> - Diret๓rio inicial se necessแrio                                               |
  	|<ExpL1> - .F. botใo salvar - .T. botใo abrir                                            |
  	|<ExpN2> - Mascara de bits para escolher as op็๕es de visualiza็ใo do objeto (prconst.ch)|
  	|========================================================================================|*/
	cFileOpen := cGetFile(cExtAnex, cTitAnex, , ,.F.)
ElseIf nTipo == 3
		cExtAnex	:= "Arquivo Query| *.nqy"
		cTitAnex := "Selecionar Arquivo"
	/*|========================================================================================|
  	|cGetFile(<ExpC1>,<ExpC2>,<ExpN1>,<ExpC3>,<ExpL1>,<ExpN2>)                               |
  	|ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ                               |
  	|<ExpC1> - Expressao de filtro                                                           |
  	|<ExpC2> - Titulo da janela                                                              |
  	|<ExpN1> - Numero de mascara default 1 para *.Exe                                        |
  	|<ExpC3> - Diret๓rio inicial se necessแrio                                               |
  	|<ExpL1> - .F. botใo salvar - .T. botใo abrir                                            |
  	|<ExpN2> - Mascara de bits para escolher as op็๕es de visualiza็ใo do objeto (prconst.ch)|
  	|========================================================================================|*/
	cFileOpen := cGetFile(cExtAnex, cTitAnex, , ,.T.)	
ElseIf nTipo == 4
		cExtAnex	:= "Arquivos em Excel| *.xls"
		cTitAnex 	:= "Selecionar Arquivo"
	/*|========================================================================================|
  	|cGetFile(<ExpC1>,<ExpC2>,<ExpN1>,<ExpC3>,<ExpL1>,<ExpN2>)                               |
  	|ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ                               |
  	|<ExpC1> - Expressao de filtro                                                           |
  	|<ExpC2> - Titulo da janela                                                              |
  	|<ExpN1> - Numero de mascara default 1 para *.Exe                                        |
  	|<ExpC3> - Diret๓rio inicial se necessแrio                                               |
  	|<ExpL1> - .F. botใo salvar - .T. botใo abrir                                            |
  	|<ExpN2> - Mascara de bits para escolher as op็๕es de visualiza็ใo do objeto (prconst.ch)|
  	|========================================================================================|*/
	cFileOpen := cGetFile(cExtAnex, cTitAnex, , ,.T.)
EndIf
RETURN(cFileOpen)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGETCUSTOMIบAutor  ณLeonardo S. ALvarez บ Data ณ  02/18/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclui as informacoes geradas pela query na GetDados       บฑฑ
ฑฑบ          ณ para ser mostrado na tela                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NDIQUERY                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION GETCUSTOMI(nTOTCOL, ALIAS)
Local aSize		:= MSAdvSize()
Local aObjects	:= {}
Local aInfo		:= {}
Local aPosObj	:= {}
Local nX		:= 0                                                                                                              
Local aCpoGDa	:= {""}                                                                                                 
Local aAlter	:= {""}
Local nSuperior	:= C(120)
Local nEsquerda	:= C(001)
Local nInferior	:= C(275)
Local nDireita	:= C(445)
Local nOpc		:= 0
Local cLinOk	:= ""
Local cTudoOk	:= "AllwaysTrue"
Local cIniCpos	:= ""
Local nFreeze	:= 000
Local nMax		:= 000
Local cFieldOk	:= "AllwaysTrue"
Local cSuperDel	:= ""
Local cDelOk	:= "AllwaysTrue"
Local oWnd		:= oDlg                                                                                                  
Local aHead		:= {}
Local aCol		:= {}			
Local aStru		:= {}

Local aAux		:= {}
Local nPos		:= 0
Local nPonto	:= 0


AADD(aObjects, {100,50, .T., .T., .F. } )
AADD(aObjects, {100,50, .T., .T., .F. } )
aInfo	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj	:= MsObjSize( aInfo, aObjects, .T., .F. )

nSuperior	:= aPosObj[2,1] - 20
nEsquerda	:= aPosObj[2,2] 
nInferior	:= aPosObj[2,3] 
nDireita	:= aPosObj[2,4]

DbSelectArea(ALIAS)
aStru	:= DbStruct()
                                                                                                                                
aCpoGDa	:= aClone(aStru)

DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2))
For nX := 1 To Len(aCpoGDa)                                                                                                     
		AADD(aHead,{AllTrim(aCpoGDa[nX][1]),;                                                                                         
			AllTrim(aCpoGDa[nX][1]),;                                                                                                       			
			"",;
			aCpoGDa[nX][3],;                                                                                                       
			aCpoGDa[nX][4]})                                                                                                        	
Next nX                                                                                                                         

aAux := {}                          

DbSelectArea(ALIAS)
(ALIAS)->(DbGoTop())
While !(ALIAS)->(Eof())
  For nX := 1 To Len(aHead)
  	AADD(aAux, &(aHead[nX][2]))
	Next	
		AADD(aAux, .F.)
		If Len(aCol) < nTOTCOL                                      
			AADD(aCol, aAux)		
		Else
			Exit
		EndIf
		aAux	:= {}                                                        
	(ALIAS)->(DbSkip())
EndDo
                                  
oGetDados1:= MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinOk,cTudoOk,cIniCpos,;                               
                             aAlter,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oWnd,aHead,aCol)
RETURN (IIf(Len(aCol) > 0, .T., .F.))                                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERAEXCEL บAutor  ณLeonardo S. Alvarez บ Data ณ  02/18/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que efetua a geracao do arquivo em Excel no caminho บฑฑ
ฑฑบ          ณ informado pelo usuario                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NDIQUERY                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION GERAEXCEL()
Local cArq	:= ""
Local cAlias:= ""

cAlias	:= GetNextAlias() 

If lGeraExcel 
	cArq	:= PATHARQ(1)
	If Empty(cArq)
			Return .F.			
	EndIf
	
	DbSelectArea(ALIAS)                          
	DbGoTop()		
	
	COPY TO (cAlias) + ".DBF" VIA "DBFCDXADS"
	
	If __CopyFile(cAlias + ".DBF", cArq + ".xls")
		ShellExecute("Open", cArq + ".xls","","",1)
		cPathPlan	:= cArq + ".xls"
	Else		
		Aviso("Erro", "Nใo foi possํvel gerar o arquivo Excel", {"OK"})	
		cPathPlan	:= ""
	EndIf
Else
	Aviso("Erro", "Nใo existe registros a serem gerados", {"OK"})
EndIf

FErase(cAlias + ".DBF")
RETURN(.T.)              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQRYEXIT   บAutor  ณMicrosiga           บ Data ณ  02/20/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que efetua a saida da rotina e deleta o arquivo     บฑฑ
ฑฑบ          ณ temporario                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NDIQUERY                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION QRYEXIT(oForm, aConexao)
Local nI := 0
If !Empty(ALIAS)
	If (Select(ALIAS) > 0)
		(ALIAS)->(DbCloseArea())	
		FErase(ALIAS + GetDBExtension())
		FErase(ALIAS + OrdBagExt())
	EndIf
EndIf
If Len(aConexao) > 0
	For nI := 1 To Len(aConexao)
		TcUnLink(aConexao[nI])
	Next nI
EndIf

oForm:End()
RETURN Nil  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQRYSALVAR บAutor  ณLeonardo S. Alvarez บ Data ณ  02/21/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Salva query no caminho especificado pelo usuแrio           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NDIQUERY                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION QRYSALVAR(cTEXTO)
Local cArq		:= ""
Local nHandle	:= 0

If !lGeraExcel 
	If !MsgYesNo("Nใo foi gerado nenhum registro !" + Chr(13) + Chr(10) + "Deseja Salvar o Arquivo mesmo assim ?")
		Return .F.	
	EndIf
EndIf

cArq := PATHARQ(2)

If Empty(cArq)
	Aviso("Erro", "Nใo ้ possํvel gravar, poํs nใo foi selecionado o caminho", {"OK"})
	Return .F.
Else
	If (nHandle := FCreate(cArq + ".NQY", 1)) == -1  
			MsgStop("Nao foi possํvel criar arquivo " + cArq, FError())	
	Else
		FWrite(nHandle,	AllTrim(cTEXTO))  
		FClose(nHandle)
		MsgAlert("Arquivo Gravado com sucesso !")
	EndIf
EndIf
RETURN(.T.)         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQRYABRIR  บAutor  ณLeonardo S.Alvarez  บ Data ณ  02/21/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua a abertura da query salva                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NDIQUERY                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION QRYABRIR(cTEXTO)
Local cArq		:= ""                                        	
Local cLinha	:= ""

cArq	:= PATHARQ(3)

If Empty(cArq)
	Return cTEXTO
EndIf
	
FT_FUse(cArq)
FT_FGoTop()
While !FT_FEof()       
	cLinha	+= AllTrim(FT_FReadLn())
	cLinha	+= Chr(13) + Chr(10)
	FT_FSkip()
EndDo
If Empty(cLinha)
	cLinha	:= cTEXTO
EndIf
oGet1:SetFocus()
RETURN(cLinha)      

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()   ณ Autores ณ Norbert/Ernani/Mansano ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
STATIC FUNCTION C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                                               
	//ณTratamento para tema "Flat"ณ                                               
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                               
If "MP8" $ oApp:cVersion .Or. "P10" $ oApp:cVersion
	If (Alltrim(GetTheme()) $ "FLAT.TEMAP10") .Or. (Alltrim(GetTheme()) $ "CLASSIC") .Or. (Empty(GetTheme())) .Or. SetMdiChild() .Or. Empty(GetTheme())  //Tratamento para tema "Flat"
		nTam *= 0.91
	EndIf
EndIf
RETURN Int(nTam)        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQRYTCONN  บAutor  ณLeonardo S. Alvarez บ Data ณ  03/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEfetua conexao no Banco de Dados informado pelo usuario     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NDQUERY                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION QRYTCONN(aConexao)
// Variaveis Locais da Funcao
Local cServer	:= Space(40)
Local cBase		:= Space(40)
Local cPorta	:= Space(40)
Local cStrBase	:= ""
Local cStrSrv	:= ""
Local cStrPort	:= ""
Local cStrLnk	:= ""
Local nOpc		:= 0
Local nConexao	:= -1
Local oServer
Local oBase
Local oPorta

// Variaveis Private da Funcao
Private oDlgConn				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL	:= .F.                        
Private INCLUI	:= .F.                        
Private ALTERA	:= .F.                        
Private DELETA	:= .F.

cServer	:= PadR(GetSrvProfString("TopServer", ""),40)
cBase	:= PadR(GetSrvProfString("TopDataBase", "") + "/" + GetSrvProfString("TopAlias", ""),40)
cPorta	:= PadR(GetSrvProfString("TopPort", "7890"),40)

DEFINE MSDIALOG oDlgConn TITLE "Conectar no Top Connect ..." FROM C(178),C(181) TO C(369),C(439) PIXEL

	// Cria as Groups do Sistema
	@ C(003),C(006) TO C(080),C(130) LABEL "" PIXEL OF oDlgConn

	// Cria Componentes Padroes do Sistema
	@ C(010),C(007) Say "Servidor" Size C(022),C(008) COLOR CLR_BLACK  PIXEL OF oDlgConn
	@ C(018),C(007) MsGet oServer Var cServer Size C(117),C(009) COLOR CLR_BLACK PIXEL OF oDlgConn
	@ C(033),C(007) Say "DBMS / Base de Dados" Size C(058),C(008) COLOR CLR_BLACK PIXEL OF oDlgConn
	@ C(041),C(008) MsGet oBase Var cBase Size C(116),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgConn
	@ C(055),C(008) Say "Porta" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlgConn
	@ C(064),C(008) MsGet oPorta Var cPorta Size C(037),C(009) COLOR CLR_BLACK Picture "9999" PIXEL OF oDlgConn
	@ C(083),C(025) Button "Conectar" Size C(037),C(012) PIXEL OF oDlgConn ACTION (nOpc:=1, oDlgConn:End())
	@ C(083),C(074) Button "Cancelar" Size C(037),C(012) PIXEL OF oDlgConn ACTION (nOpc:= 0, oDlgConn:End())
	
		// Cria ExecBlocks dos Componentes Padroes do Sistema

ACTIVATE MSDIALOG oDlgConn CENTERED

If nOpc = 1

	cStrBase:= AllTrim(cBase)
	cStrSrv	:= AllTrim(cServer)
	cStrPort:= AllTrim(cPorta)
	cStrLnk	:= cStrBase + "@" + cStrSrv + ":" + cStrPort
    
	MsgRun("Conectando a: " + cStrSrv + ":" + cStrPort + ". Base: " + cStrBase, "Aguarde...", {||nConexao := TcLink(cStrBase,cStrSrv)})
	
	If 	nConexao < 0
		cMensagem := "Nao foi possํvel estabelecer conexao com o TopConnect Server, retorno: " + AllTrim(Str(nConexao))
		MsgStop(cMensagem)
		Return(.F.)
	EndIf
	
	AADD(aConexao, nConexao)
	
	TcSetConn(nConexao)
	nPosCon	:= AScan(oTopSrv:aItems, {|x| x == cStrLnk})
	
	If nPosCon == 0
		AADD(aActConns, {cStrLnk,nConexao})	
		AADD(oTopSrv:aItems, cStrLnk)	
	EndIf
	
	oTopSrv:SetItems(oTopSrv:aItems)
	oTopSrv:Refresh()
	nPosCon 		:= AScan(oTopSrv:aItems, {|x| x == cStrLnk})
	oTopSrv:nAt	:= nPosCon
	oTopSrv:Refresh()
EndIf
RETURN(.T.)   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณESTRUTAB  บAutor  ณLeonardo S. Alvarez บ Data ณ  03/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra as estruturas das tabelas referente a conexใo que   บฑฑ
ฑฑบ          ณ esta aberta                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NDIQUERY                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION ESTRUTAB()
Local cGet1	:= Space(25)
Local oGet1

Private oDlgT
Private aListBox1	:= {}
Private oListBox1

DEFINE MSDIALOG oDlgT TITLE "Tabelas" FROM C(184),C(179) TO C(437),C(550) PIXEL

	// Cria Componentes Padroes do Sistema
	@ C(113),C(107) Button "Ok" Size C(037),C(012) PIXEL OF oDlgT Action MsgRun("Lendo Estrutura..."	, "Aguarde", {||SX3TABLE(AllTrim(aListBox1[oListBox1:nAt,02]))})	
	@ C(113),C(147) Button "Cancelar" Size C(037),C(012) PIXEL OF oDlgT Action(oDlgT:End())
	@ C(114),C(003) Say "Procurar" Size C(024),C(008) COLOR CLR_BLACK PIXEL OF oDlgT
	@ C(114),C(031) MsGet oGet1 Var cGet1 Size C(069),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlgT
  
  SX2->(DbGoTop())
	SX2->(DbSetOrder(1)	)
	While !SX2->(Eof())
		AADD(aListBox1,{AllTrim(SX2->X2_ARQUIVO), AllTrim(SX2->X2_CHAVE), ""})
		SX2->(DbSkip())
	EndDo
	
	@ C(001),C(001) ListBox oListBox1 Fields ;
		HEADER "TABELA", "CHAVE";
		Size C(184),C(108) Of oDlgT Pixel;
		ColSizes 50,50
		oListBox1:SetArray(aListBox1)		
		oListBox1:bLine 		:= {|| {;
		aListBox1[oListBox1:nAt,01],;
		aListBox1[oListBox1:nAt,02],;
		aListBox1[oListBox1:nAt,03]}}
	  oGet1:bChange	:= {|| SEEKTABLE(aListBox1, @oListBox1, AllTrim(cGet1)), oListBox1:Refresh()}
ACTIVATE MSDIALOG oDlgT CENTERED 
RETURN(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCheckSenhaบAutor  ณMicrosiga           บ Data ณ07/01/03     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida se o SenhaP esta ou nao habilitado para utilizar o   บฑฑ
ฑฑบ          ณDiario Tecnico                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Microsiga - Chamada Remote com Programa Inicial Diario     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION CHECKSENHAP(cLoginX,cPwd)
Local cSenhapNumber	:= ""
Local lRet			:= .T.

If !(GetSrvProfString("JUMPSENHAP", "0") = "1")
	cSenhapNumber := GetSenhaP(PadR(cLoginX,20), PadR(cPwd,8), "MSG005")
	If cSenhapNumber == '00000000'
		lRet	:= .F.
	EndIf
Else
	MsgStop("Rotina de Seguranca SenhaP Desabilitada")
	lRet := .T.
EndIf

If lRet
	U_NDIQUERY()
EndIf
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTROCACONN บAutor  ณLeonardo S Alvarez  บ Data ณ  08/25/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seta a conexao selecionada pelo usuario atraves do         บฑฑ
ฑฑบ          ณ combo.                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NDIQUERY                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION TROCACONN(aConexoes)
TcSetConn(aConexoes[oTopSrv:nAt][2])
RETURN(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNDIQUERY  บAutor  ณMicrosiga           บ Data ณ  08/25/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION SEEKTABLE(aList, oList, cBusca)
Local nPos	:= 0                             

If AScan(aList, {|x| x[2] == AllTrim(cBusca)}) > 0
	oList:nAt	:= AScan(aList, {|x| x[2] == AllTrim(cBusca)})
ElseIf AScan(aList, {|x| x[1] == AllTrim(cBusca)}) > 0
	oList:nAt	:= AScan(aList, {|x| x[1] == AllTrim(cBusca)})
ElseIf AScan(aList, {|x| Left(x[1],4) == AllTrim(cBusca)}) > 0
	oList:nAt	:= AScan(aList, {|x| Left(x[1],4) == AllTrim(cBusca)})
ElseIf AScan(aList, {|x| Left(x[1],5) == AllTrim(cBusca)}) > 0
	oList:nAt	:= AScan(aList, {|x| Left(x[1],5) == AllTrim(cBusca)})
Else
	MsgAlert("Tabela nใo Encontrada: " + AllTrim(cBusca))	
EndIf
RETURN(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNDIQUERY  บAutor  ณMicrosiga           บ Data ณ  08/25/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION SX3TABLE(cTabela)
Local aListSX3 := {}
Local oListSX3
Local oOk 	   := LoadBitmap( GetResources(), "LBOK")
Local oNo 	   := LoadBitmap( GetResources(), "LBNO")
Private oDlgSX3				// Dialog Principal
Private oMenu


DEFINE MSDIALOG oDlgSX3 TITLE "Estrutura da tabela [" + AllTrim(cTabela) + "]" FROM C(184),C(179) TO C(538),C(648) PIXEL

	// Cria Componentes Padroes do Sistema
	@ C(163),C(099) Button "Ok" Size C(037),C(012) PIXEL OF oDlgSX3 Action(INCAMPOS(aListSX3),oDlgSX3:End())
	SX3->(DbSetOrder(1))
	If SX3->(DbSeek(cTabela))
		While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cTabela
			AADD(aListSX3,{.F., AllTrim(SX3->X3_CAMPO), AllTrim(SX3->X3_TIPO), SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL, AllTrim(SX3->X3_TITULO),""})
			SX3->(DbSkip())
		EndDo
	EndIf
	
	@ C(001),C(001) ListBox oListSX3 Fields ;
		HEADER "","Nome do Campo","Tipo","Tamanho","Decimal","Tํtulo";
		Size C(235),C(159) Of oDlgSX3 Pixel;
		ColSizes 50,50;
		On DBLCLICK(aListSX3[oListSX3:nAt,01] := !(aListSX3[oListSX3:nAt,1]), oListSX3:Refresh())
		
		aListSX3 := ASort(aListSX3,,, {|x,y| x[1]  < y[1]})		
		oListSX3:SetArray(aListSX3)    
		oListSX3:bLine	:= {|| {If(	aListSX3[oListSX3:nAT,01],oOk,oNo),;
									aListSX3[oListSX3:nAt,02],;
									aListSX3[oListSX3:nAt,03],;
									aListSX3[oListSX3:nAt,04],;
									aListSX3[oListSX3:nAt,05],;
									aListSX3[oListSX3:nAt,06],;
									aListSX3[oListSX3:nAt,07]}}
ACTIVATE MSDIALOG oDlgSX3 CENTERED 
RETURN(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINCAMPOS  บAutor  ณ Leonardo S Alvarez บ Data ณ  12/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

STATIC FUNCTION INCAMPOS(aCAMPOS)
Local nI		:= 0
Local cCampos	:= ""
For nI	:= 1 To Len(aCAMPOS)
	If aCAMPOS[nI,1]
		cCampos	+= AllTrim(aCAMPOS[nI,2]) + ","
	EndIf
Next
cMemo1 += SubStr(cCampos,1,Len(cCampos)-1)
oMemo1:Refresh()
RETURN(.T.)