#include "Protheus.ch"

/*---------------------------------------------------------------------------------------
{Protheus.doc} CEAIA19
Faz inclusao de movimento de caixinha

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

User Function CEAIA19(_cXML,_nOpc)

Local _cError    := ""
Local _cWarning  := ""
Local _cDelimit  := "_"
Local lRet		 :=.T.
Local cXMLRet	 :=""
Local cContentRet:=""
Local nTam		 :=TamSx3("EU_NUM")[1]
Local cNum	  	:=''
Local cCaixa	 :=''
Local oXml

Default _cXML    := ""

oXml := XmlParser(_cXML, _cDelimit, @_cError, @_cWarning)

//Verifica se a estrutura foi criada
IF !(Empty(_cError) .and. Empty(_cWarning))
	lRet:=.F.
	cContentRet:='Estrutura do XML invalida.'
EndIF

If lRet
	//Valida se caixa existe e se existe saldo
	cCaixa:=oXml:_FINA560:_SEUMASTER:_EU_CAIXA:_VALUE:TEXT
	dbSelectArea("SET")
	dbSetOrder(1)
	If dbSeek( xFilial('SET')+cCaixa  )
		If SET->ET_SALDO <  Val(oXml:_FINA560:_SEUMASTER:_EU_VALOR:_VALUE:TEXT)   // Valor informado superior ao saldo
			lRet:=.F.
			cContentRet:='Nao ha saldo no caixinha '+ cCaixa
		EndIf
	Else
		lRet:=.F.
		cContentRet:='Caixinha não localizado. Codigo: '+ cCaixa
	EndIf
	
	cNum:=oXml:_FINA560:_SEUMASTER:_EU_COD:_VALUE:TEXT
	cNum:=Padr(cNum,nTam)
	dbSelectArea('SEU')
	dbSetORder(1)
	If dbSeek(xFilial('SEU')+ cNum )
		lRet:=.F.
		cContentRet:='Movimento ja existente. Codigo: '+ cNum
	EndIf
EndIf

If lRet              

	//Não há execauto
	dbSelectArea('SEU')
	RecLock('SEU',.T.)
	EU_FILIAL	:= xFilial('SEU')
	EU_NUM		:=cNum
	EU_CAIXA	:=cCaixa
	EU_TIPO		:=oXml:_FINA560:_SEUMASTER:_EU_TIPO:_VALUE:TEXT
	EU_FILORI	:=xFilial('SEU')
	EU_HISTOR	:=oXml:_FINA560:_SEUMASTER:_EU_HISTOR:_VALUE:TEXT
	EU_NRCOMP	:=oXml:_FINA560:_SEUMASTER:_EU_NRCOMP:_VALUE:TEXT
	EU_VALOR	:=Val(oXml:_FINA560:_SEUMASTER:_EU_VALOR:_VALUE:TEXT)
	If Alltrim(oXml:_FINA560:_SEUMASTER:_EU_TIPO:_VALUE:TEXT)=='01'//Adiantamento
		EU_SLDADIA:=Val(oXml:_FINA560:_SEUMASTER:_EU_VALOR:_VALUE:TEXT)
	EndIF
	EU_BENEF	:=oXml:_FINA560:_SEUMASTER:_EU_BENEF:_VALUE:TEXT
	EU_DTDIGT	:=CtoD(oXml:_FINA560:_SEUMASTER:_EU_DTDIGIT:_VALUE:TEXT)
	EU_EMISSAO	:=CtoD(oXml:_FINA560:_SEUMASTER:_EU_DTDIGIT:_VALUE:TEXT)
	EU_SEQCXA 	:=SET->ET_SEQCXA//Padrao faz essa gravação.
	MsUnlock()
	
EndIf  

cXMLRet:='<TOTVSIntegrator>'
cXMLRet+='	<DATA>'+DToS(Date())+'</DATA>'
cXMLRet+='	<DATA>'+Time()+'</DATA>'
cXMLRet+='	<LOGMASTER modeltype="FIELDS">'
cXMLRet+=' 		<LOGITEM modeltype="FIELDS">'
cXMLRet+='			<ID>'+Alltrim(cNum)+'</ID>'
cXMLRet+='			<RETORNO>'+Iif(Empty(cContentRet),'0','1')+'</RETORNO>'
cXMLRet+='			<MOTIVO>'+cContentRet+'</MOTIVO>'
cXMLRet+='		</LOGITEM>'
cXMLRet+='	</LOGMASTER>'
cXMLRet+='	<GlobalDocumentFunctionCode>FINA560</GlobalDocumentFunctionCode>'
cXMLRet+='	<GlobalDocumentFunctionDescription>Caixinha</GlobalDocumentFunctionDescription>	'
cXMLRet+='</TOTVSIntegrator>'        

//Conout(CRLF)
//Conout(cXMLRet)
//Conout(CRLF)
                
//-- Retorno para ESB
u_CESBENV('CEAIA19','Caixinha',cXMLRet) 
		
Return{Iif(Empty(cContentRet),.T.,.F.),cXMLRet}