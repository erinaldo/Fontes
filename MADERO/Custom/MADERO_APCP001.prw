#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} APCP01SP
//TODO funcção para validar alteração de quantidades com a quantidade separada
@author Mario L. B. Faria
@since 25/06/2018
@version 1.0
@return lRet, lógico, continua a ou não o processo
@param cOP, characters, Codigo da OP
@param cCodPrd, characters, Codigo do Produto
@param cLote, characters, Numero do lote
@param nQtd, numeric, Quantidade
/*/
User Function APCP01SP(cOP,cCodPrd,cLote,nQtd)
Local lRet		:= .T.
	
	If nQtd < U_A10001GP(cOP,cCodPrd,cLote) 
		Aviso("Separação","A quantidade informada é menor que a quantidade já separada.",{'Sair'},1)
		lRet := .F.
	EndIf
	
Return lRet