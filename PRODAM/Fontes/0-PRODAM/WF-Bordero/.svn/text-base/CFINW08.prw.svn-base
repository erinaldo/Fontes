#INCLUDE "TOPCONN.CH"
#include "Protheus.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CFINW08
Workflow controle de envio das alçadas de Borderô.
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CFINW08(aParam) 
LOCAL cEmp		:= ""
LOCAL cFil		:= ""
          
If aParam == Nil
	CONOUT("Parametro invalido => CFINW08")
ELSE	
	cEmp := alltrim(aParam[1])
	cFil := alltrim(aParam[2])
	
	RpcSetType(3)
	IF RPCSetEnv(cEmp,cFil)                                                                                                              
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CFINW08] Processo Iniciado para "+cEmp+"-"+cFil)
		U_C6W08WF(1)  		// Rotina Workflow
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CFINW08] Processo Finalizado para "+cEmp+"-"+cFil)	
		RpcClearEnv()
	ENDIF	
EndIf

RETURN
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} C6W08WF
Rotina de processamento de envio e retorno
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function C6W08WF(nOpc,oProcess)

Local cQuery	:=''
Local cAlias	:=''

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
		
		cWfId := u_C6W08ENV(nOpc,(cAlias)->CR_FILIAL,TRIM((cAlias)->CR_NUM),(cAlias)->CR_USER,(cAlias)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER),(cAlias)->CR_TOTAL)
		
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
	cOpc     	:= "S"
	nTotalItens:= val(alltrim(oProcess:oHtml:RetByName("TOTALITENS")))
	cMarcadas	:= alltrim(oProcess:oHtml:RetByName("LINHASMARCADAS"))
	aTit		:= {}	
	nCnt		:= 0
	nOpc		:= 0
	cNumBor	:= ""
	cDocto		:= ""	
	cWFID     	:= oProcess:fProcessId
	cTo   		:= oProcess:cTo
	cChaveSCR	:= alltrim(oProcess:oHtml:RetByName("CHAVE"))
	cChaveSE2	:= ""
	lFlagAprov := .F.
	nReprovados:= 0
	nBkpRecScr := 0
	
	FOR nCnt:=1 to nTotalItens
		lFlagAprov	:= alltrim(cvaltochar(nCnt))$cMarcadas 
		cChaveSE2	:= xfilial("SE2")+; // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
						 oProcess:oHtml:RetByName("t.1")[nCnt]+;
						 oProcess:oHtml:RetByName("T.2")[nCnt]+;
						 oProcess:oHtml:RetByName("T.3")[nCnt]+;
						 oProcess:oHtml:RetByName("T.4")[nCnt]+;
						 oProcess:oHtml:RetByName("T.5.1")[nCnt]+;
						 oProcess:oHtml:RetByName("T.5.2")[nCnt]
		
		IF lFlagAprov
			nReprovados++
		ENDIF
		
		// aTit[x][1] - Flag de aprovação
		// aTit[x][2] - Chave do titulo		 
		AADD(aTit,{lFlagAprov,cChaveSE2})								
	NEXT nCnt
	
	IF nReprovados == nTotalItens
		cOpc:= "N"
	ENDIF 
	
	oProcess:Finish()
	
	If !empty(aTit)
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
		
			cDocto	:= SCR->CR_NUM
			cNumBor:= PadR(SCR->CR_NUM,TamSx3('EA_NUMBOR')[1])	
			nBkpRecScr:= SCR->(RECNO())
			if RIGHT(TRIM(SCR->CR_NUM),2)=="_1"
				nOpc:=2	//Retorno de Aprovação/Rejeic. Inicial
		   	Else
				nOpc:=3	//Retorno de aprovação/Rejeic. de Procurador
			Endif
	
			RECLOCK("SCR",.F.)
				SCR->CR_WF		:= "2"			// Status 2 - respondido
				SCR->CR_OBS	:= cObs
			MSUNLOCK()
		
			// Status SE2:
			// 0-Gerado Bordero
			// 1-Enviado para aprovação inicial
			// 2-Aprovado inicial
			// 3-Reprovado inicial
			// 4-Enviado para aprovação de PROCURADOR
			// 5-Aprovado pelo Procurador
			// 6-Reprovado pelo Procurador	
			
			lLiberou := MAAlcDoc({SCR->CR_NUM,'BP',SCR->CR_TOTAL,SCR->CR_APROV,,SCR->CR_APROV,,,,,cObs},Date(),IIF(cOpc=="S",4,6))
			
			_cArqSCR := CriaTrab(nil,.f.)
			// verifica se esta totalmente liberado
			_cQuery := "SELECT * FROM "+RetSqlName("SCR")+" "
			_cQuery += "WHERE D_E_L_E_T_ = ' ' AND CR_FILIAL = '"+XFilial("SCR")+"' AND CR_NUM = '"+cDocto+"' AND CR_STATUS NOT IN ('03','05') AND CR_TIPO = 'BD' "
			_cQuery := ChangeQuery(_cQuery)
			
			dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),_cArqSCR,.t.,.t.)
			_cSolici := ""
			IF (_cArqSCR)->(Eof()) .and. cOpc == "S"
				FOR nCnt:=1 to LEN(aTit)
					dbSelectarea("SE2")
					SE2->(dbSetOrder(1))//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA 
					IF SE2->(DBSEEK(aTit[nCnt][2]))
						IF SE2->E2_NUMBOR == cNumBor
						   _cSolici := SE2->E2_XSOLAPV
							RECLOCK("SE2",.F.)
								IF aTit[nCnt][1]
									SE2->E2_XSTSAPV= IIF(nOpc==2,'2','5')
								ELSE
									SE2->E2_XSTSAPV= Iif(nOpc==2,'3','6')
								ENDIF	
							MSUNLOCK()
						ENDIF
					ENDIF								
				NEXT nCnt
				
				SCR->(DBGOTO(nBkpRecScr))
				U_C6W08ENV(nOpc,SCR->CR_FILIAL,TRIM(SCR->CR_NUM),_cSolici/*SCR->CR_USER*/,SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER),SCR->CR_TOTAL,2,cObs)
			ELSE

				IF cOpc == "N"
					cQuery:=" Update "+RetSqlName('SE2')+" Set E2_XSTSAPV='"+Iif(nOpc==2,'3','6')+"' "
					cQuery+=" Where E2_FILIAL='"+xFilial('SE2')+"' AND E2_NUMBOR='"+cNumBor+"' AND D_E_L_E_T_=''"
					TcSqlExec(cQuery)					
					
					SCR->(DBGOTO(nBkpRecScr))
					U_C6W08ENV(nOpc,SCR->CR_FILIAL,TRIM(SCR->CR_NUM),SCR->CR_USER,SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER),SCR->CR_TOTAL,1,cObs)
									
				Endif		
			
			ENDIF
	
		END TRANSACTION	
	
	Endif
	
EndIf


Return
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} C6W08ENV
Rotina de envio do workflow
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User function C6W08ENV(nOpc,cFilAux,cNumDoc,cCodUsr,cChave,nTotal,nStatus,cObs)

Local nStsBord	:='0'
Local cHttp		:= GetNewPar("MV_WFDHTTP","")
Local cMailAdm	:= GetNewPar("MV_WFADMIN","")
Local cTo		:= UsrRetMail(cCodUsr)
Local cWfId		:= ""
Local oProcess	:= NIL
Local oHtml		:= NIL
Local nTotalGeral	:= 0
Local nTotalItens	:= 0
Local cHtmlCheck	:= ""
       
//-- Variavel cNumDoc chega com '_1' ou '_2' aqui (aprovação inicial ou do Procurador)
cNumDoc:=PAdr(cNumDoc,TamSx3('E2_NUMBOR')[1])
DO CASE
	
	//-- Envio de email para aprovacao
	CASE nOpc == 1		
		oProcess:= TWFProcess():New( "APRVBP", "Envio Aprovacao BP :" + cNumDoc )
		oProcess:NewTask( "Envio BP : "+xFilial('SE2') + cNumDoc, "\WORKFLOW\HTML\APROV_BP.HTM" )
		oProcess:cSubject	:= "Aprovacao Borderô de Pagamentos " + cNumDoc
		oProcess:bReturn 	:= ""
		oProcess:NewVersion(.T.)
		oProcess:cTo     	:= cCodUsr
		oProcess:UserSiga	:= cCodUsr
		oProcess:cBody	:=''
		oHtml     			:= oProcess:oHTML
		
	CASE nOpc == 2 .oR. nOpc == 3//Retorno do Aprovador ou do Procurador		
		oProcess:= TWFProcess():New( "APRVBP", "Posição de Borderô BP :" + cNumDoc )
		oProcess:NewTask( "Final RC : "+xFilial('SE2') + cNumDoc, "\WORKFLOW\HTML\RESP_BP.HTM" )
		oProcess:cSubject:= "Posição de Aprovação de Borderô " + cNumDoc
		oProcess:NewVersion(.T.)
		oProcess:cTo    	:= UsrRetMail(cCodUsr)
		oProcess:UserSiga	:= cCodUsr
		oHtml     			:= oProcess:oHTML
EndCase

	               
//-- Variaveis ocultas p/ rastreabilidade
oHtml:ValByName( "CFILANT"	, xFilial("SCR"))
oHtml:ValByName( "CEMPANT"	, cEmpAnt)
oHtml:ValByName( "CHAVE"		, cChave)
oHtml:ValByName( "WFID"		, oProcess:fProcessId)

oHtml:ValByName( "CBORDERO"	, cNumDoc)


dbSelectarea("SE2")
dbSetOrder(15)//Filial+Borderô
dbSeek(xFilial('SE2')+cNumDoc)

dbSelectArea("SEA")
dbSetOrder(2)//FIL+NUMBOR+CARTEIRA
If dbSeek(xfilial("SEA")+cNumDoc+'P')
	
	AAdd( (oHtml:ValByName( "c.1"))	, EA_NUMBOR )
	AAdd( (oHtml:ValByName( "c.2"))	, DToC(EA_DATABOR) )
	AAdd( (oHtml:ValByName( "c.3"))	, UsrFullName(SE2->E2_XSOLAPV) )
		
	//-- Area dos titulos do HTML 
	While !SE2->(Eof()) .And. SE2->E2_FILIAL==xFilial('SE2') .And. SE2->E2_NUMBOR==cNumDoc
		 nTotalItens++
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
		IF nOpc == 1
			AAdd( (oHtml:ValByName( "t.0"    )), CVALTOCHAR(nTotalItens))
			nTotalGeral+= SE2->E2_SALDO
		Else
			IF nStsBord$"2,5"
				nTotalGeral+= SE2->E2_SALDO
				AAdd( (oHtml:ValByName( "t.0"    )), "<input type='checkbox' checked name='t.0."+ cvaltochar(nTotalItens) +"' disabled >"	)
			Else
				AAdd( (oHtml:ValByName( "t.0"    )), "<input type='checkbox' name='t.0."+ cvaltochar(nTotalItens) +"' disabled >"	)
			Endif				
		Endif	
		
		AAdd( (oHtml:ValByName( "t.1"    )), SE2->E2_PREFIXO	)
		AAdd( (oHtml:ValByName( "t.2"    )), SE2->E2_NUM	)
		AAdd( (oHtml:ValByName( "t.3"    )), SE2->E2_PARCELA	)
		AAdd( (oHtml:ValByName( "t.4"    )), SE2->E2_TIPO	)
		AAdd( (oHtml:ValByName( "t.5"    )), POSICIONE("SA2",1,XFILIAL("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_NOME"))
		AAdd( (oHtml:ValByName( "t.5.1"  )), SE2->E2_FORNECE	)
		AAdd( (oHtml:ValByName( "t.5.2"  )), SE2->E2_LOJA	)
		AAdd( (oHtml:ValByName( "t.6"    )), DtoC(SE2->E2_VENCREA)	)
		AAdd( (oHtml:ValByName( "t.7"    )), SEA->EA_PORTADO	)
		AAdd( (oHtml:ValByName( "t.8"    )), SEA->EA_AGEDEP	)
		AAdd( (oHtml:ValByName( "t.9"    )), SEA->EA_NUMCON	)				
		AAdd( (oHtml:ValByName( "t.10"    )), TransForm(SE2->E2_SALDO,PESQPICT("SE2","E2_SALDO")))
		SE2->(dbSkip())
	End
	
	oHtml:ValByName( "TotalGeral"		, TransForm(nTotalGeral,PESQPICT("SE2","E2_SALDO")))
	oHtml:ValByName( "TotalItens"		, CVALTOCHAR(nTotalItens) )
	oHtml:ValByName( "LinhasMarcadas"	, "" )

EndIf

IF nOpc == 1	
	If nStsBord=='0' .oR. nStsBord=='1'//Pode ter enviado para o primeiro Aprovador e para o segundo ainda não.
		//-- Primeiro envio para Aprovação
		oProcess:bReturn := "u_C6W08WF(2)"
		
		cQuery:=" Update "+RetSqlName('SE2')+" Set E2_XSTSAPV='1' "
		cQuery+=" Where E2_FILIAL='"+xFilial('SE2')+"' AND E2_NUMBOR='"+cNumDoc+"' AND D_E_L_E_T_=''"
	
	ElseIf nStsBord=='2' .Or.  nStsBord=='4'
		//-- Ja aprovado Inicial - Nesse ponto foi solicitado em u_FA590AROT() aprovação de Procuradores	
		//-- Envio aprovação de PROCURADOR
		oProcess:bReturn := "U_C6W08WF(3)"
		
		cQuery:=" Update "+RetSqlName('SE2')+" Set E2_XSTSAPV='4' "
		cQuery+=" Where E2_FILIAL='"+xFilial('SE2')+"' AND E2_NUMBOR='"+cNumDoc+"' AND D_E_L_E_T_=''"
	EndIf
	TcSqlExec(cQuery)	
	             
	cRootDir:=oProcess:oWF:cRootDir //-->  \workflow\emp99\	
	cProcess := oProcess:Start(cRootDir+"wfBP\")   //Faz a gravacao do link de aprovação no cPath
	cHtmlFile  := cProcess + ".htm"
	
	//-- Cria nova tarefa para enviar um e-mail com o link do HMTL de aprovação.
	oProcess:NewTask("Link RC", "\workflow\HTML\Link.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
	oProcess:NewVersion(.T.)
	oProcess:cTo		:= UsrRetMail(cCodUsr)
	oProcess:cSubject	:= "Aprovação Borderô de Pagamentos - Filial: "+xFilial('SE2')+" / Numero: "+cNumDoc
	
	oHtml    := oProcess:oHTML
	oHtml:ValByName( "cnome",UsrFullName(cCodUsr))
	oHtml:ValByName( "descproc"	 , "do Borderô n° "+cNumDoc)

	//-- Link de Aprovação.
	cPath:='\emp'+cEmpAnt+'\wfBP\'
	oHtml:ValByName("proclink",STRTRAN(Trim(cHttp)+cPath+cHtmlFile,"\","/"))	
	
	cProcess := oProcess:Start(cRootDir+"wfBP\")
	cWfId:= oProcess:fProcessId
Else	
	oProcess:Start()
	oProcess:Finish()	
Endif

Return cWfId

