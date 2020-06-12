#Include 'totvs.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CESBENV
Função resposável pelo retorno do xml
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
user function CESBENV(cFuncCode,cDescription,cXml) 
local oFWEAI

If !EMPTY(cFuncCode) .and. !EMPTY(cDescription) .and. !EMPTY(cXml)
	oFWEAI:= FWEAI():New()
	oFWEAI:SetFuncCode( cFuncCode )
	oFWEAI:SetFuncDescription( cDescription )
	oFWEAI:SetDocType("2") 		// 1= Sincrono | 2= Assincrono
	oFWEAI:AddLayout( cFuncCode , "1.0", cFuncCode , cXml  )
	oFWEAI:SetTypeMessage( "11" )
	oFWEAI:SetSendChannel("1") // 1= ESB | 2= EAI
	oFWEAI:Activate()
	
	If !oFWEAI:Save()
		If InTransaction()
	   		DisarmTransaction()
	   	EndIf
	EndIf
else
	conout("Envio não realizado..")	                                                                
EndIf

return 
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CESBTRA
Tratamento da mensagem de erro do EAI
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CESBTRA(aBlocoMsg)
Local lHelp   := .F.
Local lTabela := .F.
Local lLinInv := .F.
Local lLinItem:= .F.
Local cLinha  := ""
Local aRet    := {}
Local cRet    := ""
Local nI      := 0

For nI := 1 to LEN( aBlocoMsg)
	cLinha  := UPPER( aBlocoMsg[nI] )    
	cLinha  := STRTRAN( cLinha,CHR(13), " " )
	cLinha  := STRTRAN( cLinha,CHR(10), " " )  
	
	lHelp   	:= .F.
	lTabela 	:= .F.
	lLinInv	:= .F.
	lLinItem	:= .F.
		
	If SUBS( cLinha, 1, 4 ) == 'HELP'
		lHelp := .T.
	EndIf
	
	If SUBS( cLinha, 1, 6 ) == 'TABELA'
		lTabela := .T.
	EndIf

	If '< -- INVALIDO'$cLinha
		cLinha:= StrTran(cLinha,'< -- INVALIDO','( INVALIDO )')
		lLinInv	:= .T.
	EndIf          
	
	If 'ERRO NO ITEM'$cLinha
		lLinItem:= .T.
	EndIf
		
	If  lHelp .or. lTabela .or. lLinInv .or. lLinItem
		
		If '<'$cLinha
			cLinha:= StrTran(cLinha,'<','(')
		EndIf

		If '>'$cLinha
			cLinha:= StrTran(cLinha,'>',')')
		EndIf			
			
		aAdd(aRet,cLinha)
	EndIf                   
Next

For nI := 1 to Len(aRet)
	cRet += aRet[nI]+CRLF
Next

Return cRet 

/*
Local lHelp   := .F.
Local lTabela := .F.
Local cLinha  := ""
Local aAux		:= {}
Local cRet    := ""
Local nI      := 0

For nI := 1 to LEN( aBlocoMsg)
	cLinha  := UPPER( aBlocoMsg[nI] )
	cLinha  := STRTRAN( cLinha,CHR(13), " " )
	cLinha  := STRTRAN( cLinha,CHR(10), " " )
	
	If SUBS( cLinha, 1, 4 ) == 'HELP'
		lHelp := .T.
	EndIf
	
	If SUBS( cLinha, 1, 6 ) == 'TABELA'
		lHelp   := .F.
		lTabela := .T.
	EndIf
	
	If  lHelp .or. ( lTabela .AND. '< -- INVALIDO' $  cLinha )
		aAdd(aAux,  StrTran(cLinha,'< -- INVALIDO','( INVALIDO )') )
	EndIf
	
Next

For nI := 1 to Len(aAux)
	cRet += aAux[nI]+CRLF
Next

Return cRet 
*/