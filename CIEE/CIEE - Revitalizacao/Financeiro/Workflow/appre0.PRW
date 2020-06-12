#INCLUDE "TOPCONN.CH"
#include "Protheus.ch"

/*---------------------------------------------------------------------------------------
{Protheus.doc} TES006WF
Job de controle de envio das alçadas de Borderô.

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

User function TES006WF(aParam)
LOCAL cEmp		:= ""
LOCAL cFil		:= ""

If aParam <> Nil
	
	cEmp := alltrim(aParam[1])
	cFil := alltrim(aParam[2])
	
	RpcSetType(3)
	IF RPCSetEnv(cEmp,cFil)
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][TES006WF] Processo Iniciado para "+cEmp+"-"+cFil)
		u_Tes006Env(1)  	// 1-- Envia para aprovaçõa
		//u_Tes006Env(2)		// 2-- Retorno do aprovador - Executado pelo Submit do Html
		//u_Tes006Env(3)		// 2-- Retorno do Superintendente - Executado pelo Submit do Html
		CONOUT("["+Left(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][TES006WF] Processo Finalizado para "+cEmp+"-"+cFil)
		RpcClearEnv()
	ENDIF
EndIf

Return

//-- Teste
User function TES00699()
LOCAL cEmp		:= "99"
LOCAL cFil		:= "01"

CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][TES006WF] Processo Iniciado para "+cEmp+"-"+cFil)
U_TES06Env(1)  		// 1-- Envia para aprovação
CONOUT("["+Left(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][TES006WF] Processo Finalizado para "+cEmp+"-"+cFil)

Return

User Function TES06Env(nOpc,oProcess)

Local cQuery:=''
Local cAlias:=''

//-- Envio do Workflow para aprovação.
If nOpc==1
	cQuery := " SELECT CR_FILIAL,CR_TIPO,CR_NUM,CR_NIVEL,CR_TOTAL,CR_USER,CR_APROV"
	cQuery += " FROM "+RETSQLNAME("SCR")+" SCR"
	cQuery += " WHERE CR_FILIAL='"+cFilAnt+"'"
	cQuery += " 	AND CR_TIPO='BP'"//Borderos
	cQuery += " 	AND CR_STATUS='02'"
	cQuery += " 	AND CR_WF=' '"
	cQuery += " 	AND SCR.D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY CR_FILIAL,CR_NUM,CR_NIVEL,CR_USER"
	TcQuery cQuery NEW ALIAS (cAlias:=GetNextAlias())
	dbSelectarea(cAlias)
	While (cAlias)->(!Eof())
		
		cWfId := u_TES06Prc(nOpc,(cAlias)->CR_FILIAL,TRIM((cAlias)->CR_NUM),(cAlias)->CR_USER,(cAlias)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER),(cAlias)->CR_TOTAL)
		
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
	
	
ElseIf nOpc==2 .oR. nOpc==3//Aprovador da alçada inicial ou Procurador
	
	//-- Retorno da aprovação do workflow (Submit do html)
	cFil     	:= oProcess:oHtml:RetByName("CFILANT")
	cEmp     	:= oProcess:oHtml:RetByName("CEMPANT")
	cObs     	:= alltrim(oProcess:oHtml:RetByName("OBS"))
	cOpc     	:= alltrim(oProcess:oHtml:RetByName("OPC"))
	         
	//-- Teste
	//If .F.
	RpcSetType(3)
	RPCSetEnv(cEmp,cFil)
	//EndIf

	cWFID     	:= oProcess:fProcessId
	cTo   		:= oProcess:cTo
	cChaveSCR	:= alltrim(oProcess:oHtml:RetByName("CHAVE"))
	oProcess:Finish()
	
	If cOpc $ "S|N" //Aprovacao S-Sim N-Nao
		
		
		dbSelectArea("SCR")
		dbSetOrder(2)//Fil+Tipo+Num+Usuario
		dbSeek(cChaveSCR)
		If !Found() .OR. Alltrim(SCR->CR_XWFID) <> Alltrim(cWFID)
			//CONOUT("Processo nao encontrado :" + cWFID + " Processo atual :" + SCR->CR_XWFID)
			Return .T.
		EndIf
		
		If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#04#05"
			//CONOUT("Processo ja respondido via sistema :" + cWFID)
			Return .T.
		EndIf
		
		BEGIN TRANSACTION
		
		RecLock("SCR",.F.)
		SCR->CR_WF:="2"//-- Respondido
		MsUnLock()
		
		//-- MaAlcDoc faz a gravação do CR_STATUS
		//-- P.E. MTALCFIM libera SE2 (Gravação do E2_XSTSAPV)
		//-- P.E. Chama u_Gct02Prc()
		lLiberou := MAAlcDoc({SCR->CR_NUM,'BP',SCR->CR_TOTAL,SCR->CR_APROV,,SCR->CR_APROV,,,,,cObs},Date(),IIF(cOpc=="S",4,6))
		
		END TRANSACTION
		
	EndIf
	             
	//If .F.//Teste
	RPCClearEnv()
	//EndIf
EndIf


Return
                           	

/*------------------------------------------------------------------------------------
*
* Gct02Env()
* Faz o Envio do Workflow
*
------------------------------------------------------------------------------------*/
User function Tes06Prc(nOpc,cFilAux,cNumDoc,cCodUsr,cChave,nTotal,nStatus,cObs)

Local nStsBord	:=0
Local cHttp		:= GetNewPar("MV_WFDHTTP","")
Local cMailAdm	:= GetNewPar("MV_WFADMIN","")
Local cTo		:= UsrRetMail(cCodUsr)
Local cWfId		:= ""
Local oProcess	:= NIL
Local oHtml		:= NIL
       
//-- Variavel cNumDoc chega com '_1' ou '_2' aqui (aprovação inicial ou do Procurador)
cNumDoc:=PAdr(cNumDoc,TamSx3('E2_NUMBOR')[1])
DO CASE
	
	//-- Envio de email para aprovacao
	CASE nOpc == 1
		
		oProcess:= TWFProcess():New( "APRVBP", "Envio Aprovacao BP :" + xFilial('SE2') + "/" + cNumDoc )
		oProcess:NewTask( "Envio BP : "+xFilial('SE2') + cNumDoc, "\WORKFLOW\APROV_BP.HTM" )
		oProcess:cSubject:= "Aprovacao Borderô de Pagamentos " + xFilial('SE2') + "/"+ cNumDoc
		oProcess:bReturn := ""
		oProcess:NewVersion(.T.)
		oProcess:cTo      	:= cCodUsr
		oProcess:UserSiga	:= cCodUsr
		oProcess:cBody		:=''
		oHtml     			:= oProcess:oHTML
		
	CASE nOpc == 2 .oR. nOpc == 3//Retorno do Aprovador ou do Procurador
	
		//-- Envio de email ao final do processo - Executado a partir de u_MTALCFIM()		
		oProcess:= TWFProcess():New( "FIMREV", "Posição de Borderô BP :" + xFilial('SE2') + "/" + cNumDoc )
		oProcess:NewTask( "Final RC : "+xFilial('SE2') + cNumDoc, "\WORKFLOW\RESP_BP.HTM" )
		oProcess:cSubject:= "Posição de Aprovação de Borderô " + xFilial('SE2') + "/"+ cNumDoc
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

	dbSelectarea("SE2")
	dbSetOrder(15)//Filial+Borderô
	dbSeek(xFilial('SE2')+cNumDoc)
	
	dbSelectArea("SEA")
	dbSetOrder(2)//FIL+NUMBOR+CARTEIRA
	If dbSeek(xfilial("SEA")+cNumDoc+'P')
		
		AAdd( (oHtml:ValByName( "c.1"))	, EA_NUMBOR )
		AAdd( (oHtml:ValByName( "c.2"))	, DToC(EA_DATABOR) )
		AAdd( (oHtml:ValByName( "c.3")) , EA_FILIAL )
		AAdd( (oHtml:ValByName( "c.4"))	, UsrFullName(SE2->E2_XSOLAPV) )
			
		//-- Area dos titulos do HTML 
		While !SE2->(Eof()) .And. SE2->E2_FILIAL==xFilial('SE2') .And. SE2->E2_NUMBOR==cNumDoc
			 
			 nStsBord:=SE2->E2_XSTSAPV//-- Status de Aprovação      
			/*
			* 0-Gerado Bordero
			* 1-Enviado para aprovação inicial
			* 2-Aprovado inicial
			* 3-Reprovado inicial
			* 4-Enviado para aprovação de PROCURADOR
			* 5-Aprovado pelo Procurador
			* 6-Reprovado pelo Procurador
			*/
			AAdd( (oHtml:ValByName( "t.1"    )), SE2->E2_PREFIXO	)
			AAdd( (oHtml:ValByName( "t.2"    )), SE2->E2_NUM	)
			AAdd( (oHtml:ValByName( "t.3"    )), SE2->E2_PARCELA	)
			AAdd( (oHtml:ValByName( "t.4"    )), SE2->E2_FORNECE+'-'+SE2->E2_LOJA	)
			AAdd( (oHtml:ValByName( "t.5"    )), Str(SE2->E2_SALDO)	)
			AAdd( (oHtml:ValByName( "t.6"    )), DtoC(SE2->E2_VENCREA)	)
			AAdd( (oHtml:ValByName( "t.7"    )), SEA->EA_PORTADO	)
			AAdd( (oHtml:ValByName( "t.8"    )), SEA->EA_AGEDEP	)
			AAdd( (oHtml:ValByName( "t.9"    )), SEA->EA_NUMCON	)				
			
			SE2->(dbSkip())
		End
	EndIf	
	If nStsBord=='0' .oR. nStsBord=='1'//Pode ter enviado para o primeiro Aprovador e para o segundo ainda não.
		//-- Primeiro envio para Aprovação
		oProcess:bReturn := "u_TES06Env(2)"
		
		cQuery:=" Update "+RetSqlName('SE2')+" Set E2_XSTSAPV='1' "
		cQuery+=" Where E2_FILIAL='"+xFilial('SE2')+"' AND E2_NUMBOR='"+cNumDoc+"' AND D_E_L_E_T_=''"
	
	ElseIf nStsBord=='2' .Or.  nStsBord=='4'
		//-- Ja aprovado Inicial - Nesse ponto foi solicitado em u_FA590AROT() aprovação de Procuradores	
		//-- Envio aprovação de PROCURADOR
		oProcess:bReturn := "U_TES06Env(3)"
		
		cQuery:=" Update "+RetSqlName('SE2')+" Set E2_XSTSAPV='4' "
		cQuery+=" Where E2_FILIAL='"+xFilial('SE2')+"' AND E2_NUMBOR='"+cNumDoc+"' AND D_E_L_E_T_=''"
	EndIf
	TcSqlExec(cQuery)	
	             
	cRootDir:=oProcess:oWF:cRootDir //-->  \workflow\emp99\	
	cProcess := oProcess:Start(cRootDir+"wfBP\")   //Faz a gravacao do link de aprovação no cPath
	cHtmlFile  := cProcess + ".htm"
	
	//-- Cria nova tarefa para enviar um e-mail com o link do HMTL de aprovação.
	oProcess:NewTask("Link RC", "\workflow\LinkBP.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
	oProcess:NewVersion(.T.)
	oProcess:cTo		:= UsrRetMail(cCodUsr)
	oProcess:cSubject	:= "Aprovação Borderô de Pagamentos - Filial: "+xFilial('SE2')+" / Numero: "+cNumDoc
	
	oHtml    := oProcess:oHTML
	oHtml:ValByName( "cAprovador",UsrFullName(cCodUsr))
	oHtml:ValByName( "cNum"	  	 ,cNumDoc)

	//-- Link de Aprovação.
	cPath:='\emp'+cEmpAnt+'\wfBP\'
	oHtml:ValByName("proc_link",Trim(cHttp)+cPath+cHtmlFile)	
	
	cProcess := oProcess:Start(cRootDir+"wfBP\")
	cWfId:= oProcess:fProcessId
	
ElseIf nOpc == 2 .oR. nOpc == 3
	//-- nOpc == 2  -> Aprov./Rejeicao Inicial
	//-- nOpc == 3  -> Aprov./Rejeicao de Procurador
	//-- Ja fez update no SE2, esse ponto de execução esta vindo do u_MTALCFIM()       
			
	oHtml:ValByName( "CAPROVADOR" , UsrFullName(cCodUsr))
	oHtml:ValByName( "CNUM"		, cNumDoc )
	oHtml:ValByName( "OBS"		, cObs )
	If nStatus==1//Rejeição do Bordero
		oHtml:ValByName( "CPOSICAO"	, 'reprovado' )
	Else
		oHtml:ValByName( "CPOSICAO"	, 'aprovado' )
	EndIf
	oProcess:Start("\workflow\emp"+cEmpAnt+"\wfRC\")
	oProcess:Finish()
	
EndIf

Return cWfId
