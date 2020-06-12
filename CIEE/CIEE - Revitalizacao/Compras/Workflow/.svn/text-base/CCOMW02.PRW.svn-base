#INCLUDE "TOTVS.CH"      
#INCLUDE "TOPCONN.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCOMW02
Workflow Solicitação de compras
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CCOMW02(aParam)        
LOCAL cEmp		:= ""
LOCAL cFil		:= ""
          
If aParam == Nil
	CONOUT("Parametro invalido => CCOMW02")
ELSE	
	cEmp := alltrim(aParam[1])
	cFil := alltrim(aParam[2])
	
	RpcSetType(3)
	IF RPCSetEnv(cEmp,cFil)                                                                                                              
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CCOMW02] Processo Iniciado para "+cEmp+"-"+cFil)
		U_C2W02WF(1)  		// 1 - Envia solicitação pata aprovaçõa
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CCOMW02] Processo Finalizado para "+cEmp+"-"+cFil)	
		RpcClearEnv()
	ENDIF	
EndIf

RETURN 
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2W0299    ºAutor  ³ Totvs	    	   º Data ³06/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Empresa TESTE								              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
USER FUNCTION C2W0299()        
LOCAL cEmp		:= "99"
LOCAL cFil		:= "01"

RpcSetType(3)
IF RPCSetEnv(cEmp,cFil)                                                                                                              
	CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CCOMW02] Processo Iniciado para "+cEmp+"-"+cFil)
	U_C2W02WF(1)  		// 1 - Envia solicitação pata aprovaçõa
	CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CCOMW02] Processo Finalizado para "+cEmp+"-"+cFil)	
	RpcClearEnv()
ENDIF	

RETURN   
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2W02WF    ºAutor  ³ Totvs	    	   º Data ³06/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de workflow solicitação de compras	              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
user function C2W02WF(nOpc,oProcess)
local cObs		:= ""
local lLiberou:= .F.       
local cTab		:= "" 
local cQry		:= ""  
local cWfId	:= ""
local cComp	:= ""
	
DO 	CASE 	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia as solicitações de compras para aprovacao.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CASE nOpc == 1
		
		cTab	:= GetNextAlias()
		
	  	cQry := " SELECT * FROM "+RETSQLNAME("ZA2")+" ZA2"+CRLF
	  	cQry += " WHERE ZA2_FILIAL='"+cFilAnt+"'"+CRLF
	  	cQry += " 	AND ZA2_STATUS='1'"+CRLF
	  	cQry += " 	AND ZA2_WF=''"+CRLF
	  	cQry += " 	AND ZA2.D_E_L_E_T_=''"+CRLF
	  	cQry += " ORDER BY ZA2_FILIAL,ZA2_NUMSC"+CRLF
	  	                             
	  	
		TcQuery cQry NEW ALIAS (cTab)	                                                   
		(cTab)->(dbSelectArea((cTab)))                    
		(cTab)->(dbGoTop())                               	
		WHILE (cTab)->(!EOF())
                                             
			cWfId := C2W02ENV(nOpc,(cTab)->ZA2_FILIAL,TRIM((cTab)->ZA2_NUMSC),;
								(cTab)->ZA2_TIPO,(cTab)->ZA2_CCUSTO,(cTab)->ZA2_USER,;
								(cTab)->(ZA2_FILIAL+ZA2_NUMSC+ZA2_TIPO+ZA2_CCUSTO))			

			DBSelectarea("ZA2")
			DBSetOrder(1)
			IF DBSeek((cTab)->(ZA2_FILIAL+ZA2_NUMSC+ZA2_TIPO+ZA2_CCUSTO))
				Reclock("ZA2",.F.)
				ZA2->ZA2_WF			:= IIF(EMPTY(cWfId),"","1")  		// WF 	  1 - Realizado o envio /  - Não Realizado o envio
	  			ZA2->ZA2_WFID		:= cWfId							// Rastreabilidade
				MSUnlock()     
			ENDIF
				
		(cTab)->(DBSkip())
		END
		
		(cTab)->(dbCloseArea())
		                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa retorno de aprovação³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CASE nOpc	== 2

		cObs     	:= alltrim(oProcess:oHtml:RetByName("OBS"))
		cOpc     	:= alltrim(oProcess:oHtml:RetByName("OPC"))
		cFilAnt	:= alltrim(oProcess:oHtml:RetByName("CFILANT"))

		cWFID     	:= oProcess:fProcessId
		cTo   		:= oProcess:cTo
		cChaveZA2	:= alltrim(oProcess:oHtml:RetByName("CHAVE"))
		oProcess:Finish() // FINALIZA O PROCESSO

		IF cOpc $ "S|N"  // Aprovacao S-Sim N-Nao
			                   
			BEGIN TRANSACTION
				
				// Posiciona na tabela de Alcadas 
				DBSelectArea("ZA2")
				DBSetOrder(1)
				DBSeek(cChaveZA2)      
				IF !FOUND() .OR. TRIM(ZA2->ZA2_WFID) <> TRIM(cWFID)
					CONOUT("Processo nao encontrado :" + cWFID + " Processo atual :" + ZA2->ZA2_WFID)
					Return .T.
				ENDIF
				
				RECLOCK("ZA2",.F.)     
					ZA2->ZA2_STATUS	:= IIF(cOpc=="N","3","2")
					ZA2->ZA2_WF		:= "2"			// Status 2 - respondido
					ZA2->ZA2_OBS		:= cObs 
					ZA2->ZA2_DATLIB 	:= date() 
					ZA2->ZA2_HORLIB 	:= time()
				MSUNLOCK()	
				
				lLiberou := C2W02LIB(Alltrim(ZA2->ZA2_NUMSC),ZA2->ZA2_TIPO)
	
				If lLiberou
					
					// Solicitação de compras
					if ZA2->ZA2_TIPO == "1"
					
						DBSELECTAREA("SC1")
						DBSETORDER(1)
						DBSEEK(xFilial("SC1")+ Alltrim(ZA2->ZA2_NUMSC))  
				       WHILE SC1->(!Eof()) .And. SC1->(C1_FILIAL+C1_NUM) == ZA2->ZA2_FILIAL+ALLTRIM(ZA2->ZA2_NUMSC)   
			                cComp:= SC1->C1_CODCOMP
			                RECLOCK("SC1",.F.)
				            	SC1->C1_APROV:=  IIF(cOpc=="N","R","")
			                MsUnlock()  
			         	SC1->(DBSKIP())  
				       ENDDO 
				     							       
				       C2W02ENV(3,ZA2->ZA2_FILIAL,TRIM(ZA2->ZA2_NUMSC),ZA2->ZA2_TIPO,ZA2->ZA2_CCUSTO,;
				       			POSICIONE("SY1",1,XFILIAL("SY1")+cComp,"Y1_USER"),;
				       			ZA2->(ZA2_FILIAL+ZA2_NUMSC+ZA2_TIPO+ZA2_CCUSTO),cObs)				       
				   	
				   	// Solicitação de compras WEB
				   	Elseif ZA2->ZA2_TIPO == "2"
				   	
						dbselectarea("ZA1")
						ZA1->( dbSetOrder(1) )
						ZA1->( dbSeek( xFilial( "ZA1" ) + Alltrim(ZA2->ZA2_NUMSC) ) )
						While ZA1->( !EOF() ) .And.  ZA1->(ZA1_FILIAL+ZA1_COD) == ZA2->ZA2_FILIAL+Alltrim(ZA2->ZA2_NUMSC)
							cComp:= ZA1->ZA1_MATRIC
							RecLock( "ZA1", .F. )
			              ZA1->ZA1_STATUS:=  IIF(cOpc=="N","3","2")
			              ZA1->( MsUnlock() )
						ZA1->( dbSkip() )
						ENDDO		
						
				       C2W02ENV(3,ZA2->ZA2_FILIAL,TRIM(ZA2->ZA2_NUMSC),ZA2->ZA2_TIPO,;
				       			ZA2->ZA2_CCUSTO,cComp,;
				       			ZA2->(ZA2_FILIAL+ZA2_NUMSC+ZA2_TIPO+ZA2_CCUSTO),cObs)									   	
				       			   	     
			       Endif
			      			       
			  	ELSE
			  		
			  		IF cOpc == "N" 
						
						// Solicitação de compras
						if ZA2->ZA2_TIPO == "1"			  		
							
							DBSELECTAREA("SC1")
							DBSETORDER(1)
							DBSEEK(xFilial("SC1")+Alltrim(ZA2->ZA2_NUMSC))  
					       WHILE SC1->(!Eof()) .And. SC1->(C1_FILIAL+C1_NUM) == ZA2->ZA2_FILIAL+ALLTRIM(ZA2->ZA2_NUMSC)
			                cComp:= SC1->C1_CODCOMP
			                Reclock("SC1",.F.)
			                	SC1->C1_APROV   :=  "R"
			                MsUnlock()
				         	SC1->(DBSKIP())  
					       ENDDO
					       
					       C2W02ENV(4,ZA2->ZA2_FILIAL,TRIM(ZA2->ZA2_NUMSC),ZA2->ZA2_TIPO,ZA2->ZA2_CCUSTO,;
					       			POSICIONE("SY1",1,XFILIAL("SY1")+cComp,"Y1_USER"),;
					       			ZA2->(ZA2_FILIAL+ZA2_NUMSC+ZA2_TIPO+ZA2_CCUSTO),cObs)						       
					   	
					   	// Solicitação de compras WEB
					   	Elseif ZA2->ZA2_TIPO == "2"
				   	
							dbselectarea("ZA1")
							ZA1->( dbSetOrder(1) )
							ZA1->( dbSeek( xFilial( "ZA1" ) + Alltrim(ZA2->ZA2_NUMSC) ) )
							While ZA1->( !EOF() ) .And.  ZA1->(ZA1_FILIAL+ZA1_COD) == ZA2->ZA2_FILIAL+Alltrim(ZA2->ZA2_NUMSC)
								cComp:= ZA1->ZA1_MATRIC
								RecLock( "ZA1", .F. )
				              ZA1->ZA1_STATUS:=  "3"
				              ZA1->( MsUnlock() )
							ZA1->( dbSkip() )
							ENDDO	
							
					       C2W02ENV(4,ZA2->ZA2_FILIAL,TRIM(ZA2->ZA2_NUMSC),ZA2->ZA2_TIPO,;
					       			ZA2->ZA2_CCUSTO,cComp,;
					       			ZA2->(ZA2_FILIAL+ZA2_NUMSC+ZA2_TIPO+ZA2_CCUSTO),cObs)							
				       Endif 
				       
			  		ENDIF        
				EndIf
			END TRANSACTION
		EndIf				
		
	END CASE			
				
RETURN  
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2W02LIB   ºAutor  ³ Totvs	    	   º Data ³06/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica se possui outros niveis para aprovar              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static function C2W02LIB(cNumSC,cTipoSC)
local lRet:= .t.
local cTab:= GetNextAlias() 
local cQry:= ""
LOCAL nCnt:= 0

DBSELECTAREA("ZA2")

cQry := " SELECT * FROM "+RETSQLNAME("ZA2")+" ZA2"+CRLF
cQry += " WHERE ZA2_FILIAL='"+cFilAnt+"'"+CRLF
cQry += " 	AND ZA2_STATUS IN (' ','1','3')"+CRLF
cQry += " 	AND ZA2_NUMSC='"+cNumSC+"'"+CRLF
cQry += " 	AND ZA2_TIPO='"+cTipoSC+"'"+CRLF
cQry += " 	AND ZA2.D_E_L_E_T_=''"+CRLF 
cQry += " 	ORDER BY R_E_C_N_O_ "+CRLF
  	
TcQuery cQry NEW ALIAS (cTab)	                                                   
(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())                               	
WHILE (cTab)->(!EOF())
	nCnt++	
	// Proximo nivel Workflow
	IF nCnt == 1 .AND. EMPTY((cTab)->ZA2_STATUS)
		ZA2->(DBGOTO((cTab)->R_E_C_N_O_ ))
		IF ZA2->(!EOF())
			RECLOCK("ZA2",.F.)
				ZA2->ZA2_STATUS:= "1"
			MSUNLOCK()
		ENDIF
	ENDIF
(cTab)->(dbskip())
END

(cTab)->(dbCloseArea())

lRet:= nCnt == 0		
		
return lRet
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2W02ENV   ºAutor  ³ Totvs	    	   º Data ³06/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de envio de e-mail                 	              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static function C2W02ENV(nOpc,cFilAux,cNumDoc,cTipoSC,cCCusto,cUsrx,cChave,cResp)
LOCAL cHttp		:= GetNewPar("MV_WFDHTTP","") 
LOCAL cMailAdm	:= GetNewPar("MV_WFADMIN","")
LOCAL cTo			:= ""
LOCAL cWfId		:= ""   
LOCAL oProcess	:= NIL
LOCAL oHtml		:= NIL

IF cTipoSC == "1"	// Solicitação Protheus
	IF nOpc== 3 .or. nOpc == 4
		cTo		:= UsrRetMail(cUsrx)
		cNome	:= UsrFullName(cUsrx)
	ELSE
		cTo		:= POSICIONE("CTD",1,XFILIAL("CTD")+cCCusto,"CTD_XEMAIL")
		cNome	:= POSICIONE("CTD",1,XFILIAL("CTD")+cCCusto,"CTD_XNOME")
	ENDIF	
ELSEIF cTipoSC == "2" // Solicitação Web
	cTo		:= POSICIONE("ZAA",1,XFILIAL("ZAA")+cUsrx,"ZAA_EMAIL")
	cNome	:= POSICIONE("ZAA",1,XFILIAL("ZAA")+cUsrx,"ZAA_NOME")
ENDIF

IF EMPTY(cTo)    
	nOpc:= 0		
ENDIF

DO CASE       

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Notifica administrador³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	CASE nOpc == 0
		
		oProcess:= TWFProcess():New( "000001", "Envio Aprovacao SC :" + cFilAux + "/" + cNumDoc )
		oProcess:newtask("Notificação", "\workflow\html\Resp_SC.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
		oProcess:cSubject := "Administrador do Workflow : NOTIFICACAO"	
		oProcess:cTo:= cMailAdm
		oProcess:NewVersion(.T.)
		oHtml:= oProcess:oHTML		
		oHtml:ValByName( "cnome"	  , "Administrador" )
		oHtml:ValByName( "descproc"	  , "Campos E-mail não está preenchido." )
		oHtml:ValByName( "OBS"	  	  ,"Solicitacao de compras No: " + cNumDoc + " Filial : " + cFilAnt + " Usuario : " + UsrRetName(cCodUsr) )		
		cWfId:= oProcess:fProcessId
	    oProcess:Start()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envio de email para aprovacao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CASE nOpc == 1		
		
		oProcess:= TWFProcess():New( "000001", "Envio Aprovacao SC :" + cFilAux + "/" + cNumDoc )
		oProcess:NewTask( "Envio SC : "+cFilAux + cNumDoc, "\WORKFLOW\HTML\Aprov_SC.HTM" )
		oProcess:cSubject:= "Aprovacao Solicitação de compras " + cFilAux + "/"+ cNumDoc
		oProcess:bReturn:= "U_C2W02WF(2)"	
		oProcess:cTo:= cTo
		oProcess:NewVersion(.T.)
		oHtml:= oProcess:oHTML
		
		oHtml:ValByName( "CHAVE"	, cChave)
		oHtml:ValByName( "WFID"		, oProcess:fProcessId)
		oHtml:ValByName( "OBS"		, "" )
		
		DBSelectArea("SM0")
		DBSetOrder(1)
		DBSeek(cEmpAnt+cFilAnt)
		
		oHtml:ValByName( "CEMPANT"		, SM0->M0_NOME )
		oHtml:ValByName( "CFILANT"		, SM0->M0_CODFIL )
		
		// Solicitação Protheus
		IF cTipoSC == "1"		
		
			DBSelectArea("SC1")
			DBSetOrder(1)
			IF DBSeek(xfilial("SC1")+cNumDoc,.f.)
			
				oHtml:ValByName( "C1_FILIAL"	, SM0->M0_FILIAL )
				oHtml:ValByName( "C1_NUM"		, SC1->C1_NUM)
				oHtml:ValByName( "C1_SOLICIT"  	, UsrFullName(SC1->C1_USER))
				oHtml:ValByName( "C1_EMISSAO"	, DTOC(SC1->C1_EMISSAO) )
				
				WHILE SC1->(!EOF()) .AND. SC1->(C1_FILIAL+C1_NUM) == xFilial("SC1")+cNumDoc
				
					AAdd( (oHtml:ValByName( "t.1"    ))	, SC1->C1_ITEM)
					AAdd( (oHtml:ValByName( "t.2"    ))	, SC1->C1_PRODUTO)
					AAdd( (oHtml:ValByName( "t.3"    ))	, SC1->C1_DESCRI)
					AAdd( (oHtml:ValByName( "t.4"    ))	, SC1->C1_UM)
					AAdd( (oHtml:ValByName( "t.5"    ))	, SC1->C1_QUANT)
					AAdd( (oHtml:ValByName( "t.6"    ))	, DTOC(SC1->C1_DATPRF))
				
				SC1->(dbSkip())
				Enddo
			ENDIF
		
		ELSEIF cTipoSC == "2"
		
			DBSelectArea("ZA1")
			DBSetOrder(1)
			IF DBSeek(xfilial("ZA1")+cNumDoc,.f.)
			
				oHtml:ValByName( "C1_FILIAL"	, SM0->M0_FILIAL )
				oHtml:ValByName( "C1_NUM"		, ZA1->ZA1_COD )
				oHtml:ValByName( "C1_SOLICIT"  	, ZA1->ZA1_NOMSOL )
				oHtml:ValByName( "C1_EMISSAO"	, DTOC(ZA1->ZA1_DATA) )
				
				WHILE ZA1->(!EOF()) .AND. ZA1->(ZA1_FILIAL+ZA1_COD) == xFilial("ZA1")+cNumDoc
				
					AAdd( (oHtml:ValByName( "t.1"    ))	, ZA1->ZA1_ITEM)
					AAdd( (oHtml:ValByName( "t.2"    ))	, ZA1->ZA1_PRODUT)
					AAdd( (oHtml:ValByName( "t.3"    ))	, ZA1->ZA1_DESC)
					AAdd( (oHtml:ValByName( "t.4"    ))	, ZA1->ZA1_UM)
					AAdd( (oHtml:ValByName( "t.5"    ))	, ZA1->ZA1_QUANT)
					AAdd( (oHtml:ValByName( "t.6"    ))	, DTOC(ZA1->ZA1_PRAZO))
				
				ZA1->(dbSkip())
				Enddo
			ENDIF		
			
		ENDIF
		
		cWfId:= oProcess:fProcessId
		oProcess:nEncodeMime := 0		

		oProcess:cTo      		:= nil
		oProcess:NewVersion(.T.)
		oHtml     				:= oProcess:oHTML
		oProcess:nEncodeMime 	:= 0
		cMailID := oProcess:Start("\workflow\emp"+cEmpAnt+"\wfsc\")   //Faz a gravacao do link de aprovação no cPath
		
		chtmlfile  := cmailid + ".htm"

		csubj := "Aprovação Solicitação de compras - Filial: "+cFilAux+" / Numero: "+cNumDoc
		oProcess:newtask("Link", "\workflow\html\link.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
		oHtml:ValByName( "cnome"	  , cNome )
		oHtml:ValByName( "descproc"	  ,"da solicitação de compras No. "+cNumDoc )
		oHtml:ValByName("proclink", TRIM(cHttp)+"/emp"+cempant+"/wfsc/"+chtmlfile ) // envia o link onde esta o arquivo html
		
		oProcess:cTo 	   := cTo
		oProcess:cSubject := cSubj                   
		
		oProcess:Start()
		
		
		cWfId:= oProcess:fProcessId

		                		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envio de email Aprovado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CASE nOpc == 3		
			
		oProcess:= TWFProcess():New( "000001", "Envio p/solicitante SC aprovada : " + cFilAux + "/" + cNumDoc )
		oProcess:NewTask( "Envio SC aprovada : "+cFilAux + cNumDoc, "\WORKFLOW\HTML\Resp_SC.HTM" )
		oProcess:cSubject:= "Solicitacao de compras APROVADA: " + cFilAux + "/" +  cNumDoc 
		oProcess:cTo:= cTo
		oProcess:NewVersion(.T.)
		oHtml:= oProcess:oHTML  		
		oHtml:ValByName( "cnome"	  , cNome )
		oHtml:ValByName( "descproc"	  , "Solicitacao de compras No: " + cNumDoc + " Filial : " + cFilAnt + ", aprovada." )
		oHtml:ValByName( "OBS"	  	  , cResp )		
		oProcess:Start()
		
		cWfId:= oProcess:fProcessId		
		                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envio de email Reprovado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CASE nOpc == 4		
	
		oProcess:= TWFProcess():New( "000001", "Envio p/solicitante SC reprovado : " + cFilAux + "/" + cNumDoc )
		oProcess:NewTask( "Envio SC reprovado : "+cFilAux + cNumDoc, "\WORKFLOW\HTML\Resp_SC.HTM" )
		oProcess:cSubject:= "Solicitacao de compras REPROVADA: " + cFilAux + "/" +  cNumDoc 
		oProcess:cTo:= cTo
		oProcess:NewVersion(.T.)
		oHtml:= oProcess:oHTML  		
		oHtml:ValByName( "cnome"	  , cNome )
		oHtml:ValByName( "descproc"	  , "Solicitacao de compras No: " + cNumDoc + " Filial : " + cFilAnt + ", reprovada." )
		oHtml:ValByName( "OBS"	  	  , cResp )		
		oProcess:Start()
		
		cWfId:= oProcess:fProcessId		

ENDCASE

return cWfId