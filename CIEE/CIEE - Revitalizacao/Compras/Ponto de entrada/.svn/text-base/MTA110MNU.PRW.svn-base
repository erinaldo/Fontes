#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MTA110MNU
Insere novas opções no array aRotina - Solicitacao de compras 
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION MTA110MNU()
LOCAL aRotAux	:= {} 
LOCAL nCnt		:= 0

FOR nCnt:=1 TO LEN(aRotina)
	IF UPPER(TRIM(aRotina[nCnt][2])) == "A110APROV"
		AADD(aRotAux,{"Sol. Aprovação" , "U_CCOME01" ,0,7}) 
	ELSEIF UPPER(TRIM(aRotina[nCnt][2])) == "MSDOCUMENT"	
		AADD(aRotAux,{"Conhecimento" , "U_CCOME04('SC1')" ,0,10}) 		
	ELSE
		AADD(aRotAux,aRotina[nCnt])
	ENDIF
NEXT nCnt

AADD(aRotAux,{"Comp. Responsavel" , "U_CCOME02" ,0,8})
AADD(aRotAux,{"Cons. Aprovação"   , "U_CCOME03" ,0,9})

aRotina:= ACLONE(aRotAux)

RETURN 