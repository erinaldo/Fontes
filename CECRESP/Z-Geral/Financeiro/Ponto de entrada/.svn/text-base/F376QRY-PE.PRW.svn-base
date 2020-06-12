#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'                  
//-----------------------------------------------------------------------
/*/{Protheus.doc} F376QRY()

Ponto de entrada na rotina FINA376, F0100601
Permite complementar a query na seleção dos titulos a aglutinar
Disponivel a variável cQuery, contendo a query atual:
"SELECT R_E_C_N_O_ RECNO FROM " + RetSQLname("SE2")

@param		Nenhum
@return		Expressão complementando a query
@author 	Zema
@since 		25/07/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
User Function F376QRY
Local cQry := "" 
	IF TYPE("cQuery") <> "U"
	    IF !EMPTY(cQuery)
			cQry := U_ASFINA63()  // Exibe tela MarkBrowse para seleção dos registrose  retorna o complemento da query
		ENDIF
	ENDIF
Return(cQry)