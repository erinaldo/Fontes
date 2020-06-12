#include "Protheus.ch"
#include "TopConn.ch"

/*---------------------------------------------------------------------------------------
{Protheus.doc} CEAIA10
Envia contas contabeis novas e/ou alteradas para EAI

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

User Function CEAIA10(_cXML,_nOpc)
Local _cError    := ""
Local _cWarning  := ""
Local _cDelimit  := "_"
Local lRet		:=.T.
Local cXMLRet	:=""
Local oXml
Local cQuery:=''
Local cAlias:=''

Default _cXML    := ""

oXml := XmlParser(_cXML, _cDelimit, @_cError, @_cWarning)
	
//Verifica se a estrutura foi criada
IF !(Empty(_cError) .and. Empty(_cWarning))   
	lRet:=.F.
EndIF
If .T.          
	If oXml:_CEAIA10:_OPERATION:Text=='6'

		cQuery:="Select R_E_C_N_O_ AS REC From "+RetSqlName('CT1')
		cQuery+=" Where CT1_FILIAL='"+xFilial('CT1')+"' And CT1_XENVWS='1' AND D_E_L_E_T_=' '"
		TcQuery cQuery New Alias (cAlias:=GetNextAlias())
	
		cXMLRet:='<TOTVSIntegrator>'
		cXMLRet+='	<DATA>'+DToS(Date())+'</DATA>'
		cXMLRet+='	<DATA>'+Time()+'</DATA>'
		cXMLRet+='	<CT1MASTER modeltype="FIELDS">'
	
		While (cAlias)->(!Eof())			
			dbSelectArea('CT1')
			dbGoTo((cAlias)->REC)
			
			If RecLock('CT1',.F.)
				CT1_XENVWS:='2'//Enviado = Sim
				msUnLock()
			EndIf
			
			cXMLRet+='		<CT1ITEM modeltype="FIELDS">'
			cXMLRet+='			<CT1_CONTA order="1">'
			cXMLRet+='			   <value>'+CT1_CONTA+'</value>'
			cXMLRet+='			</CT1_CONTA>'
			cXMLRet+='			<CT1_DESC01 order="1">'
			cXMLRet+='			   <value>'+CT1_DESC01+'</value>'
			cXMLRet+='			</CT1_DESC01> '
			cXMLRet+='			<CT1_CLASSE order="1">'
			cXMLRet+='			   <value>'+CT1_CLASSE+'</value>'
			cXMLRet+='			</CT1_CLASSE>'
			cXMLRet+='		</CT1ITEM>'
			
			(cAlias)->(dbSkip())			
		End
		cXMLRet+='	</CT1MASTER>'
		cXMLRet+='	<GlobalDocumentFunctionCode>CEAIA10</GlobalDocumentFunctionCode>'
		cXMLRet+='	<GlobalDocumentFunctionDescription>Plano de contas</GlobalDocumentFunctionDescription>	'
		cXMLRet+='</TOTVSIntegrator>'                  

		//-- Retorno para ESB
		u_CESBENV('CEAIA10','Plano de contas',cXMLRet) 
	EndIF
EndIF 

//Conout(CRLF)                      
//Conout(cXMLRet)                   
//Conout(CRLF)                      
Return { lRet, cXMLRet }    