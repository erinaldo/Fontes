#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CORIGA02
Integração	de medição de contratos ambiente ORIGINAL - pedido de compras
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
//TODO - Retirar após segunda fase do projeto, apenas para atender a integração com ambiente ORIGINAL
User Function CORIGA02(cXml)
Local nOpcXml  	:= ""  
Local cError   	:= ""
Local cWarning 	:= ""
Local cDelimit 	:= "_"
local cFunXml		:= "CORIGA02"
local cDescXml 	:= "Integração de contratos - pedido de compras"
local aMsgCab		:= {"","0",""}
Local xValor   	:= ""
Local cCmpX3   	:= ""
LOCAL aCab			:= {}
LOCAL aItens		:= {}
LOCAL aLinha		:= {}
LOCAL aBlocoMsg	:= {}
local cChave		:= ""
local cContra		:= ""
LOCAL nTotIt		:= 0
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
		
	cXmlRet:= CORI02XML(cFunXml,cDescXml,aMsgCab)
	RETURN cXmlRet
endif 

// Valida se o xml é de clientes
if Type('oXml:_'+cFunXml+':_SC7MASTER') == "U" 
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "XML - Estrutura do xml não pertence a rotina "+cFunXml+"|"+CRLF
	cXmlRet:= CORI02XML(cFunXml,cDescXml,aMsgCab)
	RETURN cXmlRet
endif    

nOpcXml := Val(&('oXml:_'+cFunXml+':_OPERATION:TEXT'))

IF nOpcXml == 3
	cChave:= CriaVar("C7_NUM",.T.)
ELSE
	cChave:= &("oXml:_"+cFunXml+":_SC7MASTER:_C7_XNPCORI:_VALUE:TEXT")
Endif

cContra:= &("oXml:_"+cFunXml+":_SC7MASTER:_C7_CONTRA:_VALUE:TEXT")
aMsgCab[1]:= cChave

aCab   :={		{"C7_NUM"     , cChave					            								,Nil},; // Numero do Pedido
			  	{"C7_FILIAL"  , Xfilial("SC7") 		      											,Nil},; // Filial do Pedido de Compra
             	{"C7_EMISSAO" , dDataBase                  										,Nil},; // Tipo de pedido
         		{"C7_FORNECE" , &("oXml:_"+cFunXml+":_SC7MASTER:_C7_FORNECE:_VALUE:TEXT")		,Nil},; // Codigo do cliente
         		{"C7_LOJA"    , &("oXml:_"+cFunXml+":_SC7MASTER:_C7_LOJA:_VALUE:TEXT")		,Nil},; // Loja do cliente  
         		{"C7_CONTATO" , &("oXml:_"+cFunXml+":_SC7MASTER:_C7_CONTATO:_VALUE:TEXT")		,Nil},; // Contato
         		{"C7_COND"    , &("oXml:_"+cFunXml+":_SC7MASTER:_C7_COND:_VALUE:TEXT")		,Nil},; // Condição de Pagamento
         		{"C7_FILENT"  , Xfilial("SC7")														,Nil}}  // Filial Entrega 


nTotIt := IIF(Type("oXml:_"+cFunXml+":_SC7MASTER:_SC7DETAIL:_ITEMS:_ITEM") == "A",Len(oXml:_CORIGA02:_SC7MASTER:_SC7DETAIL:_ITEMS:_ITEM),1)

For nCnt := 1 to nTotIt
	
	aLinha:= {}
	
	SX3->(dbSetOrder(1))
	SX3->(dbGoTop())
	SX3->(dbSeek("SC7"))
	While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == "SC7"
	
		IF SX3->X3_CONTEXT == "V"
			SX3->(dbSkip())
			Loop
		ENDIF	
	
		If Alltrim(SX3->X3_CAMPO)=='C7_ITEM'
			Aadd(aLinha,{"C7_ITEM"	,StrZero(nCnt,Len(SC6->C6_ITEM)),NIL} )
			SX3->(dbSkip())
			Loop
		EndIf                                		
		
		IF Type("oXml:_"+cFunXml+":_SC7MASTER:_SC7DETAIL:_ITEMS:_ITEM"+IIF(nTotIt>1,"["+Alltrim(Str(nCnt))+"]:",":")+"_"+Alltrim(SX3->X3_CAMPO)+":REALNAME") <> "U"
			
			xValor := &("oXml:_"+cFunXml+":_SC7MASTER:_SC7DETAIL:_ITEMS:_ITEM"+IIF(nTotIt>1,"["+Alltrim(Str(nCnt))+"]:",":")+"_"+Alltrim(SX3->X3_CAMPO)+":_VALUE:TEXT")
			cCmpX3 := Alltrim(SX3->X3_CAMPO)			
			
			//-- Tratamento do dado 
			IF SX3->X3_TIPO == "C"
				xValor := PadR(xValor,SX3->X3_TAMANHO)
			ELSEIF SX3->X3_TIPO == "N"			
				xValor := Val(xValor)
			ELSEIF SX3->X3_TIPO == "D"
				xValor := Stod(xValor)
			ENDIF  
			
			aAdd(aLinha,{cCmpX3,xValor,NIL})			
			
		ENDIF
		SX3->(dbSkip())
	Enddo	
	
	Aadd(aItens, aLinha )
Next nCnt 


// Nenhum campo localizado
IF Len(aItens) == 0
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "Nenhum campo localizado|"+CRLF
	cXmlRet:= CORI02XML(cFunXml,cDescXml,aMsgCab)
	RETURN cXmlRet
ELSEIF nOpcXml != 3
	dbselectarea("SC7")
	DBSETORDER(1)
	IF !DBseek(xfilial("SC7")+cChave)
		aMsgCab[3]+= "Pedido de compra não encontrado no ambiente original."+CRLF
		cXmlRet:= CCA03XML(cFunXml,cDescXml,aMsgCab)
		RETURN cXmlRet	
	ENDIF 	
ENDIF

Begin Transaction

	MSExecAuto( {|v,x,y,z,w| MATA120(v,x,y,z,w)}, 1, aCab, aItens, nOpcXml, .F. )
	
	If lMsErroAuto
		If (__lSX8)
			RollBackSX8()
		EndIf
		DisarmTransaction()
		
		aMsgCab[2]:= "1"
		aMsgCab[3]+= U_CESBTRA(GetAutoGRLog())	
		cXmlRet:= CORI02XML(cFunXml,cDescXml,aMsgCab)
	Else
		If (__lSX8)
			ConfirmSX8()
		EndIf
				
		dbSelectArea("SC7")
		SC7->(dbgotop())		
		IF SC7->(dbseek(xFilial("SC7")+cChave))
			While SC7->(!Eof()) .and. SC7->(C7_FILIAL+C7_NUM) == xFilial("SC7")+cChave
				RECLOCK("SC7",.F.)
					SC7->C7_CONTRA:= cContra 
				MSUNLOCK()
			SC7->(dbSkip())
			Enddo	
		Endif
		
		aMsgCab[3]+= "Pedido de compra integrado com sucesso."+CRLF
		cXmlRet:= CORI02XML(cFunXml,cDescXml,aMsgCab)	
		
	EndIf
End Transaction
        

RETURN cXmlRet 
/*------------------------------------------------------------------------
*
* CORI02XML()
* Monta xml de retorno 
*
------------------------------------------------------------------------*/
static function CORI02XML(cFunXml,cDescXml,aMsgCab)
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