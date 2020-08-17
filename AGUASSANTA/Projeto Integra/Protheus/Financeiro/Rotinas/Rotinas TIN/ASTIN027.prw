#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"


//-------------------------------------------------------------------
/*/{Protheus.doc} ASTIN027 
Chamado pelo PE F040BLQ
Exclui otitulo parcializado e bordero.
@return		Nenhum			
@author		Nivia Ferreira
@since		07/03/2017
@version	12
/*/
//-------------------------------------------------------------------
User Function ASTIN027() //F0102007()
Local cRet	:= .T.

	//Negociação
	cRet := u_ASTIN023() //u_F0102003()
		
	//Parcialização
	IF	cRet
		cRet := u_ASTIN032() //u_F0103002()
	EndIf	
			
	//Bordero

	IF	cRet .And. !EMPTY(SE1->E1_NUMBOR) .And. !Inclui .And. !Altera
		dbselectarea("SEA")
		dbsetorder(1)
		If 	dbseek(xFilial("SEA")+ SE1->E1_NUMBOR+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
			RecLock("SEA",.F.)
			SEA->(DbDelete())
			SEA->(MsUnlock())
		EndIf
		
		dbselectarea("SK1")
		dbsetorder(1)
		If 	dbseek(xFilial("SK1")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)
			RecLock("SK1",.F.)
			SK1->(DbDelete())
			SK1->(MsUnlock())
		EndIf

		Reclock("SE1", .F.)
		SE1->E1_SITUACA  := '0' 
		SE1->E1_NUMBOR   := ''
		SE1->E1_NUMBCO   := ''
		SE1->(msunlock())
	EndIF

Return(cRet)



