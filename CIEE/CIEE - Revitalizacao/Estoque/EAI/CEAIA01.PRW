#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CEAIA01
Rotina de integração requisição de materiais
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CEAIA01(cXml)
Local nOpcXml  	:= ""  
Local cError   	:= ""
Local cWarning 	:= ""
Local cDelimit 	:= "_"
local cFunXml		:= "CEAIA01"
local cDescXml 	:= "Requisição de materiais"
local aMsgCab		:= {"","0",""}
Local xValor   	:= ""
Local cCmpX3   	:= ""
Local cXmlRet   	:= ""
LOCAL aStru		:= {}
LOCAL aLinha		:= {}
LOCAL aItens		:= {}
LOCAL aBlocoMsg	:= {}
local cNumReq		:= ""
local cCodReq		:= ""
local cLocali		:= ""
local cKitLan		:= ""
local nCnta		:= 0
local nCntb		:= 0
Default cXml   	:= ""
	
oXml := XmlParser(EncodeUTF8(cXML), cDelimit, @cError, @cWarning)

if !(Empty(cError) .and. Empty(cWarning))
    
	if !Empty(cError)
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "XML - Erro na estrutura do xml"+CRLF
    endif

	if !Empty(cWarning)    
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "XML - "+cWarning+"|"+CRLF	
	endif 
		
	CCA01RXML(cFunXml,cDescXml,aMsgCab)
	RETURN
endif 

// Valida se o xml é de requisicao de materiais
if Type('oXml:_'+cFunXml+':_SZNMASTER') == "U" 
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "XML - Estrutura do xml não pertence a rotina "+cFunXml+"|"+CRLF
	CCA01RXML(cFunXml,cDescXml,aMsgCab)
	RETURN
endif    

nOpcXml := Val(&('oXml:_'+cFunXml+':_OPERATION:TEXT'))

SX3->(dbSetOrder(1))
SX3->(dbGoTop())
SX3->(dbSeek("SZN"))

// Carrega vetor com os campos
While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == "SZN"

	cCmpX3 := Alltrim(SX3->X3_CAMPO)		
	
	IF SX3->X3_CONTEXT == "V" .OR. cCmpX3$"ZN_COD,ZN_DESCR,ZN_UM,ZN_QUANT,ZN_SALDO" 
		SX3->(dbSkip())
		Loop
	ENDIF

	IF Type("oXml:_"+cFunXml+":_SZNMASTER:_"+Alltrim(SX3->X3_CAMPO)+":REALNAME") <> "U"
		// Carrega conteudo do variavel
		xValor := &("oXml:_"+cFunXml+":_SZNMASTER:_"+Alltrim(SX3->X3_CAMPO)+":_VALUE:TEXT")
				
		// Faz tratamento do dado
		IF SX3->X3_TIPO == "C"
			xValor := PadR(xValor,SX3->X3_TAMANHO)
		ELSEIF SX3->X3_TIPO == "N"
			xValor := Val(xValor)
		ELSEIF SX3->X3_TIPO == "D"
			xValor := Stod(xValor)
		ENDIF
		
		IF cCmpX3 == "ZN_NUMSOC"
			cNumReq:= xValor			
		Endif	

		IF cCmpX3 == "ZN_COD"			
			cCodReq:= xValor
		Endif

		IF cCmpX3 == "ZN_CR"			
			dbSelectArea("CTT")
			dbSetOrder(1)
			If DbSeek(xFilial("CTT")+xValor)
				Do Case
					Case CTT->CTT_LOCALI == "1"
						cLocali := "SEDE"
					Case CTT->CTT_LOCALI == "2"
						cLocali := "UNIDADE"
					Case CTT->CTT_LOCALI == "3"
						cLocali := "NAO GERA"
				EndCase
	
				Do Case
					Case CTT->CTT_KITLAN == "1"
						cKitLan := "CR01"
					Case CTT->CTT_KITLAN == "2"
						cKitLan := "CR02"
				EndCase
			EndIf		
		Endif
		
		aAdd( aStru, {cCmpX3,xValor, NIL } )
	ENDIF
	SX3->(dbSkip())
Enddo

if Empty(cNumReq)
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "ZN_NUMSOC (Campo obrigatório não preenchido)" +CRLF
	CCA01RXML(cFunXml,cDescXml,aMsgCab)
	RETURN
Endif

aMsgCab[1]:= cNumReq

nTotIt := IIF(Type("oXml:_"+cFunXml+":_SZNMASTER:_ITEMS:_ITEM") == "A",Len(&("oXml:_"+cFunXml+":_SZNMASTER:_ITEMS:_ITEM")),1)

For nCnta := 1 to nTotIt
	
	aLinha:= {}
	
	SX3->(dbSetOrder(1))
	SX3->(dbGoTop())
	SX3->(dbSeek("SZN"))
	While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == "SZN"
		
		cCmpX3 := Alltrim(SX3->X3_CAMPO)
		
		IF SX3->X3_CONTEXT == "V" .OR. !cCmpX3$"ZN_COD,ZN_DESCR,ZN_UM,ZN_QUANT,ZN_SALDO" 
			SX3->(dbSkip())
			Loop
		ENDIF		
		
		IF Type("oXml:_"+cFunXml+":_SZNMASTER:_ITEMS:_ITEM"+IIF(nTotIt>1,"["+Alltrim(Str(nCnta))+"]:",":")+"_"+Alltrim(SX3->X3_CAMPO)+":REALNAME") <> "U"
			
			xValor := &("oXml:_"+cFunXml+":_SZNMASTER:_ITEMS:_ITEM"+IIF(nTotIt>1,"["+Alltrim(Str(nCnta))+"]:",":")+"_"+Alltrim(SX3->X3_CAMPO)+":_VALUE:TEXT")
			
			// Faz tratamento do dado
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
Next nCnta 


// Nenhum campo localizado
IF Len(aStru) == 0 .or. Len(aItens) == 0
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "Nenhum campo localizado"+CRLF
	CCA01RXML(cFunXml,cDescXml,aMsgCab)
	RETURN
ELSE
	IF nOpcXml != 3
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "Apenas operação de incluir é permitido por esta rotina(OPERATION igual a 3)."+CRLF
		CCA01RXML(cFunXml,cDescXml,aMsgCab)
		RETURN
	ENDIF 	
	
	dbselectarea("SZN")
	DBSETORDER(1)
	IF DBseek(xfilial("SZN")+cNumReq+cCodReq)
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "Já existe uma requisição com o código: "+cNumReq+"-"+cCodReq+"."+CRLF
		CCA01RXML(cFunXml,cDescXml,aMsgCab)
		RETURN
	ENDIF 	
		
ENDIF

BEGIN TRANSACTION
	For nCnta:=1 to len(aItens)
		RecLock("SZN",.T.)
		SZN->ZN_FILIAL   := xFilial("SZN")
		For nCntb:=1 to len(aStru)
			REPLACE &(aStru[nCntb][1]) WITH aStru[nCntb][2]  
		Next nCntb
		For nCntb:=1 to len(aItens[nCnta])
			REPLACE &(aItens[nCnta][nCntb][1]) WITH aItens[nCnta][nCntb][2]  
		Next nCntb	
		MSUnLock()
	Next nCnta	
END TRANSACTION	

aMsgCab[3]+= "Requisição de material integrada com sucesso."+CRLF
CCA01RXML(cFunXml,cDescXml,aMsgCab)	

RETURN 
/*------------------------------------------------------------------------
*
* CCA01RXML()
* Monta xml de retorno 
*
------------------------------------------------------------------------*/
static function CCA01RXML(cFunXml,cDescXml,aMsgCab)
local cData	:= Dtos(Date())
local cHora	:= Time()   
local nCnt		:= 0
local cXml		:= ""                         

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