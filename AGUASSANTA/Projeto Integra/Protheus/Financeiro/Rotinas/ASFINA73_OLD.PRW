#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA73()
Utilizado para alterar o MV_PAR03 para não contabilizar online quando for
titulo de aluguel.
 
@param		cTitE1E2
@return		
@author 	Fabiano Albuquerque
@since 		28/12/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA73()

Local cEmpAlug := GetMV("AS_EMPALUG")

IF cFilAnt $ cEmpAlug
	MV_PAR03 := 2
EndIF

Return