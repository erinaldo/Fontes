#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
//-------------------------------------------------------------------
/*/{Protheus.doc} ASTIN024
Chamado pelo PE FA070TIT
Verifica se o titulo pode ser baixado
@return		Nenhum			
@author		Nivia Ferreira
@since		23/02/2017
@version	12
/*/
//-------------------------------------------------------------------
User Function ASTIN024() //F0102004()

Local lRet 		:= .T.

	//Titulo Renegociado - Aglutinador
	IF	SE1->E1_XAGLUT == '1' .And. Empty(SE1->E1_XTITAGL) .And. !lF070Auto .And. !ISINCALLSTACK( 'FINA200' )
		
		//Nao e permitido baixa parcial
		IF	NVALREC <> SE1->E1_SALDO
			MsgAlert("Baixa do Titulo Renegociado não pode ser parcial.")
			lRet := .F.
		EndIf
		
		//Somente baixa "Normal"
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

Return(lRet)



