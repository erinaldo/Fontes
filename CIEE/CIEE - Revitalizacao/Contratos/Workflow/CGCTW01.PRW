#INCLUDE "TOPCONN.CH"
#include "Protheus.ch"

/*---------------------------------------------------------------------------------------
{Protheus.doc} CGCTW01
Job de controle de envio das alçadas de Cotnratos revisados.

@class		Nenhum
@from 		Nenhum
@param    	Nenhum
@attrib    	Nenhum
@protected  Nenhum
@author     AF Custom
@version    P.11
@since      01/10/2014
@return    	Nenhum
@sample   	Nenhum
@obs      	Nenhum
@project    CIEE - Revitalização
@menu    	Nenhum
@history    Nenhum
---------------------------------------------------------------------------------------*/
User function CGCTW01(aParam)
LOCAL cEmp		:= ""
LOCAL cFil		:= ""

If aParam <> Nil
	
	cEmp := alltrim(aParam[1])
	cFil := alltrim(aParam[2])
	
	RpcSetType(3)
	IF RPCSetEnv(cEmp,cFil)
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CGCTW01] Processo Iniciado para "+cEmp+"-"+cFil)
		u_C8W01Env(1)  		// 1-- Envia para aprovaçõa
		//u_C8W01Env(2)		// 2-- Retorno do aprovador - Executado pelo Submit do Html
		//u_C8W01Prc()		// 3-- Retorno de aprovação final - Executado pelo u_MTALCFIM() pois a aprovação pode ser manual.
		CONOUT("["+Left(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CGCTW01] Processo Finalizado para "+cEmp+"-"+cFil)
		RpcClearEnv()
	ENDIF
EndIf

Return

//-- Teste
User function GCT00299()
LOCAL cEmp		:= "99"
LOCAL cFil		:= "01"

CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CGCTW01] Processo Iniciado para "+cEmp+"-"+cFil)
U_C8W01Env(1)  		// 1-- Envia para aprovaçõa
//u_C8W01Env(2)		// 2-- Retorno do aprovador - Executado pelo Submit do Html
//u_C8W01Prc()		// 3-- Retorno de aprovação final - Executado pelo u_MTALCFIM() pois a aprovação pode ser manual.
CONOUT("["+Left(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CGCTW01] Processo Finalizado para "+cEmp+"-"+cFil)

Return

User Function C8W01Env(nOpc,oProcess)

Local cQuery:=''
Local cAlias:=''
Local cGrpAprov	:=''
//------------------------------------------------
//-- Envio do Workflow para aprovação.
//------------------------------------------------
If nOpc==1
	cQuery := " SELECT CR_FILIAL,CR_TIPO,CR_NUM,CR_NIVEL,CR_TOTAL,CR_USER,CR_APROV"
	cQuery += " FROM "+RETSQLNAME("SCR")+" SCR"
	cQuery += " WHERE CR_FILIAL='"+cFilAnt+"'"
	cQuery += " 	AND CR_TIPO='RC'"
	cQuery += " 	AND CR_STATUS='02'"
	cQuery += " 	AND CR_WF=' '"
	cQuery += " 	AND SCR.D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY CR_FILIAL,CR_NUM,CR_NIVEL,CR_USER"
	TcQuery cQuery NEW ALIAS (cAlias:=GetNextAlias())
	dbSelectarea(cAlias)
	While (cAlias)->(!Eof())
		
		cWfId := u_C8W01Prc(nOpc,(cAlias)->CR_FILIAL,TRIM((cAlias)->CR_NUM),(cAlias)->CR_USER,(cAlias)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER),(cAlias)->CR_TOTAL)
		
		dbSelectarea("SCR")
		dbSetOrder(2)
		If dbSeek((cAlias)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
			Reclock("SCR",.F.)
			SCR->CR_WF		:= Iif(Empty(cWfId)," ","1")//1 - Enviado
			SCR->CR_XWFID	:= cWfId					// Rastreabilidade
			MSUnlock()
		EndIf
		
		(cAlias)->(DBSkip())
	End
	
	(cAlias)->(dbCloseArea())
	
	
ElseIf nOpc==2
	
	//-----------------------------------------------------
	//Retorno da aprovação do workflow (Submit do html)
	//-----------------------------------------------------
	cFil     	:= oProcess:oHtml:RetByName("CFILANT")
	cEmp     	:= oProcess:oHtml:RetByName("CEMPANT")
	cObs     	:= alltrim(oProcess:oHtml:RetByName("OBS"))
	cOpc     	:= alltrim(oProcess:oHtml:RetByName("OPC"))
	
	         
	//-- Teste
	//If .F.
	//RpcSetType(3)
	//RPCSetEnv(cEmp,cFil)
	//EndIf
	
	
	cWFID     	:= oProcess:fProcessId
	cTo   		:= oProcess:cTo
	cChaveSCR	:= alltrim(oProcess:oHtml:RetByName("CHAVE"))
	oProcess:Finish()
	
	IF cOpc $ "S|N" //Aprovacao S-Sim N-Nao
		
		
		// Posiciona na tabela de Alcadas 
		DBSelectArea("SCR")
		DBSetOrder(2)
		DBSeek(cChaveSCR)      
		IF !FOUND() .OR. TRIM(SCR->CR_XWFID) <> TRIM(cWFID)
			CONOUT("Processo nao encontrado :" + cWFID + " Processo atual :" + SCR->CR_XWFID)
			Return .T.
		ENDIF
		
		If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#04#05"
			CONOUT("Processo ja respondido via sistema :" + cWFID)
			Return .T.
		EndIf
		
		BEGIN TRANSACTION
		
		RecLock("SCR",.F.)
		SCR->CR_WF:="2"//-- Respondido
		MsUnLock()
		
		//-- MAAlcDoc faz a gravação do CR_STATUS
		//-- P.E. MTALCFIM trata a operações com a Revisão do Contrato.
		//GrpAprov	:=PadR(GetMv('CI_GRPAPR2',,''),Tamsx3('AL_COD')[1])//Grupo de aprovação
		//lLiberou := MAAlcDoc({SCR->CR_NUM,'RC',SCR->CR_TOTAL,SCR->CR_APROV,,cGrpAprov,,,,,cObs},Date(),IIF(cOpc=="S",4,6))
		
		lLiberou := MAAlcDoc({SCR->CR_NUM,'RC',SCR->CR_TOTAL,SCR->CR_APROV,,SCR->CR_APROV,,,,,cObs},msdate(),IIF(cOpc=="S",4,6))
		
		If lLiberou
			U_CGCTE01(1,Alltrim(SCR->CR_NUM))
			U_C8W01Prc(3,cFilAnt,Alltrim(SCR->CR_NUM),CN9->CN9_XUSRRE,,,2,cObs)
		else
			IF cOpc == "N"
				U_CGCTE01(2,Alltrim(SCR->CR_NUM))
				U_C8W01Prc(3,cFilAnt,Alltrim(SCR->CR_NUM),CN9->CN9_XUSRRE,,,1,cObs)
			Endif
		endif
		
		END TRANSACTION
		
	EndIf
	
	//-- Teste	             
	//If .F.
	//RPCClearEnv()
	//EndIf
	
EndIf


Return
                           	

/*------------------------------------------------------------------------------------
*
* C8W01Env()
* Faz o Envio do Workflow
*
------------------------------------------------------------------------------------*/
User function C8W01Prc(nOpc,cFilAux,cNumDoc,cCodUsr,cChave,nTotal,nStatus,cObs)
Local cHttp		:= GetNewPar("MV_WFDHTTP","")
Local cMailAdm	:= GetNewPar("MV_WFADMIN","")
Local cTo			:= UsrRetMail(cCodUsr)
Local cWfId		:= ""
Local oProcess	:= NIL
Local oHtml		:= NIL

IF EMPTY(cTo)    
	nOpc:= 0		
ENDIF

DO CASE
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Notifica administrador³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	CASE nOpc == 0	
	
		oProcess:= TWFProcess():New( "APRVRC", "Envio Aprovacao RC :" + cFilAux + "/" + cNumDoc )
		oProcess:newtask("Notificação", "\workflow\html\Not_RC.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
		oProcess:cSubject := "Administrador do Workflow : NOTIFICACAO"	
		oProcess:cTo:= cMailAdm
		oProcess:UserSiga:= cCodUsr
		oProcess:NewVersion(.T.)
		oHtml:= oProcess:oHTML		
		oHtml:ValByName( "cnome"	  	, "Administrador" )
		oHtml:ValByName( "descproc"	, "Campos E-mail não está preenchido." )
		oHtml:ValByName( "OBS"	  	, "Contrato No: " + cNumDoc + " Filial : " + cFilAnt + " Usuario : " + UsrRetName(cCodUsr) )
		
		oProcess:Start()
		
		cWfId:= oProcess:fProcessId		
		
	//-- Envio de email para aprovacao
	CASE nOpc == 1
		
		oProcess:= TWFProcess():New( "APRVRC", "Envio Aprovacao RC :" + cFilAux + "/" + cNumDoc )
		oProcess:NewTask( "Envio RC : "+cFilAux + cNumDoc, "\WORKFLOW\HTML\APROV_RC.HTM" )
		oProcess:cSubject:= "Aprovacao Revisão de Contrato " + cFilAux + "/"+ cNumDoc
		oProcess:bReturn := "U_C8W01Env(2)"
		oProcess:NewVersion(.T.)
		oProcess:cTo      	:= cCodUsr
		oProcess:UserSiga	:= cCodUsr
		oProcess:cBody		:=''
		oHtml     			:= oProcess:oHTML
		
	CASE nOpc == 3
		//-- Envio de email ao final do processo - Executado a partir de u_MTALCFIM()
		
		oProcess:= TWFProcess():New( "FIMREV", "Posição de Revisão RC :" + cFilAux + "/" + cNumDoc )
		oProcess:NewTask( "Final RC : "+cFilAux + cNumDoc, "\WORKFLOW\HTML\RESP_RC.HTM" )
		oProcess:cSubject:= "Posição de Revisão de Contrato " + cFilAux + "/"+ cNumDoc
		oProcess:NewVersion(.T.)
		oProcess:cTo      	:= UsrRetMail(cCodUsr)
		oProcess:UserSiga	:= cCodUsr
		oHtml     			:= oProcess:oHTML
EndCase


IF nOpc == 1
	
	//-- Variaveis ocultas p/ rastreabilidade
	oHtml:ValByName( "CFILANT"	, xFilial("SCR"))
	oHtml:ValByName( "CEMPANT"	, cEmpAnt)
	oHtml:ValByName( "CHAVE"	, cChave)
	oHtml:ValByName( "WFID"		, oProcess:fProcessId)
	
	dbSelectArea("CN9")
	dbSetOrder(1)
	If dbSeek(xfilial("CN9")+cNumDoc)
		
		AAdd( (oHtml:ValByName( "c.1"))	, CN9->CN9_NUMERO )
		AAdd( (oHtml:ValByName( "c.2"))	, Dtoc(CN9->CN9_DTINIC) )
		AAdd( (oHtml:ValByName( "c.3"))  , Dtoc(CN9->CN9_DTASSI) )
		AAdd( (oHtml:ValByName( "c.4"))	, CN9->CN9_UNVIGE )
		AAdd( (oHtml:ValByName( "c.5"))	, Dtoc(CN9->CN9_DTFIM) )
		AAdd( (oHtml:ValByName( "c.6"))	, CN9->CN9_CLIENT )
		AAdd( (oHtml:ValByName( "c.7"))	, Str(CN9->CN9_VLINI) )
		AAdd( (oHtml:ValByName( "c.8"))	, Str(CN9->CN9_VLATU) )
		AAdd( (oHtml:ValByName( "c.9"))	, CN9->CN9_INDICE )
		
	EndIf
	
	//-- Area do HTML do processo de aprovação
	dbSelectarea("SCR")
	dbSetOrder(1)
	dbSeek(cFilAux+'RC'+cNumDoc)
	
	While !SCR->(Eof()) .And. Alltrim(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) == Alltrim(cFilAux+'RC'+cNumDoc)
		//If !Empty(CR_XWFID)//Quando gerar alçada para memo Doc pela segunda vez.
		//	Loop
		//EndIf
		
		cSituaca := ""
		Do Case
			Case SCR->CR_STATUS == "01"
				cSituaca := "Aguardando Lib"
			Case SCR->CR_STATUS == "02"
				cSituaca := "Em Aprovacao"
			Case SCR->CR_STATUS == "03"
				cSituaca := "Aprovado"
			Case SCR->CR_STATUS == "04"
				cSituaca := "Bloqueado"
			Case SCR->CR_STATUS == "05"
				cSituaca := "Nivel Liberado"
		EndCase
		
		cUsrLib := UsrRetName(SCR->CR_USERLIB)
		
		AAdd( (oHtml:ValByName( "t.1"    )), SCR->CR_NIVEL)
		AAdd( (oHtml:ValByName( "t.2"    )), UsrFullName(SCR->CR_USER))
		AAdd( (oHtml:ValByName( "t.3"    )), cSituaca)
		AAdd( (oHtml:ValByName( "t.4"    )), iIF(SCR->CR_STATUS$'03/05'	,cUsrLib,'') )//Aprovado
		AAdd( (oHtml:ValByName( "t.5"    )), iIF(SCR->CR_STATUS$'04'	,cUsrLib,'') )//Reprovado
		AAdd( (oHtml:ValByName( "t.6"    )), DTOC(SCR->CR_DATALIB))
		AAdd( (oHtml:ValByName( "t.7"    )), SCR->CR_OBS)
		
		SCR->(dbSkip())
	End
	
	cRootDir:=oProcess:oWF:cRootDir //-->  \workflow\emp99\
	
	cProcess := oProcess:Start(cRootDir+"wfRC\")   //Faz a gravacao do link de aprovação no cPath
	cHtmlFile  := cProcess + ".htm"
	
	//-- Cria nova tarefa para enviar um e-mail com o link do HMTL de aprovação.
	oProcess:NewTask("Link RC", "\workflow\HTML\LinkRC.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
	oProcess:NewVersion(.T.)
	oProcess:cTo		:= UsrRetMail(cCodUsr)
	oProcess:cSubject	:= "Aprovação Revisão Contrato - Filial: "+cFilAux+" / Numero: "+cNumDoc
	
	oHtml    := oProcess:oHTML
	oHtml:ValByName( "cAprovador",UsrFullName(cCodUsr))
	oHtml:ValByName( "cNum"	  	 ,cNumDoc)

	oHtml:ValByName("proc_link",TRIM(cHttp)+"/emp"+cempant+"/wfRC/"+cHtmlFile)	
	
	oProcess:Start()
	
	cWfId:= oProcess:fProcessId
	
ElseIf nOpc == 3
	
	cRootDir:=oProcess:oWF:cRootDir
	
	oHtml:ValByName( "CAPROVADOR" , UsrFullName(cCodUsr))
	oHtml:ValByName( "CNUM"		,  cNumDoc )	
	oHtml:ValByName( "OBS"		, cObs )
	If nStatus==1			//Exclusao da Revisao
		oHtml:ValByName( "CPOSICAO"	, 'reprovado' )
	ElseIf nStatus==2		//Aprovação da Revisão 
		oHtml:ValByName( "CPOSICAO"	, 'aprovado' )
	ElseIf nStatus==3		//Estorno de Aprovação
		oHtml:ValByName( "CPOSICAO"	, 'Estornado' )	
	EndIf
	//oProcess:Start("\workflow\emp"+cEmpAnt+"\wfRC\")
	oProcess:Start(cRootDir+"wfRC\")	
	oProcess:Finish()
	
EndIf

Return cWfId