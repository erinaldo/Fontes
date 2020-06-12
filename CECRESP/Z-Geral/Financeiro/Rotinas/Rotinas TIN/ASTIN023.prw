#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} ASTIN023
Chamado pelo PE F040BLQ
Verifica se o titulo pode ser excluido
@return		Nenhum			
@author		Nivia Ferreira
@since		23/02/2017
@version	12
/*/
//-------------------------------------------------------------------
User Function ASTIN023() //F0102003()
Local lRet 		:= .T.
Local nX   		:= 0
Local lAchou	:= .F.

For nX:=1 to len(Procname())
	if "FA040DELET" $ Upper(Procname(nX))
		lAchou := .T.
	EndIf
Next

If 	lAchou
	//Cancelar ou Exclui baixa de Titulo de Origem
	IF	SE1->E1_XAGLUT  == '1' .And. !Empty(SE1->E1_XTITAGL)
		MsgAlert("Titulo não pode ser excluido, foi renegociado.")
		lRet := .F.
	EndIf
	
	
	//Cancelar ou Exclui baixa de Titulo Aglutinado
	IF	SE1->E1_XAGLUT == '1' .And. Empty(SE1->E1_XTITAGL)
		IF	!Empty(SE1->E1_BAIXA) .And. SE1->E1_SALDO <> 0
			MsgAlert("Titulo não pode ser excluido, foi renegociado.")
			lRet := .F.
		EndIf	
	EndIf
	
EndIf

Return(lRet)
