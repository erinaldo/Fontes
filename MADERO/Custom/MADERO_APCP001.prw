#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} APCP01SP
//TODO func��o para validar altera��o de quantidades com a quantidade separada
@author Mario L. B. Faria
@since 25/06/2018
@version 1.0
@return lRet, l�gico, continua a ou n�o o processo
@param cOP, characters, Codigo da OP
@param cCodPrd, characters, Codigo do Produto
@param cLote, characters, Numero do lote
@param nQtd, numeric, Quantidade
/*/
User Function APCP01SP(cOP,cCodPrd,cLote,nQtd)
Local lRet		:= .T.
	
	If nQtd < U_A10001GP(cOP,cCodPrd,cLote) 
		Aviso("Separa��o","A quantidade informada � menor que a quantidade j� separada.",{'Sair'},1)
		lRet := .F.
	EndIf
	
Return lRet