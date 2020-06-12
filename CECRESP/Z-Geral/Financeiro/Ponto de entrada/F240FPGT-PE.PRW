#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F240FPGT()

Montagem de filtro

O ponto de entrada F240FPGT sera utilizado para montar o filtro para 
complementar a Query na rotina de geração automática de borderô - F0100301 
@param		Nenhum
@return		cRet	=	Expressão caracter com o filtro desejado.
@author 	Zema
@since 		31/03/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F240FPGT()

Local cQuery	:= ""

Local cTermo	:= ""

Local cFiltro	:= ""


IF IsInCallStack("U_F0100301")

	cQuery 	:= PARAMIXB[1]
	    
	cTermo  := "SE2.E2_FILORIG LIKE '" + AllTrim(FwXFilial("SE2"))+"%'"
	
//	cTermo 	:= "SE2.E2_FILIAL = '" + FwXFilial("SE2") + "'"

//	cFiltro := "((SE2.E2_XSFLUIG IN ('N', 'A', ' ') AND SE2.E2_XBCOFIL = '" + FWXFilial("SE2") + "') OR (SE2.E2_XBCOFIL = '"+Space(TAMSX3("E2_XBCOFIL")[1]) + "' AND SE2.E2_FILORIG = '" + FWXFilial("SE2") + "')) "
	cFiltro := "(SE2.E2_XSFLUIG IN('N', 'A', ' ') AND (SUBSTRING(SE2.E2_XBCOFIL,1,"+ALLTRIM(STR(LEN(ALLTRIM(FWXFilial("SE2")))))+") = '" + ALLTRIM(FWXFilial("SE2")) + "' OR (SE2.E2_XBCOFIL = '"+Space(TAMSX3("E2_XBCOFIL")[1]) + "' AND SUBSTRING(SE2.E2_FILORIG,1,"+ALLTRIM(STR(LEN(ALLTRIM(FWXFilial("SE2")))))+") = '" + ALLTRIM(FWXFilial("SE2")) + "'))) "
//	cFiltro := "(SE2.E2_XSFLUIG IN ('N', 'A', ' ') AND ( SE2.E2_XBCOFIL = '" + cFilAnt + "' OR SE2.E2_XBCOFIL = '"+Space(TAMSX3("E2_XBCOFIL")[1]) + "' ))"

	
	cQuery := StrTran(cQuery,  cTermo , cFiltro)

//	MEMOWRITE("Q_"+alltrim(CFILANT)+".TXT",cQuery)	
	
EndIf         



Return cQuery