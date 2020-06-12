#Include 'Protheus.ch'

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CATFA02
Solicitação de baixa e transferência
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CATFA02()      
LOCAL cAlias		:= "ZAB" 
LOCAL aCores 		:= {{"ZAB_STATUS == '1'",	'BR_VERDE' 	},;	// Pendente
						{ "ZAB_STATUS == '2'",	'BR_VERMELHO'}}	// Finalizado
Private cCadastro 	:= "Solicitação de baixa e transferência" 
Private aRotina 	:= {	{"Pesquisar" 		,"AxPesqui"    	,0,1},;
							{"Visualizar" 	,"U_C1A02MAT"    	,0,2},; 
							{"Conhecimento" 	,"MsDocument"  	,0,3},;
							{"Aprovar"   		,"U_C1A02MAT" 	,0,4},;							
							{"Excluir"   		,"U_C1A02MAT" 	,0,5},; 
							{"Rejeitar"   	,"U_C1A02MAT" 	,0,6},;
							{"Legenda"   		,"U_C1A02LEG"	  	,0,7}}															
														

dbSelectArea(cAlias)
dbSetOrder(1)							
mBrowse(6,1,22,75,cAlias,,,,,,aCores)							

RETURN  
/*------------------------------------------------------------------------
*
* C1A02MAT()
* Rotina de manutenção 
*
------------------------------------------------------------------------*/
USER FUNCTION C1A02MAT(cAlias,nReg,nOpc) 
LOCAL oDlg			:= NIL
LOCAL aSize		:= MsAdvSize(.T.)
LOCAL aPosObj 	:= MsObjSize({aSize[1],aSize[2],aSize[3],aSize[4],3,3},{{ 0, 0, .T., .T. },{ 0, 0, .T., .T. }})            
LOCAL nOpcA		:= 0 
LOCAL cQuery    	:= ""
LOCAL aHeader 	:= {}
LOCAL aCols		:= {} 
LOCAL nModo		:= IIF(nOpc == 4 .OR. nOpc == 6,GD_INSERT+GD_DELETE+GD_UPDATE,0)
LOCAL aAlterGD1	:= {}
local nContSC		:= 0
local nContOK		:= 0
local cCodForm	:= ""	
Private oGetD		:= NIL   

if nOpc == 4 .or. nOpc == 6
	IF ZAB->ZAB_STATUS == "2"
		MSGINFO("Formulário de solicitação já finalizado.")
		Return	
	ENDIF		 
endif
 
RegToMemory("ZAB",.F.)	
cQuery:= " SELECT * FROM "+RETSQLNAME("SNM")
cQuery+= " WHERE NM_FILIAL='"+XFILIAL("SNM")+"'"	
cQuery+= "	AND NM_XCODFOR='"+ZAB->ZAB_COD+"'"			
cQuery+= "	AND D_E_L_E_T_=''"
cQuery+= " ORDER BY "+SqlOrder(SNM->(IndexKey()))
		
FillGetDados(nOpc,"SNM",1,/*cSeek*/,/*{|| &cWhile }*/,{|| .T. },/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,cQuery,/*bMontCols*/,/*lEmpty*/,aHeader,aCols)


DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL 
	EnchoiceBar(oDlg,{|| Iif(U_C1A02TOK(nOpc),(nOpcA := 1, oDlg:End()),NIL)},{|| oDlg:End()},,)                                                     
	oEnCh:= MsMGet():New(cAlias,nReg,nOpc,,,,,aPosObj[1],,,,,,oDlg)
	oGetD:=	MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nModo,;
	"AllwaysTrue()","AllwaysTrue()","",aAlterGD1,,999,"AllwaysTrue()",,"AllwaysTrue()",oDlg,aHeader,aCols)      	
ACTIVATE MSDIALOG oDlg CENTERED 
 
IF nOpcA > 0  
	C1A02PRO(nOpc)		
ENDIF

RETURN   
/*------------------------------------------------------------------------
*
* C1A02TOK()
* Validação tudook
*
------------------------------------------------------------------------*/
USER FUNCTION C1A02TOK(nOpc)
LOCAL lRet:= .f.      

if nOpc == 4 

	IF MSGYESNO("Confirma a Aprovação ?", "Atencão")
		lRet:= .T.
	Endif

elseif nOpc == 5

	If  MsgNoYes( "Deseja realmente excluir esta solicitação?", "Atencão" )
		lRet:= .T.	
	Endif

elseif nOpc == 6

	IF MSGYESNO("Confirma a Rejeição ?", "Atencão")
		lRet:= .T.
	Endif

endif

RETURN lRet            
/*------------------------------------------------------------------------
*
* C1A02PRO()
* Processa baixa e transferência
*
------------------------------------------------------------------------*/
STATIC FUNCTION C1A02PRO(nOpc)
local nPosCod	:= GDFieldPos("NM_CODIGO",oGetD:AHEADER)
local nSilSol	:= GDFieldPos("NM_SITSOL",oGetD:AHEADER) 
local cCodSol	:= ""
LOCAL nCnta	:= 0  
local nContSC	:= 0
local nContOK	:= 0     

If nOpc == 5		
	cCodSol := SNM->NM_XCODFOR
	
	dbselectarea("SNM")
	SNM->( dbSetOrder(4) )
	SNM->( dbSeek( xFilial( "SNM" ) + cCodSol ) )
	While SNM->( !EOF() ) .And. xFilial( "SNM" ) == SNM->NM_FILIAL .And. cCodSol == SNM->NM_XCODFOR
		RecLock( "SNM", .F. )
		SNM->( dbDelete() )
		SNM->( MsUnlock() )
		SNM->( dbSkip() )
	End
	
	RECLOCK("ZAB",.f.)
		ZAB->(dbdelete())
	MSUNLOCK()				
Else
	
	FOR nCnta:=1 TO LEN(oGetD:ACOLS) 
		IF nOpc == 4 .AND. oGetD:ACOLS[nCnta][nSilSol] == "1" 
			
			dbSelectArea("SNM")
			SNM->( dbSetOrder(1) )
			If SNM->( dbSeek( xFilial("SNM") + oGetD:ACOLS[nCnta][nPosCod] ) )
				RegToMemory("SNM",.F.)		
				If ATFA126Grava(3,.F.)
					nContSC++
					// ENVIA WORKFLOW
					U_C1A02EWF(2,SNM->NM_SITSOL,SNM->NM_XCODFOR)					
				Endif
			Endif
		
		ELSEIF nOpc == 6 .AND. oGetD:ACOLS[nCnta][nSilSol] == "1"
			
			dbSelectArea("SNM")
			SNM->( dbSetOrder(1) )
			If SNM->( dbSeek( xFilial("SNM") + oGetD:ACOLS[nCnta][nPosCod] ) )		
				RegToMemory("SNM",.F.)
				If ATFA126Grava(4,.F.)
					nContSC++
					// ENVIA WORKFLOW
					U_C1A02EWF(3,SNM->NM_SITSOL,SNM->NM_XCODFOR)
				Endif
			Endif
		
		ENDIF
	NEXT nCnta  
	
	IF nContSC == LEN(oGetD:ACOLS)
		RECLOCK("ZAB",.F.)
			ZAB->ZAB_STATUS:= "2"
		MSUNLOCK()	
	ENDIF
		
Endif
	
RETURN   
/*------------------------------------------------------------------------
*
* C1A02EWF()
* Envia workflow
*
------------------------------------------------------------------------*/
USER FUNCTION C1A02EWF(nTpWF,nTpSC,cCodSol,cCodUsr)
LOCAL cMailAdm	:= GetNewPar("MV_WFADMIN","")
LOCAL cTo			:= ""
LOCAL cCodUsr 	:= ""
LOCAL cCodSuP		:= ""  
LOCAL cSubject	:= ""
LOCAL cMsgProc	:= ""
LOCAL cMsgTask	:= ""  
LOCAL oProcess	:= NIL
LOCAL oHtml		:= NIL
LOCAL cTabela 	:= ""
LOCAL cAprAtf		:= TRIM(SuperGetMv("CI_APRATF",.F.,"")) 

DBSELECTAREA("ZAB")
DBSETORDER(1)					
If ZAB->(dbSeek( xFilial("ZAB")+cCodSol))
	cCodUsr:= ZAB->ZAB_MATRIC
ELSE
	MSGALERT("Não foi possivel localizar o usuário do RH matricula: "+cCodUsr)
	Return		
ENDIF    

// Superior
IF !EMPTY(cCodUsr)
	DBSELECTAREA("ZAA")
	ZAA->(DBSETORDER(1))
	IF ZAA->(DBSEEK(XFILIAL("ZAA")+cCodUsr))
		IF !EMPTY(ZAA->ZAA_EMAIL)
			cTo	+=	ZAA->ZAA_EMAIL+","
		ENDIF
		
		cCodSuP:= ZAA->ZAA_MATSUP
	ELSE
		MSGALERT("Não foi possivel localizar o usuário do RH matricula: "+cCodUsr)
		Return	
	ENDIF
ENDIF

// Superior
IF !EMPTY(cCodSuP)
	ZAA->(DBGOTOP())
	IF ZAA->(DBSEEK(XFILIAL("ZAA")+cCodSuP))
		IF !EMPTY(ZAA->ZAA_EMAIL)
			cTo	+=	ZAA->ZAA_EMAIL+","
		ENDIF
	ENDIF
ENDIF

IF nTpWF == 1 

	// Responsavel ativo fixo
	IF !EMPTY(cAprAtf)
		ZAA->(DBGOTOP())
		IF ZAA->(DBSEEK(XFILIAL("ZAA")+cAprAtf))
			IF !EMPTY(ZAA->ZAA_EMAIL)
				cTo	+=	ZAA->ZAA_EMAIL+","
			ENDIF
		ENDIF
	Endif 
	
	IF nTpSC == "1" // Solicitação de baixa
		cMsgProc:= "Solicitacao de baixa"
		cMsgTask:= "Solicita Baixa"
		cSubject:= "Solicitação de baixa"
		cMsgHtml:= "Solicita&ccedil;&atilde;o de baixa de bens"
	ELSE
		cMsgProc:= "Solicitacao de transferencia"
		cMsgTask:= "Solicita Transf"
		cSubject:= "Solicitação de Transferência"
		cMsgHtml:= "Solicita&ccedil;&atilde;o de transfer&ecirc;ncia de bens"	
	ENDIF	
	
ElseIF nTpWF == 2 // Aprovação

	IF nTpSC == "1" // Solicitação de baixa
		cMsgProc:= "Aprovacao de baixa"
		cMsgTask:= "Aprova Baixa"
		cSubject:= "Aprovação de baixa"
		cMsgHtml:= "Aprova&ccedil;&atilde;o de baixa de bens"
	ELSE
		cMsgProc:= "Aprovacao de transferencia"
		cMsgTask:= "Aprova Transf"
		cSubject:= "Aprovação de Transferência"
		cMsgHtml:= "Aprova&ccedil;&atilde;o de transfer&ecirc;ncia de bens"	
	ENDIF	
		
ElseIF nTpWF == 3 // Rejeição

	IF nTpSC == "1" // Solicitação de baixa
		cMsgProc:= "Rejeicao de baixa"
		cMsgTask:= "Rejeita Baixa"
		cSubject:= "Rejeição de baixa"
		cMsgHtml:= "Rejei&ccedil;&atilde;o de baixa de bens"
	ELSE
		cMsgProc:= "Rejeicao de transferencia"
		cMsgTask:= "Rejeita Transf"
		cSubject:= "Rejeição de Transferência"
		cMsgHtml:= "Rejei&ccedil;&atilde;o de transfer&ecirc;ncia de bens"	
	ENDIF	

endif

// Notificação
IF EMPTY(cTo) 
	cSubject:= "Administrador do Workflow : NOTIFICACAO" 
	cMsgHtml:= "Não foi possivel realizar o envio de e-mail de Solicitação baixa e transferência, pois o Usuário RH de matricula "+cCodUsr+", não possui o e-mail preenchido."  
	nOpc	 := 0	
	
	cTabela += '<table width="100%" height="23" border="0" vspace="0" hspace="0" cellspacing="0" cellpadding="0">'
	cTabela += '<tr>'
	cTabela += '<td bgcolor="#FFFFFF" rowspan="2" style="font-size: 8pt">'
	cTabela += '<p align="left">'
	cTabela += '<img src="http://www.ciee.org.br/portal/media/img50anos/logo_50anos_png.png" width="230" height="80" ></p>'
	cTabela += '</td>'
	cTabela += '<td width="30%" bgcolor="#014282" style="font-size: 8pt" height="20">'
	cTabela += '<p align="right">'
	cTabela += '<font face="Arial" size="4" color="#FFFFFF"><span style="background-color: #014282">Workflow Protheus</span></font></p>'
	cTabela += '</td>'
	cTabela += '</tr>'
	cTabela += '<tr>'
	cTabela += '<td width="100%" bgcolor="#FFFFFF" style="font-size: 8pt">&nbsp;</td>'
	cTabela += '</tr>'
	cTabela += '</table>'
	cTabela += '<br>'
	cTabela += '<br>'		
	cTabela += '<table height="19" width="100%" cellspacing="0">'
	cTabela += '<tbody>'
	cTabela += '<tr><td class="TitleSmall" align="center" height="15" width="100%"></td>'
	cTabela += '</tr>'
	cTabela += '<tr><td class="TitleSmall" align="Left" height="15" width="100%" bgcolor="#FFFFFF"><b><i><font face="Arial" size="3" color="#000000">'+cMsgHtml+'</font></i></b></td>'
	cTabela += '</tr>'
	cTabela += '</tbody>'
	cTabela += '</table>'	
Else
	cTabela += '<table width="100%" height="23" border="0" vspace="0" hspace="0" cellspacing="0" cellpadding="0">'
	cTabela += '<tr>'
	cTabela += '<td bgcolor="#FFFFFF" rowspan="2" style="font-size: 8pt">'
	cTabela += '<p align="left">'
	cTabela += '<img src="http://www.ciee.org.br/portal/media/img50anos/logo_50anos_png.png" width="230" height="80" ></p>'
	cTabela += '</td>'
	cTabela += '<td width="30%" bgcolor="#014282" style="font-size: 8pt" height="20">'
	cTabela += '<p align="right">'
	cTabela += '<font face="Arial" size="4" color="#FFFFFF"><span style="background-color: #014282">Workflow Protheus</span></font></p>'
	cTabela += '</td>'
	cTabela += '</tr>'
	cTabela += '<tr>'
	cTabela += '<td width="100%" bgcolor="#FFFFFF" style="font-size: 8pt">&nbsp;</td>'
	cTabela += '</tr>'
	cTabela += '</table>'
	cTabela += '<br>'
	cTabela += '<br>'
	cTabela += '<table height="19" width="100%" cellspacing="0">'
	cTabela += '<tbody>'
	cTabela += '<tr><td class="TitleSmall" align="center" height="15" width="100%"></td>'
	cTabela += '</tr>'
	cTabela += '<tr><td class="TitleSmall" align="Left" height="15" width="100%" bgcolor="#000000"><b><i><font face="Arial" size="3" color="#FFFFFF">'+cMsgHtml+'</font></i></b></td>'
	cTabela += '</tr>'
	cTabela += '</tbody>'
	cTabela += '</table>'	
	cTabela += '<table style="width: 100%;" border="0" cellspacing="1">'
	cTabela += '<tr>'
	cTabela += '<td class="TableRowBlueDarkMini" align="center" width="10%">'
	cTabela += '<font face="Arial" size="2" color="#000000">C. Custo</font></td>'
	cTabela += '<td  class="TableRowBlueDarkMini" align="center" width="10%">'
	cTabela += '<font face="Arial" size="2" color="#000000">Plaqueta</font></td>'
	cTabela += '<td class="TableRowBlueDarkMini" align="center" width="15%">'
	cTabela += '<font face="Arial" size="2" color="#000000">Descri&ccedil;&atilde;o (Ativo)</font></td>'
	cTabela += '<td class="TableRowBlueDarkMini" align="center" width="10%">'
	cTabela += '<font face="Arial" size="2" color="#000000">Cod. Do Bem</font></td>'
	cTabela += '<td class="TableRowBlueDarkMini" align="center" width="10%">'
	cTabela += '<font face="Arial" size="2" color="#000000">Item</font></td>'
	cTabela += '<td  class="TableRowBlueDarkMini" align="center" width="10%">'
	cTabela += '<font face="Arial" size="2" color="#000000">Qtdade.</font></td>'
	cTabela += '<td class="TableRowBlueDarkMini" align="center" width="10%">'
	cTabela += '<font face="Arial" size="2" color="#000000">Dt. Aquisi&ccedil;&atilde;o</font></td>'
	cTabela += '</tr>'
	cTabela += '<tbody>'
		
	
	dbselectarea("SNM")
	SNM->( dbSetOrder(4) )
	SNM->( dbSeek( xFilial( "SNM" ) + cCodSol ) )
	While SNM->( !EOF() ) .And. xFilial( "SNM" ) == SNM->NM_FILIAL .And. cCodSol == SNM->NM_XCODFOR
		
		cTabela += '<tr>'
		cTabela += '<td class="TableRowWhiteMini2" style="border-bottom-style: solid; border-bottom-width: 1px"><p align="center">'
		cTabela += '<font face="Arial" size="2">' + Posicione("SN3",1,XFILIAL("SN3")+SNM->NM_CBASE+SNM->NM_ITEM,"N3_CUSTBEM") + '</font></p></td>'
		cTabela += '<td class="TableRowWhiteMini2" style="border-bottom-style: solid; border-bottom-width: 1px"><p align="center">'
		cTabela += '<font face="Arial" size="2">' + Posicione("SN1",1,XFILIAL("SN1")+SNM->NM_CBASE+SNM->NM_ITEM,"N1_CHAPA") + '</font></p></td>'
		cTabela += '<td class="TableRowWhiteMini2" style="border-bottom-style: solid; border-bottom-width: 1px">'
		cTabela += '<font face="Arial" size="2">' + Posicione("SN1",1,XFILIAL("SN1")+SNM->NM_CBASE+SNM->NM_ITEM,"N1_DESCRIC") + '</font></td>'
		cTabela += '<td class="TableRowWhiteMini2" style="border-bottom-style: solid; border-bottom-width: 1px"><p align="center">'
		cTabela += '<font face="Arial" size="2">' + SNM->NM_CBASE + '</font></p></td>'
		cTabela += '<td class="TableRowWhiteMini2" style="border-bottom-style: solid; border-bottom-width: 1px"><p align="center">'
		cTabela += '<font face="Arial" size="2">' + SNM->NM_ITEM + '</font></p></td>'
		cTabela += '<td class="TableRowWhiteMini2" style="border-bottom-style: solid; border-bottom-width: 1px"><p align="center">'
		cTabela += '<font face="Arial" size="2">' + CVALTOCHAR(SNM->NM_QTDBX) + '</font></p></td>'
		cTabela += '<td class="TableRowWhiteMini2" style="border-bottom-style: solid; border-bottom-width: 1px"><p align="center">'
		cTabela += '<font face="Arial" size="2">' + DTOC(Posicione("SN1",1,XFILIAL("SN1")+SNM->NM_CBASE+SNM->NM_ITEM,"N1_AQUISIC"))+ '</font></p></td>'
		cTabela += '</tr>'
	
	SNM->( dbSkip() )
	End
	
	cTabela += '</tbody>'
	cTabela += '</table>'	
		
ENDIF

oProcess:= TWFProcess():New( "SOLBXTR", cMsgProc  )
oProcess:newtask(cMsgTask, "\workflow\html\SolicitaBaixaTransferencia.htm")  
oProcess:NewVersion(.T.)
oProcess:cSubject := cSubject	
oProcess:cTo:= IIF(nTpWF== 0,cMailAdm,cTo)
oHtml:= oProcess:oHTML		
oHtml:ValByName( "HTML_ATIVOS",cTabela)
oProcess:Start()	

return
/*------------------------------------------------------------------------
*
* C1A02GRV()
* Exibe legenda
*
------------------------------------------------------------------------*/                      
USER FUNCTION C1A02LEG()   
LOCAL aLegenda		:= {{"BR_VERDE" ,"Pendente" },;		
						{"BR_VERMELHO" ,"Finalizado" }}	
						
BrwLegenda(cCadastro, "Legenda", aLegenda)
RETURN