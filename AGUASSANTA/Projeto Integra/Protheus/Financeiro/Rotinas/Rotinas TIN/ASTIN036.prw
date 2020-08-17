#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} ASTIN036
Chamado pelo PE FA070TIT
Verifica se o titulo pode ser baixado
@return		Nenhum			
@author		Nivia Ferreira
@since		10/03/2017
@version	12
/*/
//-------------------------------------------------------------------
User Function ASTIN036() //F0103006()

Local lRet 		:= .T.

	//Titulo Parcializado
	If !Empty(SE1->E1_XVINCP) .And. !lF070Auto .And. !ISINCALLSTACK( 'FINA200' )
		
		//Nao e permitido baixa parcial
		IF	NVALREC <> SE1->E1_SALDO
			MsgAlert("Baixa do Titulo Parcializado não pode ser parcial.")
			lRet := .F.
		EndIf
		
		//Somente baixa "Renegocia"
		IF	CMOTBX <> 'RENEGOCIA'
			MsgAlert("Baixa somente por REN(Renegociação)")
			lRet := .F.
		EndIf

		IF	lRet 
			Reclock("SE1", .F.)
			SE1->E1_SITUACA  := '0' 
			SE1->(msunlock())
		EndIf

	EndIf
	
	IF	SE1->E1_XPARCL == '1' .And. !lF070Auto
		MsgAlert("Titulo não pode ser baixado. Titulo foi parcializado.")
		lRet := .F.
	EndIf
    
Return(lRet)
