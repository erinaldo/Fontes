#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CEAIA30
Integração SOE NFSE retorno da prefeitura - EAI
@author   	Totvs
@since     	01/08/2014
@version  	P.11      
@return   	Nenhum
@obs       	Nenhum
Alterações	Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data       	  |Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	  |				      | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function CEAIA30(aParam)
LOCAL cEmp		:= ""
LOCAL cFil		:= ""
          
If aParam == Nil
	CONOUT("Parametro invalido => CEAIA30")
ELSE	
	cEmp := alltrim(aParam[1])
	cFil := alltrim(aParam[2])
	
	RpcSetType(3)
	IF RPCSetEnv(cEmp,cFil)                                                                                                              
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CEAIA30] Processo Iniciado para "+cEmp+"-"+cFil)
		CCA30PRO()  		
		CONOUT("["+LEFT(DTOC(Date()),5)+"]["+LEFT(Time(),5)+"][CEAIA30] Processo Finalizado para "+cEmp+"-"+cFil)	
		RpcClearEnv()
	ENDIF	
EndIf

return
/*------------------------------------------------------------------------
*
* CCA30PRO()
* Verifica retorno da prefeitura e integra com SOE
*
------------------------------------------------------------------------*/
STATIC FUNCTION CCA30PRO()
Local cFunXml	:= "CEAIA07"
Local cDescXml:= "Pedido de Venda"
Local aMsgCab	:= {"","0",""}
Local cTab		:= GetNextAlias()
Local cQuery	:= ""

DBSELECTAREA("SF3")

cQuery:=" SELECT DISTINCT F3_NFISCAL"+CRLF
cQuery+=" 		,F3_SERIE"+CRLF
cQuery+=" 		,F3_NFELETR"+CRLF 
cQuery+=" 		,F3_CODNFE"+CRLF
cQuery+=" 		,F3_DTCANC"+CRLF
cQuery+=" 		,F3_CODRET"+CRLF
cQuery+=" 		,F3_DESCRET"+CRLF
cQuery+=" 		,F2_EMINFE"+CRLF
cQuery+=" 		,F2_HORNFE"+CRLF		
cQuery+=" 		,C5_XRPSSOC"+CRLF
cQuery+=" 		,C5_NUM"+CRLF
cQuery+=" 		,SF3.R_E_C_N_O_ AS SF3REC"+CRLF
cQuery+=" FROM "+RetSqlName('SF3')+" SF3"+CRLF
cQuery+=" INNER JOIN "+RetSqlName('SF2')+" SF2 ON F2_FILIAL='"+xFilial("SF2")+"' 
cQuery+=" 		AND F2_DOC=F3_NFISCAL"+CRLF
cQuery+=" 		AND F2_FIMP NOT IN(' ','T')"+CRLF 
cQuery+=" INNER JOIN "+RetSqlName('SD2')+" SD2 ON D2_FILIAL='"+xFilial("SD2")+"'"+CRLF 
cQuery+=" 		AND D2_DOC=F2_DOC"+CRLF
cQuery+=" INNER JOIN "+RetSqlName('SC5')+" SC5 ON F2_FILIAL=C5_FILIAL"+CRLF 
cQuery+=" 		AND C5_NUM=D2_PEDIDO"+CRLF
cQuery+=" WHERE F3_FILIAL='"+xFilial("SF3")+"' AND F3_SERIE='RPS'"+CRLF
cQuery+=" 		AND F3_XFLGRET =''"+CRLF
cQuery+=" 		AND F3_DESCRET!=''"+CRLF
cQuery+=" 		AND SF3.D_E_L_E_T_=''"+CRLF
cQuery+=" ORDER BY F3_NFISCAL"+CRLF

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTab,.T.,.T.)

(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())                               	
WHILE (cTab)->(!EOF())

	aMsgCab	:= {(cTab)->C5_XRPSSOC,"0",""}
	
	If !Empty((cTab)->F3_DTCANC) .AND. !EMPTY((cTab)->F3_NFELETR) //NF cancelada	
	
		aMsgCab[3]:= 	(cTab)->C5_XRPSSOC+'|'+;											// RPS SOC
						(cTab)->C5_NUM+'|'+;												// Pedido Protheus
						TRIM((cTab)->F3_NFISCAL)+'|'+;									// RPS Protheus
						TRIM((cTab)->F3_NFELETR)+'|'+;									// NFS-e
						(cTab)->F3_DTCANC+'|'+;											// Dt/Hr Emissao NFS-e (Cancelamento)
						TRIM((cTab)->F3_CODNFE)+'|'+;									// Cod autorização
						"NF CANCELADA|"+CRLF												// Msg do TSS
	
	ElseIf EMPTY((cTab)->F3_NFELETR) // Não houve emissão de nota por inconsistêcia			
	
		aMsgCab[2]:= "1"
		aMsgCab[3]:= 	(cTab)->C5_XRPSSOC+'|'+;											// RPS SOC
						(cTab)->C5_NUM+'|'+;												// Pedido Protheus
						""+'|'+;															// RPS Protheus
						""+'|'+;															// NFS-e
						""+'|'+;															// Dt/Hr Emissao NFS-e (Cancelamento)
						TRIM((cTab)->F3_CODNFE)+'|'+;									// Cod autorização
						TRIM((cTab)->F3_DESCRET)+'|'+CRLF								// Msg do TSS	 	
 	
 	ELSE // Sucesso na emissão
	
		aMsgCab[3]:= 	(cTab)->C5_XRPSSOC+'|'+;											// RPS SOC
						(cTab)->C5_NUM+'|'+;												// Pedido Protheus
						TRIM((cTab)->F3_NFISCAL)+'|'+;									// RPS Protheus
						TRIM((cTab)->F3_NFELETR)+'|'+;									// NFS-e
						DToS(SF2->F2_EMINFE)+StrTran(SF2->F2_HORNFE,':','') +'|'+;	// Dt/Hr Emissao NFS-e (Cancelamento)
						TRIM((cTab)->F3_CODNFE)+'|'+;									// Cod autorização
						TRIM((cTab)->F3_DESCRET)+'|'+CRLF								// Msg do TSS
	
	EndIf
	
	CCA30RXML(cFunXml,cDescXml,aMsgCab)
	
	// Registra flag de envio para SOE
	SF3->(DBGOTO((cTab)->SF3REC))
	IF SF3->(!EOF())
		RECLOCK("SF3",.F.)
			SF3->F3_XFLGRET:= "X"	
		MSUNLOCK()
	ENDIF
	
(cTab)->(DBSKIP())
END                   
(cTab)->(dbCloseArea())
	

RETURN 
/*------------------------------------------------------------------------
*
* CCA29RXML()
* Monta xml de retorno 
*
------------------------------------------------------------------------*/
static function CCA30RXML(cFunXml,cDescXml,aMsgCab)
local cData	:= Dtos(Date())
local cHora	:= Time()   
local nCnt	:= 0
local cXml	:= ""                         

cXml+= '<TOTVSIntegrator>'+CRLF
cXml+= '	<DATA>'+cData+'</DATA>'+CRLF
cXml+= '	<HORA>'+cHora+'</HORA>'+CRLF
cXml+= '	<ID>'+aMsgCab[1]+'</ID>'+CRLF
cXml+= '	<RETORNO>'+aMsgCab[2]+'</RETORNO>'+CRLF
cXml+= '	<MOTIVO>'+aMsgCab[3]+'</MOTIVO>'+CRLF
cXml+= '	<GlobalDocumentFunctionCode>'+cFunXml+'</GlobalDocumentFunctionCode>'+CRLF
cXml+= '	<GlobalDocumentFunctionDescription>'+cDescXml+'</GlobalDocumentFunctionDescription>'+CRLF
cXml+= '</TOTVSIntegrator>'+CRLF

// Envia xml para funcão de retorno
u_CESBENV(cFunXml,cDescXml,cXml)

RETURN      