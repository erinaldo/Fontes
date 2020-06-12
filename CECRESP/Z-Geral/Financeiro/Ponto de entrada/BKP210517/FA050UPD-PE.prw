#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} FA050UPD()

Pr� valida inclus�o altera��o e exclus�o

O ponto de entrada FA050UPD sera executado antes da entrada nas rotinas 
de Inclus�o/ Alteracao/ Exclusao. Utilizado como pre-validacao da 
inclusao / alteracao / exclusao.

@param		Nenhum
@return		lRet	=	.T./.F. - Se retornar .F. a inclus�o / altera��o / 
						exclus�o n�o ter� prosseguimento.
@author 	Fabio Cazarini
@since 		06/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION FA050UPD()
	LOCAL lRet	:= .T.

	//-----------------------------------------------------------------------
	// Exclus�o: 	Se aprovado, aviso que a aprova��o foi conclu�da e 
	// 				solicita��o de confirma��o
	// Altera��o:	N�o ser� permitido altera��o t�tulo que:
	// 				I = a primeira aprova��o j� foi efetuada
	// 				A = t�tulo aprovado
	// 				R = t�tulo reprovado
	//-----------------------------------------------------------------------
	lRet := U_ASFINA09()
	
RETURN lRet