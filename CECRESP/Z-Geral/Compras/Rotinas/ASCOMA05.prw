#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA05()

Insere novas opcoes no array aRotina do MATA095 - Cadastro de aprovadores
Chamado pelo PE MTA095MNU

@param		Nenhum 
@return		Nenhum
@author 	Fabio Cazarini
@since 		17/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA05(aRot)

AADD( aRot, { OemToAnsi("Substituição Aprovador")  ,"U_ASCOMA06", 0 , 4, 0, nil} )
AADD( aRot, { OemToAnsi("Excluir Subst. Aprovador"),"U_ASCOMA07", 0 , 4, 0, nil} )

RETURN(aRot)