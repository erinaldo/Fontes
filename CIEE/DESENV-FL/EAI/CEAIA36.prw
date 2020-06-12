#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CEAIA36
Rotina de integração FL e FLI
@author  	Carlos Henrique
@since     	28/04/2017
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CEAIA36(cXml)
Local nOpcXml  	:= ""
Local cError   	:= ""
Local cWarning 	:= ""
Local cDelimit 	:= "_"
local cFunXml		:= "CEAIA36"
local cTab			:= "ZAG"
local cDescXml 	:= "Integração FL"
local aMsgCab		:= {"","0",""}
Local xValor   	:= ""
Local cCmpX3   	:= ""
Local cCodPro   	:= ""
LOCAL aStru		:= {}
Local aItens		:= {}
Local aLinha		:= {}
Local nTotItens	:= 0 
Local nCnta		:= 0
Local nCntb		:= 0
Local nCntc		:= 0
Default cXml   	:= ""

oXml := XmlParser(FwNoAccent(cXML), cDelimit, @cError, @cWarning)

if !(Empty(cError) .and. Empty(cWarning))
	
	if !Empty(cError)
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "XML - Erro na estrutura do xml"+CRLF
	endif
	
	if !Empty(cWarning)
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "XML - "+cWarning+"|"+CRLF
	endif
	
	RETURN CCCGAXML(cFunXml,cDescXml,aMsgCab)
endif

nOpcXml := Val(&('oXml:_'+cFunXml+':_OPERATION:TEXT'))

// Valida o xml
if Type('oXml:_'+cFunXml+':_'+cTab+'MASTER') == "U"
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "XML - Estrutura do xml não pertence a rotina "+cFunXml+"|"+CRLF
	RETURN CCCGAXML(cFunXml,cDescXml,aMsgCab)
endif

SX3->(dbSetOrder(1))
SX3->(dbGoTop())
SX3->(dbSeek(cTab))

// Carrega os campos do cabeçalho
While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == cTab
	
	IF SX3->X3_CONTEXT == "V"
		SX3->(dbSkip())
		Loop
	ENDIF
	
	cCmpX3 := Alltrim(SX3->X3_CAMPO)
	
	IF Type("oXml:_"+cFunXml+":_"+cTab+"MASTER:_"+cCmpX3+":REALNAME") <> "U"
		// Carrega conteudo do variavel
		xValor := &("oXml:_"+cFunXml+":_"+cTab+"MASTER:_"+cCmpX3+":TEXT")
		
		// Faz tratamento do dado
		IF SX3->X3_TIPO == "C"
			xValor := PadR(xValor,SX3->X3_TAMANHO)
		ELSEIF SX3->X3_TIPO == "N"
			xValor := Val(xValor)
		ELSEIF SX3->X3_TIPO == "D"
			xValor := Stod(xValor)
		ENDIF
		
		// Guarda código do processo
		IF cCmpX3 == "ZAG_CODIGO"
			cCodPro:= xValor
		ENDIF		
		
		aAdd( aStru, {cCmpX3,xValor, NIL } )
		
	elseif "_FILIAL"$cCmpX3
		aAdd( aStru, {cCmpX3,XFILIAL(cTab),NIL})
	ENDIF
	SX3->(dbSkip())
Enddo

// Carrega os campos dos itens
nTotItens := IIF(Type("oXml:_"+cFunXml+":_"+cTab+"MASTER:_"+cTab+"DETAIL:_ITEM") == "A",Len(&("oXml:_"+cFunXml+":_"+cTab+"MASTER:_"+cTab+"DETAIL:_ITEM")),1)

For nCnta:= 1 to nTotItens	

	aLinha:= {}
	
	SX3->(dbSetOrder(1))
	SX3->(dbGoTop())
	SX3->(dbSeek(cTab))
	While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == cTab
	
		IF SX3->X3_CONTEXT == "V"
			SX3->(dbSkip())
			Loop
		ENDIF			
		
		IF Type("oXml:_"+cFunXml+":_"+cTab+"MASTER:_"+cTab+"DETAIL:_ITEM"+IIF(nTotItens>1,"["+Alltrim(Str(nCnta))+"]:",":")+"_"+Alltrim(SX3->X3_CAMPO)+":REALNAME") <> "U"
			
			xValor := &("oXml:_"+cFunXml+":_"+cTab+"MASTER:_"+cTab+"DETAIL:_ITEM"+IIF(nTotItens>1,"["+Alltrim(Str(nCnta))+"]:",":")+"_"+Alltrim(SX3->X3_CAMPO)+":TEXT")
			cCmpX3 := Alltrim(SX3->X3_CAMPO)			
			
			//Tratamento para campo com conteudo NULL
			IF UPPER(xValor)== "NULL"
				xValor:= ""
			ENDIF
			
			//-- Tratamento do dado 
			IF SX3->X3_TIPO == "C"
				//Retira o ponto de campos tipo float
				IF VAL(xValor) > 0 .AND. "."$xValor
					xValor:= SUBSTR(xValor,1,AT(".",xValor)-1)
				Endif
				xValor := PadR(xValor,SX3->X3_TAMANHO)
			ELSEIF SX3->X3_TIPO == "N"			
				xValor := Val(xValor)
			ELSEIF SX3->X3_TIPO == "D"
				xValor := CTOD(SUBSTR(xValor,9,2) +"/"+ SUBSTR(xValor,6,2) +"/"+ SUBSTR(xValor,1,4))  
			ENDIF  
			
			aAdd(aLinha,{cCmpX3,xValor,NIL})			
			
		ENDIF
		SX3->(dbSkip())
	Enddo	
	
	Aadd(aItens, aLinha )

Next nCnta 

// Nenhum campo localizado
IF Len(aStru) == 0 .or. len(aItens) == 0
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "Nenhum campo localizado no SX3"+CRLF
	RETURN CCCGAXML(cFunXml,cDescXml,aMsgCab)
ENDIF

dbSelectArea(cTab)
(cTab)->(dbsetorder(1))
IF !((cTab)->(dbseek(xfilial()+cCodPro)))
	Begin Transaction
	For nCnta := 1 to Len(aItens)
		RecLock(cTab,.T.)
		//Grava cabeçalho
		For nCntb := 1 to Len(aStru)
			&(cTab+"->"+aStru[nCntb][1]) := aStru[nCntb][2]
		Next nCntb
		//Grava itens
		For nCntc := 1 to Len(aItens[nCnta])
			&(cTab+"->"+aItens[nCnta][nCntc][1]) := aItens[nCnta][nCntc][2]
		Next nCntc		
		(cTab)->(MSUNLOCK())
	Next nCnta
	End Transaction
	aMsgCab[3]+= "Processo integrado com sucesso."+CRLF
ELSE
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "Já existe um processo com código: "+cCodPro+CRLF
ENDIF

RETURN CCCGAXML(cFunXml,cDescXml,aMsgCab)
/*------------------------------------------------------------------------
*
* CCCGAXML()
* Monta xml de retorno
*
------------------------------------------------------------------------*/
static function CCCGAXML(cFunXml,cDescXml,aMsgCab)
Local cData	:= Dtos(Date())
Local cHora	:= Time()
Local nCnt	:= 0
Local cXml	:= ""

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