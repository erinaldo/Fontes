#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CEAIA04
Solicitacao de compras camada Web
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CEAIA04(cXml)
Local nOpcXml  	:= ""  
Local cError   	:= ""
Local cWarning 	:= ""
Local cDelimit 	:= "_"
local cFunXml		:= "CEAIA04"
local cDescXml 	:= "Integracao Fluig x Protheus - Solicit. de compras"
local aMsgCab		:= {"","0",""}
Local xValor   	:= ""
Local cCmpX3   	:= ""
LOCAL aStru		:= {}
LOCAL aLinha		:= {}
LOCAL aItens		:= {}
LOCAL aBlocoMsg	:= {}
Local cCodForm	:= ""
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
		
	RETURN CCA04RXML(cFunXml,cDescXml,aMsgCab)
endif 

// Valida se o xml é de requisicao de materiais
if Type('oXml:_'+cFunXml+':_ZA1MASTER') == "U" 
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "XML - Estrutura do xml não pertence a rotina "+cFunXml+"|"+CRLF
	RETURN CCA04RXML(cFunXml,cDescXml,aMsgCab)
endif    

nOpcXml := Val(&('oXml:_'+cFunXml+':_OPERATION:TEXT'))

SX3->(dbSetOrder(1))
SX3->(dbGoTop())
SX3->(dbSeek("ZA1"))

// Carrega vetor com os campos
While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == "ZA1"

	cCmpX3 := Alltrim(SX3->X3_CAMPO)		
	
	IF SX3->X3_CONTEXT == "V" .OR. cCmpX3$"ZA1_ITEM,ZA1_DESCR,ZA1_QUANT,ZA1_UM" 
		SX3->(dbSkip())
		Loop
	ENDIF

	IF Type("oXml:_"+cFunXml+":_ZA1MASTER:_"+Alltrim(SX3->X3_CAMPO)+":REALNAME") <> "U"
		// Carrega conteudo do variavel
		xValor := &("oXml:_"+cFunXml+":_ZA1MASTER:_"+Alltrim(SX3->X3_CAMPO)+":TEXT")
				
		// Faz tratamento do dado
		IF SX3->X3_TIPO == "C"
			xValor := PadR(xValor,SX3->X3_TAMANHO)
		ELSEIF SX3->X3_TIPO == "N"
			xValor := Val(xValor)
		ELSEIF SX3->X3_TIPO == "D"
			xValor := ctod(xValor)
		ENDIF
		
		IF cCmpX3 == "ZA1_COD"
			xValor		:= STRZERO(VAL(xValor),6)
			cCodForm	:= xValor			
		Endif			
		
		aAdd( aStru, {cCmpX3,xValor, NIL } )
	ENDIF
	SX3->(dbSkip())
Enddo

aMsgCab[1]:= cCodForm

nTotIt := IIF(Type("oXml:_"+cFunXml+":_ZA1MASTER:_ZA1DETAIL:_ITEM") == "A",Len(&("oXml:_"+cFunXml+":_ZA1MASTER:_ZA1DETAIL:_ITEM")),1)

For nCnta := 1 to nTotIt
	
	aLinha:= {}
	
	SX3->(dbSetOrder(1))
	SX3->(dbGoTop())
	SX3->(dbSeek("ZA1"))
	While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == "ZA1"
		
		cCmpX3 := Alltrim(SX3->X3_CAMPO)
		
		IF SX3->X3_CONTEXT == "V" .OR. !cCmpX3$"ZA1_ITEM,ZA1_DESCR,ZA1_QUANT,ZA1_UM" 
			SX3->(dbSkip())
			Loop
		ENDIF		
					
		IF Type("oXml:_"+cFunXml+":_ZA1MASTER:_ZA1DETAIL:_ITEM"+IIF(nTotIt>1,"["+Alltrim(Str(nCnta))+"]:",":")+"_"+Alltrim(SX3->X3_CAMPO)+":REALNAME") <> "U"
			
			xValor := &("oXml:_"+cFunXml+":_ZA1MASTER:_ZA1DETAIL:_ITEM"+IIF(nTotIt>1,"["+Alltrim(Str(nCnta))+"]:",":")+"_"+Alltrim(SX3->X3_CAMPO)+":TEXT")
			
			// Faz tratamento do dado
			IF SX3->X3_TIPO == "C"
				xValor := PadR(xValor,SX3->X3_TAMANHO)
			ELSEIF SX3->X3_TIPO == "N"
				xValor := Val(xValor)
			ELSEIF SX3->X3_TIPO == "D"
				xValor := ctod(xValor)
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
	aMsgCab[3]+= "Nenhum campo localizado no dicionario de dados."+CRLF
	RETURN CCA04RXML(cFunXml,cDescXml,aMsgCab)
ELSE
	IF nOpcXml != 3
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "Apenas operacao de incluir é permitido por esta rotina(OPERATION igual a 3)."+CRLF
		RETURN CCA04RXML(cFunXml,cDescXml,aMsgCab)
	ENDIF 	
	
	dbselectarea("ZA1")
	DBSETORDER(1)
	IF DBseek(xfilial("ZA1")+cCodForm)
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "Já existe uma solicitalcao para o código: "+cCodForm+"."+CRLF
		RETURN CCA04RXML(cFunXml,cDescXml,aMsgCab)
	ENDIF 			
ENDIF

BEGIN TRANSACTION
	For nCnta:=1 to len(aItens)
		RecLock("ZA1",.T.)
		ZA1->ZA1_FILIAL   := xFilial("ZA1")
		For nCntb:=1 to len(aStru)
			REPLACE &(aStru[nCntb][1]) WITH aStru[nCntb][2]  
		Next nCntb
		For nCntb:=1 to len(aItens[nCnta])
			REPLACE &(aItens[nCnta][nCntb][1]) WITH aItens[nCnta][nCntb][2]  
		Next nCntb	
		ZA1->ZA1_NOMSOL   := POSICIONE('ZAA',1,xFilial('ZAA')+ZA1->ZA1_MATRIC,'ZAA_NOME')		
		ZA1->ZA1_STATUS   := "1"
		MSUnLock()
	Next nCnta	
	
	// Gera alçadas de aprovação
	CCA04ALC(	ZA1->ZA1_MATRIC,;
				ZA1->ZA1_COD,;
				ZA1_APRO01,;
				ZA1_APRO02,;
				ZA1_APRO03,;
				ZA1_APRO04,;
				ZA1_APRO05)
	
END TRANSACTION	

aMsgCab[3]+= "Solicitacao de compras integrada com sucesso."+CRLF
	

RETURN CCA04RXML(cFunXml,cDescXml,aMsgCab)
/*------------------------------------------------------------------------
*
* CCA04RXML()
* Monta xml de retorno 
*
------------------------------------------------------------------------*/
static function CCA04RXML(cFunXml,cDescXml,aMsgCab)
local cData	:= Dtos(Date())
local cHora	:= Time()   
local nCnt		:= 0
local cXml		:= ""                         

cXml+= '<TOTVSIntegrator>'
cXml+= '	<DATA>'+cData+'</DATA>'
cXml+= '	<HORA>'+cHora+'</HORA>'
cXml+= '	<LOGMASTER modeltype="FIELDS">'
cXml+= '		<ID>'+aMsgCab[1]+'</ID>'
cXml+= '		<RETORNO>'+aMsgCab[2]+'</RETORNO>'	    	       
cXml+= '		<MOTIVO>'+aMsgCab[3]+'</MOTIVO>'
cXml+= '		<ANEXOID>'+CVALTOCHAR(FWGetIdParent("ZA1"))+'</ANEXOID>'+CRLF
cXml+= '	</LOGMASTER>'
cXml+= '	<GlobalDocumentFunctionCode>'+cFunXml+'</GlobalDocumentFunctionCode>'
cXml+= '	<GlobalDocumentFunctionDescription>'+cDescXml+'</GlobalDocumentFunctionDescription>'
cXml+= '</TOTVSIntegrator>'+CRLF

RETURN cXml
/*------------------------------------------------------------------------
*
* CCA04ALC()
* Monta alçadas de aprovação
*
------------------------------------------------------------------------*/
static function CCA04ALC(cMatSC,cNumSc,cAprov1,cAprov2,cAprov3,cAprov4,cAprov5)
LOCAL cTab		:= GetNextAlias()             
LOCAL cQry		:= ""
LOCAL nNivelH	:= 0
Local cMatAT	:= TRIM(GetMv("CI_MATTEC",.F.,"")) // Matricula da area técnica 
local nPrimeiro := 0

cQry+= "WITH ALCADAS(MATRICULA,NOME,CC,EMAIL,MATSUP)"+CRLF
cQry+= "AS("+CRLF
cQry+= "	SELECT	ZAA_MAT AS MATRICULA"+CRLF
cQry+= "			,ZAA_NOME AS NOME"+CRLF
cQry+= "			,ZAA_CC AS CC"+CRLF
cQry+= "			,ZAA_EMAIL AS EMAIL"+CRLF
cQry+= "			, ZAA_MATSUP AS MATSUP"+CRLF
cQry+= "	FROM ZAA010 ZAA1"+CRLF
cQry+= "	WHERE ZAA_FILIAL='"+XFILIAL("ZAA")+"'"+CRLF
cQry+= "		AND ZAA_MAT='"+cMatSC+"'"+CRLF
cQry+= "		AND ZAA1.D_E_L_E_T_=''"+CRLF
cQry+= "	UNION ALL"+CRLF
cQry+= "	SELECT	ZAA_MAT AS MATRICULA"+CRLF
cQry+= "			,ZAA_NOME AS NOME"+CRLF
cQry+= "			,ZAA_CC AS CC"+CRLF
cQry+= "			,ZAA_EMAIL AS EMAIL"+CRLF
cQry+= "			,ZAA_MATSUP AS MATSUP"+CRLF
cQry+= "	FROM ZAA010 ZAA2"+CRLF
cQry+= "	INNER JOIN ALCADAS ALC ON ZAA_FILIAL='"+XFILIAL("ZAA")+"' AND ZAA2.ZAA_MAT=ALC.MATSUP"+CRLF
cQry+= "	WHERE ZAA_FILIAL='"+XFILIAL("ZAA")+"'"+CRLF
cQry+= "		AND ZAA2.D_E_L_E_T_=''"+CRLF	
cQry+= ")"+CRLF
cQry+= "SELECT * FROM ALCADAS"+CRLF


TcQuery cQry NEW ALIAS (cTab)	                                                   
(cTab)->(dbSelectArea((cTab)))                    
(cTab)->(dbGoTop())                               	
WHILE (cTab)->(!EOF())
	nNivelH++
	
	DO CASE
		// Supervisor
		CASE nNivelH == 2 .and. cAprov1=="1"     
			
			nPrimeiro++
			Reclock("ZA2",.T.)
				ZA2->ZA2_FILIAL	:= XFILIAL("ZA2")
				ZA2->ZA2_NUMSC	:= cNumSc 
				ZA2->ZA2_TIPO		:= "2"
				ZA2->ZA2_CCUSTO	:= (cTab)->CC
				ZA2->ZA2_NOMAP	:= (cTab)->NOME 
				ZA2->ZA2_USER		:= (cTab)->MATRICULA
	    		IF nPrimeiro == 1
	    			ZA2->ZA2_STATUS	:= "1"
	    		Endif	
			Msunlock()
		
		// Gerência
		CASE nNivelH == 3 .and. cAprov2=="1"
			
			nPrimeiro++
			Reclock("ZA2",.T.)
				ZA2->ZA2_FILIAL	:= XFILIAL("ZA2")
				ZA2->ZA2_NUMSC	:= cNumSc 
				ZA2->ZA2_TIPO		:= "2"
				ZA2->ZA2_CCUSTO	:= (cTab)->CC
				ZA2->ZA2_NOMAP	:= (cTab)->NOME 
				ZA2->ZA2_USER		:= (cTab)->MATRICULA
	    		IF nPrimeiro == 1
	    			ZA2->ZA2_STATUS	:= "1"
	    		Endif	
			Msunlock()		
		
		// Superintendência
		CASE nNivelH == 4 .and. cAprov3=="1"
			
			nPrimeiro++
			Reclock("ZA2",.T.)
				ZA2->ZA2_FILIAL	:= XFILIAL("ZA2")
				ZA2->ZA2_NUMSC	:= cNumSc 
				ZA2->ZA2_TIPO		:= "2"
				ZA2->ZA2_CCUSTO	:= (cTab)->CC
				ZA2->ZA2_NOMAP	:= (cTab)->NOME 
				ZA2->ZA2_USER		:= (cTab)->MATRICULA
	    		IF nPrimeiro == 1
	    			ZA2->ZA2_STATUS	:= "1"
	    		Endif	
			Msunlock()	
	
		// Aprovação Presidência			
		CASE nNivelH == 5 .and. cAprov4=="1"
			
			nPrimeiro++
			Reclock("ZA2",.T.)
				ZA2->ZA2_FILIAL	:= XFILIAL("ZA2")
				ZA2->ZA2_NUMSC	:= cNumSc 
				ZA2->ZA2_TIPO		:= "2"
				ZA2->ZA2_CCUSTO	:= (cTab)->CC
				ZA2->ZA2_NOMAP	:= (cTab)->NOME 
				ZA2->ZA2_USER		:= (cTab)->MATRICULA
	    		IF nPrimeiro == 1
	    			ZA2->ZA2_STATUS	:= "1"
	    		Endif	
			Msunlock()				
			
	Endcase
	
(cTab)->(dbSkip())	
END 

// Aprovação Area Técnica
IF cAprov5 == "1" .and. !empty(cMatAT)
	DBSELECTAREA("ZAA")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("ZAA")+cMatAT)
		
		nPrimeiro++
		Reclock("ZA2",.T.)
			ZA2->ZA2_FILIAL	:= XFILIAL("ZA2")
			ZA2->ZA2_NUMSC	:= cNumSc 
			ZA2->ZA2_TIPO		:= "2"
			ZA2->ZA2_CCUSTO	:= ZAA->ZAA_CC
			ZA2->ZA2_NOMAP	:= ZAA->ZAA_NOME 
			ZA2->ZA2_USER		:= ZAA->ZAA_MAT
    		IF nPrimeiro == 1
    			ZA2->ZA2_STATUS	:= "1"
    		Endif	
		Msunlock()
					
	ENDIF
ENDIF

// Caso não tenha aprovação muda status para liberado
IF nPrimeiro == 0
	dbselectarea("ZA1")
	ZA1->( dbSetOrder(1) )
	ZA1->( dbgotop() )
	ZA1->( dbSeek( xFilial( "ZA1" ) + cNumSc ) )
	While ZA1->( !EOF() ) .And. xFilial( "ZA1" ) == ZA1->ZA1_FILIAL .And. cNumSc == ZA1->ZA1_COD
		RecLock( "ZA1", .F. )
		ZA1->ZA1_STATUS	:= "2"
		ZA1->( MsUnlock() )
	ZA1->( dbSkip() )
	End	
Endif

return 	    	