#Include 'Protheus.ch'
/*---------------------------------------------------------------------------------------
{Protheus.doc} CEAIA09
Movimentação da Folha de Pagamento - EAI

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
USER FUNCTION CEAIA09(cXml) 
local cError   	:= ""
local cWarning 	:= ""
local cDelimit 	:= "_"
local nOpcXml	:= 0 
local aCab		:= {}
local aItens	:= {} 
local cFunXml	:= "CEAIA09"
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
		
	CCA09RXML(cFunXml,cDescXml,aMsgCab,aMsgItens)
	Return
endif

// Valida se o xml é da folha
if Type('oXml:_'+cFunXml+':_'+cTabMaster+'MASTER') == "U" .or. Type('oXml:_'+cFunXml+':_'+cTabMaster+'MASTER:_'+cTabDetail+'DETAIL') == "U"	
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "XML - Estrutura do xml não pertence a rotina "+cFunXml+CRLF
	CCA09RXML(cFunXml,cDescXml,aMsgCab,aMsgItens)
	Return
endif

nOpcXml := Val(&('oXml:_'+cFunXml+':_OPERATION:TEXT'))

CCA09DIC(oXml,cFunXml,cTabMaster,cTabDetail,@aCab,@aItens,@aMsgCab,@aMsgItens) 

if aMsgCab[2]== "0" .and. ascan(aMsgItens,{|x| x[2]== "1" }) == 0
	if nOpcXml ==  6
		CCA09GRV(cTabMaster,cTabDetail,aCab,aItens,nOpcXml,@aMsgCab,@aMsgItens) 
		
		if aMsgCab[2]== "0" .and. ascan(aMsgItens,{|x| x[2]== "1" }) == 0	
			CCA09GRV(cTabMaster,cTabDetail,aCab,aItens,3,@aMsgCab,@aMsgItens)
		endif	
	else
		CCA09GRV(cTabMaster,cTabDetail,aCab,aItens,nOpcXml,@aMsgCab,@aMsgItens)
	endif	
endif

// Monta xml de retorno
CCA09RXML(cFunXml,cDescXml,aMsgCab,aMsgItens)
	
Return   
/*------------------------------------------------------------------------
*
* CCA09DIC()
* Carrega xml de acordo com o dicionario de dados
*
------------------------------------------------------------------------*/
static function CCA09DIC(oXml,cFunCab,cTabMaster,cTabDetail,aCab,aItens,aMsgCab,aMsgItens) 
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
			if x3obrigat(cCmpX3) .or. cCmpX3$"ZA5_FILIAL,ZA5_COD,ZA5_CGC"
				aadd(aNoCpo, cCmpX3+" (Campo obrigatório não preenchido)"+CRLF )
			endif		
		else
			aAdd(aCab,{cCmpX3,xValor})
		endif					
	else 	    
		cCmpX3 := Alltrim(SX3->X3_CAMPO)
		if x3obrigat(cCmpX3) .or. cCmpX3$"ZA5_FILIAL,ZA5_COD,ZA5_CGC"
			aadd(aNoCpo, cCmpX3+" (Campo obrigatório não preenchido)"+CRLF )
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
		aMsgCab[3]:= "Cadastro de cliente não localizado para CNPJ/CPF :"+cNumCGC
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
					if x3obrigat(cCmpX3) .or. cCmpX3=="ZA6_CODEST"
						aadd(aNoCpo, cCmpX3+" (Campo obrigatório não preenchido)"+CRLF )
					endif	
				else
					aAdd(aItAux,{cCmpX3,xValor})
				endif					
			else 	    
				cCmpX3 := Alltrim(SX3->X3_CAMPO)
				if x3obrigat(cCmpX3) .or. cCmpX3=="ZA6_CODEST"
					aadd(aNoCpo, cCmpX3+" (Campo obrigatório não preenchido)"+CRLF )
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
/*------------------------------------------------------------------------
*
* CCA09GRV()
* Grava os dados 
*
------------------------------------------------------------------------*/
static function CCA09GRV(cTabMaster,cTabDetail,aCab,aItens,nOpcXml,aMsgCab,aMsgItens)
local nCnta		:= 0
local nCntb		:= 0
local cFilAux	:= ""    
local lRec		:= nOpcXml==3
local lDel		:= nOpcXml==5 .or. nOpcXml==6
local cIndex	:= ""
local cChave	:= "" 
local cCodId	:= "" 
local aIndex	:= {} 
local nPosEst	:= 0 
local nPosRet	:= 0
local lRet		:= .t.
local cCodInt	:= ""

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
	
	if nOpcXml == 3
		
		aMsgCab[1]:= cCodId
		aMsgCab[2]:= "1"
		aMsgCab[3]:= "Já existe uma folha com o mesmo código."
		lRet:= .f. 
		
	elseif nOpcXml == 4
		
		if (cTabMaster)->ZA5_ENCFOL == "S" 
			aMsgCab[1]:= cCodId
			aMsgCab[2]:= "1"
			aMsgCab[3]:= "A folha já possui movimentações e não poder ser atualizada."
			lRet:= .f.
		endif
		
	elseif nOpcXml == 5 .or. nOpcXml==6
		
		if (cTabMaster)->ZA5_ENCFOL == "S" .or. CCA09VMOV(cCodId) 
			aMsgCab[1]:= cCodId
			aMsgCab[2]:= "1"
			aMsgCab[3]:= "A folha já possui movimentações e não poder ser "+ iif(nOpcXml==5,"excluida.","substituida.")
			lRet:= .f.
		endif     
						
	endif 

else

	if nOpcXml == 3
		
		cCodInt:= GETSXENUM("ZA5","ZA5_CODINT")
		ConfirmSX8() 
		
	elseif nOpcXml == 4
		
		aMsgCab[1]:= cCodId
		aMsgCab[2]:= "1"
		aMsgCab[3]:= "Registro de folha não localizado."
		lRet:= .f.
		
	elseif nOpcXml == 5 .or. nOpcXml==6
		
		aMsgCab[1]:= cCodId
		aMsgCab[2]:= "1"
		aMsgCab[3]:= "Registro de folha não localizado."
		lRet:= .f.
						
	endif
	
endif

if lRet
	Begin Transaction
	
		RecLock(cTabMaster,lRec) 
		if lDel
			(cTabMaster)->(DBDELETE())
		else		
			For nCnta := 1 to Len(aCab)			
				&(cTabMaster+"->"+aCab[nCnta][1]) := aCab[nCnta][2]
			Next nCnta  
			
			if nOpcXml == 3
				(cTabMaster)->ZA5_CODINT:= cCodInt
			endif	
		endif	                               
		(cTabMaster)->(MSUNLOCK())
		
		dbselectarea(cTabDetail)
		(cTabDetail)->(dbsetorder(1))  
		
		if lDel                    
			lRec:= .f.
			(cTabDetail)->(dbseek(XFILIAL(cTabDetail)+cCodId))
			while (cTabDetail)->(!eof()) .and. (cTabDetail)->(ZA6_FILIAL+ZA6_COD)==XFILIAL(cTabDetail)+cCodId
				RecLock(cTabDetail,lRec)
				(cTabDetail)->(DBDELETE())
				(cTabDetail)->(MSUNLOCK())
			(cTabDetail)->(dbskip()) 
			end
		else                           
			For nCnta := 1 to Len(aItens) 
				if (nPosEst:=ascan(aItens[nCnta],{|x| TRIM(x[1])== "ZA6_CODEST" }) ) > 0
					lRet:= .T. 			
					lRec:= !(cTabDetail)->(dbseek(XFILIAL(cTabDetail)+cCodId+aItens[nCnta][nPosEst][2]))
									
					IF !lRec
						// Verifica se ja possui movimentação
						if !empty((cTabDetail)->ZA6_CNAB) .OR. !empty((cTabDetail)->ZA6_CODEXT) 						
							if (nPosRet:=ascan(aMsgItens,{|x| TRIM(x[1])== aItens[nCnta][nPosEst][2] }) ) > 0 
								aMsgItens[nPosRet][2]:= "1"
								aMsgItens[nPosRet][3]:= "O estagiário já teve movimentações e não poder ser atualizado."
								lRet:= .f.                                                                                  
							endif
						endif
					ENDIF
					
					if lRet
						RecLock(cTabDetail,lRec)  
						(cTabDetail)->ZA6_FILIAL := xfilial(cTabDetail) 
						(cTabDetail)->ZA6_COD	 := cCodId
						For nCntb := 1 to Len(aItens[nCnta])
							&(cTabDetail+"->"+aItens[nCnta][nCntb][1]) := aItens[nCnta][nCntb][2]
						Next  		
						(cTabDetail)->(MSUNLOCK())	
					endif	                                                
				endif
			Next nCnta
		endif 
		
	End Transaction
endif	                                                            
	
RETURN
/*------------------------------------------------------------------------
*
* CCA09RXML()
* Monta xml de retorno 
*
------------------------------------------------------------------------*/
static function CCA09RXML(cFunXml,cDescXml,aMsgCab,aMsgItens)
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

// Envia xml para funcão de retorno
u_CESBENV(cFunXml,cDescXml,cXml)

return
/*------------------------------------------------------------------------
*
* CCA09VMOV()
* Verifica movimentação da folha 
*
------------------------------------------------------------------------*/
static function CCA09VMOV(cCodFol)
local cTabFol:= GetNextAlias()
local lRet:= .f.

BeginSQL Alias cTabFol
	SELECT count(*) AS TOTAL FROM %Table:ZA6% ZA6	
	WHERE ZA6_FILIAL = %xFilial:ZA6% 
		AND ZA6_FILIAL = %xFilial:ZA6% 
		AND ZA6_COD = %Exp:cCodFol%
		AND (ZA6_CNAB!='' OR ZA6_CODEXT!='')
		AND ZA6.D_E_L_E_T_ = ''
EndSQL

dbselectarea(cTabFol)                                                   	
if (cTabFol)->(!EOF())
	lRet:= (cTabFol)->TOTAL > 0
endif      

(cTabFol)->(dbCloseArea())

return lRet