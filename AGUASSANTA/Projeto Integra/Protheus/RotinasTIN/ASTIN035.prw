#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} ASTIN035
Chamado pelo PE FA070CA3, verefica se titulo parcializado pode ser cancelado ou excluido.
@return		Nenhum			
@author		Nivia Ferreira
@since		10/03/2017
@version	12
/*/
//-------------------------------------------------------------------
User Function ASTIN035(nOpcx) //F0103005(nOpcx)
Local lRet := .T.

//Cancelar ou Exclui baixa de Titulo Parcializado
If	SE1->E1_XPARCL  == '1' .And. !lF070Auto .And. !ISINCALLSTACK( 'FINA200' )
	IF	nOpcx == 5	
		MsgAlert("Baixa não pode ser cancelada. Título foi parcializado." )
		lRet := .F.
	EndIf

	IF	nOpcx == 6	
		MsgAlert("Baixa não pode ser excluida. Título foi parcializado." )
		lRet := .F.
	EndIf
		
EndIf

//Cancelar ou Exclui baixa de Titulo Parcial
IF	!Empty(SE1->E1_XVINCP) 

	IF	nOpcx == 5 .Or. nOpcx == 6	

		IF	nOpcx == 5 .And. !lF070Auto
			MsgAlert("Baixa não pode ser cancelada, titulo parcial.")
			lRet := .F.
		ElseIF	nOpcx == 6 .And. !lF070Auto
			MsgAlert("Titulo não pode ser excluido, titulo parcial.")
			lRet := .F.
		EndIf		
		
	EndIf

EndIf


Return(lRet)



