#INCLUDE "TOTVS.CH"

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CEAIA34
Rotina de Integração FFQ
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CEAIA34(cXml)
Local nOpcXml   	:= ""  
Local cError   	:= ""
Local cWarning 	:= ""
Local cDelimit 	:= "_"
Local aCab	     	:= {}
local cFunXml		:= "CEAIA34"
local cDescXml 	:= "Integração FFQ"
local aMsgCab		:= {"","0",""}
Local xValor   	:= ""
Local cCmpX3   	:= ""
Local cChave   	:= ""
LOCAL aCmpXml		:= {"A2_CGC","A2_NOME","E2_CCD","E2_NUM","E2_VALOR","E2_XCTKM","E2_XVLRKM","E2_XCTTX","E2_XVLRTX","E2_XCTRF","E2_XVLRRF","E2_XCTEST","E2_XVLEST","E2_XCDPED","E2_XVRPED"}
local nCnta		:= 0
Local cNat999 	:= SuperGetMV("CI_NAT999",.T.,"99999999",)
Local cNumCPF		:= "" 
Local cNomeFav	:= ""
Local cCCFav		:= ""
Local cNumTit		:= ""
Local nValor		:= 0
Local cContKM		:= ""
Local nValKM		:= 0
Local cContTaxi	:= ""
Local nValTaxi	:= 0
Local cContRef	:= ""
Local nValRef		:= 0
Local cContEst	:= ""
Local nValEst		:= 0
Local cContPed	:= ""
Local nValPed		:= 0
Local cCodFor 	:= ""
Local cLojFor 	:= ""
Local cBcoFav 	:= ""
Local cAgFav 		:= ""
Local cDAgFav 	:= ""
Local cContaFav	:= ""
Private lMsErroAuto		:= .F.
Private lAutoErrNoFile	:= .T.
Default cXml   			:= ""  

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
		
	CCA34XML(cFunXml,cDescXml,aMsgCab)
	Return
endif 

// Valida se o xml é de clientes
if Type('oXml:_'+cFunXml+':_SE2MASTER') == "U" 
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "XML - Estrutura do xml não pertence a rotina "+cFunXml+CRLF
	CCA34XML(cFunXml,cDescXml,aMsgCab)
	Return
endif    

nOpcXml := Val(&('oXml:_'+cFunXml+':_OPERATION:TEXT'))
 

FOR nCnta:= 1 TO LEN(aCmpXml)
	xValor:= Nil
	IF CCA34VAL(oXml,cFunXml,aCmpXml[nCnta],@xValor)
		DO CASE
			CASE aCmpXml[nCnta] == "A2_CGC"
				cNumCPF:= xValor
			CASE aCmpXml[nCnta] == "A2_NOME"
				cNomeFav:= xValor
			CASE aCmpXml[nCnta] == "E2_CCD"
				cCCFav:= xValor
			CASE aCmpXml[nCnta] == "E2_NUM"
				cNumTit:= xValor
				aMsgCab[1]	:= cNumTit
			CASE aCmpXml[nCnta] == "E2_VALOR"			
				nValor:= xValor						
			CASE aCmpXml[nCnta] == "E2_XCTKM"
				cContKM:= xValor			
			CASE aCmpXml[nCnta] == "E2_XVLRKM"
				nValKM:= xValor			
			CASE aCmpXml[nCnta] == "E2_XCTTX"
				cContTaxi:= xValor			
			CASE aCmpXml[nCnta] == "E2_XVLRTX"
				nValTaxi:= xValor			
			CASE aCmpXml[nCnta] == "E2_XCTRF"
				cContRef:= xValor			
			CASE aCmpXml[nCnta] == "E2_XVLRRF"
				nValRef:= xValor			
			CASE aCmpXml[nCnta] == "E2_XCTEST"
				cContEst:= xValor			
			CASE aCmpXml[nCnta] == "E2_XVLEST"
				nValEst:= xValor			
			CASE aCmpXml[nCnta] == "E2_XCDPED"
				cContPed:= xValor			
			CASE aCmpXml[nCnta] == "E2_XVRPED"			
				nValPed:=	xValor			
		ENDCASE	
	Else
		aMsgCab[3]+= "Campo obrigatório não preenchido: " + aCmpXml[nCnta] + CRLF
	Endif
Next nCnta 

IF !EMPTY(aMsgCab[3])
	aMsgCab[2]:= "1"
	CCA34XML(cFunXml,cDescXml,aMsgCab)	
	RETURN
ENDIF

nValor 	:= Val(nValor)/100
nValKM  	:= Val(nValKM)/100
nValTaxi	:= Val(nValTaxi)/100
nValRef	:= Val(nValRef)/100
nValEst	:= Val(nValEst)/100
nValPed	:= Val(nValPed)/100		

DbSelectArea("SA2")
DbSetOrder(3)
If DbSeek(xFilial("SA2")+Alltrim(cNumCPF),.F.)
	cCodFor := SA2->A2_COD
	cLojFor := SA2->A2_LOJA
Else
	aMsgCab[2]:= "1"
	aMsgCab[3]+= cNumCPF+"|"+cNomeFav+"|Nao Cadastrado no Sistema"
	CCA34XML(cFunXml,cDescXml,aMsgCab)	
	RETURN
EndIf

//Verifica se o registro ja foi importado
DbSelectArea("SE2")
DbSetOrder(1)
If DbSeek(xFilial("SE2")+"FFQ"+cNumTit+" "+"FFQ"+cCodFor+cLojFor,.F.)
	aMsgCab[2]:= "1"
	aMsgCab[3]+= cNumCPF+"|"+cNomeFav+"|"+cNumTit+"|Já existe um registro importado|"
	CCA34XML(cFunXml,cDescXml,aMsgCab)	
	RETURN
EndIf

//Conta Corrente
DbSelectArea("SZK") 
DbSetOrder(5)
If DbSeek(xFilial("SZK")+cCodFor+cLojFor)
	Do While SZK->ZK_FORNECE+SZK->ZK_LOJA == cCodFor+cLojFor
		Do Case
			Case SZK->ZK_STATUS == "A" .and. SZK->ZK_TIPO == "1" 	//Conta Corrente
				cBcoFav 	:= SZK->ZK_BANCO
				cAgFav 	:= SZK->ZK_AGENCIA
				cDAgFav 	:= SZK->ZK_DVAG
				cContaFav	:= SZK->ZK_NUMCON 	// CONTA CORRENTE
			Case SZK->ZK_STATUS == "A" .and. SZK->ZK_TIPO == "2" 	//CONTA POUPANCA
				cBcoFav 	:= SZK->ZK_BANCO
				cAgFav 	:= SZK->ZK_AGENCIA
				cDAgFav 	:= SZK->ZK_DVAG
				cContaFav:= SZK->ZK_NROPOP 		// CONTA POUPANCA
			Case SZK->ZK_STATUS == "A" .and. SZK->ZK_TIPO == "3" 	// Conta Cartao
				cBcoFav 	:= SZK->ZK_BANCO
				cAgFav 	:= SZK->ZK_AGENCIA
				cDAgFav 	:= SZK->ZK_DVAG
				cContaFav	:= SZK->ZK_NROCRT 	// CONTA CARTAO
		EndCase
	SZK->(DbSkip())
	EndDo
EndIf
 
aCab := {		{"E2_PREFIXO", 'FFQ' 	   			, NIL},; //FIXO
				{"E2_NUM"    , cNumTit				, NIL},; //Numero do Relatorio
				{"E2_PARCELA", ' '					, NIL},; //FIXO
				{"E2_TIPO"   , 'FFQ'					, NIL},; //FIXO
				{"E2_HIST"   , 'REEMB DE FFQ'		, NIL},; //FIXO
				{"E2_NATUREZ", cNat999    			, NIL},;
				{"E2_FORNECE", cCodFor				, NIL},; 
				{"E2_LOJA"   , cLojFor				, NIL},;
				{"E2_RED_CRE", '1180211'				, NIL},; //FIXO
				{"E2_EMISSAO", dDataBase				, NIL},;
				{"E2_VENCTO" , dDataBase+1			, NIL},; 
				{"E2_RATEIO" , 'S'					, NIL},; //FIXO
				{"E2_VALOR"  , nValor				, NIL},;
				{"E2_BANCO"  , cBcoFav				, NIL},;
				{"E2_AGEFOR" , cAgFav				, NIL},;
				{"E2_DVFOR"  , cDAgFav				, NIL},;
				{"E2_DATALIB", dDATABASE				, NIL},;
				{"E2_USUALIB", SUBS(CUSUARIO,7,15)	, NIL},;
				{"E2_CTAFOR" , cContaFav				, NIL}}

Begin Transaction
	
	MsExecAuto({|x,y,z| FINA050(x,y,z)},aCab,,nOpcXml)
	
	If lMsErroAuto		
		
		aMsgCab[2]:= "1"
		aMsgCab[3]+= U_CESBTRA(GetAutoGRLog())	
		DisarmTransaction()
		CCA34XML(cFunXml,cDescXml,aMsgCab)
		
	Else		
		aMsgCab[3]+= "Titulo gerado com sucesso"
		CCA34XML(cFunXml,cDescXml,aMsgCab)		
	EndIf
	
End Transaction

RETURN 
/*------------------------------------------------------------------------
*
* CCA34VAL()
* Verifica preenchimento de campo e tratamento de valores  
*
------------------------------------------------------------------------*/
static function CCA34VAL(oXml,cFunXml,cCampo,xValor)
Local lret		:= .t.
Local cCmpObr	:= "A2_CGC,E2_NUM,E2_VALOR" 

IF Type("oXml:_"+cFunXml+":_SE2MASTER:_"+cCampo+":REALNAME") <> "U"
	// Carrega conteudo do variavel
	xValor := &("oXml:_"+cFunXml+":_SE2MASTER:_"+cCampo+":_VALUE:TEXT")
	
	// Faz tratamento do dado
	IF SX3->X3_TIPO == "C"
		xValor := Alltrim(xValor)
	ELSEIF SX3->X3_TIPO == "N"
		xValor := Val(xValor)
	ELSEIF SX3->X3_TIPO == "D"
		xValor := Stod(xValor)
	ENDIF
	
	If empty(xValor) .and. cCampo$cCmpObr
		lret:= .f.
	Endif
Else
	lret:= .f.	
ENDIF	 

return lret
/*------------------------------------------------------------------------
*
* CCA34XML()
* Monta xml de retorno 
*
------------------------------------------------------------------------*/
static function CCA34XML(cFunXml,cDescXml,aMsgCab)
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