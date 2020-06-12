#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCOMW01
Workflow Pedido de compras
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
user function CCOMW01(aParam)
local cEmp		:= ""
local cFil		:= ""

If aParam == Nil
	CONOUT("Parametro invalido => CCOMW01")
ELSE	
	cEmp := alltrim(aParam[1])
	cFil := alltrim(aParam[2])
	
	RpcSetType(3)
	IF RPCSetEnv(cEmp,cFil)                                                                                                              
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CCOMW01] Processo Iniciado para "+cEmp+"-"+cFil)
		U_C2W01WF(1)  		// 1 - Envia pedido de compras pata aprovaçõa
		U_C2W01WF(3)  		// 3 - Envia retorno de aprovação
		U_C2W01WF(4)  		// 4 - Envia retorno de reprovação
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CCOMW01] Processo Finalizado para "+cEmp+"-"+cFil)	
		RpcClearEnv()
	ENDIF	
EndIf

RETURN                          
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2W0199    ºAutor  ³ Totvs	    	   º Data ³06/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Empresa TESTE								              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
user function C2W0199() 
local cEmp		:= ""
local cFil		:= ""
local aParam	:= {"99","01"}

If aParam == Nil
	CONOUT("Parametro invalido => CCOMW01")
ELSE	
	cEmp := alltrim(aParam[1])
	cFil := alltrim(aParam[2])
	
	RpcSetType(3)
	IF RPCSetEnv(cEmp,cFil)                                                                                                              
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CCOMW01] Processo Iniciado para "+cEmp+"-"+cFil)
		U_C2W01WF(1)  		// 1 - Envia pedido de compras pata aprovaçõa
		U_C2W01WF(3)  		// 3 - Envia retorno de aprovação
		U_C2W01WF(4)  		// 4 - Envia retorno de reprovação
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CCOMW01] Processo Finalizado para "+cEmp+"-"+cFil)	
		RpcClearEnv()
	ENDIF	
EndIf

RETURN   
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2W01WF    ºAutor  ³ Totvs	    	   º Data ³06/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de workflow Pedido de compras	                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/                    
user function C2W01WF(nOpc,oProcess)
local cObs		:= ""
local lLiberou	:= .F.       
local cNumSrc   := ""
local cTab		:= "" 
local cQry		:= ""  
local cWfId		:= ""
private cTpDoc	:= "PC"
	
DO 	CASE 	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia pedido de compras para aprovacao.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CASE nOpc == 1
		
		cTab	:= GetNextAlias()
		
	  	cQry := " SELECT CR_FILIAL,CR_TIPO,CR_NUM,CR_NIVEL,CR_TOTAL,CR_USER,CR_APROV"+CRLF
	  	cQry += " FROM "+RETSQLNAME("SCR")+" SCR"+CRLF
	  	cQry += " WHERE CR_FILIAL='"+cFilAnt+"'"+CRLF
	  	cQry += " 	AND CR_TIPO='"+cTpDoc+"'"+CRLF
	  	cQry += " 	AND CR_STATUS='02'"+CRLF
	  	cQry += " 	AND CR_WF=' '"+CRLF
	  	cQry += " 	AND SCR.D_E_L_E_T_ = ' '"+CRLF
	  	cQry += " ORDER BY CR_FILIAL,CR_NUM,CR_NIVEL,CR_USER"+CRLF
	  	                             
	  	
		TcQuery cQry NEW ALIAS (cTab)	                                                   
		(cTab)->(dbSelectArea((cTab)))                    
		(cTab)->(dbGoTop())                               	
		WHILE (cTab)->(!EOF())
                                                
			cWfId 		:= C2W01ENV(nOpc,(cTab)->CR_FILIAL,TRIM((cTab)->CR_NUM),(cTab)->CR_USER,(cTab)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))			
	
			DBSelectarea("SCR")
			DBSetOrder(2)
			IF DBSeek((cTab)->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
				Reclock("SCR",.F.)
				SCR->CR_WF			:= IIF(EMPTY(cWfId)," ","1")  		// Status 1 - Realizado o envio /  - Não Realizado o envio
	  			SCR->CR_XWFID		:= cWfId							// Rastreabilidade
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
		cFilAnt		:= alltrim(oProcess:oHtml:RetByName("CFILANT"))

		cWFID     	:= oProcess:fProcessId
		cTo   		:= oProcess:cTo
		cChaveSCR	:= alltrim(oProcess:oHtml:RetByName("CHAVE"))
		oProcess:Finish() // FINALIZA O PROCESSO

		IF cOpc $ "S|N"  // Aprovacao S-Sim N-Nao
			                   
			BEGIN TRANSACTION
				// Posiciona na tabela de Alcadas 
				DBSelectArea("SCR")
				DBSetOrder(2)
				DBSeek(cChaveSCR)      
				IF !FOUND() .OR. TRIM(SCR->CR_XWFID) <> TRIM(cWFID)
					CONOUT("Processo nao encontrado :" + cWFID + " Processo atual :" + SCR->CR_XWFID)
					Return .T.
				ENDIF
				
				RECLOCK("SCR",.F.)
					SCR->CR_WF		:= "2"			// Status 2 - respondido
					SCR->CR_OBS		:= cObs
				MSUNLOCK()
	
				If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#04#05"
					CONOUT("Processo ja respondido via sistema :" + cWFID)
					Return .T.
				EndIf          			
				
				lLiberou := MAAlcDoc({SCR->CR_NUM,cTpDoc,SCR->CR_TOTAL,SCR->CR_APROV,,SCR->CR_APROV,,,,,cObs},msdate(),IIF(cOpc=="S",4,6))
	 			
				If lLiberou
					DBSELECTAREA("SC7")
					DBSETORDER(1)
					DBSEEK(xFilial("SC7")+Alltrim(SCR->CR_NUM))  
			        WHILE SC7->(!Eof()) .And. SC7->(C7_FILIAL+C7_NUM) == SCR->CR_FILIAL+ALLTRIM(SCR->CR_NUM)   
		         		RecLock("SC7",.F.) 
		         			SC7->C7_WF		:= "2"  					// Status 2 - Respondido
							SC7->C7_CONAPRO	:= IIF(cOpc=="N","B","L")
						SC7->(msUnlock())
		         	SC7->(DBSKIP())  
			        ENDDO
			  	ELSE
			  		IF cOpc == "N" 
						DBSELECTAREA("SC7")
						DBSETORDER(1)
						DBSEEK(xFilial("SC7")+Alltrim(SCR->CR_NUM))  
				        WHILE SC7->(!Eof()) .And. SC7->(C7_FILIAL+C7_NUM) == SCR->CR_FILIAL+ALLTRIM(SCR->CR_NUM)
			                Reclock("SC7",.F.)
			                	SC7->C7_WF		:= "2"  					// Status 2 - Respondido
			                	SC7->C7_CONAPRO	:=  "B"
			                MsUnlock()
			         	SC7->(DBSKIP())  
				        ENDDO
			  		ENDIF        
				EndIf
			END TRANSACTION
		EndIf				
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia resposta da aprovação ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	CASE nOpc == 3                   
		
		cTab := GetNextAlias()
		
	  	cQry := " SELECT * FROM "+RETSQLNAME("SC7")+" SC7"+CRLF
	  	cQry += " WHERE C7_FILIAL='"+cFilAnt+"'"+CRLF
	  	cQry += " 	AND C7_CONAPRO='L'"+CRLF
	  	cQry += " 	AND C7_WF='2'"+CRLF	  	
	  	cQry += " 	AND SC7.D_E_L_E_T_ = ' '"+CRLF
	  	cQry += " ORDER BY C7_FILIAL,C7_NUM"+CRLF		
		  	
		TcQuery cQry NEW ALIAS (cTab)	                                                   
		(cTab)->(dbSelectArea((cTab)))                    
		(cTab)->(dbGoTop())                               	
		WHILE (cTab)->(!EOF())		
		
			cWfId	 	:= C2W01ENV(nOpc,(cTab)->C7_FILIAL, TRIM((cTab)->C7_NUM), (cTab)->C7_USER , (cTab)->C7_FILIAL + cTpDoc + PADR((cTab)->C7_NUM,50))
					           
			DBSelectarea("SC7")
			DBSetOrder(1)
			IF SC7->(DBSeek((cTab)->(C7_FILIAL+C7_NUM)))			
				WHILE SC7->(!EOF()) .AND. SC7->(C7_FILIAL+C7_NUM) == (cTab)->(C7_FILIAL+C7_NUM)
					Reclock("SC7",.F.)
					SC7->C7_WF		:= "3"						  		
		  			SC7->C7_WFID	:= cWfId						  	
					MSUnlock()				
				SC7->(dbSkip())
				Enddo 				
			ENDIF
				
		(cTab)->(DBSkip())
		END
		
		(cTab)->(dbCloseArea())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia resposta de reprovação ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	CASE nOpc == 4


		cTab := GetNextAlias()
		
	  	cQry := " SELECT * FROM "+RETSQLNAME("SC7")+" SC7"+CRLF
	  	cQry += " WHERE C7_FILIAL='"+cFilAnt+"'"+CRLF
	  	cQry += " 	AND C7_CONAPRO='B'"+CRLF
	  	cQry += " 	AND C7_WF='2'"+CRLF	  	
	  	cQry += " 	AND SC7.D_E_L_E_T_ = ' '"+CRLF
	  	cQry += " ORDER BY C7_FILIAL,C7_NUM"+CRLF		
		  	
		TcQuery cQry NEW ALIAS (cTab)	                                                   
		(cTab)->(dbSelectArea((cTab)))                    
		(cTab)->(dbGoTop())                               	
		WHILE (cTab)->(!EOF())		
		
			cWfId	 	:= C2W01ENV(nOpc,(cTab)->C7_FILIAL, TRIM((cTab)->C7_NUM), (cTab)->C7_USER , (cTab)->C7_FILIAL + cTpDoc + PADR((cTab)->C7_NUM,50))
					           			
			DBSelectarea("SC7")
			DBSetOrder(1)
			IF SC7->(DBSeek((cTab)->(C7_FILIAL+C7_NUM)))			
				WHILE SC7->(!EOF()) .AND. SC7->(C7_FILIAL+C7_NUM) == (cTab)->(C7_FILIAL+C7_NUM)
					Reclock("SC7",.F.)
					SC7->C7_WF		:= "3"
		  			SC7->C7_WFID	:= cWfId						  
					MSUnlock()				
				SC7->(dbSkip())
				Enddo 				
			ENDIF						
		(cTab)->(DBSkip())
		END		
		(cTab)->(dbCloseArea())			
	END CASE			
				
RETURN                 
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2W01ENV   ºAutor  ³ Totvs	    	   º Data ³06/09/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de envio de e-mail                 	              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/             
static function C2W01ENV(nOpc,cFilAux,cNumDoc,cCodUsr,cChave)
local cHttp		:= GetNewPar("MV_WFDHTTP","") 
local cMailAdm	:= GetNewPar("MV_WFADMIN","")
local cTo			:= UsrRetMail(cCodUsr)
local lBloq 		:= .f.                    
local cWfId		:= ""   
local oProcess	:= NIL
local oHtml		:= NIL  
local nSubTot		:= 0
local nFrete 		:= 0
local nTotal 		:= 0


IF EMPTY(cTo)    
	nOpc:= 0		
ENDIF

DO CASE      

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Notifica administrador³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	CASE nOpc == 0	
	
		oProcess:= TWFProcess():New( "PEDCOM", "Envio Aprovacao "+cTpDoc+" :" + cFilAux + "/" + cNumDoc )
		oProcess:newtask("Notificação", "\workflow\html\Not_"+cTpDoc+".htm")  //Cria um novo processo de workflow que informara o Link ao usuario
		oProcess:cSubject := "Administrador do Workflow : NOTIFICACAO"	
		oProcess:cTo:= cMailAdm
		oProcess:UserSiga:= cCodUsr
		oProcess:NewVersion(.T.)
		oHtml:= oProcess:oHTML		
		oHtml:ValByName( "cnome"	  , "Administrador" )
		oHtml:ValByName( "descproc"	  , "Campos E-mail não está preenchido." )
		oHtml:ValByName( "OBS"	  	  ,"Pedido de compras No: " + cNumDoc + " Filial : " + cFilAnt + " Usuario : " + UsrRetName(cCodUsr) )		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envio de email para aprovacao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CASE nOpc == 1		
		
		oProcess:= TWFProcess():New( "PEDCOM", "Envio Aprovacao "+cTpDoc+" :" + cFilAux + "/" + cNumDoc )
		oProcess:NewTask( "Envio "+cTpDoc+" : "+cFilAux + cNumDoc, "\WORKFLOW\HTML\Aprov_"+cTpDoc+".HTM" )
		oProcess:cSubject:= "Aprovacao pedido de compras " + cFilAux + "/"+ cNumDoc
		oProcess:bReturn := "U_C2W01WF(2)"	
		oProcess:cTo      	:= cTo
		oProcess:UserSiga	:= cCodUsr
		oProcess:NewVersion(.T.)
		oHtml     			:= oProcess:oHTML 
		
		oHtml:ValByName( "CFILANT"	, xFilial("SCR"))
		oHtml:ValByName( "CHAVE"	, cChave)
		oHtml:ValByName( "WFID"		, oProcess:fProcessId)
		oHtml:ValByName( "OBS"		, "" )  
		
		DBSelectArea("SM0")
		DBSetOrder(1)
		DBSeek(cEmpAnt+cFilAnt)
		
		oHtml:ValByName( "CEMPANT"		, SM0->M0_NOME )
		oHtml:ValByName( "CFILANT"		, SM0->M0_CODFIL )		
		                		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envio de email Aprovado para solicitante³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CASE nOpc == 3		
			
		oProcess:= TWFProcess():New( "PEDCOM", "Envio p/solicitante "+cTpDoc+" aprovada : " + cFilAux + "/" + cNumDoc )
		oProcess:NewTask( "Envio "+cTpDoc+" aprovada : "+cFilAux + cNumDoc, "\WORKFLOW\HTML\Resp_"+cTpDoc+".HTM" )
		oProcess:cSubject:= "Pedido de compras APROVADA: " + cFilAux + "/" +  cNumDoc		
		oProcess:cTo      	:= cTo
		oProcess:UserSiga	:= cCodUsr
		oProcess:NewVersion(.T.)
		oHtml     			:= oProcess:oHTML
		oHtml:ValByName( "OBS", "Pedido de compras No: " + cNumDoc + " Filial : " + cFilAnt + ", aprovado." ) 			                                 				
				                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envio de email Reprovado para solicitante³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CASE nOpc == 4		
	
		oProcess:= TWFProcess():New( "PEDCOM", "Envio p/solicitante "+cTpDoc+" reprovado : " + cFilAux + "/" + cNumDoc )
		oProcess:NewTask( "Envio "+cTpDoc+" reprovado : "+cFilAux + cNumDoc, "\WORKFLOW\HTML\Resp_"+cTpDoc+".HTM" )
		oProcess:cSubject:= "Pedido de compras REPROVADA: " + cFilAux + "/" +  cNumDoc
		oProcess:cTo      	:= cTo
		oProcess:UserSiga	:= cCodUsr
		oProcess:NewVersion(.T.)
		oHtml     			:= oProcess:oHTML	  
		oHtml:ValByName( "OBS", "Pedido de compras No: " + cNumDoc + " Filial : " + cFilAnt + ", reprovado." )

ENDCASE

IF nOpc > 0

	nSubTot := 0
	nFrete  := 0
	nTotal  := 0		
	
	DBSelectArea("SC7")
	DBSetOrder(1)
	IF DBSeek(xfilial("SC7")+cNumDoc,.f.)
	
		oHtml:ValByName( "C7_FILIAL"	, SM0->M0_FILIAL )
		oHtml:ValByName( "C7_NUM"		, SC7->C7_NUM)
		oHtml:ValByName( "C7_SOLICIT"  	, UsrFullName(SC7->C7_USER))
		oHtml:ValByName( "C7_EMISSAO"	, DTOC(SC7->C7_EMISSAO) )
		
		WHILE SC7->(!EOF()) .AND. SC7->(C7_FILIAL+C7_NUM) == xFilial("SC7")+cNumDoc
		
			AAdd( (oHtml:ValByName( "t.1"    ))	, SC7->C7_ITEM)
			AAdd( (oHtml:ValByName( "t.2"    ))	, SC7->C7_PRODUTO)
			AAdd( (oHtml:ValByName( "t.3"    ))	, SC7->C7_DESCRI)
			AAdd( (oHtml:ValByName( "t.4"    ))	, SC7->C7_OBS)
			AAdd( (oHtml:ValByName( "t.5"    ))	, SC7->C7_UM)
			AAdd( (oHtml:ValByName( "t.6"    ))	, DTOC(SC7->C7_DATPRF)) 				                                                                                            
			AAdd( (oHtml:ValByName( "t.7"    ))	, TransForm(SC7->C7_QUANT,PESQPICT("SC7","C7_QUANT")))
			AAdd( (oHtml:ValByName( "t.8"    ))	, TransForm(SC7->C7_PRECO,PESQPICT("SC7","C7_PRECO")))
			AAdd( (oHtml:ValByName( "t.9"    ))	, TransForm(SC7->C7_TOTAL,PESQPICT("SC7","C7_TOTAL")))
	
			nSubTot += SC7->C7_TOTAL
			nFrete  += SC7->C7_VALFRE
			nTotal  += SC7->(C7_TOTAL+C7_VALFRE)
					
		SC7->(dbSkip())
		Enddo
	ENDIF  
	
	oHtml:ValByName( "vlrtotal" , TRANSFORM(nSubTot,PESQPICT("SC7","C7_TOTAL")) )
	oHtml:ValByName( "vlrfrete" , TRANSFORM(nFrete ,PESQPICT("SC7","C7_TOTAL")) )
	oHtml:ValByName( "totgeral" , TRANSFORM(nTotal ,PESQPICT("SC7","C7_TOTAL")) )		
	
	//-------------------------------------------------------------
	// ALIMENTA A TELA DE PROCESSO DE APROVAÇÃO 
	//-------------------------------------------------------------
	DBSelectarea("SCR")
	DBSetOrder(1)
	DBSeek(cFilAux+cTpDoc+cNumDoc,.T.)
	WHILE !SCR->(EOF()) .AND. Alltrim(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) == Alltrim(cFilAux+cTpDoc+cNumDoc)
	
		cSituaca := ""
		Do Case
			Case SCR->CR_STATUS == "01"
				cSituaca := IIF(lBloq,"Bloqueado","Aguardando Lib") //"SOLICITAÇÃO LIBERADO"#"AGUARDANDO LIB."
			Case SCR->CR_STATUS == "02"
				cSituaca := "Em Aprovacao"
			Case SCR->CR_STATUS == "03"
				cSituaca := "Aprovado"
			Case SCR->CR_STATUS == "04"
				cSituaca := "Bloqueado"
				lBloq := .T.
			Case SCR->CR_STATUS == "05"
				cSituaca := "Nivel Liberado"
		EndCase	
	                                             
		_cT4 := UsrRetName(SCR->CR_USERLIB)
		_cT6 := SCR->CR_OBS
		
		AAdd( (oHtml:ValByName( "t1.1"    )), SCR->CR_NIVEL)
		AAdd( (oHtml:ValByName( "t1.2"    )), UsrFullName(SCR->CR_USER))
		AAdd( (oHtml:ValByName( "t1.3"    )), cSituaca    )
		AAdd( (oHtml:ValByName( "t1.4"    )), IIF(EMPTY(_cT4),"", _cT4))
		AAdd( (oHtml:ValByName( "t1.5"    )), DTOC(SCR->CR_DATALIB))
		AAdd( (oHtml:ValByName( "t1.6"    )), IIF(EMPTY(_cT6),"", _cT6))
		
	SCR->(DBSkip())
	ENDDO	
	
	cWfId:= oProcess:fProcessId
	oProcess:nEncodeMime := 0 
	
	
	if nOpc == 1     
		
		oProcess:cTo      		:= nil
		oProcess:NewVersion(.T.)
		oHtml     				:= oProcess:oHTML
		oProcess:nEncodeMime 	:= 0
		cMailID := oProcess:Start("\workflow\emp"+cEmpAnt+"\wfpc\")   //Faz a gravacao do link de aprovação no cPath
		
		chtmlfile  := cmailid + ".htm"
	
		csubj := "Aprovação pedido de compras - Filial: "+cFilAux+" / Numero: "+cNumDoc
		oProcess:newtask("Link", "\workflow\html\link.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
		oHtml:ValByName( "cnome"	  , UsrFullName(cCodUsr) )
		oHtml:ValByName( "descproc"	  ,"do pedido de compras No. "+cNumDoc )
		oHtml:ValByName("proclink", TRIM(cHttp)+"/emp"+cempant+"/wfpc/"+chtmlfile ) // envia o link onde esta o arquivo html
		oProcess:cTo 	   := UsrRetMail(cCodUsr)
		oProcess:cSubject := cSubj                   
		
		oProcess:Start()
			    
	else  
		oProcess:Start()
	endif
else
	oProcess:Start()	
endif	

cWfId:= oProcess:fProcessId
		
RETURN cWfId 