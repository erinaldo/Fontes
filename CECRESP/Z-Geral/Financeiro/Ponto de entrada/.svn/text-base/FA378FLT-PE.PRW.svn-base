#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'                  
//-----------------------------------------------------------------------
/*/{Protheus.doc} FA378FLT()

Ponto de entrada na rotina FINA378, F0100603
Permite complementar a query na seleção dos titulos a aglutinar
Disponivel a variável cQuery
@param		Nenhum
@return		Expressão complementando a query
@author 	Zema
@since 		25/07/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
User Function FA378FLT
Local cQry := "" 
	IF TYPE("cQuery") <> "U"
	    IF !EMPTY(cQuery)
	    	IF "RECSE5"$cQuery // Pela Baixa
	    		cQry := U_ASFINA65()  // Exibe tela MarkBrowse para seleção dos registrose  retorna o complemento da query
	    	ELSEIF "RECSE2"$cQuery // Pela Emissao
	    		cQry := U_ASFINA66()  // Exibe tela MarkBrowse para seleção dos registrose  retorna o complemento da query	    	
	    	ENDIF	
		ENDIF
	ENDIF
Return(cQry)
