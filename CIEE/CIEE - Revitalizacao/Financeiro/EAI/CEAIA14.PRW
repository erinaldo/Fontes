#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CEAIA14
Integra็ใo de irregularidades cadastrais no SOE
@author     Totvs
@since     	01/08/2014
@version  	P.11      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Altera็๕es Realizadas desde a Estrutura็ใo Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CEAIA14(cXml)
local cError   	:= ""
local cWarning 	:= ""
local cDelimit 	:= "_"
local nOpcXml	:= 0 
local aCab		:= {}
local aItens	:= {} 
local cFunXml	:= "CEAIA14"
local cDescXml 	:= "Movimentacao da Folha de Pagamento"
local cTabMaster:= "ZA5" 
local cTabDetail:= "ZA6"
local aMsgCab	:= {"","0",""}
local aMsgItens := {}      
Private oXml
Default cXML   	:= "" 

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
		
	CCA14RXML(cFunXml,cDescXml,aMsgCab,aMsgItens)
	Return
endif

// Valida se o xml ้ da folha
if Type('oXml:_'+cFunXml+':_'+cTabMaster+'MASTER') == "U" .or. Type('oXml:_'+cFunXml+':_'+cTabMaster+'MASTER:_'+cTabDetail+'DETAIL') == "U"	
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "XML - Estrutura do xml nใo pertence a rotina "+cFunXml+CRLF
	CCA14RXML(cFunXml,cDescXml,aMsgCab,aMsgItens)
	Return
endif

nOpcXml := Val(&('oXml:_'+cFunXml+':_OPERATION:TEXT'))

if nOpcXml != 4 
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "OPERATION - A opera็ใo nใo pode ser diferente de 4 (Alterar)"+CRLF
	CCA14RXML(cFunXml,cDescXml,aMsgCab,aMsgItens)
	Return
endif

CCA14DIC(oXml,cFunXml,cTabMaster,cTabDetail,@aCab,@aItens,@aMsgCab,@aMsgItens) 

if aMsgCab[2]== "0" .and. ascan(aMsgItens,{|x| x[2]== "1" }) == 0
	CCA14GRV(cTabMaster,cTabDetail,aCab,aItens,nOpcXml,@aMsgCab,@aMsgItens) 
endif

// Monta xml de retorno
CCA14RXML(cFunXml,cDescXml,aMsgCab,aMsgItens)
	
Return  
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ CCA14DIC   บAutor  ณ Totvs	    	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega xml de acordo com o dicionario de dados            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static function CCA14DIC(oXml,cFunCab,cTabMaster,cTabDetail,aCab,aItens,aMsgCab,aMsgItens) 
local xValor    := nil
local cCmpX3	:= ""
local nTotItens	:= 0
local aItAux	:= {}  
local aNoCpo	:= {} 
local cCodId	:= ""
local cNumCGC	:= ""
local cCodEst	:= ""
local nCnta		:= 0
local lRet		:= .t.
      
dbselectarea("SX3")

SX3->(dbsetorder(1))
SX3->(dbGoTop())
SX3->(dbseek(cTabMaster))
While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == cTabMaster  
	
	if Type("oXml:_"+cFunCab+":_"+cTabMaster+"MASTER:_"+Alltrim(SX3->X3_CAMPO)+":REALNAME") <> "U"
		
		// Pega o conteudo da Tag
		xValor := &("oXml:_"+cFunCab+":_"+cTabMaster+"MASTER:_"+Alltrim(SX3->X3_CAMPO)+":_VALUE:TEXT")
		cCmpX3 := Alltrim(SX3->X3_CAMPO)
		
		// Transforma o valor de acordo com o diconario
		if SX3->X3_TIPO == "C"
			xValor := PadR(xValor,SX3->X3_TAMANHO)
		elseif SX3->X3_TIPO == "N"
			xValor := Val(xValor)
		elseif SX3->X3_TIPO == "D"
			xValor := Stod(xValor)
		endif
		
		if SX3->X3_CONTEXT == "V"
			Loop
			SX3->(dbSkip())
		endif
		
		if cCmpX3 == "ZA5_COD"  
			cCodId:= xValor
		endif 
		
		if cCmpX3 == "ZA5_CGC"  
			cNumCGC:= xValor
		endif 		    
		                  
		if empty(xValor) 
			if cCmpX3$"ZA5_FILIAL,ZA5_COD,ZA5_CGC"
				aadd(aNoCpo, cCmpX3+" (Campo obrigat๓rio nใo preenchido)"+CRLF )
			endif		
		else
			aAdd(aCab,{cCmpX3,xValor})
		endif		
	else     
		cCmpX3 := Alltrim(SX3->X3_CAMPO)
		if cCmpX3$"ZA5_FILIAL,ZA5_COD,ZA5_CGC"
			aadd(aNoCpo, cCmpX3+" (Campo obrigat๓rio nใo preenchido)"+CRLF )
		endif							
	endif

SX3->(dbSkip())
Enddo            

if !empty(aNoCpo)                       
	lRet:=.f.
	aMsgCab[1]:= cCodId
	aMsgCab[2]:= "1"
	aEval(aNoCpo,{|x| aMsgCab[3]+= x } )
endif  

if !empty(cNumCGC)
	dbselectarea("SA1")
	dbsetorder(3)
	if !dbseek(xfilial("SA1")+cNumCGC)                       
		lRet:=.f.
		aMsgCab[1]:= cCodId
		aMsgCab[2]:= "1"
		aMsgCab[3]:= "Cadastro de cliente nใo localizado para CNPJ/CPF :"+cNumCGC
	endif                             
endif

if lRet
	aMsgCab[1]:= cCodId
	 
	if Type("oXml:_"+cFunCab+":_"+cTabMaster+"MASTER:_"+cTabDetail+"DETAIL:_ITEMS:_ITEM") == "A"
		nTotItens:= Len(&("oXml:_"+cFunCab+":_"+cTabMaster+"MASTER:_"+cTabDetail+"DETAIL:_ITEMS:_ITEM"))
	endif	
	
	For nCnta := 1 to nTotItens
		
		cCodEst:= ""
		aadd(aMsgItens,{"","0",""})
		
		SX3->(dbsetorder(1))
		SX3->(dbGoTop())
		SX3->(dbseek(cTabDetail))
		While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == cTabDetail
			
			if Type("oXml:_"+cFunCab+":_"+cTabMaster+"MASTER:_"+cTabDetail+"DETAIL:_ITEMS:_ITEM"+Iif(nTotItens>1,"["+Alltrim(Str(nCnta))+"]:",":")+"_"+Alltrim(SX3->X3_CAMPO)+":REALNAME") <> "U"
				
				// Pega o conteudo da Tag
				xValor := &("oXml:_"+cFunCab+":_"+cTabMaster+"MASTER:_"+cTabDetail+"DETAIL:_ITEMS:_ITEM"+Iif(nTotItens>1,"["+Alltrim(Str(nCnta))+"]:",":")+"_"+Alltrim(SX3->X3_CAMPO)+":TEXT")
				cCmpX3 := Alltrim(SX3->X3_CAMPO)
				
				// Transforma o valor de acordo com o diconario
				if SX3->X3_TIPO == "C"
					xValor := PadR(xValor,SX3->X3_TAMANHO)
				elseif SX3->X3_TIPO == "N"
					xValor := Val(xValor)
				elseif SX3->X3_TIPO == "D"
					xValor := Stod(xValor)
				endif    
								
				if SX3->X3_CONTEXT == "V"
					SX3->(dbSkip())
					Loop
				endif   
				
				if cCmpX3 == "ZA6_CODEST"  
					cCodEst:= xValor
				endif				
				       				
				if empty(xValor) 
					if cCmpX3$"ZA6_CODEST,ZA6_IDIRRE,ZA6_CNAB"
						aadd(aNoCpo, cCmpX3+" (Campo obrigat๓rio nใo preenchido)"+CRLF )
					endif	
				else
					aAdd(aItAux,{cCmpX3,xValor})
				endif					
				
			else     
				cCmpX3 := Alltrim(SX3->X3_CAMPO)
				if cCmpX3$"ZA6_CODEST,ZA6_IDIRRE,ZA6_CNAB" .and. cCmpX3!="ZA6_COD"
					aadd(aNoCpo, cCmpX3+" (Campo obrigat๓rio nใo preenchido)"+CRLF )
				endif	
			endif
		
		SX3->(dbSkip())
		Enddo
		
		aMsgItens[nCnta][1]:= cCodEst 
		if !empty(aNoCpo)  
			aMsgItens[nCnta][2]:= "1"
			aEval(aNoCpo,{|x| aMsgItens[nCnta][3]+= x } ) 
			aNoCpo:={}
		endif		
		
		Aadd(aItens,aItAux)
		aItAux:={}
	Next
	
endif	

return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ CCA14GRV   บAutor  ณ Totvs	    	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Grava os dados            							      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static function CCA14GRV(cTabMaster,cTabDetail,aCab,aItens,nOpcXml,aMsgCab,aMsgItens)
local nCnta		:= 0
local nCntb		:= 0
local cIndex	:= ""
local cChave	:= "" 
local cCodId	:= "" 
local aIndex	:= {} 
local nPosEst	:= 0 
local nPosRet	:= 0
local lRet		:= .t. 

dbselectarea(cTabMaster)
(cTabMaster)->(dbsetorder(1)) 
                                            
cIndex:= (cTabMaster)->(INDEXKEY(1))     
aIndex:= strtokarr(cIndex,"+")  

For nCnta := 1 to Len(aIndex)
	if (nCntb:= ASCAN(aCab,{|x| trim(x[1])==trim(aIndex[nCnta]) })) > 0
		cChave+= aCab[nCntb][2]		        
		if trim(aIndex[nCnta]) == "ZA5_COD"   
			cCodId:= aCab[nCntb][2] 
		endif	
	endif                                                 
Next nCnta           

if (cTabMaster)->(dbseek(cChave))  
	
	if nOpcXml == 4		
		if (cTabMaster)->ZA5_ENCFOL == "S" 
			aMsgCab[1]:= cCodId
			aMsgCab[2]:= "1"
			aMsgCab[3]:= "A folha jแ possui movimenta็๕es e nใo poder ser atualizada."
			lRet:= .f.
		endif  						
	endif 

else
	
	if nOpcXml == 4
		
		aMsgCab[1]:= cCodId
		aMsgCab[2]:= "1"
		aMsgCab[3]:= "Registro de folha nใo localizado."
		lRet:= .f.
						
	endif
	
endif

if lRet
	Begin Transaction

		dbselectarea(cTabDetail)
		(cTabDetail)->(dbsetorder(1))  		                  
		For nCnta := 1 to Len(aItens) 
			if (nPosEst:=ascan(aItens[nCnta],{|x| TRIM(x[1])== "ZA6_CODEST" }) ) > 0
				lRet:= .T. 				
				IF !(cTabDetail)->(dbseek(XFILIAL(cTabDetail)+cCodId+aItens[nCnta][nPosEst][2]))
					if (nPosRet:=ascan(aMsgItens,{|x| TRIM(x[1])== aItens[nCnta][nPosEst][2] }) ) > 0 
						aMsgItens[nPosRet][2]:= "1"
						aMsgItens[nPosRet][3]:= "Estagiแrio nใo localizado."
						lRet:= .f. 					
					endif
				ENDIF
				
				if lRet 
					RecLock(cTabDetail,.F.) 
					if (nCntb:=ascan(aItens[nCnta],{|x| TRIM(x[1])=="ZA6_IDIRRE" }) ) > 0
						&(cTabDetail+"->"+aItens[nCnta][nCntb][1]) := aItens[nCnta][nCntb][2]							
					endif  
					if (nCntb:=ascan(aItens[nCnta],{|x| TRIM(x[1])=="ZA6_CNAB" }) ) > 0
						&(cTabDetail+"->"+aItens[nCnta][nCntb][1]) := aItens[nCnta][nCntb][2]	
					endif
					(cTabDetail)->(MSUNLOCK())					
				endif	                                                
			endif
		Next nCnta
		
	End Transaction
	
endif	                                                            
	
RETURN
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ CCA14RXML  บAutor  ณ Totvs	    	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Monta xml de retorno       							      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static function CCA14RXML(cFunXml,cDescXml,aMsgCab,aMsgItens)
local cData	:= Dtos(Date())
local cHora	:= Time()   
local nCnt	:= 0
local cXml	:= ""                         

cXml+= '<TOTVSIntegrator>'+CRLF
cXml+= '	<DATA>'+cData+'</DATA>'+CRLF
cXml+= '	<HORA>'+cHora+'</HORA>'+CRLF
cXml+= '	<LOGMASTER modeltype="FIELDS">'+CRLF
cXml+= '		<ID>'+aMsgCab[1]+'</ID>'+CRLF
cXml+= '		<RETORNO>'+aMsgCab[2]+'</RETORNO>'+CRLF
cXml+= '		<MOTIVO>'+aMsgCab[3]+'</MOTIVO>'+CRLF
cXml+= '		<LOGITEM modeltype="GRID">'+CRLF

for nCnt:= 1 to len(aMsgItens)
	cXml+= '		<items>'+CRLF
	cXml+= '			<item id="'+strzero(nCnt,3)+'">'+CRLF
	cXml+= '			<ID>'+aMsgItens[nCnt][1]+'</ID>'+CRLF
	cXml+= '			<RETORNO>'+aMsgItens[nCnt][2]+'</RETORNO>'+CRLF
	cXml+= '			<MOTIVO>'+aMsgItens[nCnt][3]+'</MOTIVO>	'+CRLF		  
	cXml+= '			</item>'+CRLF                                   				                                                                                  
	cXml+= '		</items>'+CRLF				
next	

cXml+= '		</LOGITEM>'+CRLF
cXml+= '	</LOGMASTER>'+CRLF
cXml+= '	<GlobalDocumentFunctionCode>'+cFunXml+'</GlobalDocumentFunctionCode>'+CRLF
cXml+= '	<GlobalDocumentFunctionDescription>'+cDescXml+'</GlobalDocumentFunctionDescription>'+CRLF
cXml+= '</TOTVSIntegrator>'+CRLF

// Envia xml para funcใo de retorno
u_CESBENV(cFunXml,cDescXml,cXml)

return