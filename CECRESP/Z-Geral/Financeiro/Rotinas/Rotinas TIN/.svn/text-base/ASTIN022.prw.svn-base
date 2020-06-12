#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} ASTIN022
Chamado pelo PE FA070CA3, verefica se titulo pode ser cancelado ou excluido.
@return		Nenhum			
@author		Nivia Ferreira
@since		23/02/2017
@version	12
/*/
//-------------------------------------------------------------------
User Function ASTIN022(nOpcx) //F0102002(nOpcx)
Local lRet := .T.

//Cancelar ou Exclui baixa de Titulo de Origem
IF	SE1->E1_XAGLUT  == '1' .And. !Empty(SE1->E1_XTITAGL) .And. !lF070Auto .And. !ISINCALLSTACK( 'FINA200' )
	IF	nOpcx == 5	
		MsgAlert("Baixa não pode ser cancelada. Título foi renegociado." )
		lRet := .F.
	EndIf

	IF	nOpcx == 6	
		MsgAlert("Baixa não pode ser excluida. Título foi renegociado." )
		lRet := .F.
	EndIf
		
EndIf

//Cancelar ou Exclui baixa de Titulo Aglutinado
IF	SE1->E1_XAGLUT == '1' .And. Empty(SE1->E1_XTITAGL)

	IF	nOpcx == 5 .Or. nOpcx == 6	

		IF	!Empty(SE1->E1_BAIXA) .And. !lF070Auto
			IF	nOpcx == 5
				MsgAlert("Baixa não pode ser cancelada, foi renegociada.")
			Else
				MsgAlert("Titulo não pode ser excluido, foi renegociado.")
			EndIf		
			lRet := .F.
		EndIf	

	EndIf

EndIf


Return(lRet)



