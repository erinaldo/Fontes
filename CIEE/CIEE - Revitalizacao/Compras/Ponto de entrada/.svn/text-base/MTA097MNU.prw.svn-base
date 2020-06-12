#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MTA097MNU
Ponto de entrada para adicionar novas opções no array aRotina de liberação de documentos
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	aRotAux Array com opções do menu 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION MTA097MNU()
LOCAL aRotAux	:= {} 
LOCAL nCnt		:= 0

FOR nCnt:=1 TO LEN(aRotina)
	IF UPPER(TRIM(aRotina[nCnt][2])) == "A097VISUAL"
		AADD(aRotAux, {"Consulta Docto"	, 	'U_CCOME16(2)'  ,0, 2})	
	ELSEIF UPPER(TRIM(aRotina[nCnt][2])) == "A097LIBERA"
		AADD(aRotAux, {"Liberar"	 		, 	'U_CCOME16(3)'  ,0, 2})	
	ELSEIF UPPER(TRIM(aRotina[nCnt][2])) == "A097ESTORNA"
		AADD(aRotAux, {"Estornar"	 	, 	'U_CCOME16(4)'  ,0, 2})	
	ELSE  
		AADD(aRotAux,aRotina[nCnt])
	ENDIF
NEXT nCnt

aRotina:= ACLONE(aRotAux)
RETURN aRotAux