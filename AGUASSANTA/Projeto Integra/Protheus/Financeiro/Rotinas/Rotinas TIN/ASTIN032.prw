#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} ASTIN032 
Chamado pelo PE F040BLQ
Verifica se o titulo pode ser excluido
@return		Nenhum			
@author		Carlos Gorgulho
@since		24/02/2017
@version	12
/*/
//-------------------------------------------------------------------
User Function ASTIN032() //F0103002()

Local lRet 	:= .T.
Local nX   	:= 0
Local lAchou:= .F.

For nX:=1 to len(Procname())
	If "FA040DELET" $ Upper(Procname(nX))
		lAchou := .T.
	EndIf
Next

If 	lAchou
	//Cancelar ou Exclui baixa de Titulo de Origem
	If	SE1->E1_XPARCL  == '1'
		MsgAlert("Titulo não pode ser excluido, existe um titulo parcial vinculado a esse titulo.")
		lRet := .F.
	EndIf
	
	
	//Cancelar ou Exclui baixa de Titulo Parcializado
	IF	lRET
		If	SE1->E1_XPARCL == '1' 
			If	!Empty(SE1->E1_BAIXA) .And. SE1->E1_SALDO <> 0
				MsgAlert("Titulo não pode ser excluido, existe um titulo parcial vinculado a esse título.")
				lRet := .F.
			EndIf	
		EndIf	
	EndIf
	
EndIf

Return(lRet)