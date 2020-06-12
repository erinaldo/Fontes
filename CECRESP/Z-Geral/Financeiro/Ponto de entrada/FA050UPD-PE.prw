#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FA050UPD()

Pré valida inclusão alteração e exclusão

O ponto de entrada FA050UPD sera executado antes da entrada nas rotinas 
de Inclusão/ Alteracao/ Exclusao. Utilizado como pre-validacao da 
inclusao / alteracao / exclusao.

@param		Nenhum
@return		lRet	=	.T./.F. - Se retornar .F. a inclusão / alteração / 
						exclusão não terá prosseguimento.
@author 	Fabio Cazarini
@since 		06/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FA050UPD()
	LOCAL lRet	:= .T.

	//-----------------------------------------------------------------------
	// Exclusão: 	Se aprovado, aviso que a aprovação foi concluída e 
	// 				solicitação de confirmação
	// Alteração:	Não será permitido alteração título que:
	// 				I = a primeira aprovação já foi efetuada
	// 				A = título aprovado
	// 				R = título reprovado
	//-----------------------------------------------------------------------
	lRet := U_ASFINA09()
	
RETURN lRet