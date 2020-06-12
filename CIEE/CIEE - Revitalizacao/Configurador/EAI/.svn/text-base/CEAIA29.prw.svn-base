#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CEAIA29
Integração	Usuários RH - EAI
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CEAIA29(cXml)
Local nOpcXml  	:= ""  
Local cError   	:= ""
Local cWarning 	:= ""
Local cDelimit 	:= "_"
Local aItens		:= {}
Local aLinha		:= {}
Local nTotIt		:= 0 
Local nCnta		:= 0
Local nCntb		:= 0
local cFunXml		:= "CEAIA29"
local cDescXml 	:= "Usuários RH"
local aMsgCab		:= {"","0",""}
Local xValor   	:= ""
Local cCmpX3   	:= ""
Local cMatric		:= ""
Local cCGC			:= ""
Local nPosFil		:= 0
local aEmpFil		:= {"",""}
LOCAL aEmps		:= FWLoadSM0()
Default cXml   	:= ""

oXml := XmlParser(cXML, cDelimit, @cError, @cWarning)

if !(Empty(cError) .and. Empty(cWarning))
    
	if !Empty(cError)
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "XML - Erro na estrutura do xml|"+CRLF
    endif

	if !Empty(cWarning)    
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "XML - "+cWarning+"|"+CRLF	
	endif 
		
	CCA29RXML(cFunXml,cDescXml,aMsgCab)
	Return
endif 

// Valida se o xml é de clientes
if Type('oXml:_'+cFunXml+':_ZAAMASTER') == "U" 
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "XML - Estrutura do xml não pertence a rotina "+cFunXml+"|"+CRLF
	CCA29RXML(cFunXml,cDescXml,aMsgCab)
	Return
endif    

nOpcXml := Val(&('oXml:_'+cFunXml+':_OPERATION:TEXT'))
        
nTotIt := IIF(Type("oXml:_"+cFunXml+":_ZAAMASTER:_ITEMS:_ITEM") == "A",Len(&("oXml:_"+cFunXml+":_ZAAMASTER:_ITEMS:_ITEM")),1)
nTotIt	:= IIF(nTotIt>0,1,nTotIt) // Processa apenas uma linha de itens, mudança realizada devido a mudança no escopo

For nCnta := 1 to nTotIt
	
	aLinha:= {}
	
	SX3->(dbSetOrder(1))
	SX3->(dbGoTop())
	SX3->(dbSeek("ZAA"))
	
	// Carrega vetor com os campos
	While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == "ZAA"
	
		IF SX3->X3_CONTEXT == "V"
			SX3->(dbSkip())
			Loop
		ENDIF	
				
		IF Type("oXml:_"+cFunXml+":_ZAAMASTER:_ITEMS:_ITEM"+IIF(nTotIt>1,"["+Alltrim(Str(nCnta))+"]:",":")+"_"+Alltrim(SX3->X3_CAMPO)+":REALNAME") <> "U"
			
			xValor := &("oXml:_"+cFunXml+":_ZAAMASTER:_ITEMS:_ITEM"+IIF(nTotIt>1,"["+Alltrim(Str(nCnta))+"]:",":")+"_"+Alltrim(SX3->X3_CAMPO)+":_VALUE:TEXT")
			cCmpX3 := Alltrim(SX3->X3_CAMPO)			
			
			//-- Tratamento do dado 
			IF SX3->X3_TIPO == "C"
				xValor := PadR(xValor,SX3->X3_TAMANHO)
			ELSEIF SX3->X3_TIPO == "N"
				xValor := Val(xValor)
			ELSEIF SX3->X3_TIPO == "D"
				xValor := Stod(xValor)
			ENDIF        
			
			IF cCmpX3=="ZAA_MAT" 
				cMatric	:= ALLTRIM(xValor)
			ENDIF
			
			IF cCmpX3=="ZAA_CGC"
				cCGC	:= ALLTRIM(xValor)
			ENDIF
			
			aAdd(aLinha,{cCmpX3,xValor,NIL})			
			
		ENDIF
		SX3->(dbSkip())
	Enddo
		
	IF !EMPTY(aLinha)
		Aadd(aItens, aLinha )
	ENDIF
		
Next nCnta 

IF Len(aItens) == 0  
	aMsgCab[2]:= "1"
	aMsgCab[3]+= "Os campos do xml não foram localizados no dicionário de dados|"+CRLF
	CCA29RXML(cFunXml,cDescXml,aMsgCab)
	Return
ELSE

	IF EMPTY(cMatric)
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "Campo obrigatório não informado: Matricula|"+CRLF
		CCA29RXML(cFunXml,cDescXml,aMsgCab)
		Return 	
	ENDIF           
	
	IF EMPTY(cCGC)
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "Campo obrigatório não informado: CNPJ|"+CRLF
		CCA29RXML(cFunXml,cDescXml,aMsgCab)
		Return 	
	ENDIF  
	
	if (nPosFil:= ascan(aEmps,{|x| ALLTRIM(x[18])=cCGC })) > 0
		aEmpFil:= {aEmps[nPosFil][1],aEmps[nPosFil][2]}
	else
		aMsgCab[2]:= "1"
		aMsgCab[3]+= "CNPJ "+cCGC+" não localizado no cadastro de empresas|"+CRLF
		CCA29RXML(cFunXml,cDescXml,aMsgCab)
		Return 	
	Endif
	
	aMsgCab[1]:= cMatric
	
	IF nOpcXml == 3	
		DBSELECTAREA("ZAA")
		ZAA->(DBSETORDER(1))
		IF ZAA->(DBSEEK(XFILIAL("ZAA")+cMatric))
			aMsgCab[2]:= "1"
			aMsgCab[3]+= "Já existe um usuário para a matricula: "+cMatric+"|"+CRLF
			CCA29RXML(cFunXml,cDescXml,aMsgCab)
			Return   	
	   	ENDIF	
	ElseIf nOpcXml == 4 .or. nOpcXml == 5
		DBSELECTAREA("ZAA")
		ZAA->(DBSETORDER(1))
		IF !ZAA->(DBSEEK(XFILIAL("ZAA")+cMatric))
			aMsgCab[2]:= "1"
			aMsgCab[3]+= "Não existe um usuário cadastrado para a matricula: "+cMatric+"|"+CRLF
			CCA29RXML(cFunXml,cDescXml,aMsgCab)
			Return   	
	   	ENDIF		
	ENDIF
ENDIF

Begin Transaction
	
	For nCnta := 1 to Len(aItens)
		RecLock("ZAA",IIF(nOpcXml==3,.t.,.f.))
			IF nOpcXml == 5
				ZAA->(Dbdelete())
			else  
				ZAA->ZAA_FILIAL	:= XFILIAL("ZAA")
				ZAA->ZAA_EMP		:= aEmpFil[1]
				ZAA->ZAA_FIL		:= aEmpFil[2]
				For nCntb := 1 to Len(aItens[nCnta])			
					&("ZAA->"+aItens[nCnta][nCntb][1]) := aItens[nCnta][nCntb][2]
				Next nCntb 
			endif                        
		ZAA->(MSUNLOCK())	
	Next nCnta
	
	IF nOpcXml == 3
		
		aMsgCab[3]+= "Usuário "+TRIM(ZAA->ZAA_NOME)+" incluido com sucesso|"
		
		// Cria usuário no FLUIG
		aMsgCab[3]+= CCA29FLG(nOpcXml)
		
	ElseIF nOpcXml == 4
		
		aMsgCab[3]+= "Usuário "+TRIM(ZAA->ZAA_NOME)+" alterado com sucesso|"
		
		// Atualiza usuário no FLUIG
		aMsgCab[3]+= CCA29FLG(nOpcXml)
			
	ElseIF nOpcXml == 5
		
		aMsgCab[3]+= "Usuário "+TRIM(ZAA->ZAA_NOME)+" excluido com sucesso|"
		
		// Desativa usuário no FLUIG
		aMsgCab[3]+= CCA29FLG(nOpcXml)
		
	endif
	
	CCA29RXML(cFunXml,cDescXml,aMsgCab)	
		
End Transaction

RETURN 
/*------------------------------------------------------------------------
*
* CCA29RXML()
* Monta xml de retorno 
*
------------------------------------------------------------------------*/
static function CCA29RXML(cFunXml,cDescXml,aMsgCab)
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
/*------------------------------------------------------------------------
*
* CCA29FLG()
* Insere,atualiza e desativa usuários no FLUIG
*
------------------------------------------------------------------------*/       
static function CCA29FLG(nOpc)
LOCAL oObjWs		:= WSCIEE02():new()
local cMsg			:= ""
 
oObjWs:cusername		:= TRIM(GetMv("MV_ECMPUBL",.F.,""))
oObjWs:cpassword		:= TRIM(GetMv("MV_ECMPSW",.F.,"")) 
oObjWs:ncompanyId		:= VAL(GetMv("MV_ECMEMP",.F.,""))


IF nOpc == 3 .or. nOpc == 4

	AADD(oObjWs:oWScreateColleaguecolleagues:OWSITEM,WSClassNew('ECMColleagueServiceService_colleagueDto'))
	
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:lactive              := .T.
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:ladminUser           := .f.
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:narea1Id             := 0
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:narea2Id             := 0
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:narea3Id             := 0
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:narea4Id             := 0
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:narea5Id             := 0
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:ccolleagueId         := TRIM(ZAA->ZAA_MAT)  	// Matricula
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:ccolleagueName       := TRIM(ZAA->ZAA_NOME)		// Nome do usuário		
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:ccolleaguebackground := ""
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:ncompanyId           := 1							// Código da empresa
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:ccurrentProject      := ""
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:cdefaultLanguage     := "pt"
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:cdialectId           := "pt"
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:lemailHtml           := .t.
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:cespecializationArea := ""
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:cextensionNr         := "1234"
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:lgedUser             := .t.
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:cgroupId             := ""
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:lguestUser           := .f.
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:clogin               := TRIM(ZAA->ZAA_LGREDE)
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:cmail                := TRIM(ZAA->ZAA_EMAIL)
	
	if nOpc == 3
		oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:cpasswd           := TRIM(ZAA->ZAA_LGREDE) 
	endif	
	
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:csessionId           := ""
	oObjWs:oWScreateColleaguecolleagues:OWSITEM[1]:cvolumeId            := "Default"
	
	if nOpc == 3
		oObjWs:createColleague(oObjWs:cusername,oObjWs:cpassword,oObjWs:ncompanyId,oObjWs:oWScreateColleaguecolleagues)
		
		if trim(Upper(oObjWs:cresultXML)) == "OK"
			cMsg:= "Usuário "+TRIM(ZAA->ZAA_NOME)+" criado com sucesso"
		ElseIf "nok"$oObjWs:cresultXML			
			if TRIM(ZAA->ZAA_LGREDE)$oObjWs:cresultXML
				cMsg:= trim(strtran(oObjWs:cresultXML,"nok","Usuário "+TRIM(ZAA->ZAA_NOME)+" login de rede"))
			elseif TRIM(ZAA->ZAA_MAT)$oObjWs:cresultXML
				cMsg:= trim(strtran(oObjWs:cresultXML,"nok","Usuário "+TRIM(ZAA->ZAA_NOME)+" matricula"))	
			else
				cMsg:= trim(strtran(oObjWs:cresultXML,"nok","Usuário "+TRIM(ZAA->ZAA_NOME)))
			endif	
		Else	
			cMsg:= trim(oObjWs:cresultXML)
		endif
	Else
		oObjWs:getColleague(oObjWs:cusername,oObjWs:cpassword,oObjWs:ncompanyId,TRIM(ZAA->ZAA_MAT))
	
		IF oObjWs:oWSgetColleaguecolab:OWSITEM[1]:lactive	
			oObjWs:updateColleague(oObjWs:cusername,oObjWs:cpassword,oObjWs:ncompanyId,oObjWs:oWScreateColleaguecolleagues)
			
			if trim(upper(oObjWs:cresultXML)) == "OK"
				cMsg:= "Usuário "+TRIM(ZAA->ZAA_NOME)+" atualizado com sucesso"
			ElseIf "nok"$oObjWs:cresultXML
				if TRIM(ZAA->ZAA_LGREDE)$oObjWs:cresultXML
					cMsg:= trim(strtran(oObjWs:cresultXML,"nok","Usuário "+TRIM(ZAA->ZAA_NOME)+" login de rede"))
				elseif TRIM(ZAA->ZAA_MAT)$oObjWs:cresultXML
					cMsg:= trim(strtran(oObjWs:cresultXML,"nok","Usuário "+TRIM(ZAA->ZAA_NOME)+" matricula"))	
				else
					cMsg:= trim(strtran(oObjWs:cresultXML,"nok","Usuário "+TRIM(ZAA->ZAA_NOME)))
				endif	
			Else	
				cMsg:= trim(oObjWs:cresultXML)
			endif	
		else
			cMsg:= "Usuário "+TRIM(ZAA->ZAA_NOME)+" bloqueado para uso"			
		endif
	endif	

ElseIf nOpc == 5

	oObjWs:getColleague(oObjWs:cusername,oObjWs:cpassword,oObjWs:ncompanyId,TRIM(ZAA->ZAA_MAT))
	
	IF oObjWs:oWSgetColleaguecolab:OWSITEM[1]:lactive
		oObjWs:removeColleague(oObjWs:cusername,oObjWs:cpassword,oObjWs:ncompanyId,TRIM(ZAA->ZAA_MAT))
		if trim(upper(oObjWs:cresult)) == "OK"
			cMsg:= "Usuário "+TRIM(ZAA->ZAA_NOME)+", bloqueado com sucesso."
		ElseIf "nok"$oObjWs:cresult
			cMsg:= trim(strtran(oObjWs:cresult,"nok","Usuário "+TRIM(ZAA->ZAA_NOME)+","))
		Else	
			cMsg:= trim(oObjWs:cresult)
		endif	
	else	
		cMsg:= "Usuário "+TRIM(ZAA->ZAA_NOME)+" bloqueado para uso"
	Endif

endif	

return cMsg