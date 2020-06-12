#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CEAIA08
Integração	cadastro de clientes - EAI
@author    Totvs
@since     	01/08/2014
@version  	P.11      
@return    Nenhum
@obs        Nenhum
Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function CEAIA08(cXml)
Local nOpcXml   	:= ""  
Local cError   		:= ""
Local cWarning 		:= ""
Local cDelimit 		:= "_"
Local aCab	     	:= {}
local cFunXml		:= "CEAIA08"
local cDescXml 		:= "Cadastro de clientes"
local aMsgCab		:= {"","0",""}
Local xValor   		:= ""
Local cCmpX3   		:= ""
Local cCodId   		:= ""
Private lMsErroAuto	:= .F.
Private lAutoErrNoFile:= .T.
Default cXml   		:= ""  

oXml := XmlParser(cXML, cDelimit, @cError, @cWarning)

if !(Empty(cError) .and. Empty(cWarning))
    
	if !Empty(cError)
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "XML - Erro na estrutura do xml"+CRLF
    endif

	if !Empty(cWarning)    
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "XML - "+cWarning+CRLF	
	endif 
		
	CCA08RXML(cFunXml,cDescXml,aMsgCab)
	Return
endif 

// Valida se o xml é de clientes
if Type('oXml:_'+cFunXml+':_SA1MASTER') == "U" 
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "XML - Estrutura do xml não pertence a rotina "+cFunXml+CRLF
	CCA08RXML(cFunXml,cDescXml,aMsgCab)
	Return
endif    

nOpcXml := Val(&('oXml:_'+cFunXml+':_OPERATION:TEXT'))
                    
SX3->(dbSetOrder(1))
SX3->(dbGoTop())
SX3->(dbSeek("SA1"))

// Carrega vetor com os campos
While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == "SA1"
	
	IF SX3->X3_CONTEXT == "V"
		Loop
		SX3->(dbSkip())
	ENDIF
	
	IF Type("oXml:_"+cFunXml+":_SA1MASTER:_"+Alltrim(SX3->X3_CAMPO)+":REALNAME") <> "U"
		// Carrega conteudo do variavel
		xValor := &("oXml:_"+cFunXml+":_SA1MASTER:_"+Alltrim(SX3->X3_CAMPO)+":_VALUE:TEXT")
		cCmpX3 := Alltrim(SX3->X3_CAMPO)
		
		// Faz tratamento do dado
		IF SX3->X3_TIPO == "C"
			xValor := PadR(xValor,SX3->X3_TAMANHO)
		ELSEIF SX3->X3_TIPO == "N"
			xValor := Val(xValor)
		ELSEIF SX3->X3_TIPO == "D"
			xValor := Stod(xValor)
		ENDIF 
		
		if cCmpX3 == "A1_XCODSOE"  
			cCodId:= xValor
		endif 		

		aAdd( aCab, {Alltrim(SX3->X3_CAMPO),xValor, NIL } )
	ENDIF
	SX3->(dbSkip())
Enddo

IF Len(aCab) == 0  
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "Os campos do xml não foram localizados no dicionário de dados."+CRLF
	CCA08RXML(cFunXml,cDescXml,aMsgCab)
	Return
ELSE 
	aMsgCab[1]:= STRTRAN(cCodId,"*","_")	
	DBSELECTAREA("SA1")
	DbOrderNickName("CODCLISOE")
	IF DBSEEK(XFILIAL("SA1")+cCodId)   
		nOpcXml:= 4
	ENDIF
ENDIF

Begin Transaction
	
	MSExecAuto( { | x, y | Mata030( x, y ) }, aCab, nOpcXml )
	
	If lMsErroAuto
		
		If (__lSX8)
			RollBackSX8()
		EndIf     
		
		aMsgCab[2]:= "1"
		aMsgCab[3]+= U_CESBTRA(GetAutoGRLog())	
		DisarmTransaction()
		CCA08RXML(cFunXml,cDescXml,aMsgCab)
		
	Else		
		If (__lSX8)
			ConfirmSX8()
		EndIf
		          
		aMsgCab[3]+= IIF(nOpcXml==3,"Cliente incluido com sucesso","Cliente atualizado com sucesso")
		CCA08RXML(cFunXml,cDescXml,aMsgCab)		
	EndIf
End Transaction

RETURN 
/*------------------------------------------------------------------------
*
* CCA08RXML()
* Monta xml de retorno 
*
------------------------------------------------------------------------*/
static function CCA08RXML(cFunXml,cDescXml,aMsgCab)
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