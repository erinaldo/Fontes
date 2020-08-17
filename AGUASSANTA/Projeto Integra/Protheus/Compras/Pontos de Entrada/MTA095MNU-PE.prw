#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MTA095MNU()

Ponto de entrada utilizado para inserir novas opcoes no array aRotina

@param		Nenhum 
@return		Nenhum
@author 	Fabio Cazarini
@since 		17/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MTA095MNU()
Local aRot := {}

IF TYPE("PARAMIXB") == "A"
	aRot := PARAMIXB[1]
	aRot := U_ASCOMA05(aRot)
	RETURN(aRot)
ELSEIF TYPE("aRotina") == "A"
 	aRot := ACLONE(aRotina)
 	aRot := U_ASCOMA05(aRot)
 	aRotina := ACLONE(aRot) 	
 	RETURN
ENDIF
RETURN