#INCLUDE "TOTVS.CH"

//TODO - Utilizado para realizar a integração de contratos com ambiente ORIGINAL, poder ser mantido.
//TODO - Mudar o fonte para o diretoório correto.

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CEAIA33
Rotina de integração cadastro de grupo de produtos
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CEAIA33(cXml)
Local nOpcXml  	:= ""  
Local cError   	:= ""
Local cWarning 	:= ""
Local cDelimit 	:= "_"
local cFunXml		:= "CEAIA33"
local cDescXml 	:= "Integração cadastro de grupo de produtos"
local aMsgCab		:= {"","0",""}
Local xValor   	:= ""
Local cCmpX3   	:= ""
Local cXmlRet   	:= ""
LOCAL aStru		:= {}
LOCAL aBlocoMsg	:= {}
local cChave		:= ""
Private lMsHelpAuto 		:= .T.
Private lMsErroAuto 		:= .F.
Private lAutoErrNoFile 	:= .T.
Default cXml   			:= ""
	
oXml := XmlParser(EncodeUTF8(cXML), cDelimit, @cError, @cWarning)

if !(Empty(cError) .and. Empty(cWarning))
    
	if !Empty(cError)
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "XML - Erro na estrutura do xml|"+CRLF
    endif

	if !Empty(cWarning)    
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "XML - "+cWarning+"|"+CRLF	
	endif 
		
	cXmlRet:= CCA33XML(cFunXml,cDescXml,aMsgCab)
	RETURN cXmlRet
endif 

// Valida se o xml é de grupo de produtos
if Type('oXml:_'+cFunXml+':_SBMMASTER') == "U" 
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "XML - Estrutura do xml não pertence a rotina "+cFunXml+"|"+CRLF
	cXmlRet:= CCA33XML(cFunXml,cDescXml,aMsgCab)
	RETURN cXmlRet
endif    

nOpcXml := Val(&('oXml:_'+cFunXml+':_OPERATION:TEXT'))


SX3->(dbSetOrder(1))
SX3->(dbGoTop())
SX3->(dbSeek("SBM"))

// Carrega vetor com os campos
While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == "SBM"

	IF SX3->X3_CONTEXT == "V"
		SX3->(dbSkip())
		Loop
	ENDIF
	
	IF Type("oXml:_"+cFunXml+":_SBMMASTER:_"+Alltrim(SX3->X3_CAMPO)+":REALNAME") <> "U"
		// Carrega conteudo do variavel
		xValor := &("oXml:_"+cFunXml+":_SBMMASTER:_"+Alltrim(SX3->X3_CAMPO)+":_VALUE:TEXT")
		cCmpX3 := Alltrim(SX3->X3_CAMPO)
		
		// Faz tratamento do dado
		IF SX3->X3_TIPO == "C"
			xValor := PadR(xValor,SX3->X3_TAMANHO)
		ELSEIF SX3->X3_TIPO == "N"
			xValor := Val(xValor)
		ELSEIF SX3->X3_TIPO == "D"
			xValor := Stod(xValor)
		ENDIF

		IF cCmpX3 == "BM_GRUPO"
			cChave:= xValor
		Endif	
		
		aAdd( aStru, {cCmpX3,xValor, NIL } )
	ENDIF
	SX3->(dbSkip())
Enddo

// Nenhum campo localizado
IF Len(aStru) == 0
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "Nenhum campo localizado|"+CRLF
	cXmlRet:= CCA33XML(cFunXml,cDescXml,aMsgCab)
	RETURN cXmlRet
ELSEIF nOpcXml != 3
	dbselectarea("SBM")
	DBSETORDER(1)
	IF !DBseek(xfilial("SBM")+cChave)
		IF nOpcXml == 4
			nOpcXml:= 3 
		ELSE
			aMsgCab[3]+= "Cadastro de grupo de produtos integrado com sucesso."+CRLF
			cXmlRet:= CCA33XML(cFunXml,cDescXml,aMsgCab)
			RETURN cXmlRet		
		ENDIF
	ENDIF		
ENDIF

Begin Transaction
	MSExecAuto({|x,y| MATA035(x,y) }, aStru, nOpcXml )
	
	If lMsErroAuto
		If (__lSX8)
			RollBackSX8()
		EndIf
		
		DisarmTransaction()
		
		aMsgCab[2]:= "1"
		aMsgCab[3]+= U_CESBTRA(GetAutoGRLog())	
		cXmlRet:= CCA33XML(cFunXml,cDescXml,aMsgCab)
	Else
		If (__lSX8)
			ConfirmSX8()
		EndIf
		
		aMsgCab[3]+= "Cadastro de grupo de produtos integrado com sucesso."+CRLF
		cXmlRet:= CCA33XML(cFunXml,cDescXml,aMsgCab)	
		
	EndIf
End Transaction

RETURN cXmlRet 

/*------------------------------------------------------------------------
*
* CCA33XML()
* Monta xml de retorno 
*
------------------------------------------------------------------------*/
static function CCA33XML(cFunXml,cDescXml,aMsgCab)
local cData	:= Dtos(Date())
local cHora	:= Time()   
local nCnt	:= 0
local cXml	:= ""                         

cXml+= '<TOTVSIntegrator>'+CRLF
cXml+= '	<DATA>'+cData+'</DATA>'+CRLF
cXml+= '	<HORA>'+cHora+'</HORA>'+CRLF
cXml+= '	<ID>'+aMsgCab[1]+'</ID>'+CRLF
cXml+= '	<LOGMASTER modeltype="FIELDS">'+CRLF
cXml+= '		<RETORNO>'+aMsgCab[2]+'</RETORNO>'+CRLF	    	       
cXml+= '		<MOTIVO>'+aMsgCab[3]+'</MOTIVO>'+CRLF
cXml+= '	</LOGMASTER>'+CRLF
cXml+= '	<GlobalDocumentFunctionCode>'+cFunXml+'</GlobalDocumentFunctionCode>'+CRLF
cXml+= '	<GlobalDocumentFunctionDescription>'+cDescXml+'</GlobalDocumentFunctionDescription>'+CRLF
cXml+= '</TOTVSIntegrator>'+CRLF

RETURN cXml  