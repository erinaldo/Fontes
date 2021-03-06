#INCLUDE "TOTVS.CH"      
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CATFW01
Workflow aprova��o de plaquetas ativo fixo
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CATFW01(aParam)        
LOCAL cEmp		:= ""
LOCAL cFil		:= ""
          
If aParam == Nil
	CONOUT("Parametro invalido => CATFW01")
ELSE	
	cEmp := alltrim(aParam[1])
	cFil := alltrim(aParam[2])
	
	RpcSetType(3)
	IF RPCSetEnv(cEmp,cFil)                                                                                                              
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CATFW01] Processo Iniciado para "+cEmp+"-"+cFil)
		U_C1W01WF(1)  		// 1 - Envia workflow de confirmacao
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CATFW01] Processo Finalizado para "+cEmp+"-"+cFil)	
		RpcClearEnv()
	ENDIF	
EndIf

RETURN 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � C1W0199    �Autor  � Totvs	    	   � Data �01/01/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Empresa TESTE								              ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION C1W0199()        
LOCAL cEmp		:= "01"
LOCAL cFil		:= "0001"

RpcSetType(3)
IF RPCSetEnv(cEmp,cFil)                                                                                                              
	CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CATFW01] Processo Iniciado para "+cEmp+"-"+cFil)
	U_C1W01WF(1)  		// 1 - Envia workflow de confirmacao
	CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CATFW01] Processo Finalizado para "+cEmp+"-"+cFil)	
	RpcClearEnv()
ENDIF	

RETURN   
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � C1W01WF    �Autor  � Totvs	    	   � Data �01/01/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � trata envio e retorno de aprova��o de plaquetas	          ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function C1W01WF(nOpc,oProcess)
local cObs		:= ""
local cTab		:= "" 
local cWfId		:= ""
	
DO 	CASE 	
	//�����������������������������������Ŀ
	//�Envia as confirma��es de plaqueta. �
	//�������������������������������������
	CASE nOpc == 1
		
		cTab	:= GetNextAlias()

		BeginSQL Alias cTab
			SELECT *  FROM %Table:ZA3% ZA3
			WHERE ZA3_FILIAL = %xFilial:ZA3% 
				and ZA3_STATUS= '2' 
				and ZA3_WF=''  
				and ZA3.D_E_L_E_T_ = ''
			ORDER BY ZA3_STATUS DESC 	
		EndSQL
			                                                   
		(cTab)->(dbSelectArea((cTab)))                    
		(cTab)->(dbGoTop())                               	
		WHILE (cTab)->(!EOF())   
			
			cWfId := C1W01ENV(nOpc,(cTab)->ZA3_FILIAL,(cTab)->(ZA3_CBASE+ZA3_ITEM),(cTab)->ZA3_EMAILR,(cTab)->(ZA3_FILIAL+ZA3_CBASE+ZA3_ITEM+ZA3_SEQ))			
	                  				  
			DBSelectarea("ZA3")
			DBSetOrder(1)
			IF DBSeek((cTab)->(ZA3_FILIAL+ZA3_CBASE+ZA3_ITEM+ZA3_SEQ))
				Reclock("ZA3",.F.)
				ZA3->ZA3_WF			:= IIF(EMPTY(cWfId),"","1")  		// WF 	  1 - Realizado o envio /  - N�o Realizado o envio
	  			ZA3->ZA3_WFID		:= cWfId							// Rastreabilidade
				MSUnlock()     
			ENDIF
				
		(cTab)->(DBSkip())
		END
		
		(cTab)->(dbCloseArea())
		                
	//�����������������������������Ŀ
	//�Processa retorno de aprova��o�
	//�������������������������������
	CASE nOpc	== 2

		cObs     	:= alltrim(oProcess:oHtml:RetByName("OBS"))
		cOpc     	:= alltrim(oProcess:oHtml:RetByName("OPC"))
		cFilAnt		:= alltrim(oProcess:oHtml:RetByName("CFILANT"))

		cWFID     	:= oProcess:fProcessId
		cTo   		:= oProcess:cTo
		cChaveZA3	:= alltrim(oProcess:oHtml:RetByName("CHAVE"))
		oProcess:Finish() // FINALIZA O PROCESSO

		IF cOpc $ "S|N"  // Aprovacao S-Sim N-Nao
			                   
			BEGIN TRANSACTION
				
				// Posiciona na tabela de Alcadas 
				DBSelectArea("ZA3")
				DBSetOrder(1)
				DBSeek(cChaveZA3)      
				IF !FOUND() .OR. TRIM(ZA3->ZA3_WFID) <> TRIM(cWFID)
					CONOUT("Processo nao encontrado :" + cWFID + " Processo atual :" + ZA3->ZA3_WFID)
					Return .T.
				ENDIF
				
				if cOpc == "S"
					if U_C1E01GRV(3,ZA3->ZA3_CBASE,ZA3->ZA3_ITEM,"3",cObs)
						C1W01ENV(3,ZA3->ZA3_FILIAL,ZA3->(ZA3_CBASE+ZA3_ITEM),ZA3->ZA3_EMAILR,ZA3->(ZA3_FILIAL+ZA3_CBASE+ZA3_ITEM+ZA3_SEQ),cObs)
					endif	
				else            
					if U_C1E01GRV(3,ZA3->ZA3_CBASE,ZA3->ZA3_ITEM,"4",cObs)
						C1W01ENV(4,ZA3->ZA3_FILIAL,ZA3->(ZA3_CBASE+ZA3_ITEM),ZA3->ZA3_EMAILR,ZA3->(ZA3_FILIAL+ZA3_CBASE+ZA3_ITEM+ZA3_SEQ),cObs)
					endif	
				endif
			
			END TRANSACTION
		EndIf				
		
	END CASE			
				
RETURN  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � C1W01ENV   �Autor  � Totvs	    	   � Data �01/01/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de envio de e-mail                 	              ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function C1W01ENV(nOpc,cFilAux,cNumDoc,cTo,cChave,cResp)
LOCAL cHttp		:= GetNewPar("MV_WFDHTTP","") 
LOCAL cMailAdm	:= GetNewPar("MV_WFADMIN","")
LOCAL cWfId		:= "" 
LOCAL cNumPlaq	:= ""  
LOCAL oProcess	:= NIL
LOCAL oHtml		:= NIL

DBSelectArea("SN1")
DBSetOrder(1)
IF !DBSeek(xfilial("SN1")+cNumDoc,.f.)
	CONOUT("N�o foi localizar o numero da plaqueta...")
	return	  
ENDIF

CONOUT("Email :" + cTo )


IF EMPTY(cTo)    
	nOpc:= 0		
ENDIF

DO CASE       

	//����������������������Ŀ
	//�Notifica administrador�
	//������������������������		
	CASE nOpc == 0  		
		
		oProcess:= TWFProcess():New( "CONPLA", "Confirma��o de plaqueta No: " + SN1->N1_CHAPA )
		oProcess:newtask("Notifica��o", "\workflow\html\Resp_PLAQ.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
		oProcess:cSubject := "Administrador do Workflow : NOTIFICACAO"	
		oProcess:cTo:= cMailAdm
		oProcess:UserSiga:= __cUserId
		oProcess:NewVersion(.T.)
		oHtml:= oProcess:oHTML		
		oHtml:ValByName( "cnome"	  , "Administrador" )
		oHtml:ValByName( "descproc"	  , "Campos E-mail n�o est� preenchido." )
		oHtml:ValByName( "OBS"	  	  ,"Confirma��o de plaqueta No: " + SN1->N1_CHAPA + " da Filial : " + cFilAux + " Usuario : " + __cUserId )		
		cWfId:= oProcess:fProcessId
	    oProcess:Start()
	
	//�����������������������������Ŀ
	//�Envio de email para aprovacao�
	//�������������������������������
	CASE nOpc == 1		
		
		oProcess:= TWFProcess():New( "CONPLA", "Confirma��o de plaqueta No: " + SN1->N1_CHAPA )
		oProcess:NewTask( "Confirma��o de plaqueta No: " + SN1->N1_CHAPA , "\WORKFLOW\HTML\Conf_PLAQ.HTM" )
		oProcess:cSubject:= "Confirma��o de plaqueta No: " + SN1->N1_CHAPA
		oProcess:bReturn:= "U_C1W01WF(2)"	
		oProcess:cTo:= cTo
		oProcess:UserSiga:= __cUserId
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
		
		AAdd( (oHtml:ValByName( "t.1"    ))	, SN1->N1_CBASE )
		AAdd( (oHtml:ValByName( "t.2"    ))	, SN1->N1_ITEM )
		AAdd( (oHtml:ValByName( "t.3"    ))	, SN1->N1_DESCRIC )
		AAdd( (oHtml:ValByName( "t.4"    ))	, SN1->N1_CHAPA )

		
		cWfId:= oProcess:fProcessId
		oProcess:nEncodeMime := 0		

		oProcess:cTo      		:= nil
		oProcess:NewVersion(.T.)
		oHtml     				:= oProcess:oHTML
		oProcess:nEncodeMime 	:= 0
		cMailID := oProcess:Start("\workflow\emp"+cEmpAnt+"\wfplaq\")   //Faz a gravacao do link de aprova��o no cPath
		
		chtmlfile  := cmailid + ".htm"

		csubj := "Confirma��o de plaqueta No: " + SN1->N1_CHAPA 
		oProcess:newtask("Link", "\workflow\html\link.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
		oHtml:ValByName( "cnome"	  , UsrFullName(__cUserID) )
		oHtml:ValByName( "descproc"	  ,"da Confirma��o de plaqueta No. "+SN1->N1_CHAPA )
		oHtml:ValByName("proclink", TRIM(cHttp)+"/emp"+cempant+"/wfplaq/"+chtmlfile ) // envia o link onde esta o arquivo html
		
		oProcess:cTo 	   := cTo
		oProcess:cSubject := cSubj                   
		
		oProcess:Start()
		
		
		cWfId:= oProcess:fProcessId

		                		
	//������������������������Ŀ
	//�Envio de email Aprovado �
	//��������������������������
	CASE nOpc == 3		
			
		oProcess:= TWFProcess():New( "CONPLA", "Confirma��o de plaqueta No: " + SN1->N1_CHAPA )
		oProcess:NewTask( "Confirma��o de plaqueta No: " + SN1->N1_CHAPA, "\WORKFLOW\HTML\Resp_PLAQ.HTM" )
		oProcess:cSubject:= "Confirma��o de plaqueta No: " + SN1->N1_CHAPA 
		oProcess:cTo:= cTo
		oProcess:UserSiga:= __cUserID
		oProcess:NewVersion(.T.)
		oHtml:= oProcess:oHTML  		
		oHtml:ValByName( "cnome"	  , UsrFullName(__cUserID) )
		oHtml:ValByName( "descproc"	  , "Plaqueta No: " + SN1->N1_CHAPA +", recebida." )
		oHtml:ValByName( "OBS"	  	  , cResp )		
		oProcess:Start()
		
		cWfId:= oProcess:fProcessId		
		                
	//���������������������������
	//�Envio de email Reprovado �
	//���������������������������
	CASE nOpc == 4		
	
		oProcess:= TWFProcess():New( "CONPLA", "Confirma��o de plaqueta No: " + SN1->N1_CHAPA )
		oProcess:NewTask( "Confirma��o de plaqueta No: " + SN1->N1_CHAPA, "\WORKFLOW\HTML\Resp_PLAQ.HTM" )
		oProcess:cSubject:= "Confirma��o de plaqueta No: " + SN1->N1_CHAPA 
		oProcess:cTo:= cTo
		oProcess:UserSiga:= __cUserId
		oProcess:NewVersion(.T.)
		oHtml:= oProcess:oHTML  		
		oHtml:ValByName( "cnome"	  , UsrFullName(__cUserID) )
		oHtml:ValByName( "descproc"	  , "Plaqueta No: " + SN1->N1_CHAPA +", n�o recebida." )
		oHtml:ValByName( "OBS"	  	  , cResp )		
		oProcess:Start()
		
		cWfId:= oProcess:fProcessId		

ENDCASE

return cWfId